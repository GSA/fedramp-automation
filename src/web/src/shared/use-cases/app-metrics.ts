import type * as metrics from '../domain/metrics';

type AppMetricsContext = {
  deploymentId: metrics.Event['deploymentId'];
  eventLogger: metrics.EventLogger;
  getBrowserFingerprint: metrics.GetBrowserFingerprint;
  optInGateway: metrics.OptInStatusAdapter;
};

export type AppMetricsOptions = {
  userAlias?: metrics.Event['userAlias'];
  eventType: metrics.Event['eventType'];
  data: metrics.Event['data'];
};

export class AppMetrics {
  constructor(private ctx: AppMetricsContext) {}

  async log(opts: AppMetricsOptions) {
    if (this.ctx.optInGateway.getOptInStatus()) {
      await this.ctx.eventLogger({
        deploymentId: this.ctx.deploymentId,
        deviceId: await this.ctx.getBrowserFingerprint(),
        ...opts,
      });
    }
  }

  getOptInStatus() {
    return this.ctx.optInGateway.getOptInStatus();
  }

  setOptInStatus(optInStatus: boolean) {
    this.ctx.optInGateway.setOptInStatus(optInStatus);
  }
}
