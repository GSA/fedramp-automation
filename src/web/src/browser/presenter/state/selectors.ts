import { createSelector, defaultMemoize as memoize } from 'reselect';

import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { State } from '.';
import { filterAssertions, getReportGroups } from './helpers';
import { FilterOptions, PassStatus, Role } from './schematron-machine';
import { AssertionView } from '@asap/shared/use-cases/assertion-views';

const selectOscalDocument = memoize(
  (documentType: OscalDocumentKey) => (state: State) =>
    state.oscalDocuments[documentType],
);

export const selectValidationResult = memoize(
  (documentType: OscalDocumentKey) => (state: State) =>
    state.validationResults[documentType],
);
const selectFilter = memoize(
  (documentType: OscalDocumentKey) => (state: State) =>
    state.oscalDocuments[documentType].filter,
);

const selectFailedAssertionMap = memoize((documentType: OscalDocumentKey) =>
  createSelector(selectValidationResult(documentType), validationResult =>
    validationResult.current !== 'NO_RESULTS'
      ? validationResult.assertionsById
      : null,
  ),
);

const selectOscalDocumentConfig = memoize((documentType: OscalDocumentKey) =>
  createSelector(
    selectOscalDocument(documentType),
    oscalDocument => oscalDocument.config,
  ),
);

export const selectFilterOptions = memoize((documentType: OscalDocumentKey) =>
  createSelector(
    selectOscalDocumentConfig(documentType),
    selectFilter(documentType),
    selectFailedAssertionMap(documentType),
    selectAssertionViewIds(documentType),
    (config, filter, failedAssertionMap, assertionViewIds): FilterOptions => {
      const availableRoles = Array.from(
        new Set(config.schematronAsserts.map(assert => assert.role)),
      );
      return {
        assertionViews: config.assertionViews.map((view, index) => ({
          ...view,
          index,
          count: filterAssertions(
            config.schematronAsserts,
            {
              passStatus: filter.passStatus,
              role: filter.role,
              text: filter.text,
              assertionViewIds: (
                config.assertionViews[index] as AssertionView
              ).groups.flatMap(group => group.assertionIds),
            },
            availableRoles,
            failedAssertionMap,
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
                  passStatus: filter.passStatus,
                  role,
                  text: filter.text,
                  assertionViewIds,
                },
                availableRoles,
                failedAssertionMap,
              ).length,
            };
          }),
        ],
        passStatuses: [
          {
            id: 'all' as PassStatus,
            title: 'All assertions',
            enabled: failedAssertionMap !== null,
            count: filterAssertions(
              config.schematronAsserts,
              {
                passStatus: 'all',
                role: filter.role,
                text: filter.text,
                assertionViewIds,
              },
              availableRoles,
              failedAssertionMap,
            ).length,
          },
          {
            id: 'pass' as PassStatus,
            title: 'Passing assertions',
            enabled: failedAssertionMap !== null,
            count: filterAssertions(
              config.schematronAsserts,
              {
                passStatus: 'pass',
                role: filter.role,
                text: filter.text,
                assertionViewIds,
              },
              availableRoles,
              failedAssertionMap,
            ).length,
          },
          {
            id: 'fail' as PassStatus,
            title: 'Failing assertions',
            enabled: failedAssertionMap !== null,
            count: filterAssertions(
              config.schematronAsserts,
              {
                passStatus: 'fail',
                role: filter.role,
                text: filter.text,
                assertionViewIds,
              },
              availableRoles,
              failedAssertionMap,
            ).length,
          },
        ],
      };
    },
  ),
);

const selectAssertionViewIds = memoize((documentType: OscalDocumentKey) =>
  createSelector(
    selectOscalDocumentConfig(documentType),
    selectFilter(documentType),
    (config, filter) => {
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
      return assertionView.groups.map(group => group.assertionIds).flat();
    },
  ),
);

export const selectSchematronReport = memoize(
  (documentType: OscalDocumentKey) =>
    createSelector(
      selectOscalDocumentConfig(documentType),
      selectFilter(documentType),
      selectFilterOptions(documentType),
      selectValidationResult(documentType),
      (config, filter, filterOptions, validationResult) => {
        const assertionView = filterOptions.assertionViews
          .filter(view => view.index === filter.assertionViewId)
          .map(() => {
            return config.assertionViews[filter.assertionViewId];
          })[0] || {
          title: '',
          groups: [],
        };

        const failedAssertionMap =
          validationResult.current !== 'NO_RESULTS'
            ? validationResult.assertionsById
            : null;

        const schematronChecksFiltered = filterAssertions(
          config.schematronAsserts,
          {
            passStatus: filter.passStatus,
            role: filter.role,
            text: filter.text,
            assertionViewIds: assertionView.groups
              .map(group => group.assertionIds)
              .flat(),
          },
          filterOptions.roles.map(role => role.name),
          failedAssertionMap,
        );

        return {
          groups: getReportGroups(
            assertionView,
            schematronChecksFiltered,
            failedAssertionMap,
          ),
          assertionCount: schematronChecksFiltered.length,
        };
      },
    ),
);
