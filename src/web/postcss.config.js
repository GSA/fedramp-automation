module.exports = {
  plugins: {
    autoprefixer: {},
    ...(process.env.NODE_ENV === 'production'
      ? {
          '@fullhuman/postcss-purgecss': {
            content: ['./src/browser/**/*.tsx'],

            // Include any special characters you're using in this regular expression
            defaultExtractor: content =>
              content.match(/[\w-/.:]+(?<!:)/g) || [],
          },
        }
      : {}),
  },
};
