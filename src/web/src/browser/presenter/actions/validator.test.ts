import { createPresenterMock } from '..';

describe('report action', () => {
  describe('reset', () => {
    const config = {
      useCases: {
        validateSSP: jest.fn(() =>
          Promise.resolve({
            title: 'title',
            failedAsserts: [],
          }),
        ),
      },
    };

    it('works on unloaded', () => {
      const presenter = createPresenterMock(config);
      expect(presenter.state.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.reset();
      expect(presenter.state.validator.current).toEqual('UNLOADED');
    });

    it('is disabled while processing', async () => {
      const presenter = createPresenterMock(config);
      const promise = presenter.actions.validator.validateOscalDocument({
        fileName: 'file-name.xml',
        fileContents: '<xml></xml>',
      });
      expect(presenter.state.validator.current).toEqual('PROCESSING');
      presenter.actions.validator.reset();
      expect(presenter.state.validator.current).toEqual('PROCESSING');
      await promise;
    });

    it('works on validated', async () => {
      const presenter = createPresenterMock(config);
      await presenter.actions.validator.validateOscalDocument({
        fileName: 'file-name.xml',
        fileContents: '<xml></xml>',
      });
      expect(presenter.state.validator.current).toEqual('VALIDATED');
      presenter.actions.validator.reset();
      expect(presenter.state.validator.current).toEqual('UNLOADED');
    });
  });

  describe('validateOscalDocument', () => {
    it('should work', async () => {
      const mockXml = 'mock xml';
      const presenter = createPresenterMock({
        useCases: {
          validateSSP: jest.fn(async (xml: string) => {
            expect(xml).toEqual(mockXml);
            return Promise.resolve({
              failedAsserts: [],
              title: 'title',
            });
          }),
        },
      });
      expect(presenter.state.validator.current).toEqual('UNLOADED');
      const promise = presenter.actions.validator.validateOscalDocument({
        fileName: 'file-name.xml',
        fileContents: mockXml,
      });
      expect(presenter.state.validator.current).toEqual('PROCESSING');
      await promise;
      expect(presenter.state.validator.current).toEqual('VALIDATED');
    });
  });

  describe('setXmlUrl and setProcessingError', () => {
    it('should work', done => {
      const mockUrl = 'https://test.com/test.xml';
      const presenter = createPresenterMock({
        useCases: {
          validateSSPUrl: jest.fn(async (url: string) => {
            expect(url).toEqual(mockUrl);
            expect(presenter.state.validator.current).toEqual('PROCESSING');
            done();
            return Promise.resolve({
              xmlText: '<xml></xml>',
              validationReport: {
                title: 'title',
                failedAsserts: [],
              },
            });
          }),
        },
      });
      expect(presenter.state.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.setXmlUrl(mockUrl);
      presenter.actions.validator.setProcessingError('my error');
      const processingState =
        presenter.state.validator.matches('PROCESSING_ERROR');
      expect(processingState?.errorMessage).toEqual('my error');
    });
  });
});
