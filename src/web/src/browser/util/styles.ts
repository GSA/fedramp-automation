export const colorTokenForRole = (role: string | undefined) => {
  const roleLower = (role || '').toLowerCase();
  if (roleLower.includes('warn')) {
    return 'info';
  }
  if (roleLower.includes('error') || roleLower.includes('fatal')) {
    return 'info';
  }
  return 'info';
};
