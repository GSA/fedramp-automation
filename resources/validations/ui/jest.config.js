module.exports = {
  bail: 0,
  preset: 'ts-jest',
  reporters: [
    'default',
    [
      './node_modules/jest-html-reporter',
      {
        pageTitle: 'FedRAMP Validation Suite Test Report',
      },
    ],
  ],
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/views/**',
    '!src/**/*.humble.*',
  ],
};
