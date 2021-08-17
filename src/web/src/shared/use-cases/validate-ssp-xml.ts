import type {
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';

type ValidateSSPUseCaseContext = {
  processSchematron: SchematronProcessor;
};

export const ValidateSSPUseCase =
  (ctx: ValidateSSPUseCaseContext) => (oscalXmlString: string) => {
    return ctx.processSchematron(oscalXmlString).then(generateSchematronReport);
  };
export type ValidateSSPUseCase = ReturnType<typeof ValidateSSPUseCase>;

type ValidateSSPUrlUseCaseContext = {
  processSchematron: SchematronProcessor;
  fetch: typeof fetch;
};

const generateSchematronReport = (
  schematronResult: SchematronResult,
): ValidationReport => {
  return {
    title:
      schematronResult.successfulReports
        .filter(report => report.id === 'info-ssp-title')
        .map(report => report.text)[0] || '<Unspecified system name>',
    failedAsserts: schematronResult.failedAsserts,
  };
};

export const ValidateSSPUrlUseCase =
  (ctx: ValidateSSPUrlUseCaseContext) => (xmlUrl: string) => {
    let xmlText: string;
    return ctx
      .fetch(xmlUrl)
      .then(response => response.text())
      .then(text => {
        xmlText = text;
        return xmlText;
      })
      .then(ctx.processSchematron)
      .then(generateSchematronReport)
      .then(validationReport => {
        return {
          validationReport,
          xmlText,
        };
      });
  };
export type ValidateSSPUrlUseCase = ReturnType<typeof ValidateSSPUrlUseCase>;
