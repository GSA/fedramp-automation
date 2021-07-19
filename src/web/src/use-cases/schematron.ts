/**
 * Define the core Schematron types used in the application.
 */

export type ValidationAssert = {
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
