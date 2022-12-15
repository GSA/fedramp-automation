import { REPOSITORY_PATHS } from '../project-config';
import { getBlobFileUrl, GithubRepository } from './github';
import { OscalDocumentKey } from './oscal';
import {
  getSchematronAssertLineRanges,
  SchematronRulesetKey,
} from './schematron';
import { LineRange } from './text';

export const getDocumentReferenceUrls = ({
  github,
  documentType,
  schXmlString,
  rulesetKey,
}: {
  github: GithubRepository;
  documentType: OscalDocumentKey;
  schXmlString: string;
  rulesetKey: SchematronRulesetKey;
}) => {
  return {
    assertions: getElementReferenceUrls({
      lineRanges: getSchematronAssertLineRanges(schXmlString),
      github,
      xmlRepositoryPath: REPOSITORY_PATHS[rulesetKey].SCHEMATRON[documentType],
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
