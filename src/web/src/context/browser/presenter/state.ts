import { derived } from 'overmind';

import {
  createSchematronMachine,
  SchematronMachine,
} from './machines/schematron';
import * as router from './router';

export type SampleSSP = {
  url: string;
  displayName: string;
};

export type State = {
  baseUrl: string;
  breadcrumbs: { text: string; selected: boolean; url: string }[];
  currentRoute: router.Route;
  repositoryUrl?: string;
  sampleSSPs: SampleSSP[];
  schematron: SchematronMachine;
};

export const state: State = {
  baseUrl: '',
  breadcrumbs: derived((state: State) =>
    router.breadcrumbs[state.currentRoute.type](state.currentRoute),
  ),
  currentRoute: router.Routes.home,
  sampleSSPs: [],
  schematron: createSchematronMachine(),
};
