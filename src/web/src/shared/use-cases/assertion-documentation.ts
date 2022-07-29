import type { FormatXml } from '@asap/shared/domain/xml';
import { GithubRepository } from '@asap/shared/domain/github';
import {
  getXSpecScenarioSummaries,
  SummariesByAssertionId,
  XSpec,
} from '@asap/shared/domain/xspec';

type Context = {
  formatXml: FormatXml;
  github: GithubRepository;
  parseXspec: (xspec: string) => XSpec;
  readStringFile: (path: string) => Promise<string>;
  writeStringFile: (path: string, data: string) => void;
};

export const createXSpecScenarioSummaryWriter =
  (ctx: Context) => async (xspecPath: string, summaryPath: string) => {
    const xspecString = await ctx.readStringFile(xspecPath);
    const xspec = ctx.parseXspec(xspecString);
    return getXSpecScenarioSummaries(
      { formatXml: ctx.formatXml },
      ctx.github,
      xspec,
      xspecString,
    ).then(scenarios => {
      ctx.writeStringFile(summaryPath, JSON.stringify(scenarios));
    });
  };
export type XSpecScenarioSummaryWriter = ReturnType<
  typeof createXSpecScenarioSummaryWriter
>;

export type XSpecScenarioSummaries = {
  poam: SummariesByAssertionId;
  sap: SummariesByAssertionId;
  sar: SummariesByAssertionId;
  ssp: SummariesByAssertionId;
};

export type GetXSpecScenarioSummaries = () => Promise<XSpecScenarioSummaries>;
