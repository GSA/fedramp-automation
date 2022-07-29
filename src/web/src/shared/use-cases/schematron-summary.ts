import { ParseSchematronAssertions } from '../domain/schematron';

export class SchematronSummary {
  constructor(
    private parseSchematron: ParseSchematronAssertions,
    private readStringFile: (fileName: string) => Promise<string>,
    private writeStringFile: (
      fileName: string,
      contents: string,
    ) => Promise<void>,
  ) {}

  async generate(inputSchXmlFile: string, outputSchJsonFile: string) {
    const xmlString = await this.readStringFile(inputSchXmlFile);
    const schematronObject = await this.parseSchematron(xmlString);
    await this.writeStringFile(
      outputSchJsonFile,
      JSON.stringify(schematronObject),
    );
  }
}
