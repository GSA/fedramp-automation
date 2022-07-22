import { SCHEMATRON_REPOSITORY_PATHS } from '../project-config';
import { getBranchFileUrl, GithubRepository } from './github';
import { OscalDocumentKey } from './oscal';
import { getLineRangesForElement } from './xml';

export const getDocumentReferenceUrls = ({
  github,
  documentType,
  schXmlString,
  xspecXmlString,
}: {
  github: GithubRepository;
  documentType: OscalDocumentKey;
  schXmlString: string;
  xspecXmlString: string;
}) => {
  return {
    assertions: getElementReferenceUrls({
      github,
      element: 'sch:assert',
      xmlRepositoryPath: SCHEMATRON_REPOSITORY_PATHS[documentType],
      xmlString: schXmlString,
    }),
    xspecScenarios: getElementReferenceUrls({
      github,
      element: 'sch:assert',
      xmlRepositoryPath: SCHEMATRON_REPOSITORY_PATHS[documentType],
      xmlString: xspecXmlString,
    }),
  };
};

export type DocumentReferenceUrls = ReturnType<typeof getDocumentReferenceUrls>;

const getElementReferenceUrls = ({
  github,
  element,
  xmlString,
  xmlRepositoryPath,
}: {
  github: GithubRepository;
  element: string;
  xmlString: string;
  xmlRepositoryPath: `/${string}`;
}) => {
  const lineRanges = getLineRangesForElement(xmlString, element);
  return Object.entries(lineRanges).reduce(
    (acc: Record<string, string>, [id, lineRange]) => {
      if (lineRange) {
        acc[id] = getBranchFileUrl(github, xmlRepositoryPath, {
          start: lineRange.start + 1,
          end: lineRange.end + 1,
        });
      } else {
        acc[id] = getBranchFileUrl(github, xmlRepositoryPath);
      }
      return acc;
    },
    {},
  );
};
