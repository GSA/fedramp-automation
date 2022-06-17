import Modal from 'react-modal';
import { useAppContext } from '../context';

import { AssertionXSpecScenarios } from './AssertionXSpecScenarios';
import * as assertionDocumentation from '../../presenter/actions/assertion-documentation';

export const AssertionDocumentationOverlay = () => {
  const { dispatch, state } = useAppContext();

  return (
    <div>
      <Modal
        className="position-absolute top-2 bottom-2 right-2 left-2 margin-2 bg-white overflow-scroll"
        isOpen={state.assertionDocumentation.visibleAssertion !== null}
        onRequestClose={() => dispatch(assertionDocumentation.close)}
        contentLabel="Assertion rule examples"
        style={{
          overlay: { zIndex: 1000 },
        }}
      >
        <div className="margin-2">
          <button
            className="usa-button usa-button--unstyled float-right"
            onClick={() => dispatch(assertionDocumentation.close)}
          >
            Close help
          </button>
          <h2>Assertion Examples</h2>
        </div>
        <AssertionXSpecScenarios
          scenarioSummaries={
            state.assertionDocumentation.visibleScenarioSummaries
          }
        />
      </Modal>
    </div>
  );
};
