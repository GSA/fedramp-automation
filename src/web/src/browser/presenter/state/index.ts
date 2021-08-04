import {
  createSchematronMachine,
  SchematronMachine,
} from './schematron-machine';
import { createRouterMachine, RouterMachine } from './router-machine';

export type SampleSSP = {
  url: string;
  displayName: string;
};

export type State = {
  baseUrl: string;
  sourceRepository: {
    treeUrl?: string;
    sampleSSPs: SampleSSP[];
    developerExampleUrl?: string;
  };
  router: RouterMachine;
  schematron: SchematronMachine;
};

export const state: State = {
  baseUrl: '',
  router: createRouterMachine(),
  sourceRepository: {
    sampleSSPs: [],
  },
  schematron: createSchematronMachine(),
};
