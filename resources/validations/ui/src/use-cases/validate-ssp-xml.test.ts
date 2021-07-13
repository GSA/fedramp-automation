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
    const useCase = ValidateSSPUrlUseCase({
      fetch: jest.fn().mockImplementation((url: string) => {
        return Promise.resolve({
          text: jest.fn().mockImplementation(async () => {
            expect(url).toEqual('https://sample.gov/ssp-url.xml');
            return '<xml>ignored</xml>';
          }),
        });
      }),
      generateSchematronValidationReport: jest
        .fn()
        .mockImplementation(xmlStr => {
          expect(xmlStr).toEqual('<xml>ignored</xml>');
          return 'return value';
        }),
    });
    const retVal = await useCase('https://sample.gov/ssp-url.xml');
    expect(retVal).toEqual('return value');
  });
});
