# Paper V — evidence dossier for the non-isomorphism sentence's verb

**Lane:** `clebsch` · **Date:** 2026-08-20 · **Status:** data collection only; no verdict, no manuscript edit

## The question

Paper V's abstract (committed 2026-08-20) contains this sentence, deliberately left in a stative
construction rather than written as "we show":

> over \(\overline{\F}_{11}\) the conference cubic is not projectively isomorphic to either chordal
> cubic.

The question is whether the paper may claim this in the first person — "we show that over
\(\overline{\F}_{11}\) the conference cubic is not projectively isomorphic to either chordal cubic" —
or whether the claim is an immediate consequence of published work and should stay stative, or carry
a citation, or acquire a numbered statement in the body first.

Three outcomes are possible and this dossier does not choose between them:

1. the statement is classical in substance, so first person overclaims and a citation is the right fix;
2. the statement is new only because it is stated over \(\F_{11}\) rather than over \(\C\), in which
   case a numbered remark carrying the characteristic-\(11\) argument earns the first person;
3. the statement is trivial in any characteristic and deserves neither a citation nor a verb, only a
   parenthetical reason.

## Evidence from Paper V's own body

All line references are to `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.tex`
at commit `cca62972b`.

- **Line 55–58 (abstract).** The claim as stated, over the algebraic closure.
- **Line 103.** The setup names two chordal lines, "each chordal cubic singular along a rational
  normal quartic".
- **Lines 489–492.** "The conference cubic has six isolated nodes by \cite{RuddRigidity2026} and
  therefore spans a different line.  This proves the placement without an exhaustive cubic
  comparison." The node count is **imported from Paper I**, not proved here, and the conclusion drawn
  is that the two cubics span *different lines of the pencil* — a strictly weaker statement than
  projective non-isomorphism.
- **Lines 691–693.** "The corollary *Nodes, symmetry, and integral commutant* of
  \cite{RuddRigidity2026} proves that this triangle cubic has exactly six ordinary nodes in
  projective-frame position.  Since \(H_M\) is singular along a curve, the conference and chordal
  lines are distinct." Again: distinctness of lines in the pencil.
- **Line 1524 (conclusion).** "The chordal and conference cubics are geometrically distinct, but
  after a chordal line is selected they recover the same marked six-axis carrier."

**No numbered statement in the body asserts projective non-isomorphism over the algebraic closure.**
The available argument is one line — the dimension of the singular locus is a projective invariant,
and it is \(0\) for six isolated nodes against \(1\) for a cubic singular along a curve — but it is
not written down, and the two places that come closest both stop at "the lines are distinct".

**A subtlety the verdict must weigh.** What Paper I supplies is six ordinary nodes *in
projective-frame position*, which is a statement about \(\F_{11}\)-rational singular points. The
abstract's claim is geometric, over \(\overline{\F}_{11}\). Ruling out projective isomorphism needs
the conference cubic's *geometric* singular locus to be finite, not merely its rational one. Whether
Paper I's corollary already delivers that, or whether it needs a Weil-bound or degree argument to
exclude a positive-dimensional singular locus with few rational points, is exactly the kind of gap a
numbered remark would have to close.

## Literature evidence

### Read at partial depth

**Casalaina-Martin, Grushevsky, Hulek, Laza, "Complete moduli of cubic threefolds and their
intermediate Jacobians".** Cache key `arXiv:1510.08891`, SHA-256
`d5b3c69094eee70d5486542952f394308e3aa4bdbc5762a85588ebae4b2d7753`, fetched 2026-08-10, 56 pages,
arXiv version, pdftotext extraction at `/tmp/persistent/tavis/lit-search/text/arXiv_1510.08891.txt`.
**Read depth: partial** — extracted-text lines 296–303 and 392–412 only, comprising the GIT
classification theorem, its footnote 1, and Remark 1.2. Load-bearing content:

- Theorem, item (2): "A cubic threefold is GIT semistable if and only if it has at worst
  \(A_1,\dots,A_5\) or \(D_4\)-singularities or its orbit closure contains the chordal cubic."
- Footnote 1 to that item: "In particular, the chordal cubic is the only semistable cubic with
  non-isolated singularities." The footnote attributes the underlying classification to
  `[All03, Thm. 1.3(iii)]`.
- Remark 1.2: "We recall that the chordal cubic is the secant variety of the rational normal curve of
  degree 4 in \(\PP^4\).  Thus, it follows that the chordal cubic is stabilized by a \(\PGL(2)\)
  subgroup of \(\PGL(5)\)."
- Section 3 passage (line 300): Mumford's construction generalizes "to GIT semistable cubics with
  isolated singularities (note that this excludes only the chordal cubic case)".

*Auditor's inference, not the source's framing:* over \(\C\), the isolated-versus-non-isolated
singularity dichotomy already separates any nodal cubic threefold from the chordal cubic, so the
substance of Paper V's abstract sentence is classical **in characteristic zero**. The source says
nothing about characteristic \(11\); every statement above is set over \(\C\) in a GIT context.

**Cheltsov, Tschinkel, Zhang, "Equivariant geometry of singular cubic threefolds".** Cache key
`arXiv:2401.10974`, SHA-256
`5fb44374d4a2c1790c6246a522e12df32afc7c9a81c9ca8bcd1ade62215df089`. **Read depth: partial** —
extracted-text lines 55–63 and the grep hits at 88 and 459 only. Load-bearing content: for a nodal
cubic threefold \(X\), the number of nodes satisfies \(s\le10\); the unique one attaining ten is the
Segre cubic, with \(\operatorname{Aut}(X)\simeq S_6\); and the \(A_5\subset S_6\) that leaves a
hyperplane section invariant has been studied for linearizability. This establishes that nodal cubic
threefolds carrying \(A_5\)-actions are a worked-over family in characteristic zero, but nothing was
read here bearing on a six-nodal member or on a pencil containing both a nodal and a chordal cubic.

### Named and not read

**Allcock, "The moduli space of cubic threefolds" `[All03]`.** **Read depth: secondary only**, through
the Casalaina-Martin–Grushevsky–Hulek–Laza footnote above, whose own depth is partial. Theorem 1.3(iii)
is cited there as the source of the stability classification. A web search additionally surfaced
`https://web.ma.utexas.edu/users/allcock/research/threefolds.pdf` (the Allcock–Carlson–Toledo ball-quotient
memoir, a different work); it was **not fetched**, and the search engine's prose summary of it is not
evidence. Bibliographic detail beyond what the footnote carries is deliberately omitted here rather
than reconstructed from memory.

**Dolgachev, "Corrado Segre and nodal cubic threefolds".** Cache key `arXiv:1501.06432`, SHA-256
`98a898303e06a395bad95888a826e677a955d4b8fc88914c6ede54e31406601e`. **Read depth: metadata plus a
targeted grep only** — a case-insensitive search of the cached extraction for "chordal" and "secant
variety of the rational normal" returned no hits. The paper was not read, and no verdict rests on it.

## Queries run, verbatim

Cache-side, against `/tmp/persistent/tavis/lit-search/text/`:

- `rg -n -i -m 4 'chordal cubic' arXiv_1510.08891.txt`
- `rg -n -i -m 6 'chordal cubic is|secant variety|non-stable|not stable' arXiv_1510.08891.txt`
- `rg -n -i -m 4 'chordal|secant variety of the rational normal' arXiv_1501.06432.txt` (no hits)
- `rg -n -i -m 3 'A_?5|alternating group'` over `arXiv_2401.10974.txt`, `arXiv_2405.02744.txt`,
  `arXiv_2505.03986.txt`

Web-side, two searches:

- `Allcock "moduli space of cubic threefolds" chordal cubic secant variety rational normal curve non-isolated singularities theorem`
- `cubic threefold singular along rational normal quartic curve unique up to projective equivalence positive characteristic secant variety`

The second returned no source addressing the positive-characteristic case; the engine said so
explicitly, and no result was fetched to check further.

## Coverage statement

- **Searched and found nothing:** no source located, in the cache or via the two web searches, that
  states the isolated-versus-non-isolated separation of cubic threefolds over a field of positive
  characteristic, and none that treats an \(A_5\)-invariant pencil containing both a six-nodal and a
  chordal cubic over \(\F_{11}\).
- **Could not access — licenses nothing:** MathSciNet requires institutional authentication and is
  NOT COVERED. zbMATH Open was not queried. Google Scholar blocks automated access. Allcock's paper
  itself was not obtained; only its footnote characterisation was read.
- No citation-graph enumeration was attempted, so the three-service requirement for forward-citation
  negatives is not engaged and no such negative is claimed here.

## What the verdict needs to decide

1. Does the characteristic-zero classical fact — the chordal cubic being the only semistable cubic
   threefold with non-isolated singularities — make the first person inappropriate, even though the
   paper works over \(\F_{11}\) and the cited framing is GIT over \(\C\)?
2. Is the one-line singular-locus-dimension argument enough on its own, in any characteristic,
   making both the citation and the verb unnecessary?
3. Does the geometric-versus-rational singular locus gap noted above need closing before any version
   of the sentence — stative or first person — is safe as written over \(\overline{\F}_{11}\)?
4. If a numbered remark is warranted, what exactly should it assert, and does it belong in Paper V or
   in Paper I, which owns the node count?
