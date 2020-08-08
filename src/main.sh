#--------------------------------------------------
# main function
#--------------------------------------------------

usage () {
    cat <<EOF
${PROGNAME} - make it convenient to use 1Password CLI

Usage:
    ${PROGNAME} <command> [<args>]
    ${PROGNAME} -h | --help
    ${PROGNAME} -v | --version

Commands:
    get                 Get password from 1Password Vault
    session             Restore op session

Options:
    -h, --help          Show this message
    -v, --version       Print the op-tool version
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
