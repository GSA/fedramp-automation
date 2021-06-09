import yargs from 'yargs';

type CommandLineOptions = {
  argv: string[];
  exitProcess: boolean;
};

export const commandLineController = (ctx: CommandLineOptions) => {
  return yargs(ctx.argv)
    .exitProcess(ctx.exitProcess)
    .usage('Usage: $0 <command> [options]')
    .command('validate', 'Validate systems security plan', yargs => {
      return yargs.option('ssp', {
        type: 'string',
        demand: 'Please specify OSCAL SSP file path',
        nargs: 1,
        describe: 'Systems security plan in OSCAL XML format',
      });
    })
    .example('$0 validate --ssp my-fedramp-ssp.xml', 'Validate SSP')

    .demand(1, 'Please specify a command!')
    .strict()

    .help('h')
    .alias('h', 'help')
    .wrap(null);
};
