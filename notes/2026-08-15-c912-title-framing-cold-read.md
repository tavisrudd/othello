# Cold read: retitle and two-theorem framing, cubic stabilization epilogue

**Lane:** `clebsch` · **Task:** C912 · **Date:** 2026-08-15

Read-only cold read of the uncommitted working-tree change in
`papers/cubic-stabilization-epilogue`: the title change and the new
introduction framing. Nothing under `papers/` was edited; no build was run.

Sources read: `cubic_stabilization_epilogue.tex`, `sections/01-introduction.tex`,
`sections/03-minimal-class.tex` (statements around
`thm:six-axis-divided-powers`, `cor:universal-ch0`), `sections/04-one-step.tex`
(`thm:nu6-birational-invariance`, `prop:cubic-packet`,
`prop:low-dimensional-vanishing`), `sections/05-synthesis.tex`, `README.md`,
`.zenodo.json`, `lean/README.md`, `papers/summary/README.md`,
`papers/style-guide.md`.

## A. Accuracy of the new title

New title: *Irrationality of Cubic Threefolds after One Stabilization*.

**Accurate, and strictly more accurate than the old one.** `thm:every-cubic`
(01-introduction.tex:33-37) is: for every smooth complex cubic threefold `X`,
`X x P^1` is irrational. Universal `CH_0`-triviality appears only as a
hypothesis imported from other authors in `cor:voisin-separation`,
`cor:fermat-separation`, `cor:coprime-separation`, and as a conclusion proved
for one pencil in `thm:separation-family` / `cor:universal-ch0`. The old title
therefore advertised a restriction the main theorem does not carry, and the
retitle removes a real misstatement.

**Overselling risk: low but nonzero.** A skimmer who reads only
"Irrationality of Cubic Threefolds" sees Clemens-Griffiths. The qualifier
"after One Stabilization" is in the title itself and the abstract's first
sentence names `X x P^1`, so the misread does not survive one line. The
in-paper name of the theorem is "One-step irrationality", which is sharper
than "after one stabilization" and is not used in the title.

**Second theorem now unrepresented, but it was before too.** The all-degree
integral saturation theorem (`thm:six-axis-divided-powers`,
03-minimal-class.tex:324-334) is invisible in the new title. It was equally
invisible in the old one: "universally `CH_0`-trivial" there named a class of
cubics, not the saturation theorem. So the retitle loses nothing that the old
title carried; it only stops mislabelling `thm:every-cubic`. If the second
theorem should be visible in the title, that is a new requirement, not a
regression.

Two alternatives, if a change is wanted:

1. *Irrationality of \(X\times\PP^1\) for Every Smooth Cubic Threefold* —
   states the theorem verbatim, removes the Clemens-Griffiths misread
   entirely, and keeps the file name `irrationality_after_one_stabilization.pdf`
   defensible.
2. *One-Step Irrationality and Universal \(CH_0\)-Triviality of Cubic
   Threefolds* — puts both main theorems in the title, and "one-step" matches
   the theorem's own name in the paper.

I prefer the title as changed over both, on the grounds that alternative 1
loses the `CH_0` story completely and alternative 2 reads as if universal
`CH_0`-triviality of cubic threefolds were proved in general rather than along
one pencil. No repair required here.

**DOI / Zenodo.** `README.md:3` carries the badge for
`10.5281/zenodo.21909944`, deposited under the old title, and `.zenodo.json`
is already updated in this change. That is the right order: the next GitHub
release deposits a new version carrying the new title, the old version keeps
the old title, and the concept DOI resolves to the newest. No action beyond
making the next release. The PDF file name is unchanged and remains consistent
with the new title (it was never the full title).

## B. Truth of every new sentence

Line references are to `sections/01-introduction.tex` in the working tree.

### B1. "persists on the product and takes every cycle-theoretic obstruction with it" (lines 15-18)

Two problems, one of them a real overclaim.

*"Every cycle-theoretic obstruction" is not defensible as written.* The class
being quantified over is undefined, and at least one natural member of it is a
counterexample: the Clemens-Griffiths intermediate-Jacobian obstruction is
cycle-theoretic (it is read off the Abel-Jacobi image of one-cycles) and it
does not vanish for the universally `CH_0`-trivial cubic threefolds the
paragraph is about — the Fermat cubic threefold is universally `CH_0`-trivial
and irrational, which is the paper's own `cor:fermat-separation`. What is true
is the narrower statement: every obstruction that a decomposition of the
diagonal kills dies with it. Required repair: replace "every cycle-theoretic
obstruction" with "every obstruction that a decomposition of the diagonal
kills", or with "every unramified obstruction".

*The mechanism named is not the paper's.* The paper carries universal
`CH_0`-triviality to the product by the projective bundle formula for Chow
groups (05-synthesis.tex:5-7 and 05-synthesis.tex:32-33), not by exhibiting a
decomposition of the diagonal on `X x P^1`. For the `A_5`-pencil no
decomposition is exhibited at all: 03-minimal-class.tex:374-376 says the
argument "constructs neither a horizontal minimal cycle over the pencil nor a
relative decomposition of the diagonal". So "the decomposition of the diagonal
that makes `X` universally `CH_0`-trivial" presupposes an object the paper
declines to construct for its own family. The equivalence with universal
`CH_0`-triviality makes the sentence true, but it reads as a claim about the
paper's construction. Prefer: "because universal `CH_0`-triviality of `X`
passes to `X x P^1` by the projective bundle formula for Chow groups, and with
it every obstruction that a decomposition of the diagonal kills."

*Persistence is stated elsewhere:* yes, at 05-synthesis.tex:5-7, and for the
Yang-Yu-Zhu family at 01-introduction.tex:80-81 via their Corollary 3.5.

### B2. "the criterion available for a cubic threefold is the algebraicity of an integral class" (lines 18-21)

**False as a universal claim, and the paper refutes it two paragraphs later.**
Voisin's Corollary 4.4 (used at 03-minimal-class.tex:367-372) is one criterion.
The paper also uses two others that do not go through any integral class on the
intermediate Jacobian: Colliot-Thelene's separated-variables theorem for the
Fermat cubic (01-introduction.tex:64-68, 05-synthesis.tex:17-20) and the
coprime-degree unirational parametrizations of Yang-Yu-Zhu
(01-introduction.tex:76-81, 05-synthesis.tex:22-28). Required repair: scope the
sentence to this paper's second theorem, e.g. "since the criterion used along
the `A_5`-pencil is the algebraicity of an integral class".

*"Integrally rather than up to torsion" names the wrong foil.* Torsion is not
what is at stake. The obstruction is divisibility: by
Engel-de Gaay Fortman-Schreieder, every curve class on the intermediate
Jacobian of a very general cubic threefold is an even multiple of the minimal
class (01-introduction.tex:204-208), so the class is algebraic up to a factor
of two but not integrally. The correct contrast is "integrally rather than up
to a multiple" (or "rather than rationally"). This is a required repair
because as written it misidentifies the difficulty the six-axis saturation
theorem exists to overcome.

*"The first theorem below ... the second ..." (lines 21-23) mis-points.* Read
literally, the theorems below in the introduction are `thm:every-cubic` and
`thm:separation-family`. But `thm:separation-family` is a separation statement;
the theorem that "saturates an integral lattice of divisor classes on the
intermediate Jacobian" is `thm:six-axis-divided-powers`, which never appears in
the introduction. Add a pointer, e.g. "the second (Theorem
\ref{thm:six-axis-divided-powers}) proves that the divided powers of an
integral lattice of divisor classes on the intermediate Jacobian are ordinary
divisor products". The gloss "saturates a lattice" is also loose: saturation is
a property of a sublattice, and the theorem's content is that divided powers
land in the ordinary divisor-product image.

*Minor:* "an invariant that survives multiplication by `\PP^1`" (lines 15-16)
is slightly off for `nu_6`, which doubles rather than survives:
`nu_6(Y x P^1) = 2 nu_6(Y)` (04-one-step.tex, proof of
`thm:nu6-birational-invariance`). What survives is nonvanishing. The paper's
own phrasing at line 30-31, "its multiplicity survives one stabilization", has
the same looseness, so this is a consistency point, not a new error.

### B3. "share no input beyond the cubic threefold itself" (lines 160-161)

**Essentially true, with one qualification.** Citation sets are disjoint:
section 3 cites only Voisin and Yu; section 4 cites only Abramovich-Karu-
Matsuki-Wlodarczyk, Cai, and Iritani-Koto. The prose at
01-introduction.tex:176-178 already says the `A_5`-geometry enters only in the
cycle argument and the quantum theorem applies to every smooth cubic threefold.
The qualification: the proof of `thm:separation-family`
(05-synthesis.tex:30-38) uses a third ingredient neither argument supplies, the
projective bundle formula for Chow groups. "They meet only on the fourfold"
covers this loosely. No repair required; consider "share no input beyond the
cubic threefold itself" -> "use disjoint inputs beyond the cubic threefold
itself" if the stronger reading worries you.

### B4. The closing three sentences (lines 180-183)

*"the other certifies that `X x P^1` carries no rational parametrization" is
wrong in this paper's own vocabulary, and required repair.* Two sentences of
`cor:coprime-separation` (01-introduction.tex:83-88) say `X x P^1` **admits
unirational parametrizations** of coprime degrees. A reader who has just been
told those varieties carry parametrizations will read "carries no rational
parametrization" as a contradiction. Replace with "the other certifies that
`X x P^1` is not rational" (or "is not birational to `\PP^4`"). Note the same
loose usage pre-exists at line 9-10, "need not provide a rational
parametrization"; that instance is harmless in context but would be worth
aligning.

*"One argument certifies that the diagonal of `X x P^1` decomposes"* has the
same defect as B1: the paper certifies universal `CH_0`-triviality of the
product, and explicitly declines to construct a decomposition
(03-minimal-class.tex:374-376). Say "certifies that `X x P^1` is universally
`CH_0`-trivial".

*"on the pencil of Theorem~\ref{thm:separation-family} both conclusions hold at
every member" is true.* `thm:separation-family` (01-introduction.tex:103-118)
quantifies over every `b \in B^\circ(\C)` and asserts both universal
`CH_0`-triviality and irrationality of `X_b x P^1`.

*"Each is insensitive to the structure the other reads"* is supported only in
the weaker form the paper proves: the three realized value pairs
`(U, nu_6) = (1,0), (1,2), (0,2)` at 05-synthesis.tex:48-60, whose conclusion is
"neither ... determines the other". "Insensitive" claims more than
non-determination. Acceptable as informal framing; downgrade to "Neither
detector determines the other" if you want it exact.

### Scope boundary

No new sentence contradicts the stated boundary at 01-introduction.tex:154-156
("We do not claim that `X` is stably irrational") or 05-synthesis.tex:62-72.
No new sentence creates a logical dependency between the two theorems: the
framing consistently says they are independent, which matches the proofs
(`thm:every-cubic` never uses `thm:six-axis-divided-powers`, and
`cor:universal-ch0` never uses `nu_6`). The only place they combine is
`thm:separation-family`, and the framing says so.

## C. Prose, against `papers/style-guide.md`

1. **"This paper measures the resulting gap on a single smooth fourfold: we
   exhibit varieties \(X\times\PP^1\) that are universally \(CH_0\)-trivial and
   irrational."** (lines 10-12) Number clash — "a single smooth fourfold" then
   "varieties" plural. "This paper measures" is the stage-label register the
   guide asks to cut ("stage labels that tell readers what the section is
   doing"). Rewrite: "We exhibit smooth fourfolds \(X\times\PP^1\) that are
   universally \(CH_0\)-trivial and irrational."

2. **"Such a fourfold requires two independent theorems, and neither can be
   replaced by the other."** (lines 14-15) A fourfold does not require
   theorems; the exhibition does. The second clause is the symmetric
   mini-slogan the guide names. Rewrite: "Exhibiting one takes two independent
   theorems: the first gives irrationality of the product, the second universal
   \(CH_0\)-triviality of the factor."

3. **"takes every cycle-theoretic obstruction with it"** (lines 17-18)
   Figurative, and an overclaim (B1). Rewrite per B1.

4. **"The two read different structures carried by the same \(X\), which is
   why they can disagree about \(X\times\PP^1\), and the fourfolds where they
   disagree are the content of this paper."** (lines 23-26) Three clauses, two
   personifications ("read", "disagree"), and a generic closing stage label
   ("are the content of this paper"). Rewrite: "Each theorem reads a different
   structure on the same \(X\), so their conclusions about \(X\times\PP^1\) are
   independent."

5. **"The irrationality half has a uniform answer."** (line 28) Dangling
   reference. The old text was "The irrationality half of that question", and
   "that question" pointed at the deleted sentence "We ask how far that gap can
   persist after one explicit stabilization". Nothing in the new paragraph 1
   poses a question with halves. Rewrite: "Irrationality holds uniformly." —
   or restore an explicit question to paragraph 1.

6. **"The two arguments share no input beyond the cubic threefold itself, and
   they meet only on the fourfold."** (lines 160-161) Topic-sentence placement
   is right (guide: topic sentence first), and a lead for this subsection is a
   genuine improvement. But it now says the same thing as the paragraph-final
   sentence four lines later, "The special \(A_5\)-geometry enters only in the
   cycle argument; the quantum theorem applies to every smooth cubic threefold"
   (lines 177-178), and as new intro sentence 4 above. Keep the lead, and cut
   or fold the duplicate.

7. **The closing three sentences** (lines 180-183) are two-thirds restatement.
   Sentence 1 restates the subsection lead; sentence 2 restates intro paragraph
   2; only the `thm:separation-family` clause is new, and section 5 already
   says it ("Both conclusions hold on the \(A_5\)-family",
   05-synthesis.tex:43). Cut to one sentence: "On the pencil of
   Theorem~\ref{thm:separation-family} both conclusions hold at every member:
   \(X_b\) is universally \(CH_0\)-trivial and \(X_b\times\PP^1\) is
   irrational."

Register check: no "delve/intricate/pivotal/underscore" cluster; sentence
shapes are varied; no "Moreover/Furthermore". The main stylistic defect is
repetition across the two new blocks, not vocabulary.

## D. Residue

Old title or old-title framing still present, build artifacts excluded.

| file:line | content |
|---|---|
| `papers/summary/README.md:164` | Link text "Irrationality after One Stabilization of Universally CH₀-Trivial Cubic Threefolds" |
| `papers/summary/README.md:237` | Table row title cell, same full old title in italics |
| `papers/summary/README.md:526` | `#### Irrationality after One Stabilization of Universally CH₀-Trivial Cubic Threefolds` |

These are the three expected occurrences. Two adjacent items in the same file:

- `papers/summary/README.md:537` quotes a stale abstract that opens "Does
  universal CH₀-triviality force rationality after stabilization? We construct
  a non-isotrivial one-parameter family ...". The manuscript abstract
  (`cubic_stabilization_epilogue.tex:44-51`) now leads with the every-cubic
  theorem. The quoted block at 537-541 predates that reordering and carries the
  old title's framing (family first, uniform theorem second). Refresh it with
  the retitle.
- `papers/summary/README.md:208-210` and `:40`, `:65` use the short form
  "Irrationality after one stabilization". Consistent with the new title; no
  change needed.

Inside the manuscript directory the only remaining match is
`papers/cubic-stabilization-epilogue/README.md:1`,
`# Irrationality after one stabilization` — the short-form repository heading,
consistent with the new title and correct as is. `.zenodo.json`, `lean/README.md`,
and `README.md:9` all carry the new title. Nothing in `sections/*.tex`,
`claim-proof-novelty-ledger.md`, `Makefile`, or `verification/` presumes the old
title.

## Verdict

**GO on the retitle. NO-GO on the introduction framing as it stands**, pending
four exact repairs:

1. `01-introduction.tex:17-18` — "takes every cycle-theoretic obstruction with
   it" -> "takes with it every obstruction that a decomposition of the diagonal
   kills". The unrestricted quantifier is falsified by the paper's own
   `cor:fermat-separation`.
2. `01-introduction.tex:19-21` — "since the criterion available for a cubic
   threefold is the algebraicity of an integral class" -> "since the criterion
   used along the \(A_5\)-pencil is the algebraicity of an integral class". The
   paper uses two other criteria (Colliot-Thelene, Yang-Yu-Zhu) that are not of
   this form.
3. `01-introduction.tex:19` — "integrally rather than up to torsion" ->
   "integrally rather than up to a multiple". The obstruction is divisibility
   by two (Engel-de Gaay Fortman-Schreieder), not torsion.
4. `01-introduction.tex:181` — "the other certifies that \(X\times\PP^1\)
   carries no rational parametrization" -> "the other certifies that
   \(X\times\PP^1\) is not rational". As written it contradicts
   `cor:coprime-separation`, which gives `X x P^1` unirational parametrizations.

Recommended but not blocking: point "the second" at
`thm:six-axis-divided-powers` explicitly (B2); restate "one argument certifies
that the diagonal of \(X\times\PP^1\) decomposes" as universal
`CH_0`-triviality of the product (B4); repair the dangling "The irrationality
half" (C5); cut the duplication in C6 and C7; refresh
`papers/summary/README.md` at lines 164, 237, 526, 537-541.
