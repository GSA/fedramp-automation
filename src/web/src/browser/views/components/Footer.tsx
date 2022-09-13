import logoImg from 'uswds/img/logo-img.png';
import mailIcon from '../images/footer-mail-icon.svg';
import twitterIcon from '../images/FedRAMP_twitter.svg';
import youTubeIcon from '../images/FedRAMP-youtube.svg';

import { useAppContext } from '../context';
import { Identifier } from './Identifier';
export const Footer = () => {
  const { sourceRepository } = useAppContext().state.config;
  return (
    <>
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
                    <a
                      className="usa-footer__primary-link"
                      href={sourceRepository.treeUrl}
                    >
                      Source code
                    </a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>
        </div>
        <div className="usa-footer__secondary-section bg-theme-deep-blue text-white">
          <div className="grid-container">
            <div className="grid-row grid-gap-2">
              <div className="tablet:grid-col-3 border-primary border-right-1px">
                <p>
                  The Federal Risk and Authorization Management Program
                  (FedRAMP®) is managed by the FedRAMP Program Management
                  Office.
                </p>
                <p>
                  The FedRAMP name and the FedRAMP logo are the property of the
                  General Services Administration (GSA) and may not be used
                  without GSA’s express, written permission. For more
                  information, please see the{' '}
                  <a
                    className="text-theme-light-blue text-underline"
                    href="https://www.fedramp.gov/assets/resources/documents/FedRAMP_Branding_Guidance.pdf"
                  >
                    FedRAMP Brand Guide
                  </a>
                  .
                </p>
              </div>
              <div className="tablet:grid-col-3 tablet:padding-left-4 border-primary border-right-1px">
                <h2 className="text-theme-light-blue text-bold text-uppercase font-sans-md desktop:font-sans-lg">
                  Connect With Us
                </h2>
                <p>Please reach out to FedRAMP with any questions.</p>
                <address className="margin-top-3">
                  <a
                    className="text-theme-light-blue text-underline"
                    href="mailto:info@FedRAMP.gov"
                    target="_blank"
                  >
                    <img
                      className="footer-mail-icon margin-right-1 vertical-align-middle"
                      src={mailIcon}
                      alt="mail to fedramp"
                    />
                    info@FedRAMP.gov
                  </a>
                </address>
              </div>
              <div className="tablet:grid-col-3 desktop:grid-col-2 tablet:padding-left-4 border-primary border-right-1px margin-top-2 tablet:margin-top-0">
                <h2 className="text-theme-light-blue text-bold text-uppercase font-sans-md desktop:font-sans-lg">
                  Follow us
                </h2>
                <address>
                  <div>
                    <a
                      className="text-theme-light-blue text-underline"
                      target="_blank"
                      href="https://twitter.com/fedramp?lang=en"
                    >
                      <img
                        src={twitterIcon}
                        alt="twitter icon"
                        className="margin-right-2 vertical-align-middle"
                      />
                      Twitter
                    </a>
                  </div>
                  <div className="margin-top-2">
                    <a
                      className="text-theme-light-blue text-underline margin-top-2"
                      target="_blank"
                      href="https://www.youtube.com/c/FedRAMP?lang=en"
                    >
                      <img
                        src={youTubeIcon}
                        alt="YouTube icon"
                        className="margin-right-2 vertical-align-middle"
                      />
                      YouTube
                    </a>
                  </div>
                </address>
              </div>
              <div className="tablet:grid-col-3 tablet:padding-left-4 border-primary margin-top-2 tablet:margin-top-0">
                <h2 className="text-theme-light-blue text-bold text-uppercase font-sans-md desktop:font-sans-lg">
                  Keep Up To Date
                </h2>
                <p>
                  To receive news and updates, join the GSA’s subscriber list.
                </p>
                <a
                  className="usa-button usa-button--outline text-theme-light-blue text-bold text-uppercase radius-pill"
                  href="https://public.govdelivery.com/accounts/USGSA/subscriber/new"
                  target="_blank"
                >
                  Subscribe
                </a>
              </div>
            </div>
          </div>
        </div>
      </footer>
      <Identifier />
    </>
  );
};
