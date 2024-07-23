import { exec, ExecException, spawnSync } from "child_process";
import { YAMLError } from "yaml";

export class OscalCli {
  path: string;

  public constructor(path: string) {
    this.path = path;
  }

  public validate(file: string): void {
    console.log(__dirname);
   spawnSync(this.path,['validate','-c','/Users/davidawaltermire/git/david-waltermire/fedramp/fedramp-automation/fedramp-external-constraints.xml','-o','out.sarif',file], { stdio: 'inherit'});
  }
}

