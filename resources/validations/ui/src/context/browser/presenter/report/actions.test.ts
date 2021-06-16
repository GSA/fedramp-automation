import { createPresenterMock } from '..';

describe('report action', () => {
  describe('setXmlContents', () => {
    it('should work', async () => {
      const mockXml = 'mock xml';
      const presenter = createPresenterMock({
        validateSchematron: jest.fn(async (xml: string) => {
          expect(xml).toEqual(mockXml);
          return Promise.resolve({
            failedAsserts: [],
          });
        }),
      });
      expect(presenter.state).toMatchObject({
        report: {
          loadingValidationReport: false,
          validationReport: null,
        },
      });
      await presenter.actions.report.setXmlContents(mockXml);
      expect(presenter.state).toMatchObject({
        report: {
          loadingValidationReport: false,
          validationReport: {
            failedAsserts: [],
          },
        },
      });
    });
  });

  describe('setFilterRole', () => {
    it('works', () => {
      const presenter = createPresenterMock();
      expect(presenter.state).toMatchObject({
        report: {
          filter: {
            role: 'all',
          },
        },
      });
      presenter.actions.report.setFilterRole('error');
      expect(presenter.state).toMatchObject({
        report: {
          filter: {
            role: 'error',
          },
        },
      });
    });
  });

  describe('setFilterText', () => {
    it('works', () => {
      const presenter = createPresenterMock();
      expect(presenter.state).toMatchObject({
        report: {
          filter: {
            text: '',
          },
        },
      });
      presenter.actions.report.setFilterText('filter text');
      expect(presenter.state).toMatchObject({
        report: {
          filter: {
            text: 'filter text',
          },
        },
      });
    });
  });
});
