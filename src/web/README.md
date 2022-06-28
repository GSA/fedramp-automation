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
# To validate the demo SSP.
npm run cli -- validate ../content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml
```

### Saxon performance comparisons

To time Saxon-JS vs Saxon-HE performance:

#### Saxon-JS

```bash
time npm run cli -- validate ../content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml
```

Example output:

```
Found 328 assertions in ssp
Done
npm run cli -- validate   13.80s user 0.31s system 107% cpu 13.160 total
```

#### Saxon-HE

```bash
cd ../validations
# First, compile Schematron to XSLT:
./bin/validate_with_schematron.sh
# Then, time the stylesheet transform:
time ./bin/validate_with_schematron.sh -f ./test/demo/FedRAMP-SSP-OSCAL-Template.xml -t
```

Example output:

```
output dir report/schematron
doc requested to be validated: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml
using saxon version 10.8
Saxon JAR at classpath /Users/dan/.m2/repository/net/sf/saxon/Saxon-HE/10.8/Saxon-HE-10.8.jar is valid
validating doc: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml with rules/poam.sch output found in report/schematron/./test/demo/FedRAMP-SSP-OSCAL-Template.xml__poam.results.xml
validating doc: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml with rules/sap.sch output found in report/schematron/./test/demo/FedRAMP-SSP-OSCAL-Template.xml__sap.results.xml
validating doc: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml with rules/sar.sch output found in report/schematron/./test/demo/FedRAMP-SSP-OSCAL-Template.xml__sar.results.xml
validating doc: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml with rules/ssp.sch output found in report/schematron/./test/demo/FedRAMP-SSP-OSCAL-Template.xml__ssp.results.xml
./bin/validate_with_schematron.sh -f  -t  21.09s user 1.55s system 262% cpu 8.628 total
```
