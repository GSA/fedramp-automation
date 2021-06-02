export type ValidationAssert = {
  id: string;
  location: string;
  role: string;
  see: string;
  test: string;
  text: string;
};
export type ValidationReport = {
  failedAsserts: ValidationAssert[];
};

export type SchematronValidationReportGateway = (
  oscalXmlString: string,
) => Promise<ValidationReport>;

type ValidateSchematronUseCaseContext = {
  generateSchematronValidationReport: SchematronValidationReportGateway;
};

export const ValidateSchematronUseCase =
  (ctx: ValidateSchematronUseCaseContext) => (oscalXmlString: string) => {
    return ctx.generateSchematronValidationReport(oscalXmlString);
  };
export type ValidateSchematronUseCase = ReturnType<
  typeof ValidateSchematronUseCase
>;
