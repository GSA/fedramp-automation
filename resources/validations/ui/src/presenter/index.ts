import { createOvermind, IConfig } from 'overmind';
import { merge, namespaced } from 'overmind/config';

import * as actions from './actions';
import * as report from './report';

type UseCases = report.UseCases;

export const getPresenterConfig = (useCases: UseCases) => {
  return merge(
    {
      state: {
        baseUrl: '',
      },
      actions,
    },
    namespaced({
      report: report.getPresenterConfig(useCases),
    }),
  );
};
export type ConfigType = ReturnType<typeof getPresenterConfig>;
declare module 'overmind' {
  interface Config extends IConfig<ConfigType> {}
}

type PresenterContext = {
  baseUrl: string;
  debug: boolean;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(getPresenterConfig(ctx.useCases), {
    devtools: ctx.debug,
  });
  presenter.actions.setBaseUrl(ctx.baseUrl);
  return presenter;
};
export type Presenter = ReturnType<typeof createPresenter>;
