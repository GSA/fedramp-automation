export type State =
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
    };

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
    };

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'PROCESSING_ERROR') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
      };
    }
  } else if (state.current === 'VALIDATED') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
      };
    }
  } else if (state.current === 'UNLOADED') {
    if (event.type === 'VALIDATOR_RESET') {
      return {
        current: 'UNLOADED',
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_URL') {
      return {
        current: 'PROCESSING',
        message: `Processing ${event.data.xmlFileUrl}...`,
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_STRING') {
      return {
        current: 'PROCESSING',
        message: `Processing local file...`,
      };
    }
    if (event.type === 'VALIDATOR_PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
      };
    }
  } else if (state.current === 'PROCESSING') {
    if (event.type === 'VALIDATOR_PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
      };
    } else if (event.type === 'VALIDATOR_VALIDATED') {
      return {
        current: 'VALIDATED',
      };
    }
  }
  return state;
};

export const initialState: State = { current: 'UNLOADED' };
