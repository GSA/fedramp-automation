export type LineRange = { start: number; end: number } | null;

/**
 * Returns the 1-indexed start and end line numbers for a substring.
 * @param text string to file line numbers of
 * @param substring string to search
 * @returns start and end line numbers
 */
export const linesOf = (text: string, substring: string) => {
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
        start: line - matchLine + 1,
        end: line + 1,
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

const clipBefore = (str: string, elem: string) => {
  const startIndex = str.substring(1).search(`<${elem}`) + 1;
  return str.substring(startIndex);
};

const closingIndex = (str: string, elem: string) => {
  const pattern = `</${elem}>`;
  const index = str.search(pattern);
  if (index > -1) {
    return index + pattern.length;
  }

  const selfClosingPattern = '/>';
  const selfClosingIndex = str.search(selfClosingPattern);
  if (selfClosingIndex === -1) {
    throw new Error(`cosingIndex: cannot find ${str}`);
  }
  return selfClosingIndex + selfClosingPattern.length;
};

const clipAfter = (str: string, elems: string[]) => {
  let endIndex = 0;
  for (const elem of elems) {
    endIndex = endIndex + closingIndex(str.substring(endIndex), elem);
  }
  return str.substring(0, endIndex);
};

export const getElementString = (
  xml: string,
  openedElements: string[],
  closedElements: string[],
) => {
  let elementString = xml;
  for (const openedElement of openedElements) {
    elementString = clipBefore(elementString, openedElement);
  }
  elementString = clipAfter(elementString, closedElements);
  return elementString;
};

/**
 * Using the parent nodes of an element, returns the lines of an XML node
 * within a document.
 * @param xml document to search
 * @param openedElements list of preceding, opened parent nodes
 * @param closedElements list of closing nodes to include in the matched pattern
 * @returns start and end lines
 */
export const linesOfXml = (
  xml: string,
  openedElements: string[],
  closedElements: string[],
) => {
  const elementString = getElementString(xml, openedElements, closedElements);
  const lines = linesOf(xml, elementString);
  return lines;
};

const createXmlMatchRegExp = (
  openedElements: string[],
  closedElements: string[],
) => {
  const prefixElements = openedElements.slice(0, openedElements.length - 1);
  const matchOpenedElement = openedElements[openedElements.length - 1];

  const prefix = prefixElements.map(elem => `<${elem}[^>]*?>[^]*?`).join('');
  const suffix = closedElements
    .map(elem => `[^]+?(<\\/${elem}>|\\/>)`)
    .join('');

  const regExp = `(?:${prefix})(<${matchOpenedElement}${suffix})`;
  return new RegExp(regExp, 'u');
};
