import { it, describe, expect } from 'vitest';

import { createPresenterMock } from '.';

describe('presenter', () => {
  describe('derived state', () => {
    it('initializes without error', () => {
      const presenter = createPresenterMock();
      expect(presenter).toBeDefined();
    });
  });
});
