import React from 'react';

import type { ScenarioSummary } from '@asap/shared/domain/xspec';
import { CodeViewer } from './CodeViewer';

type Props = {
  scenarioSummaries: ScenarioSummary[];
};

export const AssertionXSpecScenarios = ({ scenarioSummaries }: Props) => {
  return (
    <ul>
      {scenarioSummaries.map((scenario, index) => (
        <li key={index}>
          {scenario.label}{' '}
          <span className="text-bold">{scenario.assertionLabel}</span>
          <CodeViewer codeHTML={scenario.context}></CodeViewer>
        </li>
      ))}
    </ul>
  );
};
