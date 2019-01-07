PONYC ?= ponyc

build/test: build appdirs/*.pony appdirs/test/*.pony
	stable env $(PONYC) appdirs/test -o build --debug

build:
	mkdir build

test: build/test
	build/test

clean:
	rm -rf build

.PHONY: clean test
