<?xml version='1.0'?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str"
  version='1.0'>

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:for-each select="//input[@type='radio' and @value='0']">
        <xsl:text>&amp;</xsl:text>
        <xsl:value-of select="str:encode-uri(@name, true())"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="str:encode-uri(@value, true())"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="*">
  </xsl:template>

</xsl:stylesheet>

