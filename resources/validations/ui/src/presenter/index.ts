import { createOvermind, IConfig } from 'overmind';
import { namespaced } from 'overmind/config';

import * as report from './report';

type UseCases = report.UseCases;

export const getPresenterConfig = (useCases: UseCases) => {
  return namespaced({
    report: report.getPresenterConfig(useCases),
  });
};
type ConfigType = ReturnType<typeof getPresenterConfig>;
declare module 'overmind' {
  interface Config extends IConfig<ConfigType> {}
}

export const createPresenter = (useCases: UseCases) => {
  return createOvermind(getPresenterConfig(useCases), {
    devtools: false,
  });
};
export type Presenter = ReturnType<typeof createPresenter>;
