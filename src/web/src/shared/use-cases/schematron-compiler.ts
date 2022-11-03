import { execSync } from 'child_process';

import { OscalDocumentKey, OscalDocumentKeys } from '../domain/oscal';
import {
  SchematronRulesetKey,
  SchematronRulesetKeys,
} from '../domain/schematron';
import { BUILD_PATH, REPOSITORY_ROOT } from '../project-config';

const STAGE_1 = `${REPOSITORY_ROOT}/vendor/schematron/trunk/schematron/code/iso_dsdl_include.xsl`;
const STAGE_2 = `${REPOSITORY_ROOT}/vendor/schematron/trunk/schematron/code/iso_abstract_expand.xsl`;
const STAGE_3 = `${REPOSITORY_ROOT}/vendor/schematron/trunk/schematron/code/iso_svrl_for_xslt2.xsl`;

export class SchematronCompiler {
  constructor(private console: Console) {}

  async compileAll() {
    for (const rulesetKey of SchematronRulesetKeys) {
      for (const documentType of OscalDocumentKeys) {
        await this.compile(rulesetKey, documentType);
      }
    }
  }

  async compile(
    rulesetKey: SchematronRulesetKey,
    documentType: OscalDocumentKey,
  ) {
    this.console.log(`Compiling Schematron for ${rulesetKey}:${documentType}`);
    const sourceFile = `${REPOSITORY_ROOT}/src/validations/rules/${rulesetKey}/${documentType}.sch`;
    const outDir = `${BUILD_PATH}/${rulesetKey}`;

    /**
     * This compilation uses the `xslt3` command-line utility, which should be
     * installed in node_modules. It is not, at time of writing, possible to
     * compile XSLT using the SaxonJS API.
     * It is also possible to use Saxon Java library, but this method avoids
     * adding Java as a dependency to the frontend.
     */
    execSync(`mkdirp ${outDir}`);
    execSync(
      `xslt3 -s:${sourceFile} -xsl:${STAGE_1} -o:${outDir}/${documentType}-stage1.sch allow-foreign=true diagnose=true`,
    );
    execSync(
      `xslt3 -s:${outDir}/${documentType}-stage1.sch -xsl:${STAGE_2} -o:${outDir}/${documentType}-stage2.sch allow-foreign=true diagnose=true`,
    );
    execSync(
      `xslt3 -s:${outDir}/${documentType}-stage2.sch -xsl:${STAGE_3} -o:${outDir}/${documentType}.xsl allow-foreign=true diagnose=true`,
    );
    execSync(
      `xslt3 -xsl:${outDir}/${documentType}.xsl -export:${outDir}/${documentType}.sef.json -relocate:on -nogo`,
    );
  }
}
