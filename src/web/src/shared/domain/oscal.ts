export const OscalDocumentKeys = ['poam', 'sap', 'sar', 'ssp'] as const;
export type OscalDocumentKey = typeof OscalDocumentKeys[number];

const ROOT_NODE_MAPPING: Record<string, OscalDocumentKey> = {
  'plan-of-action-and-milestones': 'poam',
  'assessment-plan': 'sap',
  'assessment-results': 'sar',
  'system-security-plan': 'ssp',
};

export const getDocumentTypeForRootNode = (
  rootNodeName: string,
): OscalDocumentKey | null => {
  return ROOT_NODE_MAPPING[rootNodeName] || null;
};
