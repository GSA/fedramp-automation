import type { PassStatus, Role } from '../lib/schematron';
import type { PresenterConfig } from '..';
import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

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

export const setValidationReport = async (
  { effects, state }: PresenterConfig,
  {
    documentType,
    validationReport,
    xmlString,
  }: {
    documentType: OscalDocumentKey;
    validationReport: ValidationReport;
    xmlString: string;
  },
) => {
  const annotatedXML = await effects.useCases.annotateXML({
    xmlString,
    annotations: validationReport.failedAsserts.map(assert => {
      return {
        uniqueId: assert.uniqueId,
        xpath: assert.location,
      };
    }),
  });
  state.schematron[documentType].send('SET_VALIDATION_REPORT', {
    annotatedXML,
    validationReport,
  });
};

export const setFilterRole = (
  { state }: PresenterConfig,
  { documentType, role }: { documentType: OscalDocumentKey; role: Role },
) => {
  state.schematron[documentType].send('FILTER_ROLE_CHANGED', { role });
};

export const setFilterText = (
  { state }: PresenterConfig,
  { documentType, text }: { documentType: OscalDocumentKey; text: string },
) => {
  state.schematron[documentType].send('FILTER_TEXT_CHANGED', { text });
};

export const setFilterAssertionView = (
  { state }: PresenterConfig,
  {
    documentType,
    assertionViewId,
  }: { documentType: OscalDocumentKey; assertionViewId: number },
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
  }: { documentType: OscalDocumentKey; passStatus: PassStatus },
) => {
  state.schematron[documentType].send('FILTER_PASS_STATUS_CHANGED', {
    passStatus,
  });
};
