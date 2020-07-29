# Developers Guide

This repository is intended to contain testing and development utilities as well as library code for use with golang. To run tests and build any executables (non at present) type 'make' in top level directory of the repository. This will also install any software you need on your workstation.

## Setup

clone into $GOPATH/src/github.com/paulcarlton-ww/go-utils:

    mkdir -p $GOPATH/src/github.com/paulcarlton-ww
    cd $GOPATH/src/github.com/paulcarlton-ww
    git clone git@github.com:paulcarlton-ww/go-utils.git
    cd go-utils

This project requires the following software:

    golangci-lint --version = 1.19.1
    golang version = 1.13.1
    godocdown version = head

You can install these in the project bin directory using the 'setup.sh' script:

    . bin/env.sh
    setup.sh

The setup.sh script can safely be run at any time. It installs the required software in the $GOPATH/bin/`<project-org>`/`<project-name>` directory, where `<project-org>` is the git organisation name and `<project-name>` is the git respository name, i.e. `paulcarlton-ww`/`go-utils`

## Development

The Makefile in the project's top level directory will compile, build and test all components.

    make check build

To run the build and test in a docker container, type:

    make

If changes are made to go source imports you may need to perform a go mod vendor, type:

    make gomod-update


