import { createPresenterMock } from '.';

describe('action', () => {
  describe('setBaseUrl and getAssetUrl', () => {
    it('should work', async () => {
      const presenter = createPresenterMock();
      expect(presenter.state).toMatchObject({
        baseUrl: '/',
      });
      await presenter.actions.setBaseUrl('https://baseurl');
      expect(presenter.state).toMatchObject({
        baseUrl: 'https://baseurl',
      });
      const assetUrl = presenter.actions.getAssetUrl('assets/test.png');
      expect(assetUrl).toEqual('https://baseurl/assets/test.png');
    });
  });

  describe('setRepositoryUrl', () => {
    it('should work', async () => {
      const presenter = createPresenterMock();
      expect(presenter.state).toMatchObject({
        repositoryUrl: '#',
      });
      await presenter.actions.setRepositoryUrl('https://github.com/owner/repo');
      expect(presenter.state).toMatchObject({
        repositoryUrl: 'https://github.com/owner/repo',
      });
    });
  });
});
