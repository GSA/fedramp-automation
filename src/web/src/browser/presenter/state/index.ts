import * as assertionDocumentation from './assertion-documetation';
import * as metrics from './metrics';
import * as routerMachine from './router-machine';
import {
  createSchematronMachine,
  SchematronMachine,
} from './schematron-machine';
import { createValidatorMachine, ValidatorMachine } from './validator-machine';

export type SampleDocument = {
  url: string;
  displayName: string;
};

export type State = {
  assertionDocumentation: assertionDocumentation.State;
  baseUrl: `${string}/`;
  metrics: metrics.State;
  router: routerMachine.State;
  oscalDocuments: {
    poam: SchematronMachine;
    sap: SchematronMachine;
    sar: SchematronMachine;
    ssp: SchematronMachine;
  };
  sourceRepository: {
    treeUrl?: string;
    sampleDocuments: SampleDocument[];
    developerExampleUrl?: string;
  };
  validator: ValidatorMachine;
};

export const state: State = {
  assertionDocumentation:
    assertionDocumentation.createAssertionDocumentationMachine(),
  baseUrl: '/',
  metrics: metrics.createMetricsMachine(),
  oscalDocuments: {
    poam: createSchematronMachine(),
    sap: createSchematronMachine(),
    sar: createSchematronMachine(),
    ssp: createSchematronMachine(),
  },
  router: routerMachine.createRouterMachine(),
  sourceRepository: {
    sampleDocuments: [],
  },
  validator: createValidatorMachine(),
};
