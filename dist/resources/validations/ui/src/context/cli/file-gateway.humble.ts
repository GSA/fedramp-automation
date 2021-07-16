import { readFileSync } from 'fs';

export const readStringFile = (fileName: string) =>
  readFileSync(fileName, 'utf-8');
