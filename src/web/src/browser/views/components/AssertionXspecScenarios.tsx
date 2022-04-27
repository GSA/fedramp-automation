import React from 'react';

const testData = {
  codeHTML: '',
};

export const AssertionXspecScenarios = () => {
  return (
    <pre style={{ whiteSpace: 'pre-wrap' }}>
      <code dangerouslySetInnerHTML={{ __html: testData.codeHTML }}></code>
    </pre>
  );
};
