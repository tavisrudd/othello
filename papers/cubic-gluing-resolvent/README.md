# The discriminant resolvent of the A5-cubic pencil

This directory is the authoritative source for the short modular-resolvent
companion to `papers/cubic-stabilization-epilogue`.

Run the complete local check with:

```sh
make check
```

The target replays the exact symbolic certificate and an independent finite
subgroup enumeration in `verification/`, checks their SHA-256 manifest, lints
the TeX source, builds the PDF, and rejects TeX warnings.
