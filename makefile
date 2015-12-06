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




