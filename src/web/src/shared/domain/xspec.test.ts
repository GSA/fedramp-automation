import SaxonJS from 'saxon-js';

import { it, describe, expect } from 'vitest';
import { SaxonJsXSpecParser } from '../adapters/saxon-js-gateway';
import { XSPEC_REPOSITORY_PATHS } from '../project-config';
import { GithubRepository } from './github';

import { getXSpecScenarioSummaries } from './xspec';

describe('xspec', () => {
  it('summary generation works', async () => {
    const mockXSpec = SaxonJsXSpecParser({ SaxonJS })(MOCK_XSPEC_XML);
    const github: GithubRepository = {
      owner: '18F',
      repository: 'fedramp-automation',
      branch: 'master',
      commit: 'commit-hash',
    };
    const summaries = await getXSpecScenarioSummaries(
      { formatXml: xml => xml },
      github,
      XSPEC_REPOSITORY_PATHS['poam'],
      mockXSpec,
      MOCK_XSPEC_XML,
    );
    expect(summaries).toEqual({
      'document-is-OSCAL-document': [
        {
          assertionId: 'document-is-OSCAL-document',
          assertionLabel: 'that is correct',
          context: `<plan-of-action-and-milestones xmlns="http://csrc.nist.gov/ns/oscal/1.0"/>`,
          expectAssert: false,
          referenceUrl: '#TODO',
          scenarios: [
            {
              label: 'sanity-checks',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L7-L55',
            },
            {
              label: 'when the root element',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L9-L54',
            },
            {
              label: 'is in OSCAL 1.0 namespace',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L11-L20',
            },
          ],
        },
        {
          assertionId: 'document-is-OSCAL-document',
          assertionLabel: 'that is an error',
          context: `<plan-of-action-and-milestones>
                        <!-- note lack of namespace -->
                    </plan-of-action-and-milestones>`,
          expectAssert: true,
          referenceUrl: '#TODO',
          scenarios: [
            {
              label: 'sanity-checks',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L7-L55',
            },
            {
              label: 'when the root element',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L9-L54',
            },
            {
              label: 'is not in OSCAL 1.0 namespace',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L21-L31',
            },
          ],
        },
      ],
      'document-is-plan-of-action-and-milestones': [
        {
          assertionId: 'document-is-plan-of-action-and-milestones',
          assertionLabel: 'that is correct',
          context: `<plan-of-action-and-milestones xmlns="http://csrc.nist.gov/ns/oscal/1.0"/>`,
          expectAssert: false,
          referenceUrl: '#TODO',
          scenarios: [
            {
              label: 'sanity-checks',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L7-L55',
            },
            {
              label: 'when the root element',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L9-L54',
            },
            {
              label: 'is plan-of-action-and-milestones',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L32-L41',
            },
          ],
        },
        {
          assertionId: 'document-is-plan-of-action-and-milestones',
          assertionLabel: 'that is an error',
          context: `<not-a-plan-of-action-and-milestones xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                        <!-- not the expected element -->
                    </not-a-plan-of-action-and-milestones>`,
          expectAssert: true,
          referenceUrl: '#TODO',
          scenarios: [
            {
              label: 'sanity-checks',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L7-L55',
            },
            {
              label: 'when the root element',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L9-L54',
            },
            {
              label: 'is not a plan-of-action-and-milestones',
              url: 'https://github.com/18F/fedramp-automation/blob/commit-hash/test#L42-L53',
            },
          ],
        },
      ],
    });
  });
});

const MOCK_XSPEC_XML = `<?xml version="1.0" encoding="UTF-8"?>
<x:description
    schematron="../../rules/poam.sch"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:x="http://www.jenitennison.com/xslt/xspec">
    <x:scenario
        label="sanity-checks">
        <x:scenario
            label="when the root element">
            <x:scenario
                label="is in OSCAL 1.0 namespace">
                <x:context>
                    <plan-of-action-and-milestones
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0" />
                </x:context>
                <x:expect-not-assert
                    id="document-is-OSCAL-document"
                    label="that is correct" />
            </x:scenario>
            <x:scenario
                label="is not in OSCAL 1.0 namespace">
                <x:context>
                    <plan-of-action-and-milestones>
                        <!-- note lack of namespace -->
                    </plan-of-action-and-milestones>
                </x:context>
                <x:expect-assert
                    id="document-is-OSCAL-document"
                    label="that is an error" />
            </x:scenario>
            <x:scenario
                label="is plan-of-action-and-milestones">
                <x:context>
                    <plan-of-action-and-milestones
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0" />
                </x:context>
                <x:expect-not-assert
                    id="document-is-plan-of-action-and-milestones"
                    label="that is correct" />
            </x:scenario>
            <x:scenario
                label="is not a plan-of-action-and-milestones">
                <x:context>
                    <not-a-plan-of-action-and-milestones
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                        <!-- not the expected element -->
                    </not-a-plan-of-action-and-milestones>
                </x:context>
                <x:expect-assert
                    id="document-is-plan-of-action-and-milestones"
                    label="that is an error" />
            </x:scenario>
        </x:scenario>
    </x:scenario>
</x:description>`;
