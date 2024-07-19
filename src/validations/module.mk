# Variables
OSCAL_CLI = oscal
SRC_DIR = ./src
DIST_DIR = ./dist

# Preparation
.PHONY: init-validations
prepare:
	@echo "Installing OSCAL CLI..."
	npm install oscal -g

# Validation
.PHONY: build-validations
build-validations:
	@echo "Validating artifacts recursively..."
	$(OSCAL_CLI) validate -f $(DIST_DIR) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
test-validations:
	@echo "Running Cucumber Tests"
	@npm run test
