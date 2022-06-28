export type AssertionGroup = {
  title: string;
  assertionIds: string[];
  groups: Array<AssertionGroup> | undefined;
};

const getAssertionGroup = (input: any): AssertionGroup => {
  if (typeof input.title !== 'string') {
    throw new Error('title not a string');
  }
  if (!Array.isArray(input.assertionIds)) {
    throw new Error('assertionIds not an array');
  }
  if (
    input.groups !== undefined &&
    (!Array.isArray(input.groups) ||
      !Array.from(input.groups).every(group => getAssertionGroup(group)))
  ) {
    throw new Error('groups not an array of assertion groups');
  }
  return {
    title: input.title as string,
    assertionIds: input.assertionIds as string[],
    groups: (input.groups as AssertionGroup[]) || undefined,
  } as AssertionGroup;
};

const getAssertionView = (input: any): AssertionView => {
  if (typeof input.title !== 'string') {
    throw new Error('input title is not a string');
  }
  try {
    return {
      title: input.title as string,
      groups: Array.from(input.groups).map(group => getAssertionGroup(group)),
    };
  } catch (e) {
    throw new Error('assertion view groups is not array of assertion groups');
  }
};

export type AssertionView = {
  title: string;
  groups: AssertionGroup[];
};
type AssertionViews = AssertionView[];

// Confirm that an input object (sourced from XSLT output) conforms to the
// Typescript expectation.
export const validateAssertionViews = (input: any): AssertionViews | null => {
  if (!Array.isArray(input)) {
    return null;
  }
  try {
    return Array.from(input).map(view => getAssertionView(view));
  } catch (e) {
    console.error(e);
    return null;
  }
};

export type GetAssertionViews = () => Promise<{
  poam: AssertionViews;
  sap: AssertionViews;
  sar: AssertionViews;
  ssp: AssertionViews;
}>;

export type XSLTProcessor = (
  stylesheetText: string,
  sourceText: string,
) => Promise<string>;

export const WriteAssertionViews =
  (ctx: {
    paths: {
      assertionViewSEFPath: string;
    };
    processXSLT: XSLTProcessor;
    readStringFile: (fileName: string) => Promise<string>;
    writeStringFile: (fileName: string, contents: string) => Promise<void>;
  }) =>
  async ({
    outputFilePath,
    schematronXMLPath,
  }: {
    outputFilePath: string;
    schematronXMLPath: string;
  }) => {
    const stylesheetSEFText = await ctx.readStringFile(
      ctx.paths.assertionViewSEFPath,
    );
    const schematronXML = await ctx.readStringFile(schematronXMLPath);
    const assertionViewJSON = await ctx.processXSLT(
      stylesheetSEFText,
      schematronXML,
    );
    const assertionViews = validateAssertionViews(
      JSON.parse(assertionViewJSON),
    );
    await ctx.writeStringFile(outputFilePath, JSON.stringify(assertionViews));
    console.log(`Wrote ${outputFilePath}`);
  };
export type WriteAssertionViews = ReturnType<typeof WriteAssertionViews>;
