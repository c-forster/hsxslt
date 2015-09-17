all:
	java -jar ~/SaxonHE9-5-1-6J/saxon9he.jar -ext:on harlem-shadows.tei.xml hsxslt.xsl
	mkdir -p temp/harlem-shadows
	for file in harlem-shadows/*.html; do smartypants $$file > temp/$$file; done
	mv temp/harlem-shadows/*.html harlem-shadows
	rm -rf temp




