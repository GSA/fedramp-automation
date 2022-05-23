import type { string } from 'fp-ts';
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

  async initDocument(oscalString: string): Promise<OscalDocument> {
    const xmlString = await this.ensureXml(oscalString);
    const documentType = getOscalDocumentTypeFromXml(oscalString);
    return {
      documentType,
      xmlString,
    };
  }

  async initDocumentByUrl(fileUrl: string): Promise<OscalDocument> {
    return await this.fetch(fileUrl)
      .then(response => response.text())
      .then(this.initDocument);
  }

  async validateOscal({ documentType, xmlString }: OscalDocument) {
    const processSchematron = this.schematronProcessors[documentType];
    const schematronResult = await processSchematron(xmlString);
    return generateSchematronReport(schematronResult);
  }

  private async ensureXml(oscalString: string) {
    // Convert JSON to XML, if necessary.
    if (detectFormat(oscalString) === 'json') {
      return await this.jsonOscalToXml(oscalString);
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
