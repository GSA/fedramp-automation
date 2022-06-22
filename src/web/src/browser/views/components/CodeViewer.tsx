type CodeViewerProps = {
  codeHTML: string;
};

export const CodeViewer = ({ codeHTML }: CodeViewerProps) => {
  return (
    <pre style={{ whiteSpace: 'pre-wrap' }}>
      <code dangerouslySetInnerHTML={{ __html: codeHTML }}></code>
    </pre>
  );
};
