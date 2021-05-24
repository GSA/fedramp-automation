import { createOvermind, IConfig } from 'overmind';

import type { ValidateSspXml } from '../use-cases/validate-ssp-xml';

import * as actions from './actions';
import { state } from './state';

type UseCases = {
  validateSspXml: ValidateSspXml;
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
declare module 'overmind' {
  interface Config extends IConfig<ReturnType<typeof getPresenterConfig>> {}
}

export const createPresenter = (useCases: UseCases) => {
  return createOvermind(getPresenterConfig(useCases), {
    devtools: false,
  });
};
export type Presenter = ReturnType<typeof createPresenter>;
