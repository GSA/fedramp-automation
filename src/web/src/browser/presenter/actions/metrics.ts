import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';
import * as metrics from '../state/metrics';

export const initialize = async ({
  actions,
  effects,
  state,
}: PresenterConfig) => {
  const optInStatus = await effects.useCases.appMetrics.getOptInStatus();
  if (optInStatus && state.metrics.current === 'OPT_OUT') {
    state.metrics = metrics.nextState(state.metrics, { type: 'TOGGLE' });
  }
  actions.metrics.logAppInitialization();
};

export const logAppInitialization = ({ effects, state }: PresenterConfig) => {
  effects.useCases.appMetrics.log({
    eventType: 'app-loaded',
    userAlias: undefined,
    data: {
      route: state.router.currentRoute.type,
    },
  });
};

export const logValidationSummary = (
  { effects, state }: PresenterConfig,
  documentType: OscalDocumentKey,
) => {
  if (state.validator.current === 'VALIDATED') {
    effects.useCases.appMetrics.log({
      eventType: 'validation-summary',
      userAlias: undefined,
      data: {
        failedAsserts: state.oscalDocuments[documentType].failedAssertionCounts,
      },
    });
  }
};

export const setOptInStatusOn = ({ effects, state }: PresenterConfig) => {
  if (state.metrics.current === 'OPT_OUT') {
    state.metrics = metrics.nextState(state.metrics, { type: 'TOGGLE' });
    effects.useCases.appMetrics.setOptInStatus(true);
  }
};

export const setOptInStatusOff = ({ effects, state }: PresenterConfig) => {
  if (state.metrics.current === 'OPT_IN') {
    state.metrics = metrics.nextState(state.metrics, { type: 'TOGGLE' });
    effects.useCases.appMetrics.setOptInStatus(false);
  }
};
