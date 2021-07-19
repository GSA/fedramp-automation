import type { SchematronValidator } from '../use-cases/schematron';

type ValidateSSPUseCaseContext = {
  generateSchematronValidationReport: SchematronValidator;
};

export const ValidateSSPUseCase =
  (ctx: ValidateSSPUseCaseContext) => (oscalXmlString: string) => {
    return ctx.generateSchematronValidationReport(oscalXmlString);
  };
export type ValidateSSPUseCase = ReturnType<typeof ValidateSSPUseCase>;

type ValidateSSPUrlUseCaseContext = {
  generateSchematronValidationReport: SchematronValidator;
  fetch: typeof fetch;
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
      .then(ctx.generateSchematronValidationReport)
      .then(validationReport => {
        return {
          validationReport,
          xmlText,
        };
      });
  };
export type ValidateSSPUrlUseCase = ReturnType<typeof ValidateSSPUrlUseCase>;
