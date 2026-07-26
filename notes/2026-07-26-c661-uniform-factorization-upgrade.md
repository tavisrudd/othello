# C661 — Uniform factorization upgrade for Paper II

**Lane**: `clebsch`

**Date**: 2026-07-26

**Status**: complete — the \(A_3,B_3\) row reductions have been replaced by
a human representation-theoretic proof; Paper II's nonlinear scope is
unchanged.

## Result

C661 passes through its conceptual-rank route.  The three quotient ranks now
have one mechanism:

1. the matching quotient is an affine connecting cocycle;
2. its value span is stable under \(\operatorname{PGL}_2(q)\);
3. the Fischer summands are defining-characteristic
   \(\operatorname{SL}_2(q)\)-modules;
4. irreducibility forces every nonzero top-harmonic projection to fill its
   summand; and
5. in even quotient degree, one transparent apolar trace detects the radial
   line.

No orbit row reduction remains load-bearing for the \(3,6,10\) theorem.
The existing exact quotient matrices remain independent cross-checks.
The `tt` closeout also removes the nonzero cubic computation from the
logical spine: quadratic recovery gives signed Gale self-duality and
Cayley--Bacharach in degree two; Eisenbud--Popescu then gives a Gorenstein
coordinate ring, whose Hilbert symmetry forces the cubic.

## Human proof

Let
\[
 c(g)=\Phi_{M_T}(gM_T).
\]
The quotient transformation law makes \(c\) an affine cocycle:
\[
 c(gh)=g c(h)+c(g).
\]
Therefore its value span \(S_T\) is \(G\)-stable, since
\[
 b\,c(g)=c(bg)-c(b).
\]
Distinct matchings give distinct normalized secant products by unique
factorization, so every nonbase orbit point gives a nonzero cocycle value.

For \(q=5,7\), twisting by the Dickson form's determinant weight gives
\[
\widetilde R_1=M_2\quad(q=5),\qquad
\widetilde R_2=M_4\oplus M_0\quad(q=7),
\]
where
\[
M_r=\operatorname{Sym}^r(V^\vee)\otimes
\det^{r/2}\otimes\chi,\qquad
\chi=\det^{(q-1)/2},\qquad M_0=\chi.
\]
The scalar action is trivial, so these descend to
\(\operatorname{PGL}_2(q)\).  On
\(\operatorname{PSL}_2(q)\), the top summands are the absolutely irreducible
symmetric powers of highest weights \(2<5\) and \(4<7\).

For \(A_3\), the target is the single irreducible module \(M_2\).  A nonzero
cocycle value therefore forces
\[
S_{A_3}=M_2=R_1,\qquad \dim S_{A_3}=3.
\]

For \(B_3\), project \(c\) to \(M_0=\chi\).  On
\(G^+=\operatorname{PSL}_2(7)\), this projection is a homomorphism to the
additive group of \(\mathbb F_7\).  Simplicity of \(G^+\) makes it zero.
Hence every same-sheet cocycle value lies in \(M_4\); any nonbase value is
nonzero, so irreducibility forces the complete five-space
\[
M_4=\mathcal H_2\subseteq S_{B_3}.
\]

The outer radial projection is visible without a matrix rank calculation.
The nonsquare-determinant projectivity
\[
u=\begin{pmatrix}0&1\\1&2\end{pmatrix}
\]
sends the base matching
\[
\{02,14,3\infty,56\}
\]
to
\[
M_*=\{02,15,34,6\infty\}.
\]
Substitution in \(L_{ab}=abX-(a+b)Y+Z\) and cancellation of the common
factor give
\[
\Phi_{M_{B_3}}(M_*)=(Z-2Y)(3Z+Y)=3L_{02}^2.
\]
The radial witness is therefore geometric: it is the square of the secant
common to the two matchings, up to a nonzero scalar.  The dual quadratic
norm of a secant is nonzero, while a tangent has zero norm.  In the displayed
normalization,
\[
\Delta_Q(3L_{02}^2)=4\ne0.
\]
The Laplacian kills \(M_4=\mathcal H_2\), so this value has nonzero
\(M_0=\mathbb F_7Q\)-projection.  Since the span already contains \(M_4\),
it contains \(M_0\) and therefore
\[
S_{B_3}=M_4\oplus M_0=R_2,\qquad \dim S_{B_3}=6.
\]

Together with C616's cohomological \(H_3\) argument, this proves the
\(3,6,10\) theorem uniformly at the level of mechanism.  Types \(B_3\) and
\(H_3\) each retain one hand-checkable radial scalar; neither uses a
load-bearing orbit row reduction.

## Bounded three-route attack

### Uniform recovery/Gorenstein route

The radical--Hadamard and Gale arguments use exactly the following nonlinear
inputs: two characteristic-zero-size sheets in the field, zero first moments,
equal second moments, sheet restriction rank \(q-1\), second-moment rank
\(q-2\) with a sheet-separating radical, and a nonzero signed cubic.
These inputs imply quadratic sheet recovery, full cubic evaluation, signed
Gale self-duality, and the Gorenstein inverse system.  They do not follow from
the matching quotient or its linear rank alone.

As a control, the antipodal simplex
\[
\{\pm\bar e_i:1\le i\le p\}\subset
\mathbb F_p^p/\mathbb F_p\mathbf1,\qquad p\ge5,
\]
satisfies the abstract hypotheses: the standard pairing on the zero-sum
dual has radical \(\mathbb F_p\mathbf1\), which takes values \(+1,-1\) on
the two sheets, and the signed cubic is nonzero.  This gives an infinite
abstract Gorenstein family but no conic matching realization, so it does not
pass C661's scope-increase gate.  Searching individual matching orbits would
revert to a finite census and was stopped.

### Conceptual-rank route

This route passes by the proof above.  It removes both remaining row
reductions and places \(A_3,B_3,H_3\) under the same cocycle/Fischer-module
mechanism.

### Equivalent-strength route

No separate application one lemma beyond the present paper was found.
The natural classification question asks which
\(\operatorname{PGL}_2(q)\)-matching orbits split into two
\(\operatorname{PSL}_2(q)\)-sheets of size \(q\); its stabilizer would have
index \(q\) in \(\operatorname{PSL}_2(q)\).  Turning that observation into a
classification requires a Dickson-subgroup analysis and would not improve
the now-complete rank proof.  It was not opened as an unbounded second task.
No Paper III claim was imported.

## Literature and priority boundary

This pass read one load-bearing source at **full text**:

- T. Braun and G. Nebe, *Orthogonal representations of
  \(\operatorname{SL}_2(q)\) in defining characteristic*, published
  version, all nine pages; Fact 3.1 supplies the irreducibility of
  \(\operatorname{Sym}^r(\mathbb F_p^2)\) for \(0\le r<p\).  Cache key
  `10.1007/s13366-024-00763-w`, SHA-256
  `4c43806863b35eea67a3b03cdb4321016d85e21d61f64a47f5d30b6d6ff4762e`.
  The repository landing-page PDF URL first returned HTML and was rejected
  by the cache; the author's PDF supplied the verified bytes.

The C406 and C577 post-baseline audits already cover the exact
matching-secant construction, the \(3,6,10\) images, defining-characteristic
module framework, and the Edge--Dye marker geometry at their recorded read
depths.  This task makes no new priority claim: it is a human-proof upgrade
of an already audited theorem.

## Paper and trust disposition

`papers/clebsch-factorization/clebsch_factorization.tex` now:

- describes all three ranks as symbolic consequences of the affine cocycle
  and Fischer modules;
- gives the complete \(A_3,B_3\) proof above;
- changes the evidence boundary so the quotient matrices are cross-checks;
  and
- narrows the remaining open question to nonlinear recovery and Gorenstein
  hypotheses.

The statement identity, PDF, and evidence fingerprint were regenerated.
The original eight-bundle release replay passed after the human proof
upgrade, but none of those bundles is now the primary proof of the
\(A_3,B_3\) ranks or cubic nonvanishing.  A ninth bundle pins the Lean
Hilbert-symmetry gate.  Its source elaboration, the nine-bundle metadata
gate, warning scan, and warning-free 25-page build pass.  The exact
import-only gate and resulting nine-bundle aggregate replay are waiting
behind a foreign Lean build owner.

The reusable arithmetic hinge is formalized in
`RelativeConicArcs.ClebschHilbertSymmetry`.  Its terminals are
`RelativeConicArcs.HilbertSymmetry.socleDegree_eq_three` and
`RelativeConicArcs.HilbertSymmetry.value_three_eq_one`, exposed by
`RelativeConicArcs.Gates.ClebschHilbertSymmetry`.  Lean takes symmetry,
the first three values, and total length as hypotheses; it does not formalize
the Eisenbud--Popescu criterion, Gorenstein symmetry, or the geometric
identification of those Hilbert values.

## `ej` + `tt` closeout

The first cheap upgrade was to state the two small cases with the same
twisted module notation already used for \(H_3\), rather than present two
isolated arguments.  This exposes the actual uniform theorem: the
\(3,6,10\) pattern comes from the surviving Fischer summands of one affine
connecting cocycle.  A second pass recognized the \(B_3\) outer witness as
\(3L_{02}^2\).  Its nonzero radial trace is the dual norm of a secant, so the
last \(B_3\) nonvanishing step is geometric rather than an unexplained
coordinate scalar.

The main expert-level question is now correctly separated from rank.  A
broader Paper II theorem would have to derive the radical--Hadamard inputs
structurally for new conic matching orbits; the cubic then follows.
Assuming those ranks or checking more examples would not do so.

The `tt` pass reverses the former cubic-to-Gorenstein implication.  Once
\(L^{\circ2}=\ker\epsilon\), the full-support relation and
\(ADA^{\mathsf T}=0\) make the configuration self-associated with
Cayley--Bacharach in degree two.  The classical self-association criterion
makes its coordinate ring Gorenstein.  The known values
\(h_0=1,h_1=q-1,h_2=q-1\), symmetry, and total length \(2q\) then force
\[
h=(1,q-1,q-1,1).
\]
Therefore \(L^{\circ3}=k^\Omega\) and \(\mu_3\ne0\) without tensor
enumeration.  The real nonlinear frontier is only the structural derivation
of the radical--Hadamard hypotheses for new conic matching orbits.

## Mystery ledger

| Feature | Status | Exact remaining gap |
|---|---|---|
| Why do the \(A_3,B_3,H_3\) ranks follow the same pattern? | settled | The affine cocycle, irreducible Fischer summands, and radial trace give one proof. |
| Is there one invariant formula forcing the \(B_3,H_3\) radial scalars? | \(B_3\) settled geometrically; uniform question open | The \(B_3\) scalar is the dual norm of the common secant square; no type-free formula also explaining the \(H_3\) second trace was proved. |
| Why is the first signed moment cubic and nonzero? | settled conceptually | Quadratic recovery gives self-association and CB(2); Gorenstein Hilbert symmetry forces the final cubic socle line. |
| Does radical--Hadamard recovery occur in an infinite family? | settled abstractly, open for conic quotients | Antipodal simplices give an abstract family; no new matching-quotient realization passed the gate. |
| Are \(B_3,H_3\) the only balanced \(2q\)-point full-\(\operatorname{PGL}_2(q)\) matching orbits? | open, not promoted | Requires a subgroup-index classification plus matching realization analysis. |

No remaining mystery affects the \(3,6,10\) theorem or the current Paper II
release.
