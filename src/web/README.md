# FedRAMP ASAP Web Documentation

This is the web documentation for FedRAMP ASAP.

## Developer Instructions

This project is built using the node.js version specified in `.nvmrc`. To use, run:

```bash
nvm use
```

To install dependencies:

```bash
npm install
```

### Development server

```bash
npm start
```

[http://localhost:8080](http://localhost:8080) to view it in the browser.

### Production build

Builds are produced with [Vite](https://vitejs.dev/). You may parametrize the build via environment variables, as referenced in the [Vite configuration](./vite.config.ts#L5-L15).

To build a static copy of your site to the `build/` folder:

```bash
npm run build
```

... or, customized with an environment variable. Here, we set the `BASEURL` so internal links may be mounted at sub-paths:

```bash
BASEURL=/fedramp-automation npm run build
```

To test the production build locally, you could use the preview script:

```bash
npm run preview
```

### Run tests

To launch the application test runner:

```bash
npm test
npm run test:watch
```

### Command-line tool

To run the CLI:

```bash
# To validate the demo SSP, provide the Schematron ruleset (eg, "rev4") and the document to validate:
npm run cli -- validate rev4 ../content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml
```

### Command-line validation

The Schematron validation may be tested via the SaxonJS-backed node.js command line inteface.

```bash
npm run cli -- validate rev4 ../content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml
```
