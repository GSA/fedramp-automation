export BASE_DIR=$(shell pwd)

help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Most of the real work of the build is in sub-project Makefiles.
include src/content/module.mk
include src/examples/module.mk
include src/validations/module.mk
include src/web/module.mk

.PHONY: help

all: clean build test  ## Complete clean build with tests

init: init-repo init-validations init-content init-web  ## Initialize project dependencies

init-repo:
	git submodule update --init --recursive

clean: clean-dist clean-validations clean-web  ## Clean all

clean-dist:  ## Clean non-RCS-tracked dist files
	@echo "Cleaning dist..."
	git clean -xfd dist

test: test-validations test-web test-examples ## Test all

build: build-validations build-web dist  ## Build all artifacts and copy into dist directory
	# Copy validations
	mkdir -p dist/validations/rev4
	cp src/validations/target/rules/rev4/*.xsl dist/validations/rev4
	cp src/validations/rules/rev4/*.sch dist/validations/rev4

	# Copy web build to dist
	cp -R ./src/web/dist dist/web

	@echo '#/bin/bash\necho "Serving FedRAMP ASAP documentation at http://localhost:8000/..."\npython3 -m http.server 8000 --directory web/' > ./dist/serve-documentation
	chmod +x ./dist/serve-documentation
