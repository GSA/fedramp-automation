import React from 'react';
import { useActions, useState } from '../hooks';

export const Footer = () => {
  const { getAssetUrl } = useActions();
  const { repositoryUrl } = useState();
  return (
    <footer className="usa-footer usa-footer--slim">
      <div className="grid-container usa-footer__return-to-top">
        <a href="#">Return to top</a>
      </div>
      <div className="usa-footer__primary-section">
        <div className="usa-footer__primary-container grid-row">
          <div className="mobile-lg:grid-col-12">
            <nav className="usa-footer__nav" aria-label="Footer navigation,">
              <ul className="grid-row grid-gap">
                <li className="mobile-lg:grid-col-4 desktop:grid-col-auto usa-footer__primary-content">
                  <a
                    className="usa-footer__primary-link"
                    href="https://www.fedramp.gov/"
                  >
                    FedRAMP
                  </a>
                </li>
                <li className="mobile-lg:grid-col-4 desktop:grid-col-auto usa-footer__primary-content">
                  <a
                    className="usa-footer__primary-link"
                    href="https://10x.gsa.gov/"
                  >
                    10x
                  </a>
                </li>
                <li className="mobile-lg:grid-col-4 desktop:grid-col-auto usa-footer__primary-content">
                  <a className="usa-footer__primary-link" href={repositoryUrl}>
                    Source code
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>
      </div>
      <div className="usa-footer__secondary-section">
        <div className="grid-container">
          <div className="usa-footer__logo grid-row grid-gap-2">
            <div className="grid-col-auto">
              <img
                className="usa-footer__logo-img"
                src={getAssetUrl('uswds/img/logo-img.png')}
                alt=""
              />
            </div>
            <div className="grid-col-auto">
              <p className="usa-footer__logo-heading">
                General Services Administration
              </p>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};
