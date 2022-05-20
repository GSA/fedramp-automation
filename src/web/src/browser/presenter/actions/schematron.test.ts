import { createPresenterMock, Presenter } from '..';

xdescribe('schematron', () => {
  let presenter: Presenter;

  beforeEach(() => {
    presenter = createPresenterMock();
    presenter.actions.validator.setValidationReport({
      validationReport: MOCK_VALIDATION_REPORT,
      xmlText: '<xml></xml>',
    });
  });

  describe('filtering', () => {
    it('by role works', () => {
      presenter.state.schematron.ssp.send('CONFIG_LOADED', {
        config: {
          assertionViews: [
            {
              title: 'test view',
              groups: [
                {
                  title: 'test group',
                  assertionIds: [
                    'incorrect-role-association',
                    'incomplete-core-implemented-requirements',
                  ],
                  groups: [],
                },
              ],
            },
          ],
          schematronAsserts: MOCK_SCHEMATRON_ASSERTIONS,
        },
      });
      expect(presenter.state.schematron.ssp.filter).toEqual({
        assertionViewId: 0,
        role: 'all',
        text: '',
      });
      expect(presenter.state.schematron.ssp.filterOptions.roles).toEqual([
        'all',
        'error',
        'info',
        'warn',
      ]);
      presenter.actions.schematron.setFilterRole('error');
      expect(presenter.state.schematron.ssp.filter).toEqual({
        role: 'error',
        text: '',
      });
      expect(presenter.state.schematron.ssp.schematronReport).toEqual({
        groups: [
          {
            checks: {
              checks: [
                {
                  fired: [],
                  icon: {
                    color: 'blue',
                    sprite: 'navigate_next',
                  },
                  id: 'incorrect-role-association',
                  message: 'incorrect role assertion message',
                  role: 'error',
                },
              ],
              summary: '1 checks',
              summaryColor: 'green',
            },
            title: 'System Security Plan',
          },
        ],
        summary: {
          title: 'FedRAMP Package Concerns (unprocessed)',
          counts: {
            assertions: 1,
          },
        },
      });
    });

    it('by text works', () => {
      expect(presenter.state.schematron.ssp.filter).toEqual({
        assertionViewId: 0,
        role: 'all',
        text: '',
      });
      expect(presenter.state.schematron.ssp.filterOptions.roles).toEqual([
        'all',
        'error',
        'info',
        'warn',
      ]);
      presenter.actions.schematron.setFilterText('incomplete');
      expect(presenter.state.schematron.ssp.filter).toEqual({
        role: 'all',
        text: 'incomplete',
      });
      expect(presenter.state.schematron.ssp.schematronReport).toEqual({
        groups: [
          {
            checks: {
              checks: [
                {
                  fired: [],
                  icon: {
                    color: 'blue',
                    sprite: 'navigate_next',
                  },
                  id: 'incomplete-core-implemented-requirements',
                  message:
                    'incomplete core implemented requirements assertion message',
                  role: 'info',
                },
              ],
              summary: '1 checks',
              summaryColor: 'green',
            },
            title: 'System Security Plan',
          },
        ],
        summary: {
          title: 'FedRAMP Package Concerns (unprocessed)',
          counts: {
            assertions: 1,
          },
        },
      });
    });
  });
});

const MOCK_SCHEMATRON_ASSERTIONS = [
  {
    id: 'incorrect-role-association',
    message: 'incorrect role assertion message',
    role: 'error',
  },
  {
    id: 'incomplete-core-implemented-requirements',
    message: 'incomplete core implemented requirements assertion message',
    role: 'info',
  },
  {
    id: 'untriggered-requirement',
    message: 'untriggered requirement assertion message',
    role: 'warn',
  },
];

const MOCK_VALIDATION_REPORT = {
  title: 'title',
  failedAsserts: [
    {
      text: 'ASSERT TEXT 1',
      test: 'not(exists($extraneous-roles))',
      id: 'incorrect-role-association',
      uniqueId: 'incorrect-role-association-1',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:metadata[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
      diagnosticReferences: [],
    },
    {
      text: 'ASSERT TEXT 2',
      test: 'not(exists($core-missing))',
      id: 'incomplete-core-implemented-requirements',
      uniqueId: 'incomplete-core-implemented-requirements-1',
      role: 'error',
      location:
        "/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:control-implementation[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]",
      diagnosticReferences: [],
    },
  ],
};
