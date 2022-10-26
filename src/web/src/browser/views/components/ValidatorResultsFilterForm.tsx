import { useRef } from 'react';
import spriteSvg from 'uswds/img/sprite.svg';
import * as schematron from '@asap/browser/presenter/actions/schematron';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { useAppContext } from '../context';
import { selectFilterOptions } from '@asap/browser/presenter/state/selectors';
import '../styles/ValidatorResultsFilterForm.scss';

type Props = {
  documentType: OscalDocumentKey;
};

export const ValidatorResultsFilterForm = ({ documentType }: Props) => {
  const { state } = useAppContext();
  const oscalDocument = state.oscalDocuments[documentType];
  const { dispatch } = useAppContext();

  const filterOptions = selectFilterOptions(documentType)(state);

  const topRef = useRef<HTMLHeadingElement>(null);
  const scrollIntoView = () => {
    if (topRef && topRef.current && topRef.current.parentElement) {
      topRef.current.parentElement.scrollIntoView();
    }
  };
  return (
    <>
      <aside className="padding-y-2 radius-lg padding-x-1 desktop:padding-x-3">
        <h2 className=" desktop:font-sans-xl" ref={topRef}>
          Filtering Options
        </h2>

        <div
          className="usa-search usa-search--small margin-bottom-2"
          role="search"
        >
          <label className="usa-sr-only" htmlFor="search-field-en-small">
            Search
          </label>
          <input
            className="usa-input"
            type="search"
            name="search"
            id={`${documentType}-search-field`}
            autoComplete="off"
            onChange={event => {
              let text = '';
              if (event && event.target) {
                text = event.target.value;
              }
              dispatch(schematron.setFilterText({ documentType, text }));
            }}
            placeholder="Search text..."
          />
          <button className="usa-button" type="submit">
            <svg
              aria-hidden="true"
              role="img"
              focusable="false"
              className="usa-icon"
            >
              <use
                xmlnsXlink="http://www.w3.org/1999/xlink"
                xlinkHref={`${spriteSvg}#search`}
              />
            </svg>
          </button>
        </div>
        <fieldset className="usa-fieldset margin-y-3">
          <legend className="usa-legend usa-legend--large font-sans-md margin-bottom-1">
            Filter by pass status
          </legend>
          <div className="usa-radio desktop:padding-left-2 desktop:width-mobile">
            {filterOptions.passStatuses.map(passStatus => (
              <div key={passStatus.id}>
                <input
                  className="usa-radio__input "
                  id={`${documentType}-status-${passStatus.id}`}
                  type="radio"
                  name="pass-status"
                  value={passStatus.id}
                  checked={oscalDocument.filter.passStatus === passStatus.id}
                  disabled={!passStatus.enabled}
                  onChange={() => {
                    dispatch(
                      schematron.setPassStatus({
                        documentType,
                        passStatus: passStatus.id,
                      }),
                    );
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label desktop:display-flex desktop:flex-justify "
                  htmlFor={`${documentType}-status-${passStatus.id}`}
                >
                  <span>{passStatus.title}</span>
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
        </fieldset>
        <fieldset className="usa-fieldset margin-y-3">
          <legend className="usa-legend usa-legend--large font-sans-md margin-bottom-1">
            Select a view
          </legend>
          <div className="usa-radio desktop:padding-left-2 desktop:width-mobile">
            {filterOptions.assertionViews.map(assertionView => (
              <div key={assertionView.index}>
                {/* 
                TODO: remove after debugging
                <pre>{JSON.stringify(assertionView, null, 2)}</pre> */}
                <input
                  className="usa-radio__input"
                  id={`${documentType}-assertion-view-${assertionView.index}`}
                  type="radio"
                  name="assertion-view"
                  value={assertionView.index}
                  checked={
                    oscalDocument.filter.assertionViewId === assertionView.index
                  }
                  onChange={() => {
                    dispatch(
                      schematron.setFilterAssertionView({
                        documentType,
                        assertionViewId: assertionView.index,
                      }),
                    );
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label desktop:display-flex desktop:flex-justify"
                  htmlFor={`${documentType}-assertion-view-${assertionView.index}`}
                >
                  <span>{assertionView.title}</span>
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
        </fieldset>
        <fieldset className="usa-fieldset margin-y-3">
          <legend className="usa-legend usa-legend--large font-sans-md margin-bottom-1">
            Filter by FedRAMP status
          </legend>
          <div className="usa-radio">
            {filterOptions.fedrampSpecificOptions.map((option, index) => (
              <div key={index} className="bg-info-lighter">
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`${documentType}-fedramp-specific-${option.option}`}
                  type="radio"
                  name="fedrampSpecific"
                  value={option.option}
                  checked={
                    oscalDocument.filter.fedrampSpecificOption === option.option
                  }
                  onChange={() => {
                    dispatch(
                      schematron.setFilterFedrampOption({
                        documentType,
                        fedrampFilterOption: option.option,
                      }),
                    );
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`${documentType}-fedramp-specific-${option.option}`}
                >
                  <div className="desktop:width-card desktop:display-flex desktop:flex-justify desktop:width-full desktop:padding-right-3">
                    <span>
                      {option.option.toLocaleUpperCase() || '<not specified>'}
                    </span>
                    <span
                      className="margin-left-1 usa-tag"
                      title={`${option.count} results`}
                    >
                      {option.count}
                    </span>
                  </div>
                  <span className="usa-checkbox__label-description">
                    {option.subtitle}
                  </span>
                </label>
              </div>
            ))}
          </div>
        </fieldset>
        <fieldset className="usa-fieldset margin-y-3">
          <legend className="usa-legend font-sans-md usa-legend--large margin-bottom-1">
            Filter by severity
          </legend>
          <div className="usa-radio">
            {filterOptions.roles.map((filterRole, index) => (
              <div key={index} className="bg-info-lighter">
                <input
                  className="usa-radio__input usa-radio__input--tile"
                  id={`${documentType}-role-${filterRole.name}`}
                  type="radio"
                  name="role"
                  value={filterRole.name}
                  checked={oscalDocument.filter.role === filterRole.name}
                  onChange={() => {
                    dispatch(
                      schematron.setFilterRole({
                        documentType,
                        role: filterRole.name,
                      }),
                    );
                    scrollIntoView();
                  }}
                />
                <label
                  className="usa-radio__label"
                  htmlFor={`${documentType}-role-${filterRole.name}`}
                >
                  <div className="desktop:width-card desktop:display-flex desktop:flex-justify desktop:width-full desktop:padding-right-3">
                    <span>
                      {filterRole.name.toLocaleUpperCase() || '<not specified>'}
                    </span>
                    <span
                      className="margin-left-1 usa-tag"
                      title={`${filterRole.count} results`}
                    >
                      {filterRole.count}
                    </span>
                  </div>
                  <span className="usa-checkbox__label-description">
                    {filterRole.subtitle}
                  </span>
                </label>
              </div>
            ))}
          </div>
        </fieldset>
      </aside>
    </>
  );
};
