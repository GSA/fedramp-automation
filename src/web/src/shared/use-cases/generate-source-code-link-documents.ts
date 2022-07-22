import { join } from 'path';

import { GithubRepository } from '../domain/github';
import { OscalDocumentKeys } from '../domain/oscal';
import { getDocumentReferenceUrls } from '../domain/source-code-links';
import {
  SCHEMATRON_LOCAL_PATHS,
  SCHEMATRON_REPOSITORY_PATHS,
  XSPEC_LOCAL_PATHS,
  XSPEC_REPOSITORY_PATHS,
} from '../project-config';

type Context = {
  github: GithubRepository;
  readFile: (path: string) => Promise<string>;
  writeFile: (path: string, contents: string) => void;
};

export class SourceCodeLinkDocumentGenerator {
  constructor(
    private github: GithubRepository,
    private readFile: (path: string) => Promise<string>,
    private writeFile: (path: string, contents: string) => void,
  ) {}

  createDocument(targetDir: string) {
    OscalDocumentKeys.forEach(async documentType => {
      const referenceUrls = getDocumentReferenceUrls({
        github: this.github,
        documentType,
        schXmlString: await this.readFile(SCHEMATRON_LOCAL_PATHS[documentType]),
        xspecXmlString: await this.readFile(XSPEC_LOCAL_PATHS[documentType]),
      });
      await this.writeFile(
        join(targetDir, `reference-urls-${documentType}.json`),
        JSON.stringify(referenceUrls),
      );
    });
  }
}
function PROJECT_ROOT(PROJECT_ROOT: any, arg1: string): string {
  throw new Error('Function not implemented.');
}
