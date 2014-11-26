#!/bin/bash

EXPECTEDARGS=3
if [ $# -lt $EXPECTEDARGS ]; then
    echo "Usage: $0 <BRANCH> <NUMBER OF MASTER MACHINES> <NUMBER OF MINION MACHINES>"
    exit 0
fi

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BRANCH=$1
MASTER_COUNT=$2
MINION_COUNT=$3

result=`docker build --rm -t setup_kubernetes:$BRANCH $DIR/setup_kubernetes/.`
echo "$result"

echo ""
echo "=========================================================="
echo ""

build_status=`echo $result | grep "Successfully built"`

if [ "$build_status" ] ; then
    docker run -v /tmp:/units -v $DIR/setup_kubernetes/unit_templates:/templates setup_kubernetes:$BRANCH --master_count=$MASTER_COUNT --minion_count=$MINION_COUNT
fi
