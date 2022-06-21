XSPEC_SRC := $(wildcard $(VALIDATIONS_DIR)/test/rules/*.xspec)
XSPEC_STYLEGUIDE_TARGETS := $(patsubst $(VALIDATIONS_DIR)/%.xspec,$(VALIDATIONS_DIR)/report/styleguides/xspec.sch/%-result.xml,$(XSPEC_SRC))

SCH_SRC := $(wildcard $(VALIDATIONS_DIR)/rules/*.sch)
SCH_STYLEGUIDE_TARGETS := $(patsubst $(VALIDATIONS_DIR)/%.sch,$(VALIDATIONS_DIR)/report/styleguides/sch.sch/%-result.xml,$(SCH_SRC))

test-styleguides: $(XSPEC_STYLEGUIDE_TARGETS) $(SCH_STYLEGUIDE_TARGETS)

# OSCAL Schematron styleguide
$(VALIDATIONS_DIR)/report/styleguides/sch.sch/%-result.xml: $(VALIDATIONS_DIR)/%.sch $(VALIDATIONS_DIR)/target/styleguides/sch.sch.xsl
	$(EVAL_SCHEMATRON) $(VALIDATIONS_DIR)/target/styleguides/sch.sch.xsl $< $@

# XSpec styleguide
$(VALIDATIONS_DIR)/report/styleguides/xspec.sch/%-result.xml: $(VALIDATIONS_DIR)/%.xspec $(VALIDATIONS_DIR)/target/styleguides/xspec.sch.xsl
	$(EVAL_SCHEMATRON) $(VALIDATIONS_DIR)/target/styleguides/xspec.sch.xsl $< $@
