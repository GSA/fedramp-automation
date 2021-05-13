#!/usr/bin/env bash

tidy \
    -config .tidyrc \
    -modify \
    ./src/*.sch \
    ./test/*.xspec
