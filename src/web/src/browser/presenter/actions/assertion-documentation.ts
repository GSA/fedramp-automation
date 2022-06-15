import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';

export const initialize = ({ effects, state }: PresenterConfig) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecScenarioSummaries => {
    state.newAppContext.dispatch({
      type: 'SUMMARIES_LOADED',
      data: {
        xspecScenarioSummaries,
      },
    });
  });
};

export const close = ({ state }: PresenterConfig) => {
  state.newAppContext.dispatch({ type: 'CLOSE' });
};

export const show = (
  { state }: PresenterConfig,
  {
    assertionId,
    documentType,
  }: { assertionId: string; documentType: OscalDocumentKey },
) => {
  state.newAppContext.dispatch({
    type: 'SHOW',
    data: { assertionId, documentType },
  });
};
