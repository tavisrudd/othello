# C807: novelty audit for the recognition-group criterion — synthesis and gap closure

**Date:** 2026-08-02
**Lane:** `ame-lu`
**Object audited:** `notes/2026-08-02-c804-recognition-group-criterion.md`

Two halves were run in parallel and are the primary records; this file
synthesises them and closes the two gaps they left open. Read them for the
search logs, screened sets and per-source detail:

- quantum stabilizer and local-unitary/local-Clifford literature —
  `notes/2026-08-02-c807-audit-quantum-lu-lc.md` (25 sources, 1 at full text)
- tensor-decomposition uniqueness —
  `notes/2026-08-02-c807-audit-tensor-uniqueness.md` (19 sources, 0 at full text)

**Coverage headline.** Across both halves, one source of forty-four was read at
full text before this file's gap closure; this file adds two more, both
load-bearing. Every negative below is a searched-and-found-nothing negative over
that coverage, not a claim that no predecessor exists. MathSciNet and Google
Scholar are NOT COVERED in both halves; zbMATH Open was reached by the quantum
half only. Kruskal's own 1977 paper could not be fetched (bot protection on the
only open-access location) and stands at `secondary only` through Kolda and
Bader.

## Verdicts, consolidated

| Claim | Verdict |
|---|---|
| Axis-recovery lemma | **Pre-empted.** Jennrich's uniqueness theorem, published in Harshman 1970 |
| Theorem P at intermediate index size | No predecessor located; method pre-empted, conclusion not |
| Lemma R, recognition group | Definition plus observation; nontriviality at local dimension two is Gross and Van den Nest's |
| Corollary G, generation | No predecessor located; the two-label case at local dimension two is unnamed inside a published proof |
| Lemma M at arbitrary dimension | No predecessor located; routine, and to be presented as the general form of their Lemma 1 |
| Subsumption of their Theorem 1 | Sound, but a *unification* at local dimension two, not a strengthening |
| Arbitrary local dimension | **No predecessor located — the strongest and most unoccupied claim** |
| Corollary C, CSS states | No predecessor located |

Actions already taken from these verdicts: the criterion note carries all four
wording corrections, and the manuscript citation repair is committed (see
below).

## Manuscript repair, done

`papers/ame_lu/sections/03-lu-rigidity.tex` now attributes Lemma
`diagonal-axes` to Jennrich's theorem as published in Harshman 1970, records it
as the full-column-rank case of Kruskal's condition extended to arbitrarily
many factors by Sidiropoulos and Bro, points to Kolda and Bader for the
attribution chain, and states that no novelty is claimed for the statement or
the proof. Four bibliography entries were added with bibliographic detail taken
from the Crossref records consulted by the tensor half, never from recall.
Warning-free 45-page build; the four citations resolve in the rendered page.
Commit `a742efca`.

This repair was the audit's most urgent product because it corrects material
that was already in the release candidate, independently of whether any
reframing is ever adopted.

## Gap closure 1: the local-dimension-nine counterexample — the criterion passes

**Source.** Wong and Jiang, *Local unitary decomposition of tripartite
arbitrary leveled qudit stabilizer states into p-level-qudit EPR and GHZ
states*. Identifier arXiv:2507.09416v2 (26 Sep 2025). **Read depth: `full
text`** of the extraction, cache key `arXiv:2507.09416`, poppler `pdftotext`,
913 lines; sections relied on: abstract, I, II (preliminaries and notation,
including the `Z_D`-module convention and equation (1)), and III with the
worked example at equations (4) and (5).

**What it actually contains.** They decompose tripartite stabilizer states at
arbitrary local dimension into `p`-level GHZ states, EPR pairs and unentangled
qudits, and their contribution is that this requires local unitaries *outside*
the Clifford group once the dimension is a proper prime power. Their worked
example, at local dimension nine on three qudits: the state stabilized by
`⟨X₁X₂X₃, X₁³X₂⁶, Z₁Z₂Z₃, Z₁³Z₂⁶⟩` is not Clifford-equivalent to the
Greenberger–Horne–Zeilinger state stabilized by `⟨X₁X₂X₃, Z₁Z₂⁸, Z₁Z₃⁸⟩`, yet
the two are equivalent by local unitaries. Both are products of two
three-level GHZ states, associated differently.

**The test.** Corollary G, applied to this pair, would force every local factor
Clifford and contradict their result. So the recognition groups must be proper.
Computing them from their generators, with a general element
`(X₁X₂X₃)^a (X₁³X₂⁶)^b (Z₁Z₂Z₃)^c (Z₁³Z₂⁶)^d`, `a,c ∈ Z₉`, `b,d ∈ Z₃`, the
party labels are `(a+3b, c+3d)`, `(a+6b, c+6d)`, `(a, c)`. Setting each party in
turn to zero gives the minimal supports: `{1,2}` at `a = c = 0`, `{1,3}` at
`a = −6b, c = −6d`, and `{2,3}` at `a = −3b, c = −3d`, each of order nine. Every
one of them projects at party one into `{0,3,6} × {0,3,6}`. The three-party set
is not a minimal support, so the full-support generators `X₁X₂X₃` and `Z₁Z₂Z₃`
are not minimal elements and contribute nothing. Hence

  Λ₁^max = π₁(M(ψ)) = 3Z₉ × 3Z₉,

of order nine inside a label group of order eighty-one — **proper, of index
nine.** The criterion's prediction holds on the first published state able to
test it above local dimension two.

**And the value is explanatory, not just confirmatory.** The recognition group
is exactly the three-torsion subgroup, which is precisely the sub-dimension
structure their decomposition exploits: their whole construction is about
three-level pieces living inside nine-level qudits. Our invariant computes their
structural obstruction, which is a stronger result than passing a consistency
check.

**What this does not settle.** It does not close the open two-party question.
Their minimal supports have two parties and index sets of order nine, which is
the `r = 2`, `3 ≤ N < d²` case that the criterion's sharpness section leaves
open. One might hope the counterexample refutes a rescue of that case, but it
does not: the recognition ceiling here is proper regardless, so Corollary G
fails for a reason independent of arity. The question stays open.

## Gap closure 2: Chang and Jing — method collision confirmed, conclusion unaffected

**Source.** Chang and Jing, *Local unitary equivalence of generic multi-qubits
based on the CP decomposition*, International Journal of Theoretical Physics
(2022). Identifiers arXiv:2205.06422v1; DOI 10.1007/s10773-022-05106-w. **Read
depth: `full text`** of the extraction, cache key `arXiv:2205.06422`, poppler
`pdftotext`, 2528 lines; their Lemma 1 and the following derivation read
directly, plus a full-text keyword sweep.

**Confirmed at the depth the verdict needs.** Their Lemma 1 is that conjugation
by a special unitary of degree two acts on the Pauli matrices through an
orthogonal rotation, and the coefficient tensor of the state transforms
accordingly; uniqueness of the decomposition then yields invariants and criteria
for local-unitary equivalence. That is our machine and must be cited.

**The decisive negative, now verified rather than inferred.** A keyword sweep of
the complete extraction finds **no occurrence of "Clifford", "stabilizer" or
"Weyl" anywhere in the paper.** Their subject is generic multi-qubit states, and
at local dimension two the basis-normalization conclusion is vacuous, since
every single-qubit unitary preserves the span of the Pauli operators by their
own Lemma 1. Our conclusion — that a local factor must permute the projective
Weyl axes, and is therefore Clifford — is nontrivial only above local dimension
two, where a general unitary does not preserve those axes. The method is theirs;
the conclusion is not addressed by them at all.

Wording rule that follows: cite Chang and Jing for the machine, and scope any
"to our knowledge" sentence to the conclusion at local dimension above two.
Never to the method.

## Remaining gaps, carried forward

- Kruskal 1977 unread; the k-rank condition stands at `secondary only` through
  Kolda and Bader. Harshman 1970 read at `partial`, from a re-typeset
  reproduction rather than the 1970 original.
- MathSciNet and Google Scholar NOT COVERED in both halves; zbMATH Open not
  reached by the tensor half.
- Rains, *Polynomial invariants of quantum codes*, named as a seed and not read.
  The manuscript's existing Rains citation is untouched and unverified by this
  audit.
- The Gross and Van den Nest record is fragmented across three OpenAlex entries,
  so no single count from that service is usable for it; the Semantic Scholar
  and Crossref counts stand.
- The PARALIND and Lovitz–Petrov material behind the ceiling escape route was
  located but not read.

## Standing conclusion

Nothing located pre-empts the criterion at arbitrary local dimension, which is
the claim the reframing would rest on. Two things must be cited that were not
before: Jennrich by way of Harshman for the axis lemma, now repaired in the
manuscript, and Chang and Jing for the tensor-uniqueness method. One claim must
be softened from "generalizes" to "unifies" at local dimension two. With those
in place the position is defensible, subject to the coverage limits above.
