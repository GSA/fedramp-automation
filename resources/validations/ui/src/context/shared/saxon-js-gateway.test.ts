import * as SaxonJS from 'saxon-js';

import { SaxonJsSchematronValidatorGateway } from './saxon-js-gateway';

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
    const reportGateway = SaxonJsSchematronValidatorGateway({
      SaxonJS,
      sefUrl: '/test.sef.json',
      baselinesBaseUrl: '/baselines',
      registryBaseUrl: '/xml',
    });
    const validationReport = await reportGateway('<xml>ignored</xml');
    expect(SaxonJS.transform).toHaveBeenCalled();
    expect(validationReport).toHaveProperty('failedAsserts');
  });
});

const SAMPLE_SVRL = `<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<svrl:schematron-output xmlns:f="https://fedramp.gov/ns/oscal" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:lv="local-validations" xmlns:o="http://csrc.nist.gov/ns/oscal/1.0" xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" title="FedRAMP System Security Plan Validations" schemaVersion="">
    <svrl:ns-prefix-in-attribute-values uri="https://fedramp.gov/ns/oscal" prefix="f" />
    <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="o" />
    <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="oscal" />
    <svrl:ns-prefix-in-attribute-values uri="local-validations" prefix="lv" />
    <svrl:active-pattern document="" />
    <svrl:fired-rule context="/o:system-security-plan" />
    <svrl:failed-assert test="count($registry/f:fedramp-values/f:value-set) &gt; 0" id="no-registry-values" role="fatal" location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
        <svrl:text>The registry values at the path '
            ../../xml?select=*.xml' are not present, this configuration is invalid.</svrl:text>
    </svrl:failed-assert>
</svrl:schematron-output>
`;
