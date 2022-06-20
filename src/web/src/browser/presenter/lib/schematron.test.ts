import { it, describe, expect } from 'vitest';

import type { BaseState, PassStatus } from '../state/schematron-machine';
import * as lib from './schematron';

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
          passStatus: 'all' as PassStatus,
          role: 'error',
          text: '',
          assertionViewId: 0,
        },
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
      } as unknown as BaseState,
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
      const result = lib.getSchematronReport(testData);
      expect(result).toEqual({
        groups: [
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
            title: 'Assertion group title',
          },
        ],
        summary: {
          counts: { assertions: 2 },
          subtitle: 'Assertion view title',
          title: 'Validator title',
        },
      });
    });
  });

  describe('getFilterOptions', () => {
    it('handles empty state', () => {
      const options = lib.getFilterOptions({
        config: {
          assertionViews: [],
          schematronAsserts: [],
        },
        filter: {
          passStatus: 'all',
          role: 'error',
          text: '',
          assertionViewId: 1,
        },
        failedAssertionMap: null,
      });
      expect(options).toEqual({
        assertionViews: [],
        roles: [
          {
            count: 0,
            name: 'all',
            subtitle: 'View all rules',
          },
        ],
        passStatuses: [
          {
            count: 0,
            enabled: false,
            id: 'all',
            title: 'All assertions',
          },
          {
            count: 0,
            enabled: false,
            id: 'pass',
            title: 'Passing assertions',
          },
          {
            count: 0,
            enabled: false,
            id: 'fail',
            title: 'Failing assertions',
          },
        ],
      });
    });
    it('handles group with two assertions', () => {
      const options = lib.getFilterOptions({
        config: {
          assertionViews: [
            {
              title: 'assertion view 1',
              groups: [
                {
                  title: 'assertion group 1',
                  assertionIds: ['0', '1'],
                  groups: [],
                },
              ],
            },
          ],
          schematronAsserts: [
            { id: '0', message: 'msg0', role: 'error' },
            { id: '1', message: 'msg1', role: 'error' },
            { id: '2', message: 'msg2', role: 'error' },
          ],
        },
        filter: {
          passStatus: 'all',
          role: 'error',
          text: '',
          assertionViewId: 0,
        },
        failedAssertionMap: null,
      });
      expect(options).toEqual({
        assertionViews: [
          {
            index: 0,
            title: 'assertion view 1',
            count: 2,
          },
        ],
        roles: [
          { name: 'all', subtitle: 'View all rules', count: 2 },
          {
            name: 'error',
            subtitle: 'View required, critical rules',
            count: 2,
          },
        ],
        passStatuses: [
          {
            count: 2,
            enabled: false,
            id: 'all',
            title: 'All assertions',
          },
          {
            count: 2,
            enabled: false,
            id: 'pass',
            title: 'Passing assertions',
          },
          {
            count: 2,
            enabled: false,
            id: 'fail',
            title: 'Failing assertions',
          },
        ],
      });
    });
  });

  describe('filterAssertions', () => {
    it('by role', () => {
      expect(
        lib.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
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
        },
      ]);
    });
    it('by text', () => {
      expect(
        lib.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
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
        },
      ]);
    });
    it('by text exclusive of role', () => {
      expect(
        lib.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
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
        lib.filterAssertions(
          MOCK_SCHEMATRON_ASSERTIONS,
          {
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

const MOCK_SCHEMATRON_ASSERTIONS = [
  {
    id: 'incorrect-role-association',
    message: 'incorrect role assertion message',
    role: 'error',
  },
  {
    id: 'incomplete-core-implemented-requirements',
    message: 'incomplete core implemented requirements assertion message',
    role: 'info',
  },
  {
    id: 'untriggered-requirement',
    message: 'untriggered requirement assertion message',
    role: 'warn',
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
