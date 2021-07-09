import { derived } from 'overmind';

import { EMPTY_SCHEMATRON, Schematron } from '../../../use-cases/schematron';
import { createReportMachine, ReportMachine } from './machines/report';
import * as router from './router';

export type SampleSSP = {
  url: string;
  displayName: string;
};

export type State = {
  baseUrl: string;
  breadcrumbs: { text: string; selected: boolean; url: string }[];
  currentRoute: router.Route;
  report: ReportMachine;
  repositoryUrl?: string;
  sampleSSPs: SampleSSP[];
  sspSchematron: Schematron;
};

export const state: State = {
  baseUrl: '',
  breadcrumbs: derived((state: State) =>
    router.breadcrumbs[state.currentRoute.type](state.currentRoute),
  ),
  currentRoute: router.Routes.home,
  report: createReportMachine(),
  sampleSSPs: [],
  sspSchematron: EMPTY_SCHEMATRON,
};
