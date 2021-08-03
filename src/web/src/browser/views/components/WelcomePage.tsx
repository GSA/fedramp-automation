import React from 'react';

export const WelcomePage = () => {
  return (
    <div className="usa-prose">
      <h1>FedRAMP ASAP</h1>
      <p>
        Welcome to ASAP, the upcoming FedRAMP audit validation tool. ASAP is
        made up of the following components:
      </p>
      <ul>
        <li>
          <a href="https://pages.nist.gov/OSCAL/">OSCAL</a> validation rules
          written in Schematron format
        </li>
        <li>
          This user interface, which will apply validations to a FedRAMP OSCAL
          System Security Plan and display validation errors in-browser.
        </li>
        <li>
          Compiled Schematron rules (XSLT), which may be integrated with
          third-party OSCAL creation/validation tools.
        </li>
      </ul>
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
        <li>In addition to SSP, support for POAM, SAP, and SAR validations</li>
      </ul>
      <h2>Contact us</h2>
      <p>
        Please give us your feedback via a{' '}
        <a href="https://github.com/18F/fedramp-automation/issues">
          Github issue
        </a>
        .
      </p>
    </div>
  );
};
