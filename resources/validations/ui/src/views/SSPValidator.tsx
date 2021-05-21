import React, { ChangeEvent, useState } from 'react';

import {
  transform,
  ValidationAssert,
  ValidationReport,
} from '../adapters/saxon-js';

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

export default ({}: Props) => {
  type Loading = boolean;
  const [validationReport, setValidationReport] =
    useState<ValidationReport | Loading>(false);

  const setXmlDocument = (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files.length > 0) {
      const inputFile = event.target.files[0];
      const reader = new FileReader();
      reader.addEventListener('load', event => {
        if (!event.target || !event.target.result) {
          return;
        }

        const sourceText = event.target.result.toString();
        if (!sourceText) {
          return;
        }

        setValidationReport(true);
        transform({ sourceText }).then((report: ValidationReport) => {
          setValidationReport(report);
        });
      });
      setValidationReport(false);
      reader.readAsText(inputFile);
    }
  };

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
        onChange={setXmlDocument}
      />
      {validationReport === false ? null : validationReport === true ? (
        <div className="loader" />
      ) : (
        <SSPReport report={validationReport} />
      )}
    </div>
  );
};
