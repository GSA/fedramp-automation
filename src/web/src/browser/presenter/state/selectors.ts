import { createSelector, defaultMemoize as memoize } from 'reselect';

import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { AssertionView } from '@asap/shared/use-cases/assertion-views';

import { State } from '.';
import { filterAssertions, getReportGroups } from './helpers';
import {
  FedRampSpecific,
  FedRampSpecificOptions,
  FilterOptions,
  PassStatus,
  Role,
} from './ruleset/schematron-machine';
import { SchematronRulesetKey } from '@asap/shared/domain/schematron';

const selectOscalDocument = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    (state: State) =>
      state.rulesets[rulesetKey].oscalDocuments[documentType],
);

export const selectValidationResult = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    (state: State) =>
      state.rulesets[rulesetKey].validationResults[documentType],
);
const selectFilter = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    (state: State) =>
      state.rulesets[rulesetKey].oscalDocuments[documentType].filter,
);

const selectFailedAssertionMap = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    createSelector(
      selectValidationResult(documentType, rulesetKey),
      validationResult =>
        validationResult.current !== 'NO_RESULTS'
          ? validationResult.assertionsById
          : null,
    ),
);

const selectOscalDocumentConfig = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    createSelector(
      selectOscalDocument(documentType, rulesetKey),
      oscalDocument => oscalDocument.config,
    ),
);

export const selectFilterOptions = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    createSelector(
      selectOscalDocumentConfig(documentType, rulesetKey),
      selectFilter(documentType, rulesetKey),
      selectFailedAssertionMap(documentType, rulesetKey),
      selectAssertionViewIds(documentType, rulesetKey),
      (config, filter, failedAssertionMap, assertionViewIds): FilterOptions => {
        const availableRoles = Array.from(
          new Set(config.schematronAsserts.map(assert => assert.role)),
        );
        return {
          fedrampSpecificOptions: FedRampSpecificOptions.map(
            (option: FedRampSpecific) => ({
              option,
              enabled: filter.fedrampSpecificOption === option,
              subtitle:
                {
                  all: 'All validation rules',
                  fedramp: 'FedRAMP-specific validation rules',
                  'non-fedramp': 'General OSCAL validation rules',
                }[option] || '',
              count: filterAssertions(
                config.schematronAsserts,
                {
                  fedrampSpecific: option,
                  passStatus: filter.passStatus,
                  role: filter.role,
                  text: filter.text,
                  assertionViewIds,
                },
                availableRoles,
                failedAssertionMap,
              ).length,
            }),
          ),

          assertionViews: config.assertionViews.map((view, index) => ({
            ...view,
            index,
            count: filterAssertions(
              config.schematronAsserts,
              {
                fedrampSpecific: filter.fedrampSpecificOption,
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
                    fedrampSpecific: filter.fedrampSpecificOption,
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
                  fedrampSpecific: filter.fedrampSpecificOption,
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
                  fedrampSpecific: filter.fedrampSpecificOption,
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
                  fedrampSpecific: filter.fedrampSpecificOption,
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

const selectAssertionViewIds = memoize(
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    createSelector(
      selectOscalDocumentConfig(documentType, rulesetKey),
      selectFilter(documentType, rulesetKey),
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
  (documentType: OscalDocumentKey, rulesetKey: SchematronRulesetKey) =>
    createSelector(
      selectOscalDocumentConfig(documentType, rulesetKey),
      selectFilter(documentType, rulesetKey),
      selectFilterOptions(documentType, rulesetKey),
      selectValidationResult(documentType, rulesetKey),
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
            fedrampSpecific: filter.fedrampSpecificOption,
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

export const selectVisibleScenarioSummaries = memoize(
  (rulesetKey: SchematronRulesetKey) =>
    createSelector(
      (state: State) => state.assertionDocumentation,
      (state: State) => state.rulesets[rulesetKey].oscalDocuments,
      (assertionDocumentation, oscalDocuments) => {
        if (assertionDocumentation.current === 'SHOWING') {
          const visibleAssertion = assertionDocumentation.visibleAssertion;
          if (visibleAssertion === null) {
            return [];
          }
          return assertionDocumentation.xspecScenarioSummaries[
            visibleAssertion.documentType
          ][visibleAssertion.assertionId];
        } else {
          return [];
        }
      },
    ),
);
