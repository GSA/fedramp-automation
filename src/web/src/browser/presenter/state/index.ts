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

export type SampleSSP = {
  url: string;
  displayName: string;
};

export type State = {
  assertionDocumentation: AssertionDocumentationMachine;
  baseUrl: string;
  metrics: MetricsMachine;
  router: RouterMachine;
  schematron: {
    poam: SchematronMachine;
    sap: SchematronMachine;
    sar: SchematronMachine;
    ssp: SchematronMachine;
  };
  sourceRepository: {
    treeUrl?: string;
    sampleSSPs: SampleSSP[];
    developerExampleUrl?: string;
  };
};

export const state: State = {
  assertionDocumentation: createAssertionDocumentationMachine(),
  baseUrl: '',
  metrics: createMetricsMachine(),
  router: createRouterMachine(),
  schematron: {
    poam: createSchematronMachine(),
    sap: createSchematronMachine(),
    sar: createSchematronMachine(),
    ssp: createSchematronMachine(),
  },
  sourceRepository: {
    sampleSSPs: [],
  },
};
