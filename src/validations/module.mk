SAXON_VERSION := 10.8
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_OPTS = allow-foreign=true diagnose=true
export SAXON_CP = vendor/$(SAXON_JAR)

VALIDATIONS_DIR := src/validations

COMPILE_SCH := bash $(VALIDATIONS_DIR)/bin/compile-sch.sh
EVAL_SCHEMATRON := bash $(VALIDATIONS_DIR)/bin/evaluate-compiled-schematron.sh
EVAL_XSPEC := TEST_DIR=$(VALIDATIONS_DIR)/report/test bash vendor/xspec/bin/xspec.sh -e -s -j

OSCAL_SCHEMATRON := $(wildcard $(VALIDATIONS_DIR)/rules/**/*.sch)
STYLEGUIDE_SCHEMATRON := $(wildcard $(VALIDATIONS_DIR)/styleguides/*.sch)
SRC_SCH := $(OSCAL_SCHEMATRON) $(STYLEGUIDE_SCHEMATRON)

XSL_SCH := $(patsubst $(VALIDATIONS_DIR)/%.sch,$(VALIDATIONS_DIR)/target/%.sch.xsl,$(SRC_SCH))

init-validations: $(SAXON_CP)  ## Initialize validations dependencies

$(SAXON_CP):  ## Download Saxon-HE to the vendor directory
	curl -f -H "Accept: application/zip" -o "$(SAXON_CP)" "$(SAXON_URL)"

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	rm -rf $(VALIDATIONS_DIR)/target
	git clean -xfd $(VALIDATIONS_DIR)/report

include src/validations/styleguides/module.mk
include src/validations/test/rules/module.mk
include src/validations/test/styleguides/module.mk

test-validations: $(SAXON_CP) test-styleguides test-validations-styleguides test-validations-rules  ## Test validations

# Schematron to XSL
$(VALIDATIONS_DIR)/target/%.sch.xsl: $(VALIDATIONS_DIR)/%.sch
	@echo "Building Schematron $< to $@..."
	$(COMPILE_SCH) $< $@

# Apply xspec
$(VALIDATIONS_DIR)/report/test/%-junit.xml: $(VALIDATIONS_DIR)/test/%.xspec
	$(EVAL_XSPEC) $<

build-validations: $(SAXON_CP) $(XSL_SCH)






OSCAL_CLI_VERSION:=1.0.3
OSCAL_CLI_BIN:=oscal-cli
OSCAL_CLI_INSTALL_URL:=https://repo1.maven.org/maven2/gov/nist/secauto/oscal/tools/oscal-cli/cli-core/$(OSCAL_CLI_VERSION)/cli-core-$(OSCAL_CLI_VERSION)-oscal-cli.zip
OSCAL_CLI_INSTALL_PATH:=./oscal-cli/
OSCAL_CLI_PATH:=$(shell which $(OSCAL_CLI_BIN) > /dev/null && dirname `which $(OSCAL_CLI_BIN)` || echo $(OSCAL_CLI_INSTALL_PATH))
SRC_DIR=./src

$(OSCAL_CLI_INSTALL_PATH):
	@echo Downloading OSCAL CLI Tool...
	@mkdir -p $(OSCAL_CLI_INSTALL_PATH)
	@curl $(CURL_INSTALL_OPTS) -o $(OSCAL_CLI_INSTALL_PATH)/oscal-cli.zip $(OSCAL_CLI_INSTALL_URL)
	@unzip -o $(OSCAL_CLI_INSTALL_PATH)/oscal-cli.zip -d $(OSCAL_CLI_INSTALL_PATH)
	@chmod +x $(OSCAL_CLI_INSTALL_PATH)/bin/$(OSCAL_CLI_BIN)

#
# Validate XML with oscal-cli
#
.PHONY: validate-xml-by-cli
validate-xml-by-cli: $(OSCAL_CLI_PATH) ## Validate XML files by directory using OSCAL CLI Tool
	@find $(SRC_DIR)/content/*/baselines -mindepth 1 -maxdepth 1 -type d | while read example_dir; do \
		find "$$example_dir" -name '*.xml' | while read xml_file; do \
			example_type=$$(echo "$$(basename $$xml_file)" | awk -F'[_.]' '{print $$(NF-1)}'); \
			echo "Processing content type: $$example_type"; \
			echo "Validating $$xml_file with OSCAL CLI as $$example_type"; \
			$(OSCAL_CLI_PATH)/bin/oscal-cli "$$example_type" validate "$$xml_file"; \
		done \
	done
