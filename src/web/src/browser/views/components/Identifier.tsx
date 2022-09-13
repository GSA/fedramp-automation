import GSAIcon from '../images/gsa-reversed-logo.svg';

export const Identifier = () => (
  <div className="usa-identifier">
    <section
      className="usa-identifier__section usa-identifier__section--masthead"
      aria-label="Agency identifier,"
    >
      <div className="grid-container">
        <div
          className="usa-identifier__identity"
          aria-label="Agency description"
        >
          <div className="display-flex">
            <a href="https://www.gsa.gov/" target="_blank" className="">
              <img
                className="usa-footer-logo-img width-9"
                src={GSAIcon}
                alt="GSA logo"
              />
            </a>
            <div className="margin-left-2">
              <p className="usa-identifier__identity-domain">FedRAMP.gov</p>
              <p className="usa-identifier__identity-disclaimer">
                An official website of the GSA’s{' '}
                <a
                  href="https://www.gsa.gov/about-us/organization/federal-acquisition-service/technology-transformation-services"
                  className="gov-links text-underline"
                >
                  Technology Transformation Services
                </a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
    <div className="grid-container">
      <nav
        className="usa-identifier__section usa-identifier__section--required-links"
        aria-label="Important links,"
      >
        <ul className="usa-identifier__required-links-list">
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/about-us"
              className="usa-identifier__required-link usa-link"
            >
              About GSA
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/website-information/accessibility-aids"
              className="usa-identifier__required-link usa-link"
            >
              Accessibility support
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/reference/freedom-of-information-act-foia"
              className="usa-identifier__required-link usa-link"
            >
              GSA FOIA
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/reference/civil-rights-programs/notification-and-federal-employee-antidiscrimination-and-retaliation-act-of-2002"
              className="usa-identifier__required-link usa-link"
            >
              No FEAR Act data
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsaig.gov/"
              className="usa-identifier__required-link usa-link"
            >
              Office of the Inspector General
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/reference/gsa-plans-and-reports"
              className="usa-identifier__required-link usa-link"
            >
              Performance reports
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/website-information/website-policies"
              className="usa-identifier__required-link usa-link"
            >
              GSA Privacy policy
            </a>
          </li>
          <li className="usa-identifier__required-links-item">
            <a
              href="https://www.gsa.gov/website-information/website-policies"
              className="usa-identifier__required-link usa-link"
            >
              FedRAMP privacy policy
            </a>
          </li>
        </ul>
      </nav>
    </div>
    <section
      className="usa-identifier__section usa-identifier__section--usagov"
      aria-label="U.S. government information and services,"
    >
      <div className="grid-container">
        <div className="usa-identifier__usagov-description">
          Looking for U.S. government information and services?
        </div>
        <a
          href="https://www.usa.gov/"
          className="usa-link gov-links margin-left-1"
        >
          Visit USA.gov
        </a>
      </div>
    </section>
  </div>
);
