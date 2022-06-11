import { it, describe, expect, vi } from 'vitest';

import type { OscalService } from '@asap/shared/use-cases/oscal';
import { mock } from 'vitest-mock-extended';
import { CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const mockXml = '<xml></xml>';
    const ctx = {
      console: {
        log: vi.fn(),
      } as any as Console,
      readStringFile: vi.fn().mockReturnValue(Promise.resolve(mockXml)),
      writeStringFile: vi.fn().mockReturnValue(Promise.resolve()),
      useCases: {
        parseSchematron: vi.fn(),
        oscalService: mock<OscalService>({
          validateXmlOrJson: (xmlString: string) =>
            Promise.resolve({
              documentType: 'ssp',
              validationReport: {
                title: 'test report',
                failedAsserts: [],
              },
              xmlString,
            }),
        }),
        writeAssertionViews: vi.fn(),
        writeXSpecScenarioSummaries: vi.fn(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parseAsync(['node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.readStringFile).toHaveBeenCalledWith('ssp.xml');
    expect(ctx.console.log).toHaveBeenCalledWith('Found 0 assertions in ssp');
  });
});
