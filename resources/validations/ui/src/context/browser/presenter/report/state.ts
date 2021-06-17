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
      current: 'LOADING';
      xmlFileUrl: string;
    }
  | {
      current: 'LOADING_ERROR';
      errorMessage: string;
    }
  | {
      current: 'VALIDATING';
      xmlFileContents: string;
    }
  | {
      current: 'VALIDATING_ERROR';
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
      type: 'LOADING';
      data: {
        xmlFileUrl: string;
      };
    }
  | {
      type: 'LOADING_ERROR';
      data: {
        errorMessage: string;
      };
    }
  | {
      type: 'VALIDATING';
      data: {
        xmlFileContents: string;
      };
    }
  | {
      type: 'VALIDATING_ERROR';
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
  LOADING: (state, { xmlFileUrl }) => {
    return {
      current: 'LOADING',
      xmlFileUrl,
    };
  },
  LOADING_ERROR: (state, { errorMessage }) => {
    if (state.current === 'LOADING') {
      return {
        current: 'LOADING_ERROR',
        errorMessage,
      };
    }
  },
  VALIDATING: (state, { xmlFileContents }) => {
    if (state.current === 'LOADING' || state.current === 'UNLOADED') {
      return {
        current: 'VALIDATING',
        xmlFileContents,
      };
    }
  },
  VALIDATING_ERROR: (state, { errorMessage }) => {
    if (state.current === 'VALIDATING') {
      return {
        current: 'VALIDATING_ERROR',
        errorMessage,
      };
    }
  },
  VALIDATED: (state, { validationReport }) => {
    if (state.current !== 'VALIDATING' && state.current !== 'UNLOADED') {
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
