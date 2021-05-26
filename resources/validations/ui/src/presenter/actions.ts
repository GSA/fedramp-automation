import type { Action } from 'overmind';

export const setBaseUrl: Action<string> = ({ state }, baseUrl) => {
  state.baseUrl = baseUrl;
};

export const getAssetUrl: Action<string, string> = ({ state }, assetPath) => {
  return `${state.baseUrl}${assetPath}`;
};
