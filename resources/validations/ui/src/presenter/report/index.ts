import type { ValidateSchematronUseCase } from '../../use-cases/validate-ssp-xml';

import * as actions from './actions';
import { state } from './state';

export type UseCases = {
  validateSchematron: ValidateSchematronUseCase;
};

export const getPresenterConfig = () => {
  return {
    state,
    actions,
  };
};
