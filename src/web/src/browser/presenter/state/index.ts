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
  validationResults: {
    poam: validationResultsMachine.State;
    sap: validationResultsMachine.State;
    sar: validationResultsMachine.State;
    ssp: validationResultsMachine.State;
  };
};

type ScopedTransition = {
  machine: string;
};

export type StateTransition =
  | ScopedTransition &
      (
        | assertionDocumentation.StateTransition
        | metrics.StateTransition
        | routerMachine.StateTransition
        | schematronMachine.StateTransition
        | validatorMachine.StateTransition
        | validationResultsMachine.StateTransition
      );

/*type BaseReducer = (state: State, event: StateTransition) => State;
type Reducer<S, ST> = (state: S, event: ST) => S;

type ReducerParts = BaseReducer extends (
  state: infer MachineState,
  event: infer MachineStateTransition,
) => infer MachineState
  ? { State: MachineState; StateTransition: MachineStateTransition }
  : never;

type MachineKey = string;
const reduceMachine = <R extends ReducerParts>(
  machine: string,
  state: R['State'],
  reducer: Reducer<R['State'], R['StateTransition']>,
) => {
  return (state: R['State'], event: R['StateTransition']) => {
    if (event.machine === machine) {
      return reducer(state, event);
    }
    return state;
  };
};
*/

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
  validationResults: {
    poam: validationResultsMachine.initialState,
    sap: validationResultsMachine.initialState,
    sar: validationResultsMachine.initialState,
    ssp: validationResultsMachine.initialState,
  },
};

export const rootReducer = (state: State, event: StateTransition): State => ({
  config: state.config,
  assertionDocumentation: assertionDocumentation.nextState(
    state.assertionDocumentation,
    event as assertionDocumentation.StateTransition,
  ),
  metrics: metrics.nextState(state.metrics, event as metrics.StateTransition),
  oscalDocuments: {
    poam: ((state: schematronMachine.State, event: StateTransition) => {
      if (event.machine === 'oscalDocuments.poam') {
        return schematronMachine.nextState(
          state,
          event as unknown as schematronMachine.StateTransition,
        );
      }
      return state;
    })(state.oscalDocuments.poam, event),
    sap: ((state: schematronMachine.State, event: StateTransition) => {
      if (event.machine === 'oscalDocuments.sap') {
        return schematronMachine.nextState(
          state,
          event as unknown as schematronMachine.StateTransition,
        );
      }
      return state;
    })(state.oscalDocuments.sap, event),
    sar: ((state: schematronMachine.State, event: StateTransition) => {
      if (event.machine === 'oscalDocuments.poam') {
        return schematronMachine.nextState(
          state,
          event as unknown as schematronMachine.StateTransition,
        );
      }
      return state;
    })(state.oscalDocuments.sar, event),
    ssp: ((state: schematronMachine.State, event: StateTransition) => {
      if (event.machine === 'oscalDocuments.ssp') {
        return schematronMachine.nextState(
          state,
          event as unknown as schematronMachine.StateTransition,
        );
      }
      return state;
    })(state.oscalDocuments.ssp, event),
  },
  router: routerMachine.nextState(
    state.router,
    event as routerMachine.StateTransition,
  ),
  validator: validatorMachine.nextState(
    state.validator,
    event as validatorMachine.StateTransition,
  ),
  validationResults: {
    poam: ((state: validationResultsMachine.State, event: StateTransition) => {
      if (event.machine === 'validationResults.poam') {
        return validationResultsMachine.nextState(
          state,
          event as unknown as validationResultsMachine.StateTransition,
        );
      }
      return state;
    })(state.validationResults.poam, event),
    sap: ((state: validationResultsMachine.State, event: StateTransition) => {
      if (event.machine === 'validationResults.sap') {
        return validationResultsMachine.nextState(
          state,
          event as unknown as validationResultsMachine.StateTransition,
        );
      }
      return state;
    })(state.validationResults.sap, event),
    sar: ((state: validationResultsMachine.State, event: StateTransition) => {
      if (event.machine === 'validationResults.poam') {
        return validationResultsMachine.nextState(
          state,
          event as unknown as validationResultsMachine.StateTransition,
        );
      }
      return state;
    })(state.validationResults.sar, event),
    ssp: ((state: validationResultsMachine.State, event: StateTransition) => {
      if (event.machine === 'validationResults.ssp') {
        return validationResultsMachine.nextState(
          state,
          event as unknown as validationResultsMachine.StateTransition,
        );
      }
      return state;
    })(state.validationResults.ssp, event),
  },
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
