<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html>
			<body style="font-family:Arial;font-size:12pt;">
				<h1 style="font-family:Arial;font-size:24pt;background-color:#FFFE38;color:#D51017">Employee Information</h1>
				
				<xsl:for-each select="Company/Employee">
					<xsl:call-template name="T1"><xsl:with-param name="EID" select="empID"/>
				</xsl:call-template>
			</xsl:for-each>
			<h1 style="font-family:Arial;font-size:24pt;background-color:#94ED94;color:#D51017">Department Information</h1>
			<xsl:for-each select="Company/Department">
				<xsl:call-template name="T2"><xsl:with-param name="ID" select="deptID"/>
			</xsl:call-template>
		</xsl:for-each>
	</body>
</html>
</xsl:template>
	
	
<xsl:template name="T1">		
<xsl:param name="EID" />
<xsl:text>Employee </xsl:text><b>
<xsl:value-of select="empName"/></b>
<xsl:text> works from </xsl:text> 
<b><xsl:value-of select="empOffice"/></b> 
<xsl:text> office.</xsl:text>
<b><xsl:value-of select="empName"/></b>
<xsl:text> works for </xsl:text>
<b><xsl:value-of select="count(//WorksFor/empID[. = $EID])"/></b> 
<xsl:text> division(s) which are </xsl:text> 
<xsl:for-each select="//WorksFor[empID = $EID]">
	<xsl:variable name="d" select="divID"/>
	
	<b><xsl:value-of select="//Division[divID = $d]/divName"/></b>
	
	<xsl:choose>
		<xsl:when test="position() &lt; last() -1">
			<xsl:text> , </xsl:text>
		</xsl:when>
	
		<xsl:when test="position() = last() -1 ">
			<xsl:text> and </xsl:text>
		</xsl:when>
		<xsl:otherwise>
		</xsl:otherwise>
	</xsl:choose>
</xsl:for-each>
<xsl:text> . </xsl:text>
<b><xsl:value-of select="empName"/></b>
<xsl:text> manages </xsl:text> 

<xsl:variable name="countmanaged" select="count(//Division/managerEmpID[. = $EID])"/>
<b><xsl:value-of select="$countmanaged"/></b>
<xsl:text> division(s) </xsl:text> 
<xsl:choose>
	<xsl:when test=" $countmanaged = 0">
		<xsl:text> . </xsl:text>
	</xsl:when>
	
	<xsl:when test=" $countmanaged !=0">
		<xsl:text>, which are </xsl:text>
		<xsl:for-each select="//Division[managerEmpID = $EID]">
			<b><xsl:value-of select="divName"/></b>
			<xsl:choose>
				<xsl:when test="position() &lt; last() -1">
					<xsl:text> , </xsl:text>
				</xsl:when>
	
				<xsl:when test="position() = last() -1 ">
					<xsl:text> and </xsl:text>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
				<xsl:text>. </xsl:text>
		</xsl:for-each>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>
<b>
	<xsl:value-of select="empName"/></b>

	<xsl:text> works for most of the time with the </xsl:text>
	
	<xsl:variable name="max">
		<xsl:for-each select="//WorksFor[empID = $EID]/PercentTime">
			<xsl:sort select="." data-type="number" order="descending"/>
			<xsl:if test="position() = 1"><xsl:value-of select="."/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	

	
	<xsl:for-each select="//WorksFor[empID = $EID]" >
	<xsl:if test="PercentTime = $max">
		<xsl:variable name="z" select="divID"/>
		<b><xsl:value-of select="//Division[divID = $z]/divName"/></b>
	</xsl:if>
</xsl:for-each>
		
	<xsl:text> division.</xsl:text>
	<br/>

</xsl:template>				
				


				
			

<xsl:template name="T2" match="Department">
	<xsl:param name="ID" />
	<xsl:text>Department </xsl:text>
	<b><xsl:value-of select="deptName"/></b>
	<xsl:text> houses </xsl:text>

	<b><xsl:value-of select="count(//Division/housedDeptID[. = $ID])"/></b>

	<xsl:text> division(s): </xsl:text>
	<xsl:for-each select="//Division[housedDeptID =$ID]">
		<b><xsl:value-of select="divName"/></b>
 
		<xsl:choose>
			<xsl:when test="position() &lt; last() -1">
				<xsl:text> , </xsl:text>
			</xsl:when>
	
			<xsl:when test="position() = last() -1 ">
				<xsl:text> and </xsl:text>
			</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:for-each>
	<xsl:text>. </xsl:text>
	<br/>
</xsl:template>
	
</xsl:stylesheet>
