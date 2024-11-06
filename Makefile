export BASE_DIR=$(shell pwd)
OCI_REV_TAG=$(shell git rev-parse HEAD)

help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Most of the real work of the build is in sub-project Makefiles.
include src/content/module.mk
include src/validations/module.mk

.PHONY: help

all: clean build test  ## Complete clean build with tests

init: init-repo init-validations init-content init-web  ## Initialize project dependencies

configure: init-validations

lint: lint-validations

init-repo:
	git submodule update --init --recursive

clean: clean-dist clean-validations ## Clean all

clean-dist:  ## Clean non-RCS-tracked dist files
	@echo "Cleaning dist..."
	git clean -xfd dist

clean-oci-image:
	docker rmi -f \
		validation-tools:$(OCI_REV_TAG) \
		ghcr.io/gsa/fedramp-automation/validation-tools:$(OCI_REV_TAG) \
		gsatts/validation-tools:$(OCI_REV_TAG) \

test: build-validations ## Test all

build: build-validations build-web dist  ## Build all artifacts and copy into dist directory
	# Copy validations
	mkdir -p dist/validations/rev4
	cp src/validations/target/rules/rev4/*.xsl dist/validations/rev4
	cp src/validations/rules/rev4/*.sch dist/validations/rev4

	# Copy web build to dist
	cp -R ./src/web/dist dist/web

	@echo '#/bin/bash\necho "Serving FedRAMP ASAP documentation at http://localhost:8000/..."\npython3 -m http.server 8000 --directory web/' > ./dist/serve-documentation
	chmod +x ./dist/serve-documentation

build-oci-image: ## Build OCI image
	docker build \
		--build-arg APK_EXTRA_ARGS="--no-check-certificate" \
		--build-arg WGET_EXTRA_ARGS="--no-check-certificate" \
		-t validation-tools:$(OCI_REV_TAG) \
		-t ghcr.io/gsa/fedramp-automation/validation-tools:$(OCI_REV_TAG) \
		-t  gsatts/validation-tools:$(OCI_REV_TAG) \
		.

publish-oci-image: build-oci-image ## Publish OCI image to GitHub Container Registry (ghcr.io)
	docker tag \
		validation-tools:$(OCI_REV_TAG) validation-tools:latest

	docker tag \
		ghcr.io/gsa/fedramp-automation/validation-tools:$(OCI_REV_TAG) \
		ghcr.io/gsa/fedramp-automation/validation-tools:latest

	docker tag \
		gsatts/validation-tools:$(OCI_REV_TAG) \
		gsatts/validation-tools:latest

	docker push ghcr.io/gsa/fedramp-automation/validation-tools:$(OCI_REV_TAG)
	docker push	ghcr.io/gsa/fedramp-automation/validation-tools:latest
