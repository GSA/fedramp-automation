import { base64DataUriForJson } from './util';

describe('utility function', () => {
  describe('base64DataUriForJson', () => {
    it('works', async () => {
      expect(await base64DataUriForJson(`{"hello": 1}`)).toEqual(
        'data:application/json;base64,eyJoZWxsbyI6IDF9',
      );
    });
  });
});
