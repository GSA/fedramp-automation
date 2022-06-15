import { it, describe, expect } from 'vitest';

import { validateAssertionViews } from './assertion-views';

describe('assertion view parser', () => {
  it('returns valid object', () => {
    expect(
      validateAssertionViews([
        {
          title: 'assertion view title',
          groups: [
            {
              title: 'group title',
              assertionIds: ['assertion id 1', 'assertion id 2'],
              groups: [
                {
                  title: 'subgroup title',
                  assertionIds: ['assertion id 3', 'assertion id 4'],
                },
                {
                  title: 'subgroup title 2',
                  assertionIds: ['assertion id 5', 'assertion id 6'],
                  groups: [],
                },
                {
                  title: 'subgroup title 3',
                  assertionIds: ['assertion id 7', 'assertion id 8'],
                  groups: [
                    {
                      title: 'subgroup title 4',
                      assertionIds: ['assertion id 9', 'assertion id 10'],
                    },
                  ],
                },
              ],
            },
          ],
        },
      ]),
    ).toEqual([
      {
        groups: [
          {
            assertionIds: ['assertion id 1', 'assertion id 2'],
            groups: [
              {
                assertionIds: ['assertion id 3', 'assertion id 4'],
                groups: undefined,
                title: 'subgroup title',
              },
              {
                assertionIds: ['assertion id 5', 'assertion id 6'],
                groups: [],
                title: 'subgroup title 2',
              },
              {
                assertionIds: ['assertion id 7', 'assertion id 8'],
                groups: [
                  {
                    assertionIds: ['assertion id 9', 'assertion id 10'],
                    groups: undefined,
                    title: 'subgroup title 4',
                  },
                ],
                title: 'subgroup title 3',
              },
            ],
            title: 'group title',
          },
        ],
        title: 'assertion view title',
      },
    ]);
  });
  it('returns null for invalid object', () => {
    expect(validateAssertionViews({})).toEqual(null);
  });
});
