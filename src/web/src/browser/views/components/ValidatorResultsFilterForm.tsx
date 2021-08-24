import React, { useRef } from 'react';

import { colorTokenForRole } from '../../util/styles';
import { useActions, useAppState } from '../hooks';

export const ValidatorResultsFilterForm = () => {
  const { schematron } = useAppState();
  const actions = useActions();

  const topRef = useRef<HTMLHeadingElement>(null);
  const scrollIntoView = () => {
    if (topRef && topRef.current && topRef.current.parentElement) {
      topRef.current.parentElement.scrollIntoView();
    }
  };

  return (
    <>
      <h2 ref={topRef}>Filtering Options</h2>
      <form className="usa-form padding-top-1">
        <fieldset className="usa-fieldset">
          <legend className="usa-legend text-base font-sans-md">
            Select a view
          </legend>
          <div className="usa-radio">
            {schematron.filterOptions.assertionViews.map(assertionView => (
              <div key={assertionView.index}>
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`assertion-view-${assertionView.index}`}
                  type="radio"
                  name="assertion-view"
                  value={assertionView.index}
                  checked={
                    schematron.filter.assertionViewId === assertionView.index
                  }
                  onChange={() => {
                    actions.schematron.setFilterAssertionView(
                      assertionView.index,
                    );
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`assertion-view-${assertionView.index}`}
                >
                  {assertionView.title}
                  <span
                    className="margin-left-1 usa-tag"
                    title={`${assertionView.count} results`}
                  >
                    {assertionView.count}
                  </span>
                  <span className="usa-checkbox__label-description">
                    This is optional text that can be used to
                  </span>
                </label>
              </div>
            ))}
          </div>
          <legend className="usa-legend text-base font-sans-md">
            Filter by assertion text
          </legend>
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
            <legend className="usa-legend text-base font-sans-md">
              Filter by severity
            </legend>
            {schematron.filterOptions.roles.map((filterRole, index) => (
              <div
                key={index}
                className={`bg-${colorTokenForRole(filterRole.name)}-lighter`}
              >
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`role-${filterRole.name}`}
                  type="radio"
                  name="role"
                  value={filterRole.name}
                  checked={schematron.filter.role === filterRole.name}
                  onChange={() => {
                    actions.schematron.setFilterRole(filterRole.name);
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`role-${filterRole.name}`}
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
                          filterRole.name,
                        )}`,
                      )}
                    />
                  </svg>
                  {filterRole.name.toLocaleUpperCase() || '<not specified>'}
                  <span
                    className="margin-left-1 usa-tag"
                    title={`${filterRole.count} results`}
                  >
                    {filterRole.count}
                  </span>
                  <span className="usa-checkbox__label-description">
                    This is optional text that can be used to
                  </span>
                </label>
              </div>
            ))}
          </div>
        </fieldset>
      </form>
    </>
  );
};
