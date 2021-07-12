import { derived } from 'overmind';

import {
  EMPTY_SCHEMATRON,
  Schematron,
  ValidationAssert,
} from '../../../use-cases/schematron';
import { createReportMachine, ReportMachine } from './machines/report';
import * as router from './router';

export type SampleSSP = {
  url: string;
  displayName: string;
};

const checkCircleIcon = { sprite: 'check_circle', color: 'green' };
const helpIcon = { sprite: 'help', color: 'blue' };
const cancelIcon = {
  sprite: 'cancel',
  color: 'red',
};

export type State = {
  baseUrl: string;
  breadcrumbs: { text: string; selected: boolean; url: string }[];
  currentRoute: router.Route;
  report: ReportMachine;
  repositoryUrl?: string;
  sampleSSPs: SampleSSP[];
  schematronReport: {
    summaryText: string;
    groups: {
      title: string;
      see: string;
      assertions: {
        summary: string;
        summaryColor: 'red' | 'green';
        assertions: {
          id: string;
          test: string;
          message: string;
          isReport: boolean;
          icon: typeof checkCircleIcon;
          fired: ValidationAssert[];
        }[];
      };
    }[];
  };
  sspSchematron: Schematron;
};

export const state: State = {
  baseUrl: '',
  breadcrumbs: derived((state: State) =>
    router.breadcrumbs[state.currentRoute.type](state.currentRoute),
  ),
  currentRoute: router.Routes.home,
  report: createReportMachine(),
  sampleSSPs: [],
  schematronReport: derived((state: State) => {
    const assertionGroups: {
      title: string;
      see: string;
      assertions: {
        summary: string;
        summaryColor: 'red' | 'green';
        assertions: {
          id: string;
          test: string;
          message: string;
          isReport: boolean;
          icon: typeof checkCircleIcon;
          fired: ValidationAssert[];
        }[];
      };
    }[] = [];
    const isValidated = state.report.current === 'VALIDATED';
    state.sspSchematron.patterns.forEach(pattern =>
      pattern.rules.forEach(rule => {
        const assertions = rule.asserts.map(assert => {
          const fired = state.report.assertionsById[assert.id || ''] || [];
          return {
            id: assert.id || '',
            test: assert.test,
            message: assert.message.toString(),
            isReport: assert.isReport,
            icon: !isValidated
              ? helpIcon
              : fired.length
              ? cancelIcon
              : checkCircleIcon,
            fired,
          };
        });
        const passCount = assertions.filter(
          assert => assert.fired.length === 0,
        ).length;
        assertionGroups.push({
          title: `Rule #${assertionGroups.length + 1}`,
          see: '(sample) DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48',
          assertions: {
            summary: (() => {
              if (isValidated) {
                return `${passCount} / ${assertions.length} passed`;
              } else {
                return `${assertions.length} assertions`;
              }
            })(),
            summaryColor: passCount === assertions.length ? 'green' : 'red',
            assertions,
          },
        });
      }),
    );

    return {
      summaryText: isValidated
        ? `Found ${state.report.visibleAssertions.length} problems`
        : '',
      groups: assertionGroups,
    };
  }),
  sspSchematron: EMPTY_SCHEMATRON,
};

/*
{
  title: 'Pattern / rule name',
  see: 'DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48',
  assertions: state.report.visibleAssertions
    .map(assertion => ({
      title: 'state.sspSchematron.assertion.id',
      text: assertion.text,
      icon: checkCircleIcon,
      fired: [],
    }))
    .slice(0, 2),
},
{
  title: 'Second pattern / rule name',
  see: 'DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48',
  assertions: state.report.visibleAssertions
    .map(assertion => ({
      title: 'state.sspSchematron.assertion.id',
      text: assertion.text,
      icon: cancelIcon,
      fired: [
        {
          uniqueId: 'resource-has-base64-27',
          xPath:
            "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
          text: 'This SSP has defined a responsible party with 1 role',
        },
        {
          uniqueId: 'resource-has-base64-27',
          xPath:
            "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
          text: '2 This SSP has defined a responsible party with 1 role',
        },
      ],
    }))
    .slice(0, 3),
},*/
