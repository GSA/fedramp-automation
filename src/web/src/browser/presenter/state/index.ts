import * as assertionDocumentation from './assertion-documetation';
import * as routerMachine from './router-machine';
import {
  getInitialRulesetsState,
  rulesetsReducer,
  RulesetsState,
} from './ruleset';
import * as rulesets from './ruleset';
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
  rulesets: RulesetsState;
  validator: validator.State;
};

type ScopedTransition = {
  machine: 'assertionDocumentation' | 'router' | 'validator';
};

export type StateTransition =
  | (ScopedTransition &
      (
        | assertionDocumentation.StateTransition
        | routerMachine.StateTransition
        | validator.StateTransition
      ))
  | rulesets.ScopedTransition;

export const initialState: State = {
  config: {
    baseUrl: '/',
    sourceRepository: {
      sampleDocuments: [],
    },
  },
  assertionDocumentation: assertionDocumentation.initialState,
  rulesets: getInitialRulesetsState(),
  router: routerMachine.initialState,
  validator: validator.initialState,
};

export const reduceMachine = <S, ST>(
  machine: string,
  nextState: (s: S, e: ST) => S,
  state: S,
  event: StateTransition,
) => {
  if (event.machine === machine) {
    return nextState(state, event as unknown as ST);
  }
  return state;
};

export const rootReducer = (state: State, event: StateTransition): State => ({
  config: state.config,
  assertionDocumentation: reduceMachine(
    'assertionDocumentation',
    assertionDocumentation.nextState,
    state.assertionDocumentation,
    event,
  ),
  rulesets: rulesetsReducer(
    state.rulesets,
    event as unknown as rulesets.ScopedTransition,
  ),
  router: reduceMachine('router', routerMachine.nextState, state.router, event),
  validator: reduceMachine(
    'validator',
    validator.nextState,
    state.validator,
    event,
  ),
});

export type SampleDocument = {
  url: string;
  displayName: string;
};
