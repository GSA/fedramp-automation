package gov.fedramp.automationExample;

import java.io.File;
import org.junit.Assert;
import org.junit.Test;

/** Unit test for simple App. */
public class OscalJsonToXmlConverterTest {

  /** absolute location of the demo SSP file (JSON) */
  private static final String DEMO_JSON_SSP_PATH =
      new File("../../../dist/content/rev4/templates/ssp/json/FedRAMP-SSP-OSCAL-Template.json")
          .getAbsolutePath();

  @Test
  public void testConvert() throws Exception {
    OscalJsonToXmlConverter converter = new OscalJsonToXmlConverter();
    boolean success = converter.convert(DEMO_JSON_SSP_PATH);
    Assert.assertTrue(success);
  }
}
