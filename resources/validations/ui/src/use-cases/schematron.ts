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

// For convenience, this type is mirroring the `Schema` class defined in the
// `node-schematron` library.
export type Schematron = {
  title: string | null;
  defaultPhase: string | null;
  variables: {
    name: string;
    value: string;
  }[];
  phases: {
    id: string;
    active: string[];
    variables: {
      name: string;
      value: string;
    }[];
  }[];
  patterns: {
    id: string | null;
    rules: {
      context: string;
      variables: {
        name: string;
        value: string;
      }[];
      asserts: {
        id: string | null;
        test: string;
        message: (
          | string
          | {
              $type: string;
              select: string;
            }
        )[];
        isReport: boolean;
      }[];
    }[];
    variables: {
      name: string;
      value: string;
    }[];
  }[];
  namespaces: {
    prefix: string;
    uri: string;
  }[];
};

export const EMPTY_SCHEMATRON: Schematron = {
  defaultPhase: null,
  title: '',
  variables: [],
  phases: [],
  patterns: [],
  namespaces: [],
};

export type ParseSchematronUseCase = (schematron: string) => Schematron;
export type GetSSPSchematronUseCase = () => Promise<Schematron>;
