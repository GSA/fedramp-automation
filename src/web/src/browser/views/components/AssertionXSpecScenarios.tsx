import { selectVisibleScenarioSummaries } from '@asap/browser/presenter/state/selectors';
import type { ScenarioSummary } from '@asap/shared/domain/xspec';
import { useAppContext, useSelector } from '../context';
import { CodeViewer } from './CodeViewer';

export const AssertionXSpecScenarios = () => {
  const scenarioSummaries = useSelector(selectVisibleScenarioSummaries);

  return (
    <ul>
      {scenarioSummaries.map((scenario, index) => (
        <li key={index}>
          {scenario.summary.label}{' '}
          <span className="text-bold">{scenario.summary.assertionLabel}</span>{' '}
          <span>
            <a href={scenario.referenceUrl} target="_blank" rel="noopener">
              View XSpec Scenario
            </a>
          </span>
          <CodeViewer codeHTML={scenario.summary.context}></CodeViewer>
        </li>
      ))}
    </ul>
  );
};
