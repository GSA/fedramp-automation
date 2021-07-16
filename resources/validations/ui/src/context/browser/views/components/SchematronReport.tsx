import React from 'react';
import { Routes, getUrl } from '../../presenter/router';
import { colorTokenForRole } from '../../util/styles';
import { useActions, useAppState } from '../hooks';

export const SchematronReport = () => {
  const { schematronReport } = useAppState().schematron;
  const { getAssetUrl } = useActions();
  return (
    <div className="grid-row grid-gap">
      <div className="tablet:grid-col">
        <h1 className="font-heading-lg">{schematronReport.summaryText}</h1>
        {schematronReport.groups.map((group, index) => (
          <details
            key={index}
            className="border-top-1px border-accent-cool-light padding-1"
            open={true}
          >
            <summary>
              <span className="font-heading-lg text-primary border-base-light padding-top-1">
                {group.title}
                <span
                  className="font-heading-sm text-secondary-light"
                  style={{ float: 'right' }}
                >
                  <span className={`text-${group.assertions.summaryColor}`}>
                    {group.assertions.summary}
                  </span>
                </span>
              </span>
            </summary>
            <ul className="usa-icon-list margin-top-1">
              {group.assertions.assertions.map((assert, index) => (
                <li
                  key={index}
                  className={`usa-icon-list__item padding-1 bg-${colorTokenForRole(
                    assert.role,
                  )}-lighter`}
                >
                  <div
                    className={`usa-icon-list__icon text-${assert.icon.color}`}
                  >
                    <svg className="usa-icon" aria-hidden="true" role="img">
                      <use
                        xlinkHref={getAssetUrl(
                          `uswds/img/sprite.svg#${assert.icon.sprite}`,
                        )}
                      ></use>
                    </svg>
                  </div>
                  <div className="usa-icon-list__content">
                    {assert.message}
                    {assert.fired.length ? (
                      <ul className="usa-icon-list__title">
                        {assert.fired.map((firedAssert, index) => (
                          <li key={index}>
                            {firedAssert.diagnosticReferences.length > 0
                              ? firedAssert.diagnosticReferences.join(', ')
                              : firedAssert.text}
                            <a
                              className="usa-tooltip"
                              data-position="bottom"
                              href={getUrl(
                                Routes.assertion({
                                  assertionId: firedAssert.uniqueId,
                                }),
                              )}
                              title={firedAssert.location}
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
