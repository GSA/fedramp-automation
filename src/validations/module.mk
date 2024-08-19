# Variables
OSCAL_CLI = npx oscal
SRC_DIR = ./src
DIST_DIR = ./dist
REV5_BASELINES = ./dist/content/rev5/baselines
REV5_TEMPLATES = ./dist/content/rev5/templates

# Preparation
.PHONY: init-validations
init-validations:
	@echo "Installing OSCAL CLI..."
	npm install 
	npx oscal use oscal-cli-2.0.2.rc1

# Validation
.PHONY: build-validations
build-validations:
	@echo "Running Cucumber Tests"
	@npm run test

clean-validations:
	@echo "Nothing to clean"

test-validations:
	@echo "Validating rev5 artifacts recursively..."
	$(OSCAL_CLI) validate -f $(REV5_BASELINES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
	$(OSCAL_CLI) validate -f $(REV5_TEMPLATES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
