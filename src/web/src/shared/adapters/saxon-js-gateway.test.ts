import SaxonJS from 'saxon-js';
import { it, describe, expect, vi } from 'vitest';
import { mock } from 'vitest-mock-extended';

import {
  SaxonJSXmlIndenter,
  SaxonJsSchematronProcessorGateway,
  SaxonJsJsonOscalToXmlProcessor,
  SaxonJsXSpecParser,
} from './saxon-js-gateway';

import { BUILD_PATH } from '../project-config';

/**
 * @vitest-environment jsdom
 */
describe('xml indent', () => {
  it('works', async () => {
    const xmlIndent = SaxonJSXmlIndenter({ SaxonJS });
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
    vi.spyOn(SaxonJS, 'transform').mockImplementation((() => {
      return Promise.resolve({
        principalResult: SAMPLE_SVRL,
      });
    }) as any);
    const reportGateway = SaxonJsSchematronProcessorGateway({
      console,
      SaxonJS,
      sefUrls: {
        poam: '/test.sef.json',
        sap: '/test.sef.json',
        sar: '/test.sef.json',
        ssp: '/test.sef.json',
      },
      baselinesBaseUrl: '/baselines',
      registryBaseUrl: '/xml',
    });
    const result = await reportGateway(
      '<system-security-plan>ignored</system-security-plan>',
    );
    expect(SaxonJS.transform).toHaveBeenCalled();
    expect(result).toEqual({
      documentType: 'ssp',
      schematronResult: {
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
        svrlString: SAMPLE_SVRL,
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
      },
    });
  });

  it('converts JSON to XML', async () => {
    const jsonToXml = SaxonJsJsonOscalToXmlProcessor({
      console: mock<Console>({
        log: vi.fn(),
      }),
      sefUrl: `${BUILD_PATH}/oscal_ssp_json-to-xml-converter.sef.json`,
      SaxonJS,
    });
    const convertedXml = await jsonToXml('{"system-security-plan": {}}');
    expect(convertedXml.toString()).toMatch(/<svrl:schematron-output/);
  });

  it('parses XSpec', () => {
    const parseXspec = SaxonJsXSpecParser({ SaxonJS });
    const xspec = parseXspec(SAMPLE_XSPEC);
    expect(xspec).toEqual([
      {
        node: 'x:scenario',
        label: 'In FedRAMP OSCAL Schematron',
        children: [
          {
            node: 'x:context',
            context:
              '<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron"/>',
          },
          {
            node: 'x:expect-assert',
            id: 'has-xspec-reference',
            label: 'that is incorrect',
          },
        ],
      },
      {
        node: 'x:scenario',
        label: 'FedRAMP OSCAL SSP Attachments',
        children: [
          {
            node: 'x:scenario',
            label: 'General:',
            children: [
              {
                node: 'x:scenario',
                label: 'when a resource attachment type',
                children: [
                  {
                    node: 'x:scenario',
                    label: 'is allowed',
                    children: [
                      {
                        node: 'x:context',
                        context:
                          '<resource xmlns="http://csrc.nist.gov/ns/oscal/1.0">\n              <prop name="type" value="image"/>\n            </resource>',
                      },
                      {
                        node: 'x:expect-not-assert',
                        id: 'attachment-type-is-valid',
                        label: 'that is correct',
                      },
                      {
                        node: 'x:expect-not-assert',
                        id: 'attachment-type-is-valid-2',
                        label: 'that is correct 2',
                      },
                    ],
                  },
                  {
                    node: 'x:scenario',
                    label: 'is not allowed',
                    children: [
                      {
                        node: 'x:context',
                        context:
                          '<resource xmlns="http://csrc.nist.gov/ns/oscal/1.0">\n              <prop name="type" value="notallowed"/>\n            </resource>',
                      },
                      {
                        node: 'x:expect-assert',
                        id: 'attachment-type-is-valid',
                        label: 'that is an error',
                      },
                    ],
                  },
                ],
              },
            ],
          },
        ],
      },
    ]);
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

const SAMPLE_XSPEC = `<?xml version="1.0" encoding="UTF-8"?>
<x:description schematron="../sch/sch.sch" xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:sqf="http://www.schematron-quickfix.com/validator/process" xmlns:x="http://www.jenitennison.com/xslt/xspec">
  <x:scenario label="In FedRAMP OSCAL Schematron">
    <x:context>
      <sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" />
    </x:context>
    <x:expect-assert id="has-xspec-reference" label="that is incorrect" />
  </x:scenario>
  <x:scenario label="FedRAMP OSCAL SSP Attachments">
    <x:scenario label="General:">
      <x:scenario label="when a resource attachment type">
        <x:scenario label="is allowed">
          <x:context>
            <resource xmlns="http://csrc.nist.gov/ns/oscal/1.0">
              <prop name="type" value="image" />
            </resource>
          </x:context>
          <x:expect-not-assert id="attachment-type-is-valid" label="that is correct" />
          <x:expect-not-assert id="attachment-type-is-valid-2" label="that is correct 2" />
        </x:scenario>
        <x:scenario label="is not allowed" pending="XSpec error resolution">
          <x:context>
            <resource xmlns="http://csrc.nist.gov/ns/oscal/1.0">
              <prop name="type" value="notallowed" />
            </resource>
          </x:context>
          <x:expect-assert id="attachment-type-is-valid" label="that is an error" />
        </x:scenario>
      </x:scenario>
    </x:scenario>
  </x:scenario>
</x:description>
`;
