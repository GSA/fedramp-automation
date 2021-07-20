import hljs from 'highlight.js/lib/core';
import xml from 'highlight.js/lib/languages/xml';

import type { FormatXml } from '@asap/shared/use-cases/annotate-xml';

hljs.registerLanguage('xml', xml);

export const highlightXML: FormatXml = (xmlString: string) => {
  return hljs.highlight(xmlString, {
    language: 'xml',
  }).value;
};
