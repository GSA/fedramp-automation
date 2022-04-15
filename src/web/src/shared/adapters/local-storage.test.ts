import { mock } from 'jest-mock-extended';
import { AppLocalStorage } from './local-storage';

describe('local storage adapter', () => {
  describe('metrics preference', () => {
    it('should work', () => {
      const storage = new AppLocalStorage(window.localStorage);

      // Defaults to false
      expect(storage.getOptInStatus()).toEqual(false);

      // Can set and get true
      storage.setOptInStatus(true);
      expect(storage.getOptInStatus()).toEqual(true);

      // Can set and get false
      storage.setOptInStatus(false);
      expect(storage.getOptInStatus()).toEqual(false);
    });
  });
});
