<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:dbk="http://docbook.org/ns/docbook"
  xmlns:css="http://www.w3.org/1996/css" 
  xmlns:hub="http://transpect.io/hub"
  xmlns:mml="http://www.w3.org/1998/Math/MathML" 
  xmlns:tr="http://transpect.io"
  xmlns:docx2tex="http://transpect.io/docx2tex"
  xmlns:xml2tex="http://transpect.io/xml2tex"
  xmlns:mml2tex="http://transpect.io/mml2tex"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"   
  xmlns="http://docbook.org/ns/docbook"
  version="2.0" 
  exclude-result-prefixes="#all"
  xpath-default-namespace="http://docbook.org/ns/docbook">
  
  <xsl:include href="http://transpect.io/mml2tex/xsl/mml2tex.xsl"/>
  
  <!--  *
        * MODE docx2tex-preprocess
        * -->
  
  <xsl:template match="@fileref" mode="docx2tex-preprocess">
    <xsl:variable name="fileref" 
                  select="if(matches(., '^container:'))
                          then tr:uri-to-relative-path(/hub/info/keywordset/keyword[@role eq 'source-dir-uri'],
                                                       concat(/hub/info/keywordset/keyword[@role eq 'source-dir-uri'], replace(., 'container:', '/')))
                          else ."/>
    <xsl:attribute name="fileref" select="$fileref"/>
  </xsl:template>
  
  <!-- dissolve pseudo tables frequently used for numbered equations -->
  
  <xsl:variable name="equation-label-regex" select="'^[\(\[]((\d+)(\.\d+)*)[\)\]]?$'" as="xs:string"/>
  
  <xsl:template match="informaltable[every $i in .//row 
                                     satisfies count($i/entry) = (2,3) 
                                               and $i/entry[matches(normalize-space(.), $equation-label-regex)
                                               or equation/processing-instruction()[name() eq 'latex'][matches(., '^\s*\\tag')]]
                                               and (($i/entry/para/equation|$i/entry/para/phrase/equation) 
                                                    or ($i/entry/para/equation and $i/para[not(node())]))]" mode="docx2tex-preprocess">
    <!-- process equation in first row and write label -->
    <xsl:for-each select=".//row">
      <xsl:variable name="label" select="(entry[matches(normalize-space(.), $equation-label-regex)],
                                          entry[processing-instruction()[name() eq 'latex'][matches(., '^\\tag')]])[1]" as="element(entry)"/>
      <xsl:apply-templates select="entry/* except $label/*" mode="#current">
        <xsl:with-param name="label" select="concat('\tag{', replace(normalize-space(string-join($label, '')), $equation-label-regex, '$1'), '}&#xa;')" 
                        tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="equation" mode="docx2tex-preprocess">
    <xsl:param name="label" tunnel="yes"/>
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:if test="string-length($label) gt 1">
        <xsl:attribute name="condition" select="'numbered'"/>
        <xsl:processing-instruction name="latex" select="$label"/>
      </xsl:if>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="entry/para[matches(normalize-space(string-join((.//text()), '')), $equation-label-regex)]
                                 [ancestor::row//equation or ancestor::row/inlineequation]" mode="docx2tex-preprocess">
    <xsl:processing-instruction name="latex" 
                                select="concat('\tag{', 
                                               normalize-space(string-join((.//text()), ''))[matches(., $equation-label-regex)],
                                               '}')"/>
  </xsl:template>
  
  <!-- drop empty equations -->
  
  <xsl:template match="equation[not(node() except @*)]
                      |equation[mml:math[not(node() except @*)] and not(normalize-space(.))]
                      |equation[mml:math[not(node() except @*)] and not(node() except @*)]
                      |inlineequation[not(node() except @*)]
                      |inlineequation[mml:math[not(node() except @*)] and not(normalize-space(.))]" mode="docx2tex-preprocess"/>
  
  <!-- move whitespace at the beginning or end of an equation in the regular text since they would be trimmed during whitespace normalization -->
  
  <xsl:template match="inlineequation[mml:math[*[1][self::mml:mtext[. eq ' ']]
                       or *[last()][self::mml:mtext[. eq ' ']]]]" mode="docx2tex-postprocess">
    <xsl:if test="mml:math/*[1][self::mml:mtext[. eq ' ']]">
      <phrase xml:space="preserve"> </phrase>
    </xsl:if>
    <xsl:copy-of select="."/>
    <xsl:if test="mml:math/*[last()][self::mml:mtext[. eq ' ']]">
      <phrase xml:space="preserve"> </phrase>
    </xsl:if>
  </xsl:template>
  
  <!-- paragraph contains only inlineequation, tabs and an equation label -->
  
  <xsl:template match="para[.//inlineequation and */local-name() = ('inlineequation', 'tab', 'phrase')]
                           [count(distinct-values(*/local-name())) &lt;= 3]
                           [matches(normalize-space(string-join((.//text()[not(ancestor::inlineequation)]), '')), $equation-label-regex)]" mode="docx2tex-preprocess">
    <equation condition="numbered">
      <xsl:processing-instruction name="latex" 
                                  select="concat('\tag{',
                                                 replace(string-join((text(), phrase/text()), ''), 
                                                         $equation-label-regex, 
                                                         '$1'),
                                                '}&#xa;')"/>
      <xsl:apply-templates select=".//inlineequation/*" mode="#current"/>
    </equation>
  </xsl:template>
  
  <xsl:template match="para[equation and count(distinct-values(*/local-name())) eq 1]" mode="docx2tex-preprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="blockquote[@role = 'hub:lists']" mode="docx2tex-preprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- remove each list which counts only one list item -->
  
  <xsl:variable name="texmap-override" select="document('http://transpect.io/mml2tex/texmap/texmap.xml')/xml2tex:set/xml2tex:charmap/xml2tex:char" as="element(xml2tex:char)+"/>
  
  <xsl:template match="orderedlist[count(*) eq 1][not(ancestor::orderedlist or ancestor::itemizedlist)]
                       |itemizedlist[count(*) eq 1][not(ancestor::orderedlist  or ancestor::itemizedlist)]" mode="docx2tex-preprocess">
    <xsl:if test="@mark">
      <xsl:processing-instruction name="latex" 
                                  select="if(string-length(@mark) eq 1) 
                                          then concat('$', string-join(mml2tex:utf2tex(@mark, (), $texmap-override), ''), '$ ') 
                                          else concat('$\', @mark, '$ ')"/>
    </xsl:if>
    <xsl:apply-templates select="listitem/node()" mode="move-list-item"/>
  </xsl:template>
  
  <xsl:template match="listitem/para[1]" mode="move-list-item">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="docx2tex-preprocess"/>
      <xsl:value-of select="if(parent::listitem/@override) then concat(parent::listitem/@override, '&#x20;') else ''"/>  
      <xsl:apply-templates mode="docx2tex-preprocess"/>
      <!-- add label -->
      <xsl:if test="parent::listitem/@override">
        <xsl:processing-instruction name="latex" select="concat('\label{mark-', parent::listitem/@override,'}')"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>
  
  <xsl:variable name="headline-paras" select="for $i in //para[@docx2tex:config eq 'headline'] return generate-id($i)" as="xs:string*"/>
  
  <xsl:template match="para[@docx2tex:config eq 'headline']" mode="docx2tex-preprocess">
    <xsl:copy>
      <xsl:apply-templates select="@*, node() except phrase[@role eq 'docx2tex:identifier']" mode="docx2tex-preprocess"/>
      <!-- add label -->
      <xsl:for-each select="phrase[@role = ('docx2tex:identifier', 'hub:identifier')][1]">
        <xsl:processing-instruction name="latex" select="concat('\label{mark-', (.[string-length() gt 0], 
                                                                                   index-of($headline-paras, generate-id(parent::*)))[1],'}')"/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="variablelist[count(*) eq 1]" mode="docx2tex-preprocess">
    <xsl:apply-templates select="varlistentry/term/node(), varlistentry/listitem/node()" mode="#current"/>
  </xsl:template>
    
  <!-- move leading and trailing whitespace out of phrase #13913 -->
  
  <xsl:template match="text()[parent::phrase][matches(., '^(\s+)?.+(\s+)?$')] (: leading or trailing whitespace :)
                             [string-length(normalize-space(.)) gt 0]
                             [not(following-sibling::text()[1][not(matches(., '^\s'))]) and 
                              not(preceding-sibling::text()[1][not(matches(., '\s$'))])]
                              [not(parent::phrase/@xml:space eq 'preserve')]" mode="docx2tex-preprocess">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <xsl:template match="phrase[matches(., '^(\s+)?.+(\s+)?$')][string-length(normalize-space(.)) gt 0]" mode="docx2tex-preprocess">
    <xsl:if test="matches(., '^\s+')">
      <xsl:value-of select="replace(., '^(\s+).+', '$1')"/>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
    <xsl:if test="matches(., '\s+$')">
      <xsl:value-of select="replace(., '.+(\s+)$', '$1')"/>
    </xsl:if>
  </xsl:template>
  
  <!-- remove phrase tags which contains only whitespace -->
  
  <xsl:template match="phrase[string-length(normalize-space(.)) eq 0][not(@role eq 'cr')]" mode="docx2tex-preprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="phrase[matches(., '^\s+$')]" mode="docx2tex-preprocess">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- remove empty paragraphs #13946 -->
  
  <xsl:template match="para[not(.//text()) or (every $i in .//text() satisfies matches($i, '^\s+$'))][not(* except tab)]" mode="docx2tex-preprocess"/>
  
  <!-- resolve carriage returns in empty paragraphs. the paragraph will cause a break as well #14306 -->
  
  <xsl:template match="para/phrase[position() eq last()]/phrase[@role eq 'cr'][position() eq last()][not(following-sibling::node())]" mode="docx2tex-preprocess"/>
  
  <xsl:template match="para/phrase[position() eq 1]/phrase[@role eq 'cr'][position() eq 1][not(preceding-sibling::node())]" mode="docx2tex-preprocess"/>
  
  <xsl:template match="para[not(.//text())]/phrase[position() eq 1 and position() eq last()]/phrase[@role eq 'cr']" mode="docx2tex-preprocess" priority="10"/>
  
  <xsl:template match="phrase[@role eq 'cr'][following-sibling::node()[1][self::phrase[@role eq 'cr']]]" mode="docx2tex-preprocess"/>
  
  <!-- drop unused anchors -->
  
  <xsl:template match="anchor[not(//link/@linkend = @xml:id)]" mode="docx2tex-preprocess"/>
  
  <!-- move anchors outside of block elements -->
  
  <xsl:template match="para[anchor][not(.//footnote)]" mode="docx2tex-preprocess">
    <xsl:copy>
      <xsl:apply-templates select="@*, node() except anchor" mode="#current"/>
      <xsl:apply-templates select="anchor" mode="#current"/>
    </xsl:copy>  
  </xsl:template>
    
  <!-- place footnote anchors inside of the footnote -->
  
  <xsl:template match="anchor[following-sibling::node()[1][local-name() eq 'footnote']]" mode="docx2tex-preprocess"/>
  
  <xsl:template match="footnote[preceding-sibling::node()[1][local-name() eq 'anchor']]" mode="docx2tex-preprocess">
    <xsl:copy>
      <xsl:copy-of select="preceding-sibling::node()[1][local-name() eq 'anchor']"/>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- wrap private use-content -->
  
  <xsl:template match="text()[matches(., '[&#xE000;-&#xF8FF;&#xF0000;-&#xFFFFF;&#x100000;-&#x10FFFF;]')]" mode="docx2tex-preprocess">
    <xsl:variable name="mml" select="boolean(parent::mml:*)"/>
     <xsl:analyze-string select="." regex="[&#xE000;-&#xF8FF;&#xF0000;-&#xFFFFF;&#x100000;-&#x10FFFF;]">
       <xsl:matching-substring>
         <phrase role="unicode-private-use">
           <xsl:value-of select="."/>
         </phrase>
       </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  
  <!-- preserve unmapped characters -->
  
  <xsl:template match="phrase[@role eq 'hub:ooxml-symbol'][not(.//dbk:*)]" mode="docx2tex-preprocess">
    <xsl:processing-instruction name="latex" select="concat('\', replace(@css:font-family, '\s', ''), '{', @annotations, '}')"/>
  </xsl:template>
  
  <xsl:template match="mml:math//phrase[@role eq 'unicode-private-use']" mode="docx2tex-postprocess">
    <xsl:processing-instruction name="latex" select="concat('\', replace(parent::*/@font-family, '\s', ''), '{', ., '}')"/>
  </xsl:template>
  
</xsl:stylesheet>
