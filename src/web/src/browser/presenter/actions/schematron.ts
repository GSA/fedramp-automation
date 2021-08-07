import type { SchematronAssert } from '@asap/shared/use-cases/schematron';

import type { Role } from '../state/schematron-machine';
import type { PresenterConfig } from '..';

export const setFilterRole = ({ state }: PresenterConfig, role: Role) => {
  state.schematron.send('FILTER_ROLE_CHANGED', { role });
};

export const setFilterText = ({ state }: PresenterConfig, text: string) => {
  state.schematron.send('FILTER_TEXT_CHANGED', { text });
};

export const setFilterAssertionView = (
  { state }: PresenterConfig,
  assertionViewId: number,
) => {
  state.schematron.send('FILTER_ASSERTION_VIEW_CHANGED', { assertionViewId });
};
