STYLEGUIDES_SCH_SRC := $(wildcard $(VALIDATIONS_DIR)/test/styleguides/*.xspec)
RULES_XSPEC_SRC_TARGETS := $(patsubst $(VALIDATIONS_DIR)/test/styleguides/%.xspec,$(VALIDATIONS_DIR)/report/test/styleguides/%-junit.xml,$(STYLEGUIDES_SCH_SRC))

test-validations-styleguides: $(RULES_XSPEC_SRC_TARGETS)

# Apply xspec
$(VALIDATIONS_DIR)/report/test/styleguides/%-junit.xml: $(VALIDATIONS_DIR)/test/rules/%.xspec
	$(EVAL_XSPEC) $<
