SAXON_VERSION := 10.5
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_OPTS = allow-foreign=true diagnose=true
export SAXON_CP = $(BASE_DIR)/vendor/$(SAXON_JAR)

VALIDATIONS_DIR := $(BASE_DIR)/src/validations

COMPILE_SCH := $(VALIDATIONS_DIR)/bin/compile-sch.sh
EVAL_SCHEMATRON := $(VALIDATIONS_DIR)/bin/evaluate-compiled-schematron.sh
EVAL_XSPEC := TEST_DIR=$(VALIDATIONS_DIR)/report/test $(BASE_DIR)/vendor/xspec/bin/xspec.sh -s -j

init-validations: $(SAXON_CP)  ## Initialize validations dependencies

$(SAXON_CP):  ## Download Saxon-HE to the vendor directory
	curl -H "Accept: application/zip" -o "$(SAXON_CP)" "$(SAXON_URL)" &> /dev/null

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	rm -rf $(VALIDATIONS_DIR)/target
	git clean -xfd $(VALIDATIONS_DIR)/report

test-validations: $(SAXON_CP) test-xspec test-sch  ## Test validations

test-xspec: $(VALIDATIONS_DIR)/test/test_all.xspec
	$(EVAL_XSPEC) $^

$(VALIDATIONS_DIR)/target/%.sch.xsl: $(VALIDATIONS_DIR)/styleguides/%.sch
	$(COMPILE_SCH) $^ $@

$(VALIDATIONS_DIR)/report/test/%.svrl.xml: $(VALIDATIONS_DIR)/target/%.sch.xsl $(VALIDATIONS_DIR)/rules/ssp.sch
	$(EVAL_SCHEMATRON) $^ $@

test-sch: $(VALIDATIONS_DIR)/report/test/sch.svrl.xml $(VALIDATIONS_DIR)/report/test/xspec.svrl.xml

$(VALIDATIONS_DIR)/target/ssp.xsl: $(VALIDATIONS_DIR)/rules/ssp.sch
	@echo "Building Schematron validations..."
	$(COMPILE_SCH) $^ $@

build-validations: $(SAXON_CP) $(VALIDATIONS_DIR)/target/ssp.xsl ## Build Schematron validations
