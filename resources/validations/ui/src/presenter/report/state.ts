import { derived, filter } from 'overmind';

import type {
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/validate-ssp-xml';

export type Role = string;

type State = {
  filter: {
    role: Role;
    text: string;
  };
  loadingValidationReport: boolean;
  roles: Role[];
  filterRoles: Role[];
  validationReport: ValidationReport | null;
  visibleAssertions: ValidationAssert[];
};

export const state: State = {
  filter: {
    role: 'all',
    text: '',
  },
  loadingValidationReport: false,
  validationReport: null,
  roles: derived(({ validationReport }: State) => {
    if (!validationReport) {
      return [];
    }
    return [
      'all',
      ...Array.from(
        new Set(
          validationReport.failedAsserts
            .map(assert => assert.role)
            .filter(role => role),
        ),
      ).sort(),
    ];
  }),
  filterRoles: derived(({ filter, roles }: State) => {
    switch (filter.role) {
      case 'all':
        return roles;
      default:
        return [filter.role];
    }
  }),
  visibleAssertions: derived(
    ({ filter, filterRoles, validationReport }: State) => {
      if (!validationReport) {
        return [];
      }
      let assertions = validationReport.failedAsserts.filter(
        (assertion: ValidationAssert) => {
          return filterRoles.includes(assertion.role);
        },
      );
      if (filter.text.length > 0) {
        assertions = assertions.filter(assertion => {
          const allText = Object.values(assertion).join('\n').toLowerCase();
          return allText.includes(filter.text.toLowerCase());
        });
      }
      return assertions;
    },
  ),
};
