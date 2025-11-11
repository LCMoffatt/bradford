<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:my="urn:my-functions" exclude-result-prefixes="tei xs my">

    <xsl:output method="html" indent="yes"/>
    <xsl:param name="outdir" select="'out'"/>
    <!-- output directory -->

    <!-- ===== Helpers ===== -->

    <!-- Prefer @xml:id; else fallback string -->
    <xsl:template name="choose-id">
        <xsl:param name="node"/>
        <xsl:param name="fallback"/>
        <xsl:sequence select="
                if ($node/@xml:id) then
                    string($node/@xml:id)
                else
                    $fallback"/>
    </xsl:template>

    <!-- Make a filesystem-safe, lowercase filename stem from a string -->
    <xsl:function name="my:safe-stem" as="xs:string">
        <xsl:param name="s" as="xs:string"/>
        <!-- collapse whitespace -> single dash; strip non-word chars; force lowercase -->
        <xsl:variable name="t1" select="normalize-space($s)"/>
        <xsl:variable name="t2" select="replace($t1, '\s+', '-')"/>
        <xsl:variable name="t3" select="replace($t2, '[^A-Za-z0-9\-_]+', '-')"/>
        <xsl:sequence select="lower-case($t3)"/>
    </xsl:function>

    <!-- Get listPerson display title -->
    <xsl:function name="my:list-title" as="xs:string">
        <xsl:param name="lp" as="element(tei:listPerson)"/>
        <xsl:sequence select="string(($lp/tei:head, 'List of Persons')[1])"/>
    </xsl:function>

    <!-- Person ID fallback (global serial) -->
    <xsl:function name="my:person-fallback-id" as="xs:string">
        <xsl:param name="p" as="element(tei:person)"/>
        <xsl:sequence
            select="concat('person-', format-number(count($p/preceding::tei:person) + 1, '0000'))"/>
    </xsl:function>

    <!-- ===== Entry point: produce multiple documents ===== -->
    <xsl:template match="/">

        <!-- 1) Global index page of all persons -->
        <xsl:result-document href="{$outdir}/index.html" method="html">
            <html>
                <head>
                    <meta charset="utf-8"/>
                    <title>
                        <xsl:value-of select="(//tei:titleStmt/tei:title)[1]"/>
                        <xsl:text> — Index of Persons</xsl:text>
                    </title>
                    <style>
                        body {
                            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                            line-height: 1.45;
                            margin: 2rem
                        }
                        h1 {
                            margin-top: 0
                        }
                        h2 {
                            margin-top: 2rem;
                            border-bottom: 1px solid #ddd;
                            padding-bottom: .25rem
                        }
                        ul {
                            margin: .5rem 0 1rem
                        }
                        .meta {
                            color: #555;
                            font-size: .9rem
                        }
                        .date {
                            font-style: italic
                        }
                        .toc a {
                            text-decoration: none
                        }</style>
                </head>
                <body>
                    <h1>Index of Persons</h1>
                    <p class="meta"> Generated from TEI: <xsl:value-of select="document-uri(/)"/>
                    </p>

                    <xsl:for-each select="//tei:listPerson">
                        <!-- position among lists for fallback -->
                        <xsl:variable name="list-pos" select="count(preceding::tei:listPerson) + 1"/>

                        <!-- prefer @xml:id; else listperson-<n> -->
                        <xsl:variable name="list-stem" select="
                                if (@xml:id)
                                then
                                    @xml:id
                                else
                                    concat('listperson-', $list-pos)"/>

                        <xsl:variable name="file" select="concat($list-stem, '.html')"/>

                        <h2>
                            <a href="{$file}">
                                <xsl:value-of select="my:list-title(.)"/>
                            </a>
                        </h2>

                        <!-- mini index for persons in this list -->
                        <ul>
                            <xsl:for-each select="tei:person">
                                <xsl:variable name="pid">
                                    <xsl:call-template name="choose-id">
                                        <xsl:with-param name="node" select="."/>
                                        <xsl:with-param name="fallback"
                                            select="my:person-fallback-id(.)"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <li>
                                    <a href="{$file}#{ $pid }">
                                        <xsl:value-of select="normalize-space(string(tei:name))"/>
                                    </a>
                                    <xsl:if test="tei:floruit">
                                        <span class="date"> — <xsl:value-of
                                                select="normalize-space(string(tei:floruit))"
                                            /></span>
                                    </xsl:if>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:for-each>
                </body>
            </html>
        </xsl:result-document>

        <!-- 2) One page per listPerson -->
        <xsl:apply-templates select="//tei:listPerson" mode="emit-list-page"/>

    </xsl:template>

    <!-- ===== Emit each list page ===== -->
    <xsl:template match="tei:listPerson" mode="emit-list-page">
        <xsl:variable name="list-pos" select="count(preceding::tei:listPerson) + 1"/>

        <xsl:variable name="list-id">
            <xsl:call-template name="choose-id">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="fallback" select="concat('listPerson-', $list-pos)"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="list-title" select="string((tei:head, concat('List ', $list-pos))[1])"/>


        <xsl:variable name="list-stem" select="
                if (@xml:id)
                then
                    my:safe-stem(@xml:id)
                else
                    if (normalize-space(tei:head))
                    then
                        my:safe-stem(tei:head)
                    else
                        concat('listperson-', $list-pos)"/>
        <xsl:variable name="file" select="concat($list-stem, '.html')"/>

        <xsl:result-document href="{$outdir}/{$file}" method="html">
            <html>
                <head>
                    <meta charset="utf-8"/>
                    <title>
                        <xsl:value-of select="$list-title"/>
                    </title>
                    <style>
                        body {
                            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                            line-height: 1.5;
                            margin: 2rem
                        }
                        a {
                            text-decoration: none
                        }
                        .topnav {
                            margin-bottom: 1.5rem
                        }
                        h2 {
                            margin-top: 0;
                            border-bottom: 1px solid #ddd;
                            padding-bottom: .25rem
                        }
                        h3 {
                            margin: 1.25rem 0 .25rem
                        }
                        p.date {
                            margin: .1rem 0 .4rem;
                            font-style: italic
                        }
                        ul.notes {
                            margin: .25rem 0 1rem
                        }
                        .toc {
                            margin: .75rem 0 1.25rem;
                            padding: .75rem;
                            background: #f7f7f7;
                            border-radius: .5rem
                        }
                        .toc h4 {
                            margin: .25rem 0 .5rem;
                            font-size: 1rem
                        }</style>
                </head>
                <body>
                    <div class="topnav">
                        <a href="index.html">← Back to Index</a>
                    </div>

                    <!-- Header -->
                    <h2 id="{$list-id}">
                        <xsl:value-of select="$list-title"/>
                    </h2>

                    <!-- Per-page mini TOC of persons -->
                    <div class="toc">
                        <h4>People in this list</h4>
                        <ul>
                            <xsl:for-each select="tei:person">
                                <xsl:variable name="pid">
                                    <xsl:call-template name="choose-id">
                                        <xsl:with-param name="node" select="."/>
                                        <xsl:with-param name="fallback"
                                            select="my:person-fallback-id(.)"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <li>
                                    <a href="#{$pid}">
                                        <xsl:value-of select="normalize-space(string(tei:name))"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>

                    <!-- Render persons -->
                    <xsl:apply-templates select="tei:person" mode="render-person"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <!-- ===== Person rendering (same rules as before) ===== -->
    <xsl:template match="tei:person" mode="render-person">
        <xsl:variable name="pid">
            <xsl:call-template name="choose-id">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="fallback" select="my:person-fallback-id(.)"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- name -> h3 -->
        <xsl:if test="tei:name">
            <h3 id="{$pid}">
                <xsl:apply-templates select="tei:name/node()" mode="inline"/>
            </h3>
        </xsl:if>

        <!-- floruit -> p.date -->
        <xsl:if test="tei:floruit">
            <p class="date">
                <xsl:apply-templates select="tei:floruit/node()" mode="inline"/>
            </p>
        </xsl:if>

        <!-- notes -> ul/li -->
        <xsl:if test="tei:note">
            <ul class="notes">
                <xsl:for-each select="tei:note">
                    <li>
                        <xsl:apply-templates select="node()" mode="inline"/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <hr />
    </xsl:template>

    <!-- ===== Inline handling (preserve superscripts) ===== -->
    <xsl:template match="tei:hi[@rend = ('superscript', 'sup')]" mode="inline">
        <sup>
            <xsl:apply-templates mode="inline"/>
        </sup>
    </xsl:template>

    <!-- Fallback for other hi: wrap as span class="rend" -->
    <xsl:template match="tei:hi" mode="inline">
        <span>
            <xsl:if test="@rend">
                <xsl:attribute name="class" select="@rend"/>
            </xsl:if>
            <xsl:apply-templates mode="inline"/>
        </span>
    </xsl:template>

    <!-- Copy text in inline mode -->
    <xsl:template match="text()" mode="inline">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>
