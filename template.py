#!/usr/bin/env python3
from pwn import *
{bindings}
context.arch = {bin_name}.arch
context.binary = {bin_name}
context.log_level = 'debug' if (args.DEBUG or args.GDB) else 'info'
def slog(n, m): return success(': '.join([n, hex(m)]))
def plog(*a): return log.info("\n=> ".join(map(str, a)))
s = lambda x: io.send(x) if isinstance(x, bytes) else io.send(str(x).encode())
sl = lambda x: io.sendline(x) if isinstance(x, bytes) else io.sendline(str(x).encode())
sa = lambda a, x: io.sendafter(str(a), x) if isinstance(x, bytes) else io.sendafter(str(a), x)
sla = lambda a, x: io.sendlineafter(str(a), x) if isinstance(x, bytes) else io.sendlineafter(str(a), x)
def conn(argv=[], *a, **kw):
    if args.LOCAL:
        io = process({proc_args} + argv, *a, **kw)
    elif args.GDB:
        io = gdb.debug({proc_args} + argv, gdbscript=GDB_SCRIPT, *a, **kw)
    else:
        io = remote(*REMOTE)
    return io

REMOTE = ("localhost", 1337)
GDB_SCRIPT = """
continue
""".strip().format(**locals())

io = conn()


io.interactive()
