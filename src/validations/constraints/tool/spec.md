1. define the expected state in the test-case YAML

```
test-case: # a specific content testing case
  description: Test that the resolved profile contains valid response-points.
  content: ../content/profile-response-point-VALID.xml # the content to run
  pipeline:
  - action: resolve-profile # request that the content is resolved first
  validate:
    expectations: # check the constraint result
    - constraint-id: prop-response-point-matches-string
      result: pass
```

- `content` identifies the test content to validate using oscal-cli.
- `pipeline` identifies extra processing to perform on the `content` before calling oscal-cli - e.g., resolve a profile to produce a catalog for testing
- `validate/expectations` defines what validation rules are expected to pass or fail based on the oscal-cli results

2. Parse the test-case YAML and produce jest-based assertions based on `validate/expectations` that test the contents of the SARIF results produced by the oscal-cli

YAML -- driving content used in -> oscal-cli -> SARIF
  l  -- driving Jest assertions              -> | -> Jest evaluation


