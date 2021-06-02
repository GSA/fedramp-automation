import { ValidateSchematronUseCase } from './validate-ssp-xml';

describe('validate ssp use case', () => {
  it('passes through return value from adapter', () => {
    const useCase = ValidateSchematronUseCase({
      generateSchematronValidationReport: jest
        .fn()
        .mockReturnValue('return value'),
    });
    const retVal = useCase('<xml>ignored</xml>');
    expect(retVal).toEqual('return value');
  });
});
