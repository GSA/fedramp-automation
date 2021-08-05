import { match } from 'path-to-regexp';

export type RouteTypes = {
  Home: { type: 'Home' };
  Validator: { type: 'Validator' };
  Summary: { type: 'Summary' };
  Assertion: {
    type: 'Assertion';
    assertionId: string;
  };
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
  export const validator: RouteTypes['Validator'] = {
    type: 'Validator',
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
  export const developers: RouteTypes['Developers'] = {
    type: 'Developers',
  };
  export type NotFound = { type: 'NotFound' };
  export const notFound: NotFound = { type: 'NotFound' };
}

const RouteUrl: Record<Route['type'], (route?: any) => string> = {
  Home: () => '#/',
  Validator: () => '#/validator',
  Summary: () => '#/summary',
  Assertion: (route: RouteTypes['Assertion']) =>
    `#/assertions/${route.assertionId}`,
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
  Validator: matchRoute('#/validator', () => Routes.validator),
  Summary: matchRoute('#/summary', () => Routes.summary),
  Assertion: matchRoute('#/assertions/:assertionId', Routes.assertion),
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
  Validator: (route: Route) => {
    return [
      ...breadcrumbs.Home(route),
      {
        text: 'Validator',
        linkUrl: route.type !== 'Validator' && getUrl(Routes.home),
      },
    ];
  },
  Summary: (route: Route) => {
    return [
      ...breadcrumbs.Home(route),
      {
        text: 'Document name',
        linkUrl: route.type !== 'Summary' && getUrl(Routes.summary),
      },
    ];
  },
  Assertion: (route: RouteTypes['Assertion']) => {
    return [
      ...breadcrumbs.Home(route),
      {
        text: 'Assertion',
        linkUrl:
          route.type !== 'Assertion' &&
          getUrl(Routes.assertion({ assertionId: route.assertionId })),
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
  listen: (listener: (url: string) => void) => void;
  replace: (url: string) => void;
};
