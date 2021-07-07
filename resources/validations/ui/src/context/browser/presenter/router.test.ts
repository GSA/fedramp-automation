import * as router from './router';

describe('router', () => {
  describe('getRoute', () => {
    it('parses /', () => {
      expect(router.getRoute('#/')).toEqual({ type: 'Home' });
    });
    it('parses /summary', () => {
      expect(router.getRoute('#/summary')).toEqual({ type: 'Summary' });
    });
    it('parses /assertions/assertion-id', () => {
      expect(router.getRoute('#/assertions/assertion-id')).toEqual({
        type: 'Assertion',
        assertionId: 'assertion-id',
      });
    });
    it('returns NotFound', () => {
      expect(router.getRoute('')).toEqual(router.notFound);
      expect(router.getRoute('#/does-not-exist')).toEqual(router.notFound);
    });
  });
  describe('getUrl', () => {
    it('returns HomeRoute', () => {
      expect(router.getUrl(router.Routes.home)).toEqual('#/');
    });
    it('returns SummaryRoute', () => {
      expect(router.getUrl(router.Routes.summary)).toEqual('#/summary');
    });
    it('returns AssertionRoute', () => {
      expect(
        router.getUrl(router.Routes.assertion({ assertionId: 'assertion-id' })),
      ).toEqual('#/assertions/assertion-id');
    });
  });
});
