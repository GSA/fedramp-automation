import type { Event, EventLogger } from '../domain/metrics';

type GoogleFormFieldId = `entry.${number}`;

type GoogleFormContext = {
  fetch: typeof fetch;
  formUrl: `https://docs.google.com/forms/d/e/${string}/`;
  fieldIds: {
    deploymentId: GoogleFormFieldId;
    deviceId: GoogleFormFieldId;
    userAlias: GoogleFormFieldId;
    eventType: GoogleFormFieldId;
    data: GoogleFormFieldId;
  };
};

export const createGoogleFormMetricsLogger =
  (ctx: GoogleFormContext): EventLogger =>
  async (event: Event) => {
    await ctx.fetch(`${ctx.formUrl}formResponse`, {
      method: 'POST',
      mode: 'no-cors',
      headers: {
        Accept: 'application/xml, text/xml, */*; q=0.01',
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: new URLSearchParams({
        [ctx.fieldIds.deploymentId]: event.deploymentId,
        [ctx.fieldIds.deviceId]: event.deviceId,
        [ctx.fieldIds.userAlias]: event.userAlias || 'unspecified',
        [ctx.fieldIds.eventType]: event.eventType,
        [ctx.fieldIds.data]: JSON.stringify(event.data),
      }).toString(),
    });
  };
