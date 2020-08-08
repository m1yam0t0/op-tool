#!/usr/bin/env bash

set -e

PROGDIR=$(dirname $0)
PROGNAME=$(basename $0)

# load utils
. ${PROGDIR}/utils/utils.sh

usage () {
    cat <<EOF
${PROGNAME} - 1Password CLI でいい感じにするやつ

Usage:
    ${PROGNAME} [<options>]

Commands:
    get                 Get password from 1Password Vault
    session             Restore op session

Options:
    -h, --help          Show this message
    -v, --version       Print the ${PROGNAME} version
EOF
}

# parse arguments
case $1 in
    "-h" | "--help")
        usage
        exit 0
        ;;
    "-v" | "--version")
        echo "${VERSION}"
        exit 0
        ;;
    "get")
        op_get "${@:2}"
        ;;
    "session")
        op_session "${@:2}"
        ;;
    "*")
        usage
        exit 1
        ;;
esac
