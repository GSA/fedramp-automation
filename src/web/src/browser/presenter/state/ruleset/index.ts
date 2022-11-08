import { SchematronRuleset } from '@asap/shared/domain/schematron';
import * as schematron from './schematron-machine';
import * as validationResults from './validation-results-machine';

export type RulesetState = {
  meta: SchematronRuleset;
  oscalDocuments: {
    poam: schematron.State;
    sap: schematron.State;
    sar: schematron.State;
    ssp: schematron.State;
  };
  validationResults: {
    poam: validationResults.State;
    sap: validationResults.State;
    sar: validationResults.State;
    ssp: validationResults.State;
  };
};
