/**
 * Define the core Schematron types used in the application.
 */

export type ValidationAssert = {
  uniqueId: string;
  id: string;
  location: string;
  role?: string;
  see?: string;
  test: string;
  text: string;
};
export type ValidationReport = {
  failedAsserts: ValidationAssert[];
};

export type SchematronValidator = (
  oscalXmlString: string,
) => Promise<ValidationReport>;

export type SchematronAssert = {
  id: string;
  message: string;
  isReport: boolean;
  role: string;
};

export type ParseSchematronAssertions = (
  schematron: string,
) => SchematronAssert[];
export type GetSSPSchematronAssertions = () => Promise<SchematronAssert[]>;
