import { createOvermind, IConfig } from 'overmind';
import { namespaced } from 'overmind/config';

import * as report from './report';

type UseCases = report.UseCases;

export const getPresenterConfig = (useCases: UseCases) => {
  return namespaced({
    report: report.getPresenterConfig(useCases),
  });
};
export type ConfigType = ReturnType<typeof getPresenterConfig>;
declare module 'overmind' {
  interface Config extends IConfig<ConfigType> {}
}

type PresenterContext = {
  useCases: UseCases;
  debug: boolean;
};

export const createPresenter = (ctx: PresenterContext) => {
  return createOvermind(getPresenterConfig(ctx.useCases), {
    devtools: ctx.debug,
  });
};
export type Presenter = ReturnType<typeof createPresenter>;
