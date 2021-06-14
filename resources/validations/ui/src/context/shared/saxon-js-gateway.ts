import type {
  SchematronValidator,
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/schematron';

const getValidationReport = (
  SaxonJS: any,
  document: DocumentFragment,
): ValidationReport => {
  let failedAsserts = SaxonJS.XPath.evaluate('//svrl:failed-assert', document, {
    namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' },
    resultForm: 'array',
  });
  return {
    failedAsserts: Array.prototype.map.call(failedAsserts, assert => {
      return Object.keys(assert.attributes).reduce(
        (assertMap: Record<string, ValidationAssert>, key: string) => {
          const name = assert.attributes[key].name;
          if (name) {
            assertMap[assert.attributes[key].name] =
              assert.attributes[key].value;
          }
          return assertMap;
        },
        {
          text: assert.textContent,
        },
      );
    }) as ValidationAssert[],
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
          collectionFinder: (url: string) => [],
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
