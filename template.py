#!/usr/bin/env python3
from pwn import *
import sys

{bindings}

REMOTE = ("localhost", 1337)
GDB_SCRIPT = """"""

context.arch = {bin_name}.arch
context.binary = {bin_name}


def conn():
    global {bin_name}
    if args.LOCAL or args.GDB:
        r = process({proc_args})
        if args.GDB:
            gdb.attach(target=r, gdbscript=GDB_SCRIPT)
            context.terminal = ['tmux', 'splitw', '-h']
    else:
        r = remote(*REMOTE)
    return r


if __name__ == "__main__":
    if args.DEBUG or args.GDB:
        context.log_level = 'debug'
    r = conn()

    # pwn here

    r.interactive()
