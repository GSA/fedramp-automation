import {
  SCHEMATRON_REPOSITORY_PATHS,
  XSPEC_REPOSITORY_PATHS,
} from '../project-config';
import { getBlobFileUrl, GithubRepository } from './github';
import { OscalDocumentKey } from './oscal';
import { getSchematronAssertLineRanges } from './schematron';
import { LineRange } from './text';

export const getDocumentReferenceUrls = ({
  github,
  documentType,
  schXmlString,
}: {
  github: GithubRepository;
  documentType: OscalDocumentKey;
  schXmlString: string;
  xspecXmlString: string;
}) => {
  return {
    assertions: getElementReferenceUrls({
      lineRanges: getSchematronAssertLineRanges(schXmlString),
      github,
      xmlRepositoryPath: SCHEMATRON_REPOSITORY_PATHS[documentType],
    }),
  };
};

export type DocumentReferenceUrls = ReturnType<typeof getDocumentReferenceUrls>;

const getElementReferenceUrls = ({
  lineRanges,
  github,
  xmlRepositoryPath,
}: {
  lineRanges: Record<string, LineRange>;
  github: GithubRepository;
  xmlRepositoryPath: `/${string}`;
}) => {
  return Object.entries(lineRanges).reduce(
    (acc: Record<string, string>, [id, lineRange]) => {
      if (lineRange) {
        acc[id] = getBlobFileUrl(github, xmlRepositoryPath, lineRange);
      } else {
        acc[id] = getBlobFileUrl(github, xmlRepositoryPath);
      }
      return acc;
    },
    {},
  );
};
