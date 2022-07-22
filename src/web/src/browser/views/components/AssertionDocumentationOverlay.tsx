import Modal from 'react-modal';
import { useAppContext } from '../context';
import spriteSvg from 'uswds/img/sprite.svg';

import { AssertionXSpecScenarios } from './AssertionXSpecScenarios';
import * as assertionDocumentation from '../../presenter/actions/assertion-documentation';

export const AssertionDocumentationOverlay = () => {
  const { dispatch, state } = useAppContext();

  return (
    <div className="bg-base-dark">
      <Modal
        className="overflow-scroll radius-lg padding-x-10 padding-y-5"
        isOpen={state.assertionDocumentation.current === 'SHOWING'}
        onRequestClose={() => dispatch(assertionDocumentation.close)}
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
        <div className="margin-2">
          <button
            className="usa-button usa-button--unstyled float-right"
            onClick={() => dispatch(assertionDocumentation.close)}
          >
            <svg
              className="usa-icon"
              aria-hidden="true"
              focusable="false"
              role="img"
              fontSize="1.5rem"
            >
              <use xlinkHref={`${spriteSvg}#close`}></use>
            </svg>
            <span className="usa-sr-only">Close</span>
          </button>
          <h2 className="font-sans-2xl text-light text-theme-dark-blue margin-0 margin-bottom-2 text-center">
            Assertion Examples
          </h2>
          <div className="usa-alert usa-alert--info usa-alert--no-icon">
            <div className="usa-alert__body">
              <p className="usa-alert__text">
                These are examples and not user-generated code
              </p>
            </div>
          </div>
        </div>
        <AssertionXSpecScenarios />
      </Modal>
    </div>
  );
};
