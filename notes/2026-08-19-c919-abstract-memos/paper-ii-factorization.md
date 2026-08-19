# Paper II — clebsch-factorization: abstract-tightening review (C919 follow-up)

**Date:** 2026-08-19 · **Reviewer scope:** read-only; no manuscript edits made.

**Verdict:** The proposal is a near no-op (253 words vs the current 256) with two supported additions and one good deletion; every claim checks against the body, but it fails the tightness target — use the shorter counter-draft below (235 words) which also adds the missing "up to interchange" scope qualifier.

## 1. Word counts

| Version | Words (abstract body, `\begin{abstract}`…`\end{abstract}` exclusive) |
|-------------------|-----|
| Current abstract | 256 |
| Proposed abstract | 253 |
| Recommended draft | 235 |

Counted by `tr -s ' \n' ' ' | wc -w` on the abstract body lines
(current: clebsch_factorization.tex:38–67; proposal: proposal file lines 129–161).

Key structural fact: the proposed replacement is not a rewrite. It is the
current abstract verbatim except for four deltas:

1. "The trade recovers their…" → "In each case the trade recovers the…" (cosmetic).
2. Para 3 adds "signed tensor moments vanish through degree two and" and
   "which orients the recovered sheets" (both supported; see §2).
3. Gorenstein sentence reworded: drops "already" and "of the Schur square";
   "configuration-specific contributions" → "the new configuration-specific content".
4. Deletes the final sentence "A common alternating-cycle and Dickson calculation
   supplies the radial nonvanishing needed for the quotient ranks."

So "replace the abstract" is really "apply four small edits", and the net length
change is −3 words. Under the author's standing tight-and-short preference, the
proposal as written does not earn its billing as a tightening.

## 2. Claim-by-claim verification (proposal text vs body)

All citations are to /home/tavis/src/othello/papers/clebsch-factorization/clebsch_factorization.tex.

1. **All-field classification, exactly B3/F7 and H3/F11, full PGL2(q)-orbits of
   perfect matchings, odd finite fields.** Supported. Main theorem
   (thm:factorization-recovery) item (i), lines 132–136; standalone form in
   thm:balanced-orbit-completeness, lines 906–930 (any odd prime power q, any
   G-orbit of perfect matchings of P^1(F_q)). The proposal's red-team caution
   not to shorten to "all conic matchings" is correct.
2. **One-dimensional strength-two trade, two-valued generator.** Supported:
   lines 132–136 and hypothesis block lines 919–921 ("(L∘2)⊥ is one-dimensional
   and every nonzero vector in it takes exactly two values").
3. **Trade recovers the two complementary sheets.** Supported but under-scoped
   in BOTH the current abstract and the proposal: theorem item (iii), lines
   140–142, says "up to interchange, the unique complementary halves with equal
   first and second tensor moments"; thm:balanced-cubic (i), lines 1779–1780,
   same. The proposal's own red-team note ("Do not say that quadratic data
   recover the ordered sheets") and cross-paper check 2 ("Quadratic data recover
   sheets only up to interchange") state the right constraint, yet the proposed
   text never says "up to interchange" — it relies on the later orientation
   sentence to imply it. My draft makes it explicit at cost of three words.
4. **"Without assuming self-association or Gorensteinness."** Supported:
   introduction lines 97–105 ("without assuming its group type,
   self-association, or Gorenstein coordinate ring"; "no self-duality or
   Gorenstein premise").
5. **Fixed locus is an affine line of q pairwise nonconjugate rational points.**
   Supported: thm:fixed-line-chow-rigidity (i), lines 1642–1649 ("Its q rational
   points lie in distinct G-orbits").
6. **q−2 nonmatching orbits with the same one-dimensional two-valued
   strength-two trade condition.** Supported exactly: theorem items at lines
   149–152 (main theorem (vi)) and 1655–1658 (fixed-line theorem (iii)); the
   count is re-derived at lines 1713–1719 (q−1 noncoalescent orbits = 1 matching
   + (q−2) nonmatching) and independently gated at lines 3507–3508.
7. **"The remaining rational point is the coalescence parameter."** Supported:
   q points = 1 matching + (q−2) nonmatching-trade + 1 coalescence; lines
   1713–1717 ("exactly one coalescence parameter t=c/2 … matching point is t=0,
   and c≠0"), intro display (1.1) and lines 242–243, remark at 1722–1728.
8. **"Only the matching point splits completely into linear factors" / "unique
   completely split point."** Supported with a terminology caveat: the body's
   term is *geometrically* split — thm:fixed-line-chow-rigidity (ii), lines
   1651–1653 ("the matching point is its unique geometrically split point"),
   and lines 229–231 define the geometric Chow locus as forms that "split
   geometrically into linear factors". The abstract's "completely split" is
   true (the matching point is a product of F_q-rational secant lines, and
   uniqueness geometric is stronger than uniqueness rational), and it is the
   current abstract's existing wording, so no change is forced — but see §6.
9. **"The exceptional one-factorizations are classical; the new boundary is the
   fixed line and its unique completely split point."** Supported and correctly
   retained per the proposal's own instruction; matches the priority hygiene of
   lines 156–162.
10. **"Signed tensor moments vanish through degree two; first nonzero signed
    moment is an anti-invariant cubic."** Supported: main theorem (iv), lines
    143–145; thm:balanced-cubic (ii)–(iii), lines 1783–1796 (μ1=μ2=0, μ3≠0;
    G+ fixes μ3, outer coset negates it — that is the anti-invariance);
    cor:secant-product-syzygies display (4.7), lines 2012–2019. The proposal's
    addition of "vanish through degree two" is a genuine improvement: it makes
    "first nonzero" meaningful.
11. **"…which orients the recovered sheets."** Supported: lines 1798–1799
    ("degree three is the first signed tensor moment … that orients the
    recovered sheet pair"). Note the body immediately scopes the minimality to
    signed tensor moments, "not every possible nonlinear statistic" (lines
    1800–1801); the abstract's phrasing ("first nonzero signed moment") already
    carries that scope. Safe.
12. **14- and 22-point homogenizations self-associated and arithmetically
    Gorenstein.** Supported: cor:self-associated-gorenstein, lines 1949–1960
    (reduced self-associated arithmetically Gorenstein set of 2q points; 2q =
    14, 22 for q = 7, 11); main theorem (v), lines 146–148.
13. **"Maximal isotropy identifies this cubic with the Macaulay inverse system
    of an Artinian reduction."** Supported: corollary lines 1956–1959 (socle
    residue vector ε, inverse system F_q·μ3), proof-mode line 1810–1811
    ("maximal-isotropic quotient duality gives the Gorenstein pairing"), and
    lines 1859–1860, 3549 (L is maximal isotropic; the degree-1-by-degree-2
    pairing comes directly from maximal isotropy).
14. **Gorenstein attribution.** Supported: lines 156–162 (Rodríguez-Pajares–
    Ruano–Salizzoni characterize the Gorenstein defect via the Schur square;
    "That general mechanism is not a priority claim here") and lines 1982–1991
    (zero-defect case of the modern self-dual-code criterion). The proposal's
    rewording DROPS "of the Schur square" and "already". That slightly blurs
    which general mechanism is being disclaimed — the current wording names the
    Schur square, exactly matching cross-paper check 2 ("the general
    Schur-square mechanism is not claimed as new"). I keep the current, more
    specific wording.
15. **"Targeted modular detectors, made exhaustive by Faber's tame subgroup
    theorem, exclude every other matching orbit without a field census."**
    Supported: lines 763–770 (Faber's tame subgroup theorem [Theorem C] makes
    the stabilizer list "exhaustive without a recursive subfield argument"),
    line 192 (reading map), line 3520 ("Faber supplies the abstract tame
    subgroup types"), and introduction line 97 ("a low-degree recognition
    theorem rather than an orbit census").
16. **Deleted sentence (alternating-cycle/Dickson radial nonvanishing).** The
    deletion is sound: it is proof machinery, documented at the level it
    belongs (e.g. proof mode lines 1804–1812, reading-map nodes); no theorem
    claim or scope qualification is lost.

Nothing in the proposed replacement is unsupported or strengthened beyond the
theorems. Nothing load-bearing is dropped except as noted in item 14 (Schur-square
specificity — restored in my draft).

## 3. Macro check on the proposed LaTeX

Preamble defines only two custom macros: `\F` (line 26) and `\cC` (line 27); no
style file is loaded beyond standard packages (lines 3–15, amsmath/amssymb/
amsthm/mathtools present).

The proposed block uses: `\F` (defined), `\operatorname` (amsmath — available),
and plain `B_3`, `H_3`, subscripts. It correctly uses
`\operatorname{PGL}_2(q)` rather than a `\PGL` macro — `\PGL` is NOT defined in
this paper, so the style instruction's example list ("\F, \PG, \PGL, \PP,
etc.") must not be taken as license to write `\PGL` here. Verdict: all macros
used in the proposal compile in this preamble; no missing definitions.

## 4. Judgment on the proposal's own red-team notes

All six notes are correct:

- "Signed tensor moments vanish through degree two" — verified (item 10 above).
- "First nonzero signed moment is an anti-invariant cubic" is the actual
  orientation mechanism — verified (items 10–11).
- "Unique completely split point" scoped to the fixed line, not global —
  verified (item 8); the body's uniqueness is in fact geometric, which is
  stronger than the abstract needs.
- "All-field orbit classification" scoping warning — verified (item 1).
- Unordered-sheets warning — correct in substance, but the proposal's own text
  does not act on it (item 3): it never says "up to interchange".
- Omitting the Dickson sentence — agreed (item 16).

One miss in the proposal's self-assessment: it presents the edit as fixing a
final paragraph that "shifts from theorem content into a dense list of proof
machinery". Only the last sentence is proof machinery; the rest of that
paragraph is theorem content (Gorenstein corollary) and attribution, which the
proposal correctly keeps. And the proposal does not shorten the abstract in any
real sense (−3 words), against the author's standing preference.

## 5. Recommended abstract (paste-ready)

235 words — shorter than both the current abstract and the proposal, keeps
every theorem claim and every scope qualification, and adds the missing
"up to interchange".

```latex
\begin{abstract}
Restriction to a conic forgets how its marked points were paired into
secants.  Among full \(\operatorname{PGL}_2(q)\)-orbits of perfect matchings
over odd finite fields, we classify those whose conic-quotient evaluation
space has a one-dimensional strength-two trade---a signed relation
annihilating all quadratic coordinate products---generated by a two-valued
vector.  Exactly two occur: the balanced \(B_3/\F_7\) and \(H_3/\F_{11}\)
orbits.  The trade recovers their two complementary sheets up to
interchange, without assuming self-association or Gorensteinness; signed
tensor moments vanish through degree two, and the first nonzero signed
moment is an anti-invariant cubic that orients the sheets.

The restriction to perfect matchings is sharp.  For either surviving
stabilizer, the fixed locus in the ambient conic-product fiber is an affine
line of \(q\) pairwise nonconjugate rational points: \(q-2\) nonmatching
orbits satisfy the same trade condition and one point is the coalescence
parameter, but only the matching point splits completely into linear
factors.  The exceptional one-factorizations are classical; the new
boundary is the fixed line and its unique completely split point.

The \(14\)- and \(22\)-point homogenizations are self-associated and
arithmetically Gorenstein, and maximal isotropy identifies the cubic with
the Macaulay inverse system of an Artinian reduction.  General
self-dual-code criteria already explain the Gorenstein consequence of the
Schur square; the configuration-specific contributions are the all-field
orbit classification, sharp matching boundary, sheet reconstruction, and
cubic orientation.  Targeted modular detectors, made exhaustive by Faber's
tame subgroup theorem, exclude every other matching orbit without a field
census.
\end{abstract}
```

**What I cut and why:**

- "A common alternating-cycle and Dickson calculation supplies the radial
  nonvanishing needed for the quotient ranks" (final sentence of current
  abstract) — proof machinery, not a theorem claim; fully documented in the
  proof-mode note and reading map. Agrees with the proposal.
- "Thus complete splitting selects the matching orbit from the fixed line" —
  restates in one sentence what the sentence before it (only the matching point
  splits) and the sentence after it (unique completely split point) already
  say; merging the fixed-line facts into one sentence removes the redundancy.
- Standalone sentence structure of para 2 ("Only the matching point splits …,
  although q−2 nonmatching orbits …; the remaining rational point …") —
  reordered into "q−2 satisfy the trade + 1 coalescence, but only the matching
  point splits", which accounts for all q points in one pass.

**What I refused to cut:**

- The full classification scoping (full PGL2(q)-orbits, perfect matchings, odd
  finite fields, one-dimensional, strength-two, two-valued) — every word is a
  hypothesis of thm:balanced-orbit-completeness.
- "Without assuming self-association or Gorensteinness" — the paper's central
  non-circularity claim (intro lines 97–105).
- The q−2 nonmatching-orbit count and the coalescence parameter — this is the
  sharpness content of thm:fixed-line-chow-rigidity; dropping either would
  overstate what the trade condition alone achieves.
- "The exceptional one-factorizations are classical; the new boundary …" —
  the priority hygiene sentence; the proposal also insists on it.
- The Schur-square attribution with "already" and "of the Schur square" —
  restored against the proposal (see item 14); it names the general mechanism
  being disclaimed, per cross-paper check 2.
- Faber exhaustiveness / "without a field census" — this is what makes the
  all-field claim believable in one sentence.

**What I added:** "up to interchange" (theorem (iii)'s exact qualifier, which
both the current abstract and the proposal leave implicit) and "that orients
the sheets" (the proposal's supported addition, kept).

## 6. Separate manuscript issues (not fixed, per instructions)

1. **"Completely split" vs "geometrically split".** The abstract (current,
   proposed, and mine) says "splits completely into linear factors"/"unique
   completely split point"; the body's defined term is *geometrically* split
   (lines 229–231, 1651–1653). The claims are true as written, but the
   abstract uses a term the body never defines while the body's uniqueness is
   actually the stronger geometric statement. A one-word alignment
   ("geometrically split") in the abstract, or a parenthetical in Section 4,
   would remove the mismatch. Flagging only.
2. **"Human input" labels in the trust-boundary appendix** (lines 3513–3517:
   "remains a human input", "remain human and classical inputs"). The author's
   recorded convention is that structural proofs and trust boundaries carry no
   "human" label — say what the input is (e.g. "a classical input", "proved in
   the printed argument") instead. Flagging only.
3. The theorem at line 127 forward-references "the finite matching orbits
   defined in Section 3" (sec:rank-three) for A3/B3/H3 — standard practice,
   no issue; noted only to record it was checked.
