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
          message: string;
          //isReport: boolean;
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
      schematronReport: derived((state: SchematronMachine) => {
        const assertionGroups: {
          title: string;
          //see: string;
          assertions: {
            summary: string;
            summaryColor: 'red' | 'green';
            assertions: {
              //id: string;
              //test: string;
              message: string;
              //isReport: boolean;
              icon: typeof checkCircleIcon;
              fired: ValidationAssert[];
            }[];
          };
        }[] = [];
        const isValidated = state.validator.current === 'VALIDATED';
        state.sourceSchematron.patterns.forEach(pattern =>
          pattern.rules.forEach(rule => {
            const assertions = rule.asserts.map(assert => {
              const fired =
                state.validator.assertionsById[assert.id || ''] || [];
              return {
                id: assert.id || '',
                test: assert.test,
                message: assert.message.toString(),
                isReport: assert.isReport,
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
            assertionGroups.push({
              title: `Rule #${assertionGroups.length + 1}`,
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
            });
          }),
        );

        return {
          summaryText: isValidated
            ? `Found ${state.validator.visibleAssertions.length} problems`
            : '',
          groups: assertionGroups,
        };
      }),
      sourceSchematron: EMPTY_SCHEMATRON,
      validator: createValidatorMachine(),
    },
  );
};
