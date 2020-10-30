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

function testNoArgs {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(./oaiharvester 2>&1)" "Error: No repository id provided"
}

function testWrongArg {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(./oaiharvester -x 2>&1)" "Error: ./oaiharvester: Unknown command parameter"
}

# call the functions
testList
testVersion
testNoArgs
testWrongArg

# and change back to test dir for other tests
cd test
