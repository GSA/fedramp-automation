import { useCallback } from 'react';
import Modal from 'react-modal';

import { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { useActions, useAppState } from '../hooks';
import { CodeViewer } from './CodeViewer';

type DocumentViewerOverlayProps = {
  documentType: OscalDocumentKey;
};

export const DocumentViewerOverlay = ({
  documentType,
}: DocumentViewerOverlayProps) => {
  const oscalDocument = useAppState().oscalDocuments[documentType];
  const actions = useActions();

  // Hightlight and scroll to node when mounted to DOM.
  const refCallback = useCallback(node => {
    const assertionId =
      oscalDocument.validationResults.current === 'ASSERTION_CONTEXT'
        ? oscalDocument.validationResults.assertionId
        : null;
    if (assertionId) {
      const target = node.querySelector(`#${assertionId}`) as HTMLElement;
      if (target) {
        target.scrollIntoView({
          behavior: 'auto',
          block: 'start',
          inline: 'start',
        });
        target.style.backgroundColor = 'lightgray';
      }
    }
  }, []);

  return (
    <Modal
      className="position-absolute top-2 bottom-2 right-2 left-2 margin-2 bg-white overflow-scroll"
      isOpen={oscalDocument.validationResults.current === 'ASSERTION_CONTEXT'}
      onRequestClose={() =>
        actions.documentViewer.clearAssertionContext(documentType)
      }
      contentLabel="Assertion rule examples"
      style={{
        overlay: { zIndex: 1000 },
      }}
    >
      <div className="grid-row grid-gap">
        <div ref={refCallback} className="mobile:grid-col-12">
          {oscalDocument.validationResults.current === 'ASSERTION_CONTEXT' ? (
            <CodeViewer
              codeHTML={oscalDocument.validationResults.annotatedXML}
            />
          ) : (
            <p>No report validated.</p>
          )}
        </div>
      </div>
    </Modal>
  );
};
