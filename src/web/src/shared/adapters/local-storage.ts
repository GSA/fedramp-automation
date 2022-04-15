import type { OptInStatusAdapter } from '../domain/metrics';

const OPT_IN_KEY = 'metrics-opt-in-status';

export class AppLocalStorage implements OptInStatusAdapter {
  constructor(private localStorage: typeof window.localStorage) {}

  setOptInStatus(optInStatus: boolean) {
    this.localStorage.setItem(OPT_IN_KEY, JSON.stringify(optInStatus));
  }

  getOptInStatus(): boolean {
    return JSON.parse(this.localStorage.getItem(OPT_IN_KEY) || 'false');
  }
}
