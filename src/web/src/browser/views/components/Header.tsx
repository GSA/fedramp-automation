import React from 'react';

import { useActions } from '../hooks';

export const Header = () => {
  const { getAssetUrl } = useActions();
  return (
    <header className="usa-header usa-header--basic usa-header--megamenu">
      <div className="usa-nav-container">
        <div className="usa-navbar">
          <div className="usa-logo" id="basic-mega-logo">
            <em className="usa-logo__text">
              <a href="/" title="Home" aria-label="Home">
                FedRAMP Validations
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
              <a className="usa-nav__link" href="#/">
                <span>Welcome</span>
              </a>
            </li>
            <li className="usa-nav__primary-item">
              <a className="usa-nav__link" href="#/validator">
                <span>SSP Validator</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  );
};
