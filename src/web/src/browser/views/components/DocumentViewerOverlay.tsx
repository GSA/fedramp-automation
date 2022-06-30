import { useCallback } from 'react';
import Modal from 'react-modal';

import { clearAssertionContext } from '@asap/browser/presenter/actions/validator';
import { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { CodeViewer } from './CodeViewer';
import { useAppContext, useSelector } from '../context';
import { selectValidationResult } from '@asap/browser/presenter/state/selectors';

type DocumentViewerOverlayProps = {
  documentType: OscalDocumentKey;
};

export const DocumentViewerOverlay = ({
  documentType,
}: DocumentViewerOverlayProps) => {
  const { dispatch } = useAppContext();
  const validationResult = useSelector(selectValidationResult(documentType));

  // Hightlight and scroll to node when mounted to DOM.
  const refCallback = useCallback(
    node => {
      if (!node) {
        return;
      }
      const assertionId =
        validationResult.current === 'ASSERTION_CONTEXT'
          ? validationResult.assertionId
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
    },
    [validationResult],
  );

  return (
    <Modal
      className="position-absolute top-2 bottom-2 right-2 left-2 margin-2 bg-white overflow-scroll"
      isOpen={validationResult.current === 'ASSERTION_CONTEXT'}
      onRequestClose={() => dispatch(clearAssertionContext(documentType))}
      contentLabel="Assertion rule examples"
      style={{
        overlay: { zIndex: 1000 },
      }}
    >
      <div className="grid-row grid-gap">
        <div ref={refCallback} className="mobile:grid-col-12">
          {validationResult.current === 'ASSERTION_CONTEXT' ? (
            <CodeViewer codeHTML={validationResult.annotatedXML} />
          ) : (
            <p>No report validated.</p>
          )}
        </div>
      </div>
    </Modal>
  );
};
