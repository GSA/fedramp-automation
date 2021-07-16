import type { Action } from 'overmind';

export const getAssetUrl: Action<string, string> = ({ state }, assetPath) => {
  return `${state.baseUrl}/${assetPath}`;
};
