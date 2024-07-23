REQUIRED_NODE_VERSION = $(strip $(shell cat .nvmrc))
INSTALLED_NODE_VERSION = $(strip $(shell node --version))

init-web: node
	cd src/web && \
		npm install

node:
ifneq ($(REQUIRED_NODE_VERSION),$(INSTALLED_NODE_VERSION))
	$(error node.js version `$(REQUIRED_NODE_VERSION)` required, `$(INSTALLED_NODE_VERSION)` installed)
endif

clean-web:  ## Clean web artifacts
	@echo "Cleaning web..."
	cd src/web && \
		npm run clean

build-web: node ## Build web bundle
	@echo "Deprecated web bundle..."

test-web:  ## Test web codebase
	@echo "Deprecated web tests..."
