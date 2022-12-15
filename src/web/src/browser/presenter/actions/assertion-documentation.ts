import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { SchematronRulesetKeys } from '@asap/shared/domain/schematron';
import type { ActionContext } from '..';

export const initialize = ({ dispatch, effects }: ActionContext) => {
  SchematronRulesetKeys.map(rulesetKey => {
    effects.useCases
      .getXSpecScenarioSummaries(rulesetKey)
      .then(xspecScenarioSummaries => {
        dispatch({
          machine: 'assertionDocumentation',
          type: 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED',
          data: {
            xspecScenarioSummaries,
          },
        });
      });
  });
};

export const close = ({ dispatch }: ActionContext) => {
  dispatch({
    machine: 'assertionDocumentation',
    type: 'ASSERTION_DOCUMENTATION_CLOSE',
  });
};

export const show =
  ({
    assertionId,
    documentType,
  }: {
    assertionId: string;
    documentType: OscalDocumentKey;
  }) =>
  ({ dispatch }: ActionContext) => {
    dispatch({
      machine: 'assertionDocumentation',
      type: 'ASSERTION_DOCUMENTATION_SHOW',
      data: { assertionId, documentType },
    });
  };
