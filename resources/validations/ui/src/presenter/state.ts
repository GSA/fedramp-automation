import type { ValidationReport } from '../use-cases/validate-ssp-xml';

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
  validationReport: ValidationReport | null;
};

export const state: State = {
  filter: Filter.ALL,
  loadingValidationReport: false,
  validationReport: null,
};
