import { derived } from 'overmind';

import type {
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/validate-ssp-xml';

export type Filter = string;

type State = {
  filter: Filter;
  loadingValidationReport: boolean;
  roles: Filter[];
  filterRoles: Filter[];
  validationReport: ValidationReport | null;
  visibleAssertions: ValidationAssert[];
};

export const state: State = {
  filter: 'all',
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
    switch (filter) {
      case 'all':
        return roles;
      default:
        return [filter];
    }
  }),
  visibleAssertions: derived(({ filterRoles, validationReport }: State) => {
    if (!validationReport) {
      return [];
    }
    return validationReport.failedAsserts.filter(
      (assertion: ValidationAssert) => {
        return filterRoles.includes(assertion.role);
      },
    );
  }),
};
