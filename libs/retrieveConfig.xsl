<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cfg="https://github.com/wimmuskee/shell-harvester/"
	version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	<xsl:param name="data"/>
	<xsl:param name="repository"/>
	
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$data='recordpath'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:recordpath"/>
			</xsl:when>
			<xsl:when test="$data='temppath'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:temppath"/>
			</xsl:when>
			<xsl:when test="$data='wgetopts'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:wgetopts"/>
			</xsl:when>
			<xsl:when test="$data='baseurl'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:repository[@id=$repository]/cfg:baseurl"/>
			</xsl:when>
			<xsl:when test="$data='metadataprefix'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:repository[@id=$repository]/cfg:metadataprefix"/>
			</xsl:when>
			<xsl:when test="$data='set'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:repository[@id=$repository]/cfg:set"/>
			</xsl:when>
			<xsl:when test="$data='conditional'">
  				<xsl:value-of select="/cfg:harvesterconfig/cfg:repository[@id=$repository]/cfg:conditional"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

