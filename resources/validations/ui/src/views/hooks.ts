import {
  createHook,
  createStateHook,
  createActionsHook,
  createEffectsHook,
  createReactionHook,
} from 'overmind-react';

import type { ConfigType } from '../presenter';

export const usePresenter = createHook();
export const useState = createStateHook<ConfigType>();
export const useActions = createActionsHook<ConfigType>();
export const useEffects = createEffectsHook<ConfigType>();
export const useReaction = createReactionHook<ConfigType>();
