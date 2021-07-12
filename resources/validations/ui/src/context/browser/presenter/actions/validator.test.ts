import { createPresenterMock } from '..';

describe('report action', () => {
  describe('reset', () => {
    const config = {
      useCases: {
        validateSSP: jest.fn(() =>
          Promise.resolve({
            failedAsserts: [],
          }),
        ),
      },
    };

    it('works on unloaded', () => {
      const presenter = createPresenterMock(config);
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.reset();
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
    });

    it('is disabled while processing', async () => {
      const presenter = createPresenterMock(config);
      const promise = presenter.actions.validator.setXmlContents({
        fileName: 'file-name.xml',
        xmlContents: '<xml></xml>',
      });
      expect(presenter.state.schematron.validator.current).toEqual(
        'PROCESSING',
      );
      presenter.actions.validator.reset();
      expect(presenter.state.schematron.validator.current).toEqual(
        'PROCESSING',
      );
      await promise;
    });

    it('works on validated', async () => {
      const presenter = createPresenterMock(config);
      await presenter.actions.validator.setXmlContents({
        fileName: 'file-name.xml',
        xmlContents: '<xml></xml>',
      });
      expect(presenter.state.schematron.validator.current).toEqual('VALIDATED');
      presenter.actions.validator.reset();
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
    });
  });

  describe('setXmlContents', () => {
    it('should work', async () => {
      const mockXml = 'mock xml';
      const presenter = createPresenterMock({
        useCases: {
          validateSSP: jest.fn(async (xml: string) => {
            expect(xml).toEqual(mockXml);
            return Promise.resolve({
              failedAsserts: [],
            });
          }),
        },
      });
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      const promise = presenter.actions.validator.setXmlContents({
        fileName: 'file-name.xml',
        xmlContents: mockXml,
      });
      expect(presenter.state.schematron.validator.current).toEqual(
        'PROCESSING',
      );
      await promise;
      expect(presenter.state.schematron.validator.current).toEqual('VALIDATED');
    });
  });

  describe('setXmlUrl and setProcessingError', () => {
    it('should work', done => {
      const mockUrl = 'https://test.com/test.xml';
      const presenter = createPresenterMock({
        useCases: {
          validateSSPUrl: jest.fn(async (url: string) => {
            expect(url).toEqual(mockUrl);
            expect(presenter.state.schematron.validator.current).toEqual(
              'PROCESSING',
            );
            done();
            return Promise.resolve({
              xmlText: '<xml></xml>',
              validationReport: {
                failedAsserts: [],
              },
            });
          }),
        },
      });
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.setXmlUrl(mockUrl);
      presenter.actions.validator.setProcessingError('my error');
      const processingState =
        presenter.state.schematron.validator.matches('PROCESSING_ERROR');
      expect(processingState?.errorMessage).toEqual('my error');
    });
  });

  describe('setFilterRole', () => {
    it('works', () => {
      const presenter = createPresenterMock();
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.setFilterRole('error');
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.setValidationReport({
        xmlText: '<xml></xml',
        validationReport: MOCK_VALIDATION_REPORT,
      });
    });
  });

  describe('setFilterText', () => {
    it('works', () => {
      const presenter = createPresenterMock({
        useCases: {
          validateSSP: () => Promise.resolve(MOCK_VALIDATION_REPORT),
        },
      });
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      presenter.actions.validator.setFilterText('filter text');
      expect(presenter.state.schematron.validator.current).toEqual('UNLOADED');
      const xmlText = '<xml>ignored</xml>';
      presenter.actions.validator.setXmlContents({
        fileName: 'file-name.xml',
        xmlContents: xmlText,
      });
      presenter.actions.validator.setValidationReport({
        xmlText,
        validationReport: MOCK_VALIDATION_REPORT,
      });
      presenter.actions.validator.setFilterText('filter text');
      expect(presenter.state.schematron.validator).toMatchObject({
        current: 'VALIDATED',
        filter: {
          text: 'filter text',
        },
        filterRoles: ['all', '', 'error'],
        visibleAssertions: [],
      });
    });
  });
});

const MOCK_VALIDATION_REPORT = {
  failedAsserts: [
    {
      text: 'ASSERT TEXT 1',
      test: 'not(exists($extraneous-roles))',
      id: 'incorrect-role-association',
      uniqueId: 'incorrect-role-association-1',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
    },
    {
      text: 'ASSERT TEXT 2',
      test: 'not(exists($core-missing))',
      id: 'incomplete-core-implemented-requirements',
      uniqueId: 'incomplete-core-implemented-requirements-1',
      role: 'error',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
    },
  ],
};
