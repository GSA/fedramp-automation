import { it, describe, expect, vi } from 'vitest';
import { mock } from 'vitest-mock-extended';

import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';
import { CommandLineContext, CommandLineController } from './cli-controller';
import { XSpecScenarioSummaryGenerator } from '@asap/shared/use-cases/xspec-summary';
import { AssertionViewGenerator } from '@asap/shared/use-cases/assertion-views';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const mockXml = '<xml></xml>';
    const ctx: CommandLineContext = {
      console: mock<Console>({
        log: vi.fn(),
      }),
      useCases: {
        assertionViewGenerator: mock<AssertionViewGenerator>(),
        oscalService: mock<OscalService>({
          validateXmlOrJson: (xmlString: string) =>
            Promise.resolve({
              documentType: 'ssp',
              svrlString: '<svrl />',
              validationReport: {
                title: 'test report',
                failedAsserts: [],
              },
              xmlString,
            }),
        }),
        schematronSummary: mock<SchematronSummary>(),
        xSpecScenarioSummaryGenerator: mock<XSpecScenarioSummaryGenerator>(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parseAsync(['node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.console.log).toHaveBeenCalledWith('Found 0 assertions in ssp');
  });
});
