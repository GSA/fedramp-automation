import { it, describe, expect } from 'vitest';

import * as github from './github';

describe('github', () => {
  describe('getBranchTreeUrl', () => {
    it('returns a root URL for the default branch', () => {
      expect(
        github.getBranchTreeUrl({
          owner: 'owner',
          branch: 'master',
          repository: 'my-repository',
          commit: 'master',
        }),
      ).toEqual('https://github.com/owner/my-repository');
    });
    it('returns a tree URL', () => {
      expect(
        github.getBranchTreeUrl({
          owner: 'owner',
          branch: 'branch-name',
          repository: 'my-repository',
          commit: 'master',
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
            commit: 'master',
          },
          'src/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
        ),
      ).toEqual(
        'https://raw.githubusercontent.com/18F/fedramp-automation/master/src/validations/test/demo/FedRAMP-SSP-OSCAL-Template.xml',
      );
    });
  });
  describe('getDeveloperExampleUrl', () => {
    it('returns correct URL for repository', () => {
      expect(
        github.getDeveloperExampleUrl({
          owner: '18F',
          branch: 'my-branch',
          repository: 'fedramp-automation',
          commit: 'master',
        }),
      ).toEqual(
        'https://github.com/18F/fedramp-automation/tree/my-branch/src/examples',
      );
    });
  });
  describe('getBlobFileUrl', () => {
    it('returns correct URL with line numbers', () => {
      expect(
        github.getBlobFileUrl(
          {
            owner: '18F',
            branch: 'master',
            repository: 'fedramp-automation',
            commit: 'master',
          },
          '/src/validations/rules/ssp.sch',
          { start: 545, end: 551 },
        ),
      ).toEqual(
        'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch#L545-L551',
      );
    });
    it('returns correct URL without line numbers', () => {
      expect(
        github.getBlobFileUrl(
          {
            owner: '18F',
            branch: 'master',
            repository: 'fedramp-automation',
            commit: 'master',
          },
          '/src/validations/rules/ssp.sch',
        ),
      ).toEqual(
        'https://github.com/18F/fedramp-automation/blob/master/src/validations/rules/ssp.sch',
      );
    });
  });
});
