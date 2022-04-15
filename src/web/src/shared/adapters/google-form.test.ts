import { createGoogleFormMetricsLogger } from './google-form';

describe('google form metrics', () => {
  it('posts event data', () => {
    const fetchMock = jest.fn();
    const logEvent = createGoogleFormMetricsLogger({
      fetch: fetchMock,
      formUrl:
        'https://docs.google.com/forms/d/e/1FAIpQLScKRI40pQlpaY9cUUnyTdz-e_NvOb0-DYnPw_6fTqbw-kO6KA/',
      fieldIds: {
        deploymentId: 'entry.123',
        deviceId: 'entry.321',
        userAlias: 'entry.456',
        eventType: 'entry.654',
        data: 'entry.789',
      },
    });
    logEvent({
      deploymentId: 'deploymentId',
      deviceId: 'deviceId',
      userAlias: 'userAlias',
      eventType: 'app-loaded',
      data: { attr1: 'test1', attr2: 'test2' },
    });
    expect(fetchMock).toHaveBeenCalledWith(
      'https://docs.google.com/forms/d/e/1FAIpQLScKRI40pQlpaY9cUUnyTdz-e_NvOb0-DYnPw_6fTqbw-kO6KA/formResponse',
      {
        body: 'entry.123=deploymentId&entry.321=deviceId&entry.456=userAlias&entry.654=app-loaded&entry.789=%7B%22attr1%22%3A%22test1%22%2C%22attr2%22%3A%22test2%22%7D',
        headers: {
          Accept: 'application/xml, text/xml, */*; q=0.01',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        method: 'POST',
        mode: 'no-cors',
      },
    );
  });
});
