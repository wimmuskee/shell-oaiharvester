#!/bin/bash

source config.sh
source libs/functions.sh

# check sanity (if xslts are available), tmp
mkdir -p ${TMP}

# Reading repository id
if [ ! -z $1 ]; then
	REPOSITORY=$1
else
	echo "No repository id provided"
	exit 1
fi

# Reading oai repository info
if [ -f config.xml ]; then
	BASEURL=$(xsltproc --stringparam data baseurl --stringparam repository ${REPOSITORY} libs/retrieveConfig.xsl config.xml)
	PREFIX=$(xsltproc --stringparam data metadataprefix --stringparam repository ${REPOSITORY} libs/retrieveConfig.xsl config.xml)
	SET=$(xsltproc --stringparam data set --stringparam repository ${REPOSITORY} libs/retrieveConfig.xsl config.xml)
	CONDITIONAL=$(xsltproc --stringparam data conditional --stringparam repository ${REPOSITORY} libs/retrieveConfig.xsl config.xml)
else
	echo "No repository config found."
	exit 1
fi

# Making sure the repository storage dirs exists
if [ ! -d "records/${REPOSITORY}/${STORAGE}" ]; then
	echo "Creating repository storage"
	mkdir -p "records/${REPOSITORY}/${STORAGE}"
	mkdir -p "records/${REPOSITORY}/${DELETED}"
fi

# Sets the initial harvest uri, add from if timestamp was found
if [ "${SET}" == "" ]; then
	URL="${BASEURL}?verb=ListRecords&metadataPrefix=${PREFIX}"
else
	URL="${BASEURL}?verb=ListRecords&metadataPrefix=${PREFIX}&set=${SET}"
fi

# Checks for a last harvest timestamp, and uses it
# according to the granularity settings
repository_timestamp="records/${REPOSITORY}/lasttimestamp.txt"
if [ -f ${repository_timestamp} ]; then
	# check out identify for datetime granularity
	wget "${BASEURL}?verb=Identify" -O identify.xml
	granularity=$(xsltproc --stringparam data granularity libs/retrieveData.xsl identify.xml)

	if [ "${granularity}" == "YYYY-MM-DDThh:mm:ssZ" ]; then
		timestamp=$(cat ${repository_timestamp})
	else
		timestamp=$(cat ${repository_timestamp} | awk -F "T" '{print $1}')
	fi
	URL="${URL}&from=${timestamp}"
fi


# Now, get the initial page and the records
# if there is a resumptionToken, retrieve other pages
wget ${WGET_OPTS} ${URL} -O oaipage.xml
getRecords "records/${REPOSITORY}/${CONDITIONAL}"
RESUMPTION=$(xsltproc --stringparam data resumptiontoken libs/retrieveData.xsl oaipage.xml)

while [ "${RESUMPTION}" != "" ]; do
	URL="${BASEURL}?verb=ListRecords&resumptionToken=${RESUMPTION}"
	wget ${WGET_OPTS} ${URL} -O oaipage.xml
	getRecords "records/${REPOSITORY}/${CONDITIONAL}"
	RESUMPTION=$(xsltproc --stringparam data resumptiontoken libs/retrieveData.xsl oaipage.xml)
done

# finishing up
date -u +'%FT%TZ' > ${repository_timestamp}
rm oaipage.xml identify.xml

exit 0
