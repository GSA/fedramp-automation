export type GithubRepository = {
  owner: string;
  repository: string;
  branch: string;
};

export const DEFAULT_REPOSITORY: GithubRepository = {
  owner: '18F',
  repository: 'fedramp-automation',
  branch: 'master',
};

export const getBranchTreeUrl = (github: GithubRepository) => {
  if (github.branch === DEFAULT_REPOSITORY.branch) {
    return `https://github.com/${github.owner}/${github.repository}`;
  }
  return `https://github.com/${github.owner}/${github.repository}/tree/${github.branch}`;
};

export const getRepositoryRawUrl = (
  github: GithubRepository,
  repositoryPath: string,
) => {
  return `https://raw.githubusercontent.com/${github.owner}/${github.repository}/${github.branch}/${repositoryPath}`;
};
