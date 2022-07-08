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
          target.style.backgroundColor = 'lightcyan';
        }
      }
    },
    [validationResult],
  );

  return (
    <Modal
      className="overflow-scroll radius-lg padding-x-10 padding-y-5"
      isOpen={validationResult.current === 'ASSERTION_CONTEXT'}
      onRequestClose={() => dispatch(clearAssertionContext(documentType))}
      contentLabel="Assertion rule examples"
      style={{
        overlay: {
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          zIndex: '1000',
        },
        content: {
          position: 'absolute',
          top: '40px',
          left: '40px',
          right: '40px',
          bottom: '40px',
          border: '1px solid #ccc',
          background: '#fff',
          overflow: 'auto',
          WebkitOverflowScrolling: 'touch',
          outline: 'none',
        },
      }}
    >
      <div ref={refCallback}>
        {validationResult.current === 'ASSERTION_CONTEXT' ? (
          <CodeViewer codeHTML={validationResult.annotatedXML} />
        ) : (
          <p>No report validated.</p>
        )}
      </div>
    </Modal>
  );
};
