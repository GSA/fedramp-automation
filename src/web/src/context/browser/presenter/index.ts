import { createOvermind, createOvermindMock, IContext } from 'overmind';

import * as actions from './actions';
import type { GetSSPSchematronAssertions } from '../../../use-cases/schematron';
import type { AnnotateXMLUseCase } from '../../../use-cases/annotate-xml';
import type {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '../../../use-cases/validate-ssp-xml';

import type { LocationListener } from './router';
import { state, State, SampleSSP } from './state';

type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  getSSPSchematronAssertions: GetSSPSchematronAssertions;
  validateSSP: ValidateSSPUseCase;
  validateSSPUrl: ValidateSSPUrlUseCase;
};

export const getPresenterConfig = (
  locationListen: LocationListener,
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
      locationListen,
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
  locationListen: LocationListener;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(
    getPresenterConfig(ctx.locationListen, ctx.useCases, {
      baseUrl: ctx.baseUrl,
      repositoryUrl: ctx.repositoryUrl,
      sampleSSPs: ctx.sampleSSPs,
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
    getPresenterConfig(jest.fn(), getUseCasesShim(), ctx.initialState),
    {
      useCases: ctx.useCases,
    },
  );
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
