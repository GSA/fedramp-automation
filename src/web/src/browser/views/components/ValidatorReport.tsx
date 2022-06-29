import spriteSvg from 'uswds/img/sprite.svg';

import * as assertionDocumentation from '@asap/browser/presenter/actions/assertion-documentation';
import { showAssertionContext } from '@asap/browser/presenter/actions/validator';
import {
  selectFilterOptions,
  selectSchematronReport,
} from '@asap/browser/presenter/state/selectors';
import { getAssertionViewTitleByIndex } from '@asap/browser/presenter/state/schematron-machine';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { colorTokenForRole } from '../../util/styles';
import { useAppContext } from '../context';
import '../styles/ValidatorReport.scss';
import { spawn } from 'child_process';

type Props = {
  documentType: OscalDocumentKey;
};

export const ValidatorReport = ({ documentType }: Props) => {
  const { dispatch, state } = useAppContext();
  const oscalDocument = state.oscalDocuments[documentType];
  const validationResult = state.validationResults[documentType];

  const filterOptions = selectFilterOptions(documentType)(state);
  const schematronReport = selectSchematronReport(documentType)(state);
  const viewTitle = getAssertionViewTitleByIndex(
    filterOptions.assertionViews,
    oscalDocument.filter.assertionViewId,
  );

  return (
    <>
      <div className="top-0 padding-y-1">
        <div className="display-flex flex-align-center flex-justify">
          <h1 className="margin-0">{validationResult.summary.title}</h1>
          <span
            className="font-heading-sm text-secondary-light text-error"
            style={{ float: 'right' }}
          >
            <svg
              className="usa-icon margin-right-05 text-error"
              aria-hidden="true"
              focusable="false"
              role="img"
            >
              <use xlinkHref={`${spriteSvg}#flag`}></use>
            </svg>
            {schematronReport.assertionCount} concerns
          </span>
        </div>
        <h2 className="margin-top-05 margin-bottom-0 text-normal">
          {viewTitle}
        </h2>
      </div>
      {schematronReport.groups.map(group => (
        <details
          key={group.title}
          className="border-top-1px border-accent-cool-light padding-1"
          open={false}
        >
          <summary className="display-flex flex-align-baseline flex-justify">
            <span className="font-heading-lg text-primary border-base-light padding-top-1">
              {group.title}
            </span>
            <span className="display-flex flex-align-center">
              {group.checks.summaryColor === 'red' ? (
                <svg
                  className="usa-icon margin-right-05 text-error"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                >
                  <use xlinkHref={`${spriteSvg}#flag`}></use>
                </svg>
              ) : (
                <svg
                  className="usa-icon margin-right-05 text-green"
                  aria-hidden="true"
                  focusable="false"
                  role="img"
                >
                  <use xlinkHref={`${spriteSvg}#check`}></use>
                </svg>
              )}
              <span className={`text-${group.checks.summaryColor}`}>
                {group.checks.summary}
              </span>
            </span>
          </summary>
          <div className="bg-base-lightest padding-1 radius-lg">
            <ul className="usa-icon-list margin-top-1 bg-base-lightest">
              {group.checks.checks.map((check, index) => (
                <li key={index} className={`usa-icon-list__item padding-1`}>
                  <div
                    className={`usa-icon-list__icon text-${check.icon.color}`}
                  >
                    <svg className="usa-icon" aria-hidden="true" role="img">
                      <use
                        xlinkHref={`${spriteSvg}#${check.icon.sprite}`}
                      ></use>
                    </svg>
                  </div>
                  <details className="usa-icon-list__content">
                    <summary>
                      {check.fired.length && <b>{check.fired.length} </b>}
                      {check.message}
                      <button
                        className="usa-button usa-button--unstyled"
                        onClick={() =>
                          dispatch(
                            assertionDocumentation.show({
                              assertionId: check.id,
                              documentType,
                            }),
                          )
                        }
                        title="View examples"
                      >
                        <svg
                          className="usa-icon"
                          aria-hidden="true"
                          focusable="false"
                          role="img"
                        >
                          <use xlinkHref={`${spriteSvg}#support`}></use>
                        </svg>
                      </button>
                    </summary>
                    {check.fired.length ? (
                      <ul className="usa-icon-list__title">
                        {check.fired.map((firedCheck, index) => (
                          <li key={index}>
                            {firedCheck.diagnosticReferences.length > 0
                              ? firedCheck.diagnosticReferences.join(', ')
                              : firedCheck.text}
                            <a
                              href="#"
                              className="usa-tooltip"
                              data-position="bottom"
                              onClick={() =>
                                dispatch(
                                  showAssertionContext({
                                    assertionId: firedCheck.uniqueId,
                                    documentType,
                                  }),
                                )
                              }
                              title="Show source document context"
                            >
                              <svg
                                className="usa-icon"
                                aria-hidden="true"
                                focusable="false"
                                role="img"
                              >
                                <use xlinkHref={`${spriteSvg}#link`}></use>
                              </svg>
                            </a>
                          </li>
                        ))}
                      </ul>
                    ) : null}
                  </details>
                </li>
              ))}
            </ul>
          </div>
        </details>
      ))}
    </>
  );
};
