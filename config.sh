#!/bin/bash

# wget options
WGET_OPTS="--limit-rate=200k"

# Tempdir (should be mounted in ramdisk)
TMP=/tmp/harvester

# The temporary storage dir
STORAGE=storage

# The temporary deletes dir
DELETED=deleted
