import { it, describe, expect } from 'vitest';

import * as router from './router';

describe('router', () => {
  describe('getRoute', () => {
    it('parses /', () => {
      expect(router.getRoute('#/')).toEqual({ type: 'Home' });
    });
    it('returns NotFound', () => {
      expect(router.getRoute('')).toEqual(router.Routes.notFound);
      expect(router.getRoute('#/does-not-exist')).toEqual(
        router.Routes.notFound,
      );
    });
  });
  describe('getUrl', () => {
    it('returns HomeRoute', () => {
      expect(router.getUrl(router.Routes.home)).toEqual('#/');
    });
  });
});
