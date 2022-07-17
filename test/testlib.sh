#!/bin/bash
# Library with common testfunction for the shell-oaiharvester.

function assertEqual {
	local test=$1
	local result=$2
	local expected=$3

	if [[ "${result}" == "${expected}" ]]; then
		echo "# ${test}: SUCCESS"
	else
		echo "# ${test}: FAILED"
		echo "result: ${result}"
		echo "expected: ${expected}"
		echo "1" > "testresult"
	fi
}

function assertFileExists {
	local test=$1
	local filepath=$2

	if [ -f ${filepath} ]; then
		echo "# ${test}: SUCCESS"
	else
		echo "# ${test}: FAILED"
		echo "expected: ${filepath} does not exist"
		echo "1" > "testresult"
	fi
}

function assertFileNotExists {
	local test=$1
	local filepath=$2

	if [ ! -f ${filepath} ]; then
		echo "# ${test}: SUCCESS"
	else
		echo "# ${test}: FAILED"
		echo "expected: ${filepath} does exist"
		echo "1" > "testresult"
	fi
}

function assertPattern {
	local test=$1
	local result=$2
	local pattern=$3

	if [[ "$(echo ${result} | grep ${pattern})" != "" ]]; then
		echo "# ${test}: SUCCESS"
	else
		echo "# ${test}: FAILED"
		echo "expected: ${test} does not match ${pattern}"
		echo "1" > "testresult"
	fi
}

# Test die responses without application cleanup
function die {
	local message=$1
	echo ${message}
}
