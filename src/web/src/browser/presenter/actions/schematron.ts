import type { PassStatus, Role } from '../lib/schematron';
import type { PresenterConfig } from '..';

export const initialize = ({ effects, state }: PresenterConfig) => {
  Promise.all([
    effects.useCases.getAssertionViews(),
    effects.useCases.getSchematronAssertions(),
  ]).then(([assertionViews, schematronAsserts]) => {
    state.schematron.poam.send('CONFIG_LOADED', {
      config: {
        assertionViews: assertionViews.poam,
        schematronAsserts: schematronAsserts.poam,
      },
    });
    state.schematron.sap.send('CONFIG_LOADED', {
      config: {
        assertionViews: assertionViews.sap,
        schematronAsserts: schematronAsserts.sap,
      },
    });
    state.schematron.sar.send('CONFIG_LOADED', {
      config: {
        assertionViews: assertionViews.sar,
        schematronAsserts: schematronAsserts.sar,
      },
    });
    state.schematron.ssp.send('CONFIG_LOADED', {
      config: {
        assertionViews: assertionViews.ssp,
        schematronAsserts: schematronAsserts.ssp,
      },
    });
  });
};

export const setFilterRole = ({ state }: PresenterConfig, role: Role) => {
  state.schematron.ssp.send('FILTER_ROLE_CHANGED', { role });
};

export const setFilterText = ({ state }: PresenterConfig, text: string) => {
  state.schematron.ssp.send('FILTER_TEXT_CHANGED', { text });
};

export const setFilterAssertionView = (
  { state }: PresenterConfig,
  assertionViewId: number,
) => {
  state.schematron.ssp.send('FILTER_ASSERTION_VIEW_CHANGED', {
    assertionViewId,
  });
};

export const setPassStatus = (
  { state }: PresenterConfig,
  passStatus: PassStatus,
) => {
  state.schematron.ssp.send('FILTER_PASS_STATUS_CHANGED', { passStatus });
};
