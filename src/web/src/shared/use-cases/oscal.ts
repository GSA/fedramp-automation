import type { OscalDocumentKey } from '../domain/oscal';
import type {
  SchematronJSONToXMLProcessor,
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from './schematron';

type OscalDocument = {
  documentType: OscalDocumentKey;
  xmlString: string;
};

type Fetch = typeof fetch;

export class OscalService {
  constructor(
    private jsonOscalToXml: SchematronJSONToXMLProcessor,
    private schematronProcessor: SchematronProcessor,
    private fetch: Fetch,
  ) {}

  initDocument(oscalString: string): Promise<string> {
    return this.ensureXml(oscalString).then(xmlString => {
      return xmlString;
    });
  }

  initDocumentByUrl(fileUrl: string): Promise<string> {
    return this.fetch(fileUrl)
      .then(response => response.text())
      .then(value => this.initDocument(value));
  }

  validateOscal(xmlString: string): Promise<{
    documentType: OscalDocumentKey;
    validationReport: ValidationReport;
  }> {
    return this.schematronProcessor(xmlString).then(
      ({ documentType, validationReport }) => {
        return {
          documentType,
          validationReport: generateSchematronReport(validationReport),
        };
      },
    );
  }

  async ensureXml(oscalString: string): Promise<string> {
    // Convert JSON to XML, if necessary.
    if (detectFormat(oscalString) === 'json') {
      return this.jsonOscalToXml(oscalString);
    } else {
      return Promise.resolve(oscalString);
    }
  }
}

const detectFormat = (document: string) => {
  // Naive detection of JSON format - first non-whitespace character should be
  // `{` or `[`.
  if (/^\s*[\{\[]/.test(document)) {
    return 'json';
  } else {
    return 'xml';
  }
};

const generateSchematronReport = (
  schematronResult: SchematronResult,
): ValidationReport => {
  return {
    title:
      schematronResult.successfulReports
        .filter(report => report.id === 'info-system-name')
        .map(report => report.text)[0] || '<Unspecified system name>',
    failedAsserts: schematronResult.failedAsserts,
  };
};
