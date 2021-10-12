SAXON_VERSION := 10.5
SAXON_JAR := Saxon-HE-$(SAXON_VERSION).jar
SAXON_LOCATION := saxon/Saxon-HE/$(SAXON_VERSION)/$(SAXON_JAR)
SAXON_URL := https://repo1.maven.org/maven2/net/sf/$(SAXON_LOCATION)
export SAXON_CP = $(BASE_DIR)/vendor/$(SAXON_JAR)
#export SAXON_CP=/Users/dan/.m2/repository/net/sf/saxon/Saxon-HE/10.5/Saxon-HE-10.5.jar

init-validations: $(SAXON_CP)  ## Initialize validations dependencies

$(SAXON_CP):  ## Download Saxon-HE to the vendor directory
	curl -H "Accept: application/zip" -o "$(SAXON_CP)" "$(SAXON_URL)" &> /dev/null

clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	cd src/validations \
		rm -rf report target

test-validations: $(SAXON_CP) build-validations  ## Test validations
	@echo "Running validations tests..."
	SAXON_CP=$(SAXON_CP) TEST_DIR=$(BASE_DIR)/src/validations/report/test \
		$(BASE_DIR)/vendor/xspec/bin/xspec.sh -s -j $(BASE_DIR)/src/validations/test/test_all.xspec

build-validations: $(SAXON_CP) ## Build Schematron validations
	@echo "Building Schematron validations..."
	cd src/validations && \
		./bin/validate_with_schematron.sh
