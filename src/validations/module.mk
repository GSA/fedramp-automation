SAXON_VERSION := 10.5
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_OPTS = allow-foreign=true diagnose=true
export SAXON_CP = vendor/$(SAXON_JAR)

VALIDATIONS_DIR := src/validations

COMPILE_SCH := bash $(VALIDATIONS_DIR)/bin/compile-sch.sh
EVAL_SCHEMATRON := bash $(VALIDATIONS_DIR)/bin/evaluate-compiled-schematron.sh
EVAL_XSPEC := TEST_DIR=$(VALIDATIONS_DIR)/report/test bash vendor/xspec/bin/xspec.sh -s -j

OSCAL_SCHEMATRON := $(wildcard $(VALIDATIONS_DIR)/rules/*.sch)
STYLEGUIDE_SCHEMATRON := $(wildcard $(VALIDATIONS_DIR)/styleguides/*.sch)
SRC_SCH := $(OSCAL_SCHEMATRON) $(STYLEGUIDE_SCHEMATRON)
XSL_SCH := $(patsubst $(VALIDATIONS_DIR)/%.sch,$(VALIDATIONS_DIR)/target/%.sch.xsl,$(SRC_SCH))
SVRL_SCH := $(patsubst $(VALIDATIONS_DIR)/rules/%.sch,$(VALIDATIONS_DIR)/report/test/%-result.xml,$(OSCAL_SCHEMATRON))
XSPEC_SRC := $(wildcard $(VALIDATIONS_DIR)/test/*.xspec)
XSPEC := $(patsubst $(VALIDATIONS_DIR)/test/%.xspec,$(VALIDATIONS_DIR)/report/test/%-junit.xml,$(XSPEC_SRC))

init-validations: $(SAXON_CP)  ## Initialize validations dependencies

$(SAXON_CP):  ## Download Saxon-HE to the vendor directory
	curl -f -H "Accept: application/zip" -o "$(SAXON_CP)" "$(SAXON_URL)"

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	rm -rf $(VALIDATIONS_DIR)/target
	git clean -xfd $(VALIDATIONS_DIR)/report

test-validations: $(SAXON_CP) $(SVRL_SCH) $(XSPEC)  ## Test validations

# Compile all Schematron to XSL
$(VALIDATIONS_DIR)/target/%.sch.xsl: $(VALIDATIONS_DIR)/%.sch
	@echo "Building Schematron $< to $@..."
	$(COMPILE_SCH) $< $@

# Apply Schematron styleguide to each rules SCH
$(VALIDATIONS_DIR)/report/test/%-result.xml: $(VALIDATIONS_DIR)/rules/%.sch
	$(EVAL_SCHEMATRON) $(VALIDATIONS_DIR)/target/styleguides/sch.sch.xsl $< $@

# Run each xspec
$(VALIDATIONS_DIR)/report/test/%-junit.xml: $(VALIDATIONS_DIR)/test/%.xspec
	$(EVAL_XSPEC) $<

build-validations: $(SAXON_CP) $(XSL_SCH)
