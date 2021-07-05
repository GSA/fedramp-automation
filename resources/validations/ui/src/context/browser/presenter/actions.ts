import type { PresenterConfig } from '.';
import type { Route } from './router';

export const onInitializeOvermind =
  () =>
  ({ actions, effects, state }: PresenterConfig) => {
    //state.currentRoute = effects.location.getUrl()
  };

export const setCurrentRoute = (
  { state }: PresenterConfig,
  location: Route,
) => {
  state.currentRoute = location;
};

export const getAssetUrl = ({ state }: PresenterConfig, assetPath: string) => {
  return `${state.baseUrl}/${assetPath}`;
};
