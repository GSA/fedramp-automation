# 7. FedRAMP Validations User Interface

Date: 2021-05-28

## Status

Accepted
## Context

Schematron-compiled XSLT has been produced by the development team, with the intent that it be consumed by third-party developers. Additionally, the team has determined that a frontend interface is required to display validation data from the applied XSLT. Initially, the interface will be used to solicit feedback from FART (FedRAMP Agency Review Team) stakeholders and as a method for the team to view validation results during the development process.

### Technical considerations

- *Client or server* SSPs are considered [Controlled Unclassified Information (CUI)](https://www.archives.gov/cui/about), so having the option to handle SSP evaluation entirely client-side avoids security concerns. However, XSLT transformation in-browser may be more limited in feature set or stability.
- *XSLT library* [Saxon-JS](https://www.saxonica.com/saxon-js/index.xml) is the only viable Javascript library that may be run in the browser. For the server-side, [Saxon-JS](https://www.saxonica.com/saxon-js/index.xml) (node.js) and [Saxon-HE](https://www.saxonica.com/documentation10/documentation.xml) (Java) are options that are viable. Saxon-JS has additional licensing considerations - it is free to use, but not open source.
- *View layer* There are no major known requirements that require specific view layer features.
- *Other considerations* Maintaining the ability to reuse code developed for a frontend in different contexts (build pipeline, command-line interface) would provide additional value.

## Decision

The development team has chosen to start with a fully client-side validation process. As the only viable option, Saxon-JS is chosen as the XSLT library. Typescript was chosen as the language, for type-safety. React was chosen as the view layer, due to the broad usage and community support. Additionally, to bootstrap the project quickly, Snowpack was chosen as a build system.

## Consequences

Usage of Saxon-JS in-browser enables local usage without immediate security considerations. Additionally, it maintains the option of running the same code (with accomodations) server-side in node.js.

However, Saxon-JS has potential limitations relative to Saxon-HE that are currently unknown. It may also not be as performant. As a result, maintainting the ability to run in a server-side node.js or Java backend should be maintained as an option.

Building a node.js-based frontend project maintains optionality around reusing XSLT transformation and reporting in contexts other than the browser. We can possibly replace the Java Schematron build pipeline with one managed by the same code base, or build a command-line interface that produces validation reports in static formats such as CSV, Word, or PDF. If used as the basis for additional validation-rule work, the test suite could be extended to include end-to-end XSLT processing (Schematron build pipeline -> OSCAL validation -> assertions on frontend view state).
