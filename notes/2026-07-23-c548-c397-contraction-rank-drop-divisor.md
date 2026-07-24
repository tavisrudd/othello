# C548 — C397 four-copy contraction rank-drop divisor

**Lane:** `crowns`

**Date:** 2026-07-23

**Status:** queued; highest-EV bounded crowns successor after C397

## Goal

Upgrade C397's eight-prime Tao preflight to an all-field theorem, or kill the proposed
factorization sharply. For the fixed party-symmetrized four-copy contraction in
`2026-07-23-c397-ame-perfect-tensor-physics.md`, determine the exact rank-drop scheme on the
admitted non-GRS pencil.

The observed candidate is

```text
(z-2)(9z-4)=0,
```

with rank-20 multiplicities

```text
z=2:       96,
z=4/9:    192,
char 7:   288 when the two divisors collide.
```

## Acceptance gate

1. Perform symbolic function-field row reduction, or an equivalent determinantal/Fitting-ideal
   calculation, for the full party orbit of the fixed contraction.
2. Prove that the reduced rank-drop scheme is exactly the displayed two-divisor union, including
   multiplicities, excluded pencil boundary, and every exceptional characteristic; or exhibit and
   certify the first extra component.
3. Explain `96` and `192` through the smallest exact classical mechanism available—preferably
   `S6/A4` double cosets, six-point/Gale matching geometry, or stabilizers of the contraction
   pattern. Keep the algebraic factorization theorem separate if no geometric explanation exists.
4. State the LU meaning precisely: this is a two-divisor detector, not a complete arbitrary-LU
   coordinate for the pencil.

## Stop rule

Stop after the symbolic divisor and multiplicity mechanism are proved or refuted. Do not launch a
larger contraction census, claim global LU completeness, reopen C397's settled q=13 theorem, or
broaden into tensor-network construction.

## Frozen inputs

- `notes/2026-07-23-c397-ame-perfect-tensor-physics.md`
- `notes/2026-07-23-c397-ame-perfect-tensor-physics.py`
- `notes/2026-07-23-c397-ame-perfect-tensor-physics.json`
- `notes/2026-07-23-c396-holonomy-completeness.md`
- the bounded eight-prime observation in
  `notes/2026-07-17-c294-crowns-discovery-track.md`

Any paper-facing computation requires the usual report/script/canonical-certificate/checksum
bundle. The eight-prime replay is evidence for the candidate only, not the all-field theorem.
