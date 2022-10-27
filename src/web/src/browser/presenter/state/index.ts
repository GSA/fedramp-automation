import * as assertionDocumentation from './assertion-documetation';
import * as metrics from './metrics';
import * as routerMachine from './router-machine';
import * as schematron from './schematron-machine';
import * as validator from './validator-machine';
import * as validationResults from './validation-results-machine';

export type State = {
  config: {
    baseUrl: `${string}/`;
    sourceRepository: {
      treeUrl?: string;
      sampleDocuments: SampleDocument[];
      developerExampleUrl?: string;
      newIssueUrl?: string;
    };
  };
  assertionDocumentation: assertionDocumentation.State;
  oscalDocuments: {
    poam: schematron.State;
    sap: schematron.State;
    sar: schematron.State;
    ssp: schematron.State;
  };
  router: routerMachine.State;
  validator: validator.State;
  validationResults: {
    poam: validationResults.State;
    sap: validationResults.State;
    sar: validationResults.State;
    ssp: validationResults.State;
  };
};

type ScopedTransition = {
  machine: keyof typeof reducers;
};

export type StateTransition =
  | ScopedTransition &
      (
        | assertionDocumentation.StateTransition
        | metrics.StateTransition
        | routerMachine.StateTransition
        | schematron.StateTransition
        | validator.StateTransition
        | validationResults.StateTransition
      );

export const initialState: State = {
  config: {
    baseUrl: '/',
    sourceRepository: {
      sampleDocuments: [],
    },
  },
  assertionDocumentation: assertionDocumentation.initialState,
  oscalDocuments: {
    poam: schematron.initialState,
    sap: schematron.initialState,
    sar: schematron.initialState,
    ssp: schematron.initialState,
  },
  router: routerMachine.initialState,
  validator: validator.initialState,
  validationResults: {
    poam: validationResults.initialState,
    sap: validationResults.initialState,
    sar: validationResults.initialState,
    ssp: validationResults.initialState,
  },
};

const createMachineReducer =
  <S, ST>(machine: string, nextState: (s: S, e: ST) => S) =>
  (state: S, event: StateTransition) => {
    if (event.machine === machine) {
      return nextState(state, event as unknown as ST);
    }
    return state;
  };

const reducers = {
  assertionDocumentation: createMachineReducer(
    'assertionDocumentation',
    assertionDocumentation.nextState,
  ),
  metrics: createMachineReducer('metrics', metrics.nextState),
  'oscalDocuments.poam': createMachineReducer(
    'oscalDocuments.poam',
    schematron.nextState,
  ),
  'oscalDocuments.sap': createMachineReducer(
    'oscalDocuments.sap',
    schematron.nextState,
  ),
  'oscalDocuments.sar': createMachineReducer(
    'oscalDocuments.sar',
    schematron.nextState,
  ),
  'oscalDocuments.ssp': createMachineReducer(
    'oscalDocuments.ssp',
    schematron.nextState,
  ),
  router: createMachineReducer('router', routerMachine.nextState),
  'validationResults.poam': createMachineReducer(
    'validationResults.poam',
    validationResults.nextState,
  ),
  'validationResults.sap': createMachineReducer(
    'validationResults.sap',
    validationResults.nextState,
  ),
  'validationResults.sar': createMachineReducer(
    'validationResults.sar',
    validationResults.nextState,
  ),
  'validationResults.ssp': createMachineReducer(
    'validationResults.ssp',
    validationResults.nextState,
  ),
  validator: createMachineReducer('validator', validator.nextState),
} as const;

export const rootReducer = (state: State, event: StateTransition): State => ({
  config: state.config,
  assertionDocumentation: reducers.assertionDocumentation(
    state.assertionDocumentation,
    event,
  ),
  oscalDocuments: {
    poam: reducers['oscalDocuments.poam'](state.oscalDocuments.poam, event),
    sap: reducers['oscalDocuments.sap'](state.oscalDocuments.sap, event),
    sar: reducers['oscalDocuments.sar'](state.oscalDocuments.sar, event),
    ssp: reducers['oscalDocuments.ssp'](state.oscalDocuments.ssp, event),
  },
  router: reducers.router(state.router, event),
  validationResults: {
    poam: reducers['validationResults.poam'](
      state.validationResults.poam,
      event,
    ),
    sap: reducers['validationResults.sap'](state.validationResults.sap, event),
    sar: reducers['validationResults.sar'](state.validationResults.sar, event),
    ssp: reducers['validationResults.ssp'](state.validationResults.ssp, event),
  },
  validator: reducers.validator(state.validator, event),
});

export type SampleDocument = {
  url: string;
  displayName: string;
};
