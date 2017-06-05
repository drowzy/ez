#!/bin/bash

# Generates documentation
> docs.tmp
while read src; do
    foo=$(./ez.native -q "$src")
    out=$(echo -e "Ez: \n$src\nElastic json\n$foo")
    echo "$out" >> docs.tmp
done < "$1"
