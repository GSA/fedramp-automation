import { selectVisibleScenarioSummaries } from '@asap/browser/presenter/state/selectors';
import { useSelector } from '../context';
import { CodeViewer } from './CodeViewer';

export const AssertionXSpecScenarios = () => {
  const scenarioSummaries = useSelector(selectVisibleScenarioSummaries);
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
              <span>{s.label} </span>
            ),
          )}{' '}
          <span className="text-bold">
            {summary.referenceUrl ? (
              <a href={summary.referenceUrl} target="_blank" rel="noopener">
                {summary.assertionLabel}
              </a>
            ) : (
              summary.assertionLabel
            )}
          </span>
          <CodeViewer codeHTML={summary.context}></CodeViewer>
        </li>
      ))}
    </ul>
  );
};
