import React from 'react';

import { useAppState } from '../hooks';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';

export const ValidatorPage = () => {
  const { schematron } = useAppState();

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
      <div className="grid-row grid-gap margin-2">
        <div className="mobile:grid-col-12 tablet:grid-col-4">
          <div className="position-sticky top-0 z-top bg-white padding-top-1 padding-bottom-1">
            <ValidatorResultsFilterForm />
          </div>
        </div>
        <div className="mobile:grid-col-12 tablet:grid-col-8">
          <ValidatorReport />
          {schematron.validator.current === 'PROCESSING' && (
            <div className="loader" />
          )}
        </div>
      </div>
    </>
  );
};
