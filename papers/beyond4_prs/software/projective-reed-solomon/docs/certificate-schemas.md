# Certificate schemas

The command-line interface accepts and emits versioned JSON objects.

- `prs-request-v1` is the normalized operation request.
- `prs-locator-certificate-v1` records a locator and magnitude reconstruction
  that independently witnesses a closer codeword.
- `prs-deep-certificate-v1` records the normalized syndrome, canonical
  transporter, recognized family or frozen orbit, applicable theorem-domain
  row, and covering-radius promotion used for a positive `DEEP` verdict.

`verify-certificate` recomputes field arithmetic, normalization, transport,
locator or family checks, and the frozen registry lookup. It rejects corrupted
or inapplicable certificates. Positive certificates are never emitted for
`UNRESOLVED` or `UNSUPPORTED` results.

A future schema revision must use a new identifier rather than silently
changing the meaning of an existing certificate.
