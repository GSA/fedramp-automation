import { derived, Statemachine, statemachine } from 'overmind';

import type {
  ValidationAssert,
  ValidationReport,
} from '../../../../use-cases/schematron';

export type Role = string;

type States =
  | {
      current: 'UNLOADED';
    }
  | {
      current: 'PROCESSING_URL';
      xmlFileUrl: string;
    }
  | {
      current: 'PROCESSING_STRING';
      xmlFileContents: string;
    }
  | {
      current: 'PROCESSING_ERROR';
      errorMessage: string;
    }
  | {
      current: 'VALIDATED';
      filter: {
        role: Role;
        text: string;
      };
      roles: Role[];
      validationReport: ValidationReport;
      filterRoles: Role[];
      visibleAssertions: ValidationAssert[];
    };

type BaseState = {};

type Events =
  | {
      type: 'PROCESSING_URL';
      data: {
        xmlFileUrl: string;
      };
    }
  | {
      type: 'PROCESSING_STRING';
      data: {
        xmlFileContents: string;
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
      data: {
        validationReport: ValidationReport;
      };
    };

export type ReportMachine = Statemachine<States, Events, BaseState>;

export const reportMachine = statemachine<States, Events, BaseState>({
  PROCESSING_URL: (state, { xmlFileUrl }) => {
    return {
      current: 'PROCESSING_URL',
      xmlFileUrl,
    };
  },
  PROCESSING_STRING: (state, { xmlFileContents }) => {
    if (state.current === 'PROCESSING_URL' || state.current === 'UNLOADED') {
      return {
        current: 'PROCESSING_STRING',
        xmlFileContents,
      };
    }
  },
  PROCESSING_ERROR: (state, { errorMessage }) => {
    if (
      state.current === 'PROCESSING_STRING' ||
      state.current === 'PROCESSING_URL'
    ) {
      return {
        current: 'PROCESSING_ERROR',
        errorMessage,
      };
    }
  },
  VALIDATED: (state, { validationReport }) => {
    if (
      state.current !== 'PROCESSING_STRING' &&
      state.current !== 'UNLOADED' &&
      state.current !== 'PROCESSING_URL'
    ) {
      return;
    }
    return {
      current: 'VALIDATED',
      validationReport,
      filter: {
        role: 'all',
        text: '',
      },
      roles: [
        'all',
        ...Array.from(
          new Set(
            validationReport.failedAsserts.map(assert => assert.role || ''),
          ),
        ).sort(),
      ],
      filterRoles: derived((state: ReportMachine) => {
        const validatedState = state.matches('VALIDATED');
        if (!validatedState) {
          return [];
        }
        switch (validatedState.filter.role) {
          case 'all':
            return validatedState.roles;
          default:
            return [validatedState.filter.role];
        }
      }),
      visibleAssertions: derived((state: ReportMachine) => {
        const validatedState = state.matches('VALIDATED');
        if (!validatedState) {
          return [];
        }
        let assertions = validatedState.validationReport.failedAsserts.filter(
          (assertion: ValidationAssert) => {
            return validatedState.filterRoles.includes(assertion.role || '');
          },
        );
        if (validatedState.filter.text.length > 0) {
          assertions = assertions.filter(assertion => {
            const allText = Object.values(assertion).join('\n').toLowerCase();
            return allText.includes(validatedState.filter.text.toLowerCase());
          });
        }
        return assertions;
      }),
    };
  },
});

export const createReportMachine = () => {
  return reportMachine.create({ current: 'UNLOADED' }, {});
};
