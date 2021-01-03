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

function testGetProcessTimeMac {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getProcessTime 1609667471N 1609667477N)" "6"
}

function testGetProcessTimeLinux {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getProcessTime 1609667602082180818 1609667607322857516)" "5.240"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(getProcessTime 1609667667874348012 1609667668346505924)" ".472"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getProcessTime 1609667667874348012 1609667668344505924)" ".470"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getProcessTime 1609667667874348012 1609667667944505924)" ".070"
}

# call the functions
testNotice
testGetGenericConfig
testGetProcessTimeLinux
testGetProcessTimeMac
