import { ValidateSSPUseCase, ValidateSSPUrlUseCase } from './validate-ssp-xml';

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
      jsonSspToXml: jest.fn().mockReturnValue(Promise.resolve('')),
      processSchematron: jest
        .fn()
        .mockReturnValue(Promise.resolve(MOCK_SCHEMATRON_RESULT)),
    };
    const useCase = ValidateSSPUseCase(ctx);
    const retVal = await useCase(mockXml);
    expect(ctx.processSchematron).toHaveBeenCalledWith(mockXml);
    expect(retVal).toEqual(EXPECTED_VALIDATION_REPORT);
  });

  it('returns schematron for json input', async () => {
    const testJson = async (mockJson: string) => {
      const ctx = {
        jsonSspToXml: jest.fn().mockReturnValue(Promise.resolve(mockXml)),
        processSchematron: jest
          .fn()
          .mockReturnValue(Promise.resolve(MOCK_SCHEMATRON_RESULT)),
      };
      const useCase = ValidateSSPUseCase(ctx);
      const retVal = await useCase(mockJson);
      expect(ctx.jsonSspToXml).toHaveBeenCalledWith(mockJson);
      expect(ctx.processSchematron).toHaveBeenCalledWith(mockXml);
      expect(retVal).toEqual(EXPECTED_VALIDATION_REPORT);
    };

    testJson('{}');
    testJson('[]');
  });
});

describe('validate ssp url use case', () => {
  it('passes through return value from adapter', async () => {
    const xmlText = '<xml>ignored</xml>';
    const useCase = ValidateSSPUrlUseCase({
      fetch: jest.fn().mockImplementation((url: string) => {
        return Promise.resolve({
          text: jest.fn().mockImplementation(async () => {
            expect(url).toEqual('https://sample.gov/ssp-url.xml');
            return xmlText;
          }),
        });
      }),
      jsonSspToXml: jest.fn().mockReturnValue(xmlText),
      processSchematron: jest.fn().mockImplementation(xmlStr => {
        expect(xmlStr).toEqual(xmlText);
        return MOCK_SCHEMATRON_RESULT;
      }),
    });
    const retVal = await useCase('https://sample.gov/ssp-url.xml');
    expect(retVal).toEqual({
      validationReport: EXPECTED_VALIDATION_REPORT,
      xmlText,
    });
  });
});
