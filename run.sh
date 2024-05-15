#! /bin/sh
docker run -v ./binaries:/pwn/binaries --name pwn_test --cap-add SYS_PTRACE --security-opt seccomp:unconfined -p 23946:23946 hah4/pwndocker:latest
