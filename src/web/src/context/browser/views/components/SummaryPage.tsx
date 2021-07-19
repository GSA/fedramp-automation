import React from 'react';
import { useAppState } from '../hooks';

export const SummaryPage = () => {
  const { report } = useAppState();

  if (report.current !== 'VALIDATED') {
    return <div>Not loaded.</div>;
  }

  return (
    <h1>Found {report.validationReport.failedAsserts.length} assertions.</h1>
  );
};
