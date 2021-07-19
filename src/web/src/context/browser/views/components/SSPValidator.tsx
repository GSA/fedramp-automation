import React from 'react';

import { usePresenter } from '../hooks';
import { onFileInputChangeGetFile } from '../../util/file-input';
import { colorTokenForRole } from '../../util/styles';
import { SSPReport } from './report';

export const SSPValidator = () => {
  const { state, actions } = usePresenter();
  const validatedReport = state.report.matches('VALIDATED');

  return (
    <div className="grid-row grid-gap">
      <div className="mobile:grid-col-12 tablet:grid-col-4">
        <label className="usa-label" htmlFor="file-input-specific">
          FedRAMP OSCAL SSP document
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
          onChange={onFileInputChangeGetFile(fileDetails => {
            actions.report.setXmlContents({
              fileName: fileDetails.name,
              xmlContents: fileDetails.text,
            });
          })}
          disabled={state.report.current === 'PROCESSING'}
        />
        <div className="margin-y-1">
          <div className="usa-hint">
            Or use an example file, brought to you by FedRAMP:
          </div>
          <ul>
            {state.sampleSSPs.map((sampleSSP, index) => (
              <li key={index}>
                <button
                  className="usa-button usa-button--unstyled"
                  onClick={() => actions.report.setXmlUrl(sampleSSP.url)}
                  disabled={state.report.current === 'PROCESSING'}
                >
                  {sampleSSP.displayName}
                </button>
              </li>
            ))}
          </ul>
        </div>
        {validatedReport && (
          <form className="usa-form">
            <fieldset className="usa-fieldset">
              <div className="usa-search usa-search--small" role="search">
                <label className="usa-sr-only" htmlFor="search-field">
                  Search
                </label>
                <div className="usa-input-group">
                  <div className="usa-input-prefix" aria-hidden="true">
                    <svg
                      aria-hidden="true"
                      role="img"
                      focusable="false"
                      className="usa-icon"
                    >
                      <use
                        xmlnsXlink="http://www.w3.org/1999/xlink"
                        xlinkHref={actions.getAssetUrl(
                          'uswds/img/sprite.svg#search',
                        )}
                      />
                    </svg>
                  </div>
                  <input
                    id="search-field"
                    type="search"
                    className="usa-input"
                    autoComplete="off"
                    onChange={event => {
                      let text = '';
                      if (event && event.target) {
                        text = event.target.value;
                      }
                      actions.report.setFilterText(text);
                    }}
                    placeholder="Search text..."
                  />
                </div>
              </div>
              <div className="usa-radio">
                {validatedReport.roles.map((filterRole, index) => (
                  <div key={index}>
                    <input
                      className="usa-radio__input usa-radio__input--tile"
                      id={`role-${filterRole}`}
                      type="radio"
                      name="role"
                      value={filterRole}
                      checked={validatedReport.filter.role === filterRole}
                      onChange={() => actions.report.setFilterRole(filterRole)}
                    />
                    <label
                      className={`usa-radio__label bg-${colorTokenForRole(
                        filterRole,
                      )}-lighter`}
                      htmlFor={`role-${filterRole}`}
                    >
                      <svg
                        aria-hidden="true"
                        role="img"
                        focusable="false"
                        className="usa-icon usa-icon--size-3 margin-right-1 margin-bottom-neg-2px"
                      >
                        <use
                          xmlnsXlink="http://www.w3.org/1999/xlink"
                          xlinkHref={actions.getAssetUrl(
                            `uswds/img/sprite.svg#${colorTokenForRole(
                              filterRole,
                            )}`,
                          )}
                        />
                      </svg>
                      {filterRole || '<not specified>'}
                    </label>
                  </div>
                ))}
              </div>
            </fieldset>
          </form>
        )}
      </div>
      <div className="mobile:grid-col-12 tablet:grid-col-8">
        {state.report.current === 'PROCESSING' && <div className="loader" />}
        <SSPReport />
      </div>
    </div>
  );
};
