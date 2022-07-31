import { linesOf } from './text';
import { groupBy } from '../util';
import type { FormatXml } from './xml';
import { getBlobFileUrl, GithubRepository } from './github';

type XspecAssert = {
  id: string;
  label: string;
};

export type XSpecScenario = {
  label: string;
  scenarios?: XSpecScenario[];
  context?: string;
  expectAssert?: XspecAssert[];
  expectNotAssert?: XspecAssert[];
};

export type XSpec = {
  scenarios: XSpecScenario[];
};

export type ParseXSpec = (xmlString: string) => XSpec;

// A flattened summary of an XSpec scenario, suitable for documentation.
export type ScenarioSummary = {
  assertionId: string;
  assertionLabel: string;
  context: string;
  expectAssert: boolean;
  referenceUrl: string;
  scenarios: { url: string | null; label: string }[];
};

export type SummariesByAssertionId = {
  [key: string]: ScenarioSummary[];
};

export const getXSpecScenarioSummaries = async (
  ctx: { formatXml: FormatXml },
  github: GithubRepository,
  repositoryPath: `/${string}`,
  xspec: XSpec,
  xspecString: string,
): Promise<SummariesByAssertionId> => {
  const getScenarios = (
    scenario: XSpecScenario,
    parentScenarios: { url: string | null; label: string }[],
    scenarioCount: number = 0,
    parentContext?: string,
  ): ScenarioSummary[] => {
    const childScenarioCount = countScenarios(scenario);
    // Accumulate all the scenario's parent labels into a single list.
    const scenarios = [
      ...parentScenarios,
      {
        label: scenario.label,
        url: getReferenceUrlForScenario(
          github,
          repositoryPath,
          xspecString,
          scenarioCount,
          childScenarioCount,
        ),
      },
    ];
    scenarioCount += childScenarioCount;

    // The context for this scenario is either specified on the node, or inherited.
    const context = scenario.context || parentContext;

    // If there are child scenarios, recurse over ourself.
    if (scenario.scenarios) {
      return scenario.scenarios.flatMap(s =>
        getScenarios(s, scenarios, scenarioCount, context),
      );
    }

    const assertions = [
      ...(scenario.expectAssert || []).map(e => ({
        ...e,
        expectAssert: true,
      })),
      ...(scenario.expectNotAssert || []).map(e => ({
        ...e,
        expectAssert: false,
      })),
    ];

    // Assemble this scenario with a concatenation of the parent's label.
    const finalScenarios = assertions.map(assertion => ({
      assertionId: assertion.id,
      assertionLabel: assertion.label,
      context: context ? ctx.formatXml(context) : '',
      expectAssert: assertion.expectAssert,
      referenceUrl: '#TODO',
      scenarios,
    }));

    return finalScenarios;
  };

  const summaries = xspec.scenarios.flatMap(scenario =>
    getScenarios(scenario, []),
  );
  return groupBy(summaries, summary => summary.assertionId);
};

export const getReferenceUrlForScenario = (
  github: GithubRepository,
  repositoryPath: `/${string}`,
  xspec: string,
  scenarioCount: number,
  childScenarioCount: number,
) => {
  const lineRange = getXspecScenarioLineRange(
    xspec,
    scenarioCount,
    childScenarioCount,
  );
  if (!lineRange) {
    return null;
  }
  return getBlobFileUrl(github, repositoryPath, lineRange);
};

const countScenarios = (scenario: XSpecScenario): number => {
  const counts =
    scenario.scenarios?.flatMap(scenario => countScenarios(scenario)) || [];
  return counts.reduce((a, b) => a + b, 1);
};

const createScenarioRegExp = (openedTags: number, closedTags: number) => {
  const prefix = '<x:scenario[^>]*?>[^]+?'.repeat(openedTags);
  const suffix = '[^]+?<\\/x:scenario>'.repeat(closedTags);
  const regExp = `(?:${prefix})(<x:scenario[^>]*?>[^]+?${suffix})`;
  return new RegExp(regExp, 'u');
};

export const getXspecScenarioLineRange = (
  xml: string,
  scenarioCount: number,
  childScenarioCount: number,
) => {
  const regExp = createScenarioRegExp(scenarioCount, childScenarioCount);
  const match = xml.match(regExp);
  if (match === null) {
    console.log(regExp);
    console.error(
      `Scenario XML not found: ${[scenarioCount, childScenarioCount].join(
        ' ',
      )}`,
    );
    return null;
  }
  const elementString = match[1];
  const lines = linesOf(xml, elementString);
  return lines;
};
