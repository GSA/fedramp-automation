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
