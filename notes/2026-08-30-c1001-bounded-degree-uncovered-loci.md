# C1001 — bounded-degree uncovered loci

**Lane**: `relconic`

**Status:** Complete. Theorem packet and closeout proved; no manuscript edits. Publication audit is deferred to C1004.

## Goal

Prove the field-uniform degree obstruction for the ordinary uncovered locus of a finite projective arc, derive the exact linear lower bound for its minimum vanishing degree, and settle the odd six-arc cubic-containment tail after checking every imported hypothesis.

## Acceptance gate

- State the defect lower bound and Serre range with compatible hypotheses.
- Prove the fixed-`k,d` finiteness and minimum-degree corollaries, including small or vacuous ranges.
- Verify the six-arc quadratic arithmetic and the q=13 Sziklai decomposition.
- Check from the authoritative concurrence-spectrum statement that `c >= 7` forces `c = 10`, and identify the exact q=11 classification/evidence boundary.
- Record a self-contained theorem packet with no publication placement decision.

## Publication successor

C1004 owns the later integration-versus-spinoff decision.

## Theorem packet

Put
\[
 N=\binom{k}{2},\qquad r=\lfloor k/2\rfloor,
 \qquad \beta_k=N-k+\frac6r\binom{k}{4}.
\]

### Theorem 1 — bounded-degree obstruction

Let `k >= 4`, let `A` be a `k`-arc in `PG(2,q)`, and suppose that its
ordinary uncovered locus `U(A)` is contained in the zero set of a nonzero
homogeneous form of degree `d >= 1`. If `d <= q`, then
\[
 q^2-(N+d-1)q+\beta_k\le 0. \tag{1}
\]
In particular `q <= N+d-2`. Without assuming `d <= q`, the same final
inequality still holds: when `d>q`, it is immediate from `q<=d-1`.
Consequently, for every fixed `k,d`, degree-`d` containment is possible over
only finitely many field orders, with the explicit window
\[
 q\le \binom{k}{2}+d-2.
\]

If the containing curve has no `F_q`-line component, and it is not the unique
exceptional degree-four curve over `F_4`, the Sziklai bound strengthens (1) to
\[
 q^2-(N+d-2)q+\beta_k\le0,
\]
and hence to `q<=N+d-3`.

### Corollary 2 — minimum vanishing degree

Let `delta(A)` be the least degree of a nonzero homogeneous form vanishing on
`U(A)`, allowing degree zero when `U(A)` is empty. Then for every `k >= 4`,
\[
 \delta(A)\ge q-\binom{k}{2}+2. \tag{2}
\]
The statement is nontrivial exactly when the right side is positive. At
`q=N-1`, the defect lower bound makes `U(A)` nonempty, so `delta(A)>=1`; for
`q<=N-2`, (2) is automatic. For `q>=N`, apply Theorem 1 to `d=delta(A)` when
`delta(A)<=q`; if `delta(A)>q`, (2) is immediate.

The unsimplified integer consequence is stronger. Whenever `U(A)` is
nonempty and `delta(A)<=q`,
\[
 \delta(A)\ge
 q-N+1+\left\lceil\frac{\beta_k}{q}\right\rceil. \tag{3}
\]
Thus the linear lower bound carries additional integral surcharges whenever
`q<beta_k`; (2) is only its stable first step.

### Theorem 3 — all-field six-arc cubic tail

Let `A` be a six-arc in `PG(2,q)`, for any prime power `q>=11`. Then the
following are equivalent:

1. `U(A)` is contained in a plane curve of degree at most three;
2. `q=11` and `A` is projectively equivalent to the Clebsch hexagon.

For the Clebsch hexagon the least vanishing degree is two.

### Proposition 4 — component-sensitive six-arc bound

Let `q` be odd, let `A` be a six-arc, and let a degree-`d` curve contain
`U(A)`. If its `F_q`-line factors have total multiplicity `s<d` and the
residual degree-`d-s` curve has no `F_q`-line component, then
\[
 |U(A)|\le (d-1)q+1-5s. \tag{4}
\]
If all components are rational lines, then
\[
 |U(A)|\le d(q-5). \tag{5}
\]
Repeated line factors only lower these bounds. In particular, a cubic over
`F_13` contains at most `27` points of `U(A)`, while every six-arc there has
at least `32` uncovered points.

## Proof

For an ordinary uncovered locus, specialize the prescribed-hole identity to
the empty hole set. Its nonnegative defect gives
\[
 |U(A)|\ge q^2-(N-1)q+N-k+1+\frac6r\binom{k}{4}. \tag{6}
\]
Serre's projective hypersurface inequality says that a nonzero plane form of
degree `1<=d<=q` has at most `dq+1` rational zeros. Combining this with (6)
and cancelling the final `1` gives (1). Since `beta_k>0` for `k>=4`, (1)
cannot hold when `q>=N+d-1`, proving the explicit field window and Corollary
2. When the curve has no rational line component, the Sziklai bound
`(d-1)q+1` gives the stated one-degree improvement, apart from its unique
`(q,d)=(4,4)` exception.

For every six-arc, (6) gives the characteristic-free estimate
\[
 |U(A)|\ge q^2-14q+40.
\]
A containing cubic would therefore force
\[
 q^2-17q+39\le0,
\]
which fails for every integer `q>=15`. The only prime powers in
`11<=q<=14` are `11` and `13`.

In odd characteristic, the exact identity and concurrence spectrum improve
the estimate to
\[
 |U(A)|=q^2-14q+55-c(A),\qquad
 c(A)\in\{0,1,2,3,4,6,10\},
\]
hence
\[
 |U(A)|\ge q^2-14q+45. \tag{7}
\]

For Proposition 4, factor off the rational lines with total multiplicity `s`
and use a union bound on `U(A)`. There are at most `s` distinct such lines, and
the line lemma charges at most `q-5` uncovered points to each. When the
residual degree is positive, Sziklai charges at most `(d-s-1)q+1` to it,
giving (4); when it is zero, the line charges alone give (5). Repetition can
only reduce the zero set.

At `q=13`, (7) gives `|U(A)|>=32`. A cubic without an
`F_13`-line component has at most `2q+1=27` rational points by Sziklai. If it
has one rational line and a residual conic without a rational line component,
the line bound and Sziklai give at most `(q-5)+(q+1)=22` uncovered points. If
the residual conic has a rational line component, it splits into two rational
lines, and all three line components contain at most `3(q-5)=24` uncovered
points. Thus every cubic contains at most `27` points of `U(A)`, contradicting
`|U(A)|>=32`.

At `q=11`, the exact finite low-degree classification says that `U(A)` lies
on a form of degree at most three exactly for the Clebsch class, whose
quadratic kernel is the defining nonsingular conic. This proves both
directions.

## Evidence boundary

- Equation (6): human consequence of `thm:main` in
  `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`; the
  underlying identity and nonnegativity are also formally verified there.
- Exact six-arc identity, spectrum, line bound, and `c=10` normal form:
  `cor:conic-filling-window`, `prop:concurrence-spectrum`,
  `lem:six-arc-line-bound`, and `prop:clebsch-normal-form` in
  `papers/clebsch-rigidity/clebsch_rigidity.tex`.
- The `q=11` terminal implication: finite-certificate Proposition
  `prop:low-degree-rigidity` in
  `papers/clebsch-rigidity/clebsch_rigidity_computational_companion.tex`.
- Imported classical inputs: Serre's bound in the range `d<=q`; the
  Homma--Kim/Sziklai bound for a plane curve without an `F_q`-line component,
  whose unique exceptional case has `q=d=4` and is irrelevant at `(q,d)=(13,3)`.
  Exact bibliographic pinpoints and priority belong to C1004.

## `ej` + `tt` closeout

The closeout produced two task-owned upgrades and both are incorporated above:

1. The field window is explicit, `q<=N+d-2`, rather than merely finite for
   fixed `k,d`; absence of rational line components improves it by one.
2. The six-arc cubic tail holds for every field order `q>=11`, not only odd
   orders. The characteristic-free defect estimate excludes `q>=15`, and the
   only remaining field orders are the odd cases `11` and `13`.
3. Retaining the integer constant gives the sharper lower bound (3), with
   multiple degree surcharges before the stable linear range.
4. Factoring a containing curve and charging each rational line by the
   six-arc line lemma proves Proposition 4. At `q=13` it removes the need for
   the fine concurrence-spectrum and golden-root terminal argument.

## Mystery ledger

- **Sharpness of the linear minimum-degree bound — open.** No construction in
  the checked packet realizes `delta(A)=q-N+2` along an infinite family, and no
  equality analysis was sought. The evidence gap is a family of arcs with an
  explicit minimum vanishing form, or a structural argument improving the
  bound. C1004 should decide whether this merits a new math task before using
  sharpness language.
- **Rational-line peeling beyond six-arcs — settled by C1007.** The odd-order
  focused-direction theorem gives `|U(A) intersect ell|<=q-k+1` for every
  line and every `k>=4`; the resulting component envelope improves the stable
  minimum-degree bound from `q-N+2` to `q-N+3`.
- **The tail boundary below eleven — intentionally outside scope.** The theorem
  classifies `q>=11`; small fields may have incidental cubic containment simply
  because the uncovered locus is small. This is a scope boundary, not an
  unexplained exception.
