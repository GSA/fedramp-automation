import type { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import type { GetXSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import type { GetAssertionViews } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import type { GetSchematronAssertions } from '@asap/shared/use-cases/schematron';

import type { Location } from './state/router';
import { State, StateTransition, initialState } from './state';

export type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  getAssertionViews: GetAssertionViews;
  getSchematronAssertions: GetSchematronAssertions;
  getXSpecScenarioSummaries: GetXSpecScenarioSummaries;
  oscalService: OscalService;
};

export type Effects = {
  location: Location;
  useCases: UseCases;
};

export const getInitialState = (config: State['config']) => {
  return {
    ...initialState,
    config,
  };
};

export type ActionContext = {
  effects: {
    location: Location;
    useCases: UseCases;
  };
  getState: () => State;
  dispatch: ActionDispatch<State, StateTransition, Effects>;
};

export interface ActionDispatch<S, A, E> {
  <
    Action extends ({
      dispatch,
      getState,
      effects,
    }: {
      dispatch: ActionDispatch<S, A, E>;
      getState: () => S;
      effects: E;
    }) => unknown,
  >(
    action: Action,
  ): ReturnType<Action>;
  (value: A): void;
}
