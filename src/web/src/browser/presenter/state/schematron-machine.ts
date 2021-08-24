import { derived, Statemachine, statemachine } from 'overmind';

import type {
  Role,
  SchematronFilter,
  SchematronFilterOptions,
  SchematronReport,
  SchematronUIConfig,
} from '../lib/schematron';
import { getSchematronReport, filterAssertions } from '../lib/schematron';
import { createValidatorMachine, ValidatorMachine } from './validator-machine';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
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
          role: state.filter.role,
          text,
          assertionViewId: state.filter.assertionViewId,
        },
      };
    },
    FILTER_ROLE_CHANGED: ({ role }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          role: role,
          text: state.filter.text,
          assertionViewId: state.filter.assertionViewId,
        },
      };
    },
    FILTER_ASSERTION_VIEW_CHANGED: ({ assertionViewId }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          assertionViewId: assertionViewId,
        },
      };
    },
  },
});

export const createSchematronMachine = () => {
  return schematronMachine.create(
    { current: 'UNINITIALIZED' },
    {
      config: {
        assertionViews: [],
        schematronAsserts: [],
      },
      filter: {
        role: 'all',
        text: '',
        assertionViewId: 0,
      },
      filterOptions: derived(getFilterOptions),
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
            isValidated: state.validator.current === 'VALIDATED',
          },
        }),
      ),
      validator: createValidatorMachine(),
    },
  );
};

const getFilterOptions = (state: SchematronMachine) => {
  const availableRoles = Array.from(
    new Set(state.config.schematronAsserts.map(assert => assert.role)),
  );
  const assertionViews = state.config.assertionViews.map((view, index) => {
    return {
      index,
      title: view.title,
    };
  });
  const assertionView = assertionViews
    .filter(view => view.index === state.filter.assertionViewId)
    .map(() => {
      return state.config.assertionViews[state.filter.assertionViewId];
    })[0] || {
    title: '',
    groups: [],
  };
  const assertionViewIds = assertionView.groups
    .map(group => group.assertionIds)
    .flat();
  return {
    assertionViews: assertionViews.map(view => ({
      ...view,
      count: filterAssertions(
        state.config.schematronAsserts,
        {
          role: state.filter.role,
          text: state.filter.text,
          assertionViewIds: state.config.assertionViews[
            view.index
          ].groups.flatMap(group => group.assertionIds),
        },
        availableRoles,
      ).length,
    })),
    roles: [
      ...['all', ...availableRoles.sort()].map((role: Role) => {
        return {
          name: role,
          subtitle:
            {
              all: 'View all rules',
              error: 'View required, critical rules',
              fatal: 'View rules required for rule validation',
              information: 'View optional rules',
              warning: 'View suggested rules',
            }[role] || '',
          count: filterAssertions(
            state.config.schematronAsserts,
            {
              role,
              text: state.filter.text,
              assertionViewIds,
            },
            availableRoles,
          ).length,
        };
      }),
    ],
  };
};
