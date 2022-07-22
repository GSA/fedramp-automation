export type FormatXml = (xml: string) => string;
export type IndentXml = (xml: string) => Promise<string>;

type LineRange = { start: number; end: number } | null;
export const getLineNumbersForElementById = (xml: string, element: string) => {
  const regEx = new RegExp(
    `<${element}[^]*?\\sid=\\"([^\\"]+)\\"[^]*?</${element}>`,
    'g',
  );
  const matches = xml.matchAll(regEx);

  const lineNumbers: Record<string, LineRange> = {};
  for (const match of matches) {
    const elementString = match[0];
    const id = match[1];
    lineNumbers[id] = linesOf(xml, elementString);
  }
  return lineNumbers;
};

const linesOf = (text: string, substring: string) => {
  let line = 0;
  let matchLine = 0;
  let matchedChars = 0;

  for (let i = 0; i < text.length; i++) {
    if (text[i] === substring[matchedChars]) {
      matchedChars++;
    } else {
      matchedChars = 0;
      matchLine = 0;
    }
    if (matchedChars === substring.length) {
      return {
        start: line - matchLine,
        end: line,
      };
    }
    if (text[i] === '\n') {
      line++;
      if (matchedChars > 0) {
        matchLine++;
      }
    }
  }

  return null;
};
