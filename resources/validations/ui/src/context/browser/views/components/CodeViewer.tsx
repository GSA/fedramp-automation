import React from 'react';

type CodeViewerProps = {
  codeHTML: string;
};

export const CodeViewer = ({ codeHTML }: CodeViewerProps) => {
  return (
    <pre>
      <code dangerouslySetInnerHTML={{ __html: codeHTML }}></code>
    </pre>
  );
};
