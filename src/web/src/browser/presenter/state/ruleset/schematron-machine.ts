import type { SchematronAssert } from '@asap/shared/domain/schematron';
import type { AssertionView } from '@asap/shared/use-cases/assertion-views';

export type Role = string;
export type PassStatus = 'pass' | 'fail' | 'all';
export const FedRampSpecificOptions = [
  'all',
  'fedramp',
  'non-fedramp',
] as const;
export type FedRampSpecific = typeof FedRampSpecificOptions[number];

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
  fedrampSpecificOptions: {
    option: FedRampSpecific;
    enabled: boolean;
    count: number;
    subtitle: string;
  }[];
};

export type BaseState = {
  config: {
    assertionViews: AssertionView[];
    schematronAsserts: SchematronAssert[];
  };
  filter: {
    role: Role;
    text: string;
    assertionViewId: number;
    passStatus: PassStatus;
    fedrampSpecificOption: FedRampSpecific;
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
      type: 'FILTER_FEDRAMPSPECIFIC_CHANGED';
      data: {
        fedrampSpecificOption: FedRampSpecific;
      };
    }
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
          fedrampSpecificOption: 'all',
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
    } else if (event.type === 'FILTER_FEDRAMPSPECIFIC_CHANGED') {
      return {
        ...state,
        filter: {
          ...state.filter,
          fedrampSpecificOption: event.data.fedrampSpecificOption,
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
  },
  filter: {
    fedrampSpecificOption: 'all',
    passStatus: 'all',
    role: 'all',
    text: '',
    assertionViewId: 0,
  },
};
