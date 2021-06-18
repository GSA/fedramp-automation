import { createPresenterMock } from '..';

describe('report action', () => {
  describe('setXmlContents', () => {
    it('should work', async () => {
      const mockXml = 'mock xml';
      const presenter = createPresenterMock({
        useCaseMocks: {
          validateSSP: jest.fn(async (xml: string) => {
            expect(xml).toEqual(mockXml);
            return Promise.resolve({
              failedAsserts: [],
            });
          }),
        },
      });
      expect(presenter.state.report.current).toEqual('UNLOADED');
      const promise = presenter.actions.report.setXmlContents(mockXml);
      expect(presenter.state.report.current).toEqual('PROCESSING_STRING');
      await promise;
      expect(presenter.state.report.current).toEqual('VALIDATED');
    });
  });

  describe('setFilterRole', () => {
    it('works', () => {
      const presenter = createPresenterMock();
      expect(presenter.state.report.current).toEqual('UNLOADED');
      presenter.actions.report.setFilterRole('error');
      expect(presenter.state.report.current).toEqual('UNLOADED');
      presenter.actions.report.setValidationReport(MOCK_VALIDATION_REPORT);
    });
  });

  describe('setFilterText', () => {
    it('works', () => {
      const presenter = createPresenterMock();
      expect(presenter.state.report.current).toEqual('UNLOADED');
      presenter.actions.report.setFilterText('filter text');
      expect(presenter.state.report.current).toEqual('UNLOADED');
      presenter.actions.report.setValidationReport(MOCK_VALIDATION_REPORT);
      presenter.actions.report.setFilterText('filter text');
      expect(presenter.state.report).toMatchObject({
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
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
    },
    {
      text: 'ASSERT TEXT 2',
      test: 'not(exists($core-missing))',
      id: 'incomplete-core-implemented-requirements',
      role: 'error',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
    },
  ],
};
