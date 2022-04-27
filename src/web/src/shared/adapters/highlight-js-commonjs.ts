/**
 * This is a separate module from `highlight-js.ts` to accomodate an CommonJS
 * dependency within highlight.js. This version is intended to be used via
 * node.js, while the ES6 module is to be used by Snowpack browser builds.
 */
const hljs = require('highlight.js/lib/core');
const xml = require('highlight.js/lib/languages/xml');

import type { FormatXml } from '@asap/shared/domain/xml';

hljs.registerLanguage('xml', xml);

export const highlightXML: FormatXml = (xmlString: string) => {
  return hljs.highlight(xmlString, {
    language: 'xml',
  }).value;
};
