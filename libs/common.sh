# Common functions used in main harvesting functions and migrations for the oai-harvester.

# Store status info in .oaihavester file.
function setRepositoryStatus {
	local statusfile=$1
	local timestamp=$2
	local version=$3

	echo "LASTTIMESTAMP=$timestamp" > ${statusfile}
	echo "REPO_VER=$version" >> ${statusfile}
	echo "REPO_MAJORVER=$(echo $version | cut -d "." -f 1)" >> ${statusfile}
}