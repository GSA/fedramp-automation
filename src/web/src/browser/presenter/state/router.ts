import { match } from 'path-to-regexp';

import {
  SchematronRulesetKey,
  SchematronRulesetKeys,
} from '@asap/shared/domain/schematron';

export type RouteTypes = {
  Home: { type: 'Home' };
  DocumentSummary: {
    type: 'DocumentSummary';
    ruleset: SchematronRulesetKey;
  };
  DocumentPOAM: { type: 'DocumentPOAM'; ruleset: SchematronRulesetKey };
  DocumentSAP: { type: 'DocumentSAP'; ruleset: SchematronRulesetKey };
  DocumentSAR: { type: 'DocumentSAR'; ruleset: SchematronRulesetKey };
  DocumentSSP: { type: 'DocumentSSP'; ruleset: SchematronRulesetKey };
  Developers: {
    type: 'Developers';
  };
};

export type Route = RouteTypes[keyof RouteTypes];
export type RouteType = Route['type'];
export namespace Routes {
  export const home: RouteTypes['Home'] = {
    type: 'Home',
  };
  export const defaultDocumentSummary: RouteTypes['DocumentSummary'] = {
    type: 'DocumentSummary',
    ruleset: SchematronRulesetKeys[0],
  };
  export const documentSummary = (
    ruleset: SchematronRulesetKey,
  ): RouteTypes['DocumentSummary'] => ({
    type: 'DocumentSummary',
    ruleset,
  });
  export const documentPOAM = (
    ruleset: SchematronRulesetKey,
  ): RouteTypes['DocumentPOAM'] => ({
    type: 'DocumentPOAM',
    ruleset,
  });
  export const documentSAP = (
    ruleset: SchematronRulesetKey,
  ): RouteTypes['DocumentSAP'] => ({
    type: 'DocumentSAP',
    ruleset,
  });
  export const documentSAR = (
    ruleset: SchematronRulesetKey,
  ): RouteTypes['DocumentSAR'] => ({
    type: 'DocumentSAR',
    ruleset,
  });
  export const documentSSP = (
    ruleset: SchematronRulesetKey,
  ): RouteTypes['DocumentSSP'] => ({
    type: 'DocumentSSP',
    ruleset,
  });
  export const developers: RouteTypes['Developers'] = {
    type: 'Developers',
  };
  export type NotFound = { type: 'NotFound' };
  export const notFound: NotFound = { type: 'NotFound' };
}

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '#/',
  DocumentSummary: (route: RouteTypes['DocumentSummary']) =>
    `#/${route.ruleset}/documents`,
  DocumentPOAM: (route: RouteTypes['DocumentPOAM']) =>
    `#/${route.ruleset}/documents/plan-of-action-and-milestones`,
  DocumentSAP: (route: RouteTypes['DocumentSAP']) =>
    `#/${route.ruleset}/documents/security-assessment-plan`,
  DocumentSAR: (route: RouteTypes['DocumentSAR']) =>
    `#/${route.ruleset}/documents/security-assessment-report`,
  DocumentSSP: (route: RouteTypes['DocumentSSP']) =>
    `#/${route.ruleset}/documents/system-security-plan`,
  Developers: () => '#/developers',
};

export const getUrl = (route: Route): string => {
  return RouteUrl[route.type](route);
};

const matchRoute = <L extends Route>(
  urlPattern: string,
  createRoute: (params?: any) => L,
) => {
  const matcher = match(urlPattern);
  return (url: string) => {
    const match = matcher(url);
    if (match) {
      return createRoute(match.params);
    }
  };
};

const RouteMatch: Record<Route['type'], (url: string) => Route | undefined> = {
  Home: matchRoute('#/', () => Routes.home),
  DocumentSummary: matchRoute('#/:ruleset/documents', ({ ruleset }) =>
    Routes.documentSummary(ruleset),
  ),
  DocumentPOAM: matchRoute(
    '#/:ruleset/documents/plan-of-action-and-milestones',
    ({ ruleset }) => Routes.documentPOAM(ruleset),
  ),
  DocumentSAP: matchRoute(
    '#/:ruleset/documents/security-assessment-plan',
    ({ ruleset }) => Routes.documentSAP(ruleset),
  ),
  DocumentSAR: matchRoute(
    '#/:ruleset/documents/security-assessment-report',
    ({ ruleset }) => Routes.documentSAR(ruleset),
  ),
  DocumentSSP: matchRoute(
    '#/:ruleset/documents/system-security-plan',
    ({ ruleset }) => Routes.documentSSP(ruleset),
  ),
  Developers: matchRoute('#/developers', () => Routes.developers),
};

export const getRoute = (url: string): Route | Routes.NotFound => {
  for (const routeType of Object.keys(RouteMatch)) {
    const route = RouteMatch[routeType as Route['type']](url);
    if (route) {
      return route;
    }
  }
  return Routes.notFound;
};

export type Location = {
  getCurrent: () => string;
  listen: (listener: (url: string) => void) => void;
  replace: (url: string) => void;
};

export const isRulesetRoute = (route: Route) => {
  return (route as any).ruleset !== undefined;
};
