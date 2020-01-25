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
	fi
}
