#!/usr/bin/env bash

# source files
SRC_DIR=./src
SRC_FILES=("session.sh" "get.sh" "env.sh" "main.sh")

# program name & target directory
PROGNAME="op-tool"
PROGDIR="./bin"
PROGPATH="${PROGDIR}/${PROGNAME}"

if [ ! -d ${PROGDIR} ];
then
    mkdir -p ${PROGDIR}
fi

# create script header
cat << EOF > ${PROGPATH}
#!/usr/bin/env bash

set -e

VERSION=$(cat VERSION)
PROGNAME=${PROGNAME}
EOF

# copy src to script
for s in ${SRC_FILES[@]};
do
    echo >> ${PROGPATH}
    cat ${SRC_DIR}/${s} >> ${PROGPATH}
done

chmod +x ${PROGPATH}
