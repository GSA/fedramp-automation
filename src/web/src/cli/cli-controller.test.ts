import { it, describe, expect, vi } from 'vitest';
import { mock } from 'vitest-mock-extended';

import { AssertionViewGenerator } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronCompiler } from '@asap/shared/use-cases/schematron-compiler';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';
import { XSpecAssertionSummaryGenerator } from '@asap/shared/use-cases/xspec-summary';

import { CommandLineContext, CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const ctx: CommandLineContext = {
      console: mock<Console>(),
      useCases: {
        assertionViewGenerator: mock<AssertionViewGenerator>(),
        oscalService: mock<OscalService>({
          validateOscalFile: vi.fn(),
        }),
        schematronCompiler: mock<SchematronCompiler>(),
        schematronSummary: mock<SchematronSummary>(),
        xSpecAssertionSummaryGenerator: mock<XSpecAssertionSummaryGenerator>(),
      },
    };
    const cli = CommandLineController(ctx);
    await cli.parseAsync(['node', 'index.ts', 'validate', 'rev4', 'ssp.xml']);
    expect(ctx.useCases.oscalService.validateOscalFile).toHaveBeenCalled();
  });
});
