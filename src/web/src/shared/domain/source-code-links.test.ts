import { describe, expect, it } from 'vitest';

import { getDocumentReferenceUrls } from './source-code-links';

describe('source code link generator', () => {
  const github = {
    owner: '18F',
    branch: 'master',
    repository: 'fedramp-automation',
    commit: 'master',
  };
  describe('getDocumentReferenceUrls', () => {
    it('works', () => {
      expect(
        getDocumentReferenceUrls({
          github,
          documentType: 'ssp',
          schXmlString: TEST_SCH,
          xspecXmlString: TEST_XSPEC,
        }),
      ).toEqual({
        assertions: {
          'has-import-ssp':
            'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch#L8-L13',
          'has-import-ssp-href':
            'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch#L43-L48',
          'has-location-assessment-subject':
            'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch#L34-L39',
          'has-web-applications':
            'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch#L24-L32',
        },
      });
    });
  });
});

const TEST_SCH = `<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="advanced" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema>
    <sch:pattern
        id="import-ssp">
        <sch:rule
            context="oscal:assessment-plan">
            <sch:assert
                diagnostics="has-import-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp"
                role="error"
                test="oscal:import-ssp">An OSCAL SAP must have an import-ssp element.</sch:assert>
            <sch:let
                name="web-apps"
                value="
                $ssp-doc//oscal:component[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid  |
                $ssp-doc//oscal:inventory-item[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid |
                //oscal:local-definitions/oscal:activity[oscal:prop[@value eq 'web-application']]/@uuid" />
            <sch:let name="sap-web-tasks"
                value="//oscal:task[oscal:prop[@value='web-application']]/oscal:associated-activity/@activity-uuid ! xs:string(.)"/>
            <sch:let name="missing-web-tasks"
                value="$web-apps[not(. = $sap-web-tasks)]"/>
            <sch:assert
                diagnostics="has-web-applications-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true()"
                id="has-web-applications"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/31"
                test="count($web-apps[not(. = $sap-web-tasks)]) = 0"
                unit:override-xspec="both">For every web interface to be tested there must be a matching task entry.</sch:assert>
            
            <sch:assert
                diagnostics="has-location-assessment-subject-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.3"
                id="has-location-assessment-subject"
                role="error"
                test="exists(oscal:assessment-subject[@type='location'])">A FedRAMP SAP must have a assesment-subject with a type of 'location'.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:import-ssp">
            <sch:assert
                diagnostics="has-import-ssp-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-href"
                role="error"
                test="exists(@href)">An OSCAL SAP import-ssp element must have an href attribute.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
`;

const TEST_XSPEC = `<x:description
    schematron="../../rules/ssp.sch"
    xmlns:f="https://fedramp.gov/ns/oscal"
    xmlns:lv="local-validations"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <x:param
        name="allow-foreign">true</x:param>
    <x:param
        name="only-child-elements">false</x:param>
    <x:param
        name="visit-text">true</x:param>
    <x:scenario
        label="For an OSCAL FedRAMP SSP">
        <x:scenario
            label="Section 2.1">
            <x:scenario
                label="when the security sensitivity level">                
                <x:scenario
                    label="is defined">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level>fips-199-moderate</security-sensitivity-level>
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-not-assert
                        id="no-security-sensitivity-level"
                        label="it is valid." />
                </x:scenario>
                <x:scenario
                    label="is not defined at all">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level />
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-assert
                        id="no-security-sensitivity-level"
                        label="it is invalid." />
                </x:scenario>
                <x:scenario
                    label="is set to a value from the official FedRAMP list">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level>fips-199-low</security-sensitivity-level>
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-not-assert
                        id="invalid-security-sensitivity-level"
                        label="it is valid." />
                </x:scenario>
                <x:scenario
                    label="is not set to a value from the official FedRAMP list">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level>invalid</security-sensitivity-level>
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-assert
                        id="invalid-security-sensitivity-level"
                        label="it is invalid." />
                </x:scenario>
                <x:scenario
                    label="matches the highest value in the security impact levels, security objectives">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level>fips-199-moderate</security-sensitivity-level>
                                <security-impact-level>
                                    <security-objective-confidentiality>fips-199-moderate</security-objective-confidentiality>
                                    <security-objective-integrity>fips-199-moderate</security-objective-integrity>
                                    <security-objective-availability>fips-199-moderate</security-objective-availability>
                                </security-impact-level>
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-not-assert
                        id="security-sensitivity-level-matches-security-impact-level"
                        label="it is correct." />
                </x:scenario>
                <x:scenario
                    label="does not match the highest value in the security impact levels, security objectives">
                    <x:context>
                        <system-security-plan
                            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                            <system-characteristics>
                                <security-sensitivity-level>fips-199-moderate</security-sensitivity-level>
                                <security-impact-level>
                                    <security-objective-confidentiality>fips-199-high</security-objective-confidentiality>
                                    <security-objective-integrity>fips-199-moderate</security-objective-integrity>
                                    <security-objective-availability>fips-199-moderate</security-objective-availability>
                                </security-impact-level>
                            </system-characteristics>
                        </system-security-plan>
                    </x:context>
                    <x:expect-assert
                        id="security-sensitivity-level-matches-security-impact-level"
                        label="it is incorrect." />
                </x:scenario>
            </x:scenario>
        </x:scenario>
    </x:scenario>
</x:description>`;
