/**
 * This module includes extra tests that confirm some general requirements of
 * the project that reside outside application code.
 */

import fs from 'fs/promises';

import { describe, expect, it } from 'vitest';

import { version as npmSaxonVersion } from '../node_modules/saxon-js/package.json';

describe('Saxon-JS', () => {
  /**
   * The node.js version of SaxonJS is specified in:
   *  src/web/package.json
   * The browser version of SaxonJS is vendored at:
   *  src/web/public/SaxonJS2.rt.js.
   *
   * There will be confusion if these versions get out of sync, so this test
   * verifies that the two references are to the same version.
   *
   * NOTE: If this test is failing because you updated the version of SaxonJS
   * in package.json, download the browser version and check it into the
   * repository. See: https://www.saxonica.com/download/javascript.xml
   *
   * You may also want to check if Saxonica has improved their distribution
   * method to include the browser version in the npm package, in which case
   * this separate treatment could be deprecated.
   */
  it('node.js version is the same as browser version', async () => {
    const browserString = await fs.readFile('public/SaxonJS2.rt.js', 'utf-8');
    const browserMatch = browserString.match(/"product-version":"([\d\.]+)"/);

    expect(browserMatch).not.toBeNull();
    if (browserMatch === null) {
      return;
    }
    const browserSaxonVersion = browserMatch[1];

    // browserSaxonVersion include the minor version. eg: 2.4
    // the node.js version also includes the patch version. eg: 2.4.0
    // confirm that, at least, the minor versions match.
    expect(npmSaxonVersion.startsWith(browserSaxonVersion)).toBeTruthy();
  });
});
