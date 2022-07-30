import { it, describe, expect, vi } from 'vitest';
import { mock } from 'vitest-mock-extended';

import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';
import { CommandLineContext, CommandLineController } from './cli-controller';
import { XSpecScenarioSummaryGenerator } from '@asap/shared/use-cases/xspec-summary';
import { AssertionViewGenerator } from '@asap/shared/use-cases/assertion-views';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const ctx: CommandLineContext = {
      console: mock<Console>(),
      useCases: {
        assertionViewGenerator: mock<AssertionViewGenerator>(),
        oscalService: mock<OscalService>({
          validateXmlOrJsonFile: vi.fn(),
        }),
        schematronSummary: mock<SchematronSummary>(),
        xSpecScenarioSummaryGenerator: mock<XSpecScenarioSummaryGenerator>(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parseAsync(['node', 'index.ts', 'validate', 'ssp.xml']);
    expect(ctx.useCases.oscalService.validateXmlOrJsonFile).toHaveBeenCalled();
  });
});
