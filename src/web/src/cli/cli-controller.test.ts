import { CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', () => {
    const mockXml = '<xml></xml>';
    const ctx = {
      readStringFile: jest.fn().mockReturnValue(mockXml),
      writeStringFile: jest.fn(),
      parseSchematron: jest.fn(),
      validateSSP: jest.fn().mockReturnValue(
        Promise.resolve({
          failedAsserts: [],
        }),
      ),
    };
    const cli = CommandLineController(ctx);
    cli.parse(['ts-node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.readStringFile).toHaveBeenCalledWith('ssp.xml');
    expect(ctx.validateSSP).toHaveBeenCalledWith(mockXml);
  });
});
