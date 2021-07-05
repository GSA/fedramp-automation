import { match } from 'path-to-regexp';

export type BrowserLocation = {
  getUrl: () => string;
  replaceState: (url: string) => void;
};

// Defined concrete objects for each route.
type HomeRoute = { type: 'Home' };
export const homeRoute: HomeRoute = {
  type: 'Home',
};

type ViewerRoute = { type: 'Viewer' };
export const viewerRoute: ViewerRoute = {
  type: 'Viewer',
};

type AssertionListRoute = { type: 'AssertionList' };
export const assertionListRoute: AssertionListRoute = {
  type: 'AssertionList',
};

type AssertionRoute = { type: 'Assertion'; assertionId: string };
export const assertionRoute = (options: {
  assertionId: string;
}): AssertionRoute => {
  return {
    type: 'Assertion',
    assertionId: options.assertionId,
  };
};

export type Route =
  | HomeRoute
  | ViewerRoute
  | AssertionListRoute
  | AssertionRoute;

export type NotFound = { type: 'NotFound' };
export const notFound: NotFound = { type: 'NotFound' };

export const breadcrumbStructure = {
  '/': ['/'],
};

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '/',
  Viewer: () => '/viewer',
  AssertionList: () => '/assertions',
  Assertion: (route: AssertionRoute) => `/assertions/${route.assertionId}`,
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
  Home: matchRoute('/', () => homeRoute),
  Viewer: matchRoute('/viewer', () => viewerRoute),
  AssertionList: matchRoute('/assertions', () => assertionListRoute),
  Assertion: matchRoute('/assertions/:assertionId', assertionRoute),
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
