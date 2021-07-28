export const colorTokenForRole = (role: string | undefined) => {
  const roleLower = (role || '').toLowerCase();
  if (roleLower.includes('warn')) {
    return 'warning';
  }
  if (roleLower.includes('error') || roleLower.includes('fatal')) {
    return 'error';
  }
  return 'info';
};
