import { GithubRepository } from '../domain/github';
import { OscalDocumentKey, OscalDocumentKeys } from '../domain/oscal';
import {
  generateSchematronSummary,
  ParseSchematronAssertions,
  SchematronRulesetKey,
  SchematronRulesetKeys,
} from '../domain/schematron';
import { LOCAL_PATHS, REPOSITORY_PATHS } from '../project-config';

export class SchematronSummary {
  constructor(
    private parseSchematron: ParseSchematronAssertions,
    private readStringFile: (fileName: string) => Promise<string>,
    private writeStringFile: (
      fileName: string,
      contents: string,
    ) => Promise<void>,
    private github: GithubRepository,
    private console: Console,
  ) {}

  async generateAllSummaries() {
    for (const rulesetKey of SchematronRulesetKeys) {
      for (const documentType of OscalDocumentKeys) {
        await this.generateSummary(documentType, rulesetKey);
      }
    }
  }

  async generateSummary(
    documentType: OscalDocumentKey,
    rulesetKey: SchematronRulesetKey,
  ) {
    const xmlString = await this.readStringFile(
      LOCAL_PATHS[rulesetKey].SCHEMATRON[documentType],
    );
    const schematronAsserts = await this.parseSchematron(xmlString);
    const schematronSummary = generateSchematronSummary(
      xmlString,
      schematronAsserts,
      this.github,
      REPOSITORY_PATHS[rulesetKey].SCHEMATRON[documentType],
    );
    await this.writeStringFile(
      LOCAL_PATHS[rulesetKey].SCHEMATRON_SUMMARY[documentType],
      JSON.stringify(schematronSummary),
    );
    this.console.log(
      `Wrote ${LOCAL_PATHS[rulesetKey].SCHEMATRON_SUMMARY[documentType]}`,
    );
  }
}
