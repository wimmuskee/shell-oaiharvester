#!/bin/bash

source testlib.sh
source ../libs/common.sh
source ../libs/migrations.sh

TESTCLASS="migrations"

function testNonExistingRecordpath {
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}" "$(rearrangeRecordsDataSubdirs "nonexistingdir")" "repository path nonexistingdir does not exist, there is nothing to migrate, exiting" 
}

function testMoveToNewVersionSubdirs {
	cp -r "version1-repo" "test-version1-repo"
	rearrangeRecordsDataSubdirs "test-version1-repo/"

	assertFileExists "${TESTCLASS}/${FUNCNAME[0]}/1" "test-version1-repo/4a/identifier1.xml"
	assertFileExists "${TESTCLASS}/${FUNCNAME[0]}/2" "test-version1-repo/e0/identifier2.xml"
	assertFileNotExists "${TESTCLASS}/${FUNCNAME[0]}/3" "test-version1-repo/ab/identifier1.xml"
	assertFileNotExists "${TESTCLASS}/${FUNCNAME[0]}/4" "test-version1-repo/8d/identifier2.xml"
	assertFileExists "${TESTCLASS}/${FUNCNAME[0]}/5" "test-version1-repo/dontmovethesecontents/notarecord.xml"
	assertFileNotExists "${TESTCLASS}/${FUNCNAME[0]}/6" "test-version1-repo/20/notarecord.xml"

	rm -rf "test-version1-repo"
}

function testMigrateLasttimestampFile {
	cp -r "version1-repo" "test-version1-repo"
	rm "test-version1-repo/.oaiharvester"
	rearrangeRecordsDataSubdirs "test-version1-repo/"

	assertFileExists "${TESTCLASS}/${FUNCNAME[0]}/1" "test-version1-repo/.oaiharvester"
	assertFileNotExists "${TESTCLASS}/${FUNCNAME[0]}/2" "test-version1-repo/lasttimestamp.txt"

	source "test-version1-repo/.oaiharvester"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "${REPO_VER}" "2.0.0_pre"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/4" "${LASTTIMESTAMP}" "2020-01-16T14:04:14Z"

	rm -rf "test-version1-repo"
}

function testMigrateToPreVersion {
	cp -r "version1-repo" "test-version1-repo"
	rearrangeRecordsDataSubdirs "test-version1-repo/"

	assertFileExists "${TESTCLASS}/${FUNCNAME[0]}/1" "test-version1-repo/.oaiharvester"
	assertFileNotExists "${TESTCLASS}/${FUNCNAME[0]}/2" "test-version1-repo/lasttimestamp.txt"

	source "test-version1-repo/.oaiharvester"
	assertEqual "${TESTCLASS}/${FUNCNAME[0]}/3" "${REPO_VER}" "2.0.0_pre"

	rm -rf "test-version1-repo"
}

# call the functions
testNonExistingRecordpath
testMoveToNewVersionSubdirs
testMigrateLasttimestampFile
testMigrateToPreVersion
