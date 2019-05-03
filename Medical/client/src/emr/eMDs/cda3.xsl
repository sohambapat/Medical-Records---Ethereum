<?xml version="1.0" encoding="UTF-8"?>
<!--
  CDA XSL StyleSheet
  Author: Tom Reventas
  Copyright 2013, 2014, e-MDs.com, Austin, Texas, USA
	Last update: 2014-7-3
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:hl7-org:v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output method="html" indent="yes"/>
		
	<xsl:template match="/">
		<!-- does not assume ClinicalDocument is root element: find the first occurring ClinicalDocument ANYWHERE -->
		<xsl:apply-templates select="//n1:ClinicalDocument[1]"/>
	</xsl:template>
	
	<xsl:template match="n1:ClinicalDocument">
		<html>
			<head>
				<title>
					<xsl:value-of select="n1:title"/>
				</title>
				<style type="text/css">
					<xsl:text>
body {
	width: 7.5in;
	font-size: 8pt; 
	font-family: Verdana, Tahoma, sans-serif;
	padding: 4px;
	border: thin solid gray;
}

h1 {
	font-size: 1.4em;;
	font-weight: bold;
	margin-top: 0.2em;
	margin-bottom: 0.2em;
}

h2 {
	font-size: 1.2em;
	font-weight: bold;
}

span.strong {
	font-weight: bold;
}

div.toc {
	margin-left: 1px;
	padding: 0.1em;
}
div.toc h2 {
	margin: 0.1em;
}
div.toc ul {
	float: left;
	margin-top: 0.1em;
	margin-bottom: 0.1em;
	margin-left: 1.0em;
	list-style-type: none;
}
div.toc a:link {
	color: Black;
}
div.toc a:visited {
	color: Black;
}
div.toc a:hover {
	background: Red;
	color: White;
}

table {
	border-collapse: collapse;
	margin-top: 1em;
	font-size: 1.0em;
}

th, td {
	background-color: White;
	color: Black;
	border: 2px solid Black;
	padding: 0.4em;
}

th {
	font-weight: bold;
	background-color: #dddddd;
}

div.header {
	float: left;
	margin-top: 1em;
	margin-left: 1em;
	margin-right: 2.5em;
}

div.section {
	margin-left: 0px;
}

div.section * div.section {
	margin-left: 10px;
}

div.title {
	margin-top: 1.5em;
	margin-left: -4px;
	margin-right: -4px;
	border-left: 1px solid black;
	border-top: 1px solid black;
	border-bottom: 2px solid gray; 
	background-color: #ff3333;
}

div.title h2 {
	margin-left: 14px;
	margin-top: 0.2em;
	margin-bottom: 0.2em;
	color: white;
}

div.title h2 a:link {
	text-decoration: none;
	color: white;
}
div.title h2 a:visited {
	text-decoration: none;
	color: white;
}
div.title h2 a:hover {
	background: Yellow;
	color: Black;
}
					</xsl:text>
				</style>
			</head>
			<body>
				<a name="top" />
				<h1><xsl:value-of select="n1:title"/></h1>

				<!-- TOC - Table of Contents -->
				<hr/>
				<div class="toc">
					<h2>Table of Contents</h2>
					<ul>
						<li><a href="#patient_demo">Patient Demographics</a></li>
						
						<xsl:if test="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer[1]/n1:assignedEntity/n1:assignedPerson/n1:name">
							<li><a href="#care_providers">Care Providers</a></li>
						</xsl:if>
						
						<xsl:if test="/n1:ClinicalDocument/n1:componentOf">
							<li><a href="#visit_info">Visit Information</a></li>
						</xsl:if>
					
						<xsl:for-each select="//n1:component/n1:section">
							<xsl:if test="position() &lt; 8">
								<li>
									<a href="#{generate-id(.)}"><xsl:value-of select="n1:title" /></a>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
					
					<ul>
						<xsl:for-each select="//n1:component/n1:section">
							<xsl:if test="position() &gt; 7">
								<li>
									<a href="#{generate-id(.)}"><xsl:value-of select="n1:title" /></a>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
					<div style="clear: both;"></div>
				</div>
				<!-- end of Table of Contents -->

				<!-- patientData -->
				<a name="patient_demo" />
				<div class="section">
					<div class="title">
						<h2>
							<a href="#top">Patient Demographics</a>
						</h2>
					</div>
						
					<xsl:for-each select="/n1:ClinicalDocument/n1:recordTarget/n1:patientRole">
						<div class="header">
							<span class="strong">Name: </span> <xsl:call-template name="show-name">
								<xsl:with-param name="name" select="n1:patient/n1:name"/>
							</xsl:call-template>

							<br />
							<span class="strong">Birthdate: </span>
							<xsl:call-template name="formatDate">
								<xsl:with-param name="datetime" select="n1:patient/n1:birthTime/@value"/>
							</xsl:call-template>
							
							<br />
							<span class="strong">Gender: </span> 
							<xsl:value-of select="n1:patient/n1:administrativeGenderCode/@code"/>
							<xsl:if test="n1:patient/n1:administrativeGenderCode/@displayName">
								(<xsl:value-of select="n1:patient/n1:administrativeGenderCode/@displayName"/>)
							</xsl:if>
							
							<br />
							<span class="strong">Race: </span> 
							<xsl:value-of select="n1:patient/n1:raceCode/@code"/>
							<xsl:if test="n1:patient/n1:raceCode/@displayName">
								(<xsl:value-of select="n1:patient/n1:raceCode/@displayName"/>)
							</xsl:if>

							<br />
							<span class="strong">Ethnicity: </span> 
							<xsl:value-of select="n1:patient/n1:ethnicGroupCode/@code"/>
							<xsl:if test="n1:patient/n1:ethnicGroupCode/@displayName">
								(<xsl:value-of select="n1:patient/n1:ethnicGroupCode/@displayName"/>)
							</xsl:if>

							<br />
							<span class="strong">Language: </span> 
							<xsl:for-each select="n1:patient/n1:languageCommunication">
								<br/>
								<xsl:call-template name="formatLanguageCode">
									<xsl:with-param name="languageCode" select="n1:languageCode/@code"/>
								</xsl:call-template>
								<xsl:if test="n1:proficiencyLevelCode/@displayName">
								, proficiency: <xsl:value-of select="n1:proficiencyLevelCode/@displayName"/>
								</xsl:if>
								<xsl:if test="n1:preferenceInd[@value='true']">
								(preferred)
								</xsl:if>
							</xsl:for-each>
						</div>
						
						<div class="header">
							<span class="strong">Contact Information: </span>
							<xsl:apply-templates select="n1:telecom" />
							<xsl:apply-templates select="n1:addr" />
						</div>
						
					</xsl:for-each>
				</div>
				<div style="clear: both"></div>
				
				<!-- Care Providers from documentationOf header element -->
				<xsl:if test="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer[1]/n1:assignedEntity/n1:assignedPerson/n1:name">
					<a name="care_providers" />
					<div class="section">
						<div class="title">
							<h2>
								<a href="#top">Care Providers</a>
							</h2>
						</div>

						<xsl:for-each select="/n1:ClinicalDocument/n1:documentationOf/n1:serviceEvent/n1:performer">
							<div class="header">
								<span class="strong">Name: </span> 
								<xsl:call-template name="show-name">
									<xsl:with-param name="name" select="n1:assignedEntity/n1:assignedPerson/n1:name"/>
								</xsl:call-template>
								
								<xsl:if test="n1:functionCode/n1:originalText">
									<br/><xsl:value-of select="n1:functionCode/n1:originalText" />
								</xsl:if>
								
								<xsl:if test="string-length(n1:assignedEntity/n1:representedOrganization/n1:name) &gt; 0">
									<br/>
									<xsl:call-template name="show-contact-info">
										<xsl:with-param name="entity" select="n1:assignedEntity/n1:representedOrganization"/>
									</xsl:call-template>
								</xsl:if>
								
							</div>
						</xsl:for-each>
						<div style="clear: both"></div>
					</div>
				</xsl:if>

				<!-- Visit information from componentOf header element -->
				<xsl:if test="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter">
					<a name="visit_info" />
					<div class="section">
						<div class="title">
							<h2>
								<a href="#top">Visit Information</a>
							</h2>
						</div>
						
						<div class="header">
							<span class="strong">Provider: </span> 
							<xsl:call-template name="show-name">
								<xsl:with-param name="name" select="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter/n1:responsibleParty/n1:assignedEntity/n1:assignedPerson/n1:name"/>
							</xsl:call-template>
							
							<br/><br/>
							<span class="strong">Date: </span> 
							<xsl:call-template name="formatDate">
								<xsl:with-param name="datetime" select="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter/n1:effectiveTime/n1:low/@value"/>
							</xsl:call-template>
						</div>

						<div class="header">
							<xsl:call-template name="show-contact-info">
								<xsl:with-param name="entity" select="/n1:ClinicalDocument/n1:componentOf/n1:encompassingEncounter/n1:location/n1:healthCareFacility/n1:serviceProviderOrganization"/>
							</xsl:call-template>
						</div>
	
						<div style="clear: both"></div>
					</div>
				</xsl:if>
				
				<xsl:apply-templates select="n1:component" />
				<br/>
				
				<!-- FOOTER -->
				<hr />
				Document date/time: 
				<xsl:call-template name="formatDateTime">
					<xsl:with-param name="datetime" select="/n1:ClinicalDocument/n1:effectiveTime/@value"/>
				</xsl:call-template>
			
				<!-- custodian -->
				<xsl:if test="/n1:ClinicalDocument/n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name">
					<br/>
					Custodian of record: <xsl:value-of select="/n1:ClinicalDocument/n1:custodian/n1:assignedCustodian/n1:representedCustodianOrganization/n1:name" />
				</xsl:if>
				
				<!-- authoring device -->
				<xsl:if test="/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:assignedAuthoringDevice/n1:softwareName">
					<br/>
					Authoring device: <xsl:apply-templates select="/n1:ClinicalDocument/n1:author/n1:assignedAuthor/n1:assignedAuthoringDevice/n1:softwareName" />
				</xsl:if>
				<!-- end of footer -->
				
			</body>
		</html>
	</xsl:template>
		
	<xsl:template match="n1:component">
		<xsl:apply-templates />
	</xsl:template>

	<!-- =============== nonXMLBody ========================== -->
	<xsl:template match='n1:nonXMLBody'>
		<a name="nonXMLBody" />
		<div class="section">
			<div class="title">
				<h2>
					<a href="#top">Non Structured Data</a>
				</h2>
			</div>
			<xsl:choose>
				<xsl:when test='n1:text/n1:reference'>
					<div>
						<br/>
						<b>For security reasons, automatic download of referenced resources is disabled.</b>
						<br/>
						If you trust the following source, click the link to visit the referenced document: <a href="{n1:text/n1:reference/@value}"><xsl:value-of select='n1:text/n1:reference/@value'/></a>
						<br/>
					</div>
				</xsl:when>
				<xsl:when test='n1:text/@mediaType'>
					Media Type: <input type="text" id="txtMediaType" size="22" value="{n1:text/@mediaType}"/><br/>
					Representation: <input type="text" id="txtRepresentation" size="22" value="{n1:text/@representation}"/><br/>
					<textarea id="txtRawData" rows="22" cols="80">
						<xsl:value-of select='n1:text'/>
					</textarea>
					<br/>
					<xsl:if test="n1:text[@representation = 'B64']">
						<div>To decode data, see <a href="http://www.motobit.com/util/base64-decoder-encoder.asp">Base64 Decoder</a></div>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<div>Cannot display the text</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>


	<!-- =============== normal section ========================== -->
	<xsl:template match="n1:structuredBody">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="n1:section">
		<a name="{generate-id(.)}" />
		<div class="section">
			<div class="title">
				<h2>
					<a href="#top"><xsl:value-of select="n1:title" /></a>
				</h2>
			</div>
			<xsl:apply-templates select="n1:text" />
			<xsl:apply-templates select="n1:component" />
		</div>
	</xsl:template>

  <xsl:template match="n1:text">
	  <div>
			<xsl:apply-templates select="@styleCode | node()"/>
	  </div>
  </xsl:template>
  
  <xsl:template match="n1:paragraph">
		<p>
			<xsl:apply-templates select="@styleCode | node()"/>
		</p>
	</xsl:template>
  
	<!--   Content w/ deleted text is hidden -->
	<xsl:template match="n1:content[@revised='delete']"/>
  
	<xsl:template match="n1:content">
		<span>
			<xsl:apply-templates select="@styleCode | node()"/>
		</span>
	</xsl:template>
  
	<xsl:template match="n1:br">
		<br/>
	</xsl:template>
  
	<xsl:template match="n1:list[@listType='ordered']">
		<ol>
			<xsl:copy-of select="@ID | @language"/>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>

	<xsl:template match="n1:list">
		<ul>
			<xsl:copy-of select="@ID | @language"/>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="n1:item">
		<li>
			<xsl:copy-of select="@ID | @language"/>
			<xsl:apply-templates select="@styleCode | node()"/>
		</li>
	</xsl:template>

  <xsl:template match="n1:caption">
    <span style="font-weight:bold; ">
		<xsl:apply-templates select="@styleCode | node()"/>
    </span>
  </xsl:template>


	<!-- 
	Table
		Attributes: ID, language, styleCode, border (the only attribute used by HTML5)
		summary, width, frame, rules, cellspacing, cellpadding are from HTML 4.01 and are not supported in HTML5, so they are ignored here.
	-->
	<xsl:template match="n1:table">
		<table>
			<xsl:copy-of select="@ID | @language | @border"/>
			<xsl:apply-templates select="@styleCode | node()"/>
		</table>
	</xsl:template>

	<!-- 
	Tbody, Tfoot, Thead, Tr
		Share the following attributes: ID, language, styleCode
		align, char, charoff, valign are from HTML 4.01 and are not supported in HTML5, so they are ignored here.
	-->  
	<xsl:template match="n1:tbody | n1:tfoot | n1:thead | n1:tr">
		<xsl:copy>
			<xsl:copy-of select="@ID | @language"/>
			<xsl:apply-templates select="@styleCode | node()"/>
		</xsl:copy>
	</xsl:template>
  
	<!-- 
	Td, Th  
		Share the following attributes: ID, language, styleCode, headers, scope, rowspan, colspan
		abbr, axis, align, charoff, char and valign are from HTML 4.01 and are not supported in HTML5, so they are ignored here.
	-->  
	<xsl:template match="n1:th | n1:td">
		<xsl:copy>
			<xsl:copy-of select="@ID | @language | @headers | @scope | @rowspan | @colspan"/>
			<xsl:apply-templates select="@styleCode | node()"/>
		</xsl:copy>
	</xsl:template>
  
	<xsl:template match="n1:colgroup">
		<colgroup>
			<xsl:apply-templates select="@styleCode | node()"/>
		</colgroup>
	</xsl:template>
  
	<xsl:template match="n1:col">
		<col>
			<xsl:apply-templates select="@styleCode | node()"/>
		</col>
	</xsl:template>
  
	<xsl:template match="n1:sup">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>
	
	<xsl:template match="n1:sub">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	
	<xsl:template match="n1:linkHtml">
		<a>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="@styleCode | node()"/>
		</a>
	</xsl:template>

  	<!--    Stylecode processing    -->
	<xsl:template match="@styleCode">
		<xsl:attribute name="style">
			<xsl:choose>
				<xsl:when test="contains( ., 'Bold') or contains( ., 'Italic') or contains( ., 'Underline') or contains( ., 'Emphasis')">
					<xsl:if test="contains( ., 'Bold')">font-weight: bold;</xsl:if>
					<xsl:if test="contains( ., 'Italic')">font-style: italic;</xsl:if>
					<xsl:if test="contains( ., 'Underline')">text-decoration: underline;</xsl:if>
					<xsl:if test="contains( ., 'Emphasis')">font-style: oblique;</xsl:if>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="n1:renderMultiMedia">
		<xsl:variable name="imageRef" select="@referencedObject"/>
		<xsl:apply-templates select="//n1:*[@ID=$imageRef]"/>
	</xsl:template>

  <xsl:template match="n1:regionOfInterest">
          View: <xsl:value-of select="n1:code/@code"/>, coordinates: <xsl:for-each select="n1:value"><xsl:value-of select="@value"/>, </xsl:for-each><br/>
          <xsl:apply-templates select="*/n1:observationMedia" />
  </xsl:template>

  <xsl:template match="n1:observationMedia">
        <xsl:if test="n1:value[@mediaType='image/gif' or @mediaType='image/jpeg' or @mediaType='image/png']">
			<div>
				<b>For privacy reasons automatic display of images is disabled.</b>
				<br/>
				If you trust the following source, click the link to view the image: <a href="{n1:value/n1:reference/@value}"><xsl:value-of select='n1:value/n1:reference/@value'/></a>
				<br/>
				<br/>
			</div>
        </xsl:if>
  </xsl:template>
  
	<!-- =============== non narrative temples ========================== -->
	<!-- address -->
	<xsl:template match="n1:addr">
		<br/>
		<xsl:if test="@use">
			<b>
			<xsl:call-template name="translateTelecomCode">
				<xsl:with-param name="code" select="@use"/>
			</xsl:call-template>
			<xsl:text>:</xsl:text>
			</b><br/>
		</xsl:if>
		<xsl:for-each select="n1:streetAddressLine">
			<xsl:value-of select="."/> 
			<br/>
		</xsl:for-each>
		<xsl:if test="string-length(n1:city)>0">
			<xsl:value-of select="n1:city"/>
		</xsl:if>
		<xsl:if test="string-length(n1:state)>0">
			<xsl:text>,&#160;</xsl:text>
			<xsl:value-of select="n1:state"/>
		</xsl:if>
		<xsl:if test="string-length(n1:postalCode)>0">
			<xsl:text>&#160;</xsl:text>
			<xsl:value-of select="n1:postalCode"/>
		</xsl:if>
	</xsl:template>

	<!-- telecom -->
	<xsl:template match="n1:telecom">
		<br/>
		<xsl:variable name="type" select="substring-before(@value, ':')"/>
		<xsl:variable name="value" select="substring-after(@value, ':')"/>
		<xsl:if test="$type">
			<xsl:call-template name="translateTelecomCode">
				<xsl:with-param name="code" select="$type"/>
			</xsl:call-template>
			<xsl:if test="@use">
				<xsl:text> (</xsl:text>
				<xsl:call-template name="translateTelecomCode">
					<xsl:with-param name="code" select="@use"/>
				</xsl:call-template>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:text>: </xsl:text>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$value"/>
		</xsl:if>
	</xsl:template>

	<!-- =============== named templates ========================== -->
	<xsl:template name="show-contact-info">
		<xsl:param name="entity"/>
		<xsl:call-template name="show-name">
			<xsl:with-param name="name" select="$entity/n1:name"/>
		</xsl:call-template>
		<xsl:apply-templates select="$entity/n1:telecom[@use='WP']" />
		<xsl:apply-templates select="$entity/n1:addr[@use='WP']" />
	</xsl:template>

	<xsl:template name="show-name">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$name/n1:family">
				<xsl:if test="$name/n1:prefix">
					<xsl:value-of select="$name/n1:prefix"/>
					<xsl:text> </xsl:text>
				</xsl:if>
				<xsl:for-each select="$name/n1:given">
					<xsl:value-of select="."/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:value-of select="$name/n1:family"/>
				<xsl:if test="$name/n1:suffix">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$name/n1:suffix"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<!-- Convert Telecom URL to display text -->
	<xsl:template name="translateTelecomCode">
		<xsl:param name="code"/>
		<xsl:choose>
			<!-- lookup table Telecom URI -->
			<xsl:when test="$code='tel'">
				<xsl:text>Tel</xsl:text>
			</xsl:when>
			<xsl:when test="$code='fax'">
				<xsl:text>Fax</xsl:text>
			</xsl:when>
			<xsl:when test="$code='http'">
				<xsl:text>Web</xsl:text>
			</xsl:when>
			<xsl:when test="$code='mailto'">
				<xsl:text>eMail</xsl:text>
			</xsl:when>
			<xsl:when test="$code='H'">
				<xsl:text>Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='HV'">
				<xsl:text>Vacation Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='HP'">
				<xsl:text>Primary Home</xsl:text>
			</xsl:when>
			<xsl:when test="$code='WP'">
				<xsl:text>Workplace</xsl:text>
			</xsl:when>
			<xsl:when test="$code='PUB'">
				<xsl:text>Public</xsl:text>
			</xsl:when>
			<xsl:when test="$code='DIR'">
				<xsl:text>Direct</xsl:text>
			</xsl:when>
			<xsl:when test="$code='TMP'">
				<xsl:text>Temporary</xsl:text>
			</xsl:when>
			<xsl:when test="$code='AS'">
				<xsl:text>Answering Service</xsl:text>
			</xsl:when>
			<xsl:when test="$code='EC'">
				<xsl:text>Emergency Contact</xsl:text>
			</xsl:when>
			<xsl:when test="$code='MC'">
				<xsl:text>Mobile Contact</xsl:text>
			</xsl:when>
			<xsl:when test="$code='PG'">
				<xsl:text>Direct</xsl:text>
			</xsl:when>
			
			<!--  just output the code -->
			<xsl:otherwise>
				<xsl:value-of select="$code"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<!-- show date and time -->
	<xsl:template name="formatDateTime">
		<xsl:param name="datetime"/>
		
		<xsl:call-template name="formatDate">
			<xsl:with-param name="datetime" select="$datetime"/>
		</xsl:call-template>
		
		<xsl:text>  </xsl:text>
		
		<xsl:call-template name="formatTime">
			<xsl:with-param name="datetime" select="$datetime"/>
		</xsl:call-template>
	</xsl:template>
  
	<!-- pass in a date/time string to format date only. Uses "long-month date, year" format -->
	<xsl:template name="formatDate">
		<xsl:param name="datetime"/>
		<!-- month -->
		<xsl:variable name="month" select="substring ($datetime, 5, 2)"/>
		<xsl:choose>
			<xsl:when test="$month='01'">
				<xsl:text>January </xsl:text>
			</xsl:when>
			<xsl:when test="$month='02'">
				<xsl:text>February </xsl:text>
			</xsl:when>
			<xsl:when test="$month='03'">
				<xsl:text>March </xsl:text>
			</xsl:when>
			<xsl:when test="$month='04'">
				<xsl:text>April </xsl:text>
			</xsl:when>
			<xsl:when test="$month='05'">
				<xsl:text>May </xsl:text>
			</xsl:when>
			<xsl:when test="$month='06'">
				<xsl:text>June </xsl:text>
			</xsl:when>
			<xsl:when test="$month='07'">
				<xsl:text>July </xsl:text>
			</xsl:when>
			<xsl:when test="$month='08'">
				<xsl:text>August </xsl:text>
			</xsl:when>
			<xsl:when test="$month='09'">
				<xsl:text>September </xsl:text>
			</xsl:when>
			<xsl:when test="$month='10'">
				<xsl:text>October </xsl:text>
			</xsl:when>
			<xsl:when test="$month='11'">
				<xsl:text>November </xsl:text>
			</xsl:when>
			<xsl:when test="$month='12'">
				<xsl:text>December </xsl:text>
			</xsl:when>
		</xsl:choose>
		
		<!-- day -->
		<xsl:if test="string-length($datetime) &gt; 7">
			<xsl:choose>
				<xsl:when test='substring ($datetime, 7, 1)="0"'>
					<xsl:value-of select="substring ($datetime, 8, 1)"/>
					<xsl:text>, </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring ($datetime, 7, 2)"/>
					<xsl:text>, </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	
		<!-- year -->
		<xsl:value-of select="substring ($datetime, 1, 4)"/>
	</xsl:template>

	<!-- pass in a date/time string for format time only -->
	<xsl:template name="formatTime">
		<xsl:param name="datetime"/>
		<xsl:if test="string-length($datetime) &gt; 11">
			<xsl:value-of select="substring ($datetime, 9, 2)"/>:<xsl:value-of select="substring ($datetime, 11, 2)"/>
				<xsl:if test="string-length($datetime) &gt; 12">:<xsl:value-of select="substring ($datetime, 13)"/></xsl:if>
		</xsl:if>
	</xsl:template>

	<!-- Need lookup to convert language code, there is no displayName -->
	<xsl:template name="formatLanguageCode">
		<xsl:param name="languageCode"/>
		<span title="{$languageCode}">
		<xsl:choose>
			<xsl:when test="$languageCode='aar'">Afar</xsl:when>
			<xsl:when test="$languageCode='abk'">Abkhazian</xsl:when>
			<xsl:when test="$languageCode='afr'">Afrikaans</xsl:when>
			<xsl:when test="$languageCode='aka'">Akan</xsl:when>
			<xsl:when test="$languageCode='sqi'">Albanian</xsl:when>
			<xsl:when test="$languageCode='amh'">Amharic</xsl:when>
			<xsl:when test="$languageCode='ara'">Arabic</xsl:when>
			<xsl:when test="$languageCode='arg'">Aragonese</xsl:when>
			<xsl:when test="$languageCode='hye'">Armenian</xsl:when>
			<xsl:when test="$languageCode='asm'">Assamese</xsl:when>
			<xsl:when test="$languageCode='ava'">Avaric</xsl:when>
			<xsl:when test="$languageCode='ave'">Avestan</xsl:when>
			<xsl:when test="$languageCode='aym'">Aymara</xsl:when>
			<xsl:when test="$languageCode='aze'">Azerbaijani</xsl:when>
			<xsl:when test="$languageCode='bak'">Bashkir</xsl:when>
			<xsl:when test="$languageCode='bam'">Bambara</xsl:when>
			<xsl:when test="$languageCode='eus'">Basque</xsl:when>
			<xsl:when test="$languageCode='bel'">Belarusian</xsl:when>
			<xsl:when test="$languageCode='ben'">Bengali</xsl:when>
			<xsl:when test="$languageCode='bih'">Bihari languages</xsl:when>
			<xsl:when test="$languageCode='bis'">Bislama</xsl:when>
			<xsl:when test="$languageCode='bos'">Bosnian</xsl:when>
			<xsl:when test="$languageCode='bre'">Breton</xsl:when>
			<xsl:when test="$languageCode='bul'">Bulgarian</xsl:when>
			<xsl:when test="$languageCode='mya'">Burmese</xsl:when>
			<xsl:when test="$languageCode='cat'">Catalan</xsl:when>
			<xsl:when test="$languageCode='cha'">Chamorro</xsl:when>
			<xsl:when test="$languageCode='che'">Chechen</xsl:when>
			<xsl:when test="$languageCode='zho'">Chinese</xsl:when>
			<xsl:when test="$languageCode='chu'">Church Slavic</xsl:when>
			<xsl:when test="$languageCode='chv'">Chuvash</xsl:when>
			<xsl:when test="$languageCode='cor'">Cornish</xsl:when>
			<xsl:when test="$languageCode='cos'">Corsican</xsl:when>
			<xsl:when test="$languageCode='cre'">Cree</xsl:when>
			<xsl:when test="$languageCode='ces'">Czech</xsl:when>
			<xsl:when test="$languageCode='dan'">Danish</xsl:when>
			<xsl:when test="$languageCode='div'">Divehi</xsl:when>
			<xsl:when test="$languageCode='nld'">Dutch</xsl:when>
			<xsl:when test="$languageCode='dzo'">Dzongkha</xsl:when>
			<xsl:when test="$languageCode='eng'">English</xsl:when>
			
			<xsl:when test="$languageCode='en'">English</xsl:when> 		<!-- for older versions -->
			<xsl:when test="$languageCode='en-US'">English</xsl:when>	<!-- for older versions -->
			
			<xsl:when test="$languageCode='epo'">Esperanto</xsl:when>
			<xsl:when test="$languageCode='est'">Estonian</xsl:when>
			<xsl:when test="$languageCode='ewe'">Ewe</xsl:when>
			<xsl:when test="$languageCode='fao'">Faroese</xsl:when>
			<xsl:when test="$languageCode='fij'">Fijian</xsl:when>
			<xsl:when test="$languageCode='fin'">Finnish</xsl:when>
			<xsl:when test="$languageCode='fra'">French</xsl:when>
			<xsl:when test="$languageCode='fry'">Western Frisian</xsl:when>
			<xsl:when test="$languageCode='ful'">Fulah</xsl:when>
			<xsl:when test="$languageCode='kat'">Georgian</xsl:when>
			<xsl:when test="$languageCode='deu'">German</xsl:when>
			<xsl:when test="$languageCode='gla'">Gaelic</xsl:when>
			<xsl:when test="$languageCode='gle'">Irish</xsl:when>
			<xsl:when test="$languageCode='glg'">Galician</xsl:when>
			<xsl:when test="$languageCode='glv'">Manx</xsl:when>
			<xsl:when test="$languageCode='ell'">Greek</xsl:when>
			<xsl:when test="$languageCode='grn'">Guarani</xsl:when>
			<xsl:when test="$languageCode='guj'">Gujarati</xsl:when>
			<xsl:when test="$languageCode='hat'">Haitian</xsl:when>
			<xsl:when test="$languageCode='hau'">Hausa</xsl:when>
			<xsl:when test="$languageCode='heb'">Hebrew</xsl:when>
			<xsl:when test="$languageCode='her'">Herero</xsl:when>
			<xsl:when test="$languageCode='hin'">Hindi</xsl:when>
			<xsl:when test="$languageCode='hmo'">Hiri Motu</xsl:when>
			<xsl:when test="$languageCode='hrv'">Croatian</xsl:when>
			<xsl:when test="$languageCode='hun'">Hungarian</xsl:when>
			<xsl:when test="$languageCode='ibo'">Igbo</xsl:when>
			<xsl:when test="$languageCode='isl'">Icelandic</xsl:when>
			<xsl:when test="$languageCode='ido'">Ido</xsl:when>
			<xsl:when test="$languageCode='iii'">Sichuan Yi</xsl:when>
			<xsl:when test="$languageCode='iku'">Inuktitut</xsl:when>
			<xsl:when test="$languageCode='ile'">Interlingue</xsl:when>
			<xsl:when test="$languageCode='ina'">Interlingua</xsl:when>
			<xsl:when test="$languageCode='ind'">Indonesian</xsl:when>
			<xsl:when test="$languageCode='ipk'">Inupiaq</xsl:when>
			<xsl:when test="$languageCode='ita'">Italian</xsl:when>
			<xsl:when test="$languageCode='jav'">Javanese</xsl:when>
			<xsl:when test="$languageCode='jpn'">Japanese</xsl:when>
			<xsl:when test="$languageCode='kal'">Kalaallisut</xsl:when>
			<xsl:when test="$languageCode='kan'">Kannada</xsl:when>
			<xsl:when test="$languageCode='kas'">Kashmiri</xsl:when>
			<xsl:when test="$languageCode='kau'">Kanuri</xsl:when>
			<xsl:when test="$languageCode='kaz'">Kazakh</xsl:when>
			<xsl:when test="$languageCode='khm'">Khmer</xsl:when>
			<xsl:when test="$languageCode='kik'">Kikuyu</xsl:when>
			<xsl:when test="$languageCode='kin'">Kinyarwanda</xsl:when>
			<xsl:when test="$languageCode='kir'">Kirghiz</xsl:when>
			<xsl:when test="$languageCode='kom'">Komi</xsl:when>
			<xsl:when test="$languageCode='kon'">Kongo</xsl:when>
			<xsl:when test="$languageCode='kor'">Korean</xsl:when>
			<xsl:when test="$languageCode='kua'">Kuanyama</xsl:when>
			<xsl:when test="$languageCode='kur'">Kurdish</xsl:when>
			<xsl:when test="$languageCode='lao'">Lao</xsl:when>
			<xsl:when test="$languageCode='lat'">Latin</xsl:when>
			<xsl:when test="$languageCode='lav'">Latvian</xsl:when>
			<xsl:when test="$languageCode='lim'">Limburgan</xsl:when>
			<xsl:when test="$languageCode='lin'">Lingala</xsl:when>
			<xsl:when test="$languageCode='lit'">Lithuanian</xsl:when>
			<xsl:when test="$languageCode='ltz'">Luxembourgish</xsl:when>
			<xsl:when test="$languageCode='lub'">Luba-Katanga</xsl:when>
			<xsl:when test="$languageCode='lug'">Ganda</xsl:when>
			<xsl:when test="$languageCode='mkd'">Macedonian</xsl:when>
			<xsl:when test="$languageCode='mah'">Marshallese</xsl:when>
			<xsl:when test="$languageCode='mal'">Malayalam</xsl:when>
			<xsl:when test="$languageCode='mri'">Maori</xsl:when>
			<xsl:when test="$languageCode='mar'">Marathi</xsl:when>
			<xsl:when test="$languageCode='msa'">Malay</xsl:when>
			<xsl:when test="$languageCode='mlg'">Malagasy</xsl:when>
			<xsl:when test="$languageCode='mlt'">Maltese</xsl:when>
			<xsl:when test="$languageCode='mon'">Mongolian</xsl:when>
			<xsl:when test="$languageCode='nau'">Nauru</xsl:when>
			<xsl:when test="$languageCode='nav'">Navajo</xsl:when>
			<xsl:when test="$languageCode='nbl'">Ndebele, South</xsl:when>
			<xsl:when test="$languageCode='nde'">Ndebele, North</xsl:when>
			<xsl:when test="$languageCode='ndo'">Ndonga</xsl:when>
			<xsl:when test="$languageCode='nep'">Nepali</xsl:when>
			<xsl:when test="$languageCode='nno'">Norwegian Nynorsk</xsl:when>
			<xsl:when test="$languageCode='nob'">Bokmål, Norwegian</xsl:when>
			<xsl:when test="$languageCode='nor'">Norwegian</xsl:when>
			<xsl:when test="$languageCode='nya'">Chichewa</xsl:when>
			<xsl:when test="$languageCode='oci'">Occitan (post 1500)</xsl:when>
			<xsl:when test="$languageCode='oji'">Ojibwa</xsl:when>
			<xsl:when test="$languageCode='ori'">Oriya</xsl:when>
			<xsl:when test="$languageCode='orm'">Oromomaffia</xsl:when>
			<xsl:when test="$languageCode='oss'">Ossetian</xsl:when>
			<xsl:when test="$languageCode='pan'">Panjabi</xsl:when>
			<xsl:when test="$languageCode='fas'">Persian</xsl:when>
			<xsl:when test="$languageCode='pli'">Pali</xsl:when>
			<xsl:when test="$languageCode='pol'">Polish</xsl:when>
			<xsl:when test="$languageCode='por'">Portuguese</xsl:when>
			<xsl:when test="$languageCode='pus'">Pushto</xsl:when>
			<xsl:when test="$languageCode='que'">Quechua</xsl:when>
			<xsl:when test="$languageCode='roh'">Romansh</xsl:when>
			<xsl:when test="$languageCode='ron'">Romanian</xsl:when>
			<xsl:when test="$languageCode='run'">Rundi</xsl:when>
			<xsl:when test="$languageCode='rus'">Russian</xsl:when>
			<xsl:when test="$languageCode='sag'">Sango</xsl:when>
			<xsl:when test="$languageCode='san'">Sanskrit</xsl:when>
			<xsl:when test="$languageCode='sin'">Sinhala</xsl:when>
			<xsl:when test="$languageCode='slk'">Slovak</xsl:when>
			<xsl:when test="$languageCode='slv'">Slovenian</xsl:when>
			<xsl:when test="$languageCode='sme'">Northern Sami</xsl:when>
			<xsl:when test="$languageCode='smo'">Samoan</xsl:when>
			<xsl:when test="$languageCode='sna'">Shona</xsl:when>
			<xsl:when test="$languageCode='snd'">Sindhi</xsl:when>
			<xsl:when test="$languageCode='som'">Somali</xsl:when>
			<xsl:when test="$languageCode='sot'">Sotho, Southern</xsl:when>
			<xsl:when test="$languageCode='spa'">Spanish</xsl:when>
			<xsl:when test="$languageCode='srd'">Sardinian</xsl:when>
			<xsl:when test="$languageCode='srp'">Serbian</xsl:when>
			<xsl:when test="$languageCode='ssw'">Swati</xsl:when>
			<xsl:when test="$languageCode='sun'">Sundanese</xsl:when>
			<xsl:when test="$languageCode='swa'">Swahili</xsl:when>
			<xsl:when test="$languageCode='swe'">Swedish</xsl:when>
			<xsl:when test="$languageCode='tah'">Tahitian</xsl:when>
			<xsl:when test="$languageCode='tam'">Tamil</xsl:when>
			<xsl:when test="$languageCode='tat'">Tatar</xsl:when>
			<xsl:when test="$languageCode='tel'">Telugu</xsl:when>
			<xsl:when test="$languageCode='tgk'">Tajik</xsl:when>
			<xsl:when test="$languageCode='tgl'">Tagalog</xsl:when>
			<xsl:when test="$languageCode='tha'">Thai</xsl:when>
			<xsl:when test="$languageCode='bod'">Tibetan</xsl:when>
			<xsl:when test="$languageCode='tir'">Tigrinya</xsl:when>
			<xsl:when test="$languageCode='ton'">Tonga (Tonga Islands)</xsl:when>
			<xsl:when test="$languageCode='tsn'">Tswana</xsl:when>
			<xsl:when test="$languageCode='tso'">Tsonga</xsl:when>
			<xsl:when test="$languageCode='tuk'">Turkmen</xsl:when>
			<xsl:when test="$languageCode='tur'">Turkish</xsl:when>
			<xsl:when test="$languageCode='twi'">Twi</xsl:when>
			<xsl:when test="$languageCode='uig'">Uighur</xsl:when>
			<xsl:when test="$languageCode='ukr'">Ukrainian</xsl:when>
			<xsl:when test="$languageCode='urd'">Urdu</xsl:when>
			<xsl:when test="$languageCode='uzb'">Uzbek</xsl:when>
			<xsl:when test="$languageCode='ven'">Venda</xsl:when>
			<xsl:when test="$languageCode='vie'">Vietnamese</xsl:when>
			<xsl:when test="$languageCode='vol'">Volapük</xsl:when>
			<xsl:when test="$languageCode='cym'">Welsh</xsl:when>
			<xsl:when test="$languageCode='wln'">Walloon</xsl:when>
			<xsl:when test="$languageCode='wol'">Wolof</xsl:when>
			<xsl:when test="$languageCode='xho'">Xhosa</xsl:when>
			<xsl:when test="$languageCode='yid'">Yiddish</xsl:when>
			<xsl:when test="$languageCode='yor'">Yoruba</xsl:when>
			<xsl:when test="$languageCode='zha'">Zhuang</xsl:when>
			<xsl:when test="$languageCode='zul'">Zulu</xsl:when>
			<xsl:when test="$languageCode='sgn'">Sign</xsl:when>
			<xsl:when test="$languageCode='sgn'">Sign Language</xsl:when>
			<xsl:when test="$languageCode='cpf'">French Creole</xsl:when>
			<xsl:when test="$languageCode='hmn'">Hmong</xsl:when>
			<xsl:when test="$languageCode='fil'">Filipino</xsl:when>
			<xsl:otherwise>
				code: <xsl:value-of select="$languageCode"/>
			</xsl:otherwise>
		</xsl:choose>
		</span>
	</xsl:template>

</xsl:stylesheet>
