import { Command } from 'commander';
import type { ValidateSchematronUseCase } from 'src/use-cases/validate-ssp-xml';

type CommandLineContext = {
  readStringFile: (fileName: string) => string;
  validateSchematron: ValidateSchematronUseCase;
};

export const CommandLineController = (ctx: CommandLineContext) => {
  const cli = new Command();
  cli
    .command('validate <ssp-xml-file>')
    .description('validate OSCAL systems security plan document')
    .action(sspXmlFile => {
      const xmlString = ctx.readStringFile(sspXmlFile);
      ctx.validateSchematron(xmlString).then(validationReport => {
        console.log(
          `Found ${validationReport.failedAsserts.length} assertions`,
        );
      });
    });
  return cli;
};
