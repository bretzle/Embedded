#!/bin/bash

src2pdf() {
	#local noext="${1%.*}"
	pygmentize -O full -o "$1.html" "$1"
    # enabling line wrapping in <pre> blocks
    perl -i -wpe '/<style.*>$/&&($_.="pre{white-space:pre-wrap;}\n")' "$1.html"
    wkhtmltopdf "$1.html" "$1.pdf"
    rm "$1.html"
}

remove_pdf() {
	#local noext="${1%.*}"
	rm "$1.pdf"
}

for file in $@
do
	src2pdf $file
done

pdfunite *.pdf printout.pdf

for file in $@
do
	remove_pdf $file
done
