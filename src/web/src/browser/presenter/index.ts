import { mock } from 'jest-mock-extended';
import { createOvermind, createOvermindMock, IContext } from 'overmind';

import type { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import type { AppMetrics } from '@asap/shared/use-cases/app-metrics';
import type { GetXSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import type { GetAssertionViews } from '@asap/shared/use-cases/assertion-views';
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
  getAssertionViews: GetAssertionViews;
  getSSPSchematronAssertions: GetSSPSchematronAssertions;
  getXSpecScenarioSummaries: GetXSpecScenarioSummaries;
  appMetrics: AppMetrics;
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
  sourceRepository: {
    treeUrl: string;
    sampleSSPs: SampleSSP[];
    developerExampleUrl: string;
  };
  location: Location;
  useCases: UseCases;
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(
    getPresenterConfig(ctx.location, ctx.useCases, {
      baseUrl: ctx.baseUrl,
      sourceRepository: ctx.sourceRepository,
    }),
    {
      devtools: ctx.debug,
      strict: true,
    },
  );
  return presenter;
};
export type Presenter = ReturnType<typeof createPresenter>;

type MockPresenterContext = {
  useCases?: Partial<UseCases>;
  initialState?: Partial<State>;
};

export const createPresenterMock = (ctx: MockPresenterContext = {}) => {
  const presenter = createOvermindMock(
    getPresenterConfig(
      { listen: jest.fn(), replace: jest.fn() },
      mock<UseCases>(),
      ctx.initialState,
    ),
    {
      useCases: ctx.useCases,
    },
  );
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
