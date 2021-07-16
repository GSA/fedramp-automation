#!/usr/bin/env bash

tidy \
    -config .tidyrc \
    -modify \
    ./rules/*.sch \
    ./test/*.xspec
