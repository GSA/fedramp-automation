import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ActionContext } from '..';

export const initialize = ({ dispatch, effects }: ActionContext) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecScenarioSummaries => {
    dispatch({
      machine: 'assertionDocumentation',
      type: 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED',
      data: {
        xspecScenarioSummaries,
      },
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
