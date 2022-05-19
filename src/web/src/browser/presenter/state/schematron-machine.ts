import { derived, Statemachine, statemachine } from 'overmind';

import {
  getFilterOptions,
  PassStatus,
  Role,
  SchematronFilter,
  SchematronFilterOptions,
  SchematronReport,
  SchematronUIConfig,
} from '../lib/schematron';
import { getSchematronReport } from '../lib/schematron';
import {
  AssertionDocumentationMachine,
  createAssertionDocumentationMachine,
} from './assertion-documetation';
import { createValidatorMachine, ValidatorMachine } from './validator-machine';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  assertionDocumentation: AssertionDocumentationMachine;
  config: SchematronUIConfig;
  filter: SchematronFilter;
  filterOptions: SchematronFilterOptions;
  schematronReport: SchematronReport;
  validator: ValidatorMachine;
};

type Events =
  | {
      type: 'CONFIG_LOADED';
      data: {
        config: SchematronUIConfig;
      };
    }
  | {
      type: 'FILTER_TEXT_CHANGED';
      data: {
        text: string;
      };
    }
  | {
      type: 'FILTER_ROLE_CHANGED';
      data: {
        role: Role;
      };
    }
  | {
      type: 'FILTER_ASSERTION_VIEW_CHANGED';
      data: {
        assertionViewId: number;
      };
    }
  | {
      type: 'FILTER_PASS_STATUS_CHANGED';
      data: {
        passStatus: PassStatus;
      };
    };

export type SchematronMachine = Statemachine<States, Events, BaseState>;

const schematronMachine = statemachine<States, Events, BaseState>({
  UNINITIALIZED: {
    CONFIG_LOADED: ({ config }) => {
      return {
        current: 'INITIALIZED',
        config,
      };
    },
  },
  INITIALIZED: {
    FILTER_TEXT_CHANGED: ({ text }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          text,
        },
      };
    },
    FILTER_ROLE_CHANGED: ({ role }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          role,
        },
      };
    },
    FILTER_ASSERTION_VIEW_CHANGED: ({ assertionViewId }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          assertionViewId,
        },
      };
    },
    FILTER_PASS_STATUS_CHANGED: ({ passStatus }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          passStatus,
        },
      };
    },
  },
});

export const createSchematronMachine = () => {
  return schematronMachine.create(
    { current: 'UNINITIALIZED' },
    {
      assertionDocumentation: createAssertionDocumentationMachine(),
      config: {
        assertionViews: {
          poam: [],
          sap: [],
          sar: [],
          ssp: [],
        },
        schematronAsserts: {
          poam: [],
          sap: [],
          sar: [],
          ssp: [],
        },
      },
      filter: {
        passStatus: 'all',
        role: 'all',
        text: '',
        assertionViewId: 0,
      },
      filterOptions: derived((state: SchematronMachine) =>
        getFilterOptions({
          config: state.config,
          filter: state.filter,
          failedAssertionMap: state.validator.matches('VALIDATED')
            ? state.validator.assertionsById
            : null,
        }),
      ),
      schematronReport: derived((state: SchematronMachine) =>
        getSchematronReport({
          config: state.config,
          filter: state.filter,
          filterOptions: state.filterOptions,
          validator: {
            failedAssertionMap: state.validator.assertionsById,
            title:
              state.validator.current === 'VALIDATED'
                ? state.validator.validationReport.title
                : 'FedRAMP Package Concerns',
          },
          xspecSummariesByAssertionId:
            state.assertionDocumentation.xspecSummariesByAssertionId,
        }),
      ),
      validator: createValidatorMachine(),
    },
  );
};
