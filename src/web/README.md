# FedRAMP Validations User Interface

This is the user interface for FedRAMP Validations.
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

Production builds are produced with [Snowpack](https://www.snowpack.dev/) and its [Webpack](https://webpack.js.org/) plugin. You may parametrize the build via environment variables, as referenced in the [Snowpack configuration](./snowpack.config.js#L3-L8).

To build a static copy of your site to the `build/` folder:

```bash
npm run build
```

... or, customized with an environment variable. Here, we set the `BASEURL` so internal links may be mounted at sub-paths:

```bash
BASEURL=/fedramp-automation npm run build
```

To test the production build locally, you could use the Python http server:

```bash
python -m http.server 8000 -d ./build
```

### Run tests

To launch the application test runner:

```bash
npm test
npm test -- --watch
```

### Command-line tool

To run the CLI:

```bash
# To validate the demo SSP.
npm run cli -- validate ../test/demo/FedRAMP-SSP-OSCAL-Template.xml
```

### Saxon performance comparisons

To time Saxon-JS vs Saxon-HE performance:

#### Saxon-JS

```bash
time npm run cli -- validate ../test/demo/FedRAMP-SSP-OSCAL-Template.xml
```

Example output:

```
Found 46 assertions
npm run cli -- validate ../test/demo/FedRAMP-SSP-OSCAL-Template.xml  6.90s user 0.37s system 122% cpu 5.940 total
```

#### Saxon-HE

```bash
cd ..
# First, compile Schematron to XSLT:
./bin/validate_with_schematron.sh
# Then, time the stylesheet transform:
time ./bin/validate_with_schematron.sh -f ./test/demo/FedRAMP-SSP-OSCAL-Template.xml -t
```

Example output:

```
output dir report/schematron
doc requested to be validated: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml
using saxon version 10.5
SAXON_CP env variable used is /Users/dan/.m2/repository/net/sf/saxon/Saxon-HE/10.2/Saxon-HE-10.2.jar
Saxon JAR at classpath /Users/dan/.m2/repository/net/sf/saxon/Saxon-HE/10.2/Saxon-HE-10.2.jar is valid
validating doc: ./test/demo/FedRAMP-SSP-OSCAL-Template.xml with src/ssp.sch output found in report/schematron/./test/demo/FedRAMP-SSP-OSCAL-Template.xml__ssp.results.xml
./bin/validate_with_schematron.sh -f  -t  7.41s user 0.52s system 211% cpu 3.743 total
```
