import { derived } from 'overmind';

import type {
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/validate-ssp-xml';

export enum Filter {
  ALL = 'all',
  ERROR = 'error',
  POSITIVE = 'positive',
  WARN = 'warn',
  WARNING = 'warning',
}

type State = {
  filter: Filter;
  loadingValidationReport: boolean;
  roles: Set<string>;
  filterRoles: string[];
  validationReport: ValidationReport | null;
  visibleAssertions: ValidationAssert[];
};

export const state: State = {
  filter: Filter.WARN,
  loadingValidationReport: false,
  validationReport: null,
  roles: derived(({ validationReport }: State) => {
    if (!validationReport) {
      return new Set();
    }
    return new Set(validationReport.failedAsserts.map(assert => assert.role));
  }),
  filterRoles: derived(({ filter }: State) => {
    return [filter.valueOf()];
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
