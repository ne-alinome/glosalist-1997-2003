# Makefile of _Glosalist 1997-2003_

# By Marcos Cruz (programandala.net)

# Last modified 201901161945
# See change log at the end of the file

# ==============================================================
# XXX TODO --

# - Create HTML versions without header and footer.

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - pandoc

# ==============================================================
# Config

VPATH=./src:./target

# ==============================================================
# Interface

.PHONY: all
all: epub

.PHONY: cleanepub
cleanepub:
	rm -f target/*.epub

.PHONY: cleanxml
cleanxml:
	rm -f target/*.xml

.PHONY: clean
clean: cleanepub cleanxml

# ==============================================================
# Convert to DocBook

target/%.adoc.xml: src/%.adoc
	asciidoctor --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc (v1.9.4.2) does not allow EPUB alternative templates using
# `--data-dir` (by default, <~/.pandoc>). The default templates must be
# modified or redirected instead.  They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

# NB: Option `+RTS -K21000000 -RTS` is required in order to increase the
# stack space.

%.adoc.xml.pandoc.epub: %.adoc.xml
	pandoc \
		+RTS -K21000000 -RTS \
		--from=docbook \
		--to=epub \
		--epub-stylesheet=src/stylesheet.css \
		--output=$@ \
		$<

#		--data-dir=src/templates \

adoc_files=$(sort $(wildcard src/*.adoc))

docbook_files=$(addprefix target/,$(notdir $(addsuffix .xml,$(adoc_files))))

.PHONY: epub
epub: $(docbook_files)
	for file in $^; do \
		make $$file.pandoc.epub; \
	done;

# ==============================================================
# Change log

# 2018-11-30: Start. Copy from the project _Un Hedo Prince_.
#
# 2019-01-16: Adjust pandoc's parameters.
