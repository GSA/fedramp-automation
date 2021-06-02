import type { Action } from 'overmind';

export const setBaseUrl: Action<string> = ({ state }, baseUrl) => {
  state.baseUrl = baseUrl;
};

export const setRepository: Action<string> = ({ state }, repository) => {
  state.baseUrl = repository;
};

export const getAssetUrl: Action<string, string> = ({ state }, assetPath) => {
  return `${state.baseUrl}/${assetPath}`;
};
