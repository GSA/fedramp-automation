import { createOvermindMock } from 'overmind';
import { mock } from 'vitest-mock-extended';
import { vi } from 'vitest';

import { getPresenterConfig, UseCases } from '.';
import { OldState } from './state';

type MockPresenterContext = {
  useCases?: Partial<UseCases>;
  initialState?: Partial<OldState>;
};

export const createPresenterMock = (ctx: MockPresenterContext = {}) => {
  const presenter = createOvermindMock(
    getPresenterConfig(
      { getCurrent: vi.fn(), listen: vi.fn(), replace: vi.fn() },
      mock<UseCases>(),
      ctx.initialState,
    ),
    {
      useCases: ctx.useCases,
    },
  );
  return presenter;
};
export type PresenterMock = ReturnType<typeof createPresenterMock>;
