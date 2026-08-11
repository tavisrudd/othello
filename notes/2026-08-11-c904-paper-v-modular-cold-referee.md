# Paper V, Packet R: modular cold-referee report

## Verdict

**MINOR**

The Section 9 extension calculation is mathematically sound when read without the
checker, scripts, or computational outputs. One short representation-theoretic bridge
needed by the final Frobenius theorem is used rather than proved or explicitly cited.
There is also a smaller canonicity overstatement. Both admit local repairs; neither
changes the claimed theorem, its novelty boundary, or the computation-free proof
strategy.

## Frozen artifact and evidence boundary

- Manuscript: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`.
- Verified SHA-256:
  `c8427d8178e9a2d8534950cff5cd40422ebcb0ddb578e8181bf65137f781d3ba`.
- Primary read: the full frozen PDF, with detailed audit of Section 9 (PDF pp. 14--16).
- Packet R was treated only as a question list, not as evidence.
- Proof-deletion test: no repository checker, JSON certificate, source script,
  computational output, or prior referee report was used to validate Section 9.
- Public modular-representation source consulted: F. M. Bleher, *Universal
  deformation rings and Klein four defect groups*, DOI
  `10.1090/S0002-9947-02-03072-6`. Exact read depth: the publicly indexed text of
  Section 3.3 on journal p. 3901 from the `Case (III)` heading through the definitions
  of the four length-two uniserial modules and the displayed part of Lemma 3.5's
  proof; and journal p. 3902 from the restriction-to-`A4` paragraph through
  Proposition 3.6 and the end of Section 3. I did not use the unread intervening
  portion of p. 3902.

## Earliest unsupported implication

The earliest unsupported implication in the Section 9 proof spine is the final
paragraph of Proposition 9.2 (PDF p. 15):

> Proposition 9.1 shows that \(M\) is nonsplit, so it realizes the unique
> nonsplit isomorphism class.

Proposition 9.2 computes extensions for either Frobenius-conjugate **natural**
two-dimensional \(\mathbf F_4\)-module. Proposition 9.1 has shown that its concrete
heart \(H=[G,M]\) is a simple two-dimensional \(\mathbf F_4\)-module, but the
manuscript does not print the bridge identifying this \(H\) with one of those natural
modules. The next theorem also asserts
\(\operatorname{End}_{\mathbf F_2G}(H)=\mathbf F_4\) without proving the equality.

The smallest ambiguity is that simplicity over \(\mathbf F_4\) and the relation
\(\bar\varphi^2+\bar\varphi+1=0\) give an embedded copy of \(\mathbf F_4\) in the
commutant; they do not, by themselves, identify the representation or exclude a
larger \(\mathbf F_2\)-linear commutant.

A local repair suffices. After Proposition 9.1, observe that the nontrivial
two-dimensional representation \(G\to\mathrm{GL}_2(\mathbf F_4)\) is faithful because
\(A_5\) is simple, has determinant one because \(A_5\) is perfect, and hence has image
all of \(\mathrm{SL}_2(\mathbf F_4)\) by order. Thus it is a natural module, up to the two
Frobenius-conjugate identifications. Add the standard centralizer calculation
\(\operatorname{End}_{\mathbf F_2G}(\mathbf F_4^2)=\mathbf F_4\), or cite it at the
exact point of use.

Downstream scope requiring re-read after that insertion: Theorem 9.3; the final
endomorphism-field and torsor clauses of Theorem 1.3; the upper-branch comparison in
Section 10; and the corresponding abstract and conclusion sentences. The Ext
dimension, nonsplitting, and unique-middle-module arguments themselves do not need
to change. The novelty boundary is unaffected.

## Other controlling findings

### 1. Canonical quotient versus canonical trivialization

**Type:** mathematical precision. **Locator:** Theorem 1.3 (PDF p. 4), read with
Proposition 9.1 (PDF pp. 14--15).

The submodule \(H=[G,M]\), the quotient \(M/H\), and the exact sequence
\(0\to H\to M\to M/H\to0\) are canonical. An identification
\(M/H\cong\mathbf F_4\), however, requires choosing a nonzero vector of the quotient
and has an \(\mathbf F_4^\times\) ambiguity. Accordingly, the displayed sequence with
terminal object \(\mathbf F_4\) is canonical only up to endpoint automorphism. This is
consistent with
Proposition 9.2's later observation that endpoint scalars move transitively among the
three nonzero extension classes.

Smallest repair: state that there is a canonical nonsplit sequence ending in the
trivial \(\mathbf F_4\)-line \(M/H\), and then write \(M/H\cong\mathbf F_4\). No downstream
mathematics or novelty claim changes.

### 2. The printed extension proof passes without computation

**Type:** acceptance finding. **Locators:** Proposition 9.1 (PDF pp. 14--15) and
Proposition 9.2 (PDF p. 15).

The two displayed generator actions force \(M^G=0\), so an invariant \(\mathbf F_4\)-line
cannot split the quotient. The four printed commutators span the stated four-dimensional
binary heart. In Proposition 9.2 the triangle relations give
\(\dim_{\mathbf F_4}Z^1=3\); the injective coboundary map from \(H\) gives
\(\dim_{\mathbf F_4}B^1=2\); hence the Ext line has dimension one. Endpoint scalar
automorphisms act transitively on its three nonzero classes, which proves uniqueness
of the middle-module isomorphism type rather than merely counting extensions.

The lattice intersection is also exact: from
\(D_6^\vee=\mathbf Z^\Omega+\mathbf Z\mathbf1/2\) one has immediately
\(2D_6^\vee=2\mathbf Z^\Omega+\mathbf Z\mathbf1\), so the claimed intersection and
the identification of the augmentation heart follow. No software premise is hidden in
these steps.

### 3. Bleher is corroborative, not load-bearing

**Type:** citation/priority finding. **Locator:** last sentence of Proposition 9.2
(PDF p. 15).

At the read depth recorded above, Bleher Section 3.3 identifies the three simple
modules in the principal characteristic-two block of \(A_5\) and the four possible
length-two uniserial modules with the stated ordered composition factors. That supports
the manuscript's restrained sentence that its result “agrees with” the block
description. It does not supply the manuscript's concrete cocycle dimensions,
nonsplitting witness, or endpoint-automorphism orbit; those stronger claims are
correctly proved internally. The citation is therefore accurate and the stated novelty
boundary remains credible.

## Protocol answers

1. **Earliest failure:** the unprinted natural-module/commutant bridge at the end of
   Proposition 9.2, detailed above.
2. **Smallest ambiguity:** \(\mathbf F_4\) is shown to act on \(H\), but equality with the full
   \(\mathbf F_2\)-linear commutant and identification with the natural module are not yet
   established in the text.
3. **Local repair:** yes; two short representation-theoretic sentences (plus the
   quotient-canonicity wording change) suffice.
4. **Downstream re-read:** Theorem 9.3, the affected clauses of Theorem 1.3, Section
   10's upper-branch application, abstract, and conclusion.
5. **Novelty boundary:** unchanged. Bleher supplies nearby block structure; the
   manuscript's concrete integral realization and Frobenius identification remain its
   internally proved contribution.
