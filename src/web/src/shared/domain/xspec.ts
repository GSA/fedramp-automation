import type { FormatXml } from './xml';

type XspecAssert = {
  id: string;
  label: string;
};

export type XSpecScenario = {
  label: string;
  scenarios?: XSpecScenario[];
  context?: string;
  expectAssert?: XspecAssert;
  expectNotAssert?: XspecAssert;
};

export type XSpec = {
  scenarios: XSpecScenario[];
};

export type ParseXSpec = (xmlString: string) => XSpec;

// A flattened summary of an XSpec scenario, suitable for documentation.
export type ScenarioSummary = {
  assertionId: string;
  label: string;
  context: string;
};

export const getXSpecScenarioSummaries = async (
  xspec: XSpec,
  formatXml: FormatXml,
) => {
  const getScenarios = (
    scenario: XSpecScenario,
    parentLabel?: string,
  ): ScenarioSummary[] => {
    // Assemble this scenario with a concatenation of the parent's label.
    const finalScenario = {
      assertionId:
        scenario.expectAssert?.id || scenario.expectNotAssert?.id || '',
      label: parentLabel
        ? [parentLabel, scenario.label].join(' ')
        : scenario.label,
      context: scenario.context ? formatXml(scenario.context) : '',
    };

    // If there are child scenarios, recurse over ourself.
    if (scenario.scenarios) {
      return scenario.scenarios.flatMap(s =>
        getScenarios(s, finalScenario.label),
      );
    }

    return [finalScenario];
  };

  return xspec.scenarios.flatMap(scenario => getScenarios(scenario));
};
