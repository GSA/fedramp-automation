# Variables
OSCAL_VERSION=`cat package.json|jq .dependencies.oscal | sed 's/"//g'`
OSCAL_CLI_VERSION := $(shell (grep "^oscal-cli" .tool-versions 2>nul || findstr "^oscal-cli" .tool-versions) | awk '{print $$2}' 2>nul || (grep "^oscal-cli" .tool-versions 2>/dev/null || findstr "^oscal-cli" .tool-versions) | cut -d' ' -f2)
OSCAL_CLI = npx oscal@$(OSCAL_VERSION)
SRC_DIR = ./src
DIST_DIR = ./dist
XML_DIR = $(DIST_DIR)/content/rev5/baselines/xml
JSON_DIR = $(DIST_DIR)/content/rev5/baselines/json
YAML_DIR = $(DIST_DIR)/content/rev5/baselines/yaml

.PHONY: init-content
init-content:
	@npm install
	$(OSCAL_CLI) use $(OSCAL_CLI_VERSION)
	$(OSCAL_CLI) server update
	$(OSCAL_CLI) server start -bg
# Generate content and perform conversions
.PHONY: build-content
build-content:
	@echo "Producing artifacts for baselines..."
	$(OSCAL_CLI) convert -f $(SRC_DIR)/content/rev5/baselines/xml -o $(DIST_DIR)/content/rev5/baselines/ -s
	@echo "Producing artifacts for SSP..."
	$(OSCAL_CLI) convert -f $(SRC_DIR)/content/rev5/templates/ssp/xml -o $(DIST_DIR)/content/rev5/templates/ssp -s
	@echo "Producing artifacts for POAM..."
	$(OSCAL_CLI) convert -f $(SRC_DIR)/content/rev5/templates/poam/xml -o $(DIST_DIR)/content/rev5/templates/poam -s
	@echo "Producing artifacts for SAP..."
	$(OSCAL_CLI) convert -f $(SRC_DIR)/content/rev5/templates/sap/xml -o $(DIST_DIR)/content/rev5/templates/sap -s
	@echo "Producing artifacts for SAR..."
	$(OSCAL_CLI) convert -f $(SRC_DIR)/content/rev5/templates/sar/xml -o $(DIST_DIR)/content/rev5/templates/sar -s

	@echo "Resolving FedRAMP HIGH baseline profile..."
	$(OSCAL_CLI) resolve -f $(SRC_DIR)/content/rev5/baselines/xml/FedRAMP_rev5_HIGH-baseline_profile.xml -o $(XML_DIR)/FedRAMP_rev5_HIGH-baseline-resolved-profile_catalog.xml -s
	@echo "Resolving FedRAMP MODERATE baseline profile..."
	$(OSCAL_CLI) resolve -f $(SRC_DIR)/content/rev5/baselines/xml/FedRAMP_rev5_MODERATE-baseline_profile.xml -o $(XML_DIR)/FedRAMP_rev5_MODERATE-baseline-resolved-profile_catalog.xml -s
	@echo "Resolving FedRAMP LOW baseline profile..."
	$(OSCAL_CLI) resolve -f $(SRC_DIR)/content/rev5/baselines/xml/FedRAMP_rev5_LOW-baseline_profile.xml -o $(XML_DIR)/FedRAMP_rev5_LOW-baseline-resolved-profile_catalog.xml -s
	@echo "Resolving FedRAMP LI-SaaS baseline profile..."
	$(OSCAL_CLI) resolve -f $(SRC_DIR)/content/rev5/baselines/xml/FedRAMP_rev5_LI-SaaS-baseline_profile.xml -o $(XML_DIR)/FedRAMP_rev5_LI-SaaS-baseline-resolved-profile_catalog.xml -s

	@echo "Converting Profiles to JSON..."
	$(OSCAL_CLI) convert -f $(XML_DIR) -o $(JSON_DIR) -t JSON -s
	@echo "Converting Profiles to YAML..."
	$(OSCAL_CLI) convert -f $(XML_DIR) -o $(YAML_DIR) -t YAML -s


.PHONY: test-content
test-content:
	@echo "Validating Source files"
	@$(OSCAL_CLI) validate -f  $(SRC_DIR)/content/rev5/baselines/ -r -s

.PHONY: test-legacy-content
test-legacy-content:
	@echo "Validating Source files"
	@$(OSCAL_CLI) validate -f  $(SRC_DIR)/content/rev4/baselines/ -r -s
