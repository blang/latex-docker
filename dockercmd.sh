#!/bin/sh
exec docker run --rm -i --user="$(id -u):$(id -g)" -v $PWD:/data blang/latex "$@"
