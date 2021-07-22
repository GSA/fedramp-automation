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
  repositoryUrl?: string;
  router: RouterMachine;
  sampleSSPs: SampleSSP[];
  schematron: SchematronMachine;
};

export const state: State = {
  baseUrl: '',
  router: createRouterMachine(),
  sampleSSPs: [],
  schematron: createSchematronMachine(),
};
