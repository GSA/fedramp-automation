import type { OscalService } from '@asap/shared/use-cases/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';
import { mock } from 'jest-mock-extended';
import { CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const mockXml = '<xml></xml>';
    const ctx = {
      readStringFile: jest.fn().mockReturnValue(Promise.resolve(mockXml)),
      writeStringFile: jest.fn().mockReturnValue(Promise.resolve()),
      useCases: {
        parseSchematron: jest.fn(),
        oscalService: mock<OscalService>({
          validateXmlOrJson: jest.fn((xmlString: string) =>
            Promise.resolve({
              documentType: 'ssp',
              validationReport: {
                title: 'test report',
                failedAsserts: [],
              },
              xmlString,
            }),
          ),
        }),
        writeAssertionViews: jest.fn(),
        writeXSpecScenarioSummaries: jest.fn(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parse(['ts-node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.readStringFile).toHaveBeenCalledWith('ssp.xml');
    expect(ctx.useCases.oscalService.validateXmlOrJson).toHaveBeenCalledWith(
      mockXml,
    );
  });
});
