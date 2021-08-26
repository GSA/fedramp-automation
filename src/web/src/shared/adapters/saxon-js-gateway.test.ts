import * as SaxonJS from 'saxon-js';

import {
  XmlIndenter,
  SaxonJsSchematronProcessorGateway,
} from './saxon-js-gateway';

describe('xml indent', () => {
  it('works', async () => {
    const xmlIndent = XmlIndenter({ SaxonJS });
    const indentedXml = await xmlIndent(
      '<xml><child><node1></node1><!-- comment1 --><node2></node2><!-- comment2 --></child></xml>',
    );
    expect(indentedXml).toEqual(
      `<xml>
   <child>
      <node1/>
      <!-- comment1 --><node2/>
      <!-- comment2 --></child>
</xml>`,
    );
  });
});

describe('saxon-js gateway', () => {
  it('produces validation results for transformation', async () => {
    jest.spyOn(SaxonJS, 'transform').mockImplementation((() => {
      const doc = (SaxonJS as any)
        .getPlatform()
        .parseXmlFromString(SAMPLE_SVRL);
      return Promise.resolve({
        principalResult: doc,
      });
    }) as any);
    const reportGateway = SaxonJsSchematronProcessorGateway({
      SaxonJS,
      sefUrl: '/test.sef.json',
      baselinesBaseUrl: '/baselines',
      registryBaseUrl: '/xml',
    });
    const validationReport = await reportGateway('<xml>ignored</xml');
    expect(SaxonJS.transform).toHaveBeenCalled();
    expect(validationReport).toEqual({
      failedAsserts: [
        {
          diagnosticReferences: ['Diagnostic reference node content.'],
          id: 'incorrect-role-association',
          location:
            "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
          role: 'error',
          test: 'not(exists($extraneous-roles))',
          text: 'Failed assertion text node content.',
          uniqueId: 'incorrect-role-association-0',
        },
      ],
      successfulReports: [
        {
          id: 'control-implemented-requirements-stats',
          location:
            "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
          role: 'information',
          test: 'count($results/errors/error) = 0',
          text: 'Successful report text content.',
          uniqueId: 'control-implemented-requirements-stats-0',
        },
      ],
    });
  });
});

const SAMPLE_SVRL = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<svrl:schematron-output xmlns:f="https://fedramp.gov/ns/oscal"
                        xmlns:fedramp="https://fedramp.gov/ns/oscal"
                        xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                        xmlns:lv="local-validations"
                        xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                        xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
                        xmlns:saxon="http://saxon.sf.net/"
                        xmlns:schold="http://www.ascc.net/xml/schematron"
                        xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                        title="FedRAMP System Security Plan Validations"
                        schemaVersion="">
   <svrl:ns-prefix-in-attribute-values uri="https://fedramp.gov/ns/oscal" prefix="f"/>
   <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="o"/>
   <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="oscal"/>
   <svrl:ns-prefix-in-attribute-values uri="https://fedramp.gov/ns/oscal" prefix="fedramp"/>
   <svrl:ns-prefix-in-attribute-values uri="local-validations" prefix="lv"/>
   <svrl:fired-rule context="/o:system-security-plan/o:metadata"/>
   <svrl:failed-assert test="not(exists($extraneous-roles))"
                       id="incorrect-role-association"
                       role="error"
                       location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
      <svrl:text>Failed assertion text node content.</svrl:text>
      <svrl:diagnostic-reference diagnostic="incorrect-role-association-diagnostic">Diagnostic reference node content.</svrl:diagnostic-reference>
   </svrl:failed-assert>
   <svrl:successful-report test="count($results/errors/error) = 0"
                           id="control-implemented-requirements-stats"
                           role="information"
                           location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
      <svrl:text>Successful report text content.</svrl:text>
   </svrl:successful-report>
</svrl:schematron-output>
`;
