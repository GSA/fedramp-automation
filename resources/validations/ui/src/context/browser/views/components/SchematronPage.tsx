import React from 'react';
import { Routes, getUrl } from '../../presenter/router';
import { useActions, useAppState } from '../hooks';

export const SchematronPage = () => {
  const { schematronReport } = useAppState();
  const { getAssetUrl } = useActions();
  return (
    <div className="grid-row grid-gap">
      <div className="tablet:grid-col">
        {schematronReport.groups.map((group, index) => (
          <>
            <h2 className="font-heading-lg text-primary border-top-1px border-base-light padding-top-1">
              {group.title}
              <span
                className="font-heading-sm text-secondary-light"
                style={{ float: 'right' }}
              >
                {group.assertions.length} Assertions
              </span>
            </h2>
            <ul className="usa-icon-list usa-icon-list--size-lg">
              {group.assertions.map((assert, index) => (
                <li key={index} className="usa-icon-list__item">
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
                    <h3 className="usa-icon-list__title">{assert.title}</h3>
                    <p>
                      <strong>{assert.title}</strong>: {assert.text}
                    </p>
                    <ul>
                      {assert.fired.map((firedAssert, index) => (
                        <li key={index}>
                          <a
                            href={getUrl(
                              Routes.assertion({
                                assertionId: firedAssert.uniqueId,
                              }),
                            )}
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
                          </a>{' '}
                          {firedAssert.text}
                        </li>
                      ))}
                    </ul>
                  </div>
                </li>
              ))}
            </ul>
          </>
        ))}
      </div>
    </div>
  );
};
