import { getAssertionsById } from './validator';

describe('presenter validator library', () => {
  describe('getAssertionsById', () => {
    it('handles empty input', () => {
      expect(
        getAssertionsById({
          failedAssertions: [],
        }),
      ).toEqual({});
    });
    it('handles empty input', () => {
      expect(
        getAssertionsById({
          failedAssertions: [
            {
              id: 'assertion-1',
              uniqueId: 'id-1',
              location: '',
              text: '',
              test: '',
              diagnosticReferences: [],
            },
            {
              id: 'assertion-2',
              uniqueId: 'id-2',
              location: '',
              text: '',
              test: '',
              diagnosticReferences: [],
            },
          ],
        }),
      ).toEqual({
        'assertion-1': [
          {
            diagnosticReferences: [],
            id: 'assertion-1',
            location: '',
            test: '',
            text: '',
            uniqueId: 'id-1',
          },
        ],
        'assertion-2': [
          {
            diagnosticReferences: [],
            id: 'assertion-2',
            location: '',
            test: '',
            text: '',
            uniqueId: 'id-2',
          },
        ],
      });
    });
  });
});
