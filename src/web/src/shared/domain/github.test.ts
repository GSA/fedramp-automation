import * as github from './github';

describe('github', () => {
  describe('getBranchTreeUrl', () => {
    it('returns a root URL for the default branch', () => {
      expect(
        github.getBranchTreeUrl({
          owner: 'owner',
          branch: 'develop',
          repository: 'my-repository',
        }),
      ).toEqual('https://github.com/owner/my-repository');
    });
    it('returns a tree URL', () => {
      expect(
        github.getBranchTreeUrl({
          owner: 'owner',
          branch: 'branch-name',
          repository: 'my-repository',
        }),
      ).toEqual('https://github.com/owner/my-repository/tree/branch-name');
    });
  });
  describe('getRepositoryRawUrl', () => {
    it('returns well-formed URL', () => {
      expect(
        github.getRepositoryRawUrl(
          {
            owner: '18F',
            branch: 'master',
            repository: 'fedramp-automation',
          },
          'src/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
        ),
      ).toEqual(
        'https://raw.githubusercontent.com/18F/fedramp-automation/master/src/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
      );
    });
  });
});
