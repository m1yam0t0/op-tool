#--------------------------------------------------
# Get
#--------------------------------------------------

# Select item from list
select_item () {
    ${OP_CMD} list items | jq -r '.[].overview.title' | fzf
}

# Select field from item
select_field () {
    local OP_ITEM=$(${OP_CMD} get item "${OP_ITEM_NAME}" | jq -r '.details')
    local OP_ITEM_SECTION_NUM=$(echo "${OP_ITEM}" | jq -r '.sections | length')
    if [ $(( $(echo ${OP_ITEM_SECTION_NUM}) )) -gt 0 ]; then
        KEY="[.fields[].designation, .sections[].fields[]?.t] | .[]"
    else
        KEY=".fields[].designation"
    fi

    echo "${OP_ITEM}" | jq -r "${KEY} | select (length > 0)" | fzf
}

# Get credential
op_get_item () {
    ${OP_CMD} get item ${OP_ITEM_NAME} --fields "${OP_ITEM_FIELD:-password}" | pbcopy
}

# Get one-time password
op_get_otp () {
    ${OP_CMD} get totp ${OP_ITEM_NAME} | pbcopy
}

# Usage
usage_get () {
    cat <<EOF
${CMDNAME} - Get credential from 1Password

Usage:
    ${CMDNAME} [(-n|--name) <name>] [(-f|--field) <field>] [(-i|--interactive)] [--otp]
    ${CMDNAME} -h | --help
    ${CMDNAME} -v | --version

Options:
    -n, --name          1Password item name
    -f, --field         1Password item fields
    -i, --interactive   Select field interactive
    --otp               Get One-time Password
    -h, --help          Show this message
    -v, --version       Print the ${PROGNAME} version
EOF
}

# Parse arguments
arg_parse_get () {
    for OPT in "$@"
    do
        case $OPT in
            "-h" | "--help")
                usage_get
                exit 0
                ;;
            "-v" | "--version")
                echo "${VERSION}"
                ;;
            "-n" | "--name")
                OP_ITEM_NAME=$2
                shift 2
                ;;
            "-f" | "--field")
                OP_ITEM_FIELD=$2
                shift 2
                ;;
            "-i" | "--interactive")
                INTERACTIVE=1
                shift
                ;;
            "--otp")
                OP_ITEM_FIELD="One-time Password"
                shift
                ;;
        esac
    done
}

# op-tool get
op_get () {
    CMDNAME="${PROGNAME} get"
    arg_parse_get "$@"

    # check op session
    op_session

    # get 1password item by using 1password cli
    if [ -z "${OP_ITEM_NAME}" ]; then
        OP_ITEM_NAME=$(select_item)
    fi

    # get 1password item field interactive
    if [ -z "${OP_ITEM_FIELD}" ] && [ "${INTERACTIVE}" = 1 ]; then
        OP_ITEM_FIELD=$(select_field)
    fi

    # get password from 1password item
    if [ "${OP_ITEM_FIELD}" = "One-time Password" ]; then
        op_get_otp
    else
        op_get_item
    fi
    echo "Copied 1Password item to clipboard. (item=${OP_ITEM_NAME}, field=${OP_ITEM_FIELD:-password})"
}
