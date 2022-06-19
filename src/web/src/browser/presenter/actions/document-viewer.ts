import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ActionContext } from '..';

export const showAssertionContext =
  ({
    assertionId,
    documentType,
  }: {
    assertionId: string;
    documentType: OscalDocumentKey;
  }) =>
  ({ dispatch }: ActionContext) => {
    dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'SET_ASSERTION_CONTEXT',
      data: {
        assertionId,
      },
    });
  };

export const clearAssertionContext =
  (documentType: OscalDocumentKey) =>
  ({ dispatch }: ActionContext) => {
    dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'CLEAR_ASSERTION_CONTEXT',
    });
  };
