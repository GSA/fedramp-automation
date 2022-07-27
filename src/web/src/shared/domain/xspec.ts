import { groupBy } from '../util';
import type { FormatXml } from './xml';

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
  expectAssert: boolean;
  context: string;
  scenarios: { url: string; label: string }[];
};

export type SummariesByAssertionId = {
  [key: string]: ScenarioSummary[];
};

export const getXSpecScenarioSummaries = async (
  ctx: { formatXml: FormatXml },
  xspec: XSpec,
  xspecString: string,
): Promise<SummariesByAssertionId> => {
  const getScenarios = (
    scenario: XSpecScenario,
    parentScenarios: { url: string; label: string }[],
    parentContext?: string,
  ): ScenarioSummary[] => {
    // Accumulate all the scenario's parent labels into a single list.
    const scenarios = [
      ...parentScenarios,
      {
        label: scenario.label,
        url: getReferenceUrlForScenario(xspecString, [
          ...parentScenarios.map(s => s.label),
          scenario.label,
        ]),
      },
    ];

    // The context for this scenario is either specified on the node, or inherited.
    const context = scenario.context || parentContext;

    // If there are child scenarios, recurse over ourself.
    if (scenario.scenarios) {
      return scenario.scenarios.flatMap(s =>
        getScenarios(s, scenarios, context),
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
      expectAssert: assertion.expectAssert,
      context: context ? ctx.formatXml(context) : '',
      scenarios,
    }));

    return finalScenarios;
  };

  const summaries = xspec.scenarios.flatMap(scenario =>
    getScenarios(scenario, []),
  );
  return groupBy(summaries, summary => summary.assertionId);
};

const getReferenceUrlForScenario = (xspec: string, labels: string[]) => {
  return '';
};
