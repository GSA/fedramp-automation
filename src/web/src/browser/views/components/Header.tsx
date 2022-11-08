import classnames from 'classnames';
import closeSvg from 'uswds/img/usa-icons/close.svg';
import logo from '../images/logo.svg';

import { getUrl, Routes, isRulesetRoute } from '@asap/browser/presenter/state/router';
import { useAppContext } from '../context';
import { SCHEMATRON_RULESETS } from '@asap/shared/domain/schematron';

export const Header = () => {
  const { currentRoute } = useAppContext().state.router;
  const { newIssueUrl } = useAppContext().state.config.sourceRepository;

  return (
    <header className="usa-header usa-header--basic usa-header--megamenu">
      <div className="usa-nav-container">
        <div className="usa-navbar width-auto">
          <div className="usa-logo margin-0" id="basic-mega-logo">
            <a
              className="display-flex flex-align-center"
              href={getUrl(Routes.home)}
              title="Home"
              aria-label="Home"
            >
              <img
                src={logo}
                alt="FedRamp logo"
                className="width-4 tablet:width-5 desktop:width-9"
              />
              <em className="usa-logo__text margin-left-2">
                Automated Security Authorization Processing
              </em>
            </a>
          </div>
          <button className="usa-menu-btn">Menu</button>
        </div>
        <nav aria-label="Primary navigation" className="usa-nav">
          <button className="usa-nav__close">
            <img src={closeSvg} role="img" alt="close" />
          </button>
          <ul className="usa-nav__primary usa-accordion">
            <li className="usa-nav__primary-item">
              <a
                className={classnames('usa-nav__link', {
                  'usa-current': currentRoute.type === Routes.home.type,
                })}
                href={getUrl(Routes.home)}
              >
                <span>Home</span>
              </a>
            </li>
            <li className="usa-nav__primary-item">
              <button
                className={classnames(
                  'usa-accordion__button',
                  'usa-nav__link',
                  {
                    'usa-current': isRulesetRoute(currentRoute),
                  },
                )}
                aria-expanded="false"
                aria-controls="document-rules"
              >
                <span>Document Rules</span>
              </button>
              <ul id="document-rules" className="usa-nav__submenu">
                <li className="usa-nav__submenu-item">
                  <a href={getUrl(Routes.documentSummary("rev4"))}>{SCHEMATRON_RULESETS['rev4'].title}</a>
                </li>
                <li className="usa-nav__submenu-item">
                  <a href={getUrl(Routes.documentSummary("rev5"))}>{SCHEMATRON_RULESETS['rev5'].title}</a>
                </li>
              </ul>
            </li>
            <li className="usa-nav__primary-item">
              <a
                className={classnames('usa-nav__link', {
                  'usa-current': currentRoute.type === Routes.developers.type,
                })}
                href={getUrl(Routes.developers)}
              >
                <span>Developers</span>
              </a>
            </li>
            <li className="usa-nav__primary-item">
              <a
                className="usa-button bg-transparent border-1px radius-pill nav-btn margin-top-1 desktop:margin-top-0"
                href={newIssueUrl}
              >
                <span>Provide Feedback</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </header>
  );
};
