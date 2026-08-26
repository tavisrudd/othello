# C949 live frontier — sharp asymptotics for complete higher arcs

**Lane:** `relconic`

**Date:** 2026-08-26

> **START HERE FOR C949.** This is the live task card and routing document.
> Do not preload the proof snapshot or archive. Read only the focused source
> named by the selected frontier below.

## Goal and honest status

For `q=3^h`, determine the sharp asymptotics of the largest complete
`(2q/3+1)`-arc in `PG(2,q)`.

Established:

```text
t_(2q/3+1)(2,q) >= q^2/3+5q/3-o(q),
```

and the exact `5/3` endpoint is absent for all sufficiently large ternary
fields.  The full matching upper bound, a matching construction, and a
classification of all near-extremizers remain open.

Current honest completion estimate: about **70% of the structural program**,
but materially less than 70% of a finished asymptotic theorem because the
remaining step is a global inverse/classification theorem.

## Read routing

- Detailed theorem statements and derivations through 2026-08-26:
  `notes/2026-08-26-c949-structural-proof-snapshot.md`.
- Focused bounded transverse-core proof:
  `notes/2026-08-26-c949-redei-transverse-core.md`.
- Chronological session log and links to focused snapshots:
  `notes/2026-08-24-c949-sharp-higher-arc-asymptotics-archive.md`.
- C962 finite-carrier application memo:
  `notes/2026-08-25-c962-application-opportunities-memo.md`.
- C962 recovery/algorithm bounds:
  `notes/2026-08-25-c962-recovery-algorithms-and-bounds.md`.

Load the long proof snapshot only by theorem label.  The labels most relevant
to the live frontiers are listed below.

## Landed theorem state

### 1. Nine-signature inverse reduction

Every hypothetical sublinear repair reduces to nine SR11 signatures:

- seven concurrent rows, compressed to ghost types `m_0 in {1,4,7}`;
- triangular `(4,-3)`, the balanced carrier branch;
- triangular `(5,-1)`, which necessarily carries a linear high-secant trade.

The concurrent branch has a two-permutation Redei normal form.  Its first
uncontrolled forbidden coefficient is

```text
E_(q+4)=Phi_dir Q_3,
```

where `Q_3` is a projective cubic.  Ordinary Newton reciprocity does not
determine it.

### 2. Mason-relative quadratic separation

Let `B` be a near-sharp minimal `q/3`-fold blocking complement and `S` any
Mason generalized-KM large root.  If `|B\S|=q-3+e`, then

```text
liminf e/q^2 >= c_*=0.0171413259... > 1/60,
|B triangle S| >= (2c_*-o(1))q^2,
```

where `c_*=x_*^2` and

```text
216x_*^3-72x_*^2+21x_*-2=0.
```

Key labels:

```text
(SR24a-Mason-U-pairs)
(SR24a-Mason-quantitative-gap)
(SR24a-Mason-mixed)
```

This rules out every subquadratic Mason switch, across all nine signatures.
It does **not** prove that an arbitrary near-sharp blocker is close to any
Mason root.  That missing mixed-correlation theorem would itself be a major
global classification input.

### 3. Balanced blocking geometry

The balanced `(4,-3), eta=1` branch dualizes to a minimal blocking
`(2q+4,4)`-arc `D` with exact secant spectrum

```text
t_1=(2q^2-8q+3)/3,  t_2=3q-3,
t_3=3,              t_4=q(q+2)/3.
```

Its high-line arrangement has only double, triple, and quadruple points.
Local jets, scalar cocycles, freeness/Saito, and automatic cube-root gluing
are all proved no-go routes.  A quartic carrier would contradict blocking for
`q>=81`, but no quartic-carrier implication is proved.

### 4. Exact low-pencil and bounded Redei certificate

Let `V_1,V_2,V_3` be the zero-triangle vertices.  Weight each `D`-bisecant by
one and each trisecant by two.  Exact second-moment saturation and incidence
inversion prove

```text
1_(2-secants)+2 1_(3-secants)
 =sum_(i=1)^3 1_(pencil(V_i)).              (SR24a-low-pencils)
```

Thus the three connector lines are precisely the trisecants and every other
line in those pencils is a bisecant.  Every tangent is clean.

In any tangent chart, with

```text
B_0(X,M)=product_(i=1)^3(X-b_i+Ma_i),
```

the global quotient has the exact field-uniform form

```text
Q(X,M)=B_0(X,M)C_0(X^3,M)+(M^q-M)E(X,M),
deg_X E<3,  deg E<=3.                       (SR24a-Redei-cubic)
```

All `q`-scale ambiguity is therefore confined to the **nine coefficients**
of one cubic `E`.

The split-product companion quotient compresses further.  If
`R=(X^q-X)Q+(M^q-M)H`, canonical division of `H` by `B_0`, followed by the
three connector interpolations, gives

```text
H=B_0D+P_good I_E+(M^q-M)U,
deg_X U<3, deg U<=3.
```

Hence the two canonical quotient remainders form a genuine bounded
**nine-plus-nine** state `(E,U)`.  See the focused transverse-core snapshot.

The reciprocal transition is exact.  In a tangent-point-adapted flag chart,
one may normalize

```text
V_1=(0,0), V_2=(1,0), V_3=(s,1),
B_0=X(X+M)(X-1+sM),  s notin {0,1}.
```

The standard reciprocal remainder exists iff the three homogeneous-cubic
coefficients vanish:

```text
e_03=e_12=e_21=0.                         (SR24a-Redei-recip-gate)
```

Finite directional fibers cannot see `E`: adding `(M^q-M)E'` preserves all
of them.  The values of `E` are exactly the transverse derivatives of `Q`
along the three moving low-pencil roots.  Hence the next proof must use a
pre-specialization split-product, reciprocal-norm, or Witt identity.

### 5. q=27 finite carrier boundary

C962 supplies a 714-task high-incidence DFS interface.  Each high cell gives

```text
C(x)-yA(x)=-y^2
```

in the 18 coefficients of the degree-eight pair `(A,C)`.  Seven double-high
rows leave at most a one-dimensional fractional-linear defect; every
completed carrier has full rank 18.  The finite search is useful for
extracting bounded rejection cores, but no completed exhaustive rejection is
being claimed here.

The numerical resemblance between the nine coefficients of `E` and one half
of the 18-variable carrier is not structural: the reciprocal transform of
`E` is the same nine-dimensional object, not a second cubic.  A theorem
linking the tangent-product quotient to `C(x)-yA(x)=-y^2` is still missing.

## Live frontiers, in EV order

### EV1 — bounded transverse-derivative theorem

Relate or contradict the bounded pair `(E,U)`, preferably beginning with the
three reciprocal obstructions `e_03,e_12,e_21`, from one of:

1. the globally split point product before specialization;
2. the reciprocal norm as a polynomial identity rather than field fibers;
3. a Witt lift that evaluates
   `(partial_M-a_i partial_X)Q` on the moving pencil root;
4. a bounded symbolic rejection core extracted from the q=27 gates.

Do not return to finite-fiber interpolation, the omitted tangent slope,
pointwise torus jets, scalar holonomy, or automatic cube-root gluing.

### EV2 — all-signature mixed-correlation inverse theorem

Prove that a near-sharp minimal `q/3`-fold blocker either has

```text
|B triangle S|=o(q^2)
```

for some Mason root `S`, contradicting the quadratic separation theorem, or
directly incurs `eta>=c q`.  Scalar line moments and essentiality alone have
formal countermodels and cannot establish this.

### EV3 — concurrent cubic coupling

Couple the projective cubic `Q_3` controlling the first forbidden concurrent
coefficient to the two permutation root factorizations.  Directional data
alone permits arbitrary `Phi_dir Q_3`; the missing input is splitness or an
offset-sensitive correlation.

### EV4 — triangular `(5,-1)` trade theorem

This signature has `Omega(q)` high-secant trade even when `eta=o(q)`.  It is
not governed by the constant-repair balanced carrier lemma and needs a
separate global trade obstruction or construction.

## Closed routes

- exact `5/3` endpoint;
- bounded/local Mason repair and every subquadratic Mason switch;
- Segre-pencil sign cocycle and cube-class propagation;
- local second/third/all finite torus jets;
- Saito/freeness alone;
- scalar cube-root gluing and scalar low-node cocycles;
- automatic quartic extraction from Bezout or Hilbert count;
- generic BSG/Freiman energy from the incidence ledger;
- treating the missing tangent direction as another clean fiber;
- identifying the reciprocal `E` as an independent second nine variables.

## Mystery ledger (`ej` + `tt`)

- **Settled:** the dirty tangent branch is impossible; the three
  zero-triangle vertices exhaust the weighted norm.
- **Settled:** the weighted low lines are exactly three pencils, not merely a
  matching-like count.
- **Settled:** both canonical Redei quotient defects compress to the bounded
  nine-plus-nine cubic state `(E,U)`.
- **Settled:** reciprocal conversion fails on exactly three homogeneous
  coefficients.
- **Settled/no-go:** finite slope fibers cannot constrain `E`; they are
  invariant under `Q -> Q+(M^q-M)E'`.
- **Open:** compute the transverse pencil derivatives from split/Witt/norm
  data.
- **Open:** connect any resulting bounded identity to C962's `(A,C)` carrier
  variables without relying on the numerical `9+9=18` coincidence.
- **Open and global:** classify all nine inverse signatures or construct a
  matching near-sharp family.

## Next checkpoint

Derive the reciprocal transition of the full quotient pair `(Q,H)` and test
whether it gives a nontrivial linear relation between `E` and `U`.  Keep the
high quotients `C_0,D` explicit so the finite-fiber gauge freedom is not
mistaken for a contradiction.
