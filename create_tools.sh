#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Fetch external dependencies
git submodule init
git submodule update
# Build trec_eval
cd external/trec_eval
make
cp trec_eval $DIR/bin
cd $DIR
# Build polyfuse
cd external/polyfuse
make
cp polyfuse $DIR/bin
cd $DIR


