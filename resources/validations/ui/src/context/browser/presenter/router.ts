import { match } from 'path-to-regexp';

export type BrowserLocation = {
  getUrl: () => string;
  replaceState: (url: string) => void;
};

// Defined concrete objects for each route.
export type HomeRoute = { type: 'Home' };
export const homeRoute: HomeRoute = {
  type: 'Home',
};

// Defined concrete objects for each route.
export type SummaryRoute = { type: 'Summary' };
export const summaryRoute: SummaryRoute = {
  type: 'Summary',
};

export type AssertionRoute = { type: 'Assertion'; assertionId: string };
export const assertionRoute = (options: {
  assertionId: string;
}): AssertionRoute => {
  return {
    type: 'Assertion',
    assertionId: options.assertionId,
  };
};

export type Route = HomeRoute | SummaryRoute | AssertionRoute;
export type RouteType = Route['type'];

export type NotFound = { type: 'NotFound' };
export const notFound: NotFound = { type: 'NotFound' };

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '#/',
  Summary: () => '#/summary',
  Assertion: (route: AssertionRoute) => `#/assertions/${route.assertionId}`,
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
  Home: matchRoute('#/', () => homeRoute),
  Summary: matchRoute('#/summary', () => summaryRoute),
  Assertion: matchRoute('#/assertions/:assertionId', assertionRoute),
};

export const getRoute = (url: string): Route | NotFound => {
  for (const routeType of Object.keys(RouteMatch)) {
    const route = RouteMatch[routeType as Route['type']](url);
    if (route) {
      return route;
    }
  }
  return notFound;
};

type Breadcrumb = {
  text: string;
  url: string;
  selected: boolean;
};
export const breadcrumbs: Record<Route['type'], (route: any) => Breadcrumb[]> =
  {
    Home: (route: Route) => {
      return [
        {
          text: 'Select SSP',
          url: getUrl(homeRoute),
          selected: route.type === 'Home',
        },
      ];
    },
    Summary: (route: Route) => {
      return [
        ...breadcrumbs.Home(route),
        {
          text: 'Document name',
          url: getUrl(summaryRoute),
          selected: route.type === 'Summary',
        },
      ];
    },
    Assertion: (route: AssertionRoute) => {
      return [
        ...breadcrumbs.Home(route),
        {
          text: 'Assertion',
          url: getUrl(assertionRoute({ assertionId: route.assertionId })),
          selected: route.type === 'Assertion',
        },
      ];
    },
  };

export type LocationListener = (listener: (url: string) => void) => void;
