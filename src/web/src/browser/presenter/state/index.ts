import { NewAppContext } from '@asap/browser/views/context';
import * as assertionDocumentation from './assertion-documetation';
import * as metrics from './metrics';
import * as routerMachine from './router-machine';
import {
  createSchematronMachine,
  SchematronMachine,
} from './schematron-machine';
import * as validatorMachine from './validator-machine';

export type NewState = {
  assertionDocumentation: assertionDocumentation.State;
  metrics: metrics.State;
};

export type NewEvent = assertionDocumentation.Event | metrics.Event;

export const initialState: NewState = {
  assertionDocumentation: assertionDocumentation.initialState,
  metrics: metrics.initialState,
};

export const rootReducer = (state: NewState, event: NewEvent) => ({
  assertionDocumentation: assertionDocumentation.nextState(
    state.assertionDocumentation,
    <assertionDocumentation.Event>event,
  ),
  metrics: metrics.nextState(state.metrics, <metrics.Event>event),
});

export type SampleDocument = {
  url: string;
  displayName: string;
};

export type State = {
  newAppContext: NewAppContext;
  baseUrl: `${string}/`;
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
  validator: validatorMachine.State;
};

export const state: State = {
  newAppContext: { state: initialState, dispatch: () => {} },
  baseUrl: '/',
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
  validator: validatorMachine.createValidatorMachine(),
};
