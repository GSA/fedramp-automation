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
                  'usa-current': currentRoute.type === Routes.validator.type,
                })}
                href={getUrl(Routes.validator)}
              >
                <span>SSP Validator</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  );
};
