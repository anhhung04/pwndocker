#!/usr/bin/env python3
from pwn import *
{bindings}
context.binary = {bin_name}
context.arch = {bin_name}.arch
context.log_level = "debug" if (args.D or args.G) else "info"
context.terminal = ["tmux", "splitw", "-h", "-p", "65"]
slog = lambda n, m: success(n + ": " + hex(m))

io = process(executable={bin_name}.path)
# io = remote("localhost", 1337)
if args.G: io = gdb.debug([exe.path],gdbscript="")

io.interactive()
