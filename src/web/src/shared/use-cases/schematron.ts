/**
 * Define the core Schematron types used in the application.
 */

import type { OscalDocumentKey } from '../domain/oscal';

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

export type SchematronJSONToXMLProcessor = (
  jsonString: string,
) => Promise<string>;

export type SchematronProcessor = (oscalXmlString: string) => Promise<{
  documentType: OscalDocumentKey;
  validationReport: SchematronResult;
}>;

export type SchematronAssert = {
  id: string;
  message: string;
  role: string;
};

export type ParseSchematronAssertions = (
  schematron: string,
) => SchematronAssert[];
export type GetSchematronAssertions = () => Promise<{
  poam: SchematronAssert[];
  sap: SchematronAssert[];
  sar: SchematronAssert[];
  ssp: SchematronAssert[];
}>;
