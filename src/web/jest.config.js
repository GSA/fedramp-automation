module.exports = {
  bail: 0,
  preset: 'ts-jest',
  reporters: [
    'default',
    [
      './node_modules/jest-html-reporter',
      {
        pageTitle: 'FedRAMP Validations Test Report',
      },
    ],
  ],
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/index.ts',
    '!src/context/browser/index.ts',
    '!src/context/browser/views/**',
    '!src/context/cli/index.ts',
    '!src/context/shared/project-config.js',
    '!src/**/*.humble.*',
  ],
  testEnvironment: 'jsdom',
};
