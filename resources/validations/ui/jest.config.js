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
    '!src/views/**',
    '!src/**/*.humble.*',
  ],
  testEnvironment: 'jsdom',
};
