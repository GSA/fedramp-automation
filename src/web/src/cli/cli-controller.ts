import { Command } from 'commander';

import type { XSpecScenarioSummaryWriter } from '@asap/shared/use-cases/assertion-documentation';
import type { WriteAssertionViews } from '@asap/shared/use-cases/assertion-views';
import type { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';

type CommandLineContext = {
  console: Console;
  readStringFile: (fileName: string) => Promise<string>;
  writeStringFile: (fileName: string, contents: string) => Promise<void>;
  useCases: {
    oscalService: OscalService;
    schematronSummary: SchematronSummary;
    writeAssertionViews: WriteAssertionViews;
    writeXSpecScenarioSummaries: XSpecScenarioSummaryWriter;
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
    .command('parse-schematron <input-sch-xml-file> <output-sch-json-file>')
    .description('parse Schematron XML and output JSON summary')
    .action(async (inputSchXmlFile, outputSchJsonFile) => {
      ctx.useCases.schematronSummary.generate(
        inputSchXmlFile,
        outputSchJsonFile,
      );
      ctx.console.log(`Wrote ${outputSchJsonFile}`);
    });
  cli
    .command('create-assertion-view <output-file-path> <schematron-xml-path>')
    .description(
      'write UI-optimized JSON of assertion views to target location',
    )
    .action(async (outputFilePath, schematronXMLPath) => {
      await ctx.useCases.writeAssertionViews({
        outputFilePath,
        schematronXMLPath,
      });
      ctx.console.log(`Wrote assertion views to filesystem`);
    });
  cli
    .command('create-xspec-summaries <xspec-path> <summary-path>')
    .description(
      'write UI-optimized JSON of assertion details, including xspec scenarios as usage examples',
    )
    .action(async (xspecPath, summaryPath) => {
      await ctx.useCases.writeXSpecScenarioSummaries(xspecPath, summaryPath);
      ctx.console.log(`Wrote assertion documentation to filesystem`);
    });
  return cli;
};
export type CommandLineController = ReturnType<typeof CommandLineController>;
