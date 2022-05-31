package gov.fedramp.automationExample;

import java.io.File;
import java.util.List;
import java.util.Map;
import org.junit.Assert;
import org.junit.Test;

/** Unit test for simple App. */
public class FedrampAutomationValidatorTest {
  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSSP() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File("../../../src/validations/target/rules/ssp.sch.xsl")
              .getAbsolutePath(),
          new File("../../../dist/content/baselines/rev4/xml").getAbsolutePath(),
          new File("../../../dist/content/resources/xml").getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(new File(
          "../../../dist/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml").getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail("Unexpected exception: " + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSAP() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File("../../../src/validations/target/rules/sap.sch.xsl")
              .getAbsolutePath(),
          new File("../../../dist/content/baselines/rev4/xml").getAbsolutePath(),
          new File("../../../dist/content/resources/xml").getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(new File(
          "../../../dist/content/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml").getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail("Unexpected exception: " + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSAR() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File("../../../src/validations/target/rules/sar.sch.xsl")
              .getAbsolutePath(),
          new File("../../../dist/content/baselines/rev4/xml").getAbsolutePath(),
          new File("../../../dist/content/resources/xml").getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(new File(
          "../../../dist/content/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml").getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail("Unexpected exception: " + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidatePOAM() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File("../../../src/validations/target/rules/poam.sch.xsl")
              .getAbsolutePath(),
          new File("../../../dist/content/baselines/rev4/xml").getAbsolutePath(),
          new File("../../../dist/content/resources/xml").getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(new File(
          "../../../dist/content/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml").getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail("Unexpected exception: " + e.getMessage());
    }
  }
}
