import type { IndentXml } from '@asap/shared/domain/xml';
import type {
  FailedAssert,
  ParseSchematronAssertions,
  SchematronJSONToXMLProcessor,
  SchematronProcessor,
  SchematronResult,
  SuccessfulReport,
} from '@asap/shared/domain/schematron';

import { getDocumentTypeForRootNode, OscalDocumentKey } from '../domain/oscal';
import type { ParseXSpec, XSpecNode, XSpecScenarioNode } from '../domain/xspec';
import type { XSLTProcessor } from '../use-cases/assertion-views';
import { base64DataUriForJson, formatElapsedTime } from '../util';

const getSchematronResult = async (
  SaxonJS: any,
  svrlString: string,
): Promise<SchematronResult> => {
  const document: DocumentFragment = await SaxonJS.getResource({
    text: svrlString,
    type: 'xml',
  });
  const failedAsserts = SaxonJS.XPath.evaluate(
    '//svrl:failed-assert',
    document,
    {
      // prettier-ignore
      namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' }, //NOSONAR
      resultForm: 'array',
    },
  );
  const successfulReports = SaxonJS.XPath.evaluate(
    '//svrl:successful-report',
    document,
    {
      // prettier-ignore
      namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' }, //NOSONAR
      resultForm: 'array',
    },
  );
  return {
    failedAsserts: Array.prototype.map.call(failedAsserts, (assert, index) => {
      return Object.keys(assert.attributes).reduce(
        (assertMap: Record<string, FailedAssert>, key: string) => {
          const name = assert.attributes[key].name;
          if (name) {
            assertMap[name] = assert.attributes[key].value;
          }
          return assertMap;
        },
        {
          diagnosticReferences: Array.prototype.map.call(
            SaxonJS.XPath.evaluate('svrl:diagnostic-reference', assert, {
              // prettier-ignore
              namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' }, //NOSONAR
              resultForm: 'array',
            }),
            (node: Node) => node.textContent,
          ) as any,
          text: SaxonJS.XPath.evaluate('svrl:text', assert, {
            // prettier-ignore
            namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' }, //NOSONAR
          }).textContent,
          uniqueId: `${assert.getAttribute('id')}-${index}` as any,
        },
      );
    }) as FailedAssert[],
    svrlString,
    successfulReports: Array.prototype.map.call(
      successfulReports,
      (report, index) => {
        return Object.keys(report.attributes).reduce(
          (assertMap: Record<string, FailedAssert>, key: string) => {
            const name = report.attributes[key].name;
            if (name) {
              assertMap[name] = report.attributes[key].value;
            }
            return assertMap;
          },
          {
            text: SaxonJS.XPath.evaluate('svrl:text', report, {
              // prettier-ignore
              namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' }, //NOSONAR
            }).textContent,
            uniqueId: `${report.getAttribute('id')}-${index}` as any,
          },
        );
      },
    ) as SuccessfulReport[],
  };
};

export const SaxonJsSchematronProcessorGateway =
  (ctx: {
    console: Console;
    sefUrls: Record<OscalDocumentKey, string>;
    SaxonJS: any;
    baselinesBaseUrl: string;
    registryBaseUrl: string;
  }): SchematronProcessor =>
  (sourceText: string) => {
    const startTime = performance.now();
    return ctx.SaxonJS.getResource({
      text: sourceText,
      type: 'xml',
    }).then((resource: any) => {
      const rootNodeName = resource.documentElement.nodeName as string;
      const documentType = getDocumentTypeForRootNode(rootNodeName);
      if (documentType === null) {
        throw new Error(`Unknown root node "${rootNodeName}"`);
      }
      return (
        ctx.SaxonJS.transform(
          {
            stylesheetLocation: ctx.sefUrls[documentType],
            destination: 'serialized',
            sourceNode: resource,
            stylesheetParams: {
              'baselines-base-path': ctx.baselinesBaseUrl,
              'registry-base-path': ctx.registryBaseUrl,
              'param-use-remote-resources': '1',
            },
          },
          'async',
        ) as Promise<DocumentFragment>
      )
        .then(result => {
          const elapsed = formatElapsedTime(performance.now() - startTime);
          ctx.console.log(
            `OSCAL XML validation completed in ${elapsed} (HH:MM:SS)`,
          );
          return result;
        })
        .then((output: any) => {
          return getSchematronResult(
            ctx.SaxonJS,
            output.principalResult as string,
          );
        })
        .then(schematronResult => {
          return {
            documentType,
            schematronResult,
          };
        });
    });
  };

type XmlIndenterContext = {
  SaxonJS: any;
};

export const SaxonJSXmlIndenter =
  (ctx: XmlIndenterContext): IndentXml =>
  (sourceText: string) => {
    return (
      ctx.SaxonJS.transform(
        // This is an XSLT identity tranformation, manually-compiled to SEF
        // format. Its output is indented XML.
        {
          stylesheetInternal: {
            N: 'package',
            version: '10',
            packageVersion: '1',
            saxonVersion: 'Saxon-JS 2.2',
            target: 'JS',
            targetVersion: '2',
            name: 'TOP-LEVEL',
            relocatable: 'true',
            buildDateTime: '2021-07-01T13:24:49.504-05:00',
            ns: 'xml=~ xsl=~',
            C: [
              {
                N: 'co',
                id: '0',
                binds: '0',
                C: [
                  {
                    N: 'mode',
                    onNo: 'TC',
                    flags: '',
                    patternSlots: '0',
                    prec: '',
                    C: [
                      {
                        N: 'templateRule',
                        rank: '0',
                        prec: '0',
                        seq: '0',
                        ns: 'xml=~ xsl=~',
                        minImp: '0',
                        flags: 's',
                        baseUri:
                          'file:///Users/dan/src/10x/fedramp-automation/resources/validations/ui/identity.xsl',
                        slots: '200',
                        line: '3',
                        module: 'identity.xsl',
                        match: 'node()|@*',
                        prio: '-0.5',
                        matches: 'N u[NT,NP,NC,NE]',
                        C: [
                          {
                            N: 'p.nodeTest',
                            role: 'match',
                            test: 'N u[NT,NP,NC,NE]',
                            sType: '1N u[NT,NP,NC,NE]',
                          },
                          {
                            N: 'copy',
                            sType: '1N u[1NT ,1NP ,1NC ,1NE ] ',
                            flags: 'cin',
                            role: 'action',
                            line: '4',
                            C: [
                              {
                                N: 'applyT',
                                sType: '* ',
                                line: '5',
                                mode: '#unnamed',
                                bSlot: '0',
                                C: [
                                  {
                                    N: 'docOrder',
                                    sType:
                                      '*N u[N u[N u[N u[NT,NP],NC],NE],NA]',
                                    role: 'select',
                                    line: '5',
                                    C: [
                                      {
                                        N: 'union',
                                        op: '|',
                                        sType:
                                          '*N u[N u[N u[N u[NT,NP],NC],NE],NA]',
                                        ns: '= xml=~ fn=~ xsl=~ ',
                                        C: [
                                          {
                                            N: 'axis',
                                            name: 'child',
                                            nodeTest: '*N u[NT,NP,NC,NE]',
                                          },
                                          {
                                            N: 'axis',
                                            name: 'attribute',
                                            nodeTest: '*NA',
                                          },
                                        ],
                                      },
                                    ],
                                  },
                                ],
                              },
                            ],
                          },
                        ],
                      },
                      {
                        N: 'templateRule',
                        rank: '1',
                        prec: '0',
                        seq: '0',
                        ns: 'xml=~ xsl=~',
                        minImp: '0',
                        flags: 's',
                        baseUri:
                          'file:///Users/dan/src/10x/fedramp-automation/resources/validations/ui/identity.xsl',
                        slots: '200',
                        line: '3',
                        module: 'identity.xsl',
                        match: 'node()|@*',
                        prio: '-0.5',
                        matches: 'NA',
                        C: [
                          {
                            N: 'p.nodeTest',
                            role: 'match',
                            test: 'NA',
                            sType: '1NA',
                          },
                          {
                            N: 'copy',
                            sType: '1NA ',
                            flags: 'cin',
                            role: 'action',
                            line: '4',
                            C: [
                              {
                                N: 'applyT',
                                sType: '* ',
                                line: '5',
                                mode: '#unnamed',
                                bSlot: '0',
                                C: [
                                  {
                                    N: 'docOrder',
                                    sType:
                                      '*N u[N u[N u[N u[NT,NP],NC],NE],NA]',
                                    role: 'select',
                                    line: '5',
                                    C: [
                                      {
                                        N: 'union',
                                        op: '|',
                                        sType:
                                          '*N u[N u[N u[N u[NT,NP],NC],NE],NA]',
                                        ns: '= xml=~ fn=~ xsl=~ ',
                                        C: [
                                          {
                                            N: 'axis',
                                            name: 'child',
                                            nodeTest: '*N u[NT,NP,NC,NE]',
                                          },
                                          {
                                            N: 'axis',
                                            name: 'attribute',
                                            nodeTest: '*NA',
                                          },
                                        ],
                                      },
                                    ],
                                  },
                                ],
                              },
                            ],
                          },
                        ],
                      },
                    ],
                  },
                ],
              },
              { N: 'overridden' },
              {
                N: 'output',
                C: [
                  {
                    N: 'property',
                    name: 'Q{http://saxon.sf.net/}stylesheet-version',
                    value: '10',
                  },
                  { N: 'property', name: 'omit-xml-declaration', value: 'yes' },
                  { N: 'property', name: 'indent', value: 'yes' },
                ],
              },
              { N: 'decimalFormat' },
            ],
            Σ: 'da0fec95',
          },
          destination: 'serialized',
          sourceText,
        },
        'async',
      ) as Promise<DocumentFragment>
    )
      .then((output: any) => {
        return output.principalResult as string;
      })
      .catch(error => {
        console.error(error);
        throw new Error(`Error indenting xml: ${error}`);
      });
  };

// SaxonJS attribute lookup behaves differently on node.js vs the browser.
const safeGetAttribute = (node: any, name: string) => {
  if (node.getAttribute) {
    return node.getAttribute(name);
  }
  if (node.attributes) {
    for (const attribute of node.attributes) {
      if (attribute.name === name) {
        return attribute.value;
      }
    }
  }
  throw new Error(`Attribute "${name}" not found.`);
};

export const SchematronParser =
  (ctx: { SaxonJS: any }): ParseSchematronAssertions =>
  (schematron: string) => {
    const document = ctx.SaxonJS.getPlatform().parseXmlFromString(schematron);
    const asserts = ctx.SaxonJS.XPath.evaluate('//sch:assert', document, {
      // prettier-ignore
      namespaceContext: { sch: 'http://purl.oclc.org/dsdl/schematron' }, //NOSONAR
      resultForm: 'array',
    });
    return asserts.map((assert: any) => ({
      id: assert.getAttribute('id'),
      message: assert.textContent,
      role: assert.getAttribute('role'),
      fedrampSpecific: assert.getAttribute('fedramp:specific') === 'true',
    }));
  };

// Wrapper over an XSLT transform that logs and re-rasies errors.
const transform = async (SaxonJS: any, options: any) => {
  try {
    return SaxonJS.transform(options, 'async') as Promise<DocumentFragment>;
  } catch (error) {
    console.error(error);
    throw new Error(`Error transforming xml: ${error}`);
  }
};

/**
 * Given XSLT in SEF format and an input XML document, return a string of the
 * transformed XML.
 **/
export const SaxonJsProcessor =
  (ctx: { SaxonJS: any }): XSLTProcessor =>
  (stylesheetText: string, sourceText: string) => {
    try {
      return transform(ctx.SaxonJS, {
        stylesheetText,
        sourceText,
        destination: 'serialized',
        stylesheetParams: {},
      }).then((output: any) => {
        return output.principalResult as string;
      });
    } catch (error) {
      console.error(error);
      throw new Error(`Error transforming xml: ${error}`);
    }
  };

export const SaxonJsJsonOscalToXmlProcessor =
  (ctx: {
    console: Console;
    sefUrl: string;
    SaxonJS: any;
  }): SchematronJSONToXMLProcessor =>
  (jsonString: string) => {
    const startTime = performance.now();
    return base64DataUriForJson(jsonString)
      .then(base64Json =>
        ctx.SaxonJS.transform(
          {
            stylesheetLocation: ctx.sefUrl,
            destination: 'serialized',
            initialTemplate: 'from-json',
            stylesheetParams: {
              file: base64Json,
            },
          },
          'async',
        ),
      )
      .then((output: any) => {
        const elapsed = formatElapsedTime(performance.now() - startTime);
        ctx.console.log(
          `JSON to XML conversion completed in ${elapsed} (HH:MM:SS)`,
        );
        return output.principalResult as string;
      });
  };

const parseScenarioNode = (scenario: any): XSpecScenarioNode => {
  const nodes = Array.from(scenario.childNodes) as any[];
  const children = nodes
    .map((childNode: any): XSpecNode | null => {
      if (childNode.nodeName === 'x:context') {
        return {
          node: 'x:context',
          context: childNode.childNodes[1].toString(),
        };
      }
      if (childNode.nodeName === 'x:expect-not-assert') {
        return {
          node: 'x:expect-not-assert',
          id: safeGetAttribute(childNode, 'id'),
          label: safeGetAttribute(childNode, 'label'),
        };
      }
      if (childNode.nodeName === 'x:expect-assert') {
        return {
          node: 'x:expect-assert',
          id: safeGetAttribute(childNode, 'id'),
          label: safeGetAttribute(childNode, 'label'),
        };
      }
      if (childNode.nodeName === 'x:scenario') {
        return parseScenarioNode(childNode);
      }
      return null;
    })
    .filter((node: any) => node) as XSpecNode[];
  return {
    node: 'x:scenario',
    label: safeGetAttribute(scenario, 'label'),
    children,
  };
};

export const SaxonJsXSpecParser =
  (ctx: { SaxonJS: any }): ParseXSpec =>
  (xmlString: string) => {
    const document = ctx.SaxonJS.getPlatform().parseXmlFromString(xmlString);
    const scenarios = ctx.SaxonJS.XPath.evaluate(
      '/x:description/x:scenario',
      document,
      {
        namespaceContext: { x: 'http://www.jenitennison.com/xslt/xspec' },
        resultForm: 'array',
      },
    );
    return scenarios.map((node: any) => parseScenarioNode(node));
  };
