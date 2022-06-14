import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';
import * as validationResultsMachine from '../state/validation-results-machine';

export const showAssertionContext = (
  { state }: PresenterConfig,
  {
    assertionId,
    documentType,
  }: { assertionId: string; documentType: OscalDocumentKey },
) => {
  state.oscalDocuments[documentType].validationResults =
    validationResultsMachine.nextState(
      state.oscalDocuments[documentType].validationResults,
      {
        type: 'SET_ASSERTION_CONTEXT',
        data: {
          assertionId,
        },
      },
    );
};

export const clearAssertionContext = (
  { state }: PresenterConfig,
  documentType: OscalDocumentKey,
) => {
  state.oscalDocuments[documentType].validationResults =
    validationResultsMachine.nextState(
      state.oscalDocuments[documentType].validationResults,
      {
        type: 'CLEAR_ASSERTION_CONTEXT',
      },
    );
};
