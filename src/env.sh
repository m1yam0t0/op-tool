#--------------------------------------------------
# Variables
#--------------------------------------------------
# session
OP_SESSIONDIR=${XDG_CACHE_HOME:-~/.cache}/op
OP_SESSIONFILE=${OP_SESSIONDIR}/session

# 1Password CLI with session
OP_CMD="op --session=$(get_op_session)"
