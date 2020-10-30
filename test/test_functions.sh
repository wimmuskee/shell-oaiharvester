#!/bin/bash

source testlib.sh
source ../libs/common.sh
source ../libs/functions.sh

TESTCLASS="functions"

INSTALLDIR="../libs"
CONFIGFILE="../config.example.xml"

function testNotice {
	QUIET="true"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(notice "starting test")" ""
	QUIET="false"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(notice "starting test")" "starting test" 
}

function testGetGenericConfig {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getGenericConfig temppath)" "/tmp/oaiharvester"
}

# call the functions
testNotice
testGetGenericConfig
