import { Command } from 'commander';
import type { ParseSchematronAssertions } from 'src/use-cases/schematron';
import type { ValidateSSPUseCase } from 'src/use-cases/validate-ssp-xml';

type CommandLineContext = {
  readStringFile: (fileName: string) => string;
  writeStringFile: (fileName: string, contents: string) => void;
  parseSchematron: ParseSchematronAssertions;
  validateSSP: ValidateSSPUseCase;
};

export const CommandLineController = (ctx: CommandLineContext) => {
  const cli = new Command();
  cli
    .command('validate <ssp-xml-file>')
    .description('validate OSCAL systems security plan document')
    .action(sspXmlFile => {
      const xmlString = ctx.readStringFile(sspXmlFile);
      ctx.validateSSP(xmlString).then(validationReport => {
        console.log(
          `Found ${validationReport.failedAsserts.length} assertions`,
        );
      });
    });
  cli
    .command('parse-schematron <input-sch-xml-file> <output-sch-json-file>')
    .description('parse Schematron XML and output JSON version')
    .action((inputSchXmlFile, outputSchJsonFile) => {
      const xmlString = ctx.readStringFile(inputSchXmlFile);
      const schematronObject = ctx.parseSchematron(xmlString);
      ctx.writeStringFile(outputSchJsonFile, JSON.stringify(schematronObject));
      console.log(`Wrote ${outputSchJsonFile}`);
    });
  return cli;
};
export type CommandLineController = ReturnType<typeof CommandLineController>;
