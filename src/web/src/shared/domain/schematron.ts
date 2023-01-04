/**
 * Core Schematron logic used in the application.
 */

import { getBlobFileUrl, GithubRepository } from './github';
import type { OscalDocumentKey } from './oscal';
import { LineRange, linesOf } from './text';

export type FailedAssert = {
  uniqueId: string;
  id: string;
  location: string;
  role?: string;
  see?: string;
  test: string;
  text: string;
  diagnosticReferences: string[];
};
export type SuccessfulReport = {
  uniqueId: string;
  id: string;
  location: string;
  role?: string;
  test: string;
  text: string;
};
export type SchematronResult = {
  failedAsserts: FailedAssert[];
  svrlString: string;
  successfulReports: SuccessfulReport[];
};
export type ValidationReport = {
  title: string;
  failedAsserts: FailedAssert[];
};

export type SchematronJSONToXMLProcessor = (
  jsonString: string,
) => Promise<string>;

export type SchematronJSONToXMLProcessors = Record<
  OscalDocumentKey,
  SchematronJSONToXMLProcessor
>;

export type SchematronProcessor = (oscalXmlString: string) => Promise<{
  documentType: OscalDocumentKey;
  schematronResult: SchematronResult;
}>;

// See the concrete implementation in project-config.ts
export type SchematronRuleset = {
  // The key corresponds to the directory used in the project structure,
  // such as "rev4"
  key: SchematronRulesetKey;
  // The title for this ruleset is displayed in the user interface
  title: string;
  description?: string;
};

// Define these in priority order - ie, the most-recent (or most-relevant)
// ruleset should be first in the list.
export const SchematronRulesetKeys = ['rev4'] as const;
export type SchematronRulesetKey = typeof SchematronRulesetKeys[number];

export const SCHEMATRON_RULESETS: Record<
  SchematronRulesetKey,
  SchematronRuleset
> = {
  /*rev5: {
    key: 'rev5',
    title: 'NIST RMF revision 5',
    description: '',
  },*/
  rev4: {
    key: 'rev4',
    title: 'NIST RMF revision 4',
    //description: 'The latest NIST RMF is rev5',
    description: '',
  },
} as const;

export type SchematronProcessors = Record<
  SchematronRuleset['key'],
  SchematronProcessor
>;

export type SchematronAssert = {
  id: string;
  message: string;
  role: string;
  referenceUrl: string;
  fedrampSpecific: boolean;
};

export type ParseSchematronAssertions = (
  schematron: string,
) => SchematronAssert[];
export type GetSchematronAssertions = (
  rulesetKey: SchematronRulesetKey,
) => Promise<{
  poam: SchematronAssert[];
  sap: SchematronAssert[];
  sar: SchematronAssert[];
  ssp: SchematronAssert[];
}>;

export class SchematronSummaryGenerator {}

export const getSchematronAssertLineRanges = (xml: string) => {
  const regExp = new RegExp(
    `<sch:assert[^]*?\\sid=\\"([^\\"]+)\\"[^]*?</sch:assert>`,
    'g',
  );
  const matches = xml.matchAll(regExp);

  const lineNumbers: Record<string, LineRange> = {};
  for (const match of matches) {
    const elementString = match[0];
    const idAttribute = match[1];
    lineNumbers[idAttribute] = linesOf(xml, elementString);
  }
  return lineNumbers;
};

export const generateSchematronSummary = (
  schXml: string,
  asserts: SchematronAssert[],
  github: GithubRepository,
  repositoryPath: `/${string}`,
) => {
  const lineRanges = getSchematronAssertLineRanges(schXml);
  return asserts.map(assert => {
    const lineRange = lineRanges[assert.id];
    if (!lineRange) {
      return {
        ...assert,
        referenceUrl: getBlobFileUrl(github, repositoryPath),
      };
    }
    return {
      ...assert,
      referenceUrl: getBlobFileUrl(github, repositoryPath, lineRange),
    };
  });
};
