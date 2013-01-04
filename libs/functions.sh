# Functions for the shell-oaiharvester.

# getRecords function
function getRecords
{
	# download the oaipage
	local starttime=$(date +%s%N | cut -b1-13)
	wget ${WGET_OPTS} ${URL} -O oaipage.xml
	local endtime=$(date +%s%N | cut -b1-13)
	local downloadtime=$(echo "scale=3; ($endtime - $starttime)/1000" | bc)


	# process the downloaded xml
	local starttime=$(date +%s%N | cut -b1-13)
	local conditional="${REPOSITORY_RECORDPATH}/${CONDITIONAL}"
	local count=1
	local record_count=$(xsltproc --stringparam data record_count libs/retrieveData.xsl oaipage.xml)

	
	while [ ${count} -le ${record_count} ]; do
		# get oai identifier and actual storage dir (based on first 2 chars of md5sum identifier)
		local identifier=$(xsltproc --stringparam data identifier --param record_nr ${count} libs/retrieveData.xsl oaipage.xml | sed s/\\//\%2F/g | sed s/\&/\%26/g | sed s/\ /\%20/g)
		local name="${identifier}"
		local namemd5=$(echo "${name}" | md5sum)
		local storedir=${namemd5:0:2}
		
		# check if status is deleted
		local status=$(xsltproc --stringparam data headerstatus --param record_nr ${count} libs/retrieveData.xsl oaipage.xml)

		if [ "${status}" == "deleted" ]; then
			touch "${REPOSITORY_RECORDPATH}/deleted/${name}"
			rm -f "${REPOSITORY_RECORDPATH}/harvested/${storedir}/${name}" > /dev/null 2>&1
		else
			# Store temporary record
			xsltproc --param record_nr ${count} libs/retrieveRecord.xsl oaipage.xml > ${TMP}/harvested.xml

			# first parse conditional xslt if available
			if [ ! -z ${conditional} ] && [ -f ${conditional} ]; then
				if [ "$(xsltproc ${conditional} ${TMP}/harvested.xml)" == "" ]; then
					# conditional not met, delete record
					rm ${TMP}/harvested.xml
				else
					mv ${TMP}/harvested.xml ${TMP}/passed-conditional.xml
				fi
			else
				mv ${TMP}/harvested.xml ${TMP}/passed-conditional.xml
			fi

			# store record if it passed the conditional test
			if [ -f ${TMP}/passed-conditional.xml ]; then
				mkdir -p "${REPOSITORY_RECORDPATH}/harvested/${storedir}"
				mv ${TMP}/passed-conditional.xml "${REPOSITORY_RECORDPATH}/harvested/${storedir}/${name}"
			fi

			# do translate here if translate is true
			# still to do
			#xsltproc --param record_nr ${count} retrieveRecord.xsl oaipage.xml > /tmp/record.xml
			#xsltproc modules/lom/stripUrls.xsl /tmp/record.xml > "${STORE_DIR}/${name}"
			#rm /tmp/record.xml
		fi

		count=$(( ${count} + 1 ))
	done
	
	local endtime=$(date +%s%N | cut -b1-13)
	local processtime=$(echo "scale=3; ($endtime - $starttime)/1000" | bc)


	# write logline
	echo "$(date '+%F %T'),$REPOSITORY,$record_count,$downloadtime,$processtime" >> ${LOGFILE}
}
