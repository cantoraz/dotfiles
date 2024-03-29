#!/usr/bin/env python

import os
import sys
import time
from errno import ENOENT
from pathlib import Path
from signal import SIGUSR1, Signals, signal

VERSION = '1.0.0'


class NotManualError(Exception):

    def __init__(self) -> None:
        super().__init__('not in manual mode')


class NotSupportManualError(Exception):

    def __init__(self) -> None:
        super().__init__('not support manual mode')


class Fan:
    DEFAULT_TUNE_STEP: int = 1000

    # load config from env
    SPEED_AUTO: str = os.getenv('PB_FAN_SPEED_AUTO', 'auto ')
    SPEED_SLOW: str = os.getenv('PB_FAN_SPEED_SLOW', 'slow ')
    SPEED_MIDD: str = os.getenv('PB_FAN_SPEED_MIDD', 'midd ')
    SPEED_FAST: str = os.getenv('PB_FAN_SPEED_FAST', 'fast ')
    SPEED_UNIT: str = os.getenv('PB_FAN_SPEED_UNIT', 'rpm')
    SLEEP: int = int(os.getenv('PB_FAN_SPEED_SLEEP', 1))

    def __init__(self,
                 devpath: str,
                 name: str,
                 *,
                 signal_pid: int | None = None) -> None:
        self._devpath = Path(devpath)
        self._name = name
        self._signal_pid = signal_pid

        # configure fan files

        self._input_file = self.devpath / f'{self.name}_input'
        if not self._input_file.exists():
            raise FileNotFoundError(ENOENT, 'No such file', self._input_file)

        manual_file = self.devpath / f'{self.name}_manual'
        self._manual_file = manual_file if manual_file.exists() else None

        output_file = self.devpath / f'{self.name}_output'
        self._output_file = output_file if output_file.exists() else None

        max_file = self.devpath / f'{self.name}_max'
        self._max_file = max_file if max_file.exists() else None

        min_file = self.devpath / f'{self.name}_min'
        self._min_file = min_file if min_file.exists() else None

    @property
    def devpath(self) -> Path:
        return self._devpath

    @property
    def name(self) -> str:
        return self._name

    @property
    def signal_pid(self) -> int | None:
        return self._signal_pid

    @property
    def speed(self) -> int:
        return int(self._input_file.read_text())

    @property
    def is_manual(self) -> bool | None:
        if (self._manual_file is None or self._output_file is None
                or self._max_file is None or self._min_file is None):
            return None

        return bool(int(self._manual_file.read_text()))

    @property
    def regular_speed(self) -> int | None:
        if self._output_file is None: return None

        return int(self._output_file.read_text())

    @regular_speed.setter
    def regular_speed(self, value: int):
        if self._output_file is None: raise NotSupportManualError()

        self._output_file.write_text(str(value))

    @property
    def max(self) -> int | None:
        if self._max_file is None: return None

        return int(self._max_file.read_text())

    @property
    def min(self) -> int | None:
        if self._min_file is None: return None

        return int(self._min_file.read_text())

    @property
    def status(self) -> str:
        cur_speed = self.speed

        if self.is_manual:
            max_speed = self.max
            min_speed = self.min

            if max_speed is None or min_speed is None:
                raise NotSupportManualError()

            step = (max_speed - min_speed) / 3

            if cur_speed >= max_speed - step:
                prefix = Fan.SPEED_FAST
            elif cur_speed >= min_speed + step:
                prefix = Fan.SPEED_MIDD
            else:
                prefix = Fan.SPEED_SLOW
        else:
            prefix = Fan.SPEED_AUTO

        return f'{prefix}{cur_speed}{Fan.SPEED_UNIT}'

    def query_speed(self, follow: bool = False):
        if follow:

            def handler(signum, frame):
                signame = Signals(signum).name
                raise InterruptedError(signame)

            signal(SIGUSR1, handler)
            while True:
                try:
                    print(self.status, flush=True)
                    time.sleep(Fan.SLEEP)
                except InterruptedError:
                    continue
        else:
            print(self.status, flush=True)

    def toggle_manual(self):
        if self._manual_file is None: raise NotSupportManualError()

        self._manual_file.write_text(str(int(not self.is_manual)))
        if self.signal_pid is not None: self._send_signal(SIGUSR1)

    def speed_up(self, step: int = DEFAULT_TUNE_STEP):
        if not self.is_manual: raise NotManualError()

        cur_speed = self.regular_speed
        max_speed = self.max

        if cur_speed is None or max_speed is None:
            raise NotSupportManualError()
        if cur_speed >= max_speed:
            sys.exit('already at fastest speed')

        new_speed = cur_speed // step * step + step
        self.regular_speed = new_speed if new_speed < max_speed else max_speed

        if self.signal_pid is not None: self._send_signal(SIGUSR1)

    def speed_down(self, step: int = DEFAULT_TUNE_STEP):
        if not self.is_manual: raise NotManualError()

        cur_speed = self.regular_speed
        min_speed = self.min

        if cur_speed is None or min_speed is None:
            raise NotSupportManualError()
        if cur_speed <= min_speed:
            sys.exit('already at slowest speed')

        new_speed = (cur_speed - 1 + step) // step * step - step
        self.regular_speed = new_speed if new_speed > min_speed else min_speed

        if self.signal_pid is not None: self._send_signal(SIGUSR1)

    def _send_signal(self, signum: Signals):
        if self.signal_pid is None: return

        try:
            os.kill(self.signal_pid, 0)
        except (PermissionError, ProcessLookupError):
            pass
        else:
            os.kill(self.signal_pid, signum)


def main():
    # parse arguments
    args = _parse_args()

    try:
        # Invoke the function corresponding to sub-command
        args.func(args)
    except FileNotFoundError as e:
        sys.exit(f'{e.strerror}: {e.filename}')
    except (NotManualError, NotSupportManualError) as e:
        sys.exit(str(e))
    # except KeyboardInterrupt as e:
    #     print(e)
    #     sys.exit(128 + signal.SIGINT)


def _parse_args():
    # main parser
    parser = argparse.ArgumentParser(
        prog=os.path.basename(__file__),
        description='Fan utility to monitor and tuning its speed',
    )
    parser.add_argument('-v', '--version', action='version', version=VERSION)
    parser.add_argument('-d',
                        dest='devpath',
                        required=True,
                        help='fan sysfs dir')
    parser.add_argument('-f', dest='fan_name', required=True, help='fan name')

    # Sub-commands parser ##############################################
    subparsers = parser.add_subparsers(title='commands', required=True)

    # shared parser for `pid' option
    pid_parser = argparse.ArgumentParser(add_help=False)
    pid_parser.add_argument('-p',
                            dest='pid',
                            type=int,
                            help=('PID of anther program '
                                  'to receive SIGUSR1'))

    # Sub-command `query` parser #######################################
    parser_query = subparsers.add_parser('query', help='current fan speed')
    parser_query.add_argument('-f',
                              dest='follow',
                              action='store_true',
                              help='follow mode')
    parser_query.set_defaults(func=_query_speed)

    # Sub-command `toggle` parser ######################################
    parser_toggle = subparsers.add_parser('toggle',
                                          parents=[pid_parser],
                                          help=('toggle the mode of fan '
                                                'between auto and manual'))
    parser_toggle.set_defaults(func=_toggle_manual)

    # Sub-command `up` parser ##########################################
    parser_up = subparsers.add_parser('up',
                                      parents=[pid_parser],
                                      help='increase fan speed')
    parser_up.set_defaults(func=_speed_up)

    # Sub-command `down` parser ########################################
    parser_down = subparsers.add_parser('down',
                                        parents=[pid_parser],
                                        help='decrease fan speed')
    parser_down.set_defaults(func=_speed_down)

    return parser.parse_args()


def _query_speed(args):
    f = Fan(args.devpath, args.fan_name)
    f.query_speed(args.follow)


def _toggle_manual(args):
    f = Fan(args.devpath, args.fan_name, signal_pid=args.pid)
    f.toggle_manual()


def _speed_up(args):
    f = Fan(args.devpath, args.fan_name, signal_pid=args.pid)
    f.speed_up()


def _speed_down(args):
    f = Fan(args.devpath, args.fan_name, signal_pid=args.pid)
    f.speed_down()


if __name__ == '__main__':
    import argparse

    main()
