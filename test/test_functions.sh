#!/bin/bash

source testlib.sh
source ../libs/common.sh
source ../libs/functions.sh

TESTCLASS="functions"

INSTALLDIR="../libs"
CONFIGFILE="../config.example.xml"
TMP="."

function testNotice {
	QUIET="true"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(notice "starting test")" ""
	QUIET="false"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(notice "starting test")" "starting test" 
}

function testWarning {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(warning "test")" "WARNING: test"
}

function testGetGenericConfig {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getGenericConfig temppath)" "/tmp/oaiharvester"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(getGenericConfig recordpath)" "/var/db/oaiharvester"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getGenericConfig logfile)" "/tmp/oaiharvester-log.csv"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/4" "$(getGenericConfig curlopts)" "--retry 5 --silent --limit-rate 200k --user-agent \"shell-oaiharvester\""
}

function testGetRepositoryConfig {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getRepositoryConfig baseurl repository_id)" "http://example.org/oaiprovider"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(getRepositoryConfig metadataprefix repository_id)" "lom"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getRepositoryConfig set repository_id)" "test"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/4" "$(getRepositoryConfig from repository_id)" "2012-02-29"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/5" "$(getRepositoryConfig until repository_id)" "2012-03-01"
}

function testGetTargetData {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getTargetData record_count oaipage)" "3"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(getTargetData responsedate oaipage)" "2022-02-12T06:07:40Z"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getTargetData format oaipage 1)" "xml"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/4" "$(getTargetData format oaipage 2)" "text"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/5" "$(getTargetData datestamp oaipage 2)" "2022-02-10T21:19:09Z"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/6" "$(getTargetData headerstatus oaipage 3)" "deleted"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/7" "$(getTargetData headerstatus oaipage 2)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/8" "$(getTargetData error_code errorpage)" "cannotDisseminateFormat"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/8" "$(getTargetData error_message errorpage)" "invalid metadataPrefix"
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

function testGetFromArgument {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(getFromArgument 2015-09-30T22:00:00Z YYYY-MM-DD)" "&from=2015-09-30"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(getFromArgument 2015-09-30T22:00:00Z YYYY-MM-DDThh:mm:ssZ)" "&from=2015-09-30T22:00:00Z"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(getFromArgument 2015-09-30T22:00:00.123Z YYYY-MM-DDThh:mm:ssZ)" "&from=2015-09-30T22:00:00Z"
}

function testCheckValidTimestamp {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(checkValidTimestamp 2015-09-30T22:00:00Z YYYY-MM-DDThh:mm:ssZ)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(checkValidTimestamp 2015-09-30T22:00:00.4567Z YYYY-MM-DDThh:mm:ssZ)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(checkValidTimestamp 2015-09-30 YYYY-MM-DD)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/4" "$(checkValidTimestamp 2015-09-30T13 YYYY-MM-DD)" "Invalid date set: 2015-09-30T13, expecting YYYY-MM-DD"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/5" "$(checkValidTimestamp 2015-09-30T13 YYYY-MM-DDThh:mm:ssZ)" "Invalid timestamp set: 2015-09-30T13, expecting YYYY-MM-DDThh:mm:ssZ"
}

function testCheckValidGranularity {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(checkValidGranularity YYYY-MM-DDThh:mm:ssZ)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(checkValidGranularity YYYY-MM-DD)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "$(checkValidGranularity YYYY-DD-MM)" "Invalid granularity value: YYYY-DD-MM"
}

function testParseError {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/1" "$(parseError)" ""
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(parseError noRecordsMatch)" "WARNING: noRecordsMatch - empty result"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/2" "$(parseError otherError errormessage)" "otherError - errormessage"
}

# call the functions
testNotice
testWarning
testGetGenericConfig
testGetRepositoryConfig
testGetTargetData
testGetProcessTimeLinux
testGetProcessTimeMac
testGetFromArgument
testCheckValidTimestamp
testCheckValidGranularity
testParseError
