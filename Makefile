PONYC ?= ponyc

ALL: test

build/test: .deps build appdirs/*.pony appdirs/test/*.pony
	stable env $(PONYC) appdirs/test -o build --debug

build/selftest: .deps build appdirs/*.pony examples/selftest/*.pony
	stable env $(PONYC) examples/selftest -o build --debug

build:
	mkdir build

.deps:
	stable fetch

test: build/test
	build/test

selftest: build/selftest
	build/selftest

clean:
	rm -rf build

.PHONY: clean test
