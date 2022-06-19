import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ActionContext } from '..';

export const initialize = async (config: ActionContext) => {
  const optInStatus = await config.effects.useCases.appMetrics.getOptInStatus();
  if (optInStatus && config.getState().metrics.current === 'METRICS_OPT_OUT') {
    config.dispatch({
      machine: 'metrics',
      type: 'METRICS_TOGGLE',
    });
  }
  logAppInitialization(config);
};

export const logAppInitialization = ({ effects, getState }: ActionContext) => {
  effects.useCases.appMetrics.log({
    eventType: 'app-loaded',
    userAlias: undefined,
    data: {
      route: getState().router.currentRoute.type,
    },
  });
};

export const logValidationSummary =
  (documentType: OscalDocumentKey) =>
  ({ effects, getState }: ActionContext) => {
    if (getState().validator.current === 'VALIDATED') {
      effects.useCases.appMetrics.log({
        eventType: 'validation-summary',
        userAlias: undefined,
        data: {
          failedAsserts: 0, // TODO: getState().oscalDocuments[documentType].failedAssertionCounts,
        },
      });
    }
  };

export const setOptInStatusOn = ({
  dispatch,
  effects,
  getState,
}: ActionContext) => {
  if (getState().metrics.current === 'METRICS_OPT_OUT') {
    dispatch({
      machine: 'metrics',
      type: 'METRICS_TOGGLE',
    });
    effects.useCases.appMetrics.setOptInStatus(true);
  }
};

export const setOptInStatusOff = ({
  dispatch,
  effects,
  getState,
}: ActionContext) => {
  if (getState().metrics.current === 'METRICS_OPT_IN') {
    dispatch({
      machine: 'metrics',
      type: 'METRICS_TOGGLE',
    });
    effects.useCases.appMetrics.setOptInStatus(false);
  }
};
