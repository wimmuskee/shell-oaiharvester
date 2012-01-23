#!/bin/bash

# getRecords function
function getRecords
{
	local conditional=$1
	local count=1
	local record_count=$(xsltproc --stringparam data record_count libs/retrieveData.xsl oaipage.xml)

	while [ ${count} -le ${record_count} ]; do
		# get oai identifier
		identifier=$(xsltproc --stringparam data identifier --param record_nr ${count} libs/retrieveData.xsl oaipage.xml | sed s/\\//\%2F/g | sed s/\&/\%26/g | sed s/\ /\%20/g)
		name="${identifier}"

		# check if status is deleted
		status=$(xsltproc --stringparam data headerstatus --param record_nr ${count} libs/retrieveData.xsl oaipage.xml)

		if [ "${status}" == "deleted" ]; then
			touch "${RECORDPATH}/${REPOSITORY}/deleted/${name}"
		else
			# Store temporary record
			xsltproc --param record_nr ${count} libs/retrieveRecord.xsl oaipage.xml > ${TMP}/harvested.xml

			# first parse conditional xslt if available
			if [ ! -z ${conditional} ] && [ -f ${conditional} ]; then
				if [ "$(xsltproc ${conditional} ${TMP}/harvested.xml)" == "" ]; then
					# conditional not met, delete record
					rm  ${TMP}/harvested.xml
				else
					mv ${TMP}/harvested.xml ${TMP}/passed-conditional.xml
				fi
			else
				mv ${TMP}/harvested.xml ${TMP}/passed-conditional.xml
			fi

			# store record if it passed the conditional test
			if [ -f ${TMP}/passed-conditional.xml ]; then
				mv ${TMP}/passed-conditional.xml "${RECORDPATH}/${REPOSITORY}/harvested/${name}"
			fi

			# do translate here if translate is true
			# still to do
			#xsltproc --param record_nr ${count} retrieveRecord.xsl oaipage.xml > /tmp/record.xml
			#xsltproc modules/lom/stripUrls.xsl /tmp/record.xml > "${STORE_DIR}/${name}"
			#rm /tmp/record.xml

			# sla gewoon raw op
		fi

		count=$(( ${count} + 1 ))
	done
}

