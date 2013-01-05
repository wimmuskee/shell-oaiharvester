<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	version="1.0">
	<xsl:output method="xml"/>
	<xsl:param name="record_nr"/>
	<xsl:template match="/">
		<xsl:copy-of select="/oai:OAI-PMH/oai:ListRecords/oai:record[$record_nr]/oai:metadata/child::*"/>
	</xsl:template>
</xsl:stylesheet>
