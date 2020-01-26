#!/bin/bash
# Controls the shell-oaiharvester test suite.

cd test
echo "0" > testresult
./test_migrations.sh

testresult=$(cat testresult)
rm testresult
[ ${testresult} -eq 1 ] && exit 1
exit 0
