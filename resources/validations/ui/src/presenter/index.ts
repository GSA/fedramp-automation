import { createOvermind, createOvermindMock, IConfig } from 'overmind';
import { merge, namespaced } from 'overmind/config';
import type { ValidateSchematronUseCase } from 'src/use-cases/validate-ssp-xml';

import * as actions from './actions';
import * as report from './report';

type UseCases = report.UseCases;

export const getPresenterConfig = (useCases: UseCases) => {
  return merge(
    {
      state: {
        baseUrl: '',
        repositoryUrl: '',
      },
      actions,
      effects: {
        useCases,
      },
    },
    namespaced({
      report: report.getPresenterConfig(),
    }),
  );
};
export type PresenterConfig = ReturnType<typeof getPresenterConfig>;
declare module 'overmind' {
  interface Config extends IConfig<PresenterConfig> {}
}

export type PresenterContext = {
  baseUrl: string;
  debug: boolean;
  repositoryUrl: string;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(getPresenterConfig(ctx.useCases), {
    devtools: ctx.debug,
  });
  presenter.actions.setBaseUrl(ctx.baseUrl);
  presenter.actions.setRepositoryUrl(ctx.repositoryUrl);
  return presenter;
};
export type Presenter = ReturnType<typeof createPresenter>;

export const createPresenterMock = (useCaseMocks?: Partial<UseCases>) => {
  const presenter = createOvermindMock(
    getPresenterConfig({
      validateSchematron: () => console.log as any as ValidateSchematronUseCase,
    } as any as UseCases),
    { useCases: useCaseMocks },
  );
  presenter.actions.setBaseUrl('/');
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
