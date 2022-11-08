import {
  SchematronRulesetKey,
  SCHEMATRON_RULESETS,
} from '@asap/shared/domain/schematron';
import * as assertionDocumentation from './assertion-documetation';
import * as metrics from './metrics';
import * as routerMachine from './router-machine';
import { RulesetState } from './ruleset';
import * as schematron from './ruleset/schematron-machine';
import * as validationResults from './ruleset/validation-results-machine';
import * as validator from './validator-machine';

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
  router: routerMachine.State;
  rulesets: {
    rev4: RulesetState;
    rev5: RulesetState;
  };
  validator: validator.State;
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
  rulesets: {
    rev4: {
      meta: SCHEMATRON_RULESETS['rev4'],
      oscalDocuments: {
        poam: schematron.initialState,
        sap: schematron.initialState,
        sar: schematron.initialState,
        ssp: schematron.initialState,
      },
      validationResults: {
        poam: validationResults.initialState,
        sap: validationResults.initialState,
        sar: validationResults.initialState,
        ssp: validationResults.initialState,
      },
    },
    rev5: {
      meta: SCHEMATRON_RULESETS['rev5'],
      oscalDocuments: {
        poam: schematron.initialState,
        sap: schematron.initialState,
        sar: schematron.initialState,
        ssp: schematron.initialState,
      },
      validationResults: {
        poam: validationResults.initialState,
        sap: validationResults.initialState,
        sar: validationResults.initialState,
        ssp: validationResults.initialState,
      },
    },
  },
  router: routerMachine.initialState,
  validator: validator.initialState,
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

const rulesetReducer = (
  state: State,
  event: StateTransition,
  rulesetKey: SchematronRulesetKey,
) => ({
  meta: state.rulesets[rulesetKey].meta,
  oscalDocuments: {
    poam: reducers[`oscalDocuments.poam`](
      state.rulesets[rulesetKey].oscalDocuments.poam,
      event,
    ),
    sap: reducers[`oscalDocuments.sap`](
      state.rulesets[rulesetKey].oscalDocuments.sap,
      event,
    ),
    sar: reducers[`oscalDocuments.sar`](
      state.rulesets[rulesetKey].oscalDocuments.sar,
      event,
    ),
    ssp: reducers[`oscalDocuments.ssp`](
      state.rulesets[rulesetKey].oscalDocuments.ssp,
      event,
    ),
  },
  validationResults: {
    poam: reducers[`validationResults.poam`](
      state.rulesets[rulesetKey].validationResults.poam,
      event,
    ),
    sap: reducers[`validationResults.sap`](
      state.rulesets[rulesetKey].validationResults.sap,
      event,
    ),
    sar: reducers[`validationResults.sar`](
      state.rulesets[rulesetKey].validationResults.sar,
      event,
    ),
    ssp: reducers[`validationResults.ssp`](
      state.rulesets[rulesetKey].validationResults.ssp,
      event,
    ),
  },
});

export const rootReducer = (state: State, event: StateTransition): State => ({
  config: state.config,
  assertionDocumentation: reducers.assertionDocumentation(
    state.assertionDocumentation,
    event,
  ),
  rulesets: {
    rev4: rulesetReducer(state, event, 'rev4'),
    rev5: rulesetReducer(state, event, 'rev5'),
  },
  router: reducers.router(state.router, event),
  validator: reducers.validator(state.validator, event),
});

export type SampleDocument = {
  url: string;
  displayName: string;
};
