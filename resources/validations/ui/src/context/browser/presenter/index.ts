import { derived, createOvermind, createOvermindMock, IConfig } from 'overmind';
import { merge, namespaced } from 'overmind/config';

import * as github from '../../../domain/github';
import * as actions from './actions';
import type { ValidateSchematronUseCase } from '../../../use-cases/validate-ssp-xml';

import * as report from './report';

type UseCases = {
  validateSchematron: ValidateSchematronUseCase;
};

type State = {
  baseUrl: string;
  githubRepository: github.GithubRepository;
};

export const getPresenterConfig = (
  useCases: UseCases,
  initialState: Partial<State> = {},
) => {
  return merge(
    {
      actions,
      state: {
        baseUrl: '',
        githubRepository: github.DEFAULT_REPOSITORY,
        ...initialState,
        repositoryUrl: derived(({ githubRepository }: State) =>
          github.getBranchTreeUrl(githubRepository),
        ),
        sampleSSPs: derived(({ githubRepository }: State) => [
          github.getRepositoryRawUrl(
            githubRepository,
            'resources/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
          ),
        ]),
      },
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
  githubRepository: github.GithubRepository;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(
    getPresenterConfig(ctx.useCases, {
      baseUrl: ctx.baseUrl,
      githubRepository: ctx.githubRepository,
    }),
    {
      devtools: ctx.debug,
    },
  );
  return presenter;
};
export type Presenter = ReturnType<typeof createPresenter>;

/**
 * `createOvermindMock` expects actual effect functions. They may be shimmed in
 * with the return value from this function.
 * These use cases will never be called, because Overmind requires mock effects
 * specified as the second parameter of `createOvermindMock`.
 * @returns Stubbed use cases
 */
const getUseCasesShim = (): UseCases => {
  const stub = jest.fn();
  return {
    validateSchematron: stub,
  };
};

type MockPresenterContext = {
  useCaseMocks?: Partial<UseCases>;
  initialState?: Partial<State>;
};

export const createPresenterMock = (ctx: MockPresenterContext = {}) => {
  const presenter = createOvermindMock(
    getPresenterConfig(getUseCasesShim(), ctx.initialState),
    {
      useCases: ctx.useCaseMocks,
    },
  );
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
