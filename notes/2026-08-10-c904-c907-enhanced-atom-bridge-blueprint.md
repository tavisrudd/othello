# C904/C907 enhanced-atom bridge blueprint

**Date:** 2026-08-10
**Lane:** C904, with C907 read-only
**Purpose:** exact theorem-level bridge for the proposed cross-paper crown
**Verdict:** the bridge is available with one short paper-local lemma plus four
source clauses; importing the whole KKPYY atom formalism is unnecessary

## Target theorem

> **One-step stabilization theorem.** Let \(X\subset\mathbf P^4_{\mathbf C}\)
> be a smooth cubic threefold. Then \(X\times\mathbf P^1\) is irrational.

Combined with C904's uniform Chow-diagonal theorem for the smooth
\(A_5\)-cubic pencil, this gives:

> There is a non-isotrivial one-parameter family of smooth cubic threefolds
> \(X_t\) such that every \(X_t\) is universally
> \(\mathrm{CH}_0\)-trivial, while every
> \(X_t\times\mathbf P^1\) is irrational.

The stabilization theorem should be proved with a formal-monodromy enhancement
of one KKPYY local atom. No claim of full stable irrationality is involved.

## The invariant to use

Fix the parity group \(G=\boldsymbol\mu_2\), with its nontrivial element acting
on \(H^i\) by \((-1)^i\). Work on the \(G\)-fixed, hence even-bulk, base of
the maximal A-model \(F\)-bundle.

For a geometric \(G\)-atomic \(F\)-bundle \(\mathcal A\), let

\[
\operatorname{Mon}(\mathcal A)
\]

be the multiset of eigenvalues in \(\mathbf C^\times\) of formal monodromy
after Levelt--Turrittin exponential separation.  This definition makes sense
for every atom and avoids choosing logarithms or assuming rational exponents.

Use the additive integer

\[
\nu_6(\mathcal A)
=\#\{\zeta\in\operatorname{Mon}(\mathcal A):
       \zeta=e^{\pi i/3}\text{ or }e^{-\pi i/3}\},
\]

counted with algebraic multiplicity.  Formal-monodromy eigenvalues remove
every integer-shift ambiguity, and multiplicity rather than a Boolean flag is
required because the chemical formula lives in a free abelian group on atom
classes.  Extend \(\nu_6\) linearly to that free abelian group.

## Paper-local invariance lemma

The one bridge not stated verbatim in the sources should be printed and proved.

> **Formal-monodromy lemma.** The multiset
> \(\operatorname{Mon}(\mathcal A)\), and hence \(\nu_6(\mathcal A)\), is
> invariant under:
>
> 1. isomorphism of \(F\)-bundle germs;
> 2. regular formal gauge transformations;
> 3. gauge transformations by integral powers of \(u\);
> 4. base changes and mirror maps independent of \(u\);
> 5. parallel transport inside one connected component of the reduced
>    unramified spectral cover.
>
> It is additive under external direct sum.

Proof sketch:

- A regular gauge conjugates formal monodromy.
- Multiplication by \(u^N\), with integral \(N\), shifts exponents by integers.
- A base change independent of \(u\) does not change the loop variable.
- After exponential separation, flatness in a bulk direction \(s\) gives
  \(\partial_sR=[\Gamma_s(0),R]\) for the regular-singular residue.  Hence
  the characteristic polynomial of \(\exp(2\pi iR)\) is constant on a
  connected reduced unramified spectral component.
- Formal monodromy of a direct sum is the disjoint union of the two spectra.

This is a standard formal-connection fact, but printing the five-line proof
prevents a referee from having to infer that the monodromy multiplicity
survives the KKPYY atom equivalences.

## Exact source clauses

### 1. The cubic atom and its sixth-root monodromy

Jiaji Cai, *The cubic threefold is symplectically irrational*,
arXiv:2608.01577v1, Proposition 6:
<https://arxiv.org/abs/2608.01577>.

Cai proves for the **big** quantum connection of a smooth cubic threefold:

- there are formal solutions with powers
  \(\rho\equiv\pm1/6\pmod{\mathbf Z}\);
- after Jordan reduction, those solutions lie in the rank-two block for the
  zero eigenvalue.

The calculation starts with the small connection and obtains the indicial
polynomial

\[
\rho^2+\rho+\frac5{36},
\]

whose roots are \(-1/6\) and \(-5/6\). Cai's bulk-variable gauge uses only
integral powers of \(u\), so the fractional residues persist in the big
connection.

KKPYY, Example 6.21, supplies the local-atom identification:

- at the hyperplane point, the cubic chemical formula has two one-dimensional
  nonzero-eigenvalue atoms and one zero-eigenvalue atom \(\alpha_X\);
- the Witt-algebra argument gives no further splitting of \(\alpha_X\) in a
  neighborhood.

Thus Cai's rank-two even block lies inside the zero spectral atom
\(\alpha_X\), and

\[
\nu_6(\alpha_X)=2.
\]

Here Cai's big connection and KKPYY's maximal A-model \(F\)-bundle are the
same scalar-extended big-quantum connection on the parity-fixed base; the
atom comparison preserves the loop variable \(u\).  This identification,
rather than the small-connection calculation alone, is load-bearing.

The odd \(H^3(X)\) part may lie in the same zero atom. This causes no problem:
the argument needs only the presence of the sixth-root eigenvalues in its even
subconnection.

### 2. Spectral atoms and their geometric \(F\)-bundles

L. Katzarkov, M. Kontsevich, T. Pantev, and T. Y. Yu,
*Birational Invariants from Hodge Structures and Quantum Multiplication*,
arXiv:2508.05105v2:
<https://arxiv.org/abs/2508.05105>.

Use the following exact clauses:

- **Theorem 4.1 and Remark 4.2:** a maximal \(F\)-bundle splits locally into
  the generalized eigenspaces of quantum multiplication by the Euler field;
  formal and complex-analytic versions are explicitly included.
- **Definition 5.10:** local \(G\)-atoms are connected components of the
  reduced unramified spectral cover of that Euler operator.
- **Definitions 5.20--5.21:** a spectral component gives a geometric
  \(G\)-atomic \(F\)-bundle germ.
- **Proposition 5.22:** the abstract local atom maps to its geometric atomic
  \(F\)-bundle, compatibly with disjoint unions, blowups, and projective
  bundles.

These clauses are enough to attach the formal-monodromy lemma to an atom. The
André-motive, Tannakian, Hodge-polynomial, pairing, and integral-lattice
enhancements in the rest of the paper are not needed.

### 3. Projective-bundle persistence

KKPYY Theorem 4.11 gives the canonical projective-bundle decomposition of
maximal \(F\)-bundles. Proposition 5.22(3) states its chemical-formula form:

\[
\operatorname{CFF}_G(\mathbf P(V))
=\operatorname{rank}(V)\operatorname{CFF}_G(X).
\]

For the trivial rank-two bundle on \(X\),

\[
X\times\mathbf P^1=\mathbf P_X(\mathcal O_X^{\oplus2}),
\]

so its chemical formula contains \(\alpha_X\) with multiplicity two.  In
particular, the product formula contributes
\(2\nu_6(\alpha_X)=4\), so the sixth-root multiplicity survives
stabilization with positive coefficient.

This coefficient cannot cancel in weak factorization.  The chemical formula
takes values in the free abelian group on atom classes; projectivization gives
coefficient \(+2\), while every center occurring in a fourfold weak
factorization has dimension at most two and therefore has \(\nu_6=0\).

The C907 Fourier calculation of the small connection gives the same answer:
the \(\mathbf P^1\) factor has integral exponent zero, so tensoring preserves
\(\pm1/6\). It is an excellent independent check, but Theorem 4.11 and
Proposition 5.22(3) are the load-bearing big-connection statements.

### 4. No atom of dimension at most two has sixth-root monodromy

This is the only classification lemma needed.

> **Low-dimensional lemma.** If a geometric atomic \(F\)-bundle is represented
> by a smooth projective complex variety of dimension at most two, its
> fractional formal-monodromy powers lie in
> \(\{0,1/2\}\subset\mathbf Q/\mathbf Z\).

Proof:

1. A point has exponent \(0\).
2. \(\mathbf P^1\) has exponent \(0\). Cai's Proposition 7 computes a
   positive-genus curve and gives only exponent \(1/2\) in its odd part,
   together with integral powers in the even part.
3. If \(S\) is a minimal surface with \(K_S\) nef, KKPYY Claim 6.15 uses
   \[
   g=\mathrm{Gr}+\tfrac12T
   \]
   with integral eigenvalues and gauges the connection, after adding the
   half-parity term, to a regular-singular connection with nilpotent residue.
   Undoing the gauge gives exponent \(0\) on even cohomology and \(1/2\) on
   odd cohomology.
4. A minimal projective surface of Kodaira dimension \(-\infty\) is
   \(\mathbf P^2\) or ruled. Projective space has exponent \(0\), and a ruled
   surface is a \(\mathbf P^1\)-bundle over a curve, so KKPYY Theorem 4.11
   reduces it to curve atoms.
5. Every nonminimal smooth projective surface is obtained from a minimal one
   by point blowups. KKPYY Theorem 4.5, or Proposition 5.22(2), adds only
   point atoms.

Therefore every atom represented in dimension at most two has
\(\nu_6=0\).

Hypotheses used in Claim 6.15:

- \(S\) is smooth and projective;
- \(K_S\) is nef;
- the bulk point is on the parity-fixed base and its \(H^0\)-coordinate is
  zero.

The last normalization loses nothing: translation in the identity direction
changes only the scalar exponential factor and not the fractional formal
monodromy.

### 5. Weak-factorization no-cancellation

KKPYY Proposition 5.17 states:

> If a \(d\)-fold contains an atom not representable by a smooth projective
> variety of dimension at most \(d-2\), then it is not rational.

Its proof is exactly the needed weak-factorization ledger:

- a birational map to \(\mathbf P^d\) factors into blowups and blowdowns with
  smooth centers;
- every center has codimension at least two, hence dimension at most \(d-2\);
- the blowup formula adds only atoms of those centers;
- \(\mathbf P^d\) itself is a projective bundle over a point, so it has only
  point atoms.

For \(Y=X\times\mathbf P^1\), \(d=4\). The atom \(\alpha_X\) occurs in
\(\operatorname{CFF}_G(Y)\) with coefficient two and has
\(\nu_6(\alpha_X)=2\), while the low-dimensional lemma gives
\(\nu_6=0\) for every atom represented in dimension at most two.
Proposition 5.17 gives the contradiction.

## Complete proof spine

The publishable proof can be displayed in five lines:

1. Cai Proposition 6 gives \(\nu_6(\alpha_X)=2\) on the cubic zero
   atom identified in KKPYY Example 6.21.
2. KKPYY Theorem 4.11 / Proposition 5.22(3) puts two copies of
   \(\alpha_X\) in \(X\times\mathbf P^1\).
3. KKPYY Claim 6.15, surface classification, and the projective-bundle and
   point-blowup formulas show that every atom of dimension at most two has
   only \(0\) or \(1/2\) fractional powers.
4. The paper-local formal-monodromy lemma shows the sixth-root multiplicity is
   invariant under all atom equivalences.
5. KKPYY Proposition 5.17 with \(d=4\) proves
   \(X\times\mathbf P^1\) irrational.

## Can the proof avoid the full KKPYY machinery?

### Yes: avoid almost all of it

A self-contained special-case proof can define only:

- the zero spectral component of the maximal A-model \(F\)-bundle;
- its formal-monodromy eigenvalue spectrum;
- the chemical-formula identities for a blowup and a projective bundle.

Then repeat the one-paragraph proof of Proposition 5.17 for a weak
factorization of \(X\times\mathbf P^1\dashrightarrow\mathbf P^4\).

This avoids:

- general \(G\)-atom quotients for arbitrary Weil theories;
- André motives and Tannakian groups;
- Hodge-atom polynomials;
- pairings, Serre operators, and Gamma-integral enhancements;
- all higher-dimensional carrier analysis.

In practice the paper should state the formal-monodromy lemma and the
low-dimensional lemma, then cite KKPYY Theorems 4.5 and 4.11 for the two
chemical-formula identities.

### No: two deep imports remain

The proof cannot honestly be made elementary without replacing:

1. the maximal/big A-model blowup decomposition; and
2. the maximal/big A-model projective-bundle decomposition.

Those are the deep inputs of KKPYY/Iritani and Iritani--Koto. Reproving them
would be far larger than the theorem. The special-case presentation should
therefore be self-contained **after** these two named decomposition theorems,
not claim to be independent of them.

The atom quotient itself is optional. If Proposition 5.17 is not imported,
write its special fourfold proof explicitly: orient every blowup relation in a
weak factorization, move the center formulas to the two sides, and observe
that a sixth-root atom occurs on the \(X\times\mathbf P^1\) side while
\(\mathbf P^4\) and every center on either side have only \(\pm1\) formal
monodromy. This is the same no-cancellation argument in elementary multiset
language.

## Hypothesis ledger

| Hypothesis | Where used | Status |
|---|---|---|
| \(X\) smooth cubic threefold over \(\mathbf C\) | Cai Proposition 6; cubic atom | exact |
| Big/maximal A-model \(F\)-bundle, not only small quantum cohomology | atom and birational formulas | Cai upgrades to big; KKPYY works maximally |
| Parity-equivariant theory \(G=\mu_2\) | even-bulk base and odd/even surface split | available in KKPYY framework |
| Cubic zero spectral component does not split locally | identifies \(\alpha_X\) | KKPYY Example 6.21 |
| Formal monodromy is invariant under regular/integer-power gauges and atom transport | distinguishes \(\alpha_X\) | print the paper-local lemma |
| Projective-bundle decomposition for the trivial rank-two bundle | \(X\times\mathbf P^1\) | KKPYY Theorem 4.11 / Proposition 5.22(3) |
| Surface MMP/classification over \(\mathbf C\) | exhausts surfaces | classical |
| \(K_S\) nef in the non-ruled minimal case | surface spectrum | KKPYY Claim 6.15 |
| Blowup decomposition for point blowups | nonminimal surfaces and weak factorization | KKPYY Theorem 4.5 / Proposition 5.22(2) |
| Weak factorization in characteristic zero | rational fourfold contradiction | AKMW/Włodarczyk; packaged as KKPYY Proposition 5.17 |
| All weak-factorization centers have codimension at least two | dimension \(\le2\) | standard weak factorization |

## Referee-facing cautions

1. Do not present the small tensor-product calculation as the proof of the
   big-connection projective-bundle statement.
2. Do not argue with an unqualified multiset of exponents; attach it to the
   zero spectral atom and prove invariance under the atom equivalences.
3. Do not say Cai proves the product theorem. Cai supplies the cubic block.
4. Do not say KKPYY state the product theorem. Their decomposition,
   low-dimensional regularity, and no-cancellation criterion imply it.
5. Do not call the conclusion stable irrationality. It proves irrationality
   after exactly one stabilization.
6. Because both quantum sources are recent preprints, include the complete
   special-case bridge in the paper rather than outsourcing the logical
   composition to citations.

## Source integrity

The source statements above were checked against cached primary PDFs:

- arXiv:2608.01577v1, SHA-256
  06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e;
- arXiv:2508.05105v2, SHA-256
  2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64.
