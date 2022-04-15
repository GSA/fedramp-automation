import type { PresenterConfig } from '..';

export const initialize = async ({
  actions,
  effects,
  state,
}: PresenterConfig) => {
  const optInStatus = await effects.useCases.appMetrics.getOptInStatus();
  if (optInStatus && state.metrics.matches('OPT_OUT')) {
    state.metrics.send('TOGGLE');
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

export const logValidationSummary = ({ effects, state }: PresenterConfig) => {
  if (state.schematron.validator.current === 'VALIDATED') {
    effects.useCases.appMetrics.log({
      eventType: 'validation-summary',
      userAlias: undefined,
      data: {
        failedAsserts: state.schematron.validator.failedAssertionCounts,
      },
    });
  }
};

export const setOptInStatusOn = ({ effects, state }: PresenterConfig) => {
  if (state.metrics.matches('OPT_OUT')) {
    state.metrics.send('TOGGLE');
    effects.useCases.appMetrics.setOptInStatus(true);
  }
};

export const setOptInStatusOff = ({ effects, state }: PresenterConfig) => {
  if (state.metrics.matches('OPT_IN')) {
    state.metrics.send('TOGGLE');
    effects.useCases.appMetrics.setOptInStatus(false);
  }
};
