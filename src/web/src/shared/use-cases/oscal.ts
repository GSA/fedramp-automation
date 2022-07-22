import type { OscalDocumentKey } from '../domain/oscal';
import type {
  SchematronJSONToXMLProcessor,
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from './schematron';

type Fetch = typeof fetch;

export class OscalService {
  constructor(
    private jsonOscalToXml: SchematronJSONToXMLProcessor,
    private schematronProcessor: SchematronProcessor,
    private fetch: Fetch,
  ) {}

  validateXmlOrJson(oscalString: string): Promise<{
    documentType: OscalDocumentKey;
    svrlString: string;
    validationReport: ValidationReport;
    xmlString: string;
  }> {
    let xmlString = '';
    return this.ensureXml(oscalString)
      .then(str => {
        xmlString = str;
        return this.validateXml(xmlString);
      })
      .then(result => {
        return {
          ...result,
          xmlString,
        };
      });
  }

  validateXmlOrJsonByUrl(fileUrl: string) {
    return this.fetch(fileUrl)
      .then(response => response.text())
      .then(value => this.validateXmlOrJson(value));
  }

  validateXml(xmlString: string): Promise<{
    documentType: OscalDocumentKey;
    svrlString: string;
    validationReport: ValidationReport;
  }> {
    return this.schematronProcessor(xmlString).then(result => {
      return {
        documentType: result.documentType,
        svrlString: result.schematronResult.svrlString,
        validationReport: generateValidationReport(result.schematronResult),
      };
    });
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

const generateValidationReport = (
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
