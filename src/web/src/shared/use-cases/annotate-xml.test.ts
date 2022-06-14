import { it, describe, expect } from 'vitest';

import { AnnotateXMLUseCase } from './annotate-xml';

// @ts-ignore
import SaxonJS from 'saxon-js';

describe('xml annotation integrated with SaxonJS', () => {
  const annotateXML = AnnotateXMLUseCase({
    xml: { formatXML: xml => xml, indentXml: async xml => xml },
    SaxonJS,
  });
  describe('wraps node with comments', () => {
    it('when first child', async () => {
      const retVal = await annotateXML({
        xmlString: '<xml><node1></node1><node2></node2></xml>',
        annotations: [
          {
            uniqueId: 'annotation-1',
            xpath: '//node1',
          },
        ],
      });
      expect(retVal).toEqual(
        '<?xml version="1.0" encoding="UTF-8"?><xml><!--ASSERTION-START:annotation-1:ASSERTION-START--><node1/><!--ASSERTION-END:annotation-1:ASSERTION-END--><node2/></xml>',
      );
    });

    it('when last child', async () => {
      const retVal = await annotateXML({
        xmlString: '<xml><node1></node1><node2></node2></xml>',
        annotations: [
          {
            uniqueId: 'annotation-1',
            xpath: '//node2',
          },
        ],
      });
      expect(retVal).toEqual(
        '<?xml version="1.0" encoding="UTF-8"?><xml><node1/><!--ASSERTION-START:annotation-1:ASSERTION-START--><node2/><!--ASSERTION-END:annotation-1:ASSERTION-END--></xml>',
      );
    });
  });
});
