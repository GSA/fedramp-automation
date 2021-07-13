import { derived, Statemachine, statemachine } from 'overmind';

import {
  EMPTY_SCHEMATRON,
  Schematron,
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
    [assertionId: string]: {
      id: string | null;
      test: string;
      message: (
        | string
        | {
            $type: string;
            select: string;
          }
      )[];
      isReport: boolean;
    };
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
        assertions: {
          //id: string;
          //test: string;
          //isReport: boolean;
          message: string;
          icon: typeof checkCircleIcon;
          fired: ValidationAssert[];
        }[];
      };
    }[];
  };
  sourceSchematron: Schematron;
  validator: ValidatorMachine;
};

type Events = {
  type: 'DATA_LOADED';
  sourceSchematron: Schematron;
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
    DATA_LOADED: sourceSchematron => {
      return {
        current: 'LOADED',
        sourceSchematron,
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
        state.sourceSchematron.patterns.forEach(pattern => {
          pattern.rules.forEach(rule => {
            rule.asserts.forEach(assert => {
              // TODO: after creating custom sch parser, remove `|| ''`
              assertions[assert.id || ''] = assert;
            });
          });
        });
        return assertions;
      }),
      assertionGroups: derived((state: SchematronMachine) => {
        // Return a sample assertion group corresponding to the source rules.
        const groups: SchematronMachine['assertionGroups'] = [];
        let index = 0;
        state.sourceSchematron.patterns.forEach(pattern => {
          pattern.rules.forEach(rule => {
            groups.push({
              title: `Group #${++index}`,
              asserts: rule.asserts.map(assert => ({
                id: assert.id || '', // TODO: remove `|| ''`
              })),
            });
          });
        });
        return groups;
      }),
      schematronReport: derived((state: SchematronMachine) => {
        const isValidated = state.validator.current === 'VALIDATED';
        return {
          summaryText: isValidated
            ? `Found ${state.validator.visibleAssertions.length} problems`
            : '',
          groups: state.assertionGroups.map(assertionGroup => {
            const assertions = assertionGroup.asserts.map(groupAssert => {
              const assert = state.allAssertionsById[groupAssert.id];
              const fired =
                state.validator.assertionsById[assert.id || ''] || [];
              return {
                //id: assert.id || '',
                //test: assert.test,
                //isReport: assert.isReport,
                message: assert.message.toString(),
                icon: !isValidated
                  ? helpIcon
                  : fired.length
                  ? cancelIcon
                  : checkCircleIcon,
                fired,
              };
            });
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
                summaryColor: passCount === assertions.length ? 'green' : 'red',
                assertions,
              },
            };
          }),
        };
      }),
      sourceSchematron: EMPTY_SCHEMATRON,
      validator: createValidatorMachine(),
    },
  );
};
