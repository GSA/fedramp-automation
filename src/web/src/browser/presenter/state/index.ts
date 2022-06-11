import { derived } from 'overmind';
import {
  AssertionDocumentationMachine,
  createAssertionDocumentationMachine,
} from './assertion-documetation';
import { createMetricsMachine, MetricsMachine } from './metrics';
import { createRouterMachine, RouterMachine } from './router-machine';
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
  assertionDocumentation: AssertionDocumentationMachine;
  baseUrl: `${string}/`;
  metrics: MetricsMachine;
  router: RouterMachine;
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
  assertionDocumentation: createAssertionDocumentationMachine(),
  baseUrl: '/',
  metrics: createMetricsMachine(),
  oscalDocuments: {
    poam: createSchematronMachine(),
    sap: createSchematronMachine(),
    sar: createSchematronMachine(),
    ssp: createSchematronMachine(),
  },
  router: createRouterMachine(),
  sourceRepository: {
    sampleDocuments: [],
  },
  validator: createValidatorMachine(),
};
