# C907 critical-fan pilot replay

**Lane:** `clebsch`

**Status:** exact local computational certificate; not a global fan.

The Singular replay verifies four ideal identities used by
`2026-08-12-c907-finite-pole-continuum-certificate.md`:

1. the `0/0` semistable incidence graph is unchanged by saturation with the
   exact torus boundary factors;
2. the `0/1` incidence graph is likewise the saturated main transform; and
3. the `0/1` endpoint tangent-critical ideal, after localizing `e`, equals the
   four-point residual Morse ideal; and
4. the generic-torus `B,C` critical equations force `B=C`.

## Replay

From the repository root:

```sh
nix shell nixpkgs#singular -c Singular -q \
  notes/2026-08-12-c907-critical-fan-pilot.sing
```

The canonical output is
`notes/2026-08-12-c907-critical-fan-pilot.out`.  Singular version 4.4.1 was
used.  The replay is deterministic and contains no random choices.
The script and output contain 2,358 and 63 bytes respectively; their SHA-256
hashes are recorded in the adjacent `.sha256` manifest.

The independent check is the direct substitution, colon, and tangent-
Jacobian audit in the companion mathematical note, cold-read independently by
two Terra/xhigh referees.  This is genuinely different from the Gröbner
calculation: it proves the identities by local unit and component arguments.

## Exact boundary

The script verifies only the two compact-`y` incidence charts and their one
residual endpoint.  It does not enumerate a Gröbner fan, prove completeness of
the boundary atlas, normalize arbitrary initial schemes, or construct the
topological product collars.
