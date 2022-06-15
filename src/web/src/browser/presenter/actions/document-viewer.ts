import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';

export const showAssertionContext = (
  { state }: PresenterConfig,
  {
    assertionId,
    documentType,
  }: { assertionId: string; documentType: OscalDocumentKey },
) => {
  state.oscalDocuments[documentType].validationResults.send(
    'SET_ASSERTION_CONTEXT',
    {
      assertionId,
    },
  );
};

export const clearAssertionContext = (
  { state }: PresenterConfig,
  documentType: OscalDocumentKey,
) => {
  state.oscalDocuments[documentType].validationResults.send(
    'CLEAR_ASSERTION_CONTEXT',
  );
};
