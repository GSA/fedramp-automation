import React from 'react';

type XmlViewProps = {
  xmlText: string;
};

export const XmlViewer = ({ xmlText }: XmlViewProps) => {
  const parser = new DOMParser();
  const xmlDocument = parser.parseFromString(xmlText, 'text/xml');
  return (
    <pre
      dangerouslySetInnerHTML={{
        __html: xmlDocument.documentElement.innerHTML,
      }}
    />
  );
};
