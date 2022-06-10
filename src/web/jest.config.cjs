module.exports = {
  bail: 0,
  preset: 'ts-jest',
  reporters: ['default'],
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/index.ts',
    '!src/browser/index.ts',
    '!src/browser/views/**',
    '!src/cli/index.ts',
    '!src/shared/project-config.js',
    '!src/**/*.humble.*',
  ],
  testEnvironment: 'jsdom',
};
