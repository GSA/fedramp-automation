import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { NewPresenterConfig } from '..';

export const initialize = ({ dispatch, effects }: NewPresenterConfig) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecScenarioSummaries => {
    dispatch({
      type: 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED',
      data: {
        xspecScenarioSummaries,
      },
    });
  });
};

export const close = ({ dispatch }: NewPresenterConfig) => {
  dispatch({ type: 'ASSERTION_DOCUMENTATION_CLOSE' });
};

export const show =
  ({
    assertionId,
    documentType,
  }: {
    assertionId: string;
    documentType: OscalDocumentKey;
  }) =>
  ({ dispatch }: NewPresenterConfig) => {
    dispatch({
      type: 'ASSERTION_DOCUMENTATION_SHOW',
      data: { assertionId, documentType },
    });
  };
