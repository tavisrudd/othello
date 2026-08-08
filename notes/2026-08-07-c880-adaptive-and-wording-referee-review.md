# 2026-08-07 — C880 referee review: the adaptive decoder report and the drafted manuscript wording

**Reviewer role:** cold adversarial referee of
`notes/2026-08-07-c880-adaptive-decoder.md` (+ generator and certificates) and
`notes/2026-08-07-c880-manuscript-wording.md` (+ same-day addendum), checked
against the binding context (`notes/2026-08-07-c880-literature-audit.md`,
`notes/2026-08-07-c880-tetrad-screen.md`,
`notes/2026-08-07-c880-alignment-separation.md`, `papers/style-guide.md`) and
the current manuscript sources. Every load-bearing constant was recomputed
independently; all eleven artifacts were hash-checked and all ten runnable
modes were rebuilt and re-run, including `verify --n 8` and the \(n=40\)
sample. Nothing in the replay plan was skipped.

## Verdict

The decoder's mathematics is sound — the two test identities, the attachment
lemma, the bootstrap completeness argument, the complement equivariance, and
the summations all check out under independent derivation, and ten of the
eleven certificates reproduce byte-identically from the committed generator.
But four findings must be repaired before any of this is promoted: the claim
that adaptivity strictly helps **at every \(n\ge18\)** is not proved (the
all-instance proved bound gives \(n\ge33\)); the drafted manuscript sentence
states the \(\binom n2+n-6\) count unconditionally, omitting the exceptional
class; the "information-theoretic floor \(\lceil5/H(1/4)\rceil=7\)" argument
for the bootstrap is invalid for adaptive play, so the constant 7 rests on the
program alone, contrary to the report's independent-replay section; and
`verify8.json` is a stale certificate that the committed generator does not
reproduce. None of the four collapses a result — the asymptotic headline
(adaptive complexity \(n^2/2+O(n)\), whole coherence cost a cost of
nonadaptivity) survives — but two are wrong statements as written and two are
provenance failures, and all four are the kind of thing a journal referee
would catch.

## MAJOR findings

### MAJOR 1 — "Adaptivity strictly helps at every \(n\ge18\)" is not proved; the proved threshold is \(n\ge33\)

**Where.** `notes/2026-08-07-c880-adaptive-decoder.md` §5, line 206:
"**Item 4 is settled.** Adaptivity strictly helps at every \(n\ge18\), by a
proved construction against a proved nonadaptive floor"; also the summary
item 5 (lines 42–47), whose phrasing "The decoder's proved bound falls below
that floor from \(n=18\) on, and from \(n=33\) on for the exceptional class"
invites the same misreading.

**What is wrong.** Query complexity is a worst case over *all* instances. The
single decoder constructed here is proved to cost at most \(\binom n2+n-6\)
only on instances whose first-six-point graph is non-monochromatic; on the
exceptional complement class the proved bound is \(\binom n2+3n-20\). The
decoder's proved all-instance bound is therefore
\(\max(\binom n2+n-6,\binom n2+3n-20)=\binom n2+3n-20\) for \(n\ge7\). Against
the nonadaptive floor \((\binom{n-1}2-1)/H(1/4)\):
at \(n=18\) the all-instance bound is \(187>166.4\), and it stays above the
floor through \(n=32\) (\(572\) against \(571.94\)); the first \(n\) with
\(\binom n2+3n-20\) strictly below the floor is \(n=33\) (\(607<610.15\)).
"Falls below the floor from \(n=18\) on" is true only of the
non-exceptional-class bound, which is not a bound on any decoder's worst case.
So the proved separation statement is: adaptivity strictly helps for every
\(n\ge33\) (and at \(n=7\) exactly, 22 against 30); for \(8\le n\le32\) it is
open.

**Repair.** In §5 and in summary item 5, state the separation as proved for
\(n\ge33\), with \(n\ge18\) only as what would follow if a decoder handled the
exceptional class within \(\binom n2+n-6+O(1)\) — which is plausible (re-choose
helpers among later attached points once a non-monochromatic six-set exists)
but unproved and uncomputed here. Alternatively, prove that strengthened
decoder and recompute; that would rescue \(n\ge18\) and is the better fix if
cheap.

### MAJOR 2 — the drafted manuscript sentence states the count unconditionally and the separation without its threshold

**Where.** `notes/2026-08-07-c880-manuscript-wording.md`, addendum replacement
text (lines 494–506): "such a decoder does better than any fixed family can:
reading the two-graph on seven points, and then adding one point at a time,
costs \(\binom n2+n-6\) tests in all." Also the addendum's own guard paragraph
(lines 517–522), which repeats "the proved separation against the entropy
floor starts at \(n=18\)".

**What is wrong.** Two overstatements in one sentence. (i) The count
\(\binom n2+n-6\) is proved only outside the exceptional complement class; on
that class the proved bound is \(\binom n2+3n-20\). As drafted, the manuscript
would assert an upper bound that the underlying report does not prove.
(ii) "does better than any fixed family can", unqualified, is a separation
claim at every \(n\); by MAJOR 1 the proved threshold is \(n\ge33\) (and
\(n=7\)). The guard paragraph's \(n=18\) inherits MAJOR 1.

**Repair.** Replace the count sentence with one that carries the class split
or retreats to the safe asymptotic form, e.g.: "…and such a decoder does
better than any fixed family can for every sufficiently large \(n\): reading
the two-graph on seven points and then adding one point at a time costs
\(\binom n2+n-6\) tests outside a single degenerate switching class and
\(\binom n2+3n-20\) on it, below the displayed bound for every \(n\ge33\)."
Fix the guard paragraph's \(n=18\) to \(n=33\) (or to "18 outside the
degenerate class, 33 in all cases" if the report is repaired per MAJOR 1's
alternative).

### MAJOR 3 — the "information-theoretic floor \(\lceil5/H(1/4)\rceil=7\)" argument is invalid for the adaptive bootstrap, so the constant 7 rests on the program alone

**Where.** `notes/2026-08-07-c880-adaptive-decoder.md` lines 24–27 ("which is
the information-theoretic floor \(\lceil 5/H(1/4)\rceil=7\)"), lines 143–145
("Seven is the floor: five bits at \(H(1/4)\) bits per test needs
\(\lceil5/0.8113\rceil=7\)"), and lines 286–290 (independent replay: "The
bootstrap's floor of 7 is confirmed by the entropy count
\(\lceil5/H(1/4)\rceil=7\), which needs no program. The only constant resting
on this program alone is the value 9"). Also the generator comment,
`notes/2026-08-07-c880-adaptive-decoder.rs` lines 393–394.

**What is wrong.** The \(H(1/4)\)-per-test cap is a property of the
*unconditional* marginal of a fixed test, and the report itself (and
`2026-08-07-c880-alignment-separation.md` §5, explicitly) records that this
argument is nonadaptive-only. The bootstrap is adaptive. Conditioned on
earlier answers the yes-probability of an available query is not \(1/4\):
concretely, with helper edges \(e_{12}=e_{13}=0\), after the root query on
\(\{h_1,h_2\}\) answers yes the posterior is the eight assignments with
\(u_1=u_2=0\), and the root query on \(\{h_1,h_3\}\) splits it 4/4 — a full
bit. The chain rule then gives only
\(5\le H(1/4)+(d-1)\cdot1\), i.e. worst case \(d\ge6\), not 7. So the value 7
is correct — it is established by the exhaustive minimax computation
(`bootopt`, all 1024 codes, reproduced here) — but it is *not* confirmed by
any program-free argument, and the independent-replay section's claim is
false: both 7 and 9 rest on this program alone (7's *achievability* is also
witnessed by the trees, but its *optimality* is the minimax computation).

**Repair.** Delete "which is the information-theoretic floor" in item 2 and
the "Seven is the floor" sentence in §3, replacing them with: the exhaustive
minimax computation shows no strategy beats 7 on those 1022 codes; the
entropy argument, being nonadaptive-only, gives just 6 here. Rewrite the
independent-replay paragraph to say the core depth 22 is the one
independently confirmed constant and that 7 and 9 both rest on this program.
Fix the code comment. (If a valid structural proof of the 7 floor is wanted,
it has to engage the query geometry, not the marginal; none is on file.)

### MAJOR 4 — `verify8.json` is stale: the committed generator does not reproduce it

**Where.** `notes/2026-08-07-c880-adaptive-verify8.json` and its hash row in
`notes/2026-08-07-c880-adaptive-decoder.md` line 269.

**What is wrong.** Rebuilding the committed generator (SHA-256 matches the
report; `rustc 1.93.1`) and running `verify --n 8` gives
`queries_mean: 22.051973`, stable across two runs; the committed certificate
records `21.927124`. Every other field agrees, and all ten other artifacts
reproduce byte-identically. The committed value is exactly reproduced by a
variant of the program using the greedy bootstrap (`bootstrap` function)
instead of the minimax trees *and* the fixed helper set \(\{1,\dots,5\}\)
instead of the cheapest-of-six choice — I patched both in and obtained a
byte-identical file. So `verify8.json` was generated by an earlier development
version and not regenerated after the decoder changed. The report's headline
n=8 numbers are unaffected (worst case 30, 2,097,152 instances, all recovered
— true under both variants and reconfirmed here), but the bundle violates
`notes/research-reproducibility-conventions.md`: the hash-pinned certificate
is not an output of the hash-pinned generator, and any independent replay
fails byte-identity exactly as mine did.

**Repair.** Regenerate `verify8.json` with the committed generator and update
its SHA-256 (and mean, if quoted anywhere) in the report's artifact table. One
line of the report also changes: the exhaustive n=8 mean under the shipped
decoder is 22.05, not 21.93 (the report does not currently quote this mean,
so only the table row moves).

## MINOR findings

1. **Misquoted replacement target in the addendum.**
   `2026-08-07-c880-manuscript-wording.md` lines 485–491 say Draft 2's last
   sentence "currently reads: Between that and \(3n^2-23n+45\)…", but Draft 2
   (line 147) reads "Against \(3n^2-23n+45\) the ratio tends to \(4.87\)…".
   An editor applying the addendum by search will not find the quoted text.
   Repair: fix the quotation to "Against …" (the replacement text itself can
   keep "Between that and").

2. **Wrong decimal in the promoting note.** Line 164–165:
   "\(1/H(1/4)=1.23266\ldots\)" — the true value is \(1.232623\ldots\)
   (\(H(1/4)=0.8112781\ldots\)). The conclusion ("1.2326 is truncated, not
   rounded, so the inequality stays valid") survives, but the stated digits
   are wrong. Repair: \(1.23262\ldots\).

3. **Draft 5 is not self-contained.** Promotion item 1 (line 464) says
   "Drafts 1, 4 and 5 are self-contained and can go in as they stand", but
   Draft 5's replacement text (line 277–278) contains
   "by Remark~\ref{rem:six-point-witness}", a label defined only by Draft 3.
   Taking Drafts 1, 4, 5 without Draft 3 leaves an undefined reference.
   Repair: move Draft 5 to the item-2 group, or make its cross-reference
   conditional on Draft 3.

4. **Kummerfeld–Ramsey cost description is slightly off its source.** Draft 2,
   line 154: "spends one statistical test per quartet of observed variables".
   The tetrad screen's verbatim quotation says each quartet "requires testing
   2 of the 3 possible vanishing tetrad constraints" — one *bit* per quartet,
   two statistical tests. Repair: "spends one coherence bit per quartet …,
   each decided by a pair of statistical tests" or "a constant number of
   statistical tests per quartet".

5. **The mechanism sentence in the drafted addendum covers only one of the
   lemma's two cases.** Lines 500–502: "because a test one of whose two
   conditions is already known reads as a single bit". That is the root-test
   case (\(\beta_b=0\)); the other case uses an outer test whose two
   conditions are *forced to agree*, neither being known. Repair: "…a test
   one of whose two conditions is already decided — known to hold, or known
   to agree with the other — reads as a single bit", or state both cases.

6. **\(H(\tau)\) mislabeled in Draft 2's display.** Lines 143–144:
   "\(\binom{n-1}{2}-1=H(\tau)\le\sum_iH(A_i)\)". For uniform \(\tau\),
   \(H(\tau)=\binom{n-1}2\); the quantity \(\binom{n-1}2-1\) is the entropy of
   the complement *pair* (the object the answers determine). As printed the
   equality is false. Repair: write \(H(\{\tau,\bar\tau\})\) or "the entropy
   of the complement pair". (Same slip exists in
   `2026-08-07-c880-alignment-separation.md` §5, outside this review's scope
   but the source of the copy.)

7. **Ambiguous antecedent in Draft 4.** Lines 236–239: "The sharpness is a
   separate statement from theirs: their \(v\ge7\)…" follows a sentence about
   Pouzet–Si Kaddour (hypergraphs), but "theirs" means Dammak–Lopez–Pouzet–Si
   Kaddour (graphs). Repair: name them ("from Dammak, Lopez, Pouzet, and Si
   Kaddour's").

8. **Draft 7's insertion point splits a paragraph.** "Appends … after line
   67" of `sections/08-verification.tex`: line 67 ends "not as a procedure."
   but line 68 continues the same paragraph ("Coherence of the outer
   six-family…"). Inserting a new paragraph there separates the human-proof
   list from its lead-in. Repair: insert after line 71 (end of that
   paragraph), or direct the promoting task to make the split deliberate.

9. **"The first six points carry a monochromatic graph" is loose.** Decoder
   report lines 36–37 and §4: the exceptional class is defined by the rooted
   representative's graph on points \(1,\dots,6\) being empty or complete —
   equivalently, the restriction of the two-graph to \(\{0,\dots,6\}\) being
   trivial. "First six points" miscounts the root. Repair: one clause naming
   the representative, as the Conventions section already sets it up.

## NITs

1. Report line 255, "an oracle that counts its calls and cannot be read
   otherwise": the privacy is by inspection (single-module Rust; `Oracle.g`
   is technically accessible), not enforced. "and is not otherwise consulted"
   is the defensible phrasing. I verified by reading every call site that
   `decode` touches only `ask` and `count`.
2. Draft 8 appends to a `\begin{thebibliography}{9}` whose width argument is
   already wrong for a two-digit entry count; when touching the file, widen to
   `{99}`.
3. Draft 8's entries abbreviate journal names ("J. Algebra", "Linear Algebra
   Appl.") and use bare `doi:` text, where the existing entries spell journals
   out and wrap DOIs in `\href`. Harmonize when promoting.
4. Draft 2's first paragraph and the existing "The same statement in principal
   minors" paragraph (05-golden-operator.tex lines 357–370, Draft 5's target)
   both explain that order-three data trivializes the problem. Not a
   contradiction, but the promoting task should merge or trim one telling.
5. Draft 3, "and not merely because" — the style guide flags the "not merely
   X" reflex; "and not only because" says the same thing without it.
6. Draft 9's boundary cell, "Brunel owns the cycle-basis algorithm whose
   Seidel specialization costs \(\binom n2-n+1\) order-three minors": the
   Seidel specialization is the audit's own marked computation, not Brunel's.
   Split the clause ("Brunel owns the cycle-basis algorithm; its Seidel
   specialization, computed in the audit, costs …").
7. The greedy-bootstrap comparison numbers (worst 9, mean 5.32; report line
   158–159) have no artifact in the table. I re-ran the `bootstrap` mode:
   worst 9, mean 5.316833 — the claim is right, but if it stays in the report
   it should have a certificate row like everything else.

## What was verified independently

**Mathematics, derived from scratch.**
- Both test identities of §1 (root and outer), from
  \(\tau(0ij)=e_{ij}\), \(\tau(ijk)=e_{ij}+e_{ik}+e_{jk}\), including the
  two-independent-conditions structure and the exact yes-probability \(1/4\).
- The attachment lemma and its proof, including that
  \(\beta_b=\beta_c\iff\) the outer test's two conditions coincide, the
  \(|R|=2\) case, the disjointness of the four points in every issued test,
  and full complement-equivariance of every post-core step (both test shapes,
  the \(\beta\) computation, the case selection, and the bootstrap predictor
  are invariant under complementing the held graph and the unknowns
  together).
- The bootstrap completeness argument: two candidates with equal helper graph
  give distinct, non-complementary seven-point two-graphs (equal ten-bit
  helper part rules out the complement), all fifteen tests avoiding \(v\) are
  determined by the helper graph, so `thm:aligned-faithfulness` forces a
  difference among the twenty through \(v\). The invocation is legitimate,
  not circular: the theorem is proved independently of the decoder.
- The summations: \(22+\sum_{v=7}^{n-1}(v+1)=\binom n2+n-6\) and
  \(22+\sum_{v=7}^{n-1}(v+3)=\binom n2+3n-20\); the per-attachment count
  \(7+(v-6)\); window width \(2n-6\); \(\binom{n-1}2-1=\binom n2-n\);
  \(1+4(n-4)+6\binom{n-4}2=3n^2-23n+45\) and its values 31, 53, 201, 785,
  3925; \(H(1/4)=0.811278\), \(1/H(1/4)=1.232623\),
  \(\lceil5/H(1/4)\rceil=7\) as arithmetic; the floor values 17.26, 24.65,
  66.56, 209.55, 912.14; the thresholds (147 vs 146.68 at \(n=17\), 165 vs
  166.40 at \(n=18\); 572 vs 571.94 at \(n=32\), 607 vs 610.15 at \(n=33\));
  the ratio limits 6 and 4.87.
- Every cell of the report's §4 table against the certificates, and the
  proved/sampled split (sampled columns are exhaustive at 7 and 8, maxima of
  5000 seeds at 12/20/40 and correctly presented as lower bounds on the worst
  case).
- The six-point witness of Draft 3 by hand: both graphs give aligned family
  exactly \(\{\{0,1,2,5\},\{0,1,3,4\}\}\), and \(H\) is neither \(G\) nor its
  complement \(\{13,14,23,34,45\}\).
- Draft 3's justification: 05-golden-operator.tex line 369 does assert "six
  are not [enough]" and nothing in the paper or the Lean coverage summary
  (08-verification.tex) proves it.

**Code, read line by line.** The oracle counts every query (single `ask`
path); `decode` never reads the hidden graph (its local `g` shadows the
truth); the exhaustive modes cover exactly \(2^{10}\) helper codes,
\(2^{15}\) six-point graphs, \(2^{15}\) and \(2^{21}\) instances; the minimax
`BootOpt` is an exact game solve with memoization; leaf = singleton posterior
for `want=5`; the correctness check `same_up_to_complement` runs outside the
decoder on every instance and aborts on mismatch.

**Computation replayed** (`rustc 1.93.1`, `rustc -O`, scratch under
`/tmp/claude-1000/…/c880rev`): all eleven SHA-256 hashes and byte counts in
the report's artifact table match the files on disk; `core`, `bootopt`,
`helperchoice`, `verify7`, `trivial`, `predict`, `sample12`, `sample20`,
`sample40` reproduce **byte-identically**; `verify --n 8` reproduces every
field except the mean (MAJOR 4, stale-provenance variant identified
byte-exactly); the uncertified greedy-bootstrap comparison reproduces
(worst 9, mean 5.32).

**TeX cross-checks.** All four "replaces"/"currently" quotations against the
live sources are verbatim (Draft 1 main and optional, Draft 4, Draft 5;
Draft 7's anchor line 67 text confirmed) — the one misquotation is internal
to the wording file (MINOR 1). `theorem` and `remark` environments exist in
`clebsch_passages.tex` (`remark` numbered with `theorem`); `amsmath` is
loaded, so `\tbinom` and `\text` resolve; the five new bibliography keys are
genuinely new, the three reused keys exist, and every `\cite` in the drafts
resolves to an existing or Draft-8 key; `rem:six-point-witness` is defined
before its uses in reading order (but see MINOR 3 for the subset issue). The
five audit/screen constraints are discharged in the drafted text where the
table says they are: the order-four indicator restriction (Draft 1 final
clause, Draft 2 ¶1), Greaves–Suda as citation with Table 1/Example 2.3
(Drafts 1, 5, matching the audit's read record), the entropy bound as an
application of the standard search-theory bound (Draft 2 ¶2), Kummerfeld–
Ramsey named with no relative-cost claim (Draft 2 ¶3, "not compared here"),
and "removable without losing separation" spelled out with "nonredundant"
absent from every draft. No draft contains "first", "new", or an unqualified
priority claim; novelty wording sits only in the Draft 9 ledger cells, which
match the audit's boundaries and access-gap list.

## What could not be checked, and why

- **Primary sources behind the citations.** Greaves–Suda Table 1/Example 2.3,
  the Rising–Kulesza–Taskar optimality sentence, Holtz–Sturmfels Theorem 6,
  Brunel's cycle-basis algorithm, and the Kummerfeld–Ramsey complexity
  sentence were checked against the audit's and screen's verbatim quotations
  and read-depth records, not against the papers; no literature fetching was
  done in this review. The Draft 8 bibliographic details (volumes, pages,
  DOIs) likewise rest on the audit's records.
- **The seven/eight-point nonadaptive facts quoted by Drafts 6 and 7** (exact
  minimum 30, the 56-family orbit description, the 44 upper and 30 lower
  bound at eight points, the six-point census 96/6): these are certified by
  the separation lane's own artifacts
  (`2026-08-07-c880-alignment-separation-*.json`,
  `2026-08-07-c880-mask-ilp-bound.md`) and were not re-run here; this review
  re-ran only the adaptive-decoder generator. The six-point *witness pair*
  was re-verified by hand (it is in the drafted manuscript text); the census
  counts were not.
- **The core's cross-program confirmation** (depth 22 and mean 15.61 from
  `2026-08-07-c880-alignment-separation.rs`'s adaptive mode) was accepted
  from that lane's certificate `…-adaptive7.json` as quoted; the numbers
  agree with the exhaustive `verify7` replay done here, which is itself an
  independent execution of the claim.
- **Compilation of the drafted TeX** was checked by inspection (environments,
  macros, labels, keys), not by a LaTeX build, since applying the drafts to
  `papers/` is out of bounds for this review.

---

# Second pass, 2026-08-07 — verification of the repairs (commit 792c6264)

The first-pass text above is unchanged. This pass re-referees the repaired
deliverables as fresh work: the strengthened decoder (helper five chosen to
carry a known edge and a known non-edge), its new single bound
\(\binom n2+n-4\) and threshold \(n\ge19\), the regenerated certificates, the
revised drafted TeX, and the rewritten task card
`notes/clebsch-tasks/c880-aligned-query-complexity.md`.

## Second-pass verdict

All four MAJOR findings are repaired — the first two by strengthening the
decoder rather than weakening the claim, and the new mathematics is sound: I
re-derived the one-expensive-stage argument and the bound, hunted the helper
selection for edge cases without finding one, recomputed the \(n\ge19\)
threshold, and reproduced every one of the eleven certificates byte-identically
from the committed generator. No unfixed or new MAJOR remains. Three new MINOR
defects and four NITs were found, all prose or comment level, none touching a
bound: one sentence in the decoder report misstates its own degenerate
certificate (which says `worst_constant_pattern: 8`, not 4) and draws a false
"stays monochromatic" conclusion; the Reproduction header still carries the
old generator hash; and the task card's one-paragraph summary of the bootstrap
is wrong in a way the report itself corrects.

## The new mathematics, judged on its own merits

**Helper selection (the load-bearing change).** The code scans all pairs of
\(\{1,\dots,v-1\}\) in lexicographic order for the first known edge and first
known non-edge; if both exist it takes the union of their endpoints (3 or 4
points; the two pairs cannot coincide) and pads with the smallest unused
points to five; otherwise it takes \(\{1,\dots,5\}\). Edge cases checked: the
graph on \(\{1,\dots,v-1\}\) is fully known at stage \(v\) (edges are written
exactly once, and every pair scanned is already decided); \(v\ge7\) gives at
least six candidates, so the padding always reaches exactly five and
`copy_from_slice` cannot panic; shared endpoints between the two pairs only
shrink the union; sorting the set is harmless because both witness pairs lie
inside it, so `code_of` reads a configuration with at least one 1-bit and one
0-bit — non-monochromatic — whenever the known graph has both values. Cost 7
then follows from the `bootopt` certificate (maximum 7 over the 1022
non-monochromatic codes; the two 9s are codes 0 and 1023). **No counterexample
found; the selection does what the report claims.**

**At most one stage pays 9.** Verified as implemented. Monochromatic helper
code at stage \(v\) occurs iff \(G|_{\{1,\dots,v-1\}}\) is monochromatic
(value \(m\) in the decoder's gauge, and monochromaticity is
complement-invariant). If the truth's helper pattern (decoder gauge) is
\(\equiv m\), the bootstrap walks the matching rows of the `degenerate`
certificate — (code 0, pattern 0) and (code 1023, pattern 31), both cost 4. If
it is not \(\equiv m\), the stage costs at most 9 (the `bootopt` maximum), and
the newly written helper edges give the known graph both values, which no
later write can undo — so every later stage is non-monochromatic and costs 7.
Hence at most one stage per instance exceeds \(7+(v-6)\), by at most 2, which
is exactly the \(+2\) the bound charges. Airtight.

**The bound and the threshold, re-derived.**
\(22+\sum_{v=7}^{n-1}(7+(v-6))+2 = 24+\bigl(\tfrac{n(n+1)}2-28\bigr)
=\binom n2+n-4\), for **every** instance; window against the leaf-count bound
\(\binom n2-n\) is \(2n-4\). Against the nonadaptive floor
\((\binom{n-1}2-1)/H(1/4)\) with \(1/H(1/4)=1.232623\ldots\): at \(n=18\),
\(167>166.404\) (correctly left open); at \(n=19\), \(186<187.359\), and the
quadratic gap grows monotonically from there, so "below the floor for every
\(n\ge19\)" is right. All five table rows match the regenerated `predict`
certificate (24, 32, 74, 206, 816) and the observed column matches the
verify/sample certificates (22, 30, 69, 195, 782); the \(n=7\) and \(n=8\)
rows are correctly labeled as bounds that are not tight there.

**Replay.** Rebuilt the committed generator (SHA-256 `7806795…` confirmed on
disk, `rustc 1.93.1`) and re-ran every mode: `core`, `bootopt`, `degenerate`,
`bootstrap`, `trivial`, `predict` (with `--boot-max 7 --switch 2`),
`verify --n 7`, `verify --n 8`, and the three samples at \(n=12,20,40\).
**All eleven certificates reproduce byte-identically**, and all twelve
SHA-256/byte entries in the artifact table match the files on disk. Nothing
was skipped this pass.

## Per-finding closure

| First-pass finding | Grade | Evidence |
|---|---|---|
| MAJOR 1 — "\(n\ge18\)" separation unproved | **Fixed** | Repaired by strengthening the decoder: single all-instance bound \(\binom n2+n-4\); separation now claimed for \(n\ge19\) and proved (recomputed above); \(8\le n\le18\) explicitly open (report items 5, §4–§5; card). |
| MAJOR 2 — drafted TeX unconditional count | **Fixed** | Addendum replacement now reads "for \(n\geq19\) such a decoder does better than any fixed family can: … costs at most \(\binom n2+n-4\) tests" — every-instance true, threshold correct; the "should not say" guard now says \(n\ge19\) with \(8\le n\le18\) open. |
| MAJOR 3 — invalid entropy floor | **Partly fixed** | Both report passages rewritten correctly (minimax-computed optimum; the chain rule licenses only \(d\ge6\); "do not reinstate" recorded on the card); the independent-replay section now truthfully says 7, 9 and 4 rest on this program alone. **Residue:** the committed generator still asserts the withdrawn claim in a comment — `2026-08-07-c880-adaptive-decoder.rs` line 398, "The information-theoretic floor is 7…". Downgraded to MINOR (new finding 3 below). |
| MAJOR 4 — stale `verify8.json` | **Fixed** | Regenerated; my independent replay of `verify --n 8` from the committed source is byte-identical (mean 22.052189); the report records the catch at the foot of its artifact table. |
| MINOR 1 — addendum misquote | **Fixed** | Quote now matches Draft 2's closing sentence verbatim, including the line break. |
| MINOR 2 — \(1.23266\) | **Fixed** | Note now reads \(0.8112781\ldots\) and \(1.232623\ldots\). |
| MINOR 3 — Draft 5 "self-contained" | **Fixed** | Promotion item 1 now names Draft 5's dependence on Draft 3's label. |
| MINOR 4 — one test per quartet | **Fixed** | Now "one coherence bit per quartet …, each by a pair of statistical tests on sampled data" (residual antecedent nit below). |
| MINOR 5 — one-case mechanism sentence | **Fixed** in the drafted TeX ("already decided — known to hold, or known to agree with the other"); the task card still carries the old one-case phrasing (folded into new finding 4). |
| MINOR 6 — \(H(\tau)\) mislabel | **Fixed** | Draft 2 now applies subadditivity "to the entropy \(\binom{n-1}2-1\) of the complement pair, which is what the answers determine", and the display drops the false equality. |
| MINOR 7 — ambiguous "theirs" | **Fixed** | Draft 4 names Dammak, Lopez, Pouzet, and Si Kaddour. |
| MINOR 8 — Draft 7 insertion point | **Fixed** | Now "after line 71, which ends the paragraph"; verified against the source (line 71 does end it). |
| MINOR 9 — "first six points" | **Fixed/moot** | The wording vanished with the redesign; the report now defines the state by \(G|_K\) monochromatic. |
| NIT 1 — "cannot be read otherwise" | **Fixed** ("is not otherwise consulted"). |
| NIT 2–4 — bibliography width, style, duplication | **Fixed** | The "Three mechanical points" paragraph after Draft 8 instructs the promoter on all three. |
| NIT 5 — "not merely" | **Fixed** ("and not only because"). |
| NIT 6 — Brunel clause | **Fixed** | The ledger row now marks the Seidel specialization as "computed in the audit rather than stated there". |
| NIT 7 — uncertified greedy 5.32 | **Fixed** | `bootstrap-greedy.json` is in the artifact table and reproduces (worst 9, mean 5.316833). |

## New findings, second pass

**NEW MINOR 1 — the report misstates its own degenerate certificate, and
draws a false "stays monochromatic" conclusion.**
`notes/2026-08-07-c880-adaptive-decoder.md` lines 165–168: "If \(G|_K\) is
monochromatic and the new point's edges into \(H\) all take the same value as
the known edges, then \(G|_{K\cup\{v\}}\) is again monochromatic and the stage
costs 4, measured over both monochromatic configurations and both constant
patterns." Two defects. (i) The conclusion is false as stated: the hypothesis
constrains only the five helper edges, while \(G|_{K\cup\{v\}}\) also contains
the edges from \(v\) to \(K\setminus H\), learned in the lemma phase and
unconstrained — the monochromatic state can end through them at a cost-4
stage. (ii) "measured over both monochromatic configurations and both
constant patterns" contradicts the certificate: `degenerate` reports
`worst_constant_pattern: 8`, because the mismatched combinations (code 0 with
pattern 31, code 1023 with pattern 0) cost 8; the 4 is the maximum over the
two *matching* rows only. The bound is unaffected — mismatched-constant stages
are exit stages and sit under the \(\le9\) charge, which is how I verified the
accounting above — but the sentence must be repaired, e.g.: "…the bootstrap
costs 4 — the two matching rows of the degenerate certificate — and at most 9
otherwise, in which case the helper edges leave the known graph
non-monochromatic and every later stage costs 7." The same false biconditional
lives in the generator's degenerate-mode comment
(`2026-08-07-c880-adaptive-decoder.rs` lines 866–869, "stays monochromatic
after attaching v exactly when the pattern u is constant") — wrong on both
constant-versus-matching and \(H\)-versus-\(K\).

**NEW MINOR 2 — stale generator hash in the Reproduction header.**
`notes/2026-08-07-c880-adaptive-decoder.md` lines 248–249 still name the
generator by the superseded SHA-256 `d98cccc7…`, while the artifact table
(line 282) and the file on disk have `78067954…`. The header is the sentence a
replayer reads first, and it currently contradicts the table two paragraphs
below it. Repair: update the header hash.

**NEW MINOR 3 — the withdrawn entropy-floor claim survives as a code
comment.** `notes/2026-08-07-c880-adaptive-decoder.rs` line 398: "The
information-theoretic floor is 7, since each test answers yes with probability
1/4 and five bits are wanted." This is exactly the argument the report now
withdraws (and the card forbids reinstating). MAJOR 3's repair listed the code
comment; it was not done. Repair: replace with "The value 7 is the exact
minimax optimum over the non-monochromatic codes; entropy licenses only 6
here."

**NEW MINOR 4 — the task card's bootstrap summary is wrong in two clauses.**
`notes/clebsch-tasks/c880-aligned-query-complexity.md` lines 108–110: "because
a test one of whose two conditions is already known reads as a single bit"
(the one-case phrasing the drafted TeX already fixed), and "The bootstrap
costs seven tests per point, which exact minimax play shows optimal for every
helper configuration the decoder can be made to meet" — false: the decoder
can be made to meet the monochromatic configurations (whenever the known
graph is monochromatic), where the stage costs 4 or up to 9, and minimax
optimality of 7 is a statement about the non-monochromatic codes. Repair:
"…costs seven tests per point outside the monochromatic state, optimal there
by exact minimax; the monochromatic stages cost 4, except at most one per
instance at 9."

**NEW NIT 1.** Report line 275: "`bootopt` and `helperchoice` are exhaustive
over their whole configuration space" — the `helperchoice` mode no longer
exists; say "`bootopt`, `degenerate` and `bootstrap`".

**NEW NIT 2.** Card lines 27–31: the em-dash insertion splices the sentence so
that "beating the counting bound by a factor 1.2326" grammatically attaches to
the *adaptive* floor ("whose floor stays the counting bound, beating the
counting bound…"), a self-contradiction; the clause describes the entropy
floor. Split the sentence.

**NEW NIT 3.** Draft 2, third paragraph: after the repair, "That test decides
whether covariance minors vanish…" has lost its antecedent (the preceding
sentence now speaks of a coherence *bit* decided by a *pair* of tests). "That
bit reports whether…" restores it.

**NEW NIT 4.** Report §3's repaired paragraph is correct about what the
entropy argument gives (\(d\ge6\)) but states it without noting the first-test
step (\(5\le H(1/4)+(d-1)\)) only holds because the *first* query's marginal
is exactly \(1/4\); a one-clause justification would keep a referee from
re-deriving it. Optional.

## The task card, read cold

The five open items are actionable without this conversation. Item 1 names
the two replay routes and the exact modes, and correctly quarantines the
invalid entropy argument. Item 2's feasibility split (\(2^{28}\) instances at
\(n=9\) feasible, \(2^{36}\) at \(n=10\) not) is arithmetically right, and the
two named alternatives (exact minimax core tree; tighter \(+2\) accounting)
are real. Item 3 correctly records why the mask route is capped at 30 and
what remains. Items 4 and 5 match the reports; the wording-handoff
preconditions match the wording doc's own list (Draft 6 and Draft 7's second
sentence need the artifact migration). Referenced files all exist, including
`2026-08-07-c880-framing-review.md` and `2026-08-07-c880-mask-ilp-bound.md`.
Stale or contradicted content found: only the two clauses of NEW MINOR 4 and
the splice of NEW NIT 2; the acceptance section's met/not-met split is
accurate, including the frank line that the bootstrap constants have no
independent replay.

## Second-pass verification summary

Verified independently this pass: the helper-selection code path (all edge
cases listed above), the monotone-growth and one-expensive-stage argument as
implemented, the bound summation and the \(n\ge19\)/open-\(n=18\) threshold
arithmetic, all table rows against certificates, the verbatim addendum quote,
the retired-number sweep (`n-6`, `3n-20`, `n=18` and `n=33` as thresholds,
`21.927124`, `789`, `1.23266`, the entropy floor of 7 — all gone from the
three files except as corrective statements), and the full byte-identical
replay of all eleven certificates with all twelve hash-table entries checked.
Not checked, as before: the primary literature behind the citations, the
separation lane's own certificates, and a LaTeX build of the drafts.

Unfixed or newly found MAJOR findings: **none**.
