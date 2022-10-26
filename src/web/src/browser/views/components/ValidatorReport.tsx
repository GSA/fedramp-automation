import spriteSvg from 'uswds/img/sprite.svg';

import * as assertionDocumentation from '@asap/browser/presenter/actions/assertion-documentation';
import {
  downloadSVRL,
  showAssertionContext,
} from '@asap/browser/presenter/actions/validator';
import {
  selectFilterOptions,
  selectSchematronReport,
} from '@asap/browser/presenter/state/selectors';
import { getAssertionViewTitleByIndex } from '@asap/browser/presenter/state/schematron-machine';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { useAppContext } from '../context';
import '../styles/ValidatorReport.scss';

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

  interface FedRampTagProp {
    isFedRamp: boolean;
  }

  const FedRampTag = ({ isFedRamp }: FedRampTagProp) =>
    isFedRamp ? (
      <div>
        <span
          className="usa-tag bg-cyan text-uppercase usa-tooltip"
          data-position="right"
          title="FedRAMP-specific validation rule"
        >
          FedRAMP
        </span>
      </div>
    ) : null;

  return (
    <>
      <div className="top-0 padding-y-1">
        <div className="display-flex flex-align-center flex-justify">
          <h1 className="margin-0 font-sans-lg desktop:font-sans-xl">
            {validationResult.summary.title}
          </h1>
          <div className="float-right">
            <div
              className="font-heading-sm text-secondary-light text-error"
              style={{ textAlign: 'right' }}
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
            </div>
            {validationResult.current === 'HAS_RESULT' ? (
              <button
                className="usa-button usa-button--unstyled usa-tooltip padding-top-1"
                data-position="left"
                title="Download the raw Schematron Validation Report Language XML document"
                onClick={() => dispatch(downloadSVRL(documentType))}
              >
                Download SVRL
              </button>
            ) : null}
          </div>
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
            {group.isValidated ? (
              <span className="display-flex flex-align-center">
                {group.checks.summaryColor === 'green' ? (
                  <svg
                    className="usa-icon margin-right-05 text-green"
                    aria-hidden="true"
                    focusable="false"
                    role="img"
                  >
                    <use xlinkHref={`${spriteSvg}#check`}></use>
                  </svg>
                ) : (
                  <svg
                    className="usa-icon margin-right-05 text-error"
                    aria-hidden="true"
                    focusable="false"
                    role="img"
                  >
                    <use xlinkHref={`${spriteSvg}#flag`}></use>
                  </svg>
                )}
                <span className={`text-${group.checks.summaryColor}`}>
                  {group.checks.summary}
                </span>
              </span>
            ) : (
              <span className="usa-tag">{group.checks.checks.length}</span>
            )}
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
                  {check.fired.length ? (
                    // FAILED
                    <details className="usa-icon-list__content">
                      <summary>
                        <b>
                          {`${
                            check.fired.length
                          } ${check.role.toUpperCase()}: `}
                        </b>
                        <span>{check.message}</span>
                        <FedRampTag isFedRamp={check.fedrampSpecific} />
                        <div>
                          <span className="text-primary text-underline margin-right-1 learn-more">
                            Learn more
                          </span>
                          <span className="margin-right-1">|</span>
                          <button
                            className="usa-button usa-button--unstyled margin-right-1"
                            onClick={() =>
                              dispatch(
                                assertionDocumentation.show({
                                  assertionId: check.id,
                                  documentType,
                                }),
                              )
                            }
                          >
                            View Examples
                          </button>
                          <span className="margin-right-1">|</span>
                          <a
                            href={check.referenceUrl}
                            className="text-primary text-underline"
                            target="_blank"
                            rel="noopener"
                          >
                            View Schematron
                          </a>
                        </div>
                      </summary>
                      <p className="text-ink margin-y-05">
                        Select an item below to show source documentation
                        context
                      </p>
                      <ul className="padding-left-2">
                        {check.fired.map((firedCheck, index) => (
                          <li key={index} className="text-base-darker">
                            <a
                              className="usa-tooltip line-height-code-3"
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
                                role="img"
                              >
                                <use xlinkHref={`${spriteSvg}#remove`}></use>
                              </svg>
                              {firedCheck.diagnosticReferences.length > 0
                                ? firedCheck.diagnosticReferences.join(', ')
                                : firedCheck.text}
                            </a>
                          </li>
                        ))}
                      </ul>
                    </details>
                  ) : (
                    // PASS
                    <div className="usa-icon-list__content">
                      <b>{group.isValidated ? 'PASS: ' : null}</b>
                      <span> {check.message}</span>
                      <FedRampTag isFedRamp={check.fedrampSpecific} />
                      <div>
                        <button
                          className="usa-button usa-button--unstyled margin-right-1"
                          onClick={() =>
                            dispatch(
                              assertionDocumentation.show({
                                assertionId: check.id,
                                documentType,
                              }),
                            )
                          }
                        >
                          View Examples
                        </button>
                        <span className="margin-right-1">|</span>
                        <a
                          href={check.referenceUrl}
                          className="text-primary text-underline"
                          target="_blank"
                          rel="noopener"
                        >
                          View Schematron
                        </a>
                      </div>
                    </div>
                  )}
                </li>
              ))}
            </ul>
          </div>
        </details>
      ))}
    </>
  );
};
