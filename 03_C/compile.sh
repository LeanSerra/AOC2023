#!/bin/bash

case $1 in
    "1")
    gcc -Wall -ggdb "01_C.c" -o "01_C.out" && ./01_C.out input
    ;;
    "2")
    gcc -Wall -ggdb "02_C.c" -o "02_C.out" && ./02_C.out input
esac