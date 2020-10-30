#!/bin/bash

# change dir to app root because we're testing the command
cd ..
source test/testlib.sh

TESTCLASS="command"

function testList {
	assertPattern "${TESTCLASS}/${FUNCNAME[0]}/1" "$(./oaiharvester -c config.example.xml -l)" "example\.org"
}

function testVersion {
	assertPattern "${TESTCLASS}/${FUNCNAME[0]}/1" "$(./oaiharvester -v)" "^[0-9]\.[0-9]\.[0-9]$"
}

# call the functions
testList
testVersion

# and change back to test dir for other tests
cd test
