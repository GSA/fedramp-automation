import { derived, Statemachine, statemachine } from 'overmind';

import type { AssertionView } from '@asap/shared/use-cases/assertion-views';
import type {
  SchematronAssert,
  FailedAssert,
} from '@asap/shared/use-cases/schematron';

import { createValidatorMachine, ValidatorMachine } from './validator-machine';
import { groupSort } from 'fp-ts/lib/ReadonlyNonEmptyArray';

export type Role = string;

// Schematron rules meta-data
type SchematronUIConfig = {
  assertionViews: AssertionView[];
  schematronAsserts: SchematronAssert[];
};

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  config: SchematronUIConfig;
  filter: {
    role: Role;
    text: string;
    assertionViewId: number;
  };
  filterOptions: {
    assertionViews: {
      index: number;
      title: string;
      count: number;
    }[];
    roles: {
      name: Role;
      subtitle: string;
      count: number;
    }[];
  };
  schematronReport: {
    summary: {
      title: string;
      subtitle: string;
      counts: {
        assertions: number;
      };
    };
    groups: {
      title: string;
      checks: {
        summary: string;
        summaryColor: 'red' | 'green';
        checks: (SchematronAssert & {
          icon: typeof checkCircleIcon;
          fired: FailedAssert[];
        })[];
      };
    }[];
  };
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

const checkCircleIcon = { sprite: 'check_circle', color: 'green' };
const navigateNextIcon = { sprite: 'navigate_next', color: 'blue' };
const cancelIcon = {
  sprite: 'cancel',
  color: 'red',
};

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
      filterOptions: derived((state: SchematronMachine) => {
        const availableRoles = Array.from(
          new Set(state.config.schematronAsserts.map(assert => assert.role)),
        );
        const assertionViews = state.config.assertionViews.map(
          (view, index) => {
            return {
              index,
              title: view.title,
            };
          },
        );
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
      }),
      schematronReport: derived(
        ({ config, filter, filterOptions, validator }: SchematronMachine) => {
          const assertionView = filterOptions.assertionViews
            .filter(view => view.index === filter.assertionViewId)
            .map(() => {
              return config.assertionViews[filter.assertionViewId];
            })[0] || {
            title: '',
            groups: [],
          };

          const schematronChecksFiltered = filterAssertions(
            config.schematronAsserts,
            {
              role: filter.role,
              text: filter.text,
              assertionViewIds: assertionView.groups
                .map(group => group.assertionIds)
                .flat(),
            },
            filterOptions.roles.map(role => role.name),
          );
          const assertionsById = getAssertionsById(schematronChecksFiltered);

          const isValidated = validator.current === 'VALIDATED';

          return {
            summary: {
              title:
                validator.current === 'VALIDATED'
                  ? validator.validationReport.title
                  : 'FedRAMP Package Concerns',
              subtitle: assertionView.title,
              counts: {
                assertions: schematronChecksFiltered.length,
              },
            },
            groups: assertionView.groups
              .map(assertionGroup => {
                type UiAssert = SchematronAssert & {
                  message: string;
                  icon: typeof checkCircleIcon;
                  fired: FailedAssert[];
                };
                const checks = assertionGroup.assertionIds
                  .map(assertionGroupAssert => {
                    const assert = assertionsById[assertionGroupAssert];
                    if (!assert) {
                      return null;
                    }
                    const fired = validator.assertionsById[assert.id] || [];
                    return {
                      ...assert,
                      // message: `${assert.id} ${assert.message}`,
                      icon: !isValidated
                        ? navigateNextIcon
                        : fired.length
                        ? cancelIcon
                        : checkCircleIcon,
                      fired,
                    };
                  })
                  .filter(
                    (assert: UiAssert | null): assert is UiAssert =>
                      assert !== null,
                  );
                const firedCount = checks.filter(
                  assert => assert.fired.length > 0,
                ).length;
                return {
                  title: assertionGroup.title,
                  checks: {
                    summary: (() => {
                      if (isValidated) {
                        return `${firedCount} / ${checks.length} triggered`;
                      } else {
                        return `${checks.length} checks`;
                      }
                    })(),
                    summaryColor: (firedCount === 0 ? 'green' : 'red') as
                      | 'red'
                      | 'green',
                    checks,
                  },
                };
              })
              .filter(group => group.checks.checks.length > 0),
          };
        },
      ),
      validator: createValidatorMachine(),
    },
  );
};

const filterAssertions = (
  schematronAsserts: SchematronUIConfig['schematronAsserts'],
  filter: {
    role: Role;
    text: string;
    assertionViewIds: string[];
  },
  roleOptions: Role[],
) => {
  const filterRoles =
    filter.role === 'all' ? roleOptions.map(role => role) : filter.role;
  let assertions = schematronAsserts.filter((assertion: SchematronAssert) => {
    return filterRoles.includes(assertion.role || '');
  });
  if (filter.text.length > 0) {
    assertions = assertions.filter(assert => {
      const searchText = assert.message.toLowerCase();
      return searchText.includes(filter.text.toLowerCase());
    });
  }
  assertions = assertions.filter(assert =>
    filter.assertionViewIds.includes(assert.id),
  );
  return assertions;
};

const getAssertionsById = (asserts: SchematronAssert[]) => {
  const assertions: {
    [assertionId: string]: SchematronAssert;
  } = {};
  asserts.forEach(assert => {
    assertions[assert.id] = assert;
  });
  return assertions;
};
