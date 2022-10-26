import { it, describe, expect } from 'vitest';

import { SchematronAssert } from '@asap/shared/domain/schematron';
import type { BaseState, PassStatus } from '../state/schematron-machine';
import * as helpers from './helpers';

describe('presenter schematron library', () => {
  describe('getSchematronReport', () => {
    const testData = {
      state: {
        config: {
          assertionViews: [
            {
              title: 'Assertion view title',
              groups: [
                {
                  title: 'Assertion group title',
                  assertionIds: ['unique-1', 'unique-2'],
                  groups: undefined,
                },
              ],
            },
          ],
          schematronAsserts: [
            {
              id: 'unique-1',
              message: 'Assertion message',
              role: 'error',
            },
            {
              id: 'unique-2',
              message: 'Assertion message',
              role: 'error',
            },
            {
              id: 'unique-3',
              message: 'Assertion message',
              role: 'error',
            },
          ],
        },
        filter: {
          fedrampSpecificOption: 'all',
          passStatus: 'all' as PassStatus,
          role: 'error',
          text: '',
          assertionViewId: 0,
        },
      } as unknown as BaseState,
      filterOptions: {
        assertionViews: [
          {
            index: 0,
            title: 'Assertion view title',
            count: 5,
          },
        ],
        roles: [
          { name: 'error', subtitle: 'sub1', count: 5 },
          { name: 'warning', subtitle: 'sub2', count: 6 },
        ],
        passStatuses: [
          {
            id: 'all' as PassStatus,
            count: 5,
            title: 'All',
            enabled: false,
          },
        ],
      },
      validator: {
        title: 'Validator title',
        failedAssertionMap: {
          '1': [
            {
              uniqueId: 'unique-1',
              id: '1',
              text: 'Assertion text',
              location: '//xpath',
              test: 'true/false',
              diagnosticReferences: ['Diagnostic text 1'],
            },
          ],
          '3': [
            {
              uniqueId: 'unique-3',
              id: '3',
              text: 'Assertion text',
              location: '//xpath',
              test: 'true/false',
              diagnosticReferences: ['Diagnostic text 2'],
            },
          ],
        },
      },
      summariesByAssertionId: {
        'no-security-sensitivity-level': [
          {
            assertionId: 'no-security-sensitivity-level',
            assertionLabel: 'it is invalid.',
            context:
              '<span class="hljs-tag">&lt;<span class="hljs-name">system-security-plan</span> <span class="hljs-attr">xmlns</span>=<span class="hljs-string">&quot;http://csrc.nist.gov/ns/oscal/1.0&quot;</span>&gt;</span>\r\n    <span class="hljs-tag">&lt;<span class="hljs-name">system-characteristics</span>&gt;</span>\r\n        <span class="hljs-tag">&lt;<span class="hljs-name">security-sensitivity-level</span>/&gt;</span>\r\n    <span class="hljs-tag">&lt;/<span class="hljs-name">system-characteristics</span>&gt;</span>\r\n<span class="hljs-tag">&lt;/<span class="hljs-name">system-security-plan</span>&gt;</span>',
            label:
              'For an OSCAL FedRAMP SSP Section 2.1 when the security sensitivity level is not defined at all',
          },
        ],
        'invalid-security-sensitivity-level': [
          {
            assertionId: 'invalid-security-sensitivity-level',
            assertionLabel: 'it is valid.',
            context:
              '<span class="hljs-tag">&lt;<span class="hljs-name">system-security-plan</span> <span class="hljs-attr">xmlns</span>=<span class="hljs-string">&quot;http://csrc.nist.gov/ns/oscal/1.0&quot;</span>&gt;</span>\r\n    <span class="hljs-tag">&lt;<span class="hljs-name">system-characteristics</span>&gt;</span>\r\n        <span class="hljs-tag">&lt;<span class="hljs-name">security-sensitivity-level</span>&gt;</span>\r\n            fips-199-low\r\n        <span class="hljs-tag">&lt;/<span class="hljs-name">security-sensitivity-level</span>&gt;</span>\r\n    <span class="hljs-tag">&lt;/<span class="hljs-name">system-characteristics</span>&gt;</span>\r\n<span class="hljs-tag">&lt;/<span class="hljs-name">system-security-plan</span>&gt;</span>',
            label:
              'For an OSCAL FedRAMP SSP Section 2.1 when the security sensitivity level is set to a value from the official FedRAMP list',
          },
        ],
      },
    };

    it('works', () => {
      const result = helpers.getReportGroups(
        testData.state.config.assertionViews[0],
        testData.state.config.schematronAsserts,
        testData.validator.failedAssertionMap,
      );
      expect(result).toEqual([
        {
          checks: {
            checks: [
              {
                fired: [],
                icon: {
                  color: 'green',
                  sprite: 'check_circle',
                },
                id: 'unique-1',
                message: 'Assertion message',
                role: 'error',
              },
              {
                fired: [],
                icon: {
                  color: 'green',
                  sprite: 'check_circle',
                },
                id: 'unique-2',
                message: 'Assertion message',
                role: 'error',
              },
            ],
            summary: '0 / 2 flagged',
            summaryColor: 'green',
          },
          isValidated: true,
          title: 'Assertion group title',
        },
      ]);
    });
  });

  describe('filterAssertions', () => {
    it('by role', () => {
      expect(
        helpers.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
            fedrampSpecific: 'all',
            passStatus: 'all',
            role: 'error',
            text: '',
            assertionViewIds: ['incorrect-role-association'],
          },
          ['error', 'info'],
          null,
        ),
      ).toEqual([
        {
          id: 'incorrect-role-association',
          message: 'incorrect role assertion message',
          role: 'error',
          referenceUrl: '#TODO',
          fedrampSpecific: true,
        },
      ]);
    });
    it('by text', () => {
      expect(
        helpers.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
            fedrampSpecific: 'all',
            passStatus: 'all',
            role: 'all',
            text: 'role assertion',
            assertionViewIds: ['incorrect-role-association'],
          },
          ['error', 'info'],
          null,
        ),
      ).toEqual([
        {
          id: 'incorrect-role-association',
          message: 'incorrect role assertion message',
          role: 'error',
          referenceUrl: '#TODO',
          fedrampSpecific: true,
        },
      ]);
    });
    it('by text exclusive of role', () => {
      expect(
        helpers.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
            fedrampSpecific: 'all',
            passStatus: 'all',
            role: 'non-matching',
            text: 'role assertion',
            assertionViewIds: ['incorrect-role-association'],
          },
          ['error', 'info'],
          null,
        ),
      ).toEqual([]);
    });
    it('by role exclusive of text', () => {
      expect(
        helpers.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
            fedrampSpecific: 'all',
            passStatus: 'all',
            role: 'error',
            text: 'non-matching',
            assertionViewIds: ['incorrect-role-association'],
          },
          ['error', 'info'],
          null,
        ),
      ).toEqual([]);
    });
  });
});

const MOCK_SCHEMATRON_ASSERTIONS: SchematronAssert[] = [
  {
    id: 'incorrect-role-association',
    message: 'incorrect role assertion message',
    role: 'error',
    referenceUrl: '#TODO',
    fedrampSpecific: true,
  },
  {
    id: 'incomplete-core-implemented-requirements',
    message: 'incomplete core implemented requirements assertion message',
    role: 'info',
    referenceUrl: '#TODO',
    fedrampSpecific: true,
  },
  {
    id: 'untriggered-requirement',
    message: 'untriggered requirement assertion message',
    role: 'warn',
    referenceUrl: '#TODO',
    fedrampSpecific: true,
  },
];

const MOCK_VALIDATION_REPORT = {
  title: 'title',
  failedAsserts: [
    {
      text: 'ASSERT TEXT 1',
      test: 'not(exists($extraneous-roles))',
      id: 'incorrect-role-association',
      uniqueId: 'incorrect-role-association-1',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
      diagnosticReferences: [],
    },
    {
      text: 'ASSERT TEXT 2',
      test: 'not(exists($core-missing))',
      id: 'incomplete-core-implemented-requirements',
      uniqueId: 'incomplete-core-implemented-requirements-1',
      role: 'error',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
      diagnosticReferences: [],
    },
  ],
};
