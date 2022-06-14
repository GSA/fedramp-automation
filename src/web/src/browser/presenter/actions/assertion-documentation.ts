import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';
import * as assertionDocumentation from '../state/assertion-documetation';

export const initialize = ({ effects, state }: PresenterConfig) => {
  effects.useCases.getXSpecScenarioSummaries().then(xspecScenarioSummaries => {
    state.assertionDocumentation = assertionDocumentation.nextState(
      state.assertionDocumentation,
      {
        type: 'SUMMARIES_LOADED',
        data: {
          xspecScenarioSummaries,
        },
      },
    );
  });
};

export const close = ({ state }: PresenterConfig) => {
  state.assertionDocumentation = assertionDocumentation.nextState(
    state.assertionDocumentation,
    {
      type: 'CLOSE',
    },
  );
};

export const show = (
  { state }: PresenterConfig,
  {
    assertionId,
    documentType,
  }: { assertionId: string; documentType: OscalDocumentKey },
) => {
  state.assertionDocumentation = assertionDocumentation.nextState(
    state.assertionDocumentation,
    {
      type: 'SHOW',
      data: { assertionId, documentType },
    },
  );
};
