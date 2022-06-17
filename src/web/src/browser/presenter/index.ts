import { createOvermind, IContext } from 'overmind';

import type { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import type { AppMetrics } from '@asap/shared/use-cases/app-metrics';
import type { GetXSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import type { GetAssertionViews } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import type { GetSchematronAssertions } from '@asap/shared/use-cases/schematron';

import * as actions from './actions';
import type { Location } from './state/router';
import {
  state,
  State,
  SampleDocument,
  NewState,
  NewEvent,
  initialState,
} from './state';
import { ThunkDispatch } from '../views/hooks';

export type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  getAssertionViews: GetAssertionViews;
  getSchematronAssertions: GetSchematronAssertions;
  getXSpecScenarioSummaries: GetXSpecScenarioSummaries;
  appMetrics: AppMetrics;
  oscalService: OscalService;
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
  debug: boolean;
  sourceRepository: {
    treeUrl: string;
    sampleDocuments: SampleDocument[];
    developerExampleUrl: string;
  };
  location: Location;
  useCases: UseCases;
};

export const getInitialState = (options: { baseUrl: `${string}/` }) => {
  return {
    ...initialState,
    ...options,
  };
};

export const createPresenter = (ctx: PresenterContext) => {
  const presenter = createOvermind(
    getPresenterConfig(ctx.location, ctx.useCases, {
      sourceRepository: ctx.sourceRepository,
    }),
    {
      devtools: ctx.debug,
      strict: false,
    },
  );
  return presenter;
};
export type Presenter = ReturnType<typeof createPresenter>;

export type NewPresenterConfig = {
  effects: {
    location: Location;
    useCases: UseCases;
  };
  getState: () => NewState;
  dispatch: ThunkDispatch<NewState, NewEvent, Presenter['effects']>;
};
