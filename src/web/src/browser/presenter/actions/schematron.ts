import type { Role } from '../machines/schematron';
import type { PresenterConfig } from '..';

export const setFilterRole = ({ state }: PresenterConfig, filterRole: Role) => {
  state.schematron.filter.role = filterRole;
};

export const setFilterText = (
  { state }: PresenterConfig,
  filterText: string,
) => {
  state.schematron.filter.text = filterText;
};
