package gov.fedramp.automationExample;

import java.io.File;
import java.util.List;
import java.util.Map;
import org.junit.Assert;
import org.junit.Test;

/** Unit test for simple App. */
public class FedrampAutomationValidatorTest {

  /** Location of baseline 800-53rev4 definitions */
  private static final String BASELINE_REV4_XML = "../../../dist/content/rev4/baselines/xml";

  /** Location of resource values */
  private static final String RESOURCES_XML = "../../../dist/content/rev4/resources/xml";

  /** compiled Schematron XSLT path for SSP resource values */
  private static final String SSP_RESOURCE = "../../../src/validations/target/rules/ssp.sch.xsl";

  /** compiled Schematron XSLT path for SAP resource values */
  private static final String SAP_RESOURCE = "../../../src/validations/target/rules/sap.sch.xsl";

  /** compiled Schematron XSLT path for SAR resource values */
  private static final String SAR_RESOURCE = "../../../src/validations/target/rules/sar.sch.xsl";

  /** compiled Schematron XSLT path for POA&M resource values */
  private static final String POAM_RESOURCE = "../../../src/validations/target/rules/poam.sch.xsl";

  /** SSP template */
  private static final String SSP_TEMPLATE = "../../../dist/content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml";

  /** SAP template */
  private static final String SAP_TEMPLATE = "../../../dist/content/rev4/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml";

  /** SAR template */
  private static final String SAR_TEMPLATE = "../../../dist/content/rev4/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml";

  /** POA&M template */
  private static final String POAM_TEMPLATE = "../../../dist/content/rev4/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml";

  /** error message returned when something unexpected happens */
  private static final String ERROR_MESSAGE = "Unexpected exception: ";

  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSSP() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File(SSP_RESOURCE).getAbsolutePath(),
          new File(BASELINE_REV4_XML).getAbsolutePath(),
          new File(RESOURCES_XML).getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(
          new File(SSP_TEMPLATE).getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail(ERROR_MESSAGE + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSAP() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File(SAP_RESOURCE).getAbsolutePath(),
          new File(BASELINE_REV4_XML).getAbsolutePath(),
          new File(RESOURCES_XML).getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(
          new File(SAP_TEMPLATE).getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail(ERROR_MESSAGE + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidateSAR() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File(SAR_RESOURCE).getAbsolutePath(),
          new File(BASELINE_REV4_XML).getAbsolutePath(),
          new File(RESOURCES_XML).getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(
          new File(SAR_TEMPLATE).getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail(ERROR_MESSAGE + e.getMessage());
    }
  }

  /** Rigorous Test :-) */
  @Test
  public void shouldValidatePOAM() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator(
          new File(POAM_RESOURCE).getAbsolutePath(),
          new File(BASELINE_REV4_XML).getAbsolutePath(),
          new File(RESOURCES_XML).getAbsolutePath());
      List<Map<String, String>> failedAsserts = validator.validateOscalDocument(
          new File(POAM_TEMPLATE).getAbsolutePath());
      Assert.assertNotNull(failedAsserts);
    } catch (Exception e) {
      Assert.fail(ERROR_MESSAGE + e.getMessage());
    }
  }
}
