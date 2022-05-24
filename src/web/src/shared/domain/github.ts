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

const SAMPLE_SSP_PATHS = [
  'dist/content/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml',
  'dist/content/templates/poam/json/FedRAMP-POAM-OSCAL-Template.json',
  'dist/content/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml',
  'dist/content/templates/sap/json/FedRAMP-SAP-OSCAL-Template.json',
  'dist/content/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml',
  'dist/content/templates/sar/json/FedRAMP-SAR-OSCAL-Template.json',
  'dist/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml',
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
