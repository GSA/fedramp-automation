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
    // TODO: handle documentType
    dispatch({
      type: 'SET_ASSERTION_CONTEXT',
      data: {
        assertionId,
      },
    });
  };

export const clearAssertionContext =
  (documentType: OscalDocumentKey) =>
  ({ dispatch }: ActionContext) => {
    // TODO: handle documentType
    dispatch({
      type: 'CLEAR_ASSERTION_CONTEXT',
    });
  };
