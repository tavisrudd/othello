# C437 — exact H3 residual list and mixed-Hecke cubic preservation

**Lane:** `crowns`

**Date:** 2026-07-20

**Verdict:** `THEOREM; ALL-SIGNAL L_2=2 -> L_3=1; MIXED-HECKE COMPRESSION PRESERVES THE DROP BUT NOT WITHIN-FIBRE RECOVERY`

## Result

The H3 signed-half configuration has an intrinsic residual-list formulation with no named positive
sheet.  C430 first recovers the unordered pair of eleven-point sheets from the unique
second-moment radical.  Among all balanced `+-1` orientations of the 22 points, its degree-at-most-
two moment fibre consists of exactly the two opposite sheet signs.  The nonzero signed cubic tensor
then selects exactly one of them.  This holds for both possible input orientations, so the exact
all-signal profile is

```text
L_2 = 2,                 L_3 = 1.
```

The word *input* is load-bearing.  Orbit recovery is given the affine cubic moment tensor, not a
preferred sheet name.  If that tensor is projectivized, or if only the unsigned 22-point
configuration is supplied, the two signs remain indistinguishable: the outer involution exchanges
the sheets and negates the cubic.  Thus the intrinsic cubic **line** remembers the unoriented
orientation class, while the affine cubic tensor recovers its sign.

C411's mixed `A4\PGL_2(11)/A5` incidence map preserves this exact `2 -> 1` drop.  Its pushed-forward
signed moments vanish through degree two and have nonzero cubic moment.  The map is nevertheless
not a general orbit-recovery embedding: it is constant on `A4`-orbits of sizes `1,4,6` in each
sheet, so differences of points in a size-four or size-six fibre are invisible in every degree.
It preserves the already intrinsic two-element orientation list, but cannot recover arbitrary
within-fibre labels or transport C430's full trade-rigidity theorem to the compressed target.

## Intrinsic residual-list definition

Let `k=F_11`, let `X` be the 22 matching-decorated parents, and let

```text
phi : X -> W
```

be C406's factorization-difference configuration in its ten-dimensional linear span.  Write
`M_j(s)=sum_(x in X) s(x) phi(x)^(symmetric j)` for a balanced sign function
`s:X->{+-1}` having eleven values of each sign.  Translation of `phi` does not change `M_1`,
`M_2`, or `M_3` on the relevant fibre because the lower signed moments vanish.

Define the intrinsic degree-two candidate set

```text
S_2 = {s balanced : M_1(s)=0 and M_2(s)=0}.
```

No sheet is named in this definition.  Given an oriented signal `s_0` through its observed moments,
define

```text
L_2(s_0) = S_2,
L_3(s_0) = {s in S_2 : M_3(s)=M_3(s_0)}.
```

The cardinality profile, rather than an ordering of the candidates, is the invariant.  The outer
element sends `(s_0,M_3(s_0))` to `(-s_0,-M_3(s_0))`, so the construction is equivariant and gives
the same profile at every signal in the two-element outer orbit.

## Residual-list theorem

Let `epsilon` denote either of the two sheet signs only for the proof.  C430 identifies the full
degree-at-most-two evaluation algebra as the equal-sheet-sum hyperplane in `k^X`; its orthogonal
trade space is the line `k epsilon`.  Intersecting that line with balanced `+-1` sign functions gives

```text
S_2 = {epsilon,-epsilon}.
```

Hence `|L_2(s_0)|=2` for either `s_0=epsilon` or `s_0=-epsilon`.  C406 proves

```text
M_3(epsilon) != 0,
M_3(-epsilon) = -M_3(epsilon).
```

Since the characteristic is odd, these two tensors are distinct.  Exactly one agrees with the
observed affine tensor `M_3(s_0)`, so `|L_3(s_0)|=1`.  This is an all-signal finite statement, not a
generic-open-set claim and not a new theorem about arbitrary finite-group representations.

The proof also isolates the supplied-label stop rule.  Replacing `M_3(s_0)` by its projective line
identifies the two candidates, because `[T]=[-T]`; then the residual list stays of size two.  The
positive theorem therefore consumes a signed moment observation, as orbit recovery normally does,
and does not manufacture a canonical preferred sheet from the unsigned geometry.

## Exact modular obstruction to the generic theorem template

The Edidin--Katz regular-representation theorem applies to generic signals over an infinite field
when the relevant finite orbit is linearly independent.  Both load-bearing hypotheses fail here:

1. the field is `F_11`, and `11` divides `|PSL_2(11)|`; and
2. the 22 orbit points have affine rank 11 and factorization-difference span 10, so they are far
   from linearly independent.

The dependence is organized, rather than accidental.  On each eleven-point sheet the
`F_11[PSL_2(11)]` permutation module is the indecomposable projective cover

```text
P(1),                  Loewy layers 1 | 9 | 1.
```

The constant line is its socle.  In the two-sheet affine evaluation module, the pairing radical is

```text
soc(P(1)_+) direct_sum soc(P(1)_-).
```

Its even line is the global constant and its outer-odd line is the sheet sign.  Because a sheet has
size `11=0` in `k`, these socle indicators are isotropic and survive in the radical; the outer-odd
socle is exactly C430's unique degree-two trade.  This is the characteristic-11 mechanism leaving
two candidates after quadratic data.  The nonzero cubic is the first tensor escaping that socle
ambiguity.  Semisimple, linearly-independent-orbit intuition misses precisely this layer.

## Mixed-Hecke preservation and obstruction

Let `D:X->V` be C411's four-coordinate secant-depth incidence map.  Intrinsically, its coordinates
are mixed matrix coefficients in

```text
e_(A4) Q[PGL_2(11)] e_(A5) ~= Q[A4\PGL_2(11)/A5],
```

and reduction to `F_11` has linear rank two.  The outer involution acts on `V` by negation.  On one
sheet the three image profiles and their multiplicities are

```text
v_1=(-6, 0,12,-12),    multiplicity 1,
v_4=(-3, 3, 0,  3),    multiplicity 4,
v_6=( 3,-2,-2,  0),    multiplicity 6,
```

and the other sheet has the opposite profiles.  Therefore the pushed-forward signed measure has

```text
N_1 = N_2 = 0,
N_3 != 0.
```

The independent arithmetic check is only three terms.  The integral barycentre relation is

```text
v_1 + 4v_4 + 6v_6 = 0,
```

opposite pairs cancel every even signed moment, and the first cubic coordinate is

```text
2((-6)^3 + 4(-3)^3 + 6(3)^3) = -324 = 6 mod 11.
```

Thus `D_*epsilon` and `-D_*epsilon` agree through degree two and are separated in degree three.
The same argument after applying the outer involution proves preservation for both input signals.
This is the exact mixed-Hecke compression mechanism promised by the spike.

There is also a sharp non-extension theorem.  If distinct `x,y` lie in the same size-four or
size-six `A4`-orbit, then `D(x)=D(y)`, so

```text
delta_x-delta_y
```

is killed by every polynomial moment after projection, in every degree.  Consequently the rank-two
map cannot preserve unrestricted residual lists on `k^X`, cannot recover individual matching
labels, and does not make the six-dimensional mixed bi-Hecke module a faithful linear quotient.
The preservation theorem is exactly about the C430-recovered orientation pair.

## Literature and claim boundary

This report adds **zero newly full-read sources**.  It consumes the C437/C438 spike's recorded
shallow check and the C406/C411 audits.  In particular, generic cubic recovery over infinite
fields, finite-field/all-orbit separating invariants, modular low-degree generic separation, and
projected third-moment recovery are treated as direct prior art.  The surviving result is only the
exact H3 all-signal `2 -> 1` profile, its `1|9|1` socle mechanism, and its preservation-with-
obstruction under this specific mixed-Hecke incidence map.  No unrestricted novelty or priority
claim is made; the existing MathSciNet, Google Scholar, citation-closure, and inaccessible-full-text
gaps remain open.

## Evidence and replay

No new computation is load-bearing.  The residual-list proof is the two-line intersection of
C430's conceptual trade theorem with balanced signs, followed by C406's nonzero cubic.  The Hecke
proof uses C411's conceptual double-coset derivation and the three-term arithmetic displayed above.
The exact frozen hypotheses can be replayed from the repository root with Python 3.13.12:

```bash
python3 notes/2026-07-20-c430-conceptual-balanced-half-rigidity.py --check
python3 notes/2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py --check
sha256sum -c notes/2026-07-20-c430-conceptual-balanced-half-rigidity.sha256
python3 notes/2026-07-20-c411-double-coset-hecke.py --check
python3 notes/2026-07-20-c411-double-coset-hecke-replay.py
sha256sum -c notes/2026-07-20-c411-double-coset-hecke.sha256
```

The C430 JSON records H3 affine rank `11`, quotient span `10`, degree-two rank `21`, one-dimensional
trade kernel, radical `soc(P(1)_+) direct_sum soc(P(1)_-)`, and Loewy dimensions `1,9,1`.  The C411
JSON records the `1,4,6 / 1,4,6` fibres, rank-two depth map, zero first and second pushed moments,
and cubic witness `6`.  Their recorded SHA-256 hashes are respectively
`eebfd0525c94ac0bcb7965ab33b6d11a698242e608d9d1a40cebaa0a2b451098` and
`23f0a100356f0a369f00d81011e8d8d6b9d867b9de45a7b0625fc2889323b014`.

## Disposition

C437 passes its bounded seam gate.  It earns the exact finite-field worked example needed by G1,
but not an all-finite-group programme by itself.  Any successor must state whether its observations
are affine tensors or projective tensor lines and whether it seeks only orientation recovery or
full within-fibre signal recovery.
