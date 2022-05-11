import type { PresenterConfig } from '..';

export const initialize = ({ effects, state }: PresenterConfig) => {
  effects.useCases
    .getXSpecScenarioSummaries()
    .then(xspecSummariesByAssertionId => {
      state.schematron.assertionDocumentation.send('SUMMARIES_LOADED', {
        xspecSummariesByAssertionId,
      });
    });
};

export const close = ({ state }: PresenterConfig) => {
  state.schematron.assertionDocumentation.send('CLOSE', {});
};

export const show = ({ state }: PresenterConfig, assertionId: string) => {
  state.schematron.assertionDocumentation.send('SHOW', {
    assertionId,
  });
};
