import React from 'react';

import { useAppState } from '../hooks';
import { CodeViewer } from './CodeViewer';

export const ViewerPage = () => {
  const report = useAppState().report;
  return (
    <div>
      {report.current === 'VALIDATED' ? (
        <CodeViewer codeHTML={report.xmlText} />
      ) : (
        <p>No report validated.</p>
      )}
    </div>
  );
};
