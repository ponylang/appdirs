config ?= release

PACKAGE := appdirs
COMPILE_WITH := ponyc

BUILD_DIR ?= build/$(config)
SRC_DIR := $(PACKAGE)
EXAMPLES_DIR := examples
tests_binary := $(BUILD_DIR)/$(PACKAGE)
docs_dir := build/$(PACKAGE)-docs
deps_dir := .deps

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = $(COMPILE_WITH)
else
	PONYC = $(COMPILE_WITH) --debug
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)
EXAMPLE_SOURCE_FILES := $(shell find $(EXAMPLES_DIR) -name \*.pony)

$(deps_dir):
	stable fetch

test: unit-tests build-examples

unit-tests: $(tests_binary)
	$^ --exclude=integration --sequential

$(tests_binary): $(SOURCE_FILES) | $(BUILD_DIR) $(deps_dir)
	$(PONYC) -o ${BUILD_DIR} $(SRC_DIR)

build-examples: $(SOURCE_FILES) $(EXAMPLES_SOURCE_FILES) | $(BUILD_DIR) $(deps_dir)
	find examples/*/* -name '*.pony' -print | xargs -n 1 dirname  | sort -u | grep -v ffi- | xargs -n 1 -I {} $(PONYC) -s --checktree -o $(BUILD_DIR) {}

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build $(deps_dir)

$(docs_dir): $(SOURCE_FILES) $(deps_dir)
	rm -rf $(docs_dir)
	$(PONYC) --docs-public --pass=docs --output build $(SRC_DIR)

docs: $(docs_dir)

TAGS:
	ctags --recurse=yes $(SRC_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean realclean TAGS test
