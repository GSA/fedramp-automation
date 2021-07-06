import React, { useState } from 'react';

import type { ValidationAssert } from '../../../../use-cases/schematron';
import { useAppState } from '../../views/hooks';
import { assertionRoute, getUrl } from '../../presenter/router';

const MAX_ASSERT_TEXT_LENGTH = 200;

const alertClassForRole = (role: string | undefined) => {
  const roleLower = (role || '').toLowerCase();
  if (roleLower.includes('warn')) {
    return 'usa-alert--warning';
  }
  if (roleLower.includes('error') || roleLower.includes('fatal')) {
    return 'usa-alert--error';
  }
  return 'usa-alert--info';
};

const Assertion = ({
  assert,
  href,
}: {
  assert: ValidationAssert;
  href: string;
}) => {
  const [expanded, setExpanded] = useState<boolean>(false);
  return (
    <div className={`usa-alert ${alertClassForRole(assert.role)}`} role="alert">
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
                Show XML context
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
  const reportState = useAppState().report;
  return (
    <div>
      {reportState.current === 'VALIDATED' && (
        <>
          <h1>
            Showing {reportState.visibleAssertions.length} of{' '}
            {reportState.validationReport &&
              reportState.validationReport.failedAsserts.length}
          </h1>
          {reportState.visibleAssertions.map((assert, index) => (
            <Assertion
              key={index}
              assert={assert}
              href={getUrl(assertionRoute({ assertionId: assert.id }))}
            />
          ))}
        </>
      )}
    </div>
  );
};
