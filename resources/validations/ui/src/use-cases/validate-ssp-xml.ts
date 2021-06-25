import type { SchematronValidator } from './schematron';

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
    return ctx
      .fetch(xmlUrl)
      .then(response => response.text())
      .then(ctx.generateSchematronValidationReport);
  };
export type ValidateSSPUrlUseCase = ReturnType<typeof ValidateSSPUseCase>;
