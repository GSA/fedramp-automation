import { LineRange, linesOf } from './text';

const ElementRegExp = (element: string, idAttributeName: string) =>
  new RegExp(
    `<${element}[^]*?\\s${idAttributeName}=\\"([^\\"]+)\\"[^]*?</${element}>`,
    'g',
  );

const ScenarioRegExp = (scenarioLabels: string[]) => {
  const element = 'x:scenario';
  const idAttributeName = 'label';
  const prefix = scenarioLabels
    .map(label => `<${element}[^]*?\\s${idAttributeName}=\\"${label}\\"`)
    .join('');
  const suffix = scenarioLabels.map(label => `[^]*?</${element}>`).join('');
  return new RegExp(`${prefix}${suffix}`, 'g');
};

export const getSchematronAssertLineRanges = (xml: string) => {
  const regExp = new RegExp(
    `<sch:assert[^]*?\\sid=\\"([^\\"]+)\\"[^]*?</sch:assert>`,
    'g',
  );
  const matches = xml.matchAll(regExp);

  const lineNumbers: Record<string, LineRange> = {};
  for (const match of matches) {
    const elementString = match[0];
    const idAttribute = match[1];
    lineNumbers[idAttribute] = linesOf(xml, elementString);
  }
  return lineNumbers;
};
