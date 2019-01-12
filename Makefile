PONYC ?= ponyc
config ?= debug
ifdef config
  ifeq (,$(filter $(config),debug release))
    $(error Unknown configuration "$(config)")
  endif
endif

ifeq ($(config),debug)
	PONYC_FLAGS += --debug
endif

PONYC_FLAGS += -o build/$(config)


ALL: test

build/$(config)/test: .deps build appdirs/*.pony appdirs/test/*.pony
	stable env ${PONYC} ${PONYC_FLAGS} appdirs/test

build/$(config)/selftest: .deps build appdirs/*.pony examples/selftest/*.pony
	stable env ${PONYC} ${PONYC_FLAGS} examples/selftest

build:
	mkdir build

.deps:
	stable fetch

test: build/$(config)/test
	build/$(config)/test

selftest: build/$(config)/selftest
	build/$(config)/selftest

clean:
	rm -rf build

.PHONY: clean test
