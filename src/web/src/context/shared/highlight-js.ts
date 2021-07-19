import hljs from 'highlight.js';
import xml from 'highlight.js/lib/languages/xml';

import type { FormatXml } from '../../use-cases/annotate-xml';

hljs.registerLanguage('xml', xml);

export const highlightXML: FormatXml = (xmlString: string) => {
  return hljs.highlight(xmlString, {
    language: 'xml',
  }).value;
};
