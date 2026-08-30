# Small publishable gems sweep

**Lane**: `gem-mining`
**Date**: 2026-08-29
**Status**: read-only sweep. No allocation, no scope change, no commitment. Candidates only.

## Scope and method

Goal: find small, self-contained mathematical results in `notes/` that are (a) proved or
certified, (b) not part of any drafted manuscript under `papers/` (every drafted paper already
has a DOI deposit and is excluded), and (c) plausibly publishable as a short standalone note of
roughly two to eight pages, in the mould of *Standard Flips of Discrepancy One* and the
Hadamard-order-668 residual multiplier census.

Sources scanned, all with bounded reads:

1. Every discovery-track file under `notes/` (entry headers plus every non-`open lead` status).
2. `notes/2026-07-31-results-summary-snapshot.md`: "Unassigned adjacent results", "Two open
   programmes", and each paper section's "Material outside the current manuscript",
   "Related negatives", "What is not claimed", and "outside the current paper spines".
3. `notes/2026-07-07-codex-task-queue-archive.md`, rows marked `REPORTED 2026-08`, filtered to
   rows whose result is not manuscript-bound.
4. The C985 exact-distance notes dated 2026-08-29.

Two structural findings about the sources themselves:

- The discovery tracks are a thin harvest **by design**. Their own conventions say a lead confers
  nothing until it graduates, and almost every entry carries `**Status:** open lead`. The proved
  entries that do exist are nearly all proof simplifications destined for the owning manuscript.
  The real yield is in the snapshot's unassigned sections and in the two open programmes.
- `papers/nofil-finite-geometry-outcomes/` contains **no `.tex`** — it is a directory of
  Markdown proof kernels, not a drafted manuscript. Its contents therefore qualify under (b),
  and they are the single largest untapped block found.

Explicitly excluded as pre-empted by the notes' own audits:

- The exceptional root-system code ladder
  `[496,11,240]_{E10} -> [240,10,112] -> [120,9,56]_{E8} -> [28,7,12]_{E7} -> [27,6,12]_{E6}`.
  The snapshot records a three-layer pre-emption (level codes are Calderbank-Kantor two-weight
  codes; the fold is Brouwer-Shult 1990, available as Proposition 3.6.1 of Brouwer and Van
  Maldeghem's *Strongly Regular Graphs*; the bottom chain is named outright there) and states
  that nothing in it should be written up as novel.
- The Jordan-scalar minimal-class theorem and its primitivity boundary: proved and attractive,
  but already written into `papers/blown-up-theta-lattice` and `papers/cubic-stabilization-m1`.
- The golden conference-class recognition theorem and the aligned-design faithfulness theorem:
  both manuscript-bound (golden-operator paper, and Clebsch III via C876/C878).

---

## Candidates

### 1. Query complexity of reconstructing an aligned design

**Statement.** For a two-graph on `n` points, an *alignment test* asks whether the four triples
of a given 4-set carry equal triangle value. Adaptively, an explicit decoder reconstructs the
two-graph in `C(n,2) + n - 4` tests on every instance against a counting lower bound of
`C(n,2) - n`, so the adaptive leading constant is exactly `1/2` and the coherence restriction is
free to leading order. Nonadaptively the constant is bracketed:
`0.616 n^2 <= minimum(n) <= (9/8) n^2 + O(n)`. Supporting exact values: the nonadaptive minimum
at seven points is 30 of the 35 tests (56 optimal families in two orbits, three independent
routes); at eight points the bracket is `30 <= minimum <= 44`, the lower end proved optimal by a
`PG(3,2)` skew-line argument (a pairwise unevenly crossing family of four-four splits is a set of
pairwise skew lines, so at most five members, giving `35 - 5`); attachment constants `g(5)=9`,
`g(6)=12`, `g(7)=15` exhaustive, `g(8)` in `[15,17]`; and a star-flip lower bound
`minimum(n) >= ceil(n g(n-1)/4)` that beats the entropy floor wherever `g` is known exactly
(21 against 18 at seven points, 30 against 25 at eight).

**Where it lives.** `notes/clebsch-tasks/c880-aligned-query-complexity.md` (C880), with reports
`notes/2026-08-19-c880-nonadaptive-constant.md`, `notes/2026-08-07-c880-alignment-separation.md`,
`notes/2026-08-07-c880-mask-ilp-bound.md`, `notes/2026-08-07-c880-adaptive-decoder.md`,
`notes/2026-08-11-c880-item5-conference-promise.md`,
`notes/2026-08-07-c880-literature-audit.md`. Snapshot section "The query complexity of
reconstructing an aligned design".

**Proof status.** Human proofs for the decoder, the attachment lemma, the composition argument,
the entropy floor, the sensitivity rule and the star-flip bound; the exhaustive constants
`g(5)`, `g(6)`, `g(7)` and the eight-point hitting-set optimum are certified computations, each
with independent solver agreement (three solvers for `g(5)`, `g(6)`; two solvers plus a
structural argument for the eight-point bound).

**Why it is not in a paper.** Clebsch III proves only that aligned four-sets determine a
two-graph. The quantitative question is one the manuscript does not ask, and the snapshot states
outright that none of this is in any manuscript.

**Novelty risk.** Low. A dedicated literature audit exists with per-claim verdicts: the adaptive
and nonadaptive complexity results, the sensitivity rule, and the exact `n = 7, 8` separating-family
minima all return NO PREDECESSOR LOCATED; only the entropy-subadditivity technique is pre-empted
(textbook, cite it) and the two-value `4x4` Seidel principal minor fact becomes a citation rather
than a theorem.

**Length.** Six to eight pages.

**Venue.** arXiv `math.CO` and then a combinatorics short communication. The exact small-`n`
constants would also make a reasonable OEIS-style record.

**Caveat.** The nonadaptive constant is still an open bracket. Publish the bracket with the
mechanism, or wait; the bracket is already a factor-1.827 statement, down from 4.87.

---

### 2. Nofil / cap-avoidance outcomes on finite geometries

**Statement.** In the impartial normal-play cap-achievement (Nofil) game on the collinearity
hypergraph of a finite geometry, the second player wins `AG(n,q)` for every `q`, `PG(n,2)` for
every `n`, `PG(2m-1,q)` for odd `q` by a fixed-point-free elliptic involution, and `PG(2,q)` for
every even `q`. The even-plane theorem is the one with real content: `|PG(2,q)| = q^2+q+1` is odd
so no whole-board pairing exists, and the proof supplies a mirror strategy instead.

**Where it lives.** `papers/nofil-finite-geometry-outcomes/2026-07-05-qeven-plane-theorem.md`
plus the kernels `2026-07-07-kernel-affine-cap.md`, `2026-07-07-kernel-conic-localization.md`,
`2026-07-07-kernel-nofil-corollaries.md`, `2026-07-08-projective-mirror-proof-kernels.md`. Lane
`cap`, handoff `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`.

**Proof status.** Human proofs; the even-plane strategy was additionally verified stuck-free over
all first-player lines at `q = 2, 4, 8` with zero illegal replies. Parts are formally verified
(both directions of the frame equivalence).

**Why it is not in a paper.** `papers/nofil-finite-geometry-outcomes/` holds no `.tex`; it is a
kernel directory. The lane's effort went into the open odd-`q` plane problem instead of
packaging the closed cases.

**Novelty risk.** Low, given a qualified claim sentence. A dedicated audit
(`2026-07-08-codex-projective-nofil-novelty-audit.md`) reached Huggan-Huntemann-Stevens (JCD 2022,
arXiv:2103.13501), its 2025 follow-up, and Danziger-Huggan-Malik-Marbach (arXiv:2009.11363), and
concluded the ingredients (Nofil, pairing strategies, elliptic involutions) are prior art while
the infinite projective-family outcome theorems are not recorded for this game. The audit's own
conservative wording is already drafted. Keep the "to our knowledge" qualifier until
Clark-Mancini-Van Hook is checked.

**Length.** Six to eight pages for the full outcome set; four if restricted to the even plane.

**Venue.** arXiv `math.CO` and a games/designs journal short communication (the Nofil precedent
is *Journal of Combinatorial Designs*).

**Bonus material available for the same note.** Three further proved lemmas from the odd-`q`
attack that are self-contained: the frame reduction (the plane is a second-player win iff a
single four-cap frame is, both directions formally verified); the escape-count lemma, that every
size-three residual has exactly `q^2 - 9q + 21` legal size-four children, always odd; and the
conic localization lemma, that a size-three residual together with its two burned direction
points is a projective five-arc and therefore determines a unique conic. Note the recorded
correction: the associated optimism that `bad < total` follows from area growth is refuted at
`q = 17`, where `bad = 152` of `total = 157`.

---

### 3. A conic-disjoint complete 26-arc in `PG(2,64)` and its `[24,3,22]_64` MDS code

**Statement.** Twelve genuinely nonlinear repair layers at `s = 8` produce `3s = 24`-arcs whose
nineteen uncovered points all lie on the line at infinity, hence complete affine arcs extending
to complete 26-arcs disjoint from a conic. The twelve layers give three projectively
inequivalent 24-arcs — equivalently three monomial-equivalence classes of `[24,3,22]_64` MDS
codes, each with projective stabilizer of order four — which Frobenius fuses into a single
`PGammaL(3,64)` semilinear class, again with stabilizer of order four. The conic signature is
exact and intrinsic: every representative meets exactly two conics in ten points (disjoint on the
arc, giving a `10+10+4` decomposition), 47 in eight points, 16 in seven, 1632 in six, 29240 in
five. The object is excluded from the conic-pencil, translation-arc, hyperfocused-arc and
affinely-regular-polygon constructions.

**Where it lives.** `notes/2026-07-18-c300-c210-q64-arithmetic-classification.md` (C300/C210,
lane `relconic`); snapshot section "Complete arcs of square-root size relative to a conic".

**Proof status.** Exhaustive certified computation over `PG(2,64)` for the classification,
stabilizers and conic signature; the completeness and conic-disjointness are proved.

**Why it is not in a paper.** It is the live signal inside an open programme, kept back because
the wanted statement is the uniform characteristic-two version giving `3s+2` on an infinite
square-order sequence, which is proved only at `s = 8`. Nothing about it appears in
`papers/arcs_complete_outside_conic`.

**Novelty risk.** Medium. The four nearest catalogued constructions are already excluded in the
note, but no dedicated literature audit against the complete-arc and MDS-code classification
literature for `PG(2,64)` is recorded. That audit is the gate.

**Length.** Four to six pages.

**Venue.** arXiv `math.CO` and then *Designs, Codes and Cryptography* or *Finite Fields and
Their Applications* as a short communication.

---

### 4. A positive-density infinite family of conic-disjoint arcs

**Statement.** Two parallel subfield parabolas form a uniform conic-disjoint `2s`-arc; adding a
repair layer yields a conic-disjoint arc of size `11s/840 - O(sqrt s)` along every `s = 8^m`
with `m` odd. This is the first infinite-family positive-density result of the programme.

**Where it lives.** `notes/2026-07-16-arcs-sqrtq-construction-program.md` and
`notes/2026-07-16-c210-square-root-mechanism-audit.md`; snapshot section "Complete arcs of
square-root size relative to a conic".

**Proof status.** Human proof: `S_5 x C_2 x C_2` monodromy, Chebotarev, and a greedy bound on a
collision graph of maximum degree six.

**Why it is not in a paper.** Same reason as candidate 3 — the programme is holding out for
completeness (coverage), and legality alone was judged not to be the headline. But the arcs are
legal, infinite, and of positive density, which is a statement in its own right.

**Novelty risk.** Medium. Arcs disjoint from a conic are a studied object; a literature audit
against the conic-disjoint arc and `(k,n)`-arc construction literature has not been recorded for
this family specifically.

**Length.** Six to eight pages.

**Venue.** arXiv `math.CO`, then *Finite Fields and Their Applications*.

**Natural companion for the same note.** The Baer obstruction, a half-page counting proof: in
`PG(2,s^2)` with `B` a Baer subplane of order `s`, any `k`-arc `A` contained in `B` has all its
secants among extended `B`-lines, so `|U(A) \ B| = (s^2+s+1 - C(k,2))(s^2-s)`; since `k <= s+2`
the number of nonsecant `B`-lines is at least `(s^2-s)/2`, giving
`|U(A) \ B| >= (s^2-s)^2/2 > s^2+1`, which exceeds any ambient conic's point count. Hence **no
arc contained in a Baer subplane is complete outside any ambient conic for `s >= 3`**
(`notes/2026-07-16-c210-square-root-mechanism-audit.md`, "A family-level Baer obstruction"). Too
thin to stand alone; it is a clean lemma inside a longer note.

---

### 5. Residual multipliers for Hadamard order 668

**Statement.** The Legendre-pair route to a Hadamard matrix of order `668 = 4 * 167` reduces to a
census of possible fixed common multiplier subgroups for length 333. Of the 30
mod-3-compatible subgroups, 21 were excluded by published proof-carrying work; that baseline is
reproduced and pushed to 25 by two independent new mechanisms, and every subgroup of order six is
closed. Mechanism one is a congruence on the nine-compression: for `H` of order six generated by
`{73,85}` or `{73,121}` the compression has shape `(c_0,x,y,c_3,x,y,c_6,x,y)` with each `c_i`
congruent to `+-1 mod 12` and `x,y` odd, row-sum normalization forces `S = c_0+c_3+c_6 = 1 mod 12`
and `x+y = 0 mod 4`, so the shift-one compressed autocorrelation `R = S(x+y) + 3xy` is `5 mod 8`
in both admissible branches, contributing `2 mod 8` against the Legendre compression identity's
required `6 mod 8`. Mechanism two is an orbit lock: with `L_H(s)` the number of positions `x`
with `x` and `x+s` in the same `H`-orbit, a Legendre pair needs joint Hamming distance 334 at
every nonzero shift, so `L_H(s) >= 167` excludes `H`; the subgroup generated by `{73,112}` falls
at shift 111 (equality forced on all 222 nonmultiples of three, capping joint distance at 222)
and `{112}` at shifts 111 and 222. An exact six-case census proves the criterion does not exclude
the remaining five subgroups, so the mechanism is exhausted rather than untried.

**Where it lives.** `notes/2026-07-31-c736-hadamard-668.md`,
`notes/2026-07-31-c738-hadamard-668-id7.md`,
`notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.md`; handoff
`notes/handoffs/2026-07-14-gem-mining.md`; snapshot section "Residual multipliers for Hadamard
order 668".

**Proof status.** Human proofs for both mechanisms, with independent replay for the mod-8
argument and an exact six-case census for the orbit lock.

**Why it is not in a paper.** No manuscript was ever started; the lane recorded it as an
unassigned adjacent result. C741 (proof-carrying mixed lift for the remaining IDs) is still in
progress, which is what has held packaging.

**Novelty risk.** Low-medium. The results predate and are unaffected by the 2026-08-12 Anthropic
announcement of constructions at order 668 and the other eleven open admissible orders below
2000, which was released as an encoded string with a decoder and no method. Existence at 668 is
settled externally; **the framing must change** to the Legendre-pair question at length 333,
which remains open. The gem-mining handoff records that a folklore/priority check on the
mechanisms is still outstanding — that is the gate.

**Length.** Four to six pages.

**Venue.** arXiv `math.CO`, then *Journal of Combinatorial Designs* or *Australasian Journal of
Combinatorics* as a short communication.

---

### 6. Exact minimum distances of published quantum LDPC codes, and the symmetry reduction behind them

**Statement.** Two linked results. (a) Symmetry reduction: the conventional per-logical-class
encoding of the exact minimum-distance integer program destroys the code's own symmetry — on the
bivariate-bicycle gross code `[[144,12,12]]` only an order-two matrix symmetry survives from a
source translation group of order 72. A class-independent global re-encoding restores the
`Z_12 x Z_6` translation action as a genuine model symmetry, worth 3.1x alone; automorphism-orbit
symmetry-breaking constraints on top give a further 4.2x, for a branch-and-bound tree reduced
from 13,228,127 to 1,010,491 nodes (13.1x). The same treatment gives 6.5x on the binary passant
code `[78,36,12]_2`. (b) Exact distances certified: `[[360,12,24]]` for the official QDistSAT
`BB_360_12_?` instance, closing the published `d <= 20` scan and the previous weight-24 upper
bound; `[[784,24,24]]` for the published bivariate-bicycle code; `[[1496,194,20]]` for the
non-abelian lifted-product candidate `R2Elite01` and `[[1496,198,16]]` for the dihedral candidate
`R2Elite02` of Liu-Marquardt (arXiv:2606.24808v1); and `d >= 24` for `[[756,16,<=34]]`.

**Where it lives.** Snapshot section "Symmetry reduction in exact quantum-code distance
computation" (C997); `notes/2026-08-29-c985-qdist-bb360-exact-distance.md`,
`notes/2026-08-29-c985-bb784-exact-distance.md`,
`notes/2026-08-29-c985-sce-r2elite01-distance.md`,
`notes/2026-08-29-c985-sce-r2elite02-exact-distance.md`,
`notes/2026-08-29-c985-bb756-large-code-spike.md`. Lane `complete-ports`.

**Proof status.** Certificate. Every integer program closed at gap zero, so the distances carry
the solver's own optimality proof plus explicit `GF(2)` invariance checks; witnesses are retained
and independently replayed. The gross-code `d_Z = 12` matches the published value and the passant
`d = 12` matches an independent committed computation.

**Why it is not in a paper.** The snapshot states explicitly that the symmetry-reduction result
is not assigned to a manuscript. The exact distances are newer still.

**Novelty risk.** Low for the distances themselves (they are exact values for published codes,
several of which previously had only bounds); the notes are careful that these are not
construction-priority claims. **Medium risk of being absorbed rather than pre-empted**: an
in-progress ergodis exact-algebraic-optimization paper (`notes/2026-08-27-c985-ergodis-optimization-paper.md`)
is the natural home for the tooling story, and the node-count ratios are explicitly flagged as
one solver's property — reproducible rather than verifiable, with survival on solvers that have
built-in orbital branching untested and named as the gate on any external claim.

**Length.** Four to six pages if written as a distance-record note; the tooling claims should be
left to the ergodis paper.

**Venue.** arXiv `quant-ph` note, plus submission of the values to the quantum-code parameter
tables. Not a journal item on its own.

---

### 7. Two exact non-code consequences of the Clebsch Schur-Sarkisov spine

**Statement.** The sparse sextic is the unique reduced point of the self-dual two-pole Schubert
problem `sigma_{(2,2,1)}^2 = 1`, with Wronskian `x^5 y^5`; and the projected rational sextic is
arithmetically Buchsbaum with Hartshorne-Rao module `k^2(-1)`, which identifies its defect-two
jet quotient with its complete projective-normality deficiency.

**Where it lives.** Snapshot section "Two exact non-code consequences", inside "The Clebsch
Schur-Sarkisov spine" (which the snapshot marks as not yet assigned to a manuscript).

**Proof status.** Exact statements from a full-document cross-area audit; the underlying
computations are recorded, the write-up level is a sentence each.

**Why it is not in a paper.** The whole Schur-Sarkisov spine is unassigned; these two statements
sit at its edge and are about neither codes nor the Clebsch application.

**Novelty risk.** High. Schubert problems with `sigma_{(2,2,1)}^2 = 1` and Buchsbaum
classification of projected rational sextics are both dense classical literatures; these are
exactly the kind of statement most likely to be a known example. Do not start without a full
audit.

**Length.** Two to three pages, if either survives audit.

**Venue.** Not worth a standalone submission on this evidence; better folded into whatever
carries the Schur-Sarkisov spine, or logged as an example.

---

### 8. Eckardt points on separated-variable cubic threefolds

**Statement.** A point `p` of a smooth cubic threefold is an Eckardt point exactly when the
Hessian at `p` has rank at most two. If the equation is a sum of cubic forms in pairwise disjoint
groups of at most three variables, some group has size at most two, a point of the threefold
supported on that group exists because a binary cubic has a root, and at such a point every other
diagonal Hessian block vanishes. Hence every member of Colliot-Thelene's separated-variable class
carries an Eckardt point. Companion group-theoretic form: an Eckardt point produces an involution
with eigenvalue multiplicities `(4,1)`, so a cubic whose automorphism group is exactly `A_5`
acting through `W_5` — where involutions have multiplicities `(3,2)` — has no Eckardt point.

**Where it lives.** `notes/2026-08-15-cubic-threefolds-discovery-track.md`, entry 2026-08-18
(C914); computational side in `notes/2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`.

**Proof status.** PROOF for both statements (three lines each); the pencil side is computational.

**Why it is not in a paper.** Logged as an open lead; promoting it is a paper edit that was never
allocated. Its actual value is that it reproves the `m = 1` epilogue's
`prop:A5-nonseparated` in three lines, replacing an argument routed through Hartlieb.

**Novelty risk.** High. The Hessian-rank characterization of Eckardt points is classical, and the
separated-variable consequence is a three-line corollary; likely folklore.

**Length.** Two pages at most.

**Venue.** None standalone. Use it as a proof simplification in the cubic-threefolds manuscript.
Recorded here only so the sweep is complete.

---

## Also considered and set aside

- **The mirror lemma as a general Cayley Node-Kayles zero-criterion** (`notes/2026-07-18-dihedral-discovery-track.md`,
  C289): for any finite group `G`, involution generating set `T`, and involution `w` outside `T`
  normalizing `T`, left multiplication is a free non-adjacent pairing, forcing Node-Kayles value
  zero on `Cay(G,T)`. Proved and exhaustively checked over all ten polyhedral classes. Set aside:
  the free-pairing argument is the standard strategy-stealing device, so novelty risk is high,
  and the dihedral paper already uses it.
- **The `[10,4,6]_9` seed with dual distance four** in the complete-ports formal library that the
  manuscript does not use. Too thin.
- **Log-concavity refutations for the pointed profile** (an explicit simple rank-five binary
  seven-column counterexample, and an infinite regular-graphic series-parallel family whose
  smallest member has 14 helper edges, after 30,638 exhaustively enumerated pointed types and all
  185,701 profiles through 13 edges passed). Attractive as a counterexample note, but the
  complete-ports manuscript already carries them in its "Related negatives".
- **The Kloosterman closure of full-domain `GF(8)` scalar extensions** and the partial-domain
  deletion floor (`notes/2026-07-16-c210-square-root-mechanism-audit.md`). Technically clean, but
  it is an internal negative about one construction architecture, not a statement a reader outside
  the programme would want.
- **The Klein `E_8` transvectant operator**: exceptional degrees exactly
  `0,1,2,6,10,11,12,20,21,22,32,40,52`, degree 22 the sole certified full-corner failure, and the
  indicial-root determinant formula `det K_-(j) = C prod_{s=0}^{2} ((3j+s)_3)^{c_s}`. Real and
  unassigned, but this is a programme, not a two-to-eight page note.

---

## Top five, ranked by readiness times interest

1. **Query complexity of reconstructing an aligned design** (candidate 1). The only candidate with
   a completed per-claim literature audit returning NO PREDECESSOR LOCATED on the main results, an
   exact adaptive constant, and independently replayed small-`n` constants. Highest readiness and
   the cleanest standalone story. Decide whether to publish the nonadaptive bracket as-is.
2. **Nofil / cap-avoidance outcomes on finite geometries** (candidate 2). Complete proofs, a
   drafted conservative novelty sentence, a named prior-art anchor to position against, and three
   extra self-contained lemmas to pad the note. It needs packaging work, not mathematics.
3. **Residual multipliers for Hadamard order 668** (candidate 5). Two independent proved
   mechanisms and a clean 21-to-25 improvement over published proof-carrying work. Two gates: the
   outstanding folklore/priority check, and a reframing away from existence at 668 toward the
   Legendre-pair question at length 333.
4. **The conic-disjoint complete 26-arc in `PG(2,64)`** (candidate 3). The most striking single
   object in the sweep — a `[24,3,22]_64` MDS code with an intrinsic `10+10+4` conic signature and
   a single semilinear class — but it needs a literature audit against the `PG(2,64)` complete-arc
   and MDS classification literature before anything else.
5. **Exact distances of published quantum LDPC codes** (candidate 6). Highest certainty of
   correctness and immediate practical interest, lowest mathematical depth, and the real risk is
   that the in-progress ergodis paper absorbs it. Worth a fast arXiv note plus parameter-table
   submissions if it is going to be separate at all.

Immediately below the line: the positive-density conic-disjoint arc family with the Baer
obstruction as its companion lemma (candidate 4), which is the strongest of the rest but carries
the same unaudited-novelty gate as candidate 3.
