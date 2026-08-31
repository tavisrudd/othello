# Gem discovery track

**Date opened**: 2026-07-15
**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Mode**: append-only observation log. Never rewrite an entry; supersede it with a later one, or
leave the original with a pointer to where it went.

Sibling of the [Clebsch discovery track](2026-07-14-clebsch-discovery-track.md), same conventions,
different lane — entries do not cross between them. Companion to
[the gap-mining method](2026-07-15-gems-theory-gaps-method.md), which owns the cells and their
ledger. The repository-wide [discovery-track conventions](discovery-track-conventions.md) preserve
this log's “was I looking for this?” boundary while allowing incidental musings that do not arise
from a violated expectation.

## What belongs here — and what does not

**Incidental findings only.** This log catches what the probes turned up that **nobody was looking
for**: surprises, failed intuitions, "hmm, interesting" facts, questions raised in passing. Off-target
by definition.

**On-target findings do not belong here.** If it is what the cell was searching for — the verdict, the
computed answer, the thing the probe was built to decide — it goes to the cell ledger and the C-item
report. Putting it here too duplicates ownership and silts the log.

The discriminator, applied per observation: *was I looking for this?* If yes, it is a result. If no,
it is an entry.

**Why the log exists.** The kill order runs cheap computations at small parameters, and each is an
object-mining probe wearing a question-mining hat. The cell ledger records only whether the *cell*
lived, which tunnels attention onto a binary and discards everything to the side of it. **A killed
cell's computation is not wasted — only its verdict is.** This is where the byproducts land, and the
seam where question-mining feeds back into the object generator the lane already runs.

The precedent is in-lane and load-bearing: the **bound-shape detector exists only because someone
noticed an incidental anomaly and wrote it down** — the pencil bound is linear in q while the ω_arc
census data look sublinear. Nobody was hunting for that; it fell out of a census run for another
purpose. Without a place to put it, it evaporates.

## The bar

An entry is not "something interesting". Rule 3 of the method applies here too, and it is what keeps
this from silting up into a scrapbook:

**Surprise is relative to an expectation.** An observation qualifies when you can say what you
expected and what you got instead. For an incidental finding the violated expectation is usually a
background assumption you did not know you were holding — not the probe's declared null, which was
about something else entirely. If you cannot state the expectation, leave it out.

Two corollaries:

- A surprise means an expectation was wrong, which is information whether or not the cell it fell out
  of survived. Log it on kills especially; that is when the tunnel is tightest.
- The entry records the observation, not a theory of it. Explanations are cheap and this log does not
  grade them. If an entry grows a claim, it graduates to a report and takes a C-ID — and the original
  entry stays, with a pointer.

## Discipline

- **Provenance is mandatory.** Which cell, probe, or script produced it, precisely enough to re-run.
- **Evidence level on any literature claim**, per the method's ladder.
- **The strongest question it raises**, classified: **fold into the current cell** | **follow-on** |
  **do not pursue yet**. This preserves the question without letting the log expand scope by itself.
- **This log is not an authority.** Not a task queue, not a proof ledger, not a source for any
  manuscript claim. Promote only after scoping and verification.
- **Everything here is provisional until vetted** by a stronger reasoning model (Fable, or 5.6 Sol).
  Entries are leads, and a lead confers nothing until it graduates.

## Entry format

```
### YYYY-MM-DD — one-line title

**Provenance**: cell / probe / script that produced it, precisely enough to re-run.
**Was I looking for this?**: no — and what the probe was actually after.
**Expectation violated**: the background assumption it broke.
**Observed**: what happened instead.
**Strongest question**: … — fold into current cell | follow-on | do not pursue yet
**Status**: open lead | graduated → <pointer> | retired → <reason>
```

## Log

### 2026-07-14 — the pencil bound's shape does not match the ω_arc data

*Retroactive exemplar. Owned by the handoff's § Open frontiers; recorded here to fix the format, not
to claim the finding.*

**Provenance**: ω_arc census over primes q ≤ 37.
**Was I looking for this?**: no — the census was run to settle which q admit healthy arcs.
**Expectation violated**: that bounds in this area are loose by a constant, and the shape matches.
**Observed**: the pencil bound `(q+3)/2` is linear in q while the census data look sublinear. A bound
whose shape differs from the truth's means the bound's mechanism is not the truth's mechanism — and
the true one has no name.
**Strongest question**: what mechanism actually caps ω_arc, if not the pencil? — follow-on.
**Status**: graduated → the bound-shape detector in
[the method](2026-07-15-gems-theory-gaps-method.md) § Internal detectors. The gap itself remains
unexplained and is the handoff's to own.

### 2026-07-15 — zbMATH's `rf:` search reports every paper in mathematics as uncited

**Provenance**: [C191 instrument calibration](2026-07-15-c191-instrument-calibration.py), zbMATH Open
API leg.
**Was I looking for this?**: no — the probe was after Edge 1956's citer list by a non-OpenAlex route.
**Expectation violated**: that a citation query's empty result means "no citations". The background
assumption was that the instrument fails *loudly*.
**Observed**: zbMATH's `rf:` reference search keys on the **internal document id** (`rf:3121304`), not
the Zbl code (`rf:0072.38102`). The Zbl-code form returns `404 / "Entry not found!" / "successful
access. No results found."` — which reads exactly like a genuine empty result. Controlled against
three known-cited seeds: `rf:<Zbl code>` 404s for all, while `an:<Zbl code>` returns 200. **An
uncontrolled `rf:<Zbl code>` sweep reports a clean absence for every paper it is pointed at.**
**Strongest question**: which other citation instruments fail silently-empty rather than loudly, and
has any absence claim in this repo been built on one? — follow-on. **Cross-lane**: this is a tooling
hazard for any lane running literature gates (`clebsch` C146/C167/C169, `relconic` C154,
`repaircodes`), not a gem-mining finding. The mine does not write to other lanes; routing is the
user's.
**Status**: open lead. The general rule — control a citation instrument against a known-cited seed
before believing an empty result — is recorded in
[the method](2026-07-15-gems-theory-gaps-method.md) § Instruments.

### 2026-07-15 — Edge 1956 was cited by four people who were not Edge, and by nobody after 1988

**Provenance**: [C191 instrument calibration](2026-07-15-c191-instrument-calibration.py), all three
index legs.
**Was I looking for this?**: no — the probe was after the *venues* of Edge's citers, to test whether
any was a coding venue. The author field came along for free.
**Expectation violated**: that "seven indexed citers" described seven independent readers. Nobody had
looked at who they were.
**Observed**: three of the seven are **W. L. Edge citing himself** (Camb. Phil. Soc. 1963, Camb. Phil.
Soc. 1975, J. Algebra 1985). The independent citers are at most four people across thirty-two years —
Ostrom (1959, and among the eight authors of the 1962 *Monthly* section bundle), Raber (1975), Garner
(1988), and Segre if an unverified Semantic Scholar stub holds. **The citation record stops at 1988 in
every index.** zbMATH is starkest: of its three citers, two are self-citations, leaving one.
**Strongest question**: the paper was near-orphaned in its *own* field, with its author the main
custodian of its citation record — is that the actual shape of the founding cell's cause, rather than
"invisible to coding"? — fold into current cell (it is now recorded in C191's cell 1 as s4+s2).
**Cross-lane**: bears on `clebsch`'s C146 priority footnote, which argues Edge-vs-Dye priority. A
paper with four independent citers and none after 1988 is a different rhetorical situation than a
well-known one; the footnote may want the fact. Not routed — `clebsch`'s call.
**Status**: open lead.

### 2026-07-15 — a coding literature has been working our conic since 2006, and cites Edge nowhere

**Provenance**: [C191 completeness hunt](2026-07-15-c191-completeness-hunt.md), reading
[C179](2026-07-15-c179-conic-ldpc-literature.md) (a `clebsch` report) against C191's cell 1.
**Was I looking for this?**: no — the hunt was after *omitted cells* in the backfill's sample, a
bookkeeping question. It surfaced a live far side instead.
**Expectation violated**: that the finite-geometry↔coding seam around this conic was empty, which is
what the backfill and the method both asserted.
**Observed**: Droms–Mellinger–Meyer (2006), Sin–Wu–Xiang (2011), Madison–Wu (2012), Wu (2013),
Madison–Wu (2016) fix the same conic in `PG(2,q)`, use the same internal/conic/external point split
and passant/tangent/secant line split, and exploit the same `PGL(2,q)`/`PSL(2,q)` polarity. They build
**binary incidence null-space codes on whole point classes**; we build an `F_11` MDS code on a
six-point arc. They reach the conic from LDPC and cite Edge nowhere, so citer closure on Edge is blind
to them by construction.
**Strongest question**: this is an *earned dictionary with a question list attached*, aimed at our
object, with a nameable keying cause for why it never arrived — the best-shaped gap generator the lane
has. Edge's 22 hexagons partition the 66 external points into two systems of 11, every external point
on exactly 2 [in-repo L4, Edge §§29–32] — i.e. a binary parity-check matrix on the same 66 coordinates
Madison–Wu use, column weight 2, row weight 6. **Nobody has written Edge's hexagons down as a code.**
— follow-on, and the lane's next find-work.
**Status**: open lead. The correction it forced in C191 and the method is a *result* and lives there;
this entry records the byproduct, which is the far side itself.

### 2026-08-29 — the order-892 matrix has an automorphism of order 3 that permutes its four blocks

**Provenance**: C999, `notes/2026-08-29-c999-hadamard-668/certificate/H892.json` and the
"Automorphism groups, and the 4-profile invariant" section of
`notes/2026-08-29-c999-hadamard-668/verify/README.md`; commit `79693844f`.
**Was I looking for this?**: no — the task asked for the automorphism group of order **668**, and
892 was computed only because it was the next cheapest order in the same payload.
**Expectation violated**: that the whole payload would look like 668, whose group is exactly the
sign centre times the half-shift, which parity forces for a bordered array with even block length.
**Observed / musing**: `|Aut(H892)| = 6`, from an element of order 3 fixing one position in each of
the four circulant blocks of order 223. It is neither a common block shift nor a common block
multiplier, so it must permute the four blocks as well — outside both families the crate's
solver-free searches cover, which is why the solver proves it exists without describing it.
**Why it may matter / strongest question**: an automorphism that mixes the four Goethals–Seidel
blocks is a symmetry reduction available to a searcher, and 668 demonstrably had none. If the 892
sequences were found inside a symmetry-reduced search and the 668 ones were not, that is visible
evidence about a method its authors declined to disclose. Cheapest discriminator: read the order-3
generator out of the existing nauty output and check whether it is a block permutation composed
with a multiplier of `Z_223`.
**Evidence**: CHECKED (nauty, and bliss on 668; the 892 group order is solver output, the
generator's action is unread).
**Status**: retired → settled 2026-08-30: the order-3 element is the fixed multiplier `39` of `Z_223` (`39³ ≡ 1`), acting identically on all four sequences; see §12.1 of `notes/2026-08-29-c999-hadamard-668-report.md`.

### 2026-08-29 — a free shift parameter sits inside the posted order-668 array and does nothing

**Provenance**: C999, `notes/2026-08-29-c999-hadamard-668/README.md` under "Extracting the
sequences", and the Lean library `lean/HadamardMatrices/BorderedGoethalsSeidel.lean` (commit
`3ca9d0ad9`), which carries the shift as a parameter `e`.
**Was I looking for this?**: no — the deliverable was orthogonality of the posted matrix; the
deviation surfaced while rebuilding the matrix from the four extracted sequences and finding the
textbook array did not reproduce it.
**Observed / musing**: the six blocks of the lower-right 3×3 corner are back-circulant with entries
`x(i+j+2)` instead of `x(i+j)` — an extra cyclic shift by 2. It cancels identically in every cross
term, so the classical array at `e = 0` over the same four sequences is equally Hadamard. The
posted matrix therefore uses a parameter it did not need.
**Why it may matter / strongest question**: either the shift is a fixed artifact of how the
poster's `sed` program advances its rotation state, in which case it carries no information, or `e`
was a free coordinate in their search and the whole family `e ∈ Z_m` was being searched at once.
Cheapest discriminator: report the shift value at the other three bordered orders (716, 1676,
1772) — constant across all four means a generator convention, varying means a searched parameter.
The crate detects the operation but does not currently print its shift.
**Evidence**: CHECKED for `e = 2` at 668 (rebuild matches entry for entry) and LEAN for the
irrelevance of `e` to orthogonality; OPEN for what it means.
**Status**: retired → settled 2026-08-30: the same shift appears in every one of the nine circulant-family orders, bordered and plain (measured directly on the block entries; shift `1` in the sequence-reversal convention of the decoder README, `2` in the Lean convention), so it is the emitter's fixed convention, not a searched parameter; see §12.2 of `notes/2026-08-29-c999-hadamard-668-report.md`.

### 2026-08-29 — two orders closed in the same fortnight by opposite search philosophies

**Provenance**: C999, `notes/2026-08-29-c999-hadamard-668/certificate/H668.json` and
`.../certificate/H2060.json` with the "External: order 2060" section of
`.../certificate/README.md`; commits `79693844f` and `e4d2be925`.
**Was I looking for this?**: no — 2060 was fetched to settle whether the smallest open order was
still open, a bookkeeping question for the Part 2 survey. Its internal structure was a byproduct.
**Observed / musing**: the externally posted order-2060 matrix is a Goethals–Seidel array over four
blocks of order `515 = 5 · 103` written in a CRT-interleaved index order, with a genuine multiplier
`104 ≡ (−1,1)` acting in one CRT factor and a proved dihedral row-automorphism group of order 10.
The order-668 sequences are invariant under **no** unit of `Z_166` at all, in either the sign or
the shift sense — every unit was tested. One construction rides a multiplier group to shrink its
search space; the other apparently searched a 664-bit space with no reduction at all.
**Why it may matter / strongest question**: multiplier-invariant search is the standard tool in
this area and is exactly what this lane's own C736–C741 census assumes. A closure achieved without
it is the interesting one, and says the frontier may be moving by compute rather than by structure.
Cheapest discriminator: run the existing multiplier scan on the four prime-block-length orders
1132, 1244, 1948, 1964 from the same payload — symmetry-free across the board would settle that the
Alpöge search exploits no multiplier structure anywhere.
**Evidence**: CHECKED (both structures recovered from matrix entries; the 668 multiplier scan is
exhaustive over the units of `Z_166`; the 2060 automorphism statement is a proved lower bound, the
exact group was not computed).
**Status**: retired → settled 2026-08-30: multiplier invariance is the norm across the payload (seven of nine circulant-family quadruples), and 668/716 are the exceptions because `φ(m)` admits no useful multiplier; see §12.1 of `notes/2026-08-29-c999-hadamard-668-report.md`.


### 2026-08-30 — symmetric quadruples were not used at 668/716: is the `−1` multiplier dead there?

**Provenance**: the multiplier scan in §12.1 of `notes/2026-08-29-c999-hadamard-668-report.md` and
`certificate/H668.json`, `certificate/H716.json` (commit `f57fde27a`): both fixed multiplier groups are
trivial, in particular `−1` is absent, so none of the eight sequences is symmetric.
**Was I looking for this?**: no — the scan was after the order-3 automorphism of 892.
**Expectation violated**: a search team facing a 664-bit space with no odd-order multiplier would be
expected to take the one symmetry left, `x(−i) = x(i)`, which halves the space; they did not.
**Observed**: `φ(166) = 2·41` and `φ(178) = 2³·11` leave `−1` as the only cheap multiplier, and the
solutions found are not symmetric. Either symmetric bordered-Goethals–Seidel quadruples do not exist
at these even lengths (an even-length analogue of the known Williamson nonexistence lengths, not
in the literature as far as this lane knows) or the team tried and found none.
**Strongest question**: does a symmetric quadruple with `Σ PAF = −4`, row sums `(2,0,0,0)` exist at
`m = 166` or `178`? Symmetric sequences have about `m/2` free bits each, so the space is `~2^332`
before the PSD filter — a real search, not a scan. — do not pursue yet.
**Status**: open lead.

### 2026-08-30 — the `φ(m)` obstruction predicts which open orders are hard

**Provenance**: §12.1 of `notes/2026-08-29-c999-hadamard-668-report.md`; multiplier groups of all
nine circulant-family quadruples and of the external order-2060 matrix (commit `f57fde27a`).
**Was I looking for this?**: no — the scan explained one automorphism.
**Expectation violated**: that the twelve 2026 orders were found by one method.
**Observed**: every order whose block length admits a small odd-order multiplier was solved with one
(892, 1132, 1244, 1676, 1772, 1948, 1964, and 2060 externally); the two that admit none (668, 716)
were solved without symmetry. The bordered even-`m` route has forced row sums `(±2,0,0,0)`, and the
plain odd-`m` route needs row sums `≡ ±1 (mod r)` under an order-`r` multiplier with
`a²+b²+c²+d² = 4m` — a congruence filter on admissible `(r, row sums)`.
**Strongest question**: tabulate `φ(n/4)` and `φ(n/4 − 1)` for the open orders above 2000; those with
both of the form `2^k·(large prime)` are the 668 class and need a symmetry-free method, the rest are
the 892 class. `2092 = 4·523` is 892-class (`φ(523) = 2·3²·29`). — follow-on, gated on reopening the
declined Part 2 of the Hadamard task.
**Status**: open lead.
### 2026-08-31 — a constant-size figure meeting a growing threshold explains the whole `A_5` coincidence

**Was I looking for this?**: no — the pass was a novelty audit of C1020, and this fell out of the
adjacent-crown extraction after the claim was found pre-empted.
**Expectation violated**: that the twice-and-only-twice appearance of `A_5` in the exceptional
exterior-set census needed a group-theoretic cause. It does not, and `A_5 <= PSL(2,q)` is not the
mechanism — that subgroup also exists at `q = 19, 29`, where nothing occurs.
**Observed**: the figure's sizes are fixed (six arc points, ten Brianchon points) while the
completion size `(q+1)/2` grows with `q`. So `6 = (q+1)/2` has the unique solution `q = 11`, and
`6 + 10 = (q+1)/2` has the unique solution `q = 31`. Dye 1991's congruence (Brianchon points external
iff `q = 1 mod 3`, p. 282) then supplies the correct point type at each. Two equations, one solution
each, hence exactly two census entries.
**Strongest question**: the argument is generic — any constant-size configuration whose completion
must equal `(q+1)/2` can occur at only finitely many `q`, one per admissible size. Is this a general
finiteness lemma for exterior-set families, and does it predict which other fixed figures can appear
at all? That would convert a census observation into a structural bound and would apply to the
mixed internal/external invariant this lane still owns.
**Status**: open lead. Provisional — the whole gap-mining vet gate applies.
