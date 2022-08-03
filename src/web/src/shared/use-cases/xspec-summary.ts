import type { FormatXml } from '@asap/shared/domain/xml';
import { GithubRepository } from '@asap/shared/domain/github';
import {
  getXSpecAssertionSummaries,
  ParseXSpec,
  SummariesByAssertionId,
} from '@asap/shared/domain/xspec';
import { OscalDocumentKey, OscalDocumentKeys } from '../domain/oscal';
import {
  XSPEC_LOCAL_PATHS,
  XSPEC_REPOSITORY_PATHS,
  XSPEC_SUMMARY_LOCAL_PATHS,
} from '../project-config';

export type XSpecScenarioSummaries = {
  poam: SummariesByAssertionId;
  sap: SummariesByAssertionId;
  sar: SummariesByAssertionId;
  ssp: SummariesByAssertionId;
};

export type GetXSpecScenarioSummaries = () => Promise<XSpecScenarioSummaries>;

export class XSpecAssertionSummaryGenerator {
  constructor(
    private formatXml: FormatXml,
    private github: GithubRepository,
    private parseXspec: ParseXSpec,
    private readStringFile: (path: string) => Promise<string>,
    private writeStringFile: (path: string, data: string) => void,
    private console: Console,
  ) {}

  async generateAll() {
    for (const documentType of OscalDocumentKeys) {
      await this.generate(documentType);
    }
  }

  async generate(documentType: OscalDocumentKey) {
    this.console.log(`Generating ${documentType} xspec summary...`);
    const xspecString = await this.readStringFile(
      XSPEC_LOCAL_PATHS[documentType],
    );
    const xspec = this.parseXspec(xspecString);
    const scenarios = await getXSpecAssertionSummaries(
      { formatXml: this.formatXml },
      this.github,
      XSPEC_REPOSITORY_PATHS[documentType],
      xspec,
      xspecString,
    );
    this.writeStringFile(
      XSPEC_SUMMARY_LOCAL_PATHS[documentType],
      JSON.stringify(scenarios),
    );
    this.console.log(`Wrote ${documentType} xspec summary to filesystem.`);
  }
}
