import { getXSpecScenarioSummaries } from './xspec';

describe('xspec', () => {
  it('summary generation works', async () => {
    const result = await getXSpecScenarioSummaries(
      MOCK_XSPEC,
      (xml: string) => xml,
    );
    expect(result).toEqual([
      {
        assertionId: 'assertion-1',
        context: '<child1></child1>',
        label: 'parent 1 middle parent child 1',
      },
      {
        assertionId: 'assertion-2',
        context: '<child2></child2>',
        label: 'parent 1 middle parent child 2',
      },
      {
        assertionId: 'assertion-3',
        context: '<child3></child3>',
        label: 'child 3',
      },
    ]);
  });
});

const MOCK_XSPEC = {
  scenarios: [
    {
      label: 'parent 1',
      scenarios: [
        {
          label: 'middle parent',
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
