import type { PassStatus, Role } from '../lib/schematron';
import type { Presenter, PresenterConfig } from '..';

type SchematronDoc = keyof Presenter['state']['schematron'];

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

export const setFilterRole = (
  { state }: PresenterConfig,
  { documentType, role }: { documentType: SchematronDoc; role: Role },
) => {
  state.schematron[documentType].send('FILTER_ROLE_CHANGED', { role });
};

export const setFilterText = (
  { state }: PresenterConfig,
  { documentType, text }: { documentType: SchematronDoc; text: string },
) => {
  state.schematron[documentType].send('FILTER_TEXT_CHANGED', { text });
};

export const setFilterAssertionView = (
  { state }: PresenterConfig,
  {
    documentType,
    assertionViewId,
  }: { documentType: SchematronDoc; assertionViewId: number },
) => {
  state.schematron[documentType].send('FILTER_ASSERTION_VIEW_CHANGED', {
    assertionViewId,
  });
};

export const setPassStatus = (
  { state }: PresenterConfig,
  {
    documentType,
    passStatus,
  }: { documentType: SchematronDoc; passStatus: PassStatus },
) => {
  state.schematron[documentType].send('FILTER_PASS_STATUS_CHANGED', {
    passStatus,
  });
};
