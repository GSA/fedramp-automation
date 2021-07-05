import * as router from './router';

describe('router', () => {
  describe('getRoute', () => {
    it('parses /', () => {
      expect(router.getRoute('/')).toEqual({ type: 'Home' });
    });
    it('parses /viewer', () => {
      expect(router.getRoute('/viewer')).toEqual({ type: 'Viewer' });
    });
    it('parses /assertions', () => {
      expect(router.getRoute('/assertions')).toEqual({
        type: 'AssertionList',
      });
    });
    it('parses /assertions/assertion-id', () => {
      expect(router.getRoute('/assertions/assertion-id')).toEqual({
        type: 'Assertion',
        assertionId: 'assertion-id',
      });
    });
    it('returns NotFound', () => {
      expect(router.getRoute('')).toEqual(router.notFound);
      expect(router.getRoute('/does-not-exist')).toEqual(router.notFound);
    });
  });
  describe('getUrl', () => {
    it('returns HomeRoute', () => {
      expect(router.getUrl(router.homeRoute)).toEqual('/');
    });
    it('returns ViewerRoute', () => {
      expect(router.getUrl(router.viewerRoute)).toEqual('/viewer');
    });
    it('returns AssertionListRoute', () => {
      expect(router.getUrl(router.assertionListRoute)).toEqual(
        '/assertions',
      );
    });
    it('returns AssertionRoute', () => {
      expect(
        router.getUrl(
          router.assertionRoute({ assertionId: 'assertion-id' }),
        ),
      ).toEqual('/assertions/assertion-id');
    });
  });
});
