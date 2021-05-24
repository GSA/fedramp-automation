# FedRAMP Validation Suite User Interface

This is the user interface for the FedRAMP Validation Suite.
## Developer Instructions

This project is built using the node.js version specified in `.nvmrc`. To use, run:

```bash
nvm use
```

To install dependencies:

```bash
nvm install
```

### Development server

```bash
npm start
```

[http://localhost:8080](http://localhost:8080) to view it in the browser.

### Production build

To build a static copy of your site to the `build/` folder:

```bash
npm run build
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
