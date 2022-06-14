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

type Event =
  | {
      type: 'RESET';
    }
  | {
      type: 'PROCESSING_URL';
      data: {
        xmlFileUrl: string;
      };
    }
  | {
      type: 'PROCESSING_STRING';
      data: {
        fileName: string;
      };
    }
  | {
      type: 'PROCESSING_ERROR';
      data: {
        errorMessage: string;
      };
    }
  | {
      type: 'VALIDATED';
    };

export const nextState = (state: State, event: Event): State => {
  if (state.current === 'PROCESSING_ERROR') {
    if (event.type === 'RESET') {
      return {
        current: 'UNLOADED',
      };
    }
  } else if (state.current === 'VALIDATED') {
    if (event.type === 'RESET') {
      return {
        current: 'UNLOADED',
      };
    }
  } else if (state.current === 'UNLOADED') {
    if (event.type === 'RESET') {
      return {
        current: 'UNLOADED',
      };
    }
    if (event.type === 'PROCESSING_URL') {
      return {
        current: 'PROCESSING',
        message: `Processing ${event.data.xmlFileUrl}...`,
      };
    }
    if (event.type === 'PROCESSING_STRING') {
      return {
        current: 'PROCESSING',
        message: `Processing local file...`,
      };
    }
    if (event.type === 'PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
      };
    }
  } else if (state.current === 'PROCESSING') {
    if (event.type === 'PROCESSING_ERROR') {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage: event.data.errorMessage,
      };
    } else if (event.type === 'VALIDATED') {
      return {
        current: 'VALIDATED',
      };
    }
  }
  return state;
};

export const createValidatorMachine = (): State => ({ current: 'UNLOADED' });
