import { highlightXML } from '@asap/shared/adapters/highlight-js';
import {
  SaxonJsJsonOscalToXmlProcessor,
  SaxonJsSchematronProcessorGateway,
} from '@asap/shared/adapters/saxon-js-gateway';
import * as github from '@asap/shared/domain/github';
import {
  SchematronProcessor,
  SchematronRulesetKey,
  SchematronRulesetKeys,
} from '@asap/shared/domain/schematron';
import { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import { OscalService } from '@asap/shared/use-cases/oscal';

import { getInitialState } from './presenter';
import { createAppRenderer } from './views';

// The npm version of saxon-js is for node; currently, we load the browser
// version via a script tag in index.html.
const SaxonJS = (window as any).SaxonJS;

type BrowserContext = {
  element: HTMLElement;
  baseUrl: `${string}/`;
  githubRepository: github.GithubRepository;
};

export const runBrowserContext = ({
  element,
  baseUrl,
  githubRepository,
}: BrowserContext) => {
  // Set SaxonJS log level.
  SaxonJS.setLogLevel(2);

  const rulesUrl = `${baseUrl}rules/`;

  const renderApp = createAppRenderer(
    element,
    getInitialState({
      baseUrl,
      sourceRepository: {
        treeUrl: github.getBranchTreeUrl(githubRepository),
        sampleDocuments: github.getSampleOscalDocuments(githubRepository),
        developerExampleUrl: github.getDeveloperExampleUrl(githubRepository),
        newIssueUrl: github.getNewIssueUrl(githubRepository),
      },
    }),
    {
      location: {
        getCurrent: () => window.location.hash,
        listen: (listener: (url: string) => void) => {
          window.addEventListener('hashchange', event => {
            const hashchangeEvent = event as HashChangeEvent;
            listener(`#${hashchangeEvent.newURL.split('#')[1]}`);
          });
        },
        replace: (url: string) => window.history.replaceState(null, '', url),
      },
      useCases: {
        annotateXML: AnnotateXMLUseCase({
          xml: {
            formatXML: highlightXML,
            // skip indenting the XML for now.
            indentXml: s => Promise.resolve(s),
          },
          SaxonJS,
        }),
        getAssertionViews: async (rulesetKey: SchematronRulesetKey) => {
          const responses = await Promise.all([
            fetch(`${rulesUrl}${rulesetKey}/assertion-views-poam.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/assertion-views-sap.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/assertion-views-sar.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/assertion-views-ssp.json`).then(
              response => response.json(),
            ),
          ]);
          return {
            poam: responses[0],
            sap: responses[1],
            sar: responses[2],
            ssp: responses[3],
          };
        },
        getSchematronAssertions: async (rulesetKey: SchematronRulesetKey) => {
          const responses = await Promise.all([
            fetch(`${rulesUrl}${rulesetKey}/poam.json`).then(response =>
              response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/sap.json`).then(response =>
              response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/sar.json`).then(response =>
              response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/ssp.json`).then(response =>
              response.json(),
            ),
          ]);
          return {
            poam: responses[0],
            sap: responses[1],
            sar: responses[2],
            ssp: responses[3],
          };
        },
        getXSpecScenarioSummaries: async (rulesetKey: SchematronRulesetKey) => {
          const responses = await Promise.all([
            fetch(`${rulesUrl}${rulesetKey}/xspec-summary-poam.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/xspec-summary-sap.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/xspec-summary-sar.json`).then(
              response => response.json(),
            ),
            fetch(`${rulesUrl}${rulesetKey}/xspec-summary-ssp.json`).then(
              response => response.json(),
            ),
          ]);
          return {
            poam: responses[0],
            sap: responses[1],
            sar: responses[2],
            ssp: responses[3],
          };
        },
        oscalService: new OscalService(
          {
            ssp: SaxonJsJsonOscalToXmlProcessor({
              console,
              sefUrl: `${rulesUrl}oscal_ssp_json-to-xml-converter.sef.json`,
              SaxonJS,
            }),
            sap: SaxonJsJsonOscalToXmlProcessor({
              console,
              sefUrl: `${rulesUrl}oscal_assessment-plan_json-to-xml-converter.sef.json`,
              SaxonJS,
            }),
            sar: SaxonJsJsonOscalToXmlProcessor({
              console,
              sefUrl: `${rulesUrl}oscal_assessment-results_json-to-xml-converter.sef.json`,
              SaxonJS,
            }),
            poam: SaxonJsJsonOscalToXmlProcessor({
              console,
              sefUrl: `${rulesUrl}oscal_poam_json-to-xml-converter.sef.json`,
              SaxonJS,
            }),
          },
          Object.fromEntries(
            SchematronRulesetKeys.map(rulesetKey => [
              rulesetKey,
              SaxonJsSchematronProcessorGateway({
                console,
                sefUrls: {
                  poam: `${baseUrl}rules/${rulesetKey}/poam.sef.json`,
                  sap: `${baseUrl}rules/${rulesetKey}/sap.sef.json`,
                  sar: `${baseUrl}rules/${rulesetKey}/sar.sef.json`,
                  ssp: `${baseUrl}rules/${rulesetKey}/ssp.sef.json`,
                },
                SaxonJS,
                baselinesBaseUrl: `${baseUrl}content/${rulesetKey}/baselines/xml`,
                registryBaseUrl: `${baseUrl}content/${rulesetKey}/resources/xml`,
              }),
            ]),
          ) as Record<SchematronRulesetKey, SchematronProcessor>,
          window.fetch.bind(window),
          console,
        ),
      },
    },
  );
  renderApp();
};
