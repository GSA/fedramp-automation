import {
  createOvermind,
  createOvermindMock,
  derived,
  IContext,
} from 'overmind';
import { merge, namespaced } from 'overmind/config';

import * as actions from './actions';
import type { AnnotateXMLUseCase } from '../../../use-cases/annotate-xml';
import type {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '../../../use-cases/validate-ssp-xml';

import * as report from './report';
import * as router from './router';

type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  validateSSP: ValidateSSPUseCase;
  validateSSPUrl: ValidateSSPUrlUseCase;
};

type SampleSSP = {
  url: string;
  displayName: string;
};

type State = {
  currentRoute: router.Route;
  baseUrl: string;
  repositoryUrl?: string;
  sampleSSPs: SampleSSP[];
  breadcrumbs: { text: string; selected: boolean; url: string }[];
};

export const getPresenterConfig = (
  locationListen: router.LocationListener,
  useCases: UseCases,
  initialState: Partial<State> = {},
) => {
  const state: State = {
    currentRoute: router.Routes.home,
    baseUrl: '',
    sampleSSPs: [] as SampleSSP[],
    ...initialState,
    breadcrumbs: derived((state: State) =>
      router.breadcrumbs[state.currentRoute.type](state.currentRoute),
    ),
  };
  return merge(
    {
      actions,
      state,
      effects: {
        locationListen,
        useCases,
      },
    },
    namespaced({
      report: report.getPresenterConfig(),
    }),
  );
};
export type PresenterConfig = IContext<ReturnType<typeof getPresenterConfig>>;

export type PresenterContext = {
  baseUrl: string;
  debug: boolean;
  repositoryUrl: string;
  sampleSSPs: SampleSSP[];
  locationListen: router.LocationListener;
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
