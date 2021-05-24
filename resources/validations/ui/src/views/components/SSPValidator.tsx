import React from 'react';

// fixme: don't depend directly on use-case typing in the view
import type {
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/validate-ssp-xml';

import { usePresenter } from '../hooks';
import { onFileChange } from '../util/file-input';

interface Props {}

const SSPReport = ({ report }: { report: ValidationReport }) => {
  return (
    <div className="usa-table-container--scrollable">
      {report.failedAsserts.map((assert: ValidationAssert, index: number) => (
        <div className="usa-alert usa-alert--error" role="alert">
          <div className="usa-alert__body">
            <h4 className="usa-alert__heading">{assert.id}</h4>
            <p className="usa-alert__text">
              {assert.text}
              <ul>
                {assert.see && <li>`see: ${assert.see}`</li>}
                <li>xpath: {assert.location}</li>
                <li>test: {assert.test}</li>
              </ul>
            </p>
          </div>
        </div>
      ))}
    </div>
  );
};

export const SSPValidator: React.FC = () => {
  const { state, actions } = usePresenter();

  return (
    <div className="usa-form-group">
      <label className="usa-label" htmlFor="file-input-specific">
        Upload a FedRAMP OSCAL SSP document
      </label>
      <span className="usa-hint" id="file-input-specific-hint">
        Select XML file
      </span>
      <input
        id="file-input-specific"
        className="usa-file-input"
        type="file"
        name="file-input-specific"
        aria-describedby="file-input-specific-hint"
        accept=".xml"
        onChange={onFileChange(actions.setXmlContents)}
      />
      {state.loadingValidationReport && <div className="loader" />}
      {state.validationReport && <SSPReport report={state.validationReport} />}
    </div>
  );
};
