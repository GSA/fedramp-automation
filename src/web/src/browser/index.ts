import * as github from '@asap/shared/domain/github';
import { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import { AppMetrics } from '@asap/shared/use-cases/app-metrics';
import { OscalService } from '@asap/shared/use-cases/oscal';

import { createBrowserFingerprintMaker } from '@asap/shared/adapters/browser-fingerprint';
import { createGoogleFormMetricsLogger } from '@asap/shared/adapters/google-form';
import { highlightXML } from '@asap/shared/adapters/highlight-js';
import { AppLocalStorage } from '@asap/shared/adapters/local-storage';
import {
  SaxonJsJsonOscalToXmlProcessor,
  SaxonJsSchematronProcessorGateway,
} from '@asap/shared/adapters/saxon-js-gateway';

import { browserController } from './browser-controller';
import { createPresenter } from './presenter';
import { createAppRenderer } from './views';

// The npm version of saxon-js is for node; currently, we load the browser
// version via a script tag in index.html.
const SaxonJS = (window as any).SaxonJS;

type BrowserContext = {
  element: HTMLElement;
  baseUrl: string;
  debug: boolean;
  deploymentId: string;
  importMetaHot: ImportMetaHot | undefined;
  githubRepository: github.GithubRepository;
};

export const runBrowserContext = ({
  element,
  baseUrl,
  debug,
  deploymentId,
  importMetaHot,
  githubRepository,
}: BrowserContext) => {
  // Set SaxonJS log level.
  SaxonJS.setLogLevel(2);

  const rulesUrl = `${baseUrl}rules`;

  const jsonOscalToXml = SaxonJsJsonOscalToXmlProcessor({
    sefUrl: `${rulesUrl}/oscal_complete_json-to-xml-converter.sef.json`,
    SaxonJS,
  });
  const processSchematron = SaxonJsSchematronProcessorGateway({
    sefUrls: {
      poam: `${rulesUrl}/poam.sef.json`,
      sap: `${rulesUrl}/sap.sef.json`,
      sar: `${rulesUrl}/sar.sef.json`,
      ssp: `${rulesUrl}/ssp.sef.json`,
    },
    SaxonJS,
    baselinesBaseUrl: `${baseUrl}/baselines`,
    registryBaseUrl: `${baseUrl}/xml`,
  });
  const eventLogger = createGoogleFormMetricsLogger({
    fetch: window.fetch.bind(window),
    formUrl:
      'https://docs.google.com/forms/d/e/1FAIpQLScKRI40pQlpaY9cUUnyTdz-e_NvOb0-DYnPw_6fTqbw-kO6KA/',
    fieldIds: {
      deploymentId: 'entry.2078742906',
      deviceId: 'entry.487426639',
      userAlias: 'entry.292167116',
      eventType: 'entry.172225468',
      data: 'entry.1638260679',
    },
  });
  const localStorageGateway = new AppLocalStorage(window.localStorage);
  browserController({
    importMetaHot,
    renderApp: createAppRenderer(
      element,
      createPresenter({
        debug,
        baseUrl,
        sourceRepository: {
          treeUrl: github.getBranchTreeUrl(githubRepository),
          sampleDocuments: github.getSampleOscalDocuments(githubRepository),
          developerExampleUrl: github.getDeveloperExampleUrl(githubRepository),
        },
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
          appMetrics: new AppMetrics({
            deploymentId,
            eventLogger,
            getBrowserFingerprint: createBrowserFingerprintMaker(),
            optInGateway: localStorageGateway,
          }),
          getAssertionViews: async () => {
            const responses = await Promise.all([
              fetch(`${rulesUrl}/assertion-views-poam.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/assertion-views-sap.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/assertion-views-sar.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/assertion-views-ssp.json`).then(response =>
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
          getSchematronAssertions: async () => {
            const responses = await Promise.all([
              fetch(`${rulesUrl}/poam.json`).then(response => response.json()),
              fetch(`${rulesUrl}/sap.json`).then(response => response.json()),
              fetch(`${rulesUrl}/sar.json`).then(response => response.json()),
              fetch(`${rulesUrl}/ssp.json`).then(response => response.json()),
            ]);
            return {
              poam: responses[0],
              sap: responses[1],
              sar: responses[2],
              ssp: responses[3],
            };
          },
          getXSpecScenarioSummaries: async () => {
            const responses = await Promise.all([
              fetch(`${rulesUrl}/xspec-scenarios-poam.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/xspec-scenarios-sap.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/xspec-scenarios-sar.json`).then(response =>
                response.json(),
              ),
              fetch(`${rulesUrl}/xspec-scenarios-ssp.json`).then(response =>
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
          oscalService: new OscalService(
            jsonOscalToXml,
            processSchematron,
            window.fetch.bind(window),
          ),
        },
      }),
    ),
  });
};
