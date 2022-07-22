import type { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import type { GetXSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import type { GetAssertionViews } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import type { GetSchematronAssertions } from '@asap/shared/use-cases/schematron';

import type { Location } from './state/router';
import { State, StateTransition, initialState } from './state';
import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { DocumentReferenceUrls } from '@asap/shared/domain/source-code-links';

export type UseCases = {
  annotateXML: AnnotateXMLUseCase;
  getAssertionViews: GetAssertionViews;
  getDocumentReferenceUrls: () => Promise<
    Record<OscalDocumentKey, DocumentReferenceUrls>
  >;
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
    ThunkAction extends ({
      dispatch,
      getState,
      effects,
    }: {
      dispatch: ActionDispatch<S, A, E>;
      getState: () => S;
      effects: E;
    }) => unknown,
  >(
    action: ThunkAction | StateTransition,
  ): ReturnType<ThunkAction>;
  (value: A): void;
}
