# Paper V cold referee — Packets C/L

## Verdict

**MINOR**

The uniform lattice theorem in Section 8 survives as a standalone printed
proof after deleting every script and finite output. The controlling defect
is earlier, in Proposition 4.1: the exact outer-difference scalar \(8\) is
asserted to come from one coefficient comparison, but neither the monomial nor
the two coefficients is displayed. The printed eigenspace argument therefore
proves only a nonzero proportionality until that small calculation is supplied.

## Artifact, scope, and independence

- Frozen PDF read first:
  papers/clebsch-round-trip/golden_companion_reconstruction.pdf.
- SHA-256 verified:
  c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba.
- Close read: Sections 3–4 and 7–9; Section 8 judged independently of the
  order-six specialization. Sections 1–2, 5–6, and 10–12 were read only to
  trace definitions and downstream dependence.
- No replay script, JSON certificate, finite matrix output, prior referee
  report, task card, handoff, or internal proof note was read or run.
- The packet was treated as questions, not evidence.

## Controlling findings

### 1. Earliest unsupported implication: the scalar \(8\)

**Type:** mathematical support gap; local and verdict-controlling.

**Locator:** Proposition 4.1, proof, manuscript p. 8: “Comparing one
coefficient in \(q_\Pi h-h\) with the same coefficient of \(c_B\) gives
\(8\).”

1. **Earliest failing sentence or implication.** Everything needed before
   this point establishes the two-dimensional pencil, its \(+/-\) outer
   eigenspaces, the exchange of the two chordal lines, and hence
   \(q_\Pi h-h=\lambda c_B\) for a nonzero scalar \(\lambda\). The printed
   manuscript does not identify a monomial or print either coefficient, so it
   does not establish \(\lambda=8\) without the deleted computation.
2. **Smallest ambiguity.** Replacing \(8\) by an unspecified
   \(\lambda\in\mathbf F_{11}^{\times}\) is consistent with every displayed
   line of the proof. This is a normalization ambiguity, not a counterexample
   to the projective or selected-line bridge.
3. **Local repair.** Yes. Print the chosen conference representative and one
   line such as
   \([m](q_\Pi h-h)=a\), \([m]c_B=b\), \(a/b=8\), with the monomial \(m\) and
   values \(a,b\) explicit. No new argument or census is needed.
4. **Downstream re-read after repair.** Recheck Definition 1.1's
   \(\alpha^2=8^2\) normalization, Theorem 1.2(ii), Corollary 4.2,
   Proposition 5.2's exact oriented generator, and the exact returns in
   Corollaries 6.1–6.2. The qualitative selected-line isomorphism and all of
   Sections 7–9 are outside this dependency cone.
5. **Novelty boundary.** Unchanged. The cited conference sources support the
   classical switching object and spectral setting, not this marked
   outer-difference normalization.

### 2. Conference classification and orientation otherwise pass

**Type:** accepted mathematics; one editorial clarification advisable.

**Locators:** Lemma 3.3, manuscript pp. 7–8; Proposition 4.1 and Corollary
4.2, p. 8.

First-row normalization leaves a \(2\)-regular negative graph on five
vertices, hence a pentagon. Complementation gives the opposite orientation;
switching, relabeling, and negation are not used as synonyms. The normalizer
quotient \(N_{S_6}(G)/G\cong C_2\) supplies the exchange, and the literal
augmentation permutation makes \(q_\Pi\) linear rather than merely
projective. For maximal clarity, Lemma 3.3 could say explicitly that the
twelve normalized pentagons are the labeled switching classes and that the
two \(G\)-fixed members are the normalizer pair. This is an exposition
improvement, not a second mathematical defect.

### 3. Section 8 passes the standalone deletion test

**Type:** accepted mathematics.

**Locator:** Theorem 8.1, manuscript p. 13.

The proof is uniform in \(n\equiv2\pmod4\) and needs no order-six matrix.
For a normalized symmetric conference matrix, every column of \(I+B\) is
odd and \(\phi_Be_0=h\), so every \(\phi_B\)-stable over-lattice of
\(L=\mathbf Z^n\) contains \(L+\mathbf Zh=D_n^\vee\). The row sums give
\(\phi_Bh=h+((n-2)/4)e_0\), proving preservation and minimality. Diagonal
switching preserves this same lattice (and
\(\phi_{DBD}=D\phi_BD\)). Finally
\(\phi_B^2-\phi_B=((n-2)/4)I\); modulo two the polynomial is irreducible for
\(n\equiv6\pmod8\) and split for \(n\equiv2\pmod8\). In the split case the
displayed facts \(\bar\phi_B(\bar e_0)=\bar h\) and
\(\bar e_0=\sum_{i>0}\bar e_i\) rule out both scalar quotients, so the full
\(\mathbf F_2\times\mathbf F_2\) algebra acts faithfully.

### 4. The order-six residue and extension classification pass

**Type:** accepted mathematics; one optional explanatory line.

**Locators:** Propositions 9.1–9.2 and Theorem 9.3, manuscript pp. 13–15.

The printed generator actions prove \(M^G=0\), the four printed commutators
span the binary heart, and this gives the unique proper two-dimensional
\(\mathbf F_4G\)-submodule and nonsplitting. The triangle-presentation
cocycle count gives \(\dim Z^1=3\), \(\dim B^1=2\), hence the claimed
one-dimensional Ext group; endpoint scalars are transitive on its three
nonzero classes. Reversal sends \(\phi\) to \(1-\phi\), hence exchanges the
two primitive elements by Frobenius. An optional line could make the outer
equivariance completely explicit: diagonal switching is trivial on the
augmentation heart modulo two, so an outer relabeling conjugates the
restriction of \(\bar\phi_B\) to that of \(\bar\phi_{-B}\). No computational
output is needed for these arguments.

## Public-source read depth and attribution boundary

Only public sources explicitly cited by the manuscript for conference
matrices or lattices were consulted.

- Bussemaker–Mathon–Seidel, *Tables of two-graphs*: printed pp. 12 and 21,
  the order-six uniqueness statement on p. 23, and the contents locator for
  Table 9 on p. 83; the full tables were not read.
  <https://pure.tue.nl/ws/portalfiles/portal/2498383/252951.pdf>
- Goethals–Seidel, *Orthogonal matrices with zero diagonal*: pp. 1001–1005,
  comprising the introduction, the equivalence operations and Paley setup in
  §2 through Theorem 2.3, and the opening/necessary-condition theorem of §3.
  <https://www.cambridge.org/core/services/aop-cambridge-core/content/view/28A22B5B4DBB2C7DA9DF99DD89013A7A/S0008414X00054997a.pdf/orthogonal-matrices-with-zero-diagonal.pdf>
- Chapman, *Conference matrices and unimodular lattices*: pp. 1–4, §§1–3
  through Theorem 3.1. This is the skew-conference, imaginary-quadratic
  \(D_n/D_n^+\) analogue, not the symmetric \(D_n^\vee\) minimal-saturation
  theorem.
  <https://empslocal.ex.ac.uk/people/staff/rjchapma/preprint/conf.pdf>
- Haemers–Parsaei Majd, *Spectral symmetry in conference matrices*: abstract
  and the theorem/proposition statements in §§4–5 of arXiv v3; no lattice
  claim was found or relied upon.
  <https://arxiv.org/abs/2004.05829>
- Bleher, *Universal deformation rings and Klein four defect groups*: public
  abstract and bibliographic metadata only; it was not used to validate
  Proposition 9.2 because the manuscript prints its own cocycle proof.
  <https://doi.org/10.1090/S0002-9947-02-03072-6>

Within this cited-source boundary, the manuscript accurately treats the
order-six conference class, switching vocabulary, spectral facts, and nearby
skew-lattice construction as classical. The claimed new material—the marked
outer-difference bridge, its exact normalization, the symmetric
\(D_n^\vee\) saturation, and the composed golden/Frobenius interpretation—is
not pre-empted by the portions read. This is a source-boundary check, not an
exhaustive novelty search.
