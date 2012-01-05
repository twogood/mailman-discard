<?xml version='1.0'?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>

  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:for-each select="//input[@type='radio' and @value='0']">
        <xsl:text>&amp;</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="@value"/>
    </xsl:for-each>
  </xsl:template>

  <!--
  <xsl:template match="tr">
  </xsl:template>

  <xsl:template match="td">
    <xsl:text>fnurra</xsl:text>
    <xsl:value-of select="table/tbody/tr/td"/>
    <xsl:apply-templates/>
  </xsl:template>
    -->

  <!--
  <xsl:template match="item[enclosure/@type = 'audio/mpeg']">
    <xsl:value-of select="title"/>
    <xsl:text>;</xsl:text>
    <xsl:value-of select="enclosure/@url"/>
  </xsl:template>
  -->

  <xsl:template match="*">
  </xsl:template>

</xsl:stylesheet>

