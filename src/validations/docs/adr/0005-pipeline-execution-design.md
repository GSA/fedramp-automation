# 5. Shell-Based Validation Pipeline Execution

Date: 2021-05-18

## Status

Accepted

## Context

The development team has designed the validation suite, as document in previous ADRs, to allow use of the validations with different execution strategies. These strategies fall into two categories.

- Shell-based: This strategy is where tool developers that integrate the validations will "shell out." They will use their own application code to start a process in their container or server environment, that process will execute the validations using the Java-based Saxon XSLT processor via [the bundled JAR's command-line interface](https://www.saxonica.com/documentation9.5/using-xsl/commandline.html). The application will either read the validation results [from standard streams for standard output and standard error](https://www.saxonica.com/documentation9.5/using-xsl/commandline.html) or read the result output as stored as a file in the local filesystem.
- API-based: This strategy is where tool developers integrating the validations into their application with a library in their language and/or runtime of choice to run the XSLT transform programmatically. They will not run the Saxon XSLT processor with a separate, discrete process. The tool developer will use Saxon or any other XSLT transformation library for their language to create the XSLT processor instance, choose to load OSCAL data from memory or disk, and store validation results in memory or persist to disk.

## Decision

The development team has decided to focus on the shell-based approach first. This will require the least amount of upfront experimentation in different API-based integration patterns.

## Consequences

The efforts, benefits, and drawbacks of integration patterns with different languages and runtimes are unknown at this time and will continue to be unknown until this decision is reviewed and changed. This consequence may be beneficial, however, as we do not have enough feedback from tool developers who wish to integrate. Prioritizing which languages and runtimes, and how to document with examples, is premature without more information.