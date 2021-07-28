import type { SchematronAssert } from '@asap/shared/use-cases/schematron';

import type { Role } from '../state/schematron-machine';
import type { PresenterConfig } from '..';

export const setFilterRole = ({ state }: PresenterConfig, role: Role) => {
  state.schematron.send('FILTER_ROLE_CHANGED', { role });
};

export const setFilterText = ({ state }: PresenterConfig, text: string) => {
  state.schematron.send('FILTER_TEXT_CHANGED', { text });
};

export const setAssertions = (
  { state }: PresenterConfig,
  schematronAsserts: SchematronAssert[],
) => {
  state.schematron.send('ASSERTIONS_FOUND', { schematronAsserts });
};
