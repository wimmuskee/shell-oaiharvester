<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:oai="http://www.openarchives.org/OAI/2.0/"
	version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	<xsl:param name="data"/>
	<xsl:param name="record_nr"/>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$data='identifier'">
  				<xsl:value-of select="//oai:record[$record_nr]/oai:header/oai:identifier"/>
			</xsl:when>
			<xsl:when test="$data='record_count'">
  				<xsl:value-of select="count(//oai:record)"/>
			</xsl:when>
			<xsl:when test="$data='resumptiontoken'">
  				<xsl:value-of select="//oai:resumptionToken"/>
			</xsl:when>
			<xsl:when test="$data='granularity'">
  				<xsl:value-of select="//oai:granularity"/>
			</xsl:when>
			<xsl:when test="$data='headerstatus'">
  				<xsl:value-of select="//oai:record[$record_nr]/oai:header/@status"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

