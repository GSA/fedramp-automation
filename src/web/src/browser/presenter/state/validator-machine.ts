import {
  SchematronRulesetKey,
  SchematronRulesetKeys,
  SCHEMATRON_RULESETS,
} from '@asap/shared/domain/schematron';

type BaseState = {
  ruleset: {
    selected: SchematronRulesetKey;
    choices: typeof SCHEMATRON_RULESETS;
  };
};

export type State = BaseState &
  (
    | {
        current: 'UNLOADED';
      }
    | {
        current: 'PROCESSING';
        message: string;
      }
    | {
        current: 'PROCESSING_ERROR';
        errorMessage: string;
      }
    | {
        current: 'VALIDATED';
      }
  );

export type StateTransition =
  | {
      type: 'VALIDATOR_RESET';
    }
  | {
      type: 'VALIDATOR_PROCESSING_URL';
      data: {
        xmlFileUrl: string;
      };
    }
  | {
      type: 'VALIDATOR_PROCESSING_STRING';
      data: {
        fileName: string;
      };
    }
  | {
      type: 'VALIDATOR_PROCESSING_ERROR';
      data: {
        errorMessage: string;
      };
    }
  | {
      type: 'VALIDATOR_VALIDATED';
    }
  | {
      type: 'VALIDATOR_SET_RULESET';
      data: {
        rulesetKey: SchematronRulesetKey;
      };
    };

export const nextState = (state: State, event: StateTransition): State => {
  // Handle VALIDATOR_SET_RULESET event
  if (
    state.current !== 'PROCESSING' &&
    event.type === 'VALIDATOR_SET_RULESET'
  ) {
    return {
      ...state,
      ruleset: {
        ...state.ruleset,
        selected: event.data.rulesetKey,
      },
    };
  }
  // Handle all other events
  if (state.current === 'PROCESSING_ERROR') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
        ruleset: state.ruleset,
      };
    }
  } else if (state.current === 'VALIDATED') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
        ruleset: state.ruleset,
      };
    }
  } else if (state.current === 'UNLOADED') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
        ruleset: state.ruleset,
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_URL') {
      return {
        current: 'PROCESSING',
        message: `Processing ${event.data.xmlFileUrl}...`,
        ruleset: state.ruleset,
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_STRING') {
      return {
        current: 'PROCESSING',
        message: `Processing local file...`,
        ruleset: state.ruleset,
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
        ruleset: state.ruleset,
      };
    }
  } else if (state.current === 'PROCESSING') {
    if (event.type === 'VALIDATOR_PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
        ruleset: state.ruleset,
      };
    } else if (event.type === 'VALIDATOR_VALIDATED') {
      return {
        current: 'VALIDATED',
        ruleset: state.ruleset,
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'UNLOADED',
  ruleset: {
    selected: SchematronRulesetKeys[0],
    choices: SCHEMATRON_RULESETS,
  },
};
