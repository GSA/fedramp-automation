const fs = require('fs/promises');
const path = require('path');

// Import the node.js version of SaxonJS. If you loaded SaxonJS via a script
// tag for usage in the browser, it would be available at `window.SaxonJS`.
const SaxonJS = require('saxon-js');

/** Location of baseline 800-53rev4 definitions */
const BASELINES_PATH = path.resolve('../../../dist/content/rev4/baselines/xml');

/** Location of resource values */
const RESOURCES_PATH = path.resolve('../../../dist/content/rev4/resources/xml');

/** Path to compiled Schematron XSLT validation rules */
const COMPILED_XSLT = {
  ssp: path.resolve('/tmp/ssp.sef.json'),
  sap: path.resolve('/tmp/sap.sef.json'),
  sar: path.resolve('/tmp/sar.sef.json'),
  poam: path.resolve('/tmp/poam.sef.json'),
};

/**
 * Validates the provided OSCAL document. Supports SSP, SAP, SAR, and POA&M.
 * @param {string} documentPath OSCAL document to validate
 * @returns Object containing failed assertions and successful reported values
 */
const validateOscalDocument = async documentPath => {
  // Create a SaxonJS resource object for the given XML
  // This method utilizes node.js file system support in SaxonJS.
  // For alternate methods of loading the file, see the documentation:
  // https://www.saxonica.com/saxon-js/documentation2/index.html#!api/getResource
  const resource = await SaxonJS.getResource({
    file: documentPath,
    type: 'xml',
  });

  // Based on the root node of the document, determine the OSCAL document type
  // and the corresponding XSLT rules document.
  const documentType = {
    'plan-of-action-and-milestones': 'poam',
    'assessment-plan': 'sap',
    'assessment-results': 'sar',
    'system-security-plan': 'ssp',
  }[resource.documentElement.nodeName];
  const stylesheetLocation = COMPILED_XSLT[documentType];

  // Apply the appropriate Schematron XSLT to the document. Because we chose
  // destination = document, svrlOutput.principalResult will be a document
  // fragment.
  const svrlOutput = await SaxonJS.transform(
    {
      stylesheetLocation,
      destination: 'document',
      sourceNode: resource,
      stylesheetParams: {
        'baselines-base-path': BASELINES_PATH,
        'registry-base-path': RESOURCES_PATH,
        'param-use-remote-resources': '1',
      },
    },
    'async',
  );
  const document = svrlOutput.principalResult;

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

  // Extract relevant values out of provided XML nodes, and return.
  return {
    failedAsserts: Array.prototype.map.call(failedAsserts, assert => {
      return Object.keys(assert.attributes).reduce(
        (assertMap, key) => {
          const name = assert.attributes[key].name;
          if (name) {
            assertMap[name] = assert.attributes[key].value;
          }
          return assertMap;
        },
        {
          diagnosticReferences: Array.prototype.map.call(
            SaxonJS.XPath.evaluate('svrl:diagnostic-reference', assert, {
              namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' },
              resultForm: 'array',
            }),
            node => node.textContent,
          ),
          text: SaxonJS.XPath.evaluate('svrl:text', assert, {
            namespaceContext: { svrl: 'http://purl.oclc.org/dsdl/svrl' },
          }).textContent,
        },
      );
    }),
    successfulReports: Array.prototype.map.call(successfulReports, report => {
      return Object.keys(report.attributes).reduce(
        (assertMap, key) => {
          const name = report.attributes[key].name;
          if (name) {
            assertMap[name] = report.attributes[key].value;
          }
          return assertMap;
        },
        {
          text: SaxonJS.XPath.evaluate('svrl:text', report, {
            namespaceContext: {
              svrl: 'http://purl.oclc.org/dsdl/svrl',
            },
          }).textContent,
        },
      );
    }),
  };
};

module.exports = {
  validateOscalDocument,
};
