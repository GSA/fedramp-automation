import { it, describe, expect, vi } from 'vitest';

import { OscalService } from './oscal';

const MOCK_SCHEMATRON_RESULT = {
  failedAsserts: ['assertion 1', 'assertion 2'],
  svrlString: '<svrl />',
  successfulReports: [{ id: 'info-system-name', text: 'title text' }],
};
const EXPECTED_VALIDATION_REPORT = {
  title: 'title text',
  failedAsserts: ['assertion 1', 'assertion 2'],
};

describe('validate ssp use case', () => {
  const mockXml = '<xml>xml {[]} input</xml>';
  it('returns schematron for xml input', async () => {
    const ctx = {
      jsonOscalToXml: vi.fn().mockReturnValue(Promise.resolve('')),
      processSchematron: vi.fn().mockReturnValue(
        Promise.resolve({
          documentType: 'ssp',
          schematronResult: MOCK_SCHEMATRON_RESULT,
        }),
      ),
      fetch: vi.fn(),
    };
    const oscalService = new OscalService(
      ctx.jsonOscalToXml,
      ctx.processSchematron,
      ctx.fetch,
    );
    const retVal = await oscalService.validateXml(mockXml);
    expect(retVal).toEqual({
      documentType: 'ssp',
      svrlString: '<svrl />',
      validationReport: EXPECTED_VALIDATION_REPORT,
    });
  });

  it('returns schematron for json input', async () => {
    const testJson = async (mockJson: string) => {
      const ctx = {
        jsonOscalToXml: vi.fn().mockReturnValue(Promise.resolve(mockXml)),
        processSchematron: vi.fn().mockReturnValue(
          Promise.resolve({
            documentType: 'ssp',
            schematronResult: MOCK_SCHEMATRON_RESULT,
          }),
        ),
        fetch: vi.fn(),
      };
      const oscalService = new OscalService(
        ctx.jsonOscalToXml,
        ctx.processSchematron,
        ctx.fetch,
      );
      const retVal = await oscalService.validateXmlOrJson(mockJson);
      expect(ctx.jsonOscalToXml).toHaveBeenCalledWith(mockJson);
      expect(ctx.processSchematron).toHaveBeenCalledWith(mockXml);
      expect(retVal).toEqual({
        documentType: 'ssp',
        svrlString: '<svrl />',
        validationReport: EXPECTED_VALIDATION_REPORT,
        xmlString: mockXml,
      });
    };

    testJson('{}');
    testJson('[]');
  });
});

describe('validate ssp url use case', () => {
  it('passes through return value from adapter', async () => {
    const xmlString = '<xml>ignored</xml>';
    const ctx = {
      fetch: vi.fn().mockImplementation((url: string) => {
        return Promise.resolve({
          text: vi.fn().mockImplementation(async () => {
            expect(url).toEqual('https://sample.gov/ssp-url.xml');
            return xmlString;
          }),
        });
      }),
      jsonOscalToXml: vi.fn().mockReturnValue(xmlString),
      processSchematron: vi.fn().mockImplementation(xmlStr => {
        expect(xmlStr).toEqual(xmlString);
        return Promise.resolve({
          documentType: 'ssp',
          schematronResult: MOCK_SCHEMATRON_RESULT,
        });
      }),
    };
    const oscalService = new OscalService(
      ctx.jsonOscalToXml,
      ctx.processSchematron,
      ctx.fetch,
    );
    const retVal = await oscalService.validateXmlOrJsonByUrl(
      'https://sample.gov/ssp-url.xml',
    );
    expect(retVal).toEqual({
      documentType: 'ssp',
      svrlString: '<svrl />',
      validationReport: EXPECTED_VALIDATION_REPORT,
      xmlString,
    });
  });
});
