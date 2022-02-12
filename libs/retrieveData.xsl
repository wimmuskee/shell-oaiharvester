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
				<xsl:if test="/oai:OAI-PMH/oai:ListRecords">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListRecords/oai:record[$record_nr]/oai:header/oai:identifier"/>
				</xsl:if>
				<xsl:if test="/oai:OAI-PMH/oai:ListIdentifiers">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListIdentifiers/oai:header[$record_nr]/oai:identifier"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$data='datestamp'">
				<xsl:if test="/oai:OAI-PMH/oai:ListRecords">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListRecords/oai:record[$record_nr]/oai:header/oai:datestamp"/>
				</xsl:if>
				<xsl:if test="/oai:OAI-PMH/oai:ListIdentifiers">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListIdentifiers/oai:header[$record_nr]/oai:datestamp"/>
				</xsl:if>
			</xsl:when>
			<!-- count headers, independent of ListRecords or ListIdentifiers -->
			<xsl:when test="$data='record_count'">
				<xsl:value-of select="count(//oai:header)"/>
			</xsl:when>
			<xsl:when test="$data='resumptiontoken'">
				<xsl:value-of select="//oai:resumptionToken"/>
			</xsl:when>
			<xsl:when test="$data='granularity'">
				<xsl:value-of select="/oai:OAI-PMH/oai:Identify/oai:granularity"/>
			</xsl:when>
			<xsl:when test="$data='earliestDatestamp'">
				<xsl:value-of select="/oai:OAI-PMH/oai:Identify/oai:earliestDatestamp"/>
			</xsl:when>
			<xsl:when test="$data='responsedate'">
				<xsl:value-of select="/oai:OAI-PMH/oai:responseDate"/>
			</xsl:when>
			<xsl:when test="$data='headerstatus'">
				<xsl:if test="/oai:OAI-PMH/oai:ListRecords">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListRecords/oai:record[$record_nr]/oai:header/@status"/>
				</xsl:if>
				<xsl:if test="/oai:OAI-PMH/oai:ListIdentifiers">
					<xsl:value-of select="/oai:OAI-PMH/oai:ListIdentifiers/oai:header[$record_nr]/@status"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$data='format'">
				<xsl:if test="/oai:OAI-PMH/oai:ListRecords">
					<xsl:choose>
						<xsl:when test="count(/oai:OAI-PMH/oai:ListRecords/oai:record[$record_nr]/oai:metadata/child::*)>0">
							<xsl:text>xml</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>text</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$data='error'">
				<xsl:if test="/oai:OAI-PMH/oai:error">
					<xsl:value-of select="concat( /oai:OAI-PMH/oai:error/@code, ' - ',/oai:OAI-PMH/oai:error)"/>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
