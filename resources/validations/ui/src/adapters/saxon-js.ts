import type {
  SchematronValidationReportGateway,
  ValidationAssert,
  ValidationReport,
} from '../use-cases/validate-ssp-xml';

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

type SaxonJsSchematronValidationReportGatewayContext = {
  sefUrl: string;
  SaxonJS: any;
};

export const SaxonJsSchematronValidationReportGateway =
  (
    ctx: SaxonJsSchematronValidationReportGatewayContext,
  ): SchematronValidationReportGateway =>
  (sourceText: string) => {
    return (
      ctx.SaxonJS.transform(
        {
          stylesheetLocation: ctx.sefUrl,
          destination: 'document',
          sourceText: sourceText,
          collectionFinder: (url: string) => [],
        },
        'async',
      ) as Promise<DocumentFragment>
    ).then((output: any) => {
      return getValidationReport(output.principalResult as DocumentFragment);
    });
  };
