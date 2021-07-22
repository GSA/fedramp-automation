import { match } from 'path-to-regexp';

export type RouteTypes = {
  Home: { type: 'Home' };
  Summary: { type: 'Summary' };
  Assertion: {
    type: 'Assertion';
    assertionId: string;
  };
};

export type Route = RouteTypes[keyof RouteTypes];
export type RouteType = Route['type'];
export namespace Routes {
  export const home: RouteTypes['Home'] = {
    type: 'Home',
  };
  export const summary: RouteTypes['Summary'] = {
    type: 'Summary',
  };
  export const assertion = (options: {
    assertionId: string;
  }): RouteTypes['Assertion'] => {
    return {
      type: 'Assertion',
      assertionId: options.assertionId,
    };
  };
  export type NotFound = { type: 'NotFound' };
  export const notFound: NotFound = { type: 'NotFound' };
}

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '#/',
  Summary: () => '#/summary',
  Assertion: (route: RouteTypes['Assertion']) =>
    `#/assertions/${route.assertionId}`,
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
  Summary: matchRoute('#/summary', () => Routes.summary),
  Assertion: matchRoute('#/assertions/:assertionId', Routes.assertion),
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
  url: string;
  selected: boolean;
};
export const breadcrumbs: Record<Route['type'], (route: any) => Breadcrumb[]> =
  {
    Home: (route: Route) => {
      return [
        {
          text: 'Select SSP',
          url: getUrl(Routes.home),
          selected: route.type === 'Home',
        },
      ];
    },
    Summary: (route: Route) => {
      return [
        ...breadcrumbs.Home(route),
        {
          text: 'Document name',
          url: getUrl(Routes.summary),
          selected: route.type === 'Summary',
        },
      ];
    },
    Assertion: (route: RouteTypes['Assertion']) => {
      return [
        ...breadcrumbs.Home(route),
        {
          text: 'Assertion',
          url: getUrl(Routes.assertion({ assertionId: route.assertionId })),
          selected: route.type === 'Assertion',
        },
      ];
    },
  };

export type Location = {
  listen: (listener: (url: string) => void) => void;
  replace: (url: string) => void;
};
