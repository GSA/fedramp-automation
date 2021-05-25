import React from 'react';
import { usePresenter } from '../../../views/hooks';

export const SSPReport = () => {
  const { state } = usePresenter();
  return (
    <div className="usa-table-container--scrollable">
      {state.report.visibleAssertions.map((assert, index) => (
        <div key={index} className="usa-alert usa-alert--error" role="alert">
          <div className="usa-alert__body">
            <h4 className="usa-alert__heading">{assert.id}</h4>
            <div className="usa-alert__text">
              {assert.text}
              <ul>
                {assert.see && <li>`see: ${assert.see}`</li>}
                <li>xpath: {assert.location}</li>
                <li>test: {assert.test}</li>
              </ul>
            </div>
          </div>
        </div>
      ))}
    </div>
  );
};
