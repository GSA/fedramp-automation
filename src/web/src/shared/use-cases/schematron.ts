/**
 * Define the core Schematron types used in the application.
 */

export type FailedAssert = {
  uniqueId: string;
  id: string;
  location: string;
  role?: string;
  see?: string;
  test: string;
  text: string;
  diagnosticReferences: string[];
};
export type SuccessfulReport = {
  uniqueId: string;
  id: string;
  location: string;
  role?: string;
  test: string;
  text: string;
};
export type SchematronResult = {
  failedAsserts: FailedAssert[];
  successfulReports: SuccessfulReport[];
};
export type ValidationReport = {
  title: string;
  failedAsserts: FailedAssert[];
};

export type SchematronProcessor = (
  oscalXmlString: string,
) => Promise<SchematronResult>;

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
