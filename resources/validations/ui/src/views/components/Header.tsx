import React from 'react';
import logo from './logo.svg';

/*return (
<div>
    <header>
    <img src={logo} alt="logo" />
    </header>
</div>
);*/

export const Header = () => {
  return (
    <header className="usa-header usa-header--basic usa-header--megamenu">
      <div className="usa-nav-container">
        <div className="usa-navbar">
          <div className="usa-logo" id="basic-mega-logo">
            <em className="usa-logo__text">
              <a href="/" title="Home" aria-label="Home">
                FedRAMP Validation Suite
              </a>
            </em>
          </div>
          <button className="usa-menu-btn">Menu</button>
        </div>
        <nav aria-label="Primary navigation" className="usa-nav">
          <button className="usa-nav__close">
            <img src="/uswds/img/usa-icons/close.svg" role="img" alt="close" />
          </button>
          <ul className="usa-nav__primary usa-accordion">
            <li className="usa-nav__primary-item">
              <a className="usa-nav__link" href="#">
                <span>SSP</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  );
};
