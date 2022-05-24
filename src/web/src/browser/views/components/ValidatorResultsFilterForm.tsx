import type { Presenter } from '@asap/browser/presenter';
import React, { useRef } from 'react';

import { colorTokenForRole } from '../../util/styles';
import { useActions, useAppState } from '../hooks';

type Props = {
  documentType: keyof Presenter['state']['schematron'];
};

export const ValidatorResultsFilterForm = ({ documentType }: Props) => {
  const schematron = useAppState().schematron[documentType];
  const actions = useActions();

  const topRef = useRef<HTMLHeadingElement>(null);
  const scrollIntoView = () => {
    if (topRef && topRef.current) {
      console.log('Skipping scroll until multi-document UI is done...');
      //topRef.current.scrollIntoView();
    }
  };
  return (
    <>
      <h2 ref={topRef}>Filtering Options</h2>
      <form className="usa-form padding-top-1">
        <fieldset className="usa-fieldset">
          <legend className="usa-legend text-base font-sans-md">
            Filter by pass status
          </legend>
          <div className="usa-radio">
            {schematron.filterOptions.passStatuses.map(passStatus => (
              <div key={passStatus.id}>
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`${documentType}-status-${passStatus.id}`}
                  type="radio"
                  name="pass-status"
                  value={passStatus.id}
                  checked={schematron.filter.passStatus === passStatus.id}
                  disabled={!passStatus.enabled}
                  onChange={() => {
                    actions.schematron.setPassStatus({
                      documentType,
                      passStatus: passStatus.id,
                    });
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`${documentType}-status-${passStatus.id}`}
                >
                  {passStatus.title}
                  <span
                    className="margin-left-1 usa-tag"
                    title={`${passStatus.count} results`}
                  >
                    {passStatus.count}
                  </span>
                </label>
              </div>
            ))}
          </div>
          <legend className="usa-legend font-sans-md">Select a view</legend>
          <div className="usa-radio">
            {schematron.filterOptions.assertionViews.map(assertionView => (
              <div key={assertionView.index}>
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`${documentType}-assertion-view-${assertionView.index}`}
                  type="radio"
                  name="assertion-view"
                  value={assertionView.index}
                  checked={
                    schematron.filter.assertionViewId === assertionView.index
                  }
                  onChange={() => {
                    actions.schematron.setFilterAssertionView({
                      documentType,
                      assertionViewId: assertionView.index,
                    });
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`${documentType}-assertion-view-${assertionView.index}`}
                >
                  {assertionView.title}
                  <span
                    className="margin-left-1 usa-tag"
                    title={`${assertionView.count} results`}
                  >
                    {assertionView.count}
                  </span>
                </label>
              </div>
            ))}
          </div>
          <legend className="usa-legend font-sans-md">
            Filter by assertion text
          </legend>
          <span className="usa-hint">
            Filtered results appear as you type, showing exact matches.
          </span>
          <div
            className="usa-search usa-search--small margin-top-1"
            role="search"
          >
            <label
              className="usa-sr-only"
              htmlFor={`${documentType}-search-field`}
            >
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
                id={`${documentType}-search-field`}
                type="search"
                className="usa-input"
                autoComplete="off"
                onChange={event => {
                  let text = '';
                  if (event && event.target) {
                    text = event.target.value;
                  }
                  actions.schematron.setFilterText({ documentType, text });
                }}
                placeholder="Search text..."
              />
            </div>
          </div>
          <div className="usa-radio">
            <legend className="usa-legend font-sans-md">
              Filter by severity
            </legend>
            {schematron.filterOptions.roles.map((filterRole, index) => (
              <div
                key={index}
                className={`bg-${colorTokenForRole(filterRole.name)}-lighter`}
              >
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`${documentType}-role-${filterRole.name}`}
                  type="radio"
                  name="role"
                  value={filterRole.name}
                  checked={schematron.filter.role === filterRole.name}
                  onChange={() => {
                    actions.schematron.setFilterRole({
                      documentType,
                      role: filterRole.name,
                    });
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`${documentType}-role-${filterRole.name}`}
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
                    {filterRole.subtitle}
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
