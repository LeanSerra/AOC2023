#!/bin/bash

case $1 in
    "1")
    ocamlc -g -o "01_OCaml.out" "01_OCaml.ml" && ./01_OCaml.out smallinput
    ;;
    "2")
    ocamlc -g -o "02_OCaml.out" "02_OCaml.ml" && ./02_OCaml.out smallinput
esac

rm *.cmi *.cmo