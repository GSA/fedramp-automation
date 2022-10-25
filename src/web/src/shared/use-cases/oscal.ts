import { parse as parseYaml } from 'yaml';

import { getDocumentTypeForRootNode, OscalDocumentKey } from '../domain/oscal';
import type {
  SchematronJSONToXMLProcessors,
  SchematronProcessor,
  SchematronResult,
  ValidationReport,
} from '../domain/schematron';

type Fetch = typeof fetch;

export class OscalService {
  constructor(
    private jsonOscalToXmlProcessors: SchematronJSONToXMLProcessors,
    private schematronProcessor: SchematronProcessor,
    private fetch: Fetch,
    private console: Console,
    private readStringFile?: (fileName: string) => Promise<string>,
  ) {}

  async validateOscalFile(oscalFilePath: string) {
    if (!this.readStringFile) {
      throw new Error('readStringFile not provided');
    }
    const xmlString = await this.readStringFile(oscalFilePath);
    const result = await this.validateOscal(xmlString);
    this.console.log(
      `Found ${result.validationReport.failedAsserts.length} assertions in ${result.documentType}`,
    );
  }

  validateOscal(oscalString: string): Promise<{
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

  validateOscalByUrl(fileUrl: string) {
    return this.fetch(fileUrl)
      .then(response => response.text())
      .then(value => this.validateOscal(value));
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
    const detected = detectFormat(oscalString);

    if (detected.format === 'yaml') {
      const jsonString = JSON.stringify(parseYaml(oscalString));
      const documentType = getDocumentTypeForRootNode(detected.type || '');
      if (documentType === null) {
        return oscalString;
      }
      return this.jsonOscalToXmlProcessors[documentType](jsonString);
    }

    if (detected.format === 'json') {
      const documentType = getDocumentTypeForRootNode(detected.type || '');
      if (documentType === null) {
        return oscalString;
      }
      return this.jsonOscalToXmlProcessors[documentType](oscalString);
    }

    return oscalString;
  }
}

const detectFormat = (document: string) => {
  // Naive detection of JSON format - first non-whitespace character should be
  // `{`, and we will extract the opening tag name to detect the document type.
  const jsonMatch = document.match(/^\s*\{\s*"(.+)"/);
  if (jsonMatch !== null) {
    return {
      format: 'json',
      type: jsonMatch[1],
    };
  }

  const yamlMatch = document.match(/^---\s*(.+):/);
  if (yamlMatch !== null) {
    return {
      format: 'yaml',
      type: yamlMatch[1],
    };
  }

  return {
    format: 'xml',
  };
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
