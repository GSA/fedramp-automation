/**
 * This is a simple test that will validate each of the four FedRAMP example
 * documents and assert that SVRL results were returned.
 */
const assert = require('assert');
const path = require('path');

const { validateOscalDocument } = require('./validator');

/** OSCAL example documents */
const TEMPLATES = {
  ssp: path.resolve(
    '../../../dist/content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml',
  ),
  sap: path.resolve(
    '../../../dist/content/rev4/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml',
  ),
  sar: path.resolve(
    '../../../dist/content/rev4/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml',
  ),
  poam: path.resolve(
    '../../../dist/content/rev4/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml',
  ),
};

const testDocumentValidation = async documentKey => {
  console.log(`Testing SaxonJS validation of ${documentKey} document...`);
  await validateOscalDocument(TEMPLATES[documentKey]).then(results => {
    assert(
      results.failedAsserts.length > 0,
      `${documentKey}: Expected non-zero failed asserts. Got: ${results.failedAsserts}`,
    );
  });
};

const test = async () => {
  await testDocumentValidation('ssp');
  await testDocumentValidation('sap');
  await testDocumentValidation('sar');
  await testDocumentValidation('poam');
};

test().then(() => console.log('done!'));
