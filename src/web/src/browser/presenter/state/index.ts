import * as assertionDocumentation from './assertion-documetation';
import * as metrics from './metrics';
import * as routerMachine from './router-machine';
import * as schematronMachine from './schematron-machine';
import * as validatorMachine from './validator-machine';
import * as validationResultsMachine from './validation-results-machine';

export type State = {
  config: {
    baseUrl: `${string}/`;
    sourceRepository: {
      treeUrl?: string;
      sampleDocuments: SampleDocument[];
      developerExampleUrl?: string;
    };
  };
  assertionDocumentation: assertionDocumentation.State;
  metrics: metrics.State;
  oscalDocuments: {
    poam: schematronMachine.State;
    sap: schematronMachine.State;
    sar: schematronMachine.State;
    ssp: schematronMachine.State;
  };
  router: routerMachine.State;
  validator: validatorMachine.State;
};

export type StateTransition =
  | assertionDocumentation.StateTransition
  | metrics.StateTransition
  | routerMachine.StateTransition
  | schematronMachine.StateTransition
  | validatorMachine.StateTransition
  | validationResultsMachine.StateTransition;

export const initialState: State = {
  config: {
    baseUrl: '/',
    sourceRepository: {
      sampleDocuments: [],
    },
  },
  assertionDocumentation: assertionDocumentation.initialState,
  metrics: metrics.initialState,
  oscalDocuments: {
    poam: schematronMachine.initialState,
    sap: schematronMachine.initialState,
    sar: schematronMachine.initialState,
    ssp: schematronMachine.initialState,
  },
  router: routerMachine.initialState,
  validator: validatorMachine.initialState,
};

export const rootReducer = (state: State, event: StateTransition): State => ({
  config: state.config,
  assertionDocumentation: assertionDocumentation.nextState(
    state.assertionDocumentation,
    event as assertionDocumentation.StateTransition,
  ),
  metrics: metrics.nextState(state.metrics, event as metrics.StateTransition),
  oscalDocuments: {
    poam: schematronMachine.nextState(
      state.oscalDocuments.poam,
      event as unknown as schematronMachine.StateTransition,
    ),
    sap: schematronMachine.nextState(
      state.oscalDocuments.poam,
      event as unknown as schematronMachine.StateTransition,
    ),
    sar: schematronMachine.nextState(
      state.oscalDocuments.poam,
      event as unknown as schematronMachine.StateTransition,
    ),
    ssp: schematronMachine.nextState(
      state.oscalDocuments.poam,
      event as unknown as schematronMachine.StateTransition,
    ),
  },
  router: routerMachine.nextState(
    state.router,
    event as routerMachine.StateTransition,
  ),
  validator: validatorMachine.nextState(
    state.validator,
    event as validatorMachine.StateTransition,
  ),
});

export type SampleDocument = {
  url: string;
  displayName: string;
};

export type OldState = {
  newAppContext: any;
};

export const state: OldState = {
  newAppContext: { state: initialState, dispatch: () => {} },
};
