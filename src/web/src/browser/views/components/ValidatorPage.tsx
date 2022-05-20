import React from 'react';

import type { Presenter } from '@asap/browser/presenter';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';

type Props = {
  documentType: keyof Presenter['state']['schematron'];
};

const DocumentValidator = ({ documentType }: Props) => (
  <>
    <h1>{documentType.toUpperCase()}</h1>
    <div className="grid-row grid-gap">
      <div className="mobile:grid-col-12 tablet:grid-col-4">
        <div className="position-sticky top-0bg-white padding-top-4">
          <ValidatorResultsFilterForm documentType={documentType} />
        </div>
      </div>
      <div className="mobile:grid-col-12 tablet:grid-col-8">
        <ValidatorReport documentType={documentType} />
      </div>
    </div>
  </>
);

export const ValidatorPage = () => {
  return (
    <>
      <div className="grid-row">
        <h1>FedRAMP OSCAL SSP Validator</h1>
        <div className="mobile:grid-col-12">
          You may use this tool to browse FedRAMP OSCAL SSP validation rules and
          validation results.
        </div>
      </div>
      <div className="grid-row grid-gap">
        <div className="tablet:grid-col-12">
          <h1>Choose an XML file to process</h1>
        </div>
        <ValidatorFileSelectForm />
      </div>
      <DocumentValidator documentType="ssp" />
      <DocumentValidator documentType="sap" />
      <DocumentValidator documentType="sar" />
      <DocumentValidator documentType="poam" />
    </>
  );
};
