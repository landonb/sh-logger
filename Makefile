PREFIX ?= /usr/local

install:
	cp -f bin/logger.sh $(PREFIX)/bin

uninstall:
	rm -f $(PREFIX)/bin/logger.sh

