import { describe, expect, it } from 'vitest';
import { getSchematronAssertLineRanges } from './schematron';

describe('schematron', () => {
  describe('getSchematronAssertLineRanges', () => {
    it('returns line numbers for sch:assert', () => {
      const lineNumbers = getSchematronAssertLineRanges(TEST_SCH);
      expect(lineNumbers).toEqual({
        'has-import-ssp': {
          end: 13,
          start: 8,
        },
        'has-import-ssp-href': {
          end: 48,
          start: 43,
        },
        'has-location-assessment-subject': {
          end: 39,
          start: 34,
        },
        'has-web-applications': {
          end: 32,
          start: 24,
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
