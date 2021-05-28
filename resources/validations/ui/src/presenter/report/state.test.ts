import type { ValidationReport } from 'src/use-cases/validate-ssp-xml';
import { createPresenterMock } from '..';

describe('report state', () => {
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
