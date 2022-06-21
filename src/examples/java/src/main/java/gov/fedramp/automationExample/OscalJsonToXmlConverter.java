package gov.fedramp.automationExample;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;
import javax.xml.transform.stream.StreamSource;
import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.QName;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XPathCompiler;
import net.sf.saxon.s9api.XPathExecutable;
import net.sf.saxon.s9api.XPathSelector;
import net.sf.saxon.s9api.XdmAtomicValue;
import net.sf.saxon.s9api.XdmDestination;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XdmValue;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

/**
 * Simple example of how to use Saxon-HE to apply fedramp-automation validation rules to an OSCAL
 * Fedramp System Security Plan.
 */
public class OscalJsonToXmlConverter {
  private static final String JSON_TO_XML_XSLT =
      new File("../../../vendor/oscal/xml/convert/oscal_complete_json-to-xml-converter.xsl")
          .getAbsolutePath();

  private Processor processor;
  private XsltExecutable xsltExecutable;

  public OscalJsonToXmlConverter() throws SaxonApiException {
    // Create a Saxon processor
    processor = new Processor(false);
    // Compile the source XSLT to an XsltExecutable.
    StreamSource xslDocument = new StreamSource(new File(JSON_TO_XML_XSLT));
    XsltCompiler xsltCompiler = processor.newXsltCompiler();
    xsltExecutable = xsltCompiler.compile(xslDocument);
  }

  /**
   * Convert a JSON SSP to XML.
   *
   * <p>This method is an example of how to use the NIST-provided OSCAL JSON to XML stylesheet.
   * Rather than apply the stylesheet to a JSON document, the stylesheet instead is parameterized on
   * the JSON SSP with the `file` attribute. This attribute must be set to a valid URI - a path, or
   * a data URI.
   *
   * <p>To avoid network or filesystem I/O, you may choose to use a data URI. Here we demonstrate
   * such data URI usage.
   *
   * @throws URISyntaxException
   */
  public boolean convert(String jsonPath)
      throws IOException, SaxonApiException, URISyntaxException {
    XsltTransformer xsltTransformer = getTransformer(jsonPath);

    // Read the source SSP document
    // XdmNode inputNode = getInputNode(jsonPath);
    // xsltTransformer.setInitialContextNode(inputNode);

    // Do the transformation and output the result directly to an XdmValue
    // that we may query with XPath.
    XdmDestination xdmDestination = new XdmDestination();
    xsltTransformer.setDestination(xdmDestination);
    xsltTransformer.transform();

    // There should be a root node of `system-security-plan` in an OSCAL SSP
    // document.
    XdmNode svrlXdmNode = xdmDestination.getXdmNode();
    XdmValue rootNode = queryXPath(svrlXdmNode, "//oscal:system-security-plan");
    return rootNode.size() > 0;
  }

  private XsltTransformer getTransformer(String jsonPath) throws IOException, URISyntaxException {
    XsltTransformer xsltTransformer = xsltExecutable.load();
    URI jsonDataUri = getJsonDataUri(jsonPath);
    xsltTransformer.setParameter(new QName("file"), new XdmAtomicValue(jsonDataUri));
    xsltTransformer.setInitialTemplate(new QName("from-json"));
    return xsltTransformer;
  }

  private XdmValue queryXPath(XdmNode sourceXdmNode, String xPathQuery) throws SaxonApiException {
    XPathCompiler xPathCompiler = processor.newXPathCompiler();
    xPathCompiler.declareNamespace("oscal", "http://csrc.nist.gov/ns/oscal/1.0");
    XPathExecutable executable = xPathCompiler.compile(xPathQuery);
    XPathSelector selector = executable.load();

    selector.setContextItem(sourceXdmNode);
    return selector.evaluate();
  }

  private URI getJsonDataUri(String jsonPath) throws IOException, URISyntaxException {
    File jsonFile = new File(jsonPath);
    String jsonDataUri =
        "data:application/json;base64,"
            + Base64.getEncoder()
                .encodeToString(Files.readAllBytes(Paths.get(jsonFile.getAbsolutePath())));
    return new URI(jsonDataUri);
  }
}
