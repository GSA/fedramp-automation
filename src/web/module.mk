init-web: node
	cd src/web && \
		npm install

clean-web:  ## Clean web artifacts
	@echo "Cleaning web..."
	cd src/web && \
		npm run clean

build-web: node ## Build web bundle
	@echo "Building web bundle..."
	cd src/web && \
	  npm run build

test-web:  ## Test web codebase
	@echo "Running web tests..."
	cd src/web && \
		npm run test
