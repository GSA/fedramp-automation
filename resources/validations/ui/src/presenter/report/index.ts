import type { ValidateSchematronUseCase } from '../../use-cases/validate-ssp-xml';

import * as actions from './actions';
import { state } from './state';

export const getPresenterConfig = () => {
  return {
    state,
    actions,
  };
};
