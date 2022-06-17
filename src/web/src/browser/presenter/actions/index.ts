export * as assertionDocumentation from './assertion-documentation';
import * as assertionDocumentation from './assertion-documentation';
export * as documentViewer from './document-viewer';
export * as metrics from './metrics';
export * as schematron from './schematron';
export * as validator from './validator';

import { AppContextType } from '@asap/browser/views/context';
import type { NewPresenterConfig, PresenterConfig } from '..';
import * as router from '../state/router';

export const onInitializeOvermind = async ({
  actions,
  effects,
}: PresenterConfig) => {
  actions.setCurrentRoute(effects.location.getCurrent());
  effects.location.listen((url: string) => {
    actions.setCurrentRoute(url);
  });
  actions.schematron.initialize();
  await actions.metrics.initialize();
};

export const initializeApplication = (config: NewPresenterConfig) => {
  assertionDocumentation.initialize(config);
};

export const setCurrentRoute = (
  { effects, state }: PresenterConfig,
  url: string,
) => {
  const route = router.getRoute(url);
  if (route.type !== 'NotFound') {
    state.newAppContext.dispatch({
      type: 'ROUTE_CHANGED',
      data: { route },
    });
    effects.location.replace(router.getUrl(route));
  }
};

export const getAssetUrl = ({ state }: PresenterConfig, assetPath: string) => {
  return `${state.baseUrl}${assetPath}`;
};

export const setNewAppContext = (
  { state }: PresenterConfig,
  newAppContext: AppContextType,
) => {
  state.newAppContext = newAppContext;
};
