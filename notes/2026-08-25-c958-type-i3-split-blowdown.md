# C958 type-I3 split blowdown

**Lane:** `cubic-threefolds`

## Result

The type-`I3` cubic-surface fibre now has an explicit quadratic blowdown over
its degree-24 splitting field.  In the monomial order

```text
Y1^2, Y1*Y2, Y1*Y3, Y1*Y4, Y2^2,
Y2*Y3, Y2*Y4, Y3^2, Y3*Y4, Y4^2,
```

the certificate retains the thirty coefficients of three quadrics
`[Z1:Z2:Z3]`.  Each quadric is the unique one through the common reducible
twisted cubic and the three indicated exceptional lines.  Every interpolation
matrix has rank nine.

The three quadrics contract `E0,...,E5` to six distinct marked plane points.
After the certified normalization, four are

```text
[1:0:0], [0:1:0], [0:0:1], [1:1:1].
```

Writing the distinguished sixth point as `[1:A:B]`, the fifth point is exactly
`[1:A^2:B^2]`.  Thus the change to the standard split quartic-del-Pezzo Cox
moduli is again

```text
(a_split,b_split)=(A^2,B^2),
```

the same structural pattern used in type `I1`.  The three quadrics are linearly
independent and have no common ambient factor.

## Formula size

The thirty normalized coefficient strings use 26,906 characters in total; the
longest uses 1,255.  The two split-modulus expressions use 689 and 696
characters.  These formulas are appropriate for the machine-readable artifact,
not inline expansion in the manuscript.

## Replay and trust boundary

From the repository root:

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-25-c958-type-i3-split-blowdown.py \
  --check notes/2026-08-25-c958-type-i3-split-blowdown.json
```

The cold replay completed in 14 minutes 28 seconds.  The generator is 8,848
bytes with SHA-256
`03868c1a80c20be144c503e14d989e5a8d70bd3394573acca4b36f6058c2c04c`;
the 34,368-byte certificate has SHA-256
`35be82c860ec32455ff0d635e5b8bd61dcb6fd2c51106f00644a41c0eec1aa69`.

This is an independent arithmetic implementation of the upstream exceptional
sections: those sections were derived and checked in SymPy's quotient algebra,
whereas this interpolation is regenerated in Sage's tower of exact function
fields.  It independently checks the line formulas by restricting every
quadric to them.  It does not yet certify the inverse cubic map, ground-field
descent, tangent coordinates, or either stabilized cubic composite.

## Mystery ledger

| feature | status | evidence or remaining gate |
|---|---|---|
| Does the type-`I3` six-line configuration admit the expected marked blowdown? | settled | three rank-nine interpolation systems and six exact contractions |
| Does its split Cox marking have the same square pattern as type `I1`? | settled | the fifth point is coordinatewise the square of `[1:A:B]` |
| Are the formulas small enough to print? | no | 26,906 coefficient characters belong in the ancillary JSON |
| Is the split map birational in both directions? | pending | the strengthened inverse certificate is a separate gate |

**Vibe:** the type-`I3` split geometry has reached the same marked-plane
interface as type `I1`; descent, rather than line interpolation, is now the
arithmetic problem.
