import { Command } from 'commander';

import type { AssertionViewGenerator } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';
import type { XSpecScenarioSummaryGenerator } from '@asap/shared/use-cases/xspec-summary';

export type CommandLineContext = {
  console: Console;
  readStringFile: (fileName: string) => Promise<string>;
  writeStringFile: (fileName: string, contents: string) => Promise<void>;
  useCases: {
    assertionViewGenerator: AssertionViewGenerator;
    oscalService: OscalService;
    schematronSummary: SchematronSummary;
    xSpecScenarioSummaryGenerator: XSpecScenarioSummaryGenerator;
  };
};

export const CommandLineController = (ctx: CommandLineContext) => {
  const cli = new Command();
  cli
    .command('validate <oscal-xml-file>')
    .description('validate OSCAL document (SSP, SAP, SAR, or POA&M)')
    .action(async oscalXmlFile => {
      const xmlString = await ctx.readStringFile(oscalXmlFile);
      const result = await ctx.useCases.oscalService.validateXmlOrJson(
        xmlString,
      );
      ctx.console.log(
        `Found ${result.validationReport.failedAsserts.length} assertions in ${result.documentType}`,
      );
    });
  cli
    .command('generate-schematron-summaries')
    .description('parse all Schematron XML and outputs JSON summaries')
    .action(() => ctx.useCases.schematronSummary.generateAllSummaries());
  cli
    .command('create-assertion-view')
    .description(
      'write UI-optimized JSON of assertion views to target location',
    )
    .action(async () => {
      await ctx.useCases.assertionViewGenerator.generateAll();
    });
  cli
    .command('create-xspec-summaries <document-type>')
    .description(
      'write UI-optimized JSON xspec scenario summaries, useful for usage examples',
    )
    .action(async documentType => {
      await ctx.useCases.xSpecScenarioSummaryGenerator.generate(documentType);
    });
  return cli;
};
export type CommandLineController = ReturnType<typeof CommandLineController>;
