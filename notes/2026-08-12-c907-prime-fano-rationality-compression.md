# C907 prime-Fano rationality compression

**Lane:** `clebsch`

**Status:** closed carrier-side compression.  Every smooth complex prime Fano
threefold of genus seven, nine, or ten is rational; consequently each has
framed primitive-sixth multiplicity zero.  This removes all three rows from
the direct prime-Fano carrier scan.  No manuscript, Lean, queue, handoff, or
task-card change is made here.

## Result

Let \(X\) be a smooth complex prime Fano threefold of genus
\(g\in\{7,9,10\}\). Then

\[
  \nu_6(X)=0.
\]

In particular, after the existing genus-eight and genus-twelve compressions,
the exact direct-operator portfolio is only \(V_{10}\) (genus six). None of
the genus-seven, genus-nine, or genus-ten prime families is a pending
operator-certification row.

## Proof

Kuznetsov--Prokhorov give the three cases over an arbitrary characteristic-zero
field.

- For genus seven, Proposition 6.8 says that a prime Fano is rational once it
  has a rational point. This is automatic over \(\mathbb C\).
- For genus nine, Theorem 9.4 identifies its rational-cubic Hilbert scheme
  \(F_3(X)\) with \(\operatorname{Pic}^0(\Gamma)\). Thus
  \(F_3(X)(\mathbb C)\) is nonempty, and Proposition 6.9 makes \(X\) rational.
- For genus ten, Theorem 9.9 identifies the conic Hilbert scheme
  \(F_2(X)\) with \(\operatorname{Pic}^0(\Gamma)\). Hence
  \(F_2(X)(\mathbb C)\ne\varnothing\); together with the automatic complex
  point of \(X\), Proposition 6.10 makes \(X\) rational.

The paper's standing hypothesis for these results is precisely geometric
Picard rank one and genus in \(\{7,9,10,12\}\), which contains every smooth
complex prime Fano in the three listed genera.

The previously established C907 v1 blow-up comparison makes \(\nu_6\)
birationally invariant for smooth projective varieties of dimension at most
four.  Since \(\nu_6(\mathbb P^3)=0\), rationality of \(X\) gives the displayed
identity.

This is only a statement about the closed integer \(\nu_6\).  It neither
constructs the cubic-isotypic Stokes/Rees object nor proves
\(\ell_{1/6}(X)=0\); that strengthened conclusion remains conditional on the
unproved strict analytic comparison.

## Source audit

One external source was read at full text.

1. Alexander Kuznetsov and Yuri Prokhorov, *Rationality of Fano threefolds
   over non-closed fields*, arXiv:1911.08949, preprint PDF, Proposition 6.8
   (PDF p. 38), Propositions 6.9--6.10 (pp. 38--39), Theorem 9.4 (pp. 51--53),
   and Theorem 9.9 (p. 54). Accessed from the arXiv PDF and cached under
   `arXiv:1911.08949`, SHA-256
   `0cdc0dd962fb6af047976dea0976566d9a256b801842aad388133cc677b9e203`,
   789442 bytes, 62 pages. Read depth: **full text** for the stated
   propositions and Hilbert-scheme identifications, their proofs, and the
   standing hypotheses in Section 5. This is the preprint source actually
   read; the report does not assert a theorem-locus check against the
   published version (Amer. J. Math. 145 (2023), 335--411,
   DOI `10.1353/ajm.2023.0008`).

2. `2026-08-12-c907-low-dimensional-stable-birational-compression.md`,
   Sections 1 and 5.  Internal C907 antecedent, read in full for this use: it
   records the already-closed dimension-\(\le4\) birational invariance of
   \(\nu_6\), and explicitly marks the enriched upgrade as conditional.

No novelty, priority, forward-citation, or absence-of-literature claim is
made, so a literature-closure search is not part of this report.

## Validation

This is a source-and-formal-consequence report, not a computational result;
there is no generator or certificate bundle. Validation consisted of reading
the cached three rationality propositions and their Hilbert-scheme inputs,
then checking that their hypotheses specialize to smooth complex prime Fanos
and that the existing C907 dimension-three birational-invariance proposition
has exactly the needed scope. The cached source hash above is the replay
anchor.

## Mystery ledger

- **Settled:** prime Fanos of genera seven, nine, and ten are structurally
  excluded from primitive-sixth carrier admission: their \(\nu_6\) vanishes by
  rationality.
- **EJ/TT closeout:** the free compression is larger than the genus-seven
  point-link alone, because the paper's genus-nine and genus-ten Hilbert-space
  identifications make their rationality hypotheses automatic over
  \(\mathbb C\). The complementary warning is equally decisive: this is a
  complex-ground-field argument and does not turn the nonclosed-field criteria
  into unconditional rationality over an arbitrary field.
- **Open:** certify the provisional genus-six \(V_{10}\) result and,
  independently, prove or refute the enriched length bound for arbitrary
  threefold centers.
- **Boundary:** zero formal multiplicity still does not rule out an enriched
  extension until the Wave-0/Track-A analytic realization exists.
