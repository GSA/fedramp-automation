import { it, describe, expect, vi } from 'vitest';
import { mock } from 'vitest-mock-extended';

import { SourceCodeLinkDocumentGenerator } from '@asap/shared/use-cases/generate-source-code-link-documents';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';
import { CommandLineController } from './cli-controller';

describe('command-line controller', () => {
  it('calls validate schematron', async () => {
    const mockXml = '<xml></xml>';
    const ctx = {
      console: mock<Console>({
        log: vi.fn(),
      }),
      readStringFile: vi.fn().mockReturnValue(Promise.resolve(mockXml)),
      writeStringFile: vi.fn().mockReturnValue(Promise.resolve()),
      useCases: {
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
        sourceCodeLinkDocumentGenerator:
          mock<SourceCodeLinkDocumentGenerator>(),
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
