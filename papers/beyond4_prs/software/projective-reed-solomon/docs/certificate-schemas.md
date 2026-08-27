# Certificate schemas

The command-line interface accepts and emits versioned JSON objects.

- `projective-reed-solomon-request-v1` is the normalized operation request.
- `projective-reed-solomon-locator-certificate-v1` records a locator and
  magnitude reconstruction that independently witnesses a closer codeword.
- `projective-reed-solomon-deep-certificate-v1` records the normalized
  syndrome, canonical transporter, recognized family or frozen orbit,
  applicable theorem-domain row, and covering-radius promotion used for a
  positive `DEEP` verdict.
- `projective-reed-solomon-canonicalization-v1` is the structural
  canonicalization result envelope.
- `projective-reed-solomon-classification-v1` is the classification result
  envelope, which may contain a deep certificate.
- `projective-reed-solomon-verification-v1` reports successful replay of a
  locator or deep certificate.
- `projective-reed-solomon-simultaneous-locator-v1` binds a typed list of
  forbidden projective `Root` values to the returned locator certificate.  It
  is a result envelope, not a new certificate trust route.

`verify-certificate` recomputes field arithmetic, normalization, transport,
locator or family checks, and the frozen registry lookup. It rejects corrupted
or inapplicable certificates. Positive certificates are never emitted for
`UNRESOLVED` or `UNSUPPORTED` results.

The `distance` and `decode` commands emit a locator certificate directly. A
`classify` result nests a positive certificate under `deep_certificate`; pass
that nested certificate—not the classification envelope—to `verify`.

A locator certificate independently checks the displayed error pattern and its
weight. The exact-distance claim also uses the executable's increasing-degree
search order; the certificate does not encode an exhaustive lower-degree
search transcript.

A future schema revision must use a new identifier rather than silently
changing the meaning of an existing certificate.
