import { selectVisibleScenarioSummaries } from '@asap/browser/presenter/state/selectors';
import { useSelector } from '../context';
import { CodeViewer } from './CodeViewer';

export const AssertionXSpecScenarios = () => {
  const scenarioSummaries = useSelector(selectVisibleScenarioSummaries);
  console.log(scenarioSummaries);
  return (
    <ul>
      {scenarioSummaries.map((scenario, index) => (
        <li key={index}>
          {scenario.summary.scenarios.map((s, index) => (
            <a key={index} href={s.url}>
              {s.label}
            </a>
          ))}
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
