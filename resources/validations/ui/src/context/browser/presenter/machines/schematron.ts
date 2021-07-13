import { derived, Statemachine, statemachine } from 'overmind';

import type {
  SchematronAssert,
  ValidationAssert,
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
  allAssertionsById: {
    [assertionId: string]: SchematronAssert;
  };
  assertionGroups: {
    title: string;
    asserts: {
      id: string;
    }[];
  }[];
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
          fired: ValidationAssert[];
        })[];
      };
    }[];
  };
  schematronAsserts: SchematronAssert[];
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
    { current: 'UNLOADED' },
    {
      allAssertionsById: derived((state: SchematronMachine) => {
        const assertions: SchematronMachine['allAssertionsById'] = {};
        state.schematronAsserts.forEach(assert => {
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
      schematronReport: derived(
        ({
          allAssertionsById,
          assertionGroups,
          validator,
        }: SchematronMachine) => {
          const isValidated = validator.current === 'VALIDATED';
          return {
            summaryText: isValidated
              ? `Found ${validator.visibleAssertions.length} problems`
              : '',
            groups: assertionGroups.map(assertionGroup => {
              const assertions = assertionGroup.asserts.map(
                assertionGroupAssert => {
                  const assert = allAssertionsById[assertionGroupAssert.id];
                  const fired = validator.assertionsById[assert.id] || [];
                  return {
                    ...assert,
                    message: `${assert.id} ${assert.message}`,
                    icon: !isValidated
                      ? helpIcon
                      : fired.length
                      ? cancelIcon
                      : checkCircleIcon,
                    fired,
                  };
                },
              );
              const passCount = assertions.filter(
                assert => assert.fired.length === 0,
              ).length;
              return {
                title: assertionGroup.title,
                assertions: {
                  summary: (() => {
                    if (isValidated) {
                      return `${passCount} / ${assertions.length} passed`;
                    } else {
                      return `${assertions.length} assertions`;
                    }
                  })(),
                  summaryColor:
                    passCount === assertions.length ? 'green' : 'red',
                  assertions,
                },
              };
            }),
          };
        },
      ),
      schematronAsserts: [] as SchematronAssert[],
      validator: createValidatorMachine(),
    },
  );
};
