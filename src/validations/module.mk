SAXON_VERSION := 10.5
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_OPTS := allow-foreign=true diagnose=true
export SAXON_CP = $(BASE_DIR)/vendor/$(SAXON_JAR)

init-validations: $(SAXON_CP)  ## Initialize validations dependencies

$(SAXON_CP):  ## Download Saxon-HE to the vendor directory
	curl -H "Accept: application/zip" -o "$(SAXON_CP)" "$(SAXON_URL)" &> /dev/null

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	rm -rf $(BASE_DIR)/src/validations/target
	git clean -xfd $(BASE_DIR)/src/validations/report

test-validations: test-xspec test-sch  ## Test validations

test-xspec: $(SAXON_CP)
	@echo "Running validations tests..."
	TEST_DIR=$(BASE_DIR)/src/validations/report/test \
		$(BASE_DIR)/vendor/xspec/bin/xspec.sh -s -j $(BASE_DIR)/src/validations/test/test_all.xspec

$(BASE_DIR)/src/validations/target/sch.xsl: $(BASE_DIR)/src/validations/sch/sch.sch $(SAXON_CP)
	$(BASE_DIR)/src/validations/bin/compile-sch.sh \
		$(BASE_DIR)/src/validations/sch/sch.sch \
		$(BASE_DIR)/src/validations/target/sch.xsl

test-sch: $(BASE_DIR)/src/validations/target/sch.xsl
	$(BASE_DIR)/src/validations/bin/evaluate-compiled-schematron.sh \
		"$(BASE_DIR)/src/validations/target/sch.xsl" \
		"$(BASE_DIR)/src/validations/rules/ssp.sch" \
		"$(BASE_DIR)/src/validations/report/test/sch-svrl.xml"

build-validations: $(BASE_DIR)/src/validations/rules/ssp.sch ## Build Schematron validations

$(BASE_DIR)/src/validations/rules/ssp.sch: $(SAXON_CP)
	@echo "Building Schematron validations..."
	$(BASE_DIR)/src/validations/bin/compile-sch.sh \
		$(BASE_DIR)/src/validations/rules/ssp.sch \
		$(BASE_DIR)/src/validations/target/ssp.xsl
