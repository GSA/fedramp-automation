import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import partnersCloudSvg from '../images/partners-cloud.svg';
import partnersAssessorsSvg from '../images/partners-assessors.svg';
import partnersAgenciesSvg from '../images/bldg.svg';
import whyIllustration from '../images/partners_fed-agencies.png';
import '../styles/HomePage.scss';
import asapMovie from '../images/asap-540-2.mp4';

import { useAppContext } from '../context';

const ProcessList = () => (
  <section className="bg-gray-10 padding-y-10">
    <div className="grid-container">
      <h2 className="text-theme-dark-blue font-sans-xl text-light margin-top-0">
        How does it work?
      </h2>
      <div className="grid-row">
        <div className="desktop:grid-col-6">
          <ol className="usa-process-list">
            <li className="usa-process-list__item padding-bottom-4">
              <h4 className="usa-process-list__heading line-height-sans-1">
                Submit with confidence
              </h4>
              <p className="margin-top-1 text-light">
                Creation of compliant FedRAMP OSCAL System Security Plans is
                enhanced with timely and context-sensitive validation errors.
              </p>
            </li>
            <li className="usa-process-list__item padding-bottom-4">
              <h4 className="usa-process-list__heading line-height-sans-1">
                Streamlined FedRAMP Review
              </h4>
              <p className="margin-top-1 text-light">
                High-quality submissions lead to efficient FedRAMP audit
                reviews. Additionally, FedRAMP Audit Review Team efforts are
                further streamlined by a friendly presentation of complex
                business rule validations.
              </p>
            </li>
            <li className="usa-process-list__item">
              <h4 className="usa-process-list__heading line-height-sans-1">
                Lower-cost agency ATO
              </h4>
              <p className="margin-top-1 text-light">
                FedRAMP-approved Cloud Service Providers (CSPs) with structured
                OSCAL System Security Plans are more cost-effective for agencies
                to evaluate as part of their own Approval To Operate (ATO)
                process.
              </p>
            </li>
          </ol>
        </div>
        <div className="desktop:grid-col-6">
          <div className="add-aspect-16x9 shadow-4">
            <video
              className="radius-lg"
              controls
              width="100%"
              src={asapMovie}
              autoPlay
              loop
            />
          </div>
        </div>
      </div>
    </div>
  </section>
);

const PartiesGrid = () => (
  <section className="padding-y-10">
    <div className="grid-container">
      <h2 className="text-center text-theme-dark-blue text-uppercase font-sans-xl margin-top-0">
        Who uses ASAP?
      </h2>
      <div className="grid-row">
        <div className="tablet:grid-col-6 desktop:grid-col-4 display-flex flex-align-start">
          <img
            className="margin-right-4 width-9 tablet:width-10"
            src={partnersCloudSvg}
            alt="partners in the cloud"
          />
          <div>
            <h3 className="text-theme-red margin-0">Cloud Service Providers</h3>
            <p>
              Submit your FedRAMP-compliant OSCAL System Security Plan with
              confidence.
            </p>
          </div>
        </div>
        <div className="tablet:grid-col-6 desktop:grid-col-4 display-flex flex-align-start">
          <img
            className="margin-right-4 width-9 tablet:width-10"
            src={partnersAssessorsSvg}
            alt="partner assessors"
          />
          <div>
            <h3 className="text-theme-red margin-0">FedRAMP Reviewers</h3>
            <p>Evaluate CSP submissions with an efficient workflow.</p>
            <a
              className="text-primary text-underline"
              href={getUrl(Routes.developers)}
            >
              Learn more
            </a>
          </div>
        </div>
        <div className="tablet:grid-col-6 desktop:grid-col-4 display-flex flex-align-start">
          <img
            className="margin-right-4 width-9 tablet:width-10"
            src={partnersAgenciesSvg}
            alt="partner agencies"
          />
          <div>
            <h3 className="text-theme-red margin-0">Federal Agencies</h3>
            <p>
              Evaluate FedRAMP-approved cloud service providers with the aid of
              structured OSCAL documentation.
            </p>
          </div>
        </div>
      </div>
    </div>
  </section>
);

const HeroSection = () => {
  const { state } = useAppContext();
  return (
    <section className="bg-theme-light-cyan text-white padding-y-10 hero-unit">
      <div className="grid-container">
        <div className="grid-row grid-gap">
          <div className="desktop:grid-col-8">
            <h1 className="text-light font-sans-3xl text-uppercase margin-0">
              Accelerate <span className="text-bold">Approvals</span>
            </h1>
            <div className="grid-row grid-gap">
              <div className="tablet:grid-col-6">
                <p className="font-sans-lg">
                  Welcome to Automated Security Authorization Processing (ASAP),
                  the FedRAMP audit validation tool. Project funded by{' '}
                  <a
                    className="text-white text-underline"
                    href="https://10x.gsa.gov/"
                  >
                    10x.
                  </a>
                </p>
                <a
                  className="usa-button usa-button--big margin-top-2 bg-theme-deep-blue radius-pill padding-x-6"
                  href={getUrl(Routes.documentSummary)}
                >
                  Try It Now
                </a>
              </div>
              <div className="tablet:grid-col-6 padding-left-2">
                <p>ASAP is comprised of the following components:</p>
                <p>
                  <a
                    className="text-white text-underline"
                    href="https://pages.nist.gov/OSCAL/"
                  >
                    Open Security Controls Assessment Language (OSCAL)
                  </a>{' '}
                  validation rules written in{' '}
                  <a
                    className="text-white text-underline"
                    href="https://schematron.com/"
                  >
                    Schematron
                  </a>{' '}
                  format. A{' '}
                  <a
                    className="text-white text-underline"
                    href={`${state.config.baseUrl}rules/rules.html`}
                  >
                    rules summary
                  </a>{' '}
                  is available.
                </p>
                <p>
                  This user interface, which applies validations to a FedRAMP
                  OSCAL System Security Plan and display validation errors
                  in-browser.
                </p>
                <p>
                  Compiled Schematron rules (XSLT), which may be integrated with
                  third-party OSCAL creation/validation tools. Read our{' '}
                  <a
                    className="text-white text-underline"
                    href={getUrl(Routes.developers)}
                  >
                    developer documentation
                  </a>{' '}
                  for more information.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

const WhySection = () => {
  const { newIssueUrl } = useAppContext().state.config.sourceRepository;
  return (
    <section className="padding-y-10">
      <div className="grid-container">
        <div className="grid-row grid-gap">
          <div className="desktop:grid-col-6">
            <img
              src={whyIllustration}
              alt="pillars with folders, cart, zoom window, and envelope"
            />
          </div>
          <div className="desktop:grid-col-6">
            <h2 className="text-theme-dark-blue font-sans-xl text-light margin-y-0">
              Why should I care?
            </h2>
            <p>
              FedRAMP audit approvals are expensive for both FedRAMP and CSPs
              (Cloud Service Providers). The ASAP validation tool helps CSPs
              craft correct System Security Plans, and helps the FedRAMP Audit
              Review Team evaluate them efficiently.
            </p>
            <h2 className="text-theme-dark-blue font-sans-xl text-light margin-y-0">
              Contact us
            </h2>
            <p>
              Your feedback is important to us. Please send us any problems or
              feature requests to our team to help make ASAP better for
              everyone.
            </p>
            <a
              className="usa-button radius-pill bg-theme-deep-blue margin-top-1 text-uppercase"
              href={newIssueUrl}
            >
              Provide Feedback
            </a>
          </div>
        </div>
      </div>
    </section>
  );
};
export const HomePage = () => (
  <div className="usa-prose">
    <HeroSection />
    <PartiesGrid />
    <ProcessList />
    <WhySection />
  </div>
);
