import { describe, expect, it } from 'vitest';
import { getElementString, linesOf, linesOfXml } from './text';

describe('text domain', () => {
  describe('getElementString', () => {
    it('work with one closing tag', () => {
      const elementString = getElementString(
        TEST_SCH,
        ['sch:schema', 'sch:pattern', 'sch:rule', 'sch:assert'],
        ['sch:assert'],
      );
      expect(elementString).toEqual(`<sch:assert
                diagnostics="has-import-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp"
                role="error"
                test="oscal:import-ssp">An OSCAL SAP must have an import-ssp element.</sch:assert>`);
    });
    it('work with two closing tags', () => {
      const elementString = getElementString(
        TEST_SCH,
        ['sch:schema', 'sch:pattern', 'sch:rule'],
        ['sch:assert', 'sch:rule'],
      );
      expect(elementString).toEqual(`<sch:rule
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
        </sch:rule>`);
    });
    it('works with duplicate opening tag and two closing tags', () => {
      const elementString = getElementString(
        TEST_SCH,
        ['sch:schema', 'sch:pattern', 'sch:rule', 'sch:rule'],
        ['sch:rule'],
      );
      expect(elementString).toEqual(`<sch:rule
            context="oscal:import-ssp">
            <sch:assert
                diagnostics="has-import-ssp-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-href"
                role="error"
                test="exists(@href)">An OSCAL SAP import-ssp element must have an href attribute.</sch:assert>
        </sch:rule>`);
    });
  });

  describe('linesOf', () => {
    it('returns line numbers for sch:assert', () => {
      const lineNumbers = linesOf(
        TEST_SCH,
        `<sch:assert
                diagnostics="has-web-applications-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true()"
                id="has-web-applications"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/31"
                test="count($web-apps[not(. = $sap-web-tasks)]) = 0"
                unit:override-xspec="both">For every web interface to be tested there must be a matching task entry.</sch:assert>`,
      );
      expect(lineNumbers).toEqual({
        end: 32,
        start: 24,
      });
    });
  });

  describe('linesOfXml', () => {
    it('returns line numbers for nested xml node', () => {
      expect(
        linesOfXml(
          TEST_SCH,
          ['sch:schema', 'sch:pattern', 'sch:rule', 'sch:rule', 'sch:assert'],
          ['sch:assert'],
        ),
      ).toEqual({
        start: 43,
        end: 48,
      });
    });
    it('returns line numbers for nested xml node with parents', () => {
      expect(
        linesOfXml(
          TEST_SCH,
          ['sch:schema', 'sch:pattern', 'sch:rule', 'sch:rule'],
          ['sch:rule'],
        ),
      ).toEqual({
        start: 41,
        end: 49,
      });
    });
    it('returns line numbers for xml with self-closing tags', () => {
      expect(
        linesOfXml(
          TEST_XSPEC,
          [
            'x:description',
            'x:scenario',
            'x:scenario',
            'x:scenario',
            'x:context',
            'x:expect-assert',
          ],
          ['x:expect-assert'],
        ),
      ).toEqual({
        start: 18,
        end: 20,
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

const TEST_XSPEC = `<?xml version="1.0" encoding="UTF-8"?>
<x:description
    schematron="../../rules/poam.sch"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:x="http://www.jenitennison.com/xslt/xspec">
    <x:scenario
        label="sanity-checks">
        <x:scenario
            label="when the root element">
            <x:scenario
                label="is not in OSCAL 1.0 namespace">
                <x:context>
                    <plan-of-action-and-milestones>
                        <!-- note lack of namespace -->
                    </plan-of-action-and-milestones>
                </x:context>
                <x:expect-assert
                    id="document-is-OSCAL-document"
                    label="that is an error" />
            </x:scenario>
        </x:scenario>
    </x:scenario>
</x:description>`;
