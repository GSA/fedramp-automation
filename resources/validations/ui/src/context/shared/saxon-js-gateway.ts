import type {
  SchematronValidator,
  ValidationAssert,
  ValidationReport,
} from '../../use-cases/schematron';

const getValidationReport = (document: DocumentFragment): ValidationReport => {
  return {
    failedAsserts: Array.prototype.map.call(
      document.querySelectorAll('failed-assert'),
      assert => {
        return {
          id: assert.attributes.id.value,
          location: assert.attributes.location.value,
          role: assert.attributes.role && assert.attributes.role.value,
          see: assert.attributes.see && assert.attributes.see.value,
          test: assert.attributes.test.value,
          text: assert.textContent,
        };
      },
    ) as ValidationAssert[],
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
      return getValidationReport(output.principalResult as DocumentFragment);
    });
  };
