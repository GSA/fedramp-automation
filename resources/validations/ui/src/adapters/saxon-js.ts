// @ts-nocheck
// The npm version of saxon-js is for node; currently, we load the browser
// version via a script tag in index.html.

export const transform = (options: { sourceText: string }) => {
  return window.SaxonJS.transform(
    {
      stylesheetLocation: '/validations/ssp.sef.json',
      destination: 'serialized',
      sourceText: options.sourceText,
      collectionFinder: _ => [],
    },
    'async',
  ).then(output => {
    return output.principalResult as string;
  });
};
