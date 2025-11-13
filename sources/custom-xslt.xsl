<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">
    
    <xsl:output method="html" indent="yes"/>
    <xsl:param name="outdir" select="'out'"/>
    
    <!-- ===== Simple utility: choose id or fallback ===== -->
    <xsl:template name="choose-id">
        <xsl:param name="node"/>
        <xsl:param name="fallback"/>
        <xsl:sequence select="if ($node/@xml:id) then string($node/@xml:id) else $fallback"/>
    </xsl:template>
    
    <!-- ===== Entry point ===== -->
    <xsl:template match="/">
        
        <!-- === INDEX PAGE === -->
        <xsl:result-document href="{$outdir}/index.html" method="html">
            <html lang="en">
                <head>
                    <meta charset="utf-8"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <title>Prosopography of the Lacedaemonians — Index</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
                </head>
                <body>
                    <!-- Navbar -->
                    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
                        <div class="container-fluid">
                            <a class="navbar-brand" href="index.html">Prosopography of the Lacedaemonians</a>
                        </div>
                    </nav>
                    
                    <div class="container">
                        <div class="px-4 py-3 my-3 text-center">
                            <h1 class="display-5 fw-bold text-body-emphasis">A Prosopography of Lacedaemonians</h1>
                            <div class="col-lg-6 mx-auto">
                                <p class="lead mb-4">A digital version of <em>A Prosopography of Lacedaemonians from the Death of Alexander the
                                        Great, 323 B.C., to the Sack of Sparta by Alaric, A.D.
                                        396</em>, by Alfred S. Bradford (C. H. Beck, 1977).</p>
                                <p>Revised and updated.</p>
                                <p>This site was created from a TEI XML source. The source and XSLT stylesheets are available at <a href="https://github.com/sjhuskey/bradford">https://github.com/sjhuskey/bradford</a>.</p>
                                <div class="d-grid gap-2 d-sm-flex justify-content-sm-center"> <a href="about.html"><button type="button"
                                            class="btn btn-primary btn-lg px-4 gap-3">About</button></a></div>
                            </div>
                        </div>
                        <h1 class="mb-4">Index of Lists</h1>
                        <table class="table table-striped table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Greek Letter</th>
                                    <th>Link</th>
                                    <th>Number of Persons</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="//tei:listPerson">
                                    <xsl:variable name="id" select="@xml:id"/>
                                    <xsl:variable name="count" select="count(tei:person)"/>
                                    <tr>
                                        <td><xsl:value-of select="normalize-space(tei:head)"/></td>
                                        <td><a href="{$id}.html"><xsl:value-of select="@xml:id"/></a></td>
                                        <td><xsl:value-of select="$count"/></td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                    <footer class="footer mt-auto py-3 bg-body-tertiary">
                        <div class="container"> <span class="text-body-secondary">© 2025 Steve Bradford.</span> </div>
                    </footer>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"/>
                </body>
            </html>
        </xsl:result-document>
        
        <!-- === ONE PAGE PER LIST === -->
        <xsl:apply-templates select="//tei:listPerson" mode="emit-page"/>
    </xsl:template>
    
    <!-- ===== Each listPerson page ===== -->
    <xsl:template match="tei:listPerson" mode="emit-page">
        <xsl:variable name="id"     select="@xml:id"/>
        <xsl:variable name="title"  select="string((tei:head, concat('List ', position()))[1])"/>
        <xsl:variable name="outfile" select="concat($outdir, '/', $id, '.html')"/>
        
        <!-- prev / next neighbors in document order -->
        <xsl:variable name="prev" select="(preceding::tei:listPerson)[last()]"/>
        <xsl:variable name="next" select="(following::tei:listPerson)[1]"/>
        <xsl:variable name="prev-id" select="string($prev/@xml:id)"/>
        <xsl:variable name="next-id" select="string($next/@xml:id)"/>
        <xsl:variable name="prev-title" select="string(($prev/tei:head, 'Prev')[1])"/>
        <xsl:variable name="next-title" select="string(($next/tei:head, 'Next')[1])"/>
        
        <xsl:result-document href="{$outfile}" method="html">
            <html lang="en">
                <head>
                    <meta charset="utf-8"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <title>
                        <xsl:value-of select="$title"/>
                        <xsl:text> — Prosopography of the Lacedaemonians</xsl:text>
                    </title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
                    <style>
                        body { padding-bottom: 3rem; }
                        h2 { margin-top: 1rem; }
                        h3 { margin-top: 1rem; }
                        .date { font-style: italic; }
                        ul.notes { margin-bottom: 1rem; }
                        .inline-graphic { vertical-align: middle; margin: 0 .25rem; }
                        .nav-prevnext { margin: 1.5rem 0; }
                    </style>
                </head>
                <body>
                    <!-- Navbar -->
                    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
                        <div class="container-fluid">
                            <a class="navbar-brand" href="index.html">Prosopography of the Lacedaemonians</a>
                        </div>
                    </nav>
                    
                    <div class="container">
                        <h2 id="{$id}">
                            <xsl:value-of select="$title"/>
                        </h2>
                        
                        <!-- Mini TOC -->
                        <div class="list-group my-3">
                            <xsl:for-each select="tei:person">
                                <xsl:variable name="pid">
                                    <xsl:call-template name="choose-id">
                                        <xsl:with-param name="node" select="."/>
                                        <xsl:with-param name="fallback" select="concat('person-', position())"/>
                                    </xsl:call-template>
                                </xsl:variable>
                                <a href="#{$pid}" class="list-group-item list-group-item-action">
                                    <xsl:value-of select="normalize-space(string(tei:name))"/>
                                </a>
                            </xsl:for-each>
                        </div>
                        
                        <!-- Persons -->
                        <xsl:apply-templates select="tei:person" mode="render-person"/>
                        
                        <!-- Prev/Next buttons -->
                        <div class="nav-prevnext d-flex justify-content-between">
                            <div>
                                <xsl:choose>
                                    <xsl:when test="$prev">
                                        <a class="btn btn-outline-primary" href="{$prev-id}.html">←
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="$prev-title"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="btn btn-outline-secondary disabled">← Previous</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div>
                                <xsl:choose>
                                    <xsl:when test="$next">
                                        <a class="btn btn-outline-primary" href="{$next-id}.html">
                                            <xsl:value-of select="$next-title"/>
                                            <xsl:text> </xsl:text>→
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="btn btn-outline-secondary disabled">Next →</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                        </div>
                    </div>
                    <footer class="footer mt-auto py-3 bg-body-tertiary">
                        <div class="container"> <span class="text-body-secondary">© 2025 Steve Bradford.</span> </div>
                    </footer>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- ===== Render a person ===== -->
    <xsl:template match="tei:person" mode="render-person">
        <xsl:variable name="pid">
            <xsl:call-template name="choose-id">
                <xsl:with-param name="node" select="."/>
                <xsl:with-param name="fallback" select="concat('person-', position())"/>
            </xsl:call-template>
        </xsl:variable>
        
        <div class="border-bottom pb-2 mb-3">
            <h3 id="{$pid}">
                <xsl:apply-templates select="tei:name/node()" mode="inline"/>
            </h3>
            
            <xsl:if test="tei:floruit">
                <p class="date">
                    <xsl:apply-templates select="tei:floruit/node()" mode="inline"/>
                </p>
            </xsl:if>
            
            <xsl:if test="tei:note">
                <ul class="notes">
                    <xsl:for-each select="tei:note">
                        <li><xsl:apply-templates select="node()" mode="inline"/></li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </div>
    </xsl:template>
    
    <!-- ===== Inline markup ===== -->
    
    <!-- Superscripts -->
    <xsl:template match="tei:hi[@rend=('superscript','sup')]" mode="inline">
        <sup><xsl:apply-templates mode="inline"/></sup>
    </xsl:template>
    
    <!-- Other hi -->
    <xsl:template match="tei:hi" mode="inline">
        <span class="{@rend}"><xsl:apply-templates mode="inline"/></span>
    </xsl:template>
    
    <!-- Inline graphic (e.g., inside note) -->
    <xsl:template match="tei:graphic" mode="inline">
        <xsl:variable name="src" select="string(@url)"/>
        <xsl:variable name="alt" select="normalize-space(string(tei:desc))"/>
        <!-- Preserve width/height if present (units can be cm, px, etc.) -->
        <xsl:variable name="w" select="normalize-space(@width)"/>
        <xsl:variable name="h" select="normalize-space(@height)"/>
        
        <img class="inline-graphic">
            <xsl:attribute name="src" select="$src"/>
            <xsl:if test="$alt != ''">
                <xsl:attribute name="alt" select="$alt"/>
                <xsl:attribute name="title" select="$alt"/>
            </xsl:if>
            
            <!-- Prefer explicit width/height CSS so we don’t distort line height -->
            <xsl:if test="$w or $h">
                <xsl:attribute name="style">
                    <xsl:value-of select="concat(
                        $w  ! concat('width: ' , ., '; '),
                        $h  ! concat('height: ', ., '; ')
                        )"/>
                </xsl:attribute>
            </xsl:if>
        </img>
    </xsl:template>
    
    <!-- Copy text in inline mode -->
    <xsl:template match="text()" mode="inline">
        <xsl:value-of select="."/>
    </xsl:template>
    
</xsl:stylesheet>
