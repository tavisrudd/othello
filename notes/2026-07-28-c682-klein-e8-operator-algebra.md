# C682 Klein \(E_8\) operator algebra and spectrum

## Verdict

The Klein third-transvectant has a genuine spectrum-generating algebra, not
only the rank-four McKay selection rule recorded previously.  Put
\[
 f=X^{11}Y+11X^6Y^6-XY^{11},\qquad
 \Delta={1\over87278400}(\,\cdot\,,f)_3
\]
on \(S=\mathbf Q[X,Y]\), equip each \(\operatorname{Sym}^n\) with the
positive Fischer form
\[
 \langle X^{n-i}Y^i,X^{n-i}Y^i\rangle=(n-i)!\,i!,
\]
and let \(\Delta^\dagger\) be the graded formal adjoint.  If
\(\mathscr A=\langle \mathsf E,\Delta,\Delta^\dagger\rangle\), where
\(\mathsf E\) is Euler degree, then the first two return words
\[
 C_n=\Delta^\dagger\Delta,\qquad
 D_n=(\Delta^\dagger)^2\Delta^2
\]
already saturate the full binary-icosahedral commutant in the first three
nontrivial even McKay weights:
\[
\begin{array}{c|c|c}
n&\operatorname{Sym}^n|_{2.A_5}
  &\langle C_n,D_n\rangle\\ \hline
6&3'\oplus4&\mathbf C\oplus\mathbf C\\
12&1\oplus3\oplus4\oplus5&\mathbf C^4\\
18&3\oplus5\oplus3'\oplus4^{\oplus2}
  &\mathbf C^3\oplus M_2(\mathbf C).
\end{array}
\]
The dimensions are \(2,4,7\), exactly
\(\sum_\rho m_\rho^2=\dim\operatorname{End}_{2.A_5}(\operatorname{Sym}^n)\).
At the first repeated affine-\(E_8\) vertex, \(n=18\), the commutator
\([C_{18},D_{18}]\) has rank eight.  Thus the two returns generate the full
\(M_2\) on the multiplicity space of the doubled four-module.  This is the
first point at which the operator algebra sees more than the list of McKay
vertices.

This is a Platinum-level structural result within C682's exploratory scale:
it computes the first non-multiplicity-free corner completely and gives an
exact spectral refinement of the Mukai--Umemura orbit calculation.  It does
not claim a presentation of the infinite graded algebra in all weights.

## Formal adjoint and grading

The Weyl-algebra formula is
\[
\Delta^\dagger
={1\over87278400}
\sum_{i=0}^3(-1)^i\binom3i
 X^{3-i}Y^i
 \bigl(\partial_X^i\partial_Y^{3-i}f\bigr)
       (\partial_X,\partial_Y).
\]
It has differential order nine and degree \(-6\).  The generator and replay
verify this formula against the Fischer weighted transpose on the monomial
bases in degrees \(6,12,18\).  Consequently
\[
[\mathsf E,\Delta]=6\Delta,\qquad
[\mathsf E,\Delta^\dagger]=-6\Delta^\dagger.
\]
The “degree-\(n\) corner” above means the action on the
\(\mathsf E=n\) weight space; the return words are honest elements of the
degree-zero part of \(\mathscr A\).

## Exact positive spectrum

All eigenvalues below are for the normalized \(\Delta\).

For \(n=6\),
\[
\operatorname{Spec}(C_6)
=\left\{0^{(3)},\left({6300\over303601}\right)^{(4)}\right\}.
\]
The zero space is \(3'\), the nonzero space is \(4\), and the sole nonzero
singular value of \(\Delta:\operatorname{Sym}^6\to\operatorname{Sym}^{12}\)
is
\[
{30\sqrt7\over551}.
\]
This recovers the original rank-four kernel theorem spectrally.

For \(n=12\),
\[
\operatorname{Spec}(C_{12})
=\left\{
0^{(1)},
\left({1126125\over303601}\right)^{(3)},
\left({2027025\over303601}\right)^{(5)},
\left({2217600\over303601}\right)^{(4)}
\right\},
\]
on \(1,3,5,4\), respectively.

For \(n=18\), the scalar channels are
\[
\left({37322208\over303601}\right)^{(3)}_{3},\qquad
\left({82976544\over303601}\right)^{(5)}_{5},\qquad
\left({101582208\over303601}\right)^{(3)}_{3'}.
\]
On the two-dimensional multiplicity space of \(4^{\oplus2}\), the two
eigenvalues are the roots of
\[
x^2-{213325308\over303601}x
{11035030675818240\over92173567201}=0,
\]
each repeated four times on the full representation.  The quadratic is the
first spectral datum not recoverable from the affine-\(E_8\) vertex labels
alone.

The first-return algebra at \(n=18\) is the five-dimensional commutative
spectral algebra
\[
\mathbf Q^3\oplus
\mathbf Q[x]/\left(
x^2-{213325308\over303601}x
{11035030675818240\over92173567201}
\right).
\]
Adding the second return makes the quadratic factor noncommutative:
\([C_{18},D_{18}]\) has rank \(8\), and the corner becomes
\(\mathbf Q^3\oplus M_2(\mathbf Q)\) in the displayed rational model.

## Algebraic adjoint and the Mukai--Umemura boundary

The positive Fischer adjoint is not \(SL_2\)-invariant, so it cannot be used
to compare complex \(PSL_2\)-orbits intrinsically.  For that comparison use
the distinct apolar bilinear form
\[
[p,q]_n={(p,q)_n\over(n!)^2}
\]
and write \(\delta_f^\vee\) for the apolar adjoint of the unnormalized
\(\delta_f=(\,\cdot\,,f)_3\).

On the three canonical orbit representatives already used by the
scheme-valued inverse certificate, \(\delta_f\) has rank four in every
case, but the apolar return \(P_f=\delta_f^\vee\delta_f\) is
\[
\begin{array}{c|c|c}
\text{orbit}&\operatorname{rank}\delta_f&P_f\\ \hline
\text{open icosahedral}&4&P_f^2=237600000\,P_f,\quad\operatorname{rank}P_f=4\\
\text{two-dimensional boundary}&4&P_f=0\\
\text{closed orbit}&4&P_f=0.
\end{array}
\]
Equivariance transports these identities along each orbit.  Therefore the
apolar return detects the open orbit inside the rank-four compactification
even though transvectant rank alone is constant.  It does not distinguish
the two boundary orbits, and the scalar \(237600000\) depends on the chosen
representative normalization.  The invariant content is semisimple nonzero
versus zero.

## Comparison with Kramer's generalized Casimir

Kramer's equation (47) gives a different Hermitian degree-preserving
icosahedral operator \(\mathcal K\), obtained by symmetrizing the degree-six
spherical Klein invariant in \(SU_2\) generators.  Exact implementation of
that displayed formula gives
\[
\operatorname{rank}[\mathcal K,C_n]=0,0,8
\quad\text{for }n=6,12,18.
\]
The first two zeros are forced by multiplicity-free restriction.  The
rank-eight commutator at \(n=18\) proves that the return operator is not a
polynomial in Kramer's generalized Casimir and Euler degree; the two
operators supply independent directions on the doubled four-module.
Independently, \(C_{18}\) and \(D_{18}\) already generate that full
matrix block.

Source read depth: one source was read at `partial` depth.  Peter Kramer,
*Invariant operator due to F. Klein quantizes H. Poincare's dodecahedral
3-manifold*, arXiv:gr-qc/0410094, sections 8--9 and displayed equations
(43)--(47), cached PDF SHA-256
`ce3d079bd10b1cd47b131e1e1e997f59cd8ba42176e6ff363aa1d25dd5d7d44b`.
Kramer's operator is the adjacent prior art actually compared.  This report
makes no absence or priority claim over the wider invariant-differential-
operator literature.

## Proof and trust boundary

The proof has four human steps.

1. Fischer adjunction gives the displayed order-nine lowering operator and
   the Euler commutators.
2. The affine-\(E_8\) Clebsch--Gordan recurrence gives the three module
   decompositions and commutant dimensions \(2,4,7\).
3. Exact characteristic polynomials give the spectra above.  Exact row
   reduction gives algebra dimensions \(2,4,7\); containment in the
   binary-icosahedral commutant and equality of dimensions prove saturation.
4. Exact apolar transposes on Hitchin's three orbit representatives give the
   open projector identity and the two zero boundary returns.

The primary generator uses sparse binary polynomials and
Faddeev--LeVerrier characteristic polynomials.  The independent replay uses
dense coefficient lists, minimal-polynomial/nullity checks, and a separately
implemented algebra closure.  Both use only the Python standard library.

From `rust/`, replay with

```text
python3 ../notes/2026-07-28-c682-klein-e8-operator-algebra.py --check
python3 ../notes/2026-07-28-c682-klein-e8-operator-algebra-replay.py
(cd ../notes && sha256sum -c 2026-07-28-c682-klein-e8-operator-algebra.sha256)
```

The certificate records the Fischer and apolar conventions, all spectral
factors, the affine-\(E_8\) decompositions, corner dimensions, commutator
ranks, orbit rows, and exact claim boundary.  It does not certify a global
presentation in every degree, a scheme-theoretic equation for the boundary,
or a novelty claim.
The byte counts are \(30188\) for the generator, \(12525\) for the
independent replay, and \(4452\) for the JSON certificate; their SHA-256
hashes are recorded in the adjacent `.sha256` manifest.

## `ej` + `tt` closeout

The cheap `ej` upgrade was to replace “compute a few singular values” by the
return-word algebra.  The second return is the decisive extra object: at the
first repeated McKay vertex it has rank-eight commutator with the first and
proves full commutant saturation.  The independent Kramer comparison then
shows that this is not a repackaging of the known generalized Casimir.

The `tt` pass exposed the adjoint ambiguity.  The Fischer adjoint is the
correct positive spectral object, whereas the apolar adjoint is the correct
algebraic orbit object.  Keeping both produces the strongest geometric
consequence: rank stays four on all three Mukai--Umemura orbits, while the
apolar return collapses exactly on the two boundary orbits.

## Mystery ledger

- **Settled:** the first non-multiplicity-free Klein corner is
  \(\mathbf C^3\oplus M_2(\mathbf C)\); the two shortest return words already
  generate it.
- **Settled:** the degree-six nonzero singular value is
  \(30\sqrt7/551\), and the spectra through degree eighteen are exact.
- **Settled:** Kramer's generalized Casimir and the first return become
  independent precisely at the doubled four-vertex; their commutator has
  rank eight.
- **Settled:** the apparent conflict between positive spectrum and orbit
  invariance was an adjoint-choice issue.  Fischer and apolar adjoints have
  different jobs.
- **Settled set-theoretically:** the apolar return is nonzero semisimple on
  the open orbit and zero on both boundary orbits, although the original
  transvectant rank is four throughout.
- **Open:** determine whether the return words saturate
  \(\operatorname{End}_{2.A_5}(\operatorname{Sym}^n)\) for every \(n\), or
  locate the first failure.  The present gate stops exactly at \(n=18\).
- **Open:** identify the first and second returns in a standard generating
  set for the binary-icosahedral invariant enveloping/Weyl algebra.
- **Open scheme-theoretically:** compute the vanishing multiplicity and
  ideal of the apolar return along the Mukai--Umemura boundary; three orbit
  representatives prove the reduced set statement, not its scheme
  structure.
- **Open arithmetically:** construct the divided-power integral adjoint and
  determine how these spectra change at \(2,3,5,7,11\).

C682 remains open; the user retains stopping authority.
