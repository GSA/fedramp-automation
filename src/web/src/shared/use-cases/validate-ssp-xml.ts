import type {
  SchematronJSONToXMLProcessor,
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';

export const ValidateSSPUseCase =
  (ctx: {
    jsonSspToXml: SchematronJSONToXMLProcessor;
    processSchematron: SchematronProcessor;
  }) =>
  (oscalString: string) => {
    return (() => {
      // Convert JSON to XML, if necessary.
      if (detectFormat(oscalString) === 'json') {
        return ctx.jsonSspToXml(oscalString);
      } else {
        return Promise.resolve(oscalString);
      }
    })()
      .then(ctx.processSchematron)
      .then(generateSchematronReport);
  };
export type ValidateSSPUseCase = ReturnType<typeof ValidateSSPUseCase>;

export const ValidateSSPUrlUseCase =
  (ctx: {
    jsonSspToXml: SchematronJSONToXMLProcessor;
    processSchematron: SchematronProcessor;
    fetch: typeof fetch;
  }) =>
  (fileUrl: string) => {
    let xmlText: string;

    return ctx
      .fetch(fileUrl)
      .then(response => response.text())
      .then(text => {
        // Convert JSON to XML, if necessary.
        if (detectFormat(text) === 'json') {
          return ctx.jsonSspToXml(text);
        } else {
          return Promise.resolve(text);
        }
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

const detectFormat = (document: string) => {
  // Naive detection of JSON format - first non-whitespace character should be
  // `{` or `[`.
  if (/^\s*[\{\[]/.test(document)) {
    return 'json';
  } else {
    return 'xml';
  }
};
