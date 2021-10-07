package gov.fedramp.automationExample;

import java.io.File;
import java.util.List;
import java.util.Map;
import org.junit.Assert;
import org.junit.Test;

/** Unit test for simple App. */
public class OscalJsonToXmlConverterTest {

  private static String DEMO_JSON_SSP_PATH = new File(
      "../../../dist/content/templates/ssp/json/FedRAMP-SSP-OSCAL-Template.json").getAbsolutePath();

  @Test
  public void testConvert() throws Exception {
    OscalJsonToXmlConverter converter = new OscalJsonToXmlConverter();
    boolean success = converter.convert(DEMO_JSON_SSP_PATH);
    Assert.assertTrue(success);
  }
}
