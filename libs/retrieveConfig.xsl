<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:cfg="http://github.com/wimmuskee/shell-harvester/"
	version="1.0">
	<xsl:output method="text" omit-xml-declaration="yes"/>
	<xsl:param name="data"/>
	<xsl:param name="repository"/>
	
	<xsl:template match="/">
		<xsl:choose>
			<!-- Generic options -->
			<xsl:when test="$data='recordpath'">
  				<xsl:value-of select="/cfg:config/cfg:recordpath"/>
			</xsl:when>
			<xsl:when test="$data='temppath'">
  				<xsl:value-of select="/cfg:config/cfg:temppath"/>
			</xsl:when>
			<xsl:when test="$data='logfile'">
  				<xsl:value-of select="/cfg:config/cfg:logfile"/>
			</xsl:when>
			<xsl:when test="$data='recordlogfile'">
				<xsl:value-of select="/cfg:config/cfg:recordlogfile"/>
			</xsl:when>
			<xsl:when test="$data='curlopts'">
  				<xsl:value-of select="/cfg:config/cfg:curlopts"/>
			</xsl:when>
			<xsl:when test="$data='updatecmd'">
  				<xsl:value-of select="/cfg:config/cfg:updatecmd"/>
			</xsl:when>
			<xsl:when test="$data='deletecmd'">
  				<xsl:value-of select="/cfg:config/cfg:deletecmd"/>
			</xsl:when>
			<xsl:when test="$data='listrepos'">
				<xsl:for-each select="/cfg:config/cfg:repository">
					<xsl:value-of select="@id"/>
					<xsl:text> :: </xsl:text>
					<xsl:value-of select="cfg:baseurl"/>
					<xsl:text> :: </xsl:text>
					<xsl:choose>
						<xsl:when test="cfg:recordpath">
							<xsl:value-of select="cfg:recordpath"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(/cfg:config/cfg:recordpath, '/', @id)"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>\n</xsl:text>
				</xsl:for-each>
			</xsl:when>
			<!-- Repository options -->
			<xsl:when test="$data='baseurl'">
  				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:baseurl"/>
			</xsl:when>
			<xsl:when test="$data='metadataprefix'">
  				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:metadataprefix"/>
			</xsl:when>
			<xsl:when test="$data='set'">
  				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:set"/>
			</xsl:when>
			<xsl:when test="$data='from'">
  				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:from"/>
			</xsl:when>
			<xsl:when test="$data='until'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:until"/>
			</xsl:when>
			<xsl:when test="$data='resumptiontoken'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:resumptiontoken"/>
			</xsl:when>
			<xsl:when test="$data='repository_path'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:recordpath"/>
			</xsl:when>
			<xsl:when test="$data='repository_updatecmd'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:updatecmd"/>
			</xsl:when>
			<xsl:when test="$data='repository_deletecmd'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:deletecmd"/>
			</xsl:when>
			<xsl:when test="$data='repository_curlopts'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:curlopts"/>
			</xsl:when>
			<xsl:when test="$data='username'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:username"/>
			</xsl:when>
			<xsl:when test="$data='password'">
				<xsl:value-of select="/cfg:config/cfg:repository[@id=$repository]/cfg:password"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
