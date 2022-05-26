import { OscalService } from './oscal';

const MOCK_SCHEMATRON_RESULT = {
  failedAsserts: ['assertion 1', 'assertion 2'],
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
      jsonOscalToXml: jest.fn().mockReturnValue(Promise.resolve('')),
      processSchematron: jest.fn().mockReturnValue(
        Promise.resolve({
          documentType: 'ssp',
          validationReport: MOCK_SCHEMATRON_RESULT,
        }),
      ),
      fetch: jest.fn(),
    };
    const oscalService = new OscalService(
      ctx.jsonOscalToXml,
      ctx.processSchematron,
      ctx.fetch,
    );
    const retVal = await oscalService.validateXml(mockXml);
    expect(retVal).toEqual({
      documentType: 'ssp',
      validationReport: EXPECTED_VALIDATION_REPORT,
    });
  });

  it('returns schematron for json input', async () => {
    const testJson = async (mockJson: string) => {
      const ctx = {
        jsonOscalToXml: jest.fn().mockReturnValue(Promise.resolve(mockXml)),
        processSchematron: jest.fn().mockReturnValue(
          Promise.resolve({
            documentType: 'ssp',
            validationReport: MOCK_SCHEMATRON_RESULT,
          }),
        ),
        fetch: jest.fn(),
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
      fetch: jest.fn().mockImplementation((url: string) => {
        return Promise.resolve({
          text: jest.fn().mockImplementation(async () => {
            expect(url).toEqual('https://sample.gov/ssp-url.xml');
            return xmlString;
          }),
        });
      }),
      jsonOscalToXml: jest.fn().mockReturnValue(xmlString),
      processSchematron: jest.fn().mockImplementation(xmlStr => {
        expect(xmlStr).toEqual(xmlString);
        return Promise.resolve({
          documentType: 'ssp',
          validationReport: MOCK_SCHEMATRON_RESULT,
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
      validationReport: EXPECTED_VALIDATION_REPORT,
      xmlString,
    });
  });
});
