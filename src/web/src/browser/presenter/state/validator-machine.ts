import { Statemachine, statemachine } from 'overmind';

import type { ValidationReport } from '@asap/shared/use-cases/schematron';

type States =
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

type BaseState = {};

type Events =
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
      data: {};
    };

export type ValidatorMachine = Statemachine<States, Events, BaseState>;

export const validatorMachine = statemachine<States, Events, BaseState>({
  PROCESSING_ERROR: {
    RESET: () => {
      return {
        current: 'UNLOADED',
      };
    },
  },
  VALIDATED: {
    RESET: () => {
      return {
        current: 'UNLOADED',
      };
    },
  },
  UNLOADED: {
    PROCESSING_URL: ({ xmlFileUrl }) => {
      return {
        current: 'PROCESSING',
        message: `Processing ${xmlFileUrl}...`,
      };
    },
    PROCESSING_STRING: ({ fileName }) => {
      return {
        current: 'PROCESSING',
        message: `Processing local file...`,
      };
    },
    PROCESSING_ERROR: () => {},
  },
  PROCESSING: {
    PROCESSING_ERROR: ({ errorMessage }) => {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage,
      };
    },
    VALIDATED: () => {
      return {
        current: 'VALIDATED',
      };
    },
  },
});

export const createValidatorMachine = () => {
  return validatorMachine.create({ current: 'UNLOADED' }, {});
};
