#!/usr/bin/env python
"""Battery status monitor

Usage:
    duobattery.py [-f | --follow] <name>...
    duobattery.py -h | --help
    duobattery.py -v | --version

Options:
    -f --follow     Follow mode

    -h --help       Show this screen
    -v --version    Show version
"""

import os
import sys
import time
from abc import ABC, abstractmethod
from enum import Enum
# from errno import ENOENT
from operator import attrgetter
from pathlib import Path
from signal import SIGUSR1, Signals, signal

VERSION: str = '1.0.0'

#
# class BatteryAttributeError(FileNotFoundError):

#     def __init__(self, attr: str) -> None:
#         super().__init__(ENOENT, 'No such attribute', attr)


class BatteryStatus(Enum):
    NA = 'n/a'
    CHARGING = 'Charging'
    DISCHARGING = 'Discharging'
    NOT_CHARGING = 'Not charging'


class AbstractBattery(ABC):
    # path of power_supply (udev kernel subsystem)
    SUBSYS_PATH = '/sys/class/power_supply'

    # 󱉝󱟨󱃌󰂃󰂑
    # 󱉞󱟩󱃍
    # icon label fractions
    ICON_NA = '󱉞'

    # capacity label fractions
    CAPACITY_NA = 'n/a'
    CAPACITY_FULL = 'Full'
    CAPACITY_UNIT = '%'

    # time label fractions
    TIME_LEFT_NA = '--:--'

    # power label fractions
    POWER_UNIT = 'W'
    CHARGE_SIGN = '∿'
    DISCHARGE_SIGN = '𝌁'
    AC_SIGN = '󱒀'

    # load config from env
    ICONS: list[str] = os.getenv('DUOBATTERY_ICONS', '    ').split()
    CHARGE_ICONS: list[str] = os.getenv('DUOBATTERY_CHARGE_ICONS', '').split() or ICONS # yapf: disable
    FULL_AT: int = int(os.getenv('DUOBATTERY_FULL_AT', 99))
    LOW_AT: int = int(os.getenv('DUOBATTERY_LOW_AT', 5))
    LOW_COLOR: str | None = os.getenv('DUOBATTERY_LOW_COLOR')

    def __init__(self):
        # default value
        self._status, self._power_now = BatteryStatus.NA, 0
        self._capacity, self._energy_now, self._energy_full = 0, 0, 0

    @property
    def status(self) -> BatteryStatus:
        return self._status

    @property
    def power_now(self) -> int:
        """μW"""
        return self._power_now

    @property
    def capacity(self) -> int:
        """%"""
        return self._capacity

    @property
    def energy_now(self) -> int:
        """μWh"""
        return self._energy_now

    @property
    def energy_full(self) -> int:
        """μWh"""
        return self._energy_full

    @property
    @abstractmethod
    def energy_full_choked(self) -> int:
        """μWh"""
        raise NotImplementedError

    @abstractmethod
    def update(self):
        raise NotImplementedError

    def __str__(self) -> str:
        return '{} {} {}{}'.format(
            self._label_icon,
            self._label_capacity,
            self._label_time_left,
            self._label_power_now,
        )

    @property
    def _label_icon(self) -> str:
        if self.status is BatteryStatus.NA:
            return self.ICON_NA

        # choose icon set
        if self.status is BatteryStatus.CHARGING:
            icons = self.CHARGE_ICONS
        else:
            icons = self.ICONS

        # select the icon
        if self.capacity <= self.LOW_AT:
            icon = icons[0]
            if self.LOW_COLOR:
                icon = f'%{{F{self.LOW_COLOR}}}{icon}%{{F-}}'
        else:
            icon = icons[-1]
            steps = len(icons) - 2
            step = (100 - self.LOW_AT) / steps
            for i in range(1, steps + 1):
                if self.capacity < self.LOW_AT + i * step:
                    icon = icons[i]
                    break

        return icon

    @property
    @abstractmethod
    def _label_capacity(self) -> str:
        raise NotImplementedError

    @property
    def _label_time_left(self) -> str:
        # calculate time left
        if not self.power_now:
            return self.TIME_LEFT_NA
        elif self.status is BatteryStatus.CHARGING:
            time_left = 3600 * (self.energy_full_choked -
                                self.energy_now) / self.power_now
        elif self.status is BatteryStatus.DISCHARGING:
            time_left = 3600 * self.energy_now / self.power_now
        else:
            return self.TIME_LEFT_NA

        return time.strftime('%-H:%M', time.gmtime(time_left))

    @property
    def _label_power_now(self) -> str:
        # choose charging/discharging sign
        if self.status is BatteryStatus.CHARGING:
            sign = self.CHARGE_SIGN
        elif self.status is BatteryStatus.DISCHARGING:
            sign = self.DISCHARGE_SIGN
        else:
            return self.AC_SIGN

        watts = self.power_now / 1_000_000
        power = f'{watts:.2f}'[:3] if watts < 1000 else int(watts)
        return f'{sign}{power}{self.POWER_UNIT}'


class Battery(AbstractBattery):

    def __init__(self, name: str):
        self._name = name
        self._devpath = Path(self.SUBSYS_PATH) / name
        # if not self._devpath.exists():
        #     raise FileNotFoundError(ENOENT, 'No such directory', self._devpath)

        self._attr_status = self._devpath / 'status'
        self._attr_power_now = self._devpath / 'power_now'
        self._attr_capacity = self._devpath / 'capacity'
        self._attr_energy_now = self._devpath / 'energy_now'
        self._attr_energy_full = self._devpath / 'energy_full'
        self._attr_charge_stop_threshold = self._devpath / 'charge_stop_threshold'

        # default value
        self._charge_stop_threshold = 100

        # DON'T forget init parent class
        super().__init__()

        # update state for the very first time
        self.update()

    @property
    def name(self) -> str:
        return self._name

    @property
    def charge_stop_threshold(self) -> int:
        """%"""
        return self._charge_stop_threshold

    @property
    def energy_full_choked(self) -> int:
        return self.energy_full * self.charge_stop_threshold // 100

    def update(self):
        if not (self._devpath.exists() and self._attr_status.exists()):
            self._status = BatteryStatus.NA
            return

        self._status = BatteryStatus(self._attr_status.read_text().rstrip())
        self._power_now = int(self._attr_power_now.read_text())
        self._capacity = int(self._attr_capacity.read_text())
        self._energy_now = int(self._attr_energy_now.read_text())
        self._energy_full = int(self._attr_energy_full.read_text())
        self._charge_stop_threshold = int(self._attr_charge_stop_threshold.read_text())  # yapf: disable

    @property
    def _label_capacity(self) -> str:
        if self.status is BatteryStatus.NA:
            label = self.CAPACITY_NA
        elif self.capacity >= self.FULL_AT:
            label = self.CAPACITY_FULL
        else:
            label = f'{self.capacity}{self.CAPACITY_UNIT}'
            if self.capacity <= self.LOW_AT and self.LOW_COLOR:
                label = f'%{{F{self.LOW_COLOR}}}{label}%{{F-}}'

        return label


class DuoBattery(AbstractBattery):

    # capacity label fractions
    CAPACITY_PLUS = '+'

    def __init__(self, *names: str):
        self._batteries = list(map(Battery, names))

        # DON'T forget init parent class
        super().__init__()

        # update state for the very first time
        self.update()

    @property
    def batteries(self) -> list[Battery]:
        return self._batteries

    @property
    def energy_full_choked(self) -> int:
        return sum(map(attrgetter('energy_full_choked'), self.batteries))

    def update(self):
        status, power_now, energy_now, energy_full = BatteryStatus.NA, 0, 0, 0

        # Battery Status Assertions
        # | BAT0         | BAT1         | RESULT       |
        # |--------------+--------------+--------------|
        # | na           | na           | na           |
        # | charging     | na           | charging     |
        # | discharging  | na           | discharging  |
        # | not_charging | na           | not_charging |
        # |--------------+--------------+--------------|
        # | na           | charging     | charging     |
        # | not_charging | charging     | charging     |
        # |--------------+--------------+--------------|
        # | na           | discharging  | discharging  |
        # | not_charging | discharging  | discharging  |
        # |--------------+--------------+--------------|
        # | na           | not_charging | not_charging |
        # | charging     | not_charging | charging     |
        # | discharging  | not_charging | discharging  |
        # | not_charging | not_charging | not_charging |
        #
        for batt in reversed(self.batteries):
            batt.update()

            # determine status
            # yapf: disable
            if (batt.status is BatteryStatus.CHARGING or
                batt.status is BatteryStatus.DISCHARGING or
                (batt.status is BatteryStatus.NOT_CHARGING
                 and status is BatteryStatus.NA)):
                # yapf: enable
                status = batt.status
                power_now = batt.power_now

            # accumulate energy
            if batt.status is not BatteryStatus.NA:
                energy_now += batt.energy_now
                energy_full += batt.energy_full

        self._status = status
        self._power_now = power_now
        self._capacity = energy_full and 100 * energy_now // energy_full
        self._energy_now = energy_now
        self._energy_full = energy_full

    @property
    def _label_capacity(self) -> str:
        return self.CAPACITY_PLUS.join(
            map(attrgetter('_label_capacity'), self.batteries))


def main():
    NAMES: list[str] = os.getenv('DUOBATTERY_NAMES', '').split()
    args = docopt(__doc__,
                  argv=(sys.argv[1:] + NAMES if NAMES else None),
                  version=VERSION)

    arg_len = len(args['<name>']) - len(NAMES)
    names = (args['<name>'][:arg_len] if arg_len else args['<name>'])
    batt = DuoBattery(*names)
    follow = args['--follow']
    query_battery(batt, follow)

    # for b in batteries:
    #     print(f'{b.status.value}'
    #           f' power_now: {b.power_now} μW'
    #           f' capacity: {b.capacity} %'
    #           f' energy_now: {b.energy_now} μWh'
    #           f' energy_full:{b.energy_full} μWh'
    #           '\n'
    #           f' charge_stop_threshold: {b.charge_stop_threshold} %')


def query_battery(battery: AbstractBattery, follow: bool = False):
    SLEEP: int = int(os.getenv('DUOBATTERY_SLEEP', 1))

    if follow:

        def handler(signum, frame):
            signame = Signals(signum).name
            raise InterruptedError(signame)

        signal(SIGUSR1, handler)
        while True:
            try:
                print(battery, flush=True)
                time.sleep(SLEEP)
                battery.update()
            except InterruptedError:
                continue
    else:
        print(battery)


if __name__ == '__main__':
    from docopt import docopt

    main()
