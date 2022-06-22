import type { ScenarioSummary } from '@asap/shared/domain/xspec';
import { CodeViewer } from './CodeViewer';

export const AssertionXSpecScenarios = (props: {
  scenarioSummaries: ScenarioSummary[];
}) => {
  return (
    <ul>
      {props.scenarioSummaries.map((scenario, index) => (
        <li key={index}>
          {scenario.label}{' '}
          <span className="text-bold">{scenario.assertionLabel}</span>
          <CodeViewer codeHTML={scenario.context}></CodeViewer>
        </li>
      ))}
    </ul>
  );
};
