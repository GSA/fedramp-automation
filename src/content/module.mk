# These targets will build src/content, using OSCAL's CI/CD build tools.
# Docker is utilized for a build environment.
# These build targets are not part of the standard test/build cycle. Instead,
# they are intended to be run via a Github Action workflow.

CONTENT_DIR := src/content
MNT := /code
OSCAL_DIR := vendor/oscal
CICD_DIR_PATH := $(OSCAL_DIR)/build/ci-cd
CONTENT_CONFIG_PATH := src/config

OSCAL_DOCKER := docker compose -f $(OSCAL_DIR)/build/docker-compose.yml -f $(CONTENT_DIR)/docker-compose.yml

init-content:  ## Initialize content build environment (build Docker image)
	@echo "Building Docker image for OSCAL content generation..."
	$(OSCAL_DOCKER) build

test-content:  ## Test src/content
	@echo "Testing content..."
	$(OSCAL_DOCKER) run cli $(MNT)/$(CICD_DIR_PATH)/validate-content.sh -v -o $(MNT)/$(OSCAL_DIR) -a $(MNT) -c $(MNT)/$(CONTENT_CONFIG_PATH)

build-content:  ## Build dist/content
	@echo "Building content..."
	$(OSCAL_DOCKER) run cli $(MNT)/$(CICD_DIR_PATH)/copy-and-convert-content.sh -v -o $(MNT)/$(OSCAL_DIR) -a $(MNT) -c $(MNT)/$(CONTENT_CONFIG_PATH) -w $(MNT)/dist --resolve-profiles
	cp -R $(CONTENT_DIR)/rev4/resources/xml/. dist/content/rev4/resources/xml
	cp -R $(CONTENT_DIR)/rev5/resources/xml/. dist/content/rev5/resources/xml