import { linesOfXml } from './text';
import { groupBy } from '../util';
import type { FormatXml } from './xml';
import { getBlobFileUrl, GithubRepository } from './github';

type XspecAssert = {
  id: string;
  label: string;
};

export type XSpecScenarioNode = {
  node: 'x:scenario';
  label: string;
  children: XSpecNode[];
};
type XSpecContextNode = {
  node: 'x:context';
  context: string;
};
type XSpecAssertionNode =
  | {
      node: 'x:expect-not-assert';
      id: string;
      label: string;
    }
  | {
      node: 'x:expect-assert';
      id: string;
      label: string;
    };
export type XSpecNode =
  | XSpecScenarioNode
  | XSpecContextNode
  | XSpecAssertionNode;

export type XSpecScenario = {
  label: string;
  scenarios?: XSpecScenario[];
  context?: string;
  expectAssert?: XspecAssert[];
  expectNotAssert?: XspecAssert[];
};

export type ParseXSpec = (xmlString: string) => XSpecScenarioNode[];

// A flattened summary of an XSpec scenario, suitable for documentation.
export type AssertionSummary = {
  assertionId: string;
  assertionLabel: string;
  context: string;
  expectAssert: boolean;
  referenceUrl: string | null;
  scenarios: { url: string | null; label: string }[];
};

export type SummariesByAssertionId = {
  [key: string]: AssertionSummary[];
};

type XSpecNodeContext = {
  current: {
    encounteredElements: XSpecNode[];
    context?: string;
  };
  assertions: {
    id: string;
    label: string;
    expectAssert: boolean;
  }[];
};

type NodeParseContext = {
  context: string;
  parentNodes: XSpecNode[];
  childNodes: XSpecNode[];
};
export const getXSpecAssertionSummaries = (
  ctx: { formatXml: FormatXml },
  github: GithubRepository,
  repositoryPath: `/${string}`,
  xSpecNodes: XSpecScenarioNode[],
  xspecString: string,
) => {
  const encounteredElements: string[] = [];

  const parseNode = (
    xSpecNode: XSpecNode,
    nodeContext: NodeParseContext = {
      context: '',
      parentNodes: [],
      childNodes: [],
    },
  ): { context: string; assertions: AssertionSummary[] } => {
    encounteredElements.push(xSpecNode.node);

    let childContext = {
      ...nodeContext,
    };
    if (xSpecNode.node === 'x:scenario') {
      childContext = {
        ...childContext,
        parentNodes: [...childContext.parentNodes, xSpecNode],
      };
      return {
        assertions: xSpecNode.children.flatMap(child => {
          const parseResult = parseNode(child, childContext);
          childContext.context = parseResult.context;
          return parseResult.assertions;
        }),
        context: childContext.context,
      };
    }

    const assertions: XSpecAssertionNode[] = [];
    if (xSpecNode.node === 'x:context') {
      childContext.context = xSpecNode.context;
    } else if (xSpecNode.node === 'x:expect-assert') {
      assertions.push(xSpecNode);
    } else if (xSpecNode.node === 'x:expect-not-assert') {
      assertions.push(xSpecNode);
    }

    return {
      context: childContext.context,
      assertions: assertions.map((assertionNode: XSpecAssertionNode) => {
        return {
          assertionId: assertionNode.id,
          assertionLabel: assertionNode.label,
          context: ctx.formatXml(nodeContext.context),
          expectAssert: assertionNode.node === 'x:expect-assert',
          referenceUrl: getElementUrlByPosition(
            { github, repositoryPath, xspecString },
            encounteredElements,
            [encounteredElements[encounteredElements.length - 1]],
          ),
          scenarios: nodeContext.parentNodes
            .filter(parentNode => parentNode.node === 'x:scenario')
            .map(parentNode => {
              const scenarioNode = parentNode as XSpecScenarioNode;
              return {
                url: null /*getElementUrlByPosition(
                  { github, repositoryPath, xspecString },
                  encounteredElements,
                  nodeContext.childNodes
                    .map(childNode => childNode.node)
                    .reverse(),
                )*/,
                label: scenarioNode.label,
              };
            }),
        };
      }),
    };
  };
  const assertions = xSpecNodes.flatMap(node => parseNode(node).assertions);
  return groupBy(assertions, summary => summary.assertionId);
};

const getElementUrlByPosition = (
  opts: {
    github: GithubRepository;
    repositoryPath: `/${string}`;
    xspecString: string;
  },
  precedingOpenedTags: string[],
  innerTags: string[],
) => {
  const lineRange = linesOfXml(
    opts.xspecString,
    precedingOpenedTags,
    innerTags.reverse(),
  );
  return lineRange
    ? getBlobFileUrl(opts.github, opts.repositoryPath, lineRange)
    : null;
};
