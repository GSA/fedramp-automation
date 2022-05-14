SAXON_VERSION := 10.5
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_OPTS = allow-foreign=true diagnose=true
export SAXON_CP = vendor/$(SAXON_JAR)

VALIDATIONS_DIR := src/validations

COMPILE_SCH := bash $(VALIDATIONS_DIR)/bin/compile-sch.sh
EVAL_SCHEMATRON := bash $(VALIDATIONS_DIR)/bin/evaluate-compiled-schematron.sh
EVAL_XSPEC := TEST_DIR=$(VALIDATIONS_DIR)/report/test bash vendor/xspec/bin/xspec.sh -e -s -j

OSCAL_SCHEMATRON := $(wildcard $(VALIDATIONS_DIR)/rules/*.sch)
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
