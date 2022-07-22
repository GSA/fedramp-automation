import { DocumentReferenceUrls } from '@asap/shared/domain/source-code-links';
import type { AssertionView } from '@asap/shared/use-cases/assertion-views';
import type { SchematronAssert } from '@asap/shared/use-cases/schematron';

export type Role = string;
export type PassStatus = 'pass' | 'fail' | 'all';

export type FilterOptions = {
  assertionViews: {
    index: number;
    title: string;
    count: number;
  }[];
  roles: {
    name: Role;
    subtitle: string;
    count: number;
  }[];
  passStatuses: {
    id: PassStatus;
    title: string;
    enabled: boolean;
    count: number;
  }[];
};

export type BaseState = {
  config: {
    assertionViews: AssertionView[];
    schematronAsserts: SchematronAssert[];
    documentReferenceUrls: DocumentReferenceUrls;
  };
  filter: {
    role: Role;
    text: string;
    assertionViewId: number;
    passStatus: PassStatus;
  };
};

export type State =
  | (BaseState & {
      current: 'INITIALIZED';
    })
  | (BaseState & {
      current: 'UNINITIALIZED';
    });

export type StateTransition =
  | {
      type: 'CONFIG_LOADED';
      data: {
        config: State['config'];
      };
    }
  | {
      type: 'FILTER_TEXT_CHANGED';
      data: {
        text: string;
      };
    }
  | {
      type: 'FILTER_ROLE_CHANGED';
      data: {
        role: Role;
      };
    }
  | {
      type: 'FILTER_ASSERTION_VIEW_CHANGED';
      data: {
        assertionViewId: number;
      };
    }
  | {
      type: 'FILTER_PASS_STATUS_CHANGED';
      data: {
        passStatus: PassStatus;
      };
    };

export const getAssertionViewTitleByIndex = (
  assertionViews: FilterOptions['assertionViews'],
  index: number,
) => {
  if (assertionViews.length === 0) {
    return '';
  }
  return assertionViews
    .filter(view => view.index === index)
    .map(() => {
      return assertionViews[index];
    })[0].title;
};

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'UNINITIALIZED') {
    if (event.type === 'CONFIG_LOADED') {
      return {
        current: 'INITIALIZED',
        filter: {
          passStatus: 'all',
          role: 'all',
          text: '',
          assertionViewId: 0,
        },
        config: event.data.config,
      };
    }
  } else if (state.current === 'INITIALIZED') {
    if (event.type === 'FILTER_TEXT_CHANGED') {
      return {
        ...state,
        filter: {
          ...state.filter,
          text: event.data.text,
        },
      };
    } else if (event.type === 'FILTER_ROLE_CHANGED') {
      return {
        ...state,
        filter: {
          ...state.filter,
          role: event.data.role,
        },
      };
    } else if (event.type === 'FILTER_ASSERTION_VIEW_CHANGED') {
      return {
        ...state,
        filter: {
          ...state.filter,
          assertionViewId: event.data.assertionViewId,
        },
      };
    } else if (event.type === 'FILTER_PASS_STATUS_CHANGED') {
      return {
        ...state,
        filter: {
          ...state.filter,
          passStatus: event.data.passStatus,
        },
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'UNINITIALIZED',
  config: {
    assertionViews: [],
    schematronAsserts: [],
    documentReferenceUrls: {
      assertions: {},
      xspecScenarios: {},
    },
  },
  filter: {
    passStatus: 'all',
    role: 'all',
    text: '',
    assertionViewId: 0,
  },
};
