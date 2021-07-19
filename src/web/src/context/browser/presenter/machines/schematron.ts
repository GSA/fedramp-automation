import { derived, Statemachine, statemachine } from 'overmind';

import type {
  SchematronAssert,
  FailedAssert,
} from '../../../../use-cases/schematron';
import { createValidatorMachine, ValidatorMachine } from './validator';

export type Role = string;

type States =
  | {
      current: 'UNLOADED';
    }
  | {
      current: 'LOADED';
    };

type BaseState = {
  assertionsById: {
    [assertionId: string]: SchematronAssert;
  };
  assertionGroups: {
    title: string;
    asserts: {
      id: string;
    }[];
  }[];
  filter: {
    role: Role;
    text: string;
  };
  filterRoles: Role[];
  roles: Role[];
  schematronReport: {
    summaryText: string;
    groups: {
      title: string;
      //see: string;
      assertions: {
        summary: string;
        summaryColor: 'red' | 'green';
        assertions: (SchematronAssert & {
          icon: typeof checkCircleIcon;
          fired: FailedAssert[];
        })[];
      };
    }[];
  };
  schematronAsserts: SchematronAssert[];
  schematronAssertsFiltered: SchematronAssert[];
  validator: ValidatorMachine;
};

type Events = {
  type: 'DATA_LOADED';
  schematronAsserts: SchematronAssert[];
};

export type SchematronMachine = Statemachine<States, Events, BaseState>;

const checkCircleIcon = { sprite: 'check_circle', color: 'green' };
const helpIcon = { sprite: 'help', color: 'blue' };
const cancelIcon = {
  sprite: 'cancel',
  color: 'red',
};

const schematronMachine = statemachine<States, Events, BaseState>({
  UNLOADED: {
    DATA_LOADED: schematronAsserts => {
      return {
        current: 'LOADED',
        schematronAsserts,
      };
    },
  },
  LOADED: {},
});

export const createSchematronMachine = () => {
  return schematronMachine.create(
    { current: 'LOADED' },
    {
      assertionsById: derived((state: SchematronMachine) => {
        const assertions: SchematronMachine['assertionsById'] = {};
        state.schematronAssertsFiltered.forEach(assert => {
          assertions[assert.id] = assert;
        });
        return assertions;
      }),
      assertionGroups: derived((state: SchematronMachine) => {
        // Return a sample assertion group corresponding to the source rules.
        return [
          {
            title: 'ssp.sch assertions',
            asserts: state.schematronAsserts,
          },
        ];
      }),
      filter: {
        role: 'all',
        text: '',
      },
      filterRoles: derived((state: SchematronMachine) => {
        switch (state.filter.role) {
          case 'all':
            return state.roles;
          default:
            return [state.filter.role];
        }
      }),
      roles: derived((state: SchematronMachine) => [
        'all',
        ...Array.from(
          new Set(state.schematronAsserts.map(assert => assert.role)),
        ).sort(),
      ]),
      schematronReport: derived(
        ({ assertionsById, assertionGroups, validator }: SchematronMachine) => {
          const isValidated = validator.current === 'VALIDATED';
          return {
            summaryText: isValidated
              ? 'Processed validations'
              : 'Unprocessed validations',
            groups: assertionGroups.map(assertionGroup => {
              type UiAssert = SchematronAssert & {
                message: string;
                icon: typeof checkCircleIcon;
                fired: FailedAssert[];
              };
              const assertions = assertionGroup.asserts
                .map(assertionGroupAssert => {
                  const assert = assertionsById[assertionGroupAssert.id];
                  if (!assert) {
                    return null;
                  }
                  const fired = validator.assertionsById[assert.id] || [];
                  return {
                    ...assert,
                    // message: `${assert.id} ${assert.message}`,
                    icon: !isValidated
                      ? helpIcon
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
              const firedCount = assertions.filter(
                assert => assert.fired.length > 0,
              ).length;
              return {
                title: assertionGroup.title,
                assertions: {
                  summary: (() => {
                    if (isValidated) {
                      return `${firedCount} / ${assertions.length} triggered`;
                    } else {
                      return `${assertions.length} assertions`;
                    }
                  })(),
                  summaryColor: firedCount === 0 ? 'green' : 'red',
                  assertions,
                },
              };
            }),
          };
        },
      ),
      schematronAsserts: [] as SchematronAssert[],
      schematronAssertsFiltered: derived(
        ({ filter, filterRoles, schematronAsserts }: SchematronMachine) => {
          let assertions = schematronAsserts.filter(
            (assertion: SchematronAssert) => {
              return filterRoles.includes(assertion.role || '');
            },
          );
          if (filter.text.length > 0) {
            assertions = assertions.filter(assert => {
              const searchText = assert.message.toLowerCase();
              return searchText.includes(filter.text.toLowerCase());
            });
          }
          return assertions;
        },
      ),
      validator: createValidatorMachine(),
    },
  );
};
