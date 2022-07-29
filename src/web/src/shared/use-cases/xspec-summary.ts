import type { FormatXml } from '@asap/shared/domain/xml';
import { GithubRepository } from '@asap/shared/domain/github';
import {
  getXSpecScenarioSummaries,
  SummariesByAssertionId,
  XSpec,
} from '@asap/shared/domain/xspec';
import { OscalDocumentKey } from '../domain/oscal';
import {
  XSPEC_LOCAL_PATHS,
  XSPEC_SUMMARY_LOCAL_PATHS,
} from '../project-config';

export type XSpecScenarioSummaries = {
  poam: SummariesByAssertionId;
  sap: SummariesByAssertionId;
  sar: SummariesByAssertionId;
  ssp: SummariesByAssertionId;
};

export type GetXSpecScenarioSummaries = () => Promise<XSpecScenarioSummaries>;

export class XSpecScenarioSummaryGenerator {
  constructor(
    private formatXml: FormatXml,
    private github: GithubRepository,
    private parseXspec: (xspec: string) => XSpec,
    private readStringFile: (path: string) => Promise<string>,
    private writeStringFile: (path: string, data: string) => void,
    private console: Console,
  ) {}

  async generate(documentType: OscalDocumentKey) {
    const xspecString = await this.readStringFile(
      XSPEC_LOCAL_PATHS[documentType],
    );
    const xspec = this.parseXspec(xspecString);
    const scenarios = await getXSpecScenarioSummaries(
      { formatXml: this.formatXml },
      this.github,
      xspec,
      xspecString,
    );
    this.writeStringFile(
      XSPEC_SUMMARY_LOCAL_PATHS[documentType],
      JSON.stringify(scenarios),
    );
    this.console.log(`Wrote assertion documentation to filesystem`);
  }
}
