import React from 'react';

import { colorTokenForRole } from '../../util/styles';
import { useActions, useAppState } from '../hooks';

export const ValidatorResultsFilterForm = () => {
  const { schematron } = useAppState();
  const actions = useActions();

  return (
    <form className="usa-form bg-white padding-top-1">
      <fieldset className="usa-fieldset">
        <legend className="usa-legend">Select an assertion view</legend>
        <div className="usa-radio">
          {schematron.filterOptions.assertionViews.map(assertionView => (
            <div key={assertionView.id}>
              <input
                className="usa-radio__input usa-radio__input--tile"
                id={`assertion-view-${assertionView.id}`}
                type="radio"
                name="assertion-view"
                value={assertionView.id}
                checked={schematron.filter.assertionViewId === assertionView.id}
                onChange={() =>
                  actions.schematron.setFilterAssertionView(assertionView.id)
                }
              />
              <label
                className="usa-radio__label"
                htmlFor={`assertion-view-${assertionView.id}`}
              >
                {assertionView.title}
                <span className="usa-checkbox__label-description">
                  This is optional text that can be used to describe the label
                  in more detail.
                </span>
              </label>
            </div>
          ))}
        </div>
        <div
          className="usa-search usa-search--small margin-top-1"
          role="search"
        >
          <label className="usa-sr-only" htmlFor="search-field">
            Search assertion text
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
                  xlinkHref={actions.getAssetUrl('uswds/img/sprite.svg#search')}
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
              placeholder="Search assertion text..."
            />
          </div>
        </div>
        <div className="usa-radio">
          <legend className="usa-legend">Filter by assertion role</legend>
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
                onChange={() => actions.schematron.setFilterRole(filterRole)}
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
                      `uswds/img/sprite.svg#${colorTokenForRole(filterRole)}`,
                    )}
                  />
                </svg>
                {filterRole.toLocaleUpperCase() || '<not specified>'}
                <span className="usa-checkbox__label-description">
                  This is optional text that can be used to describe the label
                  in more detail.
                </span>
              </label>
            </div>
          ))}
        </div>
      </fieldset>
    </form>
  );
};
