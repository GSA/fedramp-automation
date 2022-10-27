export type GithubRepository = {
  owner: string;
  repository: string;
  branch: string;
  commit: string;
};

export const DEFAULT_REPOSITORY: GithubRepository = {
  owner: '18F',
  repository: 'fedramp-automation',
  branch: 'master',
  commit: 'master',
};

const SAMPLE_OSCAL_PATHS = [
  'dist/content/rev4/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml',
  'dist/content/rev4/templates/poam/json/FedRAMP-POAM-OSCAL-Template.json',
  'dist/content/rev4/templates/poam/yaml/FedRAMP-POAM-OSCAL-Template.yaml',
  'dist/content/rev4/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml',
  'dist/content/rev4/templates/sap/json/FedRAMP-SAP-OSCAL-Template.json',
  'dist/content/rev4/templates/sap/yaml/FedRAMP-SAP-OSCAL-Template.yaml',
  'dist/content/rev4/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml',
  'dist/content/rev4/templates/sar/json/FedRAMP-SAR-OSCAL-Template.json',
  'dist/content/rev4/templates/sar/yaml/FedRAMP-SAR-OSCAL-Template.yaml',
  'dist/content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml',
  'dist/content/rev4/templates/ssp/json/FedRAMP-SSP-OSCAL-Template.json',
  'dist/content/rev4/templates/ssp/yaml/FedRAMP-SSP-OSCAL-Template.yaml',
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

type LineRange = { start: number; end: number };
export const getBlobFileUrl = (
  github: GithubRepository,
  repositoryPath: `/${string}`,
  lineRange?: LineRange,
) => {
  const blobUrl = `https://github.com/${github.owner}/${github.repository}/blob/${github.commit}${repositoryPath}`;
  if (!lineRange) {
    return blobUrl;
  }
  return `${blobUrl}#L${lineRange.start}-L${lineRange.end}`;
};

export const getRepositoryRawUrl = (
  github: GithubRepository,
  repositoryPath: string,
) => {
  return `https://raw.githubusercontent.com/${github.owner}/${github.repository}/${github.branch}/${repositoryPath}`;
};

export const getSampleOscalDocuments = (github: GithubRepository) => {
  return SAMPLE_OSCAL_PATHS.map(url => {
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

export const getNewIssueUrl = (github: GithubRepository) => {
  return `https://github.com/${github.owner}/${github.repository}/issues/new/choose`;
};
