import type {
  SchematronJSONToXMLProcessor,
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
  jsonSspToXml: SchematronJSONToXMLProcessor;
  processSchematron: SchematronProcessor;
  fetch: typeof fetch;
};

const generateSchematronReport = (
  schematronResult: SchematronResult,
): ValidationReport => {
  return {
    title:
      schematronResult.successfulReports
        .filter(report => report.id === 'info-system-name')
        .map(report => report.text)[0] || '<Unspecified system name>',
    failedAsserts: schematronResult.failedAsserts,
  };
};

export const ValidateSSPUrlUseCase =
  (ctx: ValidateSSPUrlUseCaseContext) => (fileUrl: string) => {
    let xmlText: string;
    return (() => {
      if (fileUrl.endsWith('.json')) {
        return ctx.jsonSspToXml(fileUrl);
      } else {
        return ctx.fetch(fileUrl).then(response => response.text());
      }
    })()
      .then(text => {
        xmlText = text;
        return xmlText;
      })
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
