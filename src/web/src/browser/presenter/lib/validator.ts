import type { FailedAssert } from '@asap/shared/use-cases/schematron';

export type FailedAssertionMap = { [assertionId: string]: FailedAssert[] };
