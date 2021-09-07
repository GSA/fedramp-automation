# 10. Use of remote resources during validation

Date: 2021-09-07

## Status

Accepted

## Context

Some Schematron assertions require access to documents other than the one being validated.
Since these may rely on network function, such use should be optional.
A method to enable such use must be accommodated in the related Schematron assertions.
Support for XSLT-driven and schema-aware editor validation should be provided.

## Proposed Method

Use an XSLT `<param>` to indicate that remote resources should be used.
This enables XSLT-driven validation to selectively use remote resources.
That parameter will be type `xs:boolean`, optional (`required="false"`), 
and boolean false if not provided.

An environment variable to indicate that remote resources should be used will also be provided.
This enables schema-driven editing to selectively use remote resources.

These two variables will be logically ORed and the result will be used to enable 
assertions which require access to remote resources.

## Decision

The parameter and related variables will be used to enable use of remote resources.
