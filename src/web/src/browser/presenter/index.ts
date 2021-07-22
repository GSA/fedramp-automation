import { createOvermind, createOvermindMock, IContext } from 'overmind';

import type { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import type { GetSSPSchematronAssertions } from '@asap/shared/use-cases/schematron';
import type {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '@asap/shared/use-cases/validate-ssp-xml';

import * as actions from './actions';
import type { Location } from './state/router';
import { state, State, SampleSSP } from './state';

type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  getSSPSchematronAssertions: GetSSPSchematronAssertions;
  validateSSP: ValidateSSPUseCase;
  validateSSPUrl: ValidateSSPUrlUseCase;
};

export const getPresenterConfig = (
  location: Location,
  useCases: UseCases,
  initialState: Partial<State> = {},
) => {
  return {
    actions,
    state: {
      ...state,
      ...initialState,
    },
    effects: {
      location,
      useCases,
    },
  };
};
export type PresenterConfig = IContext<ReturnType<typeof getPresenterConfig>>;

export type PresenterContext = {
  baseUrl: string;
  debug: boolean;
  repositoryUrl: string;
  sampleSSPs: SampleSSP[];
  location: Location;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(
    getPresenterConfig(ctx.location, ctx.useCases, {
      baseUrl: ctx.baseUrl,
      repositoryUrl: ctx.repositoryUrl,
      sampleSSPs: ctx.sampleSSPs,
    }),
    {
      devtools: ctx.debug,
      strict: true,
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
    annotateXML: stub,
    getSSPSchematronAssertions: stub,
    validateSSP: stub,
    validateSSPUrl: stub,
  };
};

type MockPresenterContext = {
  useCases?: Partial<UseCases>;
  initialState?: Partial<State>;
};

export const createPresenterMock = (ctx: MockPresenterContext = {}) => {
  const presenter = createOvermindMock(
    getPresenterConfig(
      { listen: jest.fn(), replace: jest.fn() },
      getUseCasesShim(),
      ctx.initialState,
    ),
    {
      useCases: ctx.useCases,
    },
  );
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
