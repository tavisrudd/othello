# Theorem boundary

The executable deliberately separates computations that are valid in general
dimensions from conclusions that require a covering-radius theorem.

| Operation | Implemented domain | Mathematical boundary |
|---|---|---|
| `canonicalize` | `r >= 5`, `q >= r` | Structural orbit computation only |
| `distance`, `decode` | `r >= 5`, `q >= r`, within the requested candidate budget | Trusted increasing-degree search proves minimality; the locator certificate replays the upper-bound witness |
| `simultaneous-locator` | `r >= 6`, `q >= r`, within the requested candidate budget | A returned degree-`r-2` locator proves shallowness; failure proves no positive claim |
| `classify` | Negative witnesses for every `r>=5`; positive families remain registry-gated | A positive deep verdict requires an applicable row in `data/theorem-domain-v1.json` |
| even diagonal tangent | even `q`, `r=q-1` | Uses the imported covering radius of `PRS(2)` plus the intrinsic terminal-locator obstruction |
| GF(8)/R7 | complete | Frozen exhaustive orbit data separate the two deep orbits from every distance-six orbit |

The even diagonal tangent route is checked before the general registry lookup.
R11-or-higher requests may return a verified negative witness or an
`UNSUPPORTED` structural family, but cannot return `DEEP` merely because the
implementation reaches them.

Generic canonicalization or decoding beyond R10 is not a theorem that the
resulting syndrome is deep. Within the accepted classification domain,
unsupported routes fail closed as `UNSUPPORTED` or `UNRESOLVED`; neither state
receives a positive deep certificate.

The theorem registry is versioned data shipped with the executable. Changing
its domain is a mathematical release change, not an implementation convenience.
