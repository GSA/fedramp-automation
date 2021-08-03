package gov.fedramp.automationExample;

import java.io.File;
import java.util.List;
import java.util.Map;
import org.junit.Assert;
import org.junit.Test;

/** Unit test for simple App. */
public class FedrampAutomationValidatorTest {
  private static String DEMO_SSP_PATH =
      new File("../../../dist/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml")
          .getAbsolutePath();

  /** Rigorous Test :-) */
  @Test
  public void shouldReturnAssertions() {
    try {
      FedrampAutomationValidator validator = new FedrampAutomationValidator();
      List<Map<String, String>> failedAsserts = validator.validateSSP(DEMO_SSP_PATH);
      // Confirm that we received a list of assertions with expected attribute types
      Map<String, String> firstFailedAssert = failedAsserts.get(0);
      Assert.assertEquals(firstFailedAssert.get("test").getClass(), String.class);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
