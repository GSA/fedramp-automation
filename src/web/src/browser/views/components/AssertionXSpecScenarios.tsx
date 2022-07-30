import { selectVisibleScenarioSummaries } from '@asap/browser/presenter/state/selectors';
import { useSelector } from '../context';
import { CodeViewer } from './CodeViewer';

export const AssertionXSpecScenarios = () => {
  const scenarioSummaries = useSelector(selectVisibleScenarioSummaries);
  console.log(scenarioSummaries);
  return (
    <ul>
      {scenarioSummaries.map((summary, index) => (
        <li key={index}>
          {summary.scenarios.map((s, index) =>
            s.url ? (
              <a key={index} href={s.url} target="_blank" rel="noopener">
                {s.label}
              </a>
            ) : (
              s.label
            ),
          )}
          <span className="text-bold">{summary.assertionLabel}</span>{' '}
          <span>
            <a href={summary.referenceUrl} target="_blank" rel="noopener">
              View XSpec Scenario
            </a>
          </span>
          <CodeViewer codeHTML={summary.context}></CodeViewer>
        </li>
      ))}
    </ul>
  );
};
