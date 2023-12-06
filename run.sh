#!/bin/bash

BIN=${BIN:-./ready-to-run/microbench-test.bin}

./build/emu --image=${BIN} --diff=ready-to-run/riscv64-nemu-interpreter-so -e 0 --force-dump-result --no-snapshot --no-diff "$@"
