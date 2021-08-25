import type { FailedAssert } from '@asap/shared/use-cases/schematron';

export type FailedAssertionMap = Record<FailedAssert['id'], FailedAssert[]>;

export const getAssertionsById = ({
  failedAssertions,
}: {
  failedAssertions: FailedAssert[];
}) => {
  return failedAssertions.reduce((acc, assert) => {
    if (acc[assert.id] === undefined) {
      acc[assert.id] = [];
    }
    acc[assert.id].push(assert);
    return acc;
  }, {} as FailedAssertionMap);
};
