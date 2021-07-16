import type { IndentXml } from '../..//domain/xml';
import type {
  ParseSchematronAssertions,
  SchematronValidator,
  FailedAssert,
  ValidationReport,
  SuccessfulReport,
} from '../../use-cases/schematron';

const getValidationReport = (
  SaxonJS: any,
  document: DocumentFragment,
): ValidationReport => {
  const failedAsserts = SaxonJS.XPath.evaluate(
    '//svrl:failed-assert',
    document,
    {
      namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' },
      resultForm: 'array',
    },
  );
  const successfulReports = SaxonJS.XPath.evaluate(
    '//svrl:successful-report',
    document,
    {
      namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' },
      resultForm: 'array',
    },
  );
  return {
    failedAsserts: Array.prototype.map.call(failedAsserts, (assert, index) => {
      console.log(
        Array.prototype.map.call(
          assert.querySelectorAll('diagnostic-reference'),
          (node: Node) => node.textContent,
        ),
      );
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
            assert.querySelectorAll('diagnostic-reference'),
            (node: Node) => node.textContent,
          ) as any,
          text: assert.querySelector('text').textContent,
          uniqueId: `${assert['id']}-${index}` as any,
        },
      );
    }) as FailedAssert[],
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
            text: report.querySelector('text').textContent,
            uniqueId: `${report['id']}-${index}` as any,
          },
        );
      },
    ) as SuccessfulReport[],
  };
};

type SaxonJsSchematronValidatorGatewayContext = {
  sefUrl: string;
  SaxonJS: any;
  baselinesBaseUrl: string;
  registryBaseUrl: string;
};

export const SaxonJsSchematronValidatorGateway =
  (ctx: SaxonJsSchematronValidatorGatewayContext): SchematronValidator =>
  (sourceText: string) => {
    return (
      ctx.SaxonJS.transform(
        {
          stylesheetLocation: ctx.sefUrl,
          destination: 'document',
          sourceText: sourceText,
          stylesheetParams: {
            'baselines-base-path': ctx.baselinesBaseUrl,
            'registry-base-path': ctx.registryBaseUrl,
          },
        },
        'async',
      ) as Promise<DocumentFragment>
    ).then((output: any) => {
      return getValidationReport(
        ctx.SaxonJS,
        output.principalResult as DocumentFragment,
      );
    });
  };

type XmlIndenterContext = {
  SaxonJS: any;
};

export const XmlIndenter =
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

export const SchematronParser =
  (ctx: { SaxonJS: any }): ParseSchematronAssertions =>
  (schematron: string) => {
    const document = ctx.SaxonJS.getPlatform().parseXmlFromString(schematron);
    const asserts = ctx.SaxonJS.XPath.evaluate(
      '//(sch:report|sch:assert)',
      document,
      {
        namespaceContext: { sch: 'http://purl.oclc.org/dsdl/schematron' },
        resultForm: 'array',
      },
    );
    return asserts.map((assert: any) => ({
      id: assert.getAttribute('id'),
      isReport: assert.nodeName === 'sch:report',
      message: assert.textContent,
      role: assert.getAttribute('role'),
    }));
  };
