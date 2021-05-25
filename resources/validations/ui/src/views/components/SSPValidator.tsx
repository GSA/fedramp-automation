import React from 'react';

import { usePresenter } from '../hooks';
import { onFileChange } from '../util/file-input';
import { SSPReport } from './report';

export const SSPValidator: React.FC = () => {
  const { state, actions } = usePresenter();

  return (
    <div className="grid-row grid-gap">
      <div className="mobile:grid-col-12 tablet:grid-col-4">
        <label className="usa-label" htmlFor="file-input-specific">
          Select a FedRAMP OSCAL SSP document
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
          onChange={onFileChange(actions.report.setXmlContents)}
        />
        {state.report.validationReport && (
          <form className="usa-form">
            <fieldset className="usa-fieldset">
              <legend className="usa-legend">Filter by assertion role</legend>
              <div className="usa-radio">
                {state.report.roles.map((filterRole, index) => (
                  <>
                    <input
                      className="usa-radio__input usa-radio__input--tile"
                      key={index}
                      id={`role-${filterRole}`}
                      type="radio"
                      name="role"
                      value={filterRole}
                      checked={state.report.filter === filterRole}
                      onChange={() => actions.report.setFilterRole(filterRole)}
                    />
                    <label
                      className="usa-radio__label"
                      htmlFor={`role-${filterRole}`}
                    >
                      {filterRole}
                    </label>
                  </>
                ))}
              </div>
            </fieldset>
          </form>
        )}
      </div>
      <div className="mobile:grid-col-12 tablet:grid-col-8">
        {state.report.loadingValidationReport && <div className="loader" />}
        <SSPReport />
      </div>
    </div>
  );
};
