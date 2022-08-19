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
    reader.readAsDataURL(blob);
  });
};

// Returns a string of the form "00:00:00"
export const formatElapsedTime = (milliseconds: number) => {
  return new Date(milliseconds).toLocaleTimeString('en-GB', {
    timeZone: 'Etc/UTC',
    hour12: false,
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  });
};
