import {
  createHook,
  createStateHook,
  createActionsHook,
  createEffectsHook,
  createReactionHook,
} from 'overmind-react';

import type { PresenterConfig } from '../presenter';

export const usePresenter = createHook();
export const useState = createStateHook<PresenterConfig>();
export const useActions = createActionsHook<PresenterConfig>();
export const useEffects = createEffectsHook<PresenterConfig>();
export const useReaction = createReactionHook<PresenterConfig>();
