import { match } from 'path-to-regexp';

export type RouteTypes = {
  Home: { type: 'Home' };
  DocumentSummary: { type: 'DocumentSummary' };
  DocumentPOAM: { type: 'DocumentPOAM' };
  DocumentSAP: { type: 'DocumentSAP' };
  DocumentSAR: { type: 'DocumentSAR' };
  DocumentSSP: { type: 'DocumentSSP' };
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
  export const documentSummary: RouteTypes['DocumentSummary'] = {
    type: 'DocumentSummary',
  };
  export const documentPOAM: RouteTypes['DocumentPOAM'] = {
    type: 'DocumentPOAM',
  };
  export const documentSAP: RouteTypes['DocumentSAP'] = {
    type: 'DocumentSAP',
  };
  export const documentSAR: RouteTypes['DocumentSAR'] = {
    type: 'DocumentSAR',
  };
  export const documentSSP: RouteTypes['DocumentSSP'] = {
    type: 'DocumentSSP',
  };
  export const developers: RouteTypes['Developers'] = {
    type: 'Developers',
  };
  export type NotFound = { type: 'NotFound' };
  export const notFound: NotFound = { type: 'NotFound' };
}

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '#/',
  DocumentSummary: () => '#/documents',
  DocumentPOAM: () => '#/documents/plan-of-action-and-milestones',
  DocumentSAP: () => '#/documents/security-assessment-plan',
  DocumentSAR: () => '#/documents/security-assessment-report',
  DocumentSSP: () => '#/documents/system-security-plan',
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
  DocumentSummary: matchRoute('#/documents', () => Routes.documentSummary),
  DocumentPOAM: matchRoute(
    '#/documents/plan-of-action-and-milestones',
    () => Routes.documentPOAM,
  ),
  DocumentSAP: matchRoute(
    '#/documents/security-assessment-plan',
    () => Routes.documentSAP,
  ),
  DocumentSAR: matchRoute(
    '#/documents/security-assessment-report',
    () => Routes.documentSAR,
  ),
  DocumentSSP: matchRoute(
    '#/documents/system-security-plan',
    () => Routes.documentSSP,
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

type Breadcrumb = {
  text: string;
  linkUrl: string | false;
};
export const breadcrumbs: Record<
  Route['type'] & string,
  (route: any) => Breadcrumb[]
> = {
  Home: (route: Route) => {
    return [
      {
        text: 'Home',
        linkUrl: route.type !== 'Home' && getUrl(Routes.home),
      },
    ];
  },
  DocumentSummary: (route: Route) => {
    return [
      ...breadcrumbs.Home(route),
      {
        text: 'Document Rules',
        linkUrl:
          route.type !== 'DocumentSummary' && getUrl(Routes.documentSummary),
      },
    ];
  },
  DocumentPOAM: (route: Route) => {
    return [
      ...breadcrumbs.DocumentSummary(route),
      {
        text: 'Plan of Action and Milestones',
        linkUrl: route.type !== 'DocumentPOAM' && getUrl(Routes.documentPOAM),
      },
    ];
  },
  DocumentSAP: (route: Route) => {
    return [
      ...breadcrumbs.DocumentSummary(route),
      {
        text: 'Security Assessment Plan',
        linkUrl: route.type !== 'DocumentSAP' && getUrl(Routes.documentSAP),
      },
    ];
  },
  DocumentSAR: (route: Route) => {
    return [
      ...breadcrumbs.DocumentSummary(route),
      {
        text: 'Security Assessment Results',
        linkUrl: route.type !== 'DocumentSAR' && getUrl(Routes.documentSAR),
      },
    ];
  },
  DocumentSSP: (route: Route) => {
    return [
      ...breadcrumbs.DocumentSummary(route),
      {
        text: 'System Security Plan',
        linkUrl: route.type !== 'DocumentSSP' && getUrl(Routes.documentSSP),
      },
    ];
  },
  Developers: (route: RouteTypes['Developers']) => {
    return [
      ...breadcrumbs.Home(route),
      {
        text: 'Developer documentation',
        linkUrl: route.type !== 'Developers' && getUrl(Routes.developers),
      },
    ];
  },
};

export type Location = {
  getCurrent: () => string;
  listen: (listener: (url: string) => void) => void;
  replace: (url: string) => void;
};
