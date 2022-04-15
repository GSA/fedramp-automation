import * as BrowserFingerprint from '@fingerprintjs/fingerprintjs';
import type { GetBrowserFingerprint } from '../domain/metrics';

export const createBrowserFingerprintMaker = (): GetBrowserFingerprint => {
  let _fingerprint: string;
  return async () => {
    _fingerprint =
      _fingerprint ||
      (await BrowserFingerprint.load()
        .then(fingerprint => fingerprint.get())
        .then(result => result.visitorId));
    return _fingerprint;
  };
};
