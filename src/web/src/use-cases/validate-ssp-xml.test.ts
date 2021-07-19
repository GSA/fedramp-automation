import { ValidateSSPUseCase, ValidateSSPUrlUseCase } from './validate-ssp-xml';

describe('validate ssp use case', () => {
  it('passes through return value from adapter', () => {
    const useCase = ValidateSSPUseCase({
      generateSchematronValidationReport: jest
        .fn()
        .mockReturnValue('return value'),
    });
    const retVal = useCase('<xml>ignored</xml>');
    expect(retVal).toEqual('return value');
  });
});

describe('validate ssp url use case', () => {
  it('passes through return value from adapter', async () => {
    const xmlText = '<xml>ignored</xml>';
    const validationReport = 'mock validation report';
    const useCase = ValidateSSPUrlUseCase({
      fetch: jest.fn().mockImplementation((url: string) => {
        return Promise.resolve({
          text: jest.fn().mockImplementation(async () => {
            expect(url).toEqual('https://sample.gov/ssp-url.xml');
            return xmlText;
          }),
        });
      }),
      generateSchematronValidationReport: jest
        .fn()
        .mockImplementation(xmlStr => {
          expect(xmlStr).toEqual(xmlText);
          return validationReport;
        }),
    });
    const retVal = await useCase('https://sample.gov/ssp-url.xml');
    expect(retVal).toEqual({ validationReport, xmlText });
  });
});
