import React from 'react';

import { useActions, useAppState } from '../hooks';
import { onFileInputChangeGetFile } from '../../util/file-input';
import { colorTokenForRole } from '../../util/styles';
import { SchematronReport } from './SchematronReport';

export const ValidatorPage = () => {
  const { sourceRepository, schematron } = useAppState();
  const actions = useActions();

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
            actions.validator.setXmlContents({
              fileName: fileDetails.name,
              xmlContents: fileDetails.text,
            });
          })}
          disabled={schematron.validator.current === 'PROCESSING'}
        />
        <div className="margin-y-1">
          <div className="usa-hint">
            Or use an example file, brought to you by FedRAMP:
          </div>
          <ul>
            {sourceRepository.sampleSSPs.map((sampleSSP, index) => (
              <li key={index}>
                <button
                  className="usa-button usa-button--unstyled"
                  onClick={() => actions.validator.setXmlUrl(sampleSSP.url)}
                  disabled={schematron.validator.current === 'PROCESSING'}
                >
                  {sampleSSP.displayName}
                </button>
              </li>
            ))}
          </ul>
        </div>
        {
          <form className="usa-form">
            <fieldset className="usa-fieldset">
              <legend className="usa-legend usa-legend">
                Select an assertion view
              </legend>
              <div className="usa-radio">
                {schematron.filterOptions.assertionViews.map(assertionView => (
                  <div key={assertionView.id}>
                    <input
                      className="usa-radio__input usa-radio__input--tile"
                      id={`assertion-view-${assertionView.id}`}
                      type="radio"
                      name="assertion-view"
                      value={assertionView.id}
                      checked={
                        schematron.filter.assertionViewId === assertionView.id
                      }
                      onChange={() =>
                        actions.schematron.setFilterAssertionView(
                          assertionView.id,
                        )
                      }
                    />
                    <label
                      className="usa-radio__label"
                      htmlFor={`assertion-view-${assertionView.id}`}
                    >
                      {assertionView.title}
                    </label>
                  </div>
                ))}
              </div>
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
                      actions.schematron.setFilterText(text);
                    }}
                    placeholder="Search text..."
                  />
                </div>
              </div>
              <div className="usa-radio">
                {schematron.filterOptions.roles.map((filterRole, index) => (
                  <div
                    key={index}
                    className={`bg-${colorTokenForRole(filterRole)}-lighter`}
                  >
                    <input
                      className="usa-radio__input usa-radio__input--tile"
                      id={`role-${filterRole}`}
                      type="radio"
                      name="role"
                      value={filterRole}
                      checked={schematron.filter.role === filterRole}
                      onChange={() =>
                        actions.schematron.setFilterRole(filterRole)
                      }
                    />
                    <label
                      className="usa-radio__label"
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
        }
      </div>
      <div className="mobile:grid-col-12 tablet:grid-col-8">
        <SchematronReport />
        {schematron.validator.current === 'PROCESSING' && (
          <div className="loader" />
        )}
      </div>
    </div>
  );
};
