configdir = $(prefix)/../etc/$(PACKAGE)

bin_PROGRAMS = oaiharvester
oaiharvester_SOURCES = oaiharvester

pkgdata_DATA = libs/*
doc_DATA = README.md COPYING
config_DATA = config.example.xml

man1_MANS = oaiharvester.1

oaiharvester.1: oaiharvester
	$(HELP2MAN) -o oaiharvester.1 -s 1 -N \
	--name="harvest an oaiprovider" \
	./oaiharvester
