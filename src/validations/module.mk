# Variables
OSCAL_CLI = oscal
SRC_DIR = ./src
DIST_DIR = ./dist
REV5_BASELINES = ./dist/content/rev5/baselines
REV5_TEMPLATES = ./dist/content/rev5/templates

# Preparation
.PHONY: init-validations
prepare:
	@echo "Installing OSCAL CLI..."
	npm install oscal cross-env -g

# Validation
.PHONY: build-validations
build-validations:
	@echo "Validating rev5 artifacts recursively..."
	$(OSCAL_CLI) validate -f $(REV5_BASELINES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
	$(OSCAL_CLI) validate -f $(REV5_TEMPLATES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r

test-validations:
	@echo "Running Cucumber Tests"
	@npm run test
