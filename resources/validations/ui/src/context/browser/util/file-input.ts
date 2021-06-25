import type { ChangeEvent } from 'react';

const readFileAsync = (file: File) => {
  return new Promise<string>((resolve, reject) => {
    let reader = new FileReader();
    reader.onload = () => {
      resolve(reader.result as string);
    };
    reader.onerror = reject;
    reader.readAsText(file);
  });
};

export const onFileInputChangeGetFile =
  (setFile: ({ name, text }: { name: string; text: string }) => void) =>
  (event: ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files.length > 0) {
      const inputFile = event.target.files[0];
      readFileAsync(inputFile).then(text => {
        setFile({ name: inputFile.name, text });
      });
    }
  };
