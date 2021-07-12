import React, { useState } from 'react';

import type { ValidationAssert } from '../../../../use-cases/schematron';
import { Routes, getUrl } from '../../presenter/router';
import { colorTokenForRole } from '../../util/styles';
import { useAppState } from '../hooks';

const MAX_ASSERT_TEXT_LENGTH = 200;

const Assertion = ({
  assert,
  href,
}: {
  assert: ValidationAssert;
  href: string;
}) => {
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
            <li>
              <a
                href={href}
                className="usa-tooltip"
                data-position="top"
                title={assert.location}
              >
                Show context in SSP
              </a>
            </li>
            <li>test: {assert.test}</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export const SSPReport = () => {
  const validator = useAppState().schematron.validator;
  return (
    <div>
      {validator.current === 'VALIDATED' && (
        <>
          <h1>
            Showing {validator.visibleAssertions.length} of{' '}
            {validator.validationReport &&
              validator.validationReport.failedAsserts.length}
          </h1>
          {validator.visibleAssertions.map((assert, index) => (
            <Assertion
              key={index}
              assert={assert}
              href={getUrl(Routes.assertion({ assertionId: assert.uniqueId }))}
            />
          ))}
        </>
      )}
    </div>
  );
};
