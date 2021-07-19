import React from 'react';
import { useAppState } from '../hooks';

export const SummaryPage = () => {
  const { validator } = useAppState().schematron;

  if (validator.current !== 'VALIDATED') {
    return <div>Not loaded.</div>;
  }

  return (
    <h1>Found {validator.validationReport.failedAsserts.length} assertions.</h1>
  );
};
