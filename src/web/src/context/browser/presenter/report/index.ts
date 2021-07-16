import * as actions from './actions';
import { createReportMachine } from './state';

export const getPresenterConfig = () => {
  return {
    actions,
    state: createReportMachine(),
  };
};
