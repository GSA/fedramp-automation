import { Command } from 'commander';

import type { XSpecScenarioSummaryWriter } from '@asap/shared/use-cases/assertion-documentation';
import type { WriteAssertionViews } from '@asap/shared/use-cases/assertion-views';
import type { ParseSchematronAssertions } from '@asap/shared/use-cases/schematron';
import type { OscalService } from '@asap/shared/use-cases/oscal';

type CommandLineContext = {
  readStringFile: (fileName: string) => Promise<string>;
  writeStringFile: (fileName: string, contents: string) => Promise<void>;
  useCases: {
    parseSchematron: ParseSchematronAssertions;
    oscalService: OscalService;
    writeAssertionViews: WriteAssertionViews;
    writeXSpecScenarioSummaries: XSpecScenarioSummaryWriter;
  };
};

export const CommandLineController = (ctx: CommandLineContext) => {
  const cli = new Command();
  cli
    .command('validate <ssp-xml-file>')
    .description('validate OSCAL systems security plan document')
    .action(sspXmlFile => {
      ctx.readStringFile(sspXmlFile).then(xmlString => {
        ctx.useCases.oscalService.validateXmlOrJson(xmlString).then(result => {
          console.log(
            `Found ${result.validationReport.failedAsserts.length} assertions in ${result.documentType}`,
          );
        });
      });
    });
  cli
    .command('parse-schematron <input-sch-xml-file> <output-sch-json-file>')
    .description('parse Schematron XML and output JSON version')
    .action((inputSchXmlFile, outputSchJsonFile) => {
      ctx.readStringFile(inputSchXmlFile).then(xmlString => {
        const schematronObject = ctx.useCases.parseSchematron(xmlString);
        ctx.writeStringFile(
          outputSchJsonFile,
          JSON.stringify(schematronObject),
        );
        console.log(`Wrote ${outputSchJsonFile}`);
      });
    });
  cli
    .command('create-assertion-view <output-file-path> <schematron-xml-path>')
    .description(
      'write UI-optimized JSON of assertion views to target location',
    )
    .action((outputFilePath, schematronXMLPath) => {
      ctx.useCases
        .writeAssertionViews({ outputFilePath, schematronXMLPath })
        .then(() => {
          console.log(`Wrote assertion views to filesystem`);
        });
    });
  cli
    .command('create-xspec-summaries <xspec-path> <summary-path>')
    .description(
      'write UI-optimized JSON of assertion details, including xspec scenarios as usage examples',
    )
    .action((xspecPath, summaryPath) => {
      ctx.useCases
        .writeXSpecScenarioSummaries(xspecPath, summaryPath)
        .then(() => {
          console.log(`Wrote assertion documentation to filesystem`);
        });
    });
  return cli;
};
export type CommandLineController = ReturnType<typeof CommandLineController>;
