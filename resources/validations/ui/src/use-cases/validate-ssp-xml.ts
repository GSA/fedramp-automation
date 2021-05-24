// temp, just export saxon-js code
export { transform } from '../adapters/saxon-js';

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

export type ValidateSspXml = (xmlContents: string) => Promise<ValidationReport>;
