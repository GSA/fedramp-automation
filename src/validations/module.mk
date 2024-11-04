# Variables
OSCAL_CLI = npx oscal@latest
SRC_DIR = ./src
DIST_DIR = ./dist
REV5_BASELINES = ./dist/content/rev5/baselines
REV5_TEMPLATES = ./dist/content/rev5/templates

# Preparation
.PHONY: init-validations
init-validations:
	@echo "Installing node modules..."
	npm install
	$(OSCAL_CLI) use 2.2.0
	$(OSCAL_CLI) server update

# Style lint
.PHONY: lint-style
lint-validations:
	@echo "Validating against style guide"
	npm run test:style

# Validation
.PHONY: build-validations
build-validations:
	@echo "Running Cucumber Tests"
	$(OSCAL_CLI) server start -bg
	@npm run test:server
	$(OSCAL_CLI) server stop

clean-validations:
	@echo "Nothing to clean"

update:
	npm install
	$(OSCAL_CLI) use latest
constraint:
	npm run constraint
metaquery:
	npm run mq

test-validations:
	@echo "Validating rev5 artifacts recursively..."
	$(OSCAL_CLI) validate -f $(REV5_BASELINES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
	$(OSCAL_CLI) validate -f $(REV5_TEMPLATES) -e ./src/validations/constraints/fedramp-external-constraints.xml -r
