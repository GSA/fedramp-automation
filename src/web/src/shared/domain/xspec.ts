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
  context: string;
  label: string;
};

export type SummariesByAssertionId = {
  [key: string]: ScenarioSummary[];
};

export const getXSpecScenarioSummaries = async (
  xspec: XSpec,
  formatXml: FormatXml,
): Promise<SummariesByAssertionId> => {
  const getScenarios = (
    scenario: XSpecScenario,
    parentLabel?: string,
    parentContext?: string,
  ): ScenarioSummary[] => {
    // This scenario's label is the concatenation of all parent labels.
    const label = parentLabel
      ? [parentLabel, scenario.label].join(' ')
      : scenario.label;

    // The context for this scenario is either specified on the node, or inherited.
    const context = scenario.context || parentContext;

    // If there are child scenarios, recurse over ourself.
    if (scenario.scenarios) {
      return scenario.scenarios.flatMap(s => getScenarios(s, label, context));
    }

    const assertions = [
      ...(scenario.expectAssert || []),
      ...(scenario.expectNotAssert || []),
    ];

    // Assemble this scenario with a concatenation of the parent's label.
    const finalScenarios = assertions.map(assertion => ({
      assertionId: assertion.id,
      assertionLabel: assertion.label,
      context: context ? formatXml(context) : '',
      label,
    }));

    return finalScenarios;
  };

  const summaries = xspec.scenarios.flatMap(scenario => getScenarios(scenario));
  return groupBy(summaries, summary => summary.assertionId);
};
