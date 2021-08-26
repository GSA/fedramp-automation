import { CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const mockXml = '<xml></xml>';
    const ctx = {
      readStringFile: jest.fn().mockReturnValue(Promise.resolve(mockXml)),
      writeStringFile: jest.fn().mockReturnValue(Promise.resolve()),
      useCases: {
        parseSchematron: jest.fn(),
        validateSSP: jest.fn().mockReturnValue(
          Promise.resolve({
            failedAsserts: [],
          }),
        ),
        writeAssertionViews: jest.fn(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parse(['ts-node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.readStringFile).toHaveBeenCalledWith('ssp.xml');
    expect(ctx.useCases.validateSSP).toHaveBeenCalledWith(mockXml);
  });
});
