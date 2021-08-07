import { fold } from 'fp-ts/Either';
import { pipe } from 'fp-ts/lib/function';
import * as t from 'io-ts';

export type AssertionGroup = {
  title: string;
  assertionIds: string[];
  groups: Array<AssertionGroup> | undefined;
};

const AssertionGroup: t.Type<AssertionGroup> = t.recursion(
  'AssertionGroup',
  () =>
    t.type({
      title: t.string,
      assertionIds: t.array(t.string),
      groups: t.union([t.array(AssertionGroup), t.undefined]),
    }),
);

const AssertionView = t.type({
  title: t.string,
  groups: t.array(AssertionGroup),
});
export type AssertionView = t.TypeOf<typeof AssertionView>;

const AssertionViews = t.array(AssertionView);
type AssertionViews = t.TypeOf<typeof AssertionViews>;

export const validateAssertionViews = (input: any): AssertionViews | null => {
  return pipe(
    AssertionViews.decode(input),
    fold(
      () => null,
      value => value,
    ),
  );
};

export type GetAssertionViews = () => Promise<AssertionViews>;
