# The discriminant resolvent of the A5-cubic pencil

The nonstandard `A5`-invariant pencil of cubic threefolds carries a
five-sheet packet of stable principal gluing kernels.  This paper identifies
its rational triple and golden pair with the root and discriminant resolvents
of the ordered two-torsion torsor on the actual elliptic norm axis.  It gives
the associated level-six modular diagram, exact monodromy, and chordal
boundary geometry.

## Read the paper

[**Open the paper (PDF) →**](cubic_gluing_resolvent.pdf)

## Verification

Run the complete local check with:

```sh
make check
```

The target replays exact symbolic and finite-group certificates, verifies
their SHA-256 manifest, builds the PDF, and rejects TeX warnings.  The
geometric identifications and polarization argument are proved in the text;
the scripts check only the explicit algebra, orbit ranks, and subgroup
enumeration stated in their headers.

## License

The contents of this repository are licensed under CC BY 4.0; see `LICENSE`.
