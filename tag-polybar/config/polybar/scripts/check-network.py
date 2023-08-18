#!/usr/bin/env python

import os
import socket
import time

CONN_LABEL: str = os.getenv('PB_CHECKNET_CONNECTED', 'Online')
DISCONN_LABEL: str = os.getenv('PB_CHECKNET_DISCONNECTED', 'Offline')
CONN_SLEEP: int = int(os.getenv('PB_CHECKNET_CONNECTED_SLEEP', 25))
DISCONN_SLEEP: int = int(os.getenv('PB_CHECKNET_DISCONNECTED_SLEEP', 5))

HOSTS: list[str] = [
    # 'google.com',
    'github.com',
    'sourceforge.net',
    'bitbucket.org',
    'archlinux.com',
    'aliyun.com',
    'baidu.com',
]


def main():
    while True:
        if probe_net():
            print(CONN_LABEL, flush=True)
            time.sleep(CONN_SLEEP)
        else:
            print(DISCONN_LABEL, flush=True)
            time.sleep(DISCONN_SLEEP)


def probe_net() -> bool:
    for host in HOSTS:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(1)
            s.connect((host, 80))
            return True
        except:
            continue
        finally:
            s.close()
    return False


if __name__ == '__main__':
    main()
