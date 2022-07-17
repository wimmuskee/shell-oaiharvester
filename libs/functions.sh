# Functions for the shell-oaiharvester.

# Gets generic options from config file.
function getGenericConfig {
	local data=$1
	echo -e $(xsltproc --stringparam data ${data} ${INSTALLDIR}/retrieveConfig.xsl ${CONFIGFILE})
}

# Gets repository specific options from config file.
function getRepositoryConfig {
	local data=$1
	local repository=$2
	echo $(xsltproc --stringparam data ${data} --stringparam repository ${repository} ${INSTALLDIR}/retrieveConfig.xsl ${CONFIGFILE})
}

# Gets data from target.
function getTargetData {
	local data=$1
	local target=$2
	local recordnr=$3
	if [ -z $recordnr ]; then
		echo $(xsltproc --stringparam data ${data} ${INSTALLDIR}/retrieveData.xsl ${TMP}/${target}.xml)
	else
		echo $(xsltproc --stringparam data ${data} --param record_nr ${recordnr} ${INSTALLDIR}/retrieveData.xsl ${TMP}/${target}.xml)
	fi
}

# Return correct oai from argument timestamp format based on granularity
function getFromArgument {
	local timestamp=$1
	local granularity=$2

	if [[ "${granularity}" == "YYYY-MM-DDThh:mm:ssZ" ]]; then
		timestamp="${timestamp:0:19}Z"
	else
		# fallback all to YYYY-MM-DD
		timestamp=${timestamp:0:10}
	fi
	echo "&from=${timestamp}"
}

# Checks if downloaded oaipage is valid for xslt processing.
function checkValidXml {
	local url=$1
	local response=$(xsltproc --novalid --stringparam data responsedate ${INSTALLDIR}/retrieveData.xsl ${TMP}/oaipage.xml)

	if [ "${response}" == "" ]; then
		die "No responseDate found in source, probably not OAI-PMH: ${url}"
	fi
}

# Checks if input timestamp matches the ISO 8601 (https://www.w3.org/TR/NOTE-datetime) or date depending on granularity
function checkValidTimestamp {
	local timestamp=$1
	local granularity=$2

	if [[ "${granularity}" == "YYYY-MM-DDThh:mm:ssZ" ]]; then
		if [[ "$(echo ${timestamp} | grep -E '^[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9](\.[0-9]+)?Z$')" == "" ]]; then
			die "Invalid timestamp set"
		fi
	else
		if [[ "$(echo ${timestamp} | grep -E '^[0-9]{4}-[0-1][0-9]-[0-3][0-9]$')" == "" ]]; then
			die "Invalid date set"
		fi
	fi
}

# returns http status code
function getHttpStatus {
	local url=$1
	cmd="curl -i ${CURL_OPTS} -s -o /dev/null -w \"%{http_code}\" \"${url}\""
	echo $(eval ${cmd})
}

# conditional message or exit depending on status code
function checkHttpStatus {
	local code=$1
	case ${code} in
		"200") msg="ok" ;;
		*) die "received ${code}, exiting" ;;
	esac
	notice "Checking status code: ${msg}"
}

# download url to destination file
function fetchUrl {
	local url=$1
	local dest=$2
	local cmd="curl ${CURL_OPTS} \"${url}\" -o ${dest}"
	rm -f ${dest}
	eval ${cmd}
}

# calculate processing time
function getProcessTime {
	local starttime=$1
	local endtime=$2

	# default date on macos does not support %N in date
	if [[ "$(echo $starttime | tail -c 2)" == "N" ]]; then
		starttime=$(echo $starttime | tr -d "N")
		endtime=$(echo $endtime | tr -d "N")
		echo $(($endtime - $starttime))
	else
		diffms=$(( ($endtime - $starttime) / 1000000))
		echo $(printf "%03d" $diffms) | sed 's/...$/.&/'
	fi
}

# getRecords function
function getRecords {
	# download the oaipage
	local starttime=$(date +%s%N)
	fetchUrl ${URL} "${TMP}/oaipage.xml"
	cp "${TMP}/oaipage.xml" /tmp/oaipage.xml
	local endtime=$(date +%s%N)
	local downloadtime=$(getProcessTime $starttime $endtime)

	# process the downloaded xml
	checkValidXml ${URL}
	local starttime=$(date +%s%N)
	local conditional="${REPOSITORY_RECORDPATH}/${CONDITIONAL}"
	local count=1
	local record_count=$(getTargetData "record_count" "oaipage")
	local responsedatetime=$(getTargetData "responsedate" "oaipage")
	local responsedate=${responsedatetime:0:10}

	while [ ${count} -le ${record_count} ]; do
		# get oai identifier and actual storage dir (based on first 2 chars of md5sum identifier)
		local identifier=$(xsltproc --stringparam data identifier --param record_nr ${count} ${INSTALLDIR}/retrieveData.xsl ${TMP}/oaipage.xml | sed s/\\//\%2F/g | sed s/\&/\%26/g | sed s/\ /\%20/g)
		local datestamp=$(getTargetData "datestamp" "oaipage" ${count})
		local status=$(getTargetData "headerstatus" "oaipage" ${count})
		local filename="${identifier}"
		local storedir=$(echo -n "${identifier}" | md5sum | head -c 2)
		local path="${REPOSITORY_RECORDPATH}/${storedir}/${filename}"

		if [ "${status}" == "deleted" ]; then
			if [ ! -z "${REPOSITORY_DELETE_CMD}" ]; then
				eval ${REPOSITORY_DELETE_CMD}
			fi

			if [ ! -z "${DELETE_CMD}" ]; then
				eval ${DELETE_CMD}
			fi
			rm -f "${path}" > /dev/null 2>&1
		else
			# ensure storage dir
			test -d "${REPOSITORY_RECORDPATH}/${storedir}" || mkdir -p "${REPOSITORY_RECORDPATH}/${storedir}"

			# retrieve record based on format
			local format=$(getTargetData "format" "oaipage" ${count})
			if [ "${format}" == "xml" ]; then
				xsltproc --param record_nr ${count} ${INSTALLDIR}/retrieveXmlRecord.xsl ${TMP}/oaipage.xml > "${path}" 
			else
				xsltproc --param record_nr ${count} ${INSTALLDIR}/retrieveTextRecord.xsl ${TMP}/oaipage.xml > "${path}" 
			fi

			if [ ! -z "${REPOSITORY_UPDATE_CMD}" ]; then
				eval ${REPOSITORY_UPDATE_CMD}
			fi

			if [ ! -z "${UPDATE_CMD}" ]; then
				eval ${UPDATE_CMD}
			fi

		fi
		echo "$(date '+%F %T'),${REPOSITORY},${datestamp},${identifier}" >> ${RECORDLOGFILE}
		count=$(( ${count} + 1 ))
	done
	
	local endtime=$(date +%s%N)
	local processtime=$(getProcessTime $starttime $endtime)

	# write logline
	echo "$(date '+%F %T'),$PID,$REPOSITORY,$URL,$record_count,$downloadtime,$processtime" >> ${LOGFILE}
}

function testRepository {
	# check dependency
	which xmllint &>/dev/null
	if [ $? -eq 1 ]; then
		die "Dependency not found: xmllint, testing not available"
	fi

	checkHttpStatus $(getHttpStatus "${BASEURL}?verb=Identify")

	echo
	echo "Downloading pages:"
	fetchUrl "${BASEURL}?verb=Identify" "${TMP}/identify.xml"
	fetchUrl "${BASEURL}?verb=ListMetadataFormats" "${TMP}/listmetadataformats.xml"

	if [ -z ${SET} ]; then
		fetchUrl "${BASEURL}?verb=ListRecords&metadataPrefix=${PREFIX}" "${TMP}/listrecords.xml"
		fetchUrl "${BASEURL}?verb=ListIdentifiers&metadataPrefix=${PREFIX}" "${TMP}/listidentifiers.xml"
	else
		fetchUrl "${BASEURL}?verb=ListSets" "${TMP}/listsets.xml"
		fetchUrl "${BASEURL}?verb=ListRecords&metadataPrefix=${PREFIX}&set=${SET}" "${TMP}/listrecords.xml"
		fetchUrl "${BASEURL}?verb=ListIdentifiers&metadataPrefix=${PREFIX}&set=${SET}" "${TMP}/listidentifiers.xml"
	fi

	echo
	echo "Validating the XML:"
	if [ "${TEST_STRICT}" != "true" ]; then
		echo "fails without report are ignored strict wildcard errors"
	fi
	if [ ! -f ${TMP}/OAI-PMH.xsd ]; then
		curl --silent "http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" -o ${TMP}/OAI-PMH.xsd
	fi

	# solve strict error message with:
	# http://blog.gmane.org/gmane.comp.gnome.lib.xml.general/month=20091101/page=2
	for xml in identify listmetadataformats listsets listrecords listidentifiers; do
		if [ -s ${TMP}/${xml}.xml ]; then
			if [ "${TEST_STRICT}" == "true" ]; then
				xmllint --noout --schema ${TMP}/OAI-PMH.xsd ${TMP}/${xml}.xml 2>&1
			else
				xmllint --noout --schema ${TMP}/OAI-PMH.xsd ${TMP}/${xml}.xml 2>&1| grep -v strict
			fi
		fi
	done

	# cleaning
	for xml in identify listmetadataformats listsets listrecords listidentifiers; do
		rm -f ${TMP}/${xml}.xml
	done
}
