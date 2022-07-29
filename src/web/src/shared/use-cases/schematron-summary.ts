import { GithubRepository } from '../domain/github';
import { OscalDocumentKey, OscalDocumentKeys } from '../domain/oscal';
import {
  generateSchematronSummary,
  ParseSchematronAssertions,
} from '../domain/schematron';
import {
  SCHEMATRON_LOCAL_PATHS,
  SCHEMATRON_REPOSITORY_PATHS,
  SCHEMATRON_SUMMARY_LOCAL_PATHS,
} from '../project-config';

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
      SCHEMATRON_LOCAL_PATHS[documentType],
    );
    const schematronAsserts = await this.parseSchematron(xmlString);
    const schematronSummary = generateSchematronSummary(
      xmlString,
      schematronAsserts,
      this.github,
      SCHEMATRON_REPOSITORY_PATHS[documentType],
    );
    await this.writeStringFile(
      SCHEMATRON_SUMMARY_LOCAL_PATHS[documentType],
      JSON.stringify(schematronSummary),
    );
    this.console.log(`Wrote ${SCHEMATRON_SUMMARY_LOCAL_PATHS[documentType]}`);
  }
}
