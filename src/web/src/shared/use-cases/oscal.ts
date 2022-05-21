import type { string } from 'fp-ts';
import type { OscalDocumentKey } from '../domain/oscal';
import type {
  SchematronJSONToXMLProcessor,
  SchematronProcessor,
} from './schematron';

export class OscalService {
  constructor(
    private jsonOscalToXml: SchematronJSONToXMLProcessor, //private processSchematron: SchematronProcessor,
  ) {}

  async initDocument(oscalString: string): Promise<{
    documentType: OscalDocumentKey;
    xmlString: string;
  }> {
    const xmlString = await this.ensureXml(oscalString);
    return {
      documentType: 'ssp',
      xmlString,
    };
  }

  private ensureXml(oscalString: string) {
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
