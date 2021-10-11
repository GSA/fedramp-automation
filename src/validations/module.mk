clean-validations:  ## Clean validations artifact
	@echo "Cleaning validations..."
	cd src/validations \
		rm -rf report target

test-validations:  ## Test validations
	@echo "Running validations tests..."
	cd src/validations && \
		../../vendor/xspec/bin/xspec.sh -s -j test/test_all.xspec

build-validations:  ## Build Schematron validations
	@echo "Building Schematron validations..."
	cd src/validations && \
		./bin/validate_with_schematron.sh
