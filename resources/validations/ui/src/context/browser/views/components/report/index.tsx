import React, { useState } from 'react';

import type { ValidationAssert } from '../../../../../use-cases/schematron';
import { usePresenter } from '../../../views/hooks';
import { colorTokenForRole } from '../../../util/styles';

const MAX_ASSERT_TEXT_LENGTH = 200;

const Assertion = ({ assert }: { assert: ValidationAssert }) => {
  const [expanded, setExpanded] = useState<boolean>(false);
  return (
    <div
      className={`usa-alert usa-alert--${colorTokenForRole(assert.role)}`}
      role="alert"
    >
      <div className="usa-alert__body">
        <h4 className="usa-alert__heading">{assert.id}</h4>
        <div className="usa-alert__text">
          {assert.text.length < MAX_ASSERT_TEXT_LENGTH ? (
            assert.text
          ) : (
            <div>
              {expanded
                ? assert.text
                : assert.text.slice(0, MAX_ASSERT_TEXT_LENGTH)}
              <button
                className="usa-button usa-button--unstyled"
                onClick={() => setExpanded(!expanded)}
              >
                {' '}
                {expanded ? 'Less' : 'More...'}
              </button>
            </div>
          )}
          <ul>
            {assert.see && <li>`see: ${assert.see}`</li>}
            <li>xpath: {assert.location}</li>
            <li>test: {assert.test}</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export const SSPReport = () => {
  const { state } = usePresenter();
  return (
    <div>
      {state.report.current === 'VALIDATED' && (
        <>
          <h1>
            Showing {state.report.visibleAssertions.length} of{' '}
            {state.report.validationReport &&
              state.report.validationReport.failedAsserts.length}
          </h1>
          {state.report.visibleAssertions.map((assert, index) => (
            <Assertion key={index} assert={assert} />
          ))}
        </>
      )}
    </div>
  );
};
