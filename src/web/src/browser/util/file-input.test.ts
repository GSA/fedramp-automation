import type { ChangeEvent } from 'react';
import { onFileInputChangeGetFile } from './file-input';

describe('onFileInputChangeGetFile', () => {
  it('returns file details on file select', done => {
    const setFile = jest.fn().mockImplementation(details => {
      expect(details).toEqual({
        name: 'file-name.xml',
        text: '',
      });
      done();
    });
    const handler = onFileInputChangeGetFile(setFile);
    handler({
      target: {
        files: [new File([], 'file-name.xml')] as unknown as FileList,
      },
    } as ChangeEvent<HTMLInputElement>);
  });
});
