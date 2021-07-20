import { createPresenterMock } from '..';

describe('action', () => {
  describe('getAssetUrl', () => {
    it('should work with baseUrl unspecified', async () => {
      const presenter = createPresenterMock();
      const assetUrl = presenter.actions.getAssetUrl('assets/test.png');
      expect(assetUrl).toEqual('/assets/test.png');
    });

    it('should work with baseUrl specified', async () => {
      const presenter = createPresenterMock({
        initialState: {
          baseUrl: 'https://baseurl',
        },
      });
      const assetUrl = presenter.actions.getAssetUrl('assets/test.png');
      expect(assetUrl).toEqual('https://baseurl/assets/test.png');
    });
  });
});
