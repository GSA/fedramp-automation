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
  baseUrl: string;
  metrics: MetricsMachine;
  router: RouterMachine;
  schematron: SchematronMachine;
  sourceRepository: {
    treeUrl?: string;
    sampleSSPs: SampleSSP[];
    developerExampleUrl?: string;
  };
};

export const state: State = {
  baseUrl: '',
  metrics: createMetricsMachine(),
  router: createRouterMachine(),
  schematron: createSchematronMachine(),
  sourceRepository: {
    sampleSSPs: [],
  },
};
