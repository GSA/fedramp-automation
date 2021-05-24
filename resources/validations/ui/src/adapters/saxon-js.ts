// The npm version of saxon-js is for node; currently, we load the browser
// version via a script tag in index.html.

import type {
  ValidateSspXml,
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

export const transform: ValidateSspXml = (sourceText: string) => {
  return (window as any).SaxonJS.transform(
    {
      stylesheetLocation: '/validations/ssp.sef.json',
      destination: 'document',
      sourceText: sourceText,
      collectionFinder: (url: string) => [],
    },
    'async',
  ).then((output: any) => {
    return getValidationReport(output.principalResult as DocumentFragment);
  });
};
