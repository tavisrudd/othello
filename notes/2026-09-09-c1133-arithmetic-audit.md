# C1133 — arithmetic finiteness and polarized-isogeny cross-check

**Date:** 2026-09-09. **Status:** downstream deduction checked, relative to the
written Hodge-conservation gate and the imported statements below. Literature
closure and manuscript review remain open.

**2026-09-10 source update:** the original Narasimhan–Nori scan, pages
125–128, is now fully read; Theorem 1.1 and its principal-polarization
consequence match the input below. The original-access gap is closed. See
`2026-09-10-c1133-source-literature-closeout.md` for its hash and read record.
Earlier inaccessible-source wording below records the previous checkpoint.

## The bounded-degree deduction

Fix a smooth cubic threefold X over a finitely generated characteristic-zero
field K⊂C. Achter's Theorem B supplies its arithmetic intermediate Jacobian
A=J(X), with its principal polarization. For a candidate Y over L/K with
[L:K]≤D, geometric one-stable birationality gives a rational Hodge isomorphism
by the proposed conservation theorem. This is an isogeny J(Y)_C∼A_C, not a
polarized or integral identification.

For abelian varieties over an algebraically closed field, extending that field
does not introduce new homomorphisms. Thus this isogeny exists over K-bar.
Orr, arXiv:1209.3653v4, Theorem 5.1, gives one in the direction

    A_Kbar → J(Y)_Kbar,   degree ≤ c(A,K) D^κ.

The field of definition of this isogeny need not have degree ≤D. That is not
an assumption of Orr's statement. His proof first passes to an extension of
bounded degree to define homomorphisms; this does not change the theorem's
quantifiers. The constants do not depend on Y or a chosen target polarization.

Choose an integer N at least this bound. A kernel of order at most N is killed
by M=lcm(1,...,N), and A[M](K-bar) is finite. There are therefore finitely many
possible kernels and finitely many target abelian varieties A/H up to geometric
isomorphism. By fixed-degree polarization finiteness, each has finitely many
principal polarizations modulo automorphisms. Cubic Torelli gives at most one
cubic geometric class per resulting principally polarized intermediate Jacobian.
This proves the proposed finiteness deduction.

The argument counts geometric isomorphism classes of Y. It supplies no bound
on twists over K, no effective count of partners, and no height condition.
The original Narasimhan–Nori article remains inaccessible as a PDF. Its indexed
Theorem 1.1 excerpt and the secondary sources agree on the required statement.
Milne's accessible *Abelian Varieties* v2.00, Theorem 15.1, independently states
the same fixed-degree polarization finiteness over any field. This is additional
statement-level corroboration; no complete reading or verification of Milne's
reduction-theory proof is claimed. Original-source access remains a documented
audit gap, not a reason to change the mathematical quantifiers.

## A second check, using fourth powers

A forward citation led to Orr, arXiv:1506.04011v3, whose Theorems 1.1 and 1.3
give a separate route through polarized isogenies. They are statements over a
common field, so apply them over K-bar.

Theorem 1.1 says an unpolarized isogeny between principally polarized A and B
implies a polarized isogeny between their fourth powers. Meanwhile the fourth
power of the bounded unpolarized isogeny has degree at most N^4. Applying
Theorem 1.3 to the fixed principally polarized A^4 gives a polarized isogeny

    (A,λ)^4 → (B,μ)^4,   degree ≤ C (N^4)^k,

where k may be taken as 4 dim(A^4)=16 dim(A). For intermediate Jacobians of
cubic threefolds, this is at most C N^320. The constant C depends only on the
fixed polarized fourth power; it is not asserted numerically effective here.
In particular all such fourth powers lie in a bounded polarized-isogeny orbit
of a fixed ppav. One cannot replace fourth powers by the original ppavs:
Orr's Proposition 3.1 is announced precisely as a counterexample to that
stronger compatibility claim.

For completeness, bounded polarized-isogeny degree gives finitely many target
ppavs. There are finitely many kernels H. If h*μ=mλ on a fixed source of
dimension g, then deg h=m^g, so m is bounded too. For fixed H and m there is
at most one target polarization: pullback along the quotient is injective on
Hom(B,B-dual), as can be checked after tensoring with Q and inverting the
isogeny. Finally, uniqueness of the decomposition of a ppav into indecomposable
ppavs recovers B from B^4 by dividing every factor multiplicity by four.
This last classical decomposition theorem is recalled in the inspected
generalities of Kresch–Tanimoto–Tschinkel; its original proof is not newly
audited here. Thus this is an alternative deduction from explicit imported
inputs, not a proof from scratch of polarization finiteness.

The fourth-power bound is a useful consistency check exposed by the audit.
The short finite-kernel/finite-polarization argument remains the economical
candidate for the manuscript. No editorial choice is enacted here.

## Citation coverage

Publication DOI aliases were verified from source metadata, not guessed from
titles. Independent counts are:

| Source alias | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| Voisin, 10.1112/S0010437X21007727 | 6 | 6 | 10 |
| Orr, 10.1515/crelle-2013-0058 | 21 | 13 | 37 |

The Voisin largest set is the same ten-record Semantic Scholar source already
retrieved. Orr's 37-record set was retrieved with no next token; all titles were
screened. Abstracts were additionally read for entries 0, 11 and 25; entry 35
has no abstract and remains unresolved. Entry 25 was promoted to the partial
primary-text read above. Exact query, discriminator, records, counts and response
hashes are in the adjacent publication-alias and Orr citation-set JSON files.
The earlier arXiv-DOI zero counts cannot stand in for these publication records.

## EJ+TT and Mystery ledger

- **Settled deduction:** bounded field degree controls a geometric isogeny
  degree, which controls a finite target list; it need not control the field
  of definition of a particular isogeny.
- **Cheap additional check:** fourth powers admit a uniform polarized-isogeny
  degree bound. This supplies a second route and explains why one must not
  quietly preserve principal polarizations before taking powers.
- **Settled indexing issue:** publication aliases materially enlarge the citing
  sets. Source identity is part of coverage, not a bibliographic afterthought.
- **Open:** original NN facsimile access, remaining citation leads and optional
  applications. No novelty or effectiveness claim follows from these checks.
