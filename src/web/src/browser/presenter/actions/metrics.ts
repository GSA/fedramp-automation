import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { PresenterConfig } from '..';

export const initialize = async ({
  actions,
  effects,
  state,
}: PresenterConfig) => {
  const optInStatus = await effects.useCases.appMetrics.getOptInStatus();
  if (
    optInStatus &&
    state.newAppContext.state.metrics.current === 'METRICS_OPT_OUT'
  ) {
    state.newAppContext.dispatch({ type: 'METRICS_TOGGLE' });
  }
  actions.metrics.logAppInitialization();
};

export const logAppInitialization = ({ effects, state }: PresenterConfig) => {
  effects.useCases.appMetrics.log({
    eventType: 'app-loaded',
    userAlias: undefined,
    data: {
      route: state.newAppContext.state.router.currentRoute.type,
    },
  });
};

export const logValidationSummary = (
  { effects, state }: PresenterConfig,
  documentType: OscalDocumentKey,
) => {
  if (state.newAppContext.state.validator.current === 'VALIDATED') {
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
  if (state.newAppContext.state.metrics.current === 'METRICS_OPT_OUT') {
    state.newAppContext.dispatch({ type: 'METRICS_TOGGLE' });
    effects.useCases.appMetrics.setOptInStatus(true);
  }
};

export const setOptInStatusOff = ({ effects, state }: PresenterConfig) => {
  if (state.newAppContext.state.metrics.current === 'METRICS_OPT_IN') {
    state.newAppContext.dispatch({ type: 'METRICS_TOGGLE' });
    effects.useCases.appMetrics.setOptInStatus(false);
  }
};
