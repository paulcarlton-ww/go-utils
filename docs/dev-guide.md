# Developers Guide

This repository is intended to contain testing and development utilities as well as library code for use
with golang and python. To run tests and build any executables (non at present) type 'make' in top level
directory of the repository. This will also install any software you need on your workstation.

## Setup

clone into $GOPATH/src/github.com/paul-carlton/go-utils:

    cd $GOPATH/src/github.com/paul-carlton/go-utils
    git clone git@github.com:paul-carlton/go-utils.git
    cd go-utils

Optionally install required software versions in project's bin directory:

    . bin/env.sh
    setup.sh

This project requires the following software:

    golangci-lint --version = 1.19.1
    golang version = 1.13.1
    godocdown version = head

You can install these in the project bin directory using the 'setup.sh' script:

    . bin/env.sh
    setup.sh

The setup.sh script can safely be run at any time. It installs the required software in the <project-dir>bin/local.

## Development

The Makefile in the project's top level directory will compile, build and test all components.

    make check build

To run the build and test in a docker container, type:

    make

If changes are made to go source imports you may need to perform a go mod vendor, type:

    make gomod-update


