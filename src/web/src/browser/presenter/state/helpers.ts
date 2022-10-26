import type {
  SchematronAssert,
  FailedAssert,
} from '@asap/shared/domain/schematron';
import type { AssertionView } from '@asap/shared/use-cases/assertion-views';

import * as state from '../state/schematron-machine';
import { FailedAssertionMap } from '../state/validation-results-machine';

type Icon = {
  sprite: string;
  color: string;
};
const checkCircleIcon: Icon = { sprite: 'check_circle', color: 'green' };
const removeIcon: Icon = { sprite: 'remove', color: 'black' };
const cancelIcon: Icon = {
  sprite: 'cancel',
  color: 'red',
};

export type SchematronReportGroups = {
  title: string;
  isValidated: boolean;
  checks: {
    summary: string;
    summaryColor: 'red' | 'green';
    checks: (SchematronAssert & {
      icon: Icon;
      fired: FailedAssert[];
      referenceUrl: string;
    })[];
  };
}[];

export const getReportGroups = (
  assertionView: AssertionView,
  schematronAssertions: SchematronAssert[],
  failedAssertionMap: FailedAssertionMap | null,
): SchematronReportGroups => {
  const assertionsById = getAssertionsById(schematronAssertions);
  return assertionView.groups
    .map(assertionGroup => {
      type UiAssert = SchematronAssert & {
        message: string;
        icon: Icon;
        fired: FailedAssert[];
        referenceUrl: string;
      };
      const isValidated = failedAssertionMap !== null;

      const checks = assertionGroup.assertionIds
        .map(assertionGroupAssert => {
          const assert = assertionsById[assertionGroupAssert];
          if (!assert) {
            return null;
          }
          const fired = (failedAssertionMap || {})[assert.id] || [];
          return {
            ...assert,
            icon:
              failedAssertionMap === null
                ? removeIcon
                : fired.length
                ? cancelIcon
                : checkCircleIcon,
            fired,
          };
        })
        .filter(
          (assert: UiAssert | null): assert is UiAssert => assert !== null,
        );
      const firedCount = checks.filter(
        assert => assert.fired.length > 0,
      ).length;

      return {
        title: assertionGroup.title,
        isValidated,
        checks: {
          summary: (() => {
            if (failedAssertionMap) {
              return `${firedCount} / ${checks.length} flagged`;
            } else {
              return `${checks.length} checks`;
            }
          })(),
          summaryColor: (firedCount === 0 ? 'green' : 'red') as 'red' | 'green',
          checks,
        },
      };
    })
    .filter(group => group.checks.checks.length > 0);
};

export const filterAssertions = (
  schematronAsserts: SchematronAssert[],
  filter: {
    passStatus: state.PassStatus;
    role: state.Role;
    text: string;
    assertionViewIds: string[];
    fedrampSpecific: state.FedRampSpecific;
  },
  roleOptions: state.Role[],
  failedAssertionMap: FailedAssertionMap | null,
) => {
  const filterRoles =
    filter.role === 'all' ? roleOptions.map(role => role) : filter.role;
  let assertions = schematronAsserts.filter((assertion: SchematronAssert) => {
    return filterRoles.includes(assertion.role || '');
  });
  if (filter.text.length > 0) {
    assertions = assertions.filter(assert => {
      const searchText = assert.message.toLowerCase();
      return searchText.includes(filter.text.toLowerCase());
    });
  }
  assertions = assertions.filter(assert =>
    filter.assertionViewIds.includes(assert.id),
  );
  if (failedAssertionMap && filter.passStatus !== 'all') {
    assertions = assertions.filter(assert => {
      const failed = !!failedAssertionMap[assert.id];
      return (
        (filter.passStatus === 'fail' && failed) ||
        (filter.passStatus === 'pass' && !failed)
      );
    });
  }
  if (filter.fedrampSpecific !== 'all') {
    assertions = assertions.filter(assert => {
      return (
        (filter.fedrampSpecific === 'fedramp' && assert.fedrampSpecific) ||
        (filter.fedrampSpecific === 'non-fedramp' && !assert.fedrampSpecific)
      );
    });
  }

  return assertions;
};

const getAssertionsById = (asserts: SchematronAssert[]) => {
  type AssertionMap = {
    [assertionId: string]: SchematronAssert;
  };
  const assertions: AssertionMap = {};
  asserts.forEach(assert => {
    assertions[assert.id] = assert;
  });
  return assertions;
};
