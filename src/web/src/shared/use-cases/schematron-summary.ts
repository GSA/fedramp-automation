import { GithubRepository } from '../domain/github';
import { OscalDocumentKey, OscalDocumentKeys } from '../domain/oscal';
import {
  generateSchematronSummary,
  ParseSchematronAssertions,
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
    for (const documentType of OscalDocumentKeys) {
      await this.generateSummary(documentType);
    }
  }

  async generateSummary(documentType: OscalDocumentKey) {
    const xmlString = await this.readStringFile(
      LOCAL_PATHS.SCHEMATRON[documentType],
    );
    const schematronAsserts = await this.parseSchematron(xmlString);
    const schematronSummary = generateSchematronSummary(
      xmlString,
      schematronAsserts,
      this.github,
      REPOSITORY_PATHS.SCHEMATRON[documentType],
    );
    await this.writeStringFile(
      LOCAL_PATHS.SCHEMATRON_SUMMARY[documentType],
      JSON.stringify(schematronSummary),
    );
    this.console.log(`Wrote ${LOCAL_PATHS.SCHEMATRON_SUMMARY[documentType]}`);
  }
}
