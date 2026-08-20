# C924 — rigorous audit of the direct quantum-`D`-module proof

**Lane:** `cubic-threefolds`

**Date:** 2026-08-19

**Scope:** mathematics only; no manuscript or Lean edits

## Verdict

**The direct-QDM route proves that a smooth cubic threefold \(X\) has
irrational one-stabilization \(X\times\mathbf P^1\), subject to one mandatory
coefficient-ring correction stated below.**  The correction is local and uses
the coefficient ring explicitly provided by Iritani--Koto; it does not require
a new geometric or analytic theorem.  With that correction, every bridge in
the proof is either contained in the packet, standard, or an exact consequence
of the cited primary source.

The packet is therefore **mathematically verified after repair**, but it should
not be promoted word for word.  Its sentence in §13 that the full intrinsic
formal Novikov completion embeds into the \(q^{-1}\)-Laurent ring is false as
stated: a general \(q\)-adic series has no image in a \(q^{-1}\)-adic Laurent
field.  The correct common-coefficient-spine argument is given in
[Mandatory repair 1](#mandatory-repair-1-projective-bundle-coefficient-spine).

Two smaller proof-text corrections should be made at the same time:

1. in (10.0f), choose a coordinate occurring in the lowest homogeneous term of
   \(d\), rather than saying that every partial derivative has initial degree
   \(m-1\);
2. for \(\mathbf P^4\), invoke directly the nonzero discriminant of
   multiplication by \(E=5H\) at the small point, not semisimplicity of the
   algebra alone.

Neither affects the theorem.

## Material read before the audit

I read the following in full before issuing the proof verdict.

- The complete epilogue source: the root file and all six section files,
  5,293 lines in total.  No paper file was edited.
- `/home/tavis/Downloads/direct_qdm_proof_packet_unified_stronger.md`, SHA-256
  `0b9585af18a82baf9e6e4ba2168033e80efc861bf5d251cf1ef734f1f4dbb96b`.
- `/home/tavis/Downloads/stable_irrationality_qdm_atom_monodromy_research_memo.md`,
  SHA-256
  `9b526aadd79db88a3d943e03778a76543a13ce0e7cc1baae0e4c441bbcd44a8d`.
- Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, 69 pages,
  SHA-256
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Iritani--Koto, *Quantum cohomology of projective bundles*,
  arXiv:2307.03696v4, 40 pages, SHA-256
  `5139f8e0c9d46f8ccb8cb415396a0fb1fb357719b7dcfbca46234a9735b57624`.
- Beauville, *Quantum cohomology of complete intersections*,
  arXiv:alg-geom/9501008, 11 pages, SHA-256
  `9d022796aefa01fd601820e415c5462bdfc255b3b4fe158af64b51f7bf0a83e3`.
- Abramovich--Karu--Matsuki--Włodarczyk, *Torification and factorization of
  birational maps*, arXiv:math/9904135, SHA-256
  `55bbc2c58f29d4b9dbe965035f80f3844f6968eaf98076ac625132ac3b3977a5`.
- David--Hertling, *Regular F-manifolds: initial conditions and Frobenius
  metrics*, arXiv:1411.4553, SHA-256
  `7a4a81f95091e19c4eb9aa6b82fb993f61ac365090c1435eed42c9c141a3e818`.
  This is only a cross-check; the final dependency graph does not use it.

The shared literature cache verified with 778 entries and zero problems after
the Beauville source was added.

## Claim-by-claim audit

| Load-bearing step | Exact input checked | Verdict |
| --- | --- | --- |
| Numerical Novikov reduction | Packet Lemma 2.1; bounded-degree Chow varieties; numerical divisor and Chern pairings | **Pass.** A bounded ample-degree slice contains finitely many effective homology classes, so coefficient grouping and convolution are continuous. The comparison identities descend together with their inverses. |
| Generic coefficient fields | Numerical effective monoid in the torsion-free lattice \(N_1(Y)\) | **Pass.** The completed monoid algebra is a domain by its lowest ample-degree part. Scalar extension preserves Jordan data. |
| Formal spectral splitting | Packet Lemmas 5.1--5.2 | **Pass.** The off-diagonal Sylvester operator is an invertible scalar plus a nilpotent operator. Flatness kills every base-direction off-diagonal Laurent coefficient. No ramification in \(z\) is introduced. |
| Pairing and elementary modification | Packet §§6.1--6.4 | **Pass.** Pairing horizontality gives \(N^TP_0=P_0N\); in rank two this makes \(L=\operatorname{im}N=\ker N\) isotropic and forces \(A_0L\subset L\). The modification is therefore regular and intrinsic. |
| Constancy of the marker | Packet §6.5 | **Pass.** After centering, the leading base coefficient is \(q_\delta N\). Modified flatness kills the only possible \(z^{-1}E_{21}\) pole and gives \(\delta R=[G_\delta,R]\), so trace, determinant, and \(\delta^\sharp\) are constant. |
| Cubic small quantum ring | Beauville main theorem and formulas (2.1)--(2.3) | **Pass.** For a cubic, \(\mu=27\), \(\ell_0=6\), \(\ell_1=15\). Restoring degree gives exactly the three products in packet §7. |
| Cubic finite block | Packet §§8--9 plus exact replay below | **Pass.** \(\chi_K=m_K=T^2(T^2-108q)\); the zero factor is one \(J_2\); the modified residue has trace \(-1\), determinant \(5/36\), and discriminant \(4/9\). |
| Persistence on the big even base | Packet §10.0 | **Pass with one wording repair.** Hensel isolates ranks \(1,1,2\). The centralizer is \(BI\oplus BN\), and flatness gives \(\partial_a\det N=2q_a\det N\). Choose a variable present in the lowest nonzero homogeneous term to conclude \(\det N=0\). The unit matrix entry keeps \(N\ne0\). |
| Independent summand spectra | Iritani Theorem 5.18(7); Iritani--Koto Theorem 5.1(5); packet Lemma 11.1 | **Pass.** The even-even Jacobian is invertible on the even slice. Independent unit coordinates translate whole spectra, and the resultant has a nonzero leading power of their difference. |
| Noninjective center map | Iritani Remarks 2.3 and 5.6, equation (5.15); packet Lemma 11.2 | **Pass.** Numerical reduction is essential. Fibres of the raw monomial map are finite by an ample compact slice, while independent divisor characters separate every finite fibre by a Vandermonde determinant. This gives a faithful reduced center pullback. |
| Regularity and parity of comparisons | Iritani Theorem 5.18; Iritani--Koto Theorem 5.1 and Remark 5.3 | **Pass.** Both maps and inverses are over \(\mathbf C[z]\)-rings regular at \(z=0\). Roots of even Novikov variables remain parity-even; the leading Gysin/hyperplane formulas and the super-coordinate maps preserve parity. |
| Projective-bundle ledger | Iritani--Koto equation (5.2), Theorem 5.1 | **Pass after Mandatory repair 1.** The source supplies the common faithful ring needed to compare intrinsic and Laurent-generic Jordan data. |
| Blowup ledger | Iritani equations (5.38)--(5.43), Theorem 5.18 | **Pass.** The blowup-side map is an embedding. The repaired center map, independent units, regularity, and parity yield \(m(\operatorname{Bl}_Z Y)=m(Y)+(r-1)m(Z)\). No recursive composition of Laurent completions is used. |
| Curves | Stable-map geometry and the string equation | **Pass.** \(\mathbf P^1\) is generically simple. For genus at least one the primary big product is classical; a nonzero rank-two curve block has scalar modified-residue spectrum and \(\delta^\sharp=0\). |
| Surfaces with nef \(K\) | Dimension axiom and packet formula (3.2) | **Pass.** The centered Euler operator raises ordinary degree by at least two, hence has cube zero and one eigenvalue; its even rank is at least three. |
| Other surfaces | Minimal-surface classification; Iritani--Koto; point blowup ledger | **Pass.** A minimal projective surface with non-nef \(K\) is \(\mathbf P^2\) or geometrically ruled. The first is generically simple and the second reduces to curve QDMs. Point blowups do not change the marker count. A standard classification citation should be supplied in a manuscript. |
| Weak factorization and contradiction | AKMW Theorem 0.1.1 | **Pass.** Projective weak factorization has smooth centers. A nontrivial center in a fourfold has dimension at most two, so every arrow preserves the marker count. Multiplication by \(E=5H\) on small \(QH(\mathbf P^4)\) has five distinct eigenvalues. |

## Mandatory repair 1: projective-bundle coefficient spine

The following claim in packet §13 must not be used:

> the intrinsic formal Novikov ring embeds in the Laurent ring merely by
> adjoining Laurent powers of the fibre variable.

If the intrinsic ring contains arbitrary \(q\)-adic series, no map
\(\mathbf C[[q]]\to\mathbf C((q^{-1/r'}))\) with \(q\mapsto q\) exists.

Iritani--Koto give the correct repair directly.  In §5.1 they define the
projective-bundle QDM over
\[
R_0=\mathbf C[z,q][[Q,\widehat t]]
\]
and define its localized form by the injective base change
\[
R_0\hookrightarrow
R_\infty=\mathbf C[z]((q^{-1/r'}))[[Q,\widehat t]].
\]
The numerical reduced connection matrices lie over the corresponding reduced
version of \(R_0\).  There is also an injective map from \(R_0\) to the usual
full effective-cone completion \(R_{\mathrm{full}}\).  Consequently
\[
\operatorname{Frac}(R_0)longrightarrow
\operatorname{Frac}(R_\infty),
\qquad
\operatorname{Frac}(R_0)longrightarrow
\operatorname{Frac}(R_{\mathrm{full}})
\]
are field extensions.  Characteristic factors, ranks, nilpotent Jordan type,
regular-gauge residue data, and their algebraic-closure signatures are
unchanged by either extension.  Thus the decomposition over \(R_\infty\)
computes the intrinsic generic block ledger without ever defining a map from
the full \(q\)-adic completion to the \(q^{-1}\)-adic Laurent field.

The base-QDM map
\[
Q_B^d\longmapsto q^{-c_1(V)\cdot d/r}Q^d
\]
is the explicit embedding in Iritani--Koto (5.2), so every base summand is
likewise a faithful scalar extension of its intrinsic generic QDM.

This common-ancestor argument is also the right general formulation whenever
an asymptotic QDM theorem and an ample-adic intrinsic completion have opposite
topologies.

## Exact finite-algebra evidence

The audit script is
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`, SHA-256
`8ed415ae249c89964172d839680efc630a493f73e641bfd97dff45593ca41ebf`.
Its deterministic output is
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.json`, SHA-256
`8aabee0487f3a3adc5c3b2aa1471232498af17a583f68e163d26782ba3d7ad9f`.

Replay:

```bash
nix shell --impure --expr 'with import <nixpkgs> {}; python3.withPackages (ps: [ ps.sympy ])' \
  -c python3 notes/cubic-threefolds-tasks/c924-finite-cubic-check.py \
  | diff -u notes/cubic-threefolds-tasks/c924-finite-cubic-check.json -
```

The replay passed with SymPy 1.14.0.  It checks exact rational identities, not
floating-point approximations.  The surrounding proof is independent of the
script.  In particular, the only second-order entry used by the residue can be
seen by hand from the two complementary simple blocks:
\[
(E_0)_{21}
=-\frac{4r}{3}\frac1{27r}
 +\frac{4r}{3}\left(-\frac1{27r}\right)
=-\frac8{81}.
\]

No Lean check was needed.

## Safe simplification and compression

These reductions are available only because the repaired proof above passes.

### 1. Work on the even QDM only

Define the marker using an even spectral block with
\[
\operatorname{rank}=2,
\qquad N\ne0,
\qquad \delta^\sharp\ne0.
\]
The cubic has \(\delta^\sharp=4/9\).  Every possible curve block of even rank
two has \(\delta^\sharp=0\) (or \(N=0\)); nef-\(K\) surfaces have even rank at
least three; the remaining low-dimensional cases are simple or reduce to
curves.  Therefore the odd rank \(10\) is not needed for exclusion.

This removes the computation of \(b_3(X)\), the total-cohomology parity-rank
signature \((2,10)\), and most of the spectrum-transfer discussion.  The only
parity statement retained is that the Iritani and Iritani--Koto maps restrict
to isomorphisms of their even QDMs.

### 2. Keep only the flatness persistence proof

Packet §10.0 is self-contained and shorter than §§10.1--10.2.  The
David--Hertling discriminant route can be removed from the proof and, if
desired, retained only as an audit note.  This also removes an external
dependency.

### 3. Shorten the cubic matrix appendix

For the theorem one needs the \(1|1|2\) conjugation, the \(2\times2\) regular
block \(D_0\), and one cross-term \((E_0)_{21}\).  The full displayed \(A_1\)
and the unused entry \((E_0)_{12}\) are audit data, not necessary main-text
data.  The two-term calculation above replaces most of the second-order
matrix display while retaining hand verifiability.

### 4. Do not compress the divisor-tagging repair

Numerical Novikov reduction, finite raw-map fibres, independent divisor
characters, and the common coefficient spine are the proof's most likely
referee failure point.  They should stay together as one explicit proposition.

### 5. State the stronger ledger consequence

The proof actually gives a birational invariant of smooth projective
fourfolds: the count of repaired even marker blocks is unchanged under every
weak-factorization step, because every center has dimension at most two.
The irrationality of \(X\times\mathbf P^1\) is the comparison of this invariant
with \(\mathbf P^4\), rather than a one-off use of the ledger.

The optional formal-monodromy replacement in packet §25 is not presently a
compression win.  It trades the elementary Lax calculation for an
isomonodromy statement and a resonance discussion.  The repaired
\(\delta^\sharp\) route is more self-contained.

## Dependency and trust boundary

The proof depends on standard genus-zero Gromov--Witten theory, Beauville's
cubic computation, the v3 blowup-QDM theorem, the v4 projective-bundle-QDM
theorem, minimal-surface classification, and projective weak factorization.
It does **not** depend on Cai, KKPY/HYZZ reconstruction, a Hodge-atom theorem,
David--Hertling, or a compatibility of recursively composed Laurent
completions.

The two QDM decomposition papers were still listed by Iritani as forthcoming
in their destination journals at the time of this audit.  The arXiv versions
above, not an unspecified future pagination, are the checked mathematical
inputs.

## `ej` + `tt` closeout and mystery ledger

The closeout pass produced two cheap upgrades:

1. the common-coefficient-spine repair, which removes the only real topology
   error in the packet; and
2. the even-only, qualitative marker \((2,N\ne0,\delta^\sharp\ne0)\), which is
   strictly smaller than the packet's \((2,10;4/9)\) signature but proves the
   same theorem.

It also exposes the fourfold birational invariant in the preceding section.
These are task-owned consequences, not separate conjectural leads.

**Mystery ledger.** No genuine mathematical mystery remains for the
one-stabilization theorem.  The conceptual meaning, if any, of the particular
number \(4/9\) is open but irrelevant: only its nonvanishing is used after the
even-only compression.  Final journal-volume and page references for the two
forthcoming QDM papers are a bibliographic publication gate, not an evidence
gap.  No incidental observation met the discovery-track discriminator.

## Final assessment

After the coefficient-spine repair, the route is a rigorous ordinary
quantum-`D`-module proof.  Its genuinely novel load-bearing point is not the
cubic matrix calculation; it is the combination of numerical Novikov
reduction with independent divisor characters, which turns Iritani's
potentially noninjective raw center map into a faithful reduced-QDM pullback.
The proof can then be made substantially shorter by working only with even
QDM blocks and a nonzero modified-residue discriminant.
