import { getDocumentTypeForRootNode, OscalDocumentKey } from '../domain/oscal';
import type {
  SchematronJSONToXMLProcessors,
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from './schematron';

type Fetch = typeof fetch;

export class OscalService {
  constructor(
    private jsonOscalToXmlProcessors: SchematronJSONToXMLProcessors,
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
    const detected = detectFormat(oscalString);
    if (detected.format === 'json') {
      const documentType = getDocumentTypeForRootNode(detected.type || '');
      console.log('documentType', detected.type, documentType);
      if (documentType === null) {
        return oscalString;
      }
      return this.jsonOscalToXmlProcessors[documentType](oscalString);
    } else {
      return oscalString;
    }
  }
}

const detectFormat = (document: string) => {
  // Naive detection of JSON format - first non-whitespace character should be
  // `{`, and we will extract the opening tag name to detect the document type.
  const match = document.match(/^\s*\{\s*"(.+)"/);
  if (match === null) {
    return {
      format: 'xml',
    };
  } else {
    return {
      format: 'json',
      type: match[1],
    };
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
