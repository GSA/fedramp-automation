import type { PresenterConfig } from '..';

export const initialize = ({ effects, state }: PresenterConfig) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecScenarioSummaries => {
    state.assertionDocumentation.send('SUMMARIES_LOADED', {
      xspecScenarioSummaries,
    });
  });
};

export const close = ({ state }: PresenterConfig) => {
  state.assertionDocumentation.send('CLOSE', {});
};

export const show = (
  { state }: PresenterConfig,
  { assertionId, documentType }: { assertionId: string; documentType: string },
) => {
  state.assertionDocumentation.send('SHOW', {
    assertionId,
    documentType,
  });
};
