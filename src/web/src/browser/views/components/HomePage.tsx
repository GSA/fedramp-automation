import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import partnersCloudSvg from '../images/partners-cloud.svg';
import partnersAssessorsSvg from '../images/partners-assessors.svg';
import partnersAgenciesSvg from '../images/partners-agencies.svg';
import '../styles/HomePage.scss';

import { useAppContext } from '../context';

const ProcessList = () => (
  <>
    <h2>How does it work?</h2>
    <ol className="usa-process-list">
      <li className="usa-process-list__item padding-bottom-4">
        <h4 className="usa-process-list__heading line-height-sans-1">
          Submit with confidence
        </h4>
        <p className="margin-top-1 text-light">
          Creation of compliant FedRAMP OSCAL System Security Plans is enhanced
          with timely and context-sensitive validation errors.
        </p>
      </li>
      <li className="usa-process-list__item padding-bottom-4">
        <h4 className="usa-process-list__heading line-height-sans-1">
          Streamlined FedRAMP Review
        </h4>
        <p className="margin-top-1 text-light">
          High-quality submissions lead to efficient FedRAMP audit reviews.
          Additionally, FedRAMP Audit Review Team efforts are further
          streamlined by a friendly presentation of complex business rule
          validations.
        </p>
      </li>
      <li className="usa-process-list__item">
        <h4 className="usa-process-list__heading line-height-sans-1">
          Lower-cost agency ATO
        </h4>
        <p className="margin-top-1 text-light">
          FedRAMP-approved Cloud Service Providers (CSPs) with structured OSCAL
          System Security Plans are more cost-effective for agencies to evaluate
          as part of their own Approval To Operate (ATO) process.
        </p>
      </li>
    </ol>
  </>
);

const PartiesGrid = () => {
  return (
    <div className="grid-container">
      <div className="grid-row">
        <div className="desktop:grid-col-12">
          <h2 className="text-center">
            Who will use the SSP Validator?
            <br />
            Our stakeholders are:
          </h2>
        </div>
      </div>
      <div className="grid-row">
        <div className="desktop:grid-col-4">
          <div>
            <img
              className="float-left margin-2"
              src={partnersCloudSvg}
              alt="partners in the cloud"
            />
            <h3>Cloud Service Providers</h3>
            <p className="margin-bottom-4">
              Submit your FedRAMP-compliant OSCAL System Security Plan with
              confidence.
            </p>
          </div>
        </div>
        <div className="desktop:grid-col-4">
          <img
            className="float-left margin-2"
            src={partnersAssessorsSvg}
            alt="partner assessors"
          />
          <h3>FedRAMP Reviewers</h3>
          <p className="margin-bottom-4">
            Evaluate CSP submissions with an efficient workflow.{' '}
            <a href={getUrl(Routes.developers)}>Read more...</a>
          </p>
        </div>
        <div className="desktop:grid-col-4">
          <img
            className="float-left margin-2"
            src={partnersAgenciesSvg}
            alt="partner agencies"
          />
          <h3>Federal Agencies</h3>
          <p className="margin-bottom-4">
            Evaluate FedRAMP-approved cloud service providers with the aid of
            structured OSCAL documentation.
          </p>
        </div>
      </div>
    </div>
  );
};

const HeroSection = () => {
  const { state } = useAppContext();
  return (
    <section className="bg-theme-light-cyan text-white padding-y-4 hero-unit">
      <div className="grid-container grid-row grid-gap">
        <div className="desktop:grid-col-8">
          <h1 className="text-light font-sans-3xl text-uppercase margin-0">
            Accelerate <span className="text-bold">Approvals</span>
          </h1>
          <div className="grid-row grid-gap">
            <div className="tablet:grid-col-6">
              <p>
                Welcome to Automated Security Authorization Processing (ASAP),
                the upcoming FedRAMP audit validation tool. Funded by{' '}
                <a
                  className="text-white text-underline"
                  href="https://10x.gsa.gov/"
                >
                  10x
                </a>
                , ASAP is comprised of the following components:
              </p>
              <a className="usa-button" href={getUrl(Routes.documentSummary)}>
                Try it now
              </a>
            </div>
            <div className="tablet:grid-col-6 padding-left-2">
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
                This user interface, which will apply validations to a FedRAMP
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
    </section>
  );
};

export const HomePage = () => {
  // const { state } = useAppContext();
  return (
    <div className="usa-prose">
      <HeroSection />
      <PartiesGrid />
      <ProcessList />
      <h2>Why should I care?</h2>
      <p>
        FedRAMP audit approvals are expensive for both FedRAMP and CSPs (Cloud
        Service Providers). The ASAP validation tool helps CSPs craft correct
        System Security Plans, and helps the FedRAMP Audit Review Team evaluate
        them efficiently.
      </p>
      <h2>What's next?</h2>
      <ul>
        <li>User feedback</li>
        <li>
          In addition to SSP, support for Plan of Actions and Milestones
          (POA&M), Security Assessment Plan (SAP), and Security Assessment
          Report (SAR) validations
        </li>
      </ul>
      <h2>Contact us</h2>
      <p>
        Please give us your feedback via a{' '}
        <a href="https://github.com/GSA/fedramp-automation/issues">
          Github issue
        </a>
        .
      </p>
    </div>
  );
};
