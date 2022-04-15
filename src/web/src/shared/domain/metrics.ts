// If you add a new event type here, don't forget to also add to the documentation.
// see: src/web/src/browser/views/components/UsageTrackingPage.tsx
export type EventType = 'validation-summary' | 'app-loaded';

export type Event = {
  // Deployment of the application (Github branch name)
  deploymentId: string;

  // Unique browser identifier
  deviceId: string;

  // Optional. User-specified identifier (eg, email address)
  userAlias?: string;

  // ID of this event.
  eventType: EventType;

  // Associated data for this `eventType`
  data: Record<string, any>;
};

// Log an event
export type EventLogger = (event: Event) => Promise<void>;

// Returns a unique fingerprint for the user's device.
export type GetBrowserFingerprint = () => Promise<string>;

// Use to determine whether the user has opted-in to tracking.
// The 10x ASAP Phase 4 team asks its partners to voluntarily opt-in.
export interface OptInStatusAdapter {
  setOptInStatus(optInStatus: boolean): void;
  getOptInStatus(): boolean;
}
