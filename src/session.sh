#--------------------------------------------------
# Session
#--------------------------------------------------

# Get session id from file
get_op_session () {
    cat ${OP_SESSIONFILE} | head -1 | sed -E 's/^export OP_SESSION_.+="(.*)"/\1/'
}

# Set --session flag to 1Password CLI
set_op_session () {
    OP_CMD="op --session=$(get_op_session)"
}

# Check 1Password CLI session
check_op_session() {
    if [ ! -f ${OP_SESSIONFILE} ]; then
        echo "-1"
    fi

    set +e
    ${OP_CMD} get account > /dev/null
    echo $?
    set -e
}

# Save 1Password CLI session to file
restore_op_session () {
    if [ ! -d ${OP_SESSIONDIR} ] ;then
        mkdir -p ${OP_SESSIONDIR}
    fi
    op signin ${OP_SIGNIN_ADDRESS:-my} > ${OP_SESSIONFILE}
    set_op_session
}

# Usage
usage_session () {
    cat <<EOF
${CMDNAME} - Store 1Password CLI session

Usage:
    ${CMDNAME}
    ${CMDNAME} -h | --help
    ${CMDNAME} -v | --version

Options:
    -h, --help      Show this message
    -v, --version   Print the ${PROGNAME} version
EOF
}

# Parse arguments
arg_parse_session () {
    for OPT in "$@"
    do
        case $OPT in
            "-h" | "--help")
                usage_session
                exit 0
                ;;
            "-v" | "--version")
                echo "${VERSION}"
                ;;
        esac
    done
}

# check op session
op_session () {
    CMDNAME="${PROGNAME} session"
    arg_parse_session "$@"

    if [ ! "$(check_op_session)" = "0" ]; then
        restore_op_session
        echo "op session restored."
    else
        echo "You have already logged in."
    fi
}
