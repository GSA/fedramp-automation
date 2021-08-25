import React from 'react';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import { useActions } from '../hooks';

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
  const { getAssetUrl } = useActions();
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
              src={getAssetUrl('partners-cloud.svg')}
              alt=""
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
            src={getAssetUrl('partners-assessors.svg')}
            alt=""
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
            src={getAssetUrl('partners-agencies.svg')}
            alt=""
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

export const HomePage = () => {
  return (
    <div className="usa-prose padding-top-3">
      <h1>Accelerate approvals</h1>
      <p>
        Welcome to Automated Security Authorization Processing (ASAP), the
        upcoming FedRAMP audit validation tool. Funded by{' '}
        <a href="https://10x.gsa.gov/">10x</a>, ASAP is comprised of the
        following components:
      </p>
      <ul>
        <li>
          <a href="https://pages.nist.gov/OSCAL/">
            Open Security Controls Assessment Language (OSCAL)
          </a>{' '}
          validation rules written in{' '}
          <a href="https://schematron.com/">Schematron</a> format
        </li>
        <li>
          This user interface, which will apply validations to a FedRAMP OSCAL
          System Security Plan and display validation errors in-browser.{' '}
          <a href={getUrl(Routes.validator)}>Try it out</a>.
        </li>
        <li>
          Compiled Schematron rules (XSLT), which may be integrated with
          third-party OSCAL creation/validation tools. Read our{' '}
          <a href={getUrl(Routes.developers)}>developer documentation</a> for
          more information.
        </li>
      </ul>
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
