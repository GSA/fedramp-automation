import React from 'react';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import { useActions, useAppState } from '../hooks';
import classnames from 'classnames';

export const Header = () => {
  const { getAssetUrl } = useActions();
  const { currentRoute } = useAppState().router;
  return (
    <header className="usa-header usa-header--basic usa-header--megamenu">
      <div className="usa-nav-container">
        <div className="usa-navbar">
          <div className="usa-logo" id="basic-mega-logo">
            <em className="usa-logo__text">
              <a href={getUrl(Routes.home)} title="Home" aria-label="Home">
                FedRAMP ASAP
              </a>
            </em>
          </div>
          <button className="usa-menu-btn">Menu</button>
        </div>
        <nav aria-label="Primary navigation" className="usa-nav">
          <button className="usa-nav__close">
            <img
              src={getAssetUrl('uswds/img/usa-icons/close.svg')}
              role="img"
              alt="close"
            />
          </button>
          <ul className="usa-nav__primary usa-accordion">
            <li className="usa-nav__primary-item">
              <a
                className={classnames('usa-nav__link', {
                  'usa-current': currentRoute.type === Routes.home.type,
                })}
                href="#/"
              >
                <span>Home</span>
              </a>
            </li>
            <li className="usa-nav__primary-item">
              <a
                className={classnames('usa-nav__link', {
                  'usa-current':
                    currentRoute.type === Routes.documentSummary.type,
                })}
                href={getUrl(Routes.documentSummary)}
              >
                <span>Document Rules</span>
              </a>
            </li>
            <li className="usa-nav__primary-item">
              <button
                className={classnames(
                  'usa-accordion__button',
                  'usa-nav__link',
                  {
                    'usa-current': currentRoute.type === Routes.developers.type,
                  },
                )}
                aria-expanded="false"
                aria-controls="extended-documentation"
              >
                <span>Documentation</span>
              </button>

              <ul id="extended-documentation" className="usa-nav__submenu">
                <li className="usa-nav__submenu-item">
                  <a href={getUrl(Routes.developers)}>Developers</a>
                </li>
                <li className="usa-nav__submenu-item">
                  <a href={getUrl(Routes.usageTracking)}>Usage Tracking</a>
                </li>
              </ul>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  );
};
