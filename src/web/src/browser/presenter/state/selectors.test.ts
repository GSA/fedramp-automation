import { describe, expect, it } from 'vitest';
import { selectFilterOptions } from './selectors';

describe('selectors', () => {
  describe('selectFilterOptions', () => {
    it('handles group with two assertions', () => {
      const options = selectFilterOptions('ssp').resultFunc(
        {
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
            {
              id: '0',
              message: 'msg0',
              role: 'error',
              referenceUrl: '#TODO',
              fedrampSpecific: true,
            },
            {
              id: '1',
              message: 'msg1',
              role: 'error',
              referenceUrl: '#TODO',
              fedrampSpecific: true,
            },
            {
              id: '2',
              message: 'msg2',
              role: 'error',
              referenceUrl: '#TODO',
              fedrampSpecific: true,
            },
          ],
        },
        {
          fedrampSpecificOption: 'all',
          passStatus: 'all',
          role: 'error',
          text: '',
          assertionViewId: 0,
        },
        null,
        ['0', '1'],
      );
      expect(options).toEqual({
        fedrampSpecificOptions: [
          {
            count: 2,
            enabled: true,
            option: 'all',
            subtitle: 'All validation rules',
          },
          {
            count: 2,
            enabled: false,
            option: 'fedramp',
            subtitle: 'FedRAMP-specific validation rules',
          },
          {
            count: 0,
            enabled: false,
            option: 'non-fedramp',
            subtitle: 'General OSCAL validation rules',
          },
        ],
        assertionViews: [
          {
            index: 0,
            title: 'assertion view 1',
            count: 2,
            groups: [
              {
                assertionIds: ['0', '1'],
                groups: [],
                title: 'assertion group 1',
              },
            ],
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

  describe('selectFilterOptions', () => {
    it('handles empty state', () => {
      const options = selectFilterOptions('ssp').resultFunc(
        {
          assertionViews: [],
          schematronAsserts: [],
        },
        {
          fedrampSpecificOption: 'all',
          passStatus: 'all',
          role: 'error',
          text: '',
          assertionViewId: 1,
        },
        null,
        ['0', '1'],
      );
      expect(options).toEqual({
        fedrampSpecificOptions: [
          {
            count: 0,
            option: 'all',
            enabled: true,
            subtitle: 'All validation rules',
          },
          {
            count: 0,
            option: 'fedramp',
            enabled: false,
            subtitle: 'FedRAMP-specific validation rules',
          },
          {
            count: 0,
            option: 'non-fedramp',
            enabled: false,
            subtitle: 'General OSCAL validation rules',
          },
        ],
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
  });
});
