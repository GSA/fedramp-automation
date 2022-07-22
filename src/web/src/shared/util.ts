export const groupBy = <T>(array: T[], predicate: (v: T) => string) =>
  array.reduce((acc, value) => {
    (acc[predicate(value)] ||= []).push(value);
    return acc;
  }, {} as { [key: string]: T[] });

export const base64DataUriForJson = (jsonString: string) => {
  return new Promise<string>((resolve, reject) => {
    var blob = new Blob([jsonString], { type: 'application/json' });
    var reader = new FileReader();
    reader.onload = e => {
      const result = e?.target?.result as string;
      if (result) {
        resolve(result);
      } else {
        reject();
      }
    };
    reader.onerror = reject;
    console.log(blob);
    reader.readAsDataURL(blob);
  });
};
