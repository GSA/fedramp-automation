REQUIRED_NODE_VERSION = $(shell cat .nvmrc)
INSTALLED_NODE_VERSION = $(shell node --version)

init-web: node
	cd src/web && \
		npm install

node:
ifneq ($(REQUIRED_NODE_VERSION),$(INSTALLED_NODE_VERSION))
	$(error node.js version $(REQUIRED_NODE_VERSION) required)
endif

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
