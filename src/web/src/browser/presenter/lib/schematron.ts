import type { AssertionView } from '@asap/shared/use-cases/assertion-views';
import type {
  SchematronAssert,
  FailedAssert,
} from '@asap/shared/use-cases/schematron';
import type { FailedAssertionMap } from './validator';

// Schematron rules meta-data
export type SchematronUIConfig = {
  assertionViews: AssertionView[];
  schematronAsserts: SchematronAssert[];
};

export type Role = string;

export type SchematronFilter = {
  role: Role;
  text: string;
  assertionViewId: number;
};

export type SchematronFilterOptions = {
  assertionViews: {
    index: number;
    title: string;
    count: number;
  }[];
  roles: {
    name: Role;
    subtitle: string;
    count: number;
  }[];
};

type AssertionMap = {
  [assertionId: string]: SchematronAssert;
};

type Icon = {
  sprite: string;
  color: string;
};
const checkCircleIcon: Icon = { sprite: 'check_circle', color: 'green' };
const navigateNextIcon: Icon = { sprite: 'navigate_next', color: 'blue' };
const cancelIcon: Icon = {
  sprite: 'cancel',
  color: 'red',
};

export type SchematronReport = {
  summary: {
    title: string;
    subtitle: string;
    counts: {
      assertions: number;
    };
  };
  groups: {
    title: string;
    checks: {
      summary: string;
      summaryColor: 'red' | 'green';
      checks: (SchematronAssert & {
        icon: Icon;
        fired: FailedAssert[];
      })[];
    };
  }[];
};

export const getSchematronReport = ({
  config,
  filter,
  filterOptions,
  validator,
}: {
  config: SchematronUIConfig;
  filter: SchematronFilter;
  filterOptions: SchematronFilterOptions;
  validator: {
    failedAssertionMap: FailedAssertionMap | null;
    title: string;
  };
}) => {
  const assertionView = filterOptions.assertionViews
    .filter(view => view.index === filter.assertionViewId)
    .map(() => {
      return config.assertionViews[filter.assertionViewId];
    })[0] || {
    title: '',
    groups: [],
  };

  const schematronChecksFiltered = filterAssertions(
    config.schematronAsserts,
    {
      role: filter.role,
      text: filter.text,
      assertionViewIds: assertionView.groups
        .map(group => group.assertionIds)
        .flat(),
    },
    filterOptions.roles.map(role => role.name),
  );

  return {
    summary: {
      title: validator.title,
      subtitle: assertionView.title,
      counts: {
        assertions: schematronChecksFiltered.length,
      },
    },
    groups: getReportGroups(
      assertionView,
      schematronChecksFiltered,
      validator.failedAssertionMap,
    ),
  };
};

export const getReportGroups = (
  assertionView: AssertionView,
  schematronAssertions: SchematronAssert[],
  failedAssertionMap: FailedAssertionMap | null,
): SchematronReport['groups'] => {
  const assertionsById = getAssertionsById(schematronAssertions);
  return assertionView.groups
    .map(assertionGroup => {
      type UiAssert = SchematronAssert & {
        message: string;
        icon: Icon;
        fired: FailedAssert[];
      };
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
                ? navigateNextIcon
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
        checks: {
          summary: (() => {
            if (failedAssertionMap) {
              return `${firedCount} / ${checks.length} triggered`;
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
    role: Role;
    text: string;
    assertionViewIds: string[];
  },
  roleOptions: Role[],
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
  return assertions;
};

const getAssertionsById = (asserts: SchematronAssert[]) => {
  const assertions: AssertionMap = {};
  asserts.forEach(assert => {
    assertions[assert.id] = assert;
  });
  return assertions;
};

export const getFilterOptions = ({
  config,
  filter,
}: {
  config: SchematronUIConfig;
  filter: SchematronFilter;
}) => {
  const availableRoles = Array.from(
    new Set(config.schematronAsserts.map(assert => assert.role)),
  );
  const assertionViews = config.assertionViews.map((view, index) => {
    return {
      index,
      title: view.title,
    };
  });
  const assertionView = assertionViews
    .filter(view => view.index === filter.assertionViewId)
    .map(() => {
      return config.assertionViews[filter.assertionViewId];
    })[0] || {
    title: '',
    groups: [],
  };
  const assertionViewIds = assertionView.groups
    .map(group => group.assertionIds)
    .flat();
  return {
    assertionViews: assertionViews.map(view => ({
      ...view,
      count: filterAssertions(
        config.schematronAsserts,
        {
          role: filter.role,
          text: filter.text,
          assertionViewIds: config.assertionViews[view.index].groups.flatMap(
            group => group.assertionIds,
          ),
        },
        availableRoles,
      ).length,
    })),
    roles: [
      ...['all', ...availableRoles.sort()].map((role: Role) => {
        return {
          name: role,
          subtitle:
            {
              all: 'View all rules',
              error: 'View required, critical rules',
              fatal: 'View rules required for rule validation',
              information: 'View optional rules',
              warning: 'View suggested rules',
            }[role] || '',
          count: filterAssertions(
            config.schematronAsserts,
            {
              role,
              text: filter.text,
              assertionViewIds,
            },
            availableRoles,
          ).length,
        };
      }),
    ],
  };
};
