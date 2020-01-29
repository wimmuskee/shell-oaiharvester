#!/bin/bash

source testlib.sh
source ../libs/common.sh
source ../libs/functions.sh

TESTCLASS="functions"

function testNotice {
	QUIET="true"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(notice "starting test")" ""
	QUIET="false"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(notice "starting test")" "starting test" 

}

# call the functions
testNotice
