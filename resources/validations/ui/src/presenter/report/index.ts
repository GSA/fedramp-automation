import type { ValidateSchematronUseCase } from '../../use-cases/validate-ssp-xml';

import * as actions from './actions';
import { state } from './state';

export type UseCases = {
  validateSchematron: ValidateSchematronUseCase;
};

export const getPresenterConfig = (useCases: UseCases) => {
  return {
    state,
    actions,
    effects: {
      useCases: useCases,
    },
  };
};
