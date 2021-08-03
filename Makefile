REQUIRED_NODE_VERSION = $(shell cat .nvmrc)
INSTALLED_NODE_VERSION = $(shell node --version)

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: clean test build  ## Complete clean build with tests

init: init-repo init-web  ## Initialize project dependencies

node:
ifneq ($(REQUIRED_NODE_VERSION),$(INSTALLED_NODE_VERSION))
	$(error node.js version $(REQUIRED_NODE_VERSION) required)
endif

init-repo:
	git submodule update --init --recursive

init-web: node
	cd src/web && \
		npm install

clean: clean-dist clean-validations clean-web  ## Clean all

clean-dist:  ## Clean non-RCS-tracked dist files
	@echo "Cleaning dist..."
	git clean -xfd dist

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	cd src/validations \
		rm -rf report target

clean-web:  ## Clean web artifacts
	@echo "Cleaning web..."
	cd src/web && \
		npm run clean

test: test-validations test-web test-example ## Test all

test-validations:  ## Test validations
	@echo "Running validations tests..."
	cd src/validations && \
		../../vendor/xspec/bin/xspec.sh -s -j test/test_all.xspec

test-web:  ## Test web codebase
	@echo "Running web tests..."
	cd src/web && \
		npm run test

test-example:	test-example-java test-example-python  ## Test example code projects

test-example-java:  ## Test example Java project
	@echo "Verifying Java example..."
	cd src/examples/java && \
		docker-compose run example mvn test

test-example-python:  ## Test example Python project
	@echo "Verifying Python example..."
	cd src/examples/python && \
		docker-compose run example pytest

build: build-validations build-web dist  ## Build all artifacts and copy into dist directory
	# Symlink for Federalist
	ln -sf ./src/web/build _site

	# Copy validations
	mkdir -p dist/validations
	cp src/validations/target/ssp.xsl dist/validations
	cp -r src/validations/rules/ssp.sch dist/validations

build-validations:  ## Build Schematron validations
	@echo "Building Schematron validations..."
	cd src/validations && \
		./bin/validate_with_schematron.sh

build-web: node ## Build web bundle
	@echo "Building web bundle..."
	cd src/web && \
	  npm run build
