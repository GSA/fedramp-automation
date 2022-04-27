import type { PresenterConfig } from '..';

export const initialize = ({ effects, state }: PresenterConfig) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecSummaries => {
    state.assertionDocumentation.send('SUMMARIES_LOADED', {
      xspecSummaries,
    });
  });
};
