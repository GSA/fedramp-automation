import { getXSpecScenarioSummaries } from './xspec';

describe('xspec', () => {
  it('summary generation works', async () => {
    const result = await getXSpecScenarioSummaries(
      MOCK_XSPEC,
      (xml: string) => xml,
    );
    expect(result).toEqual({
      'assertion-1': [
        {
          assertionId: 'assertion-1',
          assertionLabel: 'assertion-1 label',
          context: '<child1></child1>',
          label: 'parent 1 middle parent child 1',
        },
      ],
      'assertion-2': [
        {
          assertionId: 'assertion-2',
          assertionLabel: 'assertion-2 label',
          context: '<child2></child2>',
          label: 'parent 1 middle parent child 2',
        },
      ],
      'assertion-3': [
        {
          assertionId: 'assertion-3',
          assertionLabel: 'assertion-3 label',
          context: '<child3></child3>',
          label: 'child 3',
        },
      ],
      'assertion-4': [
        {
          assertionId: 'assertion-4',
          assertionLabel: 'assertion-4 label',
          context: '<middle-parent-context></middle-parent-context>',
          label: 'parent 1 middle parent child 4 no context',
        },
      ],
    });
  });
});

const MOCK_XSPEC = {
  scenarios: [
    {
      label: 'parent 1',
      scenarios: [
        {
          label: 'middle parent',
          context: '<middle-parent-context></middle-parent-context>',
          scenarios: [
            {
              label: 'child 1',
              context: '<child1></child1>',
              expectAssert: [
                {
                  id: 'assertion-1',
                  label: 'assertion-1 label',
                },
              ],
            },
            {
              label: 'child 2',
              context: '<child2></child2>',
              expectNotAssert: [
                {
                  id: 'assertion-2',
                  label: 'assertion-2 label',
                },
              ],
            },
            {
              label: 'child 4 no context',
              expectNotAssert: [
                {
                  id: 'assertion-4',
                  label: 'assertion-4 label',
                },
              ],
            },
          ],
        },
      ],
    },
    {
      label: 'child 3',
      context: '<child3></child3>',
      expectNotAssert: [
        {
          id: 'assertion-3',
          label: 'assertion-3 label',
        },
      ],
    },
  ],
};
