all:
	# html
	java -jar ~/SaxonHE9-5-1-6J/saxon9he.jar -ext:on harlem-shadows.tei.xml hsxslt.xsl
	# temp directory and "smartypants" to get smart quotation marks in html
	mkdir -p temp/harlem-shadows
	for file in harlem-shadows/*.html; do smartypants $$file > temp/$$file; done
	mv temp/harlem-shadows/*.html harlem-shadows
	# Now, do .txt output
	mkdir -p temp/text
	java -jar ~/SaxonHE9-5-1-6J/saxon9he.jar -ext:on harlem-shadows.tei.xml hs-text.xsl
	for file in text/*.txt; do ./reformatLines.py $$file > temp/$$file; done
	rm text/*
	mv temp/text/*.txt text/
	rm -rf temp
	# Now, do LaTeX
	java -jar ~/SaxonHE9-5-1-6J/saxon9he.jar -ext:on harlem-shadows.tei.xml hs-latex.xsl
	# Make Latex... but it takes forever
	# cd latex; latekmk -f lualatex
	# Now TEI
	java -jar ~/SaxonHE9-5-1-6J/saxon9he.jar -ext:on harlem-shadows.tei.xml hs-tei.xsl
	# Now copy everything
	cp -r text harlem-shadows
	cp -r tei harlem-shadows
	cp -r pdf harlem-shadows
	# Bundle ZIPs.




