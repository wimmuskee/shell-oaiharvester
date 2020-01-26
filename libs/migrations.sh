# Migrations for the shell-oaiharvester.
# only moving forward

# Starting from 2.0.0, the subdirs in the repository path are
# based on the identifier md5sum without newline. This migrates
# all records in the provided path to the new subdirs.
function rearrangeRecordsDataSubdirs {
	local recordpath=${1%/}
	local repostatuspath="${recordpath}/.oaiharvester"

	echo "Starting record subdir migration in ${recordpath}"

	if [ ! -d ${recordpath} ]; then
		echo "repository path ${recordpath} does not exist, there is nothing to migrate, exiting" && exit 0
	fi

	for path in $(find ${recordpath} -mindepth 2); do
		identifier=${path##*/}
		pathdir=${path%/*}
		subdir=${pathdir##*/}

		# make sure only valid subdirs are processed
		if [[ "$(echo ${subdir} | grep '^[a-f0-9]\{2\}$')" == "" ]]; then
			continue
		fi

		new_subdir=$(echo -n "${identifier}" | md5sum | head -c 2)
		new_path="${recordpath}/${new_subdir}/${identifier}"

		if [[ "${path}" != "${new_path}" ]]; then
			mkdir -p "${recordpath}/${new_subdir}"
			mv ${path} ${new_path}
		fi
	done

	if [ -f ${repostatuspath} ]; then
		source ${repostatuspath}
		setRepositoryStatus "${repostatuspath}" "${LASTTIMESTAMP}" "2.0.0_pre"
	elif [ -f "${recordpath}/lasttimestamp.txt" ]; then
		LASTTIMESTAMP=$(cat "${recordpath}/lasttimestamp.txt")
		setRepositoryStatus "${repostatuspath}" "${LASTTIMESTAMP}" "2.0.0_pre"
	fi

	rm -f "${recordpath}/lasttimestamp.txt"
}
