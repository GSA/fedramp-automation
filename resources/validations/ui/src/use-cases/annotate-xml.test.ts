import { AnnotateXMLUseCase } from './annotate-xml';

// @ts-ignore
import * as SaxonJS from 'saxon-js';

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
            id: 'annotation-1',
            xpath: '//node1',
          },
        ],
      });
      expect(retVal).toEqual(
        '<?xml version="1.0" encoding="UTF-8"?><xml><!--annotation-1-start--><node1/><!--annotation-1-end--><node2/></xml>',
      );
    });

    it('when last child', async () => {
      const retVal = await annotateXML({
        xmlString: '<xml><node1></node1><node2></node2></xml>',
        annotations: [
          {
            id: 'annotation-1',
            xpath: '//node2',
          },
        ],
      });
      expect(retVal).toEqual(
        '<?xml version="1.0" encoding="UTF-8"?><xml><node1/><!--annotation-1-start--><node2/><!--annotation-1-end--></xml>',
      );
    });
  });
});
