import type { SchematronValidator } from './schematron';

type ValidateSchematronUseCaseContext = {
  generateSchematronValidationReport: SchematronValidator;
};

export const ValidateSchematronUseCase =
  (ctx: ValidateSchematronUseCaseContext) => (oscalXmlString: string) => {
    return ctx.generateSchematronValidationReport(oscalXmlString);
  };
export type ValidateSchematronUseCase = ReturnType<
  typeof ValidateSchematronUseCase
>;
