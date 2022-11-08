import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import {
  SchematronRuleset,
  SchematronRulesetKey,
  SchematronRulesetKeys,
  SCHEMATRON_RULESETS,
} from '@asap/shared/domain/schematron';
import * as schematron from './schematron-machine';
import * as validationResults from './validation-results-machine';

export type RulesetState = {
  meta: SchematronRuleset;
  oscalDocuments: {
    poam: schematron.State;
    sap: schematron.State;
    sar: schematron.State;
    ssp: schematron.State;
  };
  validationResults: {
    poam: validationResults.State;
    sap: validationResults.State;
    sar: validationResults.State;
    ssp: validationResults.State;
  };
};

const getInitialRulesetState = (
  rulesetKey: SchematronRulesetKey,
): RulesetState => ({
  meta: SCHEMATRON_RULESETS[rulesetKey],
  oscalDocuments: {
    poam: schematron.initialState,
    sap: schematron.initialState,
    sar: schematron.initialState,
    ssp: schematron.initialState,
  },
  validationResults: {
    poam: validationResults.initialState,
    sap: validationResults.initialState,
    sar: validationResults.initialState,
    ssp: validationResults.initialState,
  },
});

export const getInitialRulesetsState = () =>
  Object.fromEntries(
    SchematronRulesetKeys.map(rulesetKey => [
      rulesetKey,
      getInitialRulesetState(rulesetKey),
    ]),
  ) as Record<SchematronRulesetKey, RulesetState>;
export type RulesetsState = ReturnType<typeof getInitialRulesetsState>;

export type ScopedTransition =
  | ({
      machine: `${SchematronRulesetKey}.oscalDocuments.${OscalDocumentKey}`;
    } & schematron.StateTransition)
  | ({
      machine: `${SchematronRulesetKey}.validationResults.${OscalDocumentKey}`;
    } & validationResults.StateTransition);

export const reduceMachine = <S, ST>(
  machine: ScopedTransition['machine'],
  nextState: (s: S, e: ST) => S,
  state: S,
  event: ScopedTransition,
) => {
  if (event.machine === machine) {
    return nextState(state, event as unknown as ST);
  }
  return state;
};

const rulesetNextState = (
  state: RulesetState,
  event: ScopedTransition,
  rulesetKey: SchematronRulesetKey,
) => ({
  meta: state.meta,
  oscalDocuments: {
    poam: reduceMachine(
      `${rulesetKey}.oscalDocuments.poam`,
      schematron.nextState,
      state.oscalDocuments.poam,
      event,
    ),
    sap: reduceMachine(
      `${rulesetKey}.oscalDocuments.sap`,
      schematron.nextState,
      state.oscalDocuments.sap,
      event,
    ),
    sar: reduceMachine(
      `${rulesetKey}.oscalDocuments.sar`,
      schematron.nextState,
      state.oscalDocuments.sar,
      event,
    ),
    ssp: reduceMachine(
      `${rulesetKey}.oscalDocuments.ssp`,
      schematron.nextState,
      state.oscalDocuments.ssp,
      event,
    ),
  },
  validationResults: {
    poam: reduceMachine(
      `${rulesetKey}.validationResults.poam`,
      validationResults.nextState,
      state.validationResults.poam,
      event,
    ),
    sap: reduceMachine(
      `${rulesetKey}.validationResults.sap`,
      validationResults.nextState,
      state.validationResults.sap,
      event,
    ),
    sar: reduceMachine(
      `${rulesetKey}.validationResults.sar`,
      validationResults.nextState,
      state.validationResults.sar,
      event,
    ),
    ssp: reduceMachine(
      `${rulesetKey}.validationResults.ssp`,
      validationResults.nextState,
      state.validationResults.ssp,
      event,
    ),
  },
});

export const rulesetsReducer = (
  state: RulesetsState,
  event: ScopedTransition,
) =>
  Object.fromEntries(
    SchematronRulesetKeys.map(rulesetKey => [
      rulesetKey,
      rulesetNextState(state[rulesetKey], event, rulesetKey),
    ]),
  ) as Record<SchematronRulesetKey, RulesetState>;
