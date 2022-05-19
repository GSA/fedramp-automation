import React from 'react';
import Modal from 'react-modal';

import { useActions, useAppState } from '../hooks';
import { AssertionXSpecScenarios } from './AssertionXSpecScenarios';

// Make sure to bind modal to your appElement (https://reactcommunity.org/react-modal/accessibility/)
Modal.setAppElement('#root');

export const ValidatorContentOverlay = () => {
  const { schematron } = useAppState();
  const actions = useActions();

  return (
    <div>
      <Modal
        className="position-absolute top-2 bottom-2 right-2 left-2 margin-2 bg-white overflow-scroll"
        isOpen={schematron.assertionDocumentation.visibleDocumentation !== null}
        onRequestClose={actions.assertionDocumentation.close}
        contentLabel="Assertion rule examples"
        style={{
          overlay: { zIndex: 1000 },
        }}
      >
        <div className="margin-2">
          <button
            className="usa-button usa-button--unstyled float-right"
            onClick={actions.assertionDocumentation.close}
          >
            Close help
          </button>
          <h2>Assertion Examples</h2>
        </div>
        {schematron.assertionDocumentation.visibleDocumentation ? (
          <AssertionXSpecScenarios
            scenarioSummaries={
              schematron.assertionDocumentation.xspecScenarioSummaries.ssp[
                schematron.assertionDocumentation.visibleDocumentation
              ]
            }
          />
        ) : null}
      </Modal>
    </div>
  );
};
