import spriteSvg from 'uswds/img/sprite.svg';

import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { colorTokenForRole } from '../../util/styles';
import { useAppContext } from '../context';
import * as assertionDocumentation from '../../presenter/actions/assertion-documentation';
import { showAssertionContext } from '@asap/browser/presenter/actions/document-viewer';

type Props = {
  documentType: OscalDocumentKey;
};

export const ValidatorReport = ({ documentType }: Props) => {
  const { dispatch, state } = useAppContext();
  const schematronReport = state.oscalDocuments[documentType].schematronReport;

  return (
    <>
      <div className="top-0 bg-white padding-top-1 padding-bottom-1">
        <h1 className="margin-0">
          {schematronReport.summary.title}
          <span
            className="font-heading-sm text-secondary-light"
            style={{ float: 'right' }}
          >
            <span className={`text-blue`}>
              {schematronReport.summary.counts.assertions} concerns
            </span>
          </span>
        </h1>
        <h2 className="margin-top-05 margin-bottom-0 text-normal">
          {schematronReport.summary.subtitle}
        </h2>
      </div>
      {schematronReport.groups.map(group => (
        <details
          key={group.title}
          className="border-top-1px border-accent-cool-light padding-1"
          open={false}
        >
          <summary>
            <span className="text-secondary-light" style={{ float: 'right' }}>
              <span className={`text-${group.checks.summaryColor}`}>
                {group.checks.summary}
              </span>
            </span>
            <span className="font-heading-lg text-primary border-base-light padding-top-1">
              {group.title}
            </span>
          </summary>
          <ul className="usa-icon-list margin-top-1">
            {group.checks.checks.map((check, index) => (
              <li
                key={index}
                className={`usa-icon-list__item padding-1 bg-${colorTokenForRole(
                  check.role,
                )}-lighter`}
              >
                <div className={`usa-icon-list__icon text-${check.icon.color}`}>
                  <svg className="usa-icon" aria-hidden="true" role="img">
                    <use xlinkHref={`${spriteSvg}#${check.icon.sprite}`}></use>
                  </svg>
                </div>
                <div className="usa-icon-list__content">
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
                </div>
              </li>
            ))}
          </ul>
        </details>
      ))}
    </>
  );
};
