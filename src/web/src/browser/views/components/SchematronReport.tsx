import React from 'react';

import { Routes, getUrl } from '@asap/browser/presenter/state/router';

import { colorTokenForRole } from '../../util/styles';
import { useActions, useAppState } from '../hooks';

export const SchematronReport = () => {
  const { schematronReport } = useAppState().schematron;
  const { getAssetUrl } = useActions();
  return (
    <div className="grid-row grid-gap">
      <div className="tablet:grid-col">
        <h1 className="font-heading-lg margin-bottom-0">
          {schematronReport.summary.title}
          <span
            className="font-heading-sm text-secondary-light"
            style={{ float: 'right' }}
          >
            <span className={`text-blue`}>
              {schematronReport.summary.counts.assertions} concerns and{' '}
              {schematronReport.summary.counts.reports} notes
            </span>
          </span>
        </h1>
        <h2 className="margin-top-1 font-heading-md text-light">
          {schematronReport.summary.subtitle}
        </h2>
        {schematronReport.groups.map((group, index) => (
          <details
            key={index}
            className="border-top-1px border-accent-cool-light padding-1"
            open={false}
          >
            <summary>
              <span
                className="font-heading-sm text-secondary-light"
                style={{ float: 'right' }}
              >
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
                  <div
                    className={`usa-icon-list__icon text-${check.icon.color}`}
                  >
                    <svg className="usa-icon" aria-hidden="true" role="img">
                      <use
                        xlinkHref={getAssetUrl(
                          `uswds/img/sprite.svg#${check.icon.sprite}`,
                        )}
                      ></use>
                    </svg>
                  </div>
                  <div className="usa-icon-list__content">
                    {check.message}
                    {check.fired.length ? (
                      <ul className="usa-icon-list__title">
                        {check.fired.map((firedCheck, index) => (
                          <li key={index}>
                            {firedCheck.diagnosticReferences.length > 0
                              ? firedCheck.diagnosticReferences.join(', ')
                              : firedCheck.text}
                            <a
                              className="usa-tooltip"
                              data-position="bottom"
                              href={getUrl(
                                Routes.assertion({
                                  assertionId: firedCheck.uniqueId,
                                }),
                              )}
                              title="Show source document context"
                            >
                              <svg
                                className="usa-icon"
                                aria-hidden="true"
                                focusable="false"
                                role="img"
                              >
                                <use
                                  xlinkHref={getAssetUrl(
                                    'uswds/img/sprite.svg#link',
                                  )}
                                ></use>
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
      </div>
    </div>
  );
};
