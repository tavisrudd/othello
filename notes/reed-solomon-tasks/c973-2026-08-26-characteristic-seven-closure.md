# C973 characteristic-seven pointed closure

Date: 2026-08-26  
Status: proved modulo seven replayable locator certificates; manuscript frozen

## 1. Outcome

The characteristic-seven R11 carrier is not merely shallow above the previous
`q>=343` selector threshold.  It is **pointedly shallow over every admissible
characteristic-seven field**: for every carrier syndrome and every prescribed
projective root, its Hankel kernel contains a split squarefree nonic avoiding
that root.

The missing field `q=49` reduces to five `PGL_2(49)` orbits and is closed by
five replayable exact certificates.  The same reduction at R12 has two pointed
orbits, also certified.  For `q>=343`, the existing characteristic-seven R9
slice accepts up to two additional forbidden roots without changing its first
field.  Consequently:

1. the R11 characteristic-seven carrier is pointedly shallow for every
   admissible `q=7^m`;
2. the R12 characteristic-seven carrier is pointedly shallow for every
   admissible `q=7^m`;
3. the R13 characteristic-seven carrier is shallow for every admissible
   `q=7^m`; and
4. the R14 characteristic-seven carrier is empty.

This is the useful stopping point for level-by-level work.  The proof exposes
the higher-EV general problem: identify a Lucas carrier as a modular
`PGL_2`-module and establish pointed abundance on the module, rather than
enumerating ambient syndrome space at each redundancy.

## 2. Exact module reduction at R11

Put `n=10`.  For the translation `t -> t+a`, normal-rational-curve
equivariance gives

```
e_j -> sum_{i=j}^{10} binom(i,j) a^(i-j) e_i.
```

On the characteristic-seven carrier `M_11,7=P<e_4,e_5,e_6>`, Lucas reduction
therefore gives

```
e_4 -> e_4 + 5a e_5 + a^2 e_6,
e_5 -> e_5 + 6a e_6,
e_6 -> e_6.
```

With

```
f_0=e_4,  f_1=5e_5,  f_2=e_6,
```

this becomes the standard divided-quadratic action

```
f_0 -> f_0+a f_1+a^2 f_2,
f_1 -> f_1+2a f_2,
f_2 -> f_2.
```

Scaling has projective weights `(1,lambda,lambda^2)`, after removing the
common factor `lambda^4`, and inversion exchanges `f_0,f_2` while fixing
`f_1`.  Since translations, scalings, and inversion generate `PGL_2`, this is
an equivariant identification of the carrier with `P(Gamma^2 E)`.

For coordinates `(A,B,C)` in this basis, `Delta=B^2-AC` is invariant up to a
square.  Thus carrier points have three orbits: `Delta=0`, nonzero square
`Delta`, and nonsquare `Delta`.  Their stabilizers have respectively the
following orbits on a marked projective root:

- double root: the distinguished root and its complement;
- split quadratic: the two distinguished roots and their complement;
- nonsplit quadratic: one orbit, because the nonsplit torus is transitive on
  `P^1(F_q)`.

There are exactly five pointed orbits.  In the fixed model
`F_49=F_7[x]/(x^2+1)`, representatives in `(e_4,e_5,e_6)` coordinates are

| orbit | syndrome | forbidden root |
|---|---:|---:|
| double, distinguished | `(1,0,0)` | `0` |
| double, complement | `(1,0,0)` | infinity |
| split, distinguished | `(1,0,6)` | `1` |
| split, complement | `(1,0,6)` | `0` |
| nonsplit | `(1,0,15)` | `0` |

Here `15` encodes `1+2x`.  Its norm is `1^2+2^2=5`, a nonsquare in `F_7`, so
`-15` is genuinely nonsquare in `F_49`.  This check matters: every nonzero
base-field element becomes a square in the quadratic extension, so
`(1,0,1)` would be another split representative.

## 3. Exact module reduction at R12

Put `n=11`.  The carrier is `M_12,7=P<e_5,e_6>`, and translation gives

```
e_5 -> e_5+6a e_6,
e_6 -> e_6.
```

Thus `(e_5,6e_6)` is the standard two-dimensional module.  A carrier point
and a forbidden projective root have exactly two orbits: equal and distinct.
They are represented by `e_5` with forbidden root `0` and infinity,
respectively.

## 4. Certificate evidence at q=49

The generator
`notes/reed-solomon-tasks/c973-char7-pointed-orbits.py` invokes the public,
typed `simultaneous-locator` command and replays every nested locator through
the independent public `verify` command.  It records five R11 and two R12
orbits.  All seven verify, and the typed forbidden-root list is disjoint from
each returned support.  The largest searches examine 528,522 candidates at
R11 and 516,892 at R12, below the fixed limit 2,000,000.

The authority software commit is `f26d751b8339c81cdc3f28ddbcd1f019e264f866`.
From the repository root, after its release build:

```bash
python3 notes/reed-solomon-tasks/c973-char7-pointed-orbits.py --check
cd notes/reed-solomon-tasks
sha256sum -c c973-char7-pointed-orbits.sha256
```

The 5,962-byte generator has SHA-256
`434e31d9cb693a10af11c13151a7adcafd5aec4689f095eb292d5b77505688d1`.
The 16,041-byte canonical JSON has SHA-256
`fa9c02f5662785f15acfea3500a84548b36efb189ab8957e887a1dd8699a6c0d`.

The certificates prove existence for the orbit representatives.  The finite
orbit reduction above, not an ambient census, transports them to every
syndrome/root pair.

## 5. Uniform pointed strengthening for q>=343

The existing R11 characteristic-seven proof chooses two contraction markers,
normalizes them to infinity and zero, and finds a split septic on the lower R9
slice.  Its selector degree is at most `114` and its deletion degree is at
most `38`; these figures already include avoidance of the zero marker.

Let `s` additional distinct projective roots be prescribed.  Choose the two
contraction markers away from them.  After normalization, every extra finite
forbidden value `alpha` costs at most

- `8+4=12` in selector degree: a nonzero coefficient of `N_u(alpha)` plus
  the four fixed-root factors; and
- `2+4=6` in deletion degree: the moving root plus the two residual roots on
  the double cover.

The coefficient is nonzero because otherwise `alpha` would be a fixed factor
of the whole good-slice pencil; that fixed-factor locus was already excluded
when selecting the internal marker.  For several forbidden values the
selectors are multiplied, so the bounds add.  Hence the R11 carrier is
`s`-pointedly shallow whenever

```
q > 114+12s,
q+1-2 sqrt(q) > 38+6s.
```

At `q=343` both inequalities hold for every `s<=19`; in particular they hold
for `s=2`.  They then remain true for every larger characteristic-seven field.

## 6. Propagation and sharper theorem boundary

For `f=Ae_5+Be_6` at R12, finite contraction at `t` is

```
A e_4 + (B-tA)e_5 - tB e_6,
```

and contraction at infinity is `Ae_5+Be_6`.  It is always nonzero and lies in
the R11 carrier.  One-pointed R11 abundance makes R12 shallow; two-pointed
R11 abundance leaves an arbitrary extra root forbidden and therefore makes
R12 pointedly shallow.  The q=49 R12 certificates supply the same conclusion
at the only smaller admissible characteristic-seven field.

For R13, Lucas row 11 has adjacent zero positions `5,6`, so
`M_13,7=P<e_6>`.  Every contraction is a nonzero point of the R12 carrier.
Pointed R12 abundance therefore makes the R13 carrier shallow.  Lucas row 12
has only the single zero position `6`, so `M_14,7` is empty.

Combined with the established binary closure for `q>=128` and
characteristic-three closure for `q>=81`, the possible R11 modular exceptions
are now exactly

```
q in {16, 27, 32, 64}.
```

Equivalently, the modular carrier contributes no split-free R11 direction for
any other admissible field.  This does not remove the persistent tangent and
conjugate-secant families.

## 7. Paper integration plan (separate follow-up C item)

Keep the manuscript length neutral:

1. replace the current characteristic-seven threshold paragraph with the
   quadratic-module identification and the two-line pointed bound;
2. add one compact seven-row certificate table, leaving JSON locators in the
   supplement;
3. strengthen the R11 statement from a `q>=343` modular closure to the exact
   four-field exception set; and
4. state the R12/R13 characteristic-seven propagation as one corollary, not
   as separate redundancy sections.

Do not edit the frozen manuscript in C973.  Allocate a paper-update C item
only after the mathematical closeout and independent seam review.

## 8. Explicit ej + tt closeout and mystery ledger

The `ej` pass supplied the cheap upgrade from one forbidden root to the
`s`-pointed inequalities, which in turn propagated the result through R13.
The `tt` pass asked why the three carrier dimensions fall as `3,2,1` and
whether this is a digit theorem rather than an R-level coincidence.  The
answer is the proved one-carry module theorem in
`c973-2026-08-26-one-carry-module-theorem.md`.

- Settled: the apparent q=49 characteristic-seven gap was orbit complexity,
  not a new deep family.
- Settled: the quadratic-extension square-class trap; the certified nonsplit
  representative must use an extension-field coefficient.
- Settled: characteristic seven through the end of its R11--R14 digit block.
- Open: the four small R11 fields `16,27,32,64`.
- Open: a module-uniform theorem that treats a family of Lucas digit patterns
  at once; this is now higher EV than continuing redundancy by redundancy.
- Open: independent review of the selector nonvanishing and deletion-degree
  seams already recorded in C973.

Vibe: the software paid off when paired with representation theory; the next
gain should come from generalizing that pairing, not from a larger census.
