export const UsageTrackingPage = () => {
  return (
    <>
      <h1>Usage Tracking</h1>
      <div className="usa-prose">
        <p>
          During the beta period, the 10x ASAP development team benefits from
          understanding how you use this application. The following is a
          description of each piece of data collected by this application.
        </p>
        <table className="usa-table usa-table--borderless usa-table--striped">
          <caption>Usage data collected</caption>
          <thead>
            <tr>
              <th scope="col">Application Event</th>
              <th scope="col">Description</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">All events</th>
              <td>
                For all events, an anonymized browser fingerprint is tracked.
                This fingerprint is used to group your user activity into a
                single session.
              </td>
            </tr>
            <tr>
              <th scope="row">Application loaded</th>
              <td>
                When you load the 10x ASAP application, the current page is
                tracked.
              </td>
            </tr>
            <tr>
              <th scope="row">Validation summary</th>
              <td>
                After validating an OSCAL SSP, the assertion identifiers for
                each failed validation is tracked. No content from your document
                is shared.
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </>
  );
};
