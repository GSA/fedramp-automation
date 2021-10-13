export type GithubRepository = {
  owner: string;
  repository: string;
  branch: string;
};

export const DEFAULT_REPOSITORY: GithubRepository = {
  owner: '18F',
  repository: 'fedramp-automation',
  branch: 'develop',
};

const SAMPLE_SSP_PATHS = [
  'src/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml',
  'dist/content/templates/ssp/json/FedRAMP-SSP-OSCAL-Template.json',
];

export const getBranchTreeUrl = (
  github: GithubRepository,
  useDefaultShortForm = true,
) => {
  if (useDefaultShortForm && github.branch === DEFAULT_REPOSITORY.branch) {
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

export const getSampleSSPs = (github: GithubRepository) => {
  return SAMPLE_SSP_PATHS.map(url => {
    const urlParts = url.split('/');
    return {
      url: getRepositoryRawUrl(github, url),
      displayName: urlParts[urlParts.length - 1],
    };
  });
};

export const getDeveloperExampleUrl = (github: GithubRepository) => {
  const branchTree = getBranchTreeUrl(github, false);
  return `${branchTree}/src/examples`;
};
