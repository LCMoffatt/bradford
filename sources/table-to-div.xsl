<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">

    <xsl:output method="xml" indent="yes"/>

    <!-- Identity: copy everything by default -->
    <xsl:template match="@* | node()">
        <xsl:copy>
                <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- For any TEI element that contains table/p runs, regroup children in-place -->
    <xsl:template match="tei:*[tei:table or tei:p]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
             
            <!-- Walk all child nodes in document order, forming groups that start at tei:table -->
            <xsl:for-each-group select="node()" group-starting-with="tei:table">
                <xsl:choose>
                    <!-- A group that begins with a table becomes one div -->
                    <xsl:when test="self::tei:table">
                        <!-- head: first cell of first row -->
                        <person>
                            <!-- stable per-document numbering of tables -->
                            <xsl:attribute name="xml:id">
                                <xsl:text>grp-</xsl:text>
                                <xsl:number level="any" count="tei:table"/>
                            </xsl:attribute>
                            
                            <name>
                                <xsl:value-of
                                    select="normalize-space(current-group()[1]//tei:row[1]/tei:cell[1])"/>
                            </name>
                            <floruit>
                                <xsl:value-of
                                    select="normalize-space(current-group()[1]//tei:row[1]/tei:cell[2])"
                                />
                            </floruit>
                            <!-- include only the paragraphs that belong to this group -->
                            <xsl:apply-templates
                                select="current-group()[position() gt 1][self::tei:p]"/>
                        </person>

                    </xsl:when>
                    

                    <!-- Any group not starting with a table: just process its nodes normally -->
                    <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
