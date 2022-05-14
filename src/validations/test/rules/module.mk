RULES_XSPEC_SRC := $(wildcard $(VALIDATIONS_DIR)/test/rules/*.xspec)
RULES_XSPEC_SRC_TARGETS := $(patsubst $(VALIDATIONS_DIR)/test/rules/%.xspec,$(VALIDATIONS_DIR)/report/test/rules/%-junit.xml,$(RULES_XSPEC_SRC))

test-validations-rules: $(RULES_XSPEC_SRC_TARGETS)

# Apply xspec
$(VALIDATIONS_DIR)/report/test/rules/%-junit.xml: $(VALIDATIONS_DIR)/test/rules/%.xspec
	$(EVAL_XSPEC) $<
