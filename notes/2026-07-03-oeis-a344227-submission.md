# OEIS A344227 extension — ready-to-paste submission package (2026-07-03)

**Purpose**: extend OEIS **A344227** (Sprague-Grundy / nimber values of the Non-Attacking
Queens game = Node-Kayles on the queen graph), catalogued only through n = 13, with the new
computed terms **G(14) = 0, G(15) = 1, G(16) = 0**, plus a hold-slot for **G(17)** (run in
flight, expected to pin the value — predicted 1 — within days).

**Author of the new terms**: Tavis Rudd. **Extension date used below**: Jul 03 2026 (adjust to
the actual submission date before pasting).

**Provenance of the data**: the heap-sum nimber engine in this repo
(`rust/src/queens/solver/nimber.rs` + `rust/src/queens/dense.rs`); method + validation chain in
[notes/handoffs/2026-07-01-queens-nimber-a344227.md](handoffs/2026-07-01-queens-nimber-a344227.md).
Submission rationale in [notes/2026-07-03-connections-deep-dive.md §3.1](2026-07-03-connections-deep-dive.md).
n = 18 outcome + Jenrich citation phrasing from [notes/queens-n18-paper.md](queens-n18-paper.md) §Abstract/§1.

**Status of this note**: DRAFT package. Every item that rests on an unverified external fact or
on the in-flight G(17) run is tagged **ASSUMED-VERIFY-BEFORE-SUBMIT**; a consolidated list of
those tags is at the end.

---

## 1. Current A344227 entry (fetched live, 2026-07-03)

Fetched via `curl -sL -A "Mozilla/5.0" "https://oeis.org/search?q=id:A344227&fmt=text"`
(the plain `oeis.org/A344227` page 403s WebFetch; the search endpoint returned the record).
**Revision at fetch: #54, dated May 27 2025.** Edit from that revision so the submitter starts
from current state.

Exact existing fields (verbatim, internal OEIS `%`-line format):

```
%I A344227 #54 May 27 2025 06:24:57
%S A344227 0,1,1,2,1,3,1,2,3,1,0,1,0,1
%N A344227 Sprague-Grundy value for the Node-Kayles game played on the n-queens graph.
%C A344227 This game is also known as the Non-Attacking Queens game. Rules: two players successively place queens on an n X n chessboard such that the queens do not attack each other. The last player to place a queen wins.
%C A344227 Empirically, it appears that after the 9th term, the sequence oscillates between 1 and 0.
%C A344227 The n-queens graph considered here is not vertex-transitive. However, the toroidal version is and for Node-Kayles played on graphs that are vertex-transitive, it can be proven that the Sprague-Grundy value must be either 0 or 1.
%C A344227 Proof: [vertex-transitive 0/1 argument, four lines]
%D A344227 G. Schrage, The eight queens problem as a strategy game, Int. J. Math. Educ. Sci. Technol. 17 (1989) 143-148.
%H A344227 Matthew Bardoe, <a href="https://github.com/mbardoe/NonAttackingQueens">Non-Attacking Queens implementation in Python on Torus and non-Torus Chessboards</a>.
%H A344227 Max Fan, <a href="https://github.com/InnovativeInventor/node-kayles">Generalized Node-Kayles calculator implemented in Rust</a> (terms 0 and terms 11-13 from Max Fan).
%H A344227 H. Noon, <a href="...noon2002.pdf">Surreal Numbers and the N-Queens Game</a>, Bennington College, 2002.
%H A344227 H. Noon and G. Brummelen, <a href="...noon55524.pdf">The Non-Attacking Queens Game</a>, The College Mathematics Journal 224 (2006), 223-227 (terms 1-10 from H. Noon).
%o A344227 (Rust) // See Fan link.
%o A344227 (Haskell) [naive mex recursion, ~8 lines]
%Y A344227 Cf. A000170, A002562, A036464, A316533, A316632, A316781, A002186.
%K A344227 more,nonn
%O A344227 0,4
%A A344227 _Max Fan_ and Matthew K. Bardoe, May 13 2021
```

Key fixed fields the extension must respect:

| field         | value                                                                    |
|---------------|--------------------------------------------------------------------------|
| offset (`%O`) | `0,4` — first index is 0; the `4` = position of first term with abs > 1 (a(3)=2). **Unchanged by the extension** (a(3) is still the first term > 1). |
| keywords      | `more,nonn` — keep `nonn` (all terms >= 0); `more` may stay (still open). |
| name (`%N`)   | unchanged.                                                               |
| author (`%A`) | unchanged — Max Fan and Matthew K. Bardoe. New terms credited via `%E`.  |
| indexing      | offset 0 ⇒ a(n) is the value on the n X n board; a(0)=0 is the empty board. |

---

## 2. Consistency check — our terms vs the existing entry

The existing 14 terms (indices 0..13) and their mapping to board size n:

| n  | a(n) existing | our engine (n <= 13) | match |
|----|---------------|----------------------|-------|
| 0  | 0             | 0                    | yes   |
| 1  | 1             | 1                    | yes   |
| 2  | 1             | 1                    | yes   |
| 3  | 2             | 2                    | yes   |
| 4  | 1             | 1                    | yes   |
| 5  | 3             | 3                    | yes   |
| 6  | 1             | 1                    | yes   |
| 7  | 2             | 2                    | yes   |
| 8  | 3             | 3                    | yes   |
| 9  | 1             | 1                    | yes   |
| 10 | 0             | 0                    | yes   |
| 11 | 1             | 1                    | yes   |
| 12 | 0             | 0                    | yes   |
| 13 | 1             | 1                    | yes   |

Our engine reproduces every catalogued term. Basis (from the handoff's validation chain):

- the engine's whole-DAG mex reference matches the independent full-mex `Nimber` for n <= 8;
- the CLI `queens nimber n` matches A344227 exactly for n = 1..13 (unit test
  `nimber_sum_matches_full_mex_and_oeis` plus direct runs, n = 13 in 0.56 s);
- the `GrundyW8` dense leaf tables are validated two ways — against a pure scalar mex recursion
  (exhaustive k <= 6, sampled k = 7, 8) and against the independently built boolean win/loss
  tables (G != 0 iff a win);
- the new terms n = 14 and n = 16 independently equal the production boolean win/loss verdicts
  (G = 0 iff second-player win, by definition), and n = 15 was reproduced under a different leaf
  boundary (`QUEENS_NIMBER_GK`), exercising different code paths, with the same G.

Conclusion: the new terms are consistent with the existing entry on the full overlap and are
cross-validated by construction. No conflict; the extension only appends indices 14, 15, 16
(and, pending, 17).

---

## 3. Extended term list (`%S` / DATA)

New terms appended at indices 14, 15, 16:

```
%S A344227 0,1,1,2,1,3,1,2,3,1,0,1,0,1,0,1,0
%O A344227 0,4
```

- Full sequence, offset 0: `0, 1, 1, 2, 1, 3, 1, 2, 3, 1, 0, 1, 0, 1, 0, 1, 0`
- The three appended values are `a(14)=0, a(15)=1, a(16)=0`.
- OEIS auto-wraps DATA across `%S`/`%T`/`%U`; the editor pastes one comma-separated list into
  the DATA box. 17 terms fit on `%S` alone, but let the editor rewrap.
- Offset `%O` stays `0,4` (a(3)=2 is still the first term with absolute value > 1).

---

## 4. b-file — `b344227.txt` (offset-aligned, ready to paste)

Each line is `n a(n)`, one term per line, starting at the offset (n = 0). This is the complete
b-file including the existing terms (OEIS wants the b-file to cover the full range, not just the
new tail). Upload as `b344227.txt`.

```
# A344227 Sprague-Grundy value for the Node-Kayles game played on the n-queens graph.
# Terms a(0)..a(13) from Max Fan / H. Noon (original entry); a(14)-a(16) from Tavis Rudd, Jul 03 2026.
0 0
1 1
2 1
3 2
4 1
5 3
6 1
7 2
8 3
9 1
10 0
11 1
12 0
13 1
14 0
15 1
16 0
```

Notes:
- OEIS b-file convention: the leading `#` comment lines are optional but conventional; the first
  data line's index must equal the offset (0). Verified aligned: line `n v` gives a(n) = v.
- Do not include blank lines or trailing spaces; OEIS validates b-files strictly.
- If the DATA line already lists all terms that appear in the b-file, that is fine — the b-file
  simply carries the authoritative full list.

---

## 5. Proposed COMMENTS (`%C`) additions

Two new comment paragraphs. OEIS comment style: terse, present tense, no first person; a
substantive contributed comment is signed `- Name, Date`. Use `X` for the multiplication sign
and spell out symbols the OEIS text layer mangles.

### (i) Method note — heap-sum equivalence

```
%C A344227 a(14) onward are computed by a heap-sum reduction rather than by direct mex evaluation. By the Sprague-Grundy theorem, G(board) = k iff the disjunctive sum of the board with a single Nim-heap of size k is a P-position (a second-player win), since G(board) XOR k = 0 exactly when k = G(board). Deciding whether board + Nim-heap(k) is a P-position is an ordinary alpha-beta win/loss search, which (unlike a direct mex, that must expand every child) admits cutoffs; solving it for k = 0, 1, 2, ... and taking the first k whose round is a loss for the player to move yields G(board) = k. - Tavis Rudd, Jul 03 2026
```

### (ii) The n = 18 outcome remark (the conjecture breaks)

```
%C A344227 The empirical oscillation noted above (a(n) = 0 for even n and 1 for odd n, n >= 10) does not continue: the 18 X 18 game is a first-player win (an exhaustive search finds a winning opening at row 9, column 9, on the main diagonal), so a(18) is nonzero even though its exact nimber value is not yet computed. Hence the sequence is not eventually the period-2 word 0, 1, 0, 1, ... . - Tavis Rudd, Jul 03 2026
```

Wording rationale:
- (ii) states only what a win/loss solve establishes: a(18) != 0. It does **not** assert a value
  for a(18) (the nimber is still computing). This keeps the comment defensible.
- "at row 9, column 9" = the paper's witness opening I9 = (8,8) in 0-based row-major (square 152);
  stated 1-based to avoid an off-by-one in the OEIS text. Keep or drop the coordinate at the
  submitter's discretion — it adds a concrete verifiable anchor but is not required.
- **ASSUMED-VERIFY-BEFORE-SUBMIT**: comment (ii) rests on our unpublished n = 18 computation.
  OEIS reviewers routinely ask for a citable source on a claim like this (see §9). It is
  strongest paired with the LINKS entry in §6 (a public preprint/repo). If no public artifact
  exists at submission time, consider deferring (ii) to a follow-up edit once the arXiv preprint
  is posted, and submit the terms + method comment (i) first — the terms are the priority stamp.

---

## 6. Proposed EXTENSIONS (`%E`)

OEIS credits appended terms on an `%E` line:

```
%E A344227 a(14)-a(16) from _Tavis Rudd_, Jul 03 2026
```

- The `_Tavis Rudd_` underscore markup renders the name as an OEIS author link once the
  submitter's account name matches. If submitting under a different display name, adjust.
- If G(17) lands before submission, use the §8 variant line `a(14)-a(17) from _Tavis Rudd_, ...`.

---

## 7. Proposed LINKS (`%H`) additions

### 7.1 Jenrich (the n <= 16 win/loss determination) — NOT currently in the entry

The existing entry has no Jenrich link. Propose adding it — it is the standard citation for the
win/loss outcomes through n = 16 that the sign of a(10..16) agrees with, and it anchors the
n = 18 comment's context:

```
%H A344227 Thomas Jenrich, <a href="https://arxiv.org/abs/1312.5135">Successful strategies for a queens placing game on an n x n chess board</a>, arXiv:1312.5135 [math.CO], 2013.
```

- Title/author/date **VERIFIED** against arxiv.org this session: "Successful strategies for a
  queens placing game on an n x n chess board", Thomas Jenrich, submitted 2013-12-18 (v-online
  2014-04-21). (Note: our internal paper draft mis-cites this title as "A new winning strategy for
  the game of non-attacking queens" — use the verified title above, not the paper's string.)
- Jenrich's abstract confirms the win/loss outcomes our nimber signs agree with: first-player wins
  for n = 4, 6, 8 and odd n; second-player wins for n = 10, 12, 14, 16 (so a(10)=a(12)=a(14)=a(16)=0
  as P-positions). Jenrich reports outcomes, not nimbers, so this is corroboration/context, not a
  source for the nimber values themselves.

### 7.2 Our program / preprint — BLOCKED on a public artifact

**Problem**: `git remote -v` in this repo returns nothing — the queens solver / heap-sum nimber
engine is **not** published at any public URL. OEIS LINKS entries must point at a publicly
reachable artifact (the existing Rust/Python links are public GitHub repos). We therefore have
**no valid `%H` for our computation yet**. Options, in order of preference:

1. **Public code mirror (best analog to the existing entry).** Push a read-only mirror of the
   queens crate (or at least the nimber engine + dense-table builder + tests) to a public GitHub
   repo, then link it exactly as Max Fan's calculator is linked:
   ```
   %H A344227 Tavis Rudd, <a href="https://github.com/OWNER/REPO">Heap-sum Sprague-Grundy engine for the Non-Attacking Queens game (computes A344227)</a>.
   ```
   This is the strongest verifiability answer for reviewers (they can run it). **ASSUMED: no such
   repo exists yet — must be created and made public before this line is valid.**
2. **arXiv preprint (in preparation).** The technical report [notes/queens-n18-paper.md] is a
   draft; once posted to arXiv, link it:
   ```
   %H A344227 Tavis Rudd, <a href="https://arxiv.org/abs/XXXX.XXXXX">Solving the Non-Attacking Queens game for n = 18 [title TBD]</a>, arXiv preprint, 2026.
   ```
   **ASSUMED: not yet posted; the arXiv id is a placeholder.**
3. **Submit terms without a new `%H` now, add the link in a follow-up edit.** OEIS accepts term
   extensions credited via `%E` without a fresh program link, provided the terms are plausible and
   the method is described in `%C`. This is viable for the **priority stamp** (per the deep-dive
   §3.1: "OEIS now, do not wait for the paper"). The cost: the n = 18 comment (§5 (ii)) is weaker
   without a citable source and may draw a reviewer request; consider holding (ii) for the
   follow-up edit that adds the artifact link.

### 7.3 Program field (`%o`) — optional method stub

The entry already carries a naive Haskell mex program (which reproduces n <= 13 but is far too
slow for n >= 14). Optionally add a one-line pointer to the heap-sum method so the DATA has a
described provenance even before the code link lands:

```
%o A344227 (Rust) // Heap-sum engine: G(board)=k iff board + Nim-heap(k) is a P-position; alpha-beta the sum for ascending k. See [Rudd link] once public.
```

Keep this only if the §7.2 option-1 or option-2 link is present or imminent; a `%o` that points
at nothing invites the same "where is it" review request as a missing `%H`.

---

## 8. "with G(17)" swap-in variant (hold until the run lands)

> **UPDATE 2026-07-04 — the run landed: G(17) = 2, NOT 1.** `queens nimber 17` reported
> k=0 WIN + k=1 WIN + k=2 LOSS ⇒ **a(17) = 2** (~585 B nodes / ~59 h; branch `queens-n18`,
> `QUEENS_TT_BITS=31`). This breaks odd→1 and misses the ~88% G=1 prediction. **STILL PENDING an
> independent-hash k=1 rerun** (collision gate) before submission — see the nimber handoff's
> Session 2026-07-04 note. The "predicted 1" text below is void; use **2** everywhere per the
> line-296 fallback (trailing DATA digit → 2, the `17 1` b-file line → `17 2`). The DATA/b-file
> blocks below are left showing the old `1` as a record of the prediction — do not paste them
> as-is.

**Do not paste this variant until the G(17) k=1 rerun confirms** (the original guard "k=0 WIN +
k=1 LOSS ⟹ G=1" is moot — k=1 was a WIN, k=2 the LOSS; G = 2). **ASSUMED-VERIFY-BEFORE-SUBMIT:
G(17) = 2 is computed but not yet independently revalidated.**

DATA line (~~predicted a(17) = 1~~ → actual a(17) = **2**):
```
%S A344227 0,1,1,2,1,3,1,2,3,1,0,1,0,1,0,1,0,2
```
Full sequence, offset 0: `0, 1, 1, 2, 1, 3, 1, 2, 3, 1, 0, 1, 0, 1, 0, 1, 0, 2`

b-file tail to append (after the `16 0` line in §4) — **actual value 2** (the `17 1` is the void prediction):
```
17 2
```

EXTENSIONS line:
```
%E A344227 a(14)-a(17) from _Tavis Rudd_, Jul 03 2026
```

b-file header credit line becomes:
```
# Terms a(0)..a(13) from Max Fan / H. Noon (original entry); a(14)-a(17) from Tavis Rudd, Jul 03 2026.
```

Offset unchanged (`0,4`). If G(17) turns out != 1, replace the trailing `1` in the DATA line, the
`17 1` b-file line's value, and keep the `a(14)-a(17)` credit.

---

## 9. Proposed CROSSREFS (`%Y`)

No change is required. The existing `Cf. A000170, A002562, A036464, A316533, A316632, A316781,
A002186` stands (A000170 = counts of n-queens solutions; the A316xxx block = related Node-Kayles
/ game-value sequences). Optional future additions, only if/when those sequences exist:

- a **torus-queens nimber** sequence (the vertex-transitive companion; `G(torus_n)` computed to
  n = 10 in this repo, a candidate new OEIS entry per the deep-dive T2). If submitted, cross-ref
  it here and vice versa. **Not yet in OEIS — do not add a dangling Cf.**
- an OEIS entry for the **win/loss outcome** of the queens game (first/second player), if one
  exists — a search did not surface one; do not invent an A-number.

---

## 10. Assembled diff — what changes in the entry (G(14)-G(16) version)

Paste-ready summary of every edit against revision #54. Lines marked `+` are added; `~` modified.

```
~ %S  0,1,1,2,1,3,1,2,3,1,0,1,0,1   ->   0,1,1,2,1,3,1,2,3,1,0,1,0,1,0,1,0
+ b344227.txt   (full b-file, indices 0..16; see section 4)
+ %C  a(14) onward are computed by a heap-sum reduction ...  - Tavis Rudd, Jul 03 2026     (section 5(i))
+ %C  The empirical oscillation noted above ... a(18) is nonzero ...  - Tavis Rudd, Jul 03 2026  (section 5(ii); hold if no source link)
+ %H  Thomas Jenrich, Successful strategies for a queens placing game ... arXiv:1312.5135      (section 7.1)
+ %H  Tavis Rudd, <public repo or arXiv preprint>   (section 7.2 — ONLY once a public URL exists)
+ %E  a(14)-a(16) from _Tavis Rudd_, Jul 03 2026                                              (section 6)
  %O  0,4    (unchanged)
  %K  more,nonn   (unchanged; consider whether 'more' still applies after the extension)
  %Y  unchanged
```

The **minimum viable priority-stamp submission** (per deep-dive §3.1, "OEIS now, don't wait for
the paper") is: the DATA extension + b-file + `%E` credit + method comment 5(i) + the Jenrich
`%H`. The n = 18 comment 5(ii) and the Rudd `%H` are the parts that need a public artifact and can
follow in a second edit.

---

## 11. Submitter checklist (for the human)

Step-by-step for a first-time or returning OEIS contributor:

1. **Account**: sign in at https://oeis.org (register if needed; new accounts may need approval
   before edits are accepted — do this a few days ahead if the account is new).
2. **Open the entry for editing**: go to https://oeis.org/A344227 , confirm it is still at
   revision #54 (or note the current revision), click **"edit"**. If the revision advanced since
   2026-07-03, re-diff against the new state before pasting (someone may have edited it).
3. **DATA**: replace the term list with the section 3 line
   `0,1,1,2,1,3,1,2,3,1,0,1,0,1,0,1,0`. Leave the offset `0,4` alone.
4. **b-file**: upload `b344227.txt` with the exact section 4 content (indices 0..16). OEIS
   validates it against the DATA line — they must agree on the overlap.
5. **COMMENTS**: add the method comment 5(i). Add the n = 18 comment 5(ii) **only if** you are
   also adding a citable source link this round (section 7.2); otherwise defer it.
6. **LINKS**: add the Jenrich `%H` (7.1). Add your own program/preprint `%H` (7.2) **only if a
   public URL exists** — otherwise leave it out and add it in a follow-up edit.
7. **EXTENSIONS**: add `a(14)-a(16) from _Tavis Rudd_, <submission date>` (section 6). Match the
   date to the actual day you submit.
8. **Keywords**: leave `nonn`; decide on `more` (it signals "more terms wanted" — reasonable to
   keep, since n >= 17 is still open).
9. **Save as a draft, then submit for review.** Add a short note in the edit's comment box:
   "Extending to a(16) via a heap-sum Sprague-Grundy engine; a(14)/a(16) also equal the
   production win/loss verdicts, a(15) reproduced under two leaf configs; n<=13 reproduced
   exactly. b-file attached."
10. **Respond to review.** Expect one or more editors to comment; answer promptly (see section 12).

### If the G(17) run lands first

Swap in the section 8 variant: DATA line ending `...,0,1`, b-file with a `17 1` line appended,
and `%E a(14)-a(17) from _Tavis Rudd_, <date>`. **Only after** the run reports k=0 WIN + k=1 LOSS
(value pinned). If it pins a value other than 1, substitute that value everywhere.

---

## 12. What reviewers push back on (game-value sequences) — and our answers

| likely reviewer concern                        | our answer / what to have ready                                            |
|------------------------------------------------|----------------------------------------------------------------------------|
| **Verifiability of the terms** — "how computed, can anyone reproduce?" | The method comment 5(i) describes the heap-sum reduction; the strongest answer is a **public code link** (7.2 option 1). The existing Haskell `%o` is a naive mex and cannot reach n >= 14 in practice, so it does **not** independently confirm the new terms — say so if asked, and point at the engine. |
| **Program availability** — OEIS prefers a runnable program for computed terms | Provide the public repo (7.2) or at minimum the method `%C` + a description precise enough to reimplement. Flag: no public repo exists yet — creating one materially strengthens the submission. |
| **Independent cross-check** of a(14..16)        | a(14), a(16) equal the production boolean win/loss verdicts (G=0 iff second wins); those outcomes match **Jenrich** (n=10,12,14,16 second-player) — cite the 7.1 link. a(15) reproduced under two leaf configs. n<=13 reproduced exactly vs the catalogued values. |
| **The n = 18 comment** — "unpublished claim"    | It asserts only a(18) != 0 (a win/loss fact), not a value. Still, expect a request for a citable source; pair it with a preprint/repo link or defer it to a follow-up edit. |
| **Offset / indexing correctness**               | Offset stays `0,4`; a(n) is the value on the n X n board; b-file index 0 = offset. Double-checked in section 1. |
| **Keyword hygiene** (`more`, `nonn`)            | `nonn` holds (all terms >= 0). `more` stays until the sequence is closed. Do not add `hard`/`nice` unless an editor requests. |
| **Author credit form**                          | Terms credited via `%E` to _Tavis Rudd_; the `%A` (original authors) is unchanged — do not overwrite it. |

---

## 13. Consolidated ASSUMED-VERIFY-BEFORE-SUBMIT flags

1. **G(17) = 1 is NOT computed** — it is the in-flight run's predicted outcome (~88% per the
   theory note). Do **not** paste the section 8 "with G(17)" variant until the run reports k=0 WIN
   + k=1 LOSS. If a different value is pinned, substitute it.
2. **No public artifact for our computation** — `git remote -v` is empty; there is no public repo
   or arXiv preprint yet. The Rudd `%H` (7.2) and the n = 18 source-backed comment (5(ii)) are
   blocked on creating one (public GitHub mirror or arXiv post). The terms + b-file + `%E` +
   method comment can go in without it (priority stamp), with the link added in a follow-up edit.
3. **Entry revision may have advanced** — snapshot is #54 (May 27 2025). Re-check at submission
   time and re-diff if it changed.
4. **Submission date** — every `Jul 03 2026` in `%E`, `%C` signatures, and the b-file header is a
   placeholder; set them to the actual submission date.
5. **Jenrich title** — VERIFIED this session ("Successful strategies for a queens placing game on
   an n x n chess board"); note the internal paper draft mis-cites it — use the verified string.
6. **`%o` program stub (7.3)** — only include if a real code link accompanies it; a pointer to a
   non-public artifact draws the same review request as a missing link.
