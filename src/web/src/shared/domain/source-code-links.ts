import {
  SCHEMATRON_REPOSITORY_PATHS,
  XSPEC_REPOSITORY_PATHS,
} from '../project-config';
import { getBlobFileUrl, GithubRepository } from './github';
import { OscalDocumentKey } from './oscal';
import { getLineRangesForElement } from './text';

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
      idAttributeName: 'id',
      xmlRepositoryPath: SCHEMATRON_REPOSITORY_PATHS[documentType],
      xmlString: schXmlString,
    }),
    xspecScenarios: getElementReferenceUrls({
      github,
      element: 'x:scenario',
      idAttributeName: 'label',
      xmlRepositoryPath: XSPEC_REPOSITORY_PATHS[documentType],
      xmlString: xspecXmlString,
    }),
  };
};

export type DocumentReferenceUrls = ReturnType<typeof getDocumentReferenceUrls>;

const getElementReferenceUrls = ({
  github,
  element,
  idAttributeName,
  xmlString,
  xmlRepositoryPath,
}: {
  github: GithubRepository;
  element: string;
  idAttributeName: string;
  xmlString: string;
  xmlRepositoryPath: `/${string}`;
}) => {
  const lineRanges = getLineRangesForElement(
    xmlString,
    element,
    idAttributeName,
  );
  return Object.entries(lineRanges).reduce(
    (acc: Record<string, string>, [id, lineRange]) => {
      if (lineRange) {
        acc[id] = getBlobFileUrl(github, xmlRepositoryPath, {
          start: lineRange.start + 1,
          end: lineRange.end + 1,
        });
      } else {
        acc[id] = getBlobFileUrl(github, xmlRepositoryPath);
      }
      return acc;
    },
    {},
  );
};
