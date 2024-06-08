#!/usr/bin/env python3
from pwn import *
{bindings}
context.arch = {bin_name}.arch
context.binary = {bin_name}
context.log_level = 'debug' if (args.DEBUG or args.GDB) else 'info'
def slog(n, m): return success(': '.join([n, hex(m)]))
s = lambda x: r.send(x) if isinstance(x, bytes) else r.send(str(x).encode())
sl = lambda x: r.sendline(x) if isinstance(x, bytes) else r.sendline(str(x).encode())
sa = lambda a, x: r.sendafter(str(a), x) if isinstance(x, bytes) else r.sendafter(str(a), x)
sla = lambda a, x: r.sendlineafter(str(a), x) if isinstance(x, bytes) else r.sendlineafter(str(a), x)
def conn():
    if args.LOCAL or args.GDB:
        r = process({proc_args})
        if args.GDB:
            gdb.attach(target=r, gdbscript=GDB_SCRIPT)
    else:
        r = remote(*REMOTE)
    return r

REMOTE = ("localhost", 1337)
GDB_SCRIPT = """

""".strip()

r = conn()



r.interactive()
