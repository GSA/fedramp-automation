import { createPresenterMock } from '.';

describe('presenter', () => {
  describe('derived state', () => {
    const presenter = createPresenterMock();
    it('github repositoryUrl', () => {
      expect(presenter.state.repositoryUrl).toEqual(
        'https://github.com/18F/fedramp-automation',
      );
    });
    it('github sampleSSPs', () => {
      expect(presenter.state.sampleSSPs).toEqual([
        {
          displayName: 'FedRAMP-SSP-OSCAL-Template.xml',
          url: 'https://raw.githubusercontent.com/18F/fedramp-automation/master/resources/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
        },
      ]);
    });
  });
});
