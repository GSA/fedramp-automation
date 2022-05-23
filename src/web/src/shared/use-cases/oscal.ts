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
    private schematronProcessors: {
      poam: SchematronProcessor;
      sap: SchematronProcessor;
      sar: SchematronProcessor;
      ssp: SchematronProcessor;
    },
    private fetch: Fetch,
  ) {}

  initDocument(oscalString: string): Promise<OscalDocument> {
    return this.ensureXml(oscalString).then(xmlString => {
      return {
        documentType: getOscalDocumentTypeFromXml(xmlString),
        xmlString,
      };
    });
  }

  initDocumentByUrl(fileUrl: string): Promise<OscalDocument> {
    return this.fetch(fileUrl)
      .then(response => response.text())
      .then(value => this.initDocument(value));
  }

  validateOscal({
    documentType,
    xmlString,
  }: OscalDocument): Promise<ValidationReport> {
    const processSchematron = this.schematronProcessors[documentType];
    return processSchematron(xmlString).then(generateSchematronReport);
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

export const getOscalDocumentTypeFromXml = (
  oscalXml: string,
): OscalDocumentKey => {
  return 'ssp';
};
