# Gem mining — the second-gem hunt

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-14
**Status**: C147, C174, and C736 are reported. The hexad theorem is fully machine-checked and
proof-structured; its q=23 octad analogue is closed-negative; the chord--extension identity now
holds for every six-arc in every finite projective plane. C155 is drafted with an exact computation
manifest, and submission remains gated on C156/C157/C169. C159 is seeded by Clebsch C184's complete
q11 six-arc low-degree table; C160's finite calculation is superseded by Clebsch C187 and only its q5
folklore/priority check remains. The Hadamard-668 multiplier census is now 25/30 impossible: C738's
shift-111 orbit lock excludes ID 7, and C740's complete residual screen shows the same lock excludes
ID 2 while exhausting that mechanism for IDs 0, 1, 3, 4, and 5. C741 proves the separate 9- and
37-compressions feasible for paired IDs 4 and 5, has reduced their exact mixed-lift frontier to
108 symmetry representatives, and proves the compression itself recovers each row's unique minus
among the three fixed positions modulo 6 (36 same-point and 72 different-point cases); neither ID
is yet decided.

**Allowed paths for this lane:** `notes/2026-07-14-c147-*`, C155–C157/C159/C160/C169/C174/C175/C177/C178/C190/C191/C192/C193/C736/C737/C738
reports and scripts, `notes/2026-07-15-gems-theory-gaps-method*.md`,
`notes/2026-07-15-gem-discovery-track.md`, this handoff and its companion, and the `gem-mining` rows
of the global queue. Changes to the Clebsch manuscript belong to `clebsch` (C167), even when they
cite a gem result.

**Gap-mining output is contained to this lane.** Everything the gap mine produces — cells, causes,
ledger rows, discovery-track entries, method findings — lives in this lane's docs and nowhere else.
Do not route it into another lane's handoff, and keep it out of the global queue beyond the bare
one-line `C<id> — description → report path` row the ID registry requires: no findings, no verdicts,
no status prose there. The mine may *read* any lane's docs freely; it may not write to them. A
gap-mined result that belongs in a manuscript still routes through that manuscript's lane, exactly as
any other gem result does.

**Gap-mining output is provisional until vetted by a stronger reasoning model** (Fable, or 5.6 Sol).
This covers the reasoning, not just the literature claims: causes, promotion scores, cell verdicts,
ledger rows, claimed mechanisms. The rule is earned — the method's first draft was confidently wrong
at its centre and needed an adversarial Fable pass to see it, and the revision then introduced a
circular calibration gate resting on a misreport of an in-repo record, caught only by an independent
review. Fluency is not evidence, and self-review does not catch this class. Nothing gap-mined is
load-bearing, citable, or promotable to a manuscript before its vet.

**The user launches the vet; a mining session never does.** Do not spawn a vet agent, do not
commission one, and do not self-vet. Independence means independence from the mining session's
*framing* — a vet whose prompt the mine wrote inherits the blind spots it exists to catch — and the
stronger models are a metered, expensive resource the user allocates explicitly. **This lane's
working role is to find**: mine cells, run the kill order, run the searches, write the report, mark
it provisional, stop. Leaving output at the gate is the job done right, not a loose end; "awaiting
vet" is a status to report, never a task to pick up.

## ⚠ Dye 1991/1988 — the largest standing warning to this lane (2026-07-15)

**Dye 1991 was obtained today** (page scans at `/tmp/persistent/tavis/lit-search/dye-1991/`, with an
OCR reconstruction beside them) and it is not a near-miss — it is the same geometry. Warning relayed
from the agent doing the paper citation updates, whose lane owns the manuscript side:

> Five triangles, polarity, orbit sizes, double-six structures, A₆-related phenomena, and several
> attractive graph configurations are already in Dye. These can still yield new coding
> interpretations, but should not be advertised as newly discovered geometry.

**R. H. Dye, "Hexagons, conics, A₅ and PSL₂(K)"** (scans pp. 270–286). Its stated aim is to make
hexagons account for `A₅ ≤ PSL₂(K)` over **any** field of characteristic ≠ 2 in which 5 is a square —
not just q=11. It cites Edge 1956 as its ref [6].

Two open frontiers of this lane are named in Dye's §1.4 [in-repo L3, OCR reconstruction — verify
exact statements against the PNGs before citing]:

- **The q=5 frame — "unaudited" in the novelty tables — is in Dye.** *"When K is GF(5) then PSΩ(5)
  is A₅, and 𝒞 has six points which form a hexagon. Through each of the 10 internal points passes
  three chords; these are just the edges of the hexagon."* The "cheap check: structure or degeneracy?"
  has an answer in print.
- **q=9 — the unswept prime power this lane says "matters" — is Dye 1988.** Dye's ref [5]:
  *R. H. Dye, "Twelve hexagons associated with the 10-point conic and the isomorphism PSL₂(9) ≅ A₆",
  J. London Math. Soc. (2) 37 (1988) 437–446* — twelve hexagons with **internal** vertices, two
  PSΩ(9)-orbits of six, A₆ acting inequivalently on each. **Get this paper before sweeping q=9.**

**What this does not touch.** The `[6,3,4]₁₁` MDS code, the deep-hole/covering reading, and the
coding interpretation are not Dye's subject. The E_q reduction and the healthy census remain this
lane's framing. **What is at risk is any claim that the geometry is new** — the internal-vertex
hexagons, the A₅/A₆ stabilizers, the self-polar triangles, and the Brianchon concurrency are Dye's.

**Do not route this into `clebsch`.** Another agent owns the manuscript's citations and priority
footnote; this section records only what it means for *this* lane's frontiers. Dye also states a
**sequel** exists ("the details will form a sequel") — unlocated.

## Adversarial takeover map (2026-07-14)

Full cross-lane issue ledger: [Clebsch + gem takeover audit](../2026-07-14-clebsch-gem-adversarial-takeover.md).
Cheap-upgrade report: [reader questions and cheap upgrades](../2026-07-14-clebsch-gem-cheap-upgrades.md).

| Task | State | Trust boundary / next action |
|---|---|---|
| **C147** | reported | theorem, two-system verifier, orbit proof, and octad negative are durable; stale report header corrected |
| **C169** | queued, submission gate | obtain PGOFF §§8/14 and Korchmáros–Storme–Szőnyi; coordinate Sadeh with C131; settle whether the on-conic extension spectrum was printed |
| **C155** | drafted, gated | theorem spine, novelty posture, q=23 negative, and exact Git-indexed manifest are in [the draft](../2026-07-14-c155-hexad-note.md); C156/C157/C169 remain |
| **C156/C157** | citation gates | source the two-system split and replace inferred textbook theorem numbers |
| **C159** | queued, independent | consume C184's complete q11 six-arc degree/rank table; begin with the missing q<=11 atlas cells, not a q11 six-arc rerun |
| **C160** | priority residue only | C187 settles the q5 frame/conic calculation; check Edge/frame folklore and coding tables |
| **C190** | reported | Clebsch-to-gem ownership and citation seams fixed → [report](../2026-07-15-c190-gem-clebsch-routing.md) |
| **C191** | reported, **provisional — verdict contested, vet gate open (user-launched)** | gap-mining backfill → [report](../2026-07-15-c191-gap-mining-backfill.md); its verdict is now contested by its own two follow-ups. **Calibration** → [report](../2026-07-15-c191-instrument-calibration.md): three indexes disagree (7/3/7, union 8) so object-level closure stays a lead not a reading; three of Edge 1956's seven citers are self-citations (four independent in thirty-two years, none after 1988); the instrument's error mode biases toward the emptiness it was used to confirm. **Completeness hunt** → [report](../2026-07-15-c191-completeness-hunt.md): **found a falsifier** — C179's 2006–2016 conic/LDPC coding lineage refutes cell 1's "empty seam", cell 4's object is itself from one of those coding papers, and C179 sat in the same commit as the C178 the backfill did score. The founding cell's seam factor and cause class both need re-scoring; the vet rules. Remaining find-work: C177 as the first prospective cell |
| **C192** | **closed — not a find** | first cell mined off the C179 coding far side. The 22 hexagons are 1-factors of K₁₂ on the conic's 12 points and each system of 11 is a 1-factorization (verified, both conics; **not** perfect — 0/55, so not GK₁₂). The two systems' 11×11 incidence is the Paley-biplane complement, \|Aut\|=660. **Killed by its own gate**: Edge 1956 §32 states the same structure as a symmetrical (6,6)/(5,5) correspondence and points at Klein 1879; we added λ and a modern name. The K₁₂ phrasing is absent from Edge but absent≠novel. Cost: one cached read → [report](../2026-07-15-c192-hexagon-biplane.md) |
| **C193** | reported — **the six-sweep ILL gate is open** | BSW 1992 read at full text. Its §3 is a **published complete census** of the exceptional complete exterior sets (Brouwer, up to isomorphism, q=7,11,19,23,27,31; none for q=43..131). Four consequences: the q=11 6-arc is **Korchmáros 1981** (chains of circles on an elliptic quadric) — a third prior name, not in the lane's record; there is a **second q=11 configuration, a Pasch**, invisible to an arc-only census; the q<131 check is **Brouwer's inside BSW**, not Van de Voorde's; and Giessen 1991 is confirmed as the sets-without-tangents paper, now the only unread BSW original. Strongest lead: BSW's **q=31 6-arc + Petersen graph** against this lane's q=11 Brianchon–Petersen — null declared, uncomputed → [report](../2026-07-15-c193-bsw-exceptional-census.md) |
| **C736** | reported | reproduced the proof-carrying 21/30 baseline and excluded residual IDs 9 and 10 by an exact mod-8 9-compression argument with independent replay; 23/30 are now impossible, ID 7 is the sole surviving order-6 case, and unrestricted order 668 remains open → [report](../2026-07-31-c736-hadamard-668.md) |
| **C737** | queued, independent | decide `M(18) in {57,58,59}` through a complete Seidel-spectrum census and certified elimination/construction of residual cases → future report `notes/2026-07-31-c737-equiangular-lines-r18.md` |
| **C738** | reported | excluded ID 7 `<73,112>` analytically: at shift 111, invariance forces equality on all 222 nonmultiples of 3, but a Legendre pair requires joint Hamming distance 334 while at most 222 is possible; independently replayed the exact orbit certificate and preserved C736's feasible 9-compression witness as a positive control; all order-6 cases are closed and 24/30 subgroups are impossible → [report](../2026-07-31-c738-hadamard-668-id7.md) |
| **C740** | reported | exact six-case orbit-lock census excludes ID 2 `<112>` at shifts 111 and 222; full spectra prove the criterion does not exclude IDs `0,1,3,4,5`; C736's feasible 9-compression witnesses for IDs 2, 4, and 5 remain positive controls; the census is 25/30 impossible and paired IDs 4/5 are the next exact target → [report](../2026-07-31-c740-hadamard-668-residual-orbit-locks.md) |
| **C741** | in progress, proof-carrying mixed lift remains | both common quotient systems are exactly feasible: C736's 9-compression witness survives and a new 37-compression witness has joint norm 650 and PAF `-18`; complete enumeration gives 4,089 accepted 9-compressions, eight complementary profile pairs, 648 normalized sequence pairs, and exactly 108 affine/decimation/swap representatives; orbit-size congruence proves exactly one singleton minus per positive row, and each compression recovers its location modulo 6, splitting the global frontier exactly into 36 same-point and 72 different-point cases; finish those representatives with selector-aware checked proofs or a mixed-character obstruction—generic solver status is not evidence → [checkpoint](../2026-07-31-c741-hadamard-668-ids4-5.md) |
| **C174** | reported, folds into C155 | stronger six-arc identity in every finite projective plane; exact q=5,7,11,13 tables tracked → [report](../2026-07-14-c174-general-six-subset-identity.md) |
| **C175** | queued, independent | classify concurrency-free conic six-sets across small q; not a C155 gate |
| **C177** | queued, independent | test whether local Mathieu systems on the point-regulus conics of `D_Hex(11)` glue to a `2-(1332,6,240)` or oriented `2-(1332,6,120)` design; not a C155 gate |
| **C178** | reported, closed-negative and independent | exact reconstruction gives 110 Wu conics in two orbits; their passant-join clique numbers are 4 and 3, hence no six-set → [report](../2026-07-15-c178-wu-internal-conic-cliques.md) |

**Cross-lane seam:** C155 owns the hexad theorem and C174 owns the general identity, whose q=11
specialization is `t(H)+|U(H)|=82`. Clebsch C167 may cite that identity to explain its on-conic
spectrum, but must not absorb the hexad theorem or claim it twice.
The Clebsch transversality aside is not a substitute for C155 and should be cut or reduced there.

Clebsch C184/C187 now supply two additional one-way imports: C159 uses C184's q11 low-degree atlas
as seed data, and C160 uses C187's q5 equality as settled computation. Neither import expands C155.
C187 also does not advance the BSW exterior-set conjecture: joins missing the conic is weaker than
covering every off-conic point, and BSW's external-only hypothesis is not C187's classification
problem. See [C190](../2026-07-15-c190-gem-clebsch-routing.md).

**Entry doc for the lane.** This handoff is the map: what the lane owns, what is settled, what is
open. Read alongside it:

- [gap-mining method](../2026-07-15-gems-theory-gaps-method.md) — the method for mining **questions**
  rather than objects: transport triples, dictionary tiers, and a move ordering that prices novelty
  per region instead of per claim, to invert the back-loaded literature gate that blocks C155. Its
  product is a reading budget, not a reading exemption. Adversarially reviewed in
  [the Fable pass](../2026-07-15-gems-theory-gaps-method-fable.md), which the method incorporates;
  read the method's § Overturned claims before re-proposing anything it rules out. No cells mined
  yet — the ledger and the backfill gate in § First steps are the record.
- [discovery track](../2026-07-15-gem-discovery-track.md) — append-only log of incidental findings
  thrown off by mining probes, against a declared null. A killed cell's computation is not wasted,
  only its verdict is; this is where the byproducts land and where question-mining feeds back into
  the object generator.
- [gem mining next steps](../2026-07-14-gem-mining-next-steps-fable.md) (§1–§12) — the strategy and
  the computed census. **Carries known errors**, corrected inline; the vet supersedes it where they
  disagree.
- [gem-program vet](../2026-07-14-gem-program-vet.md) — the adversarial audit. **§2.1 is a row-by-row
  impact map of the `clebsch` `.tex`**; §3 is the abandon/downgrade list; §4 the gem list.
- [novelty status tables](../2026-07-14-novelty-status-review-summary-tables.md) — what may still be
  novel, what the literature gives us as infrastructure, what we thought was novel and isn't, and the
  do-not-cite list. **Start here for the current state of any claim.**
- [C153–C160 queue rationale](../2026-07-14-c153-c160-queue-rationale.md) — why each queued item
  exists, its search directions, and what was deliberately not queued.
- [consolidated literature report](../2026-07-14-literature-sweep-consolidated.md) — all six sweeps
  in one place: what was searched, what was found, **the unread ledger** (every claim still
  conditioned on a source nobody has opened), the citation traps, and the coverage gaps. **Read this
  before commissioning any new search.**
- Literature sweeps: [hexad](../2026-07-14-gem-lit-hexad.md),
  [exterior sets](../2026-07-14-gem-lit-exterior-sets.md),
  [ω_arc](../2026-07-14-gem-lit-omega-arc.md) (⚠ known errors — banner in file),
  [deep holes](../2026-07-14-gem-lit-deep-holes.md),
  [orbit classification](../2026-07-14-gem-lit-orbit-classification.md),
  [rigidity/gap](../2026-07-14-gem-lit-rigidity-gap.md).
- [C147 report](../2026-07-14-c147-hexad-polarity-characterization.md) — the hexad result, its proof
  structure, and the q=23 negative.

## What this lane is

The Clebsch hexagon is one hit. This lane exists to produce a second one on purpose. Its scope is
the *generator* — the machinery that converts compute into candidate structure — plus the hunts that
machinery opens. Findings that land in the Clebsch manuscript belong to `clebsch` and are pegged
there; the boundary is deliverable, not subject matter.

## The method (§9 of the strategy note)

Four rules, each load-bearing in the session that produced them:

1. **Generator = a complete census, never a curated list.** The domain needs an exhaustion guarantee
   — machine-enumerable at each parameter, or classified in the literature. The test to apply before
   building any detector: *what does a miss buy?* Over a census, a miss is a theorem; over a list, a
   miss is worthless. This is what killed the fill-signature detector.
2. **Invariant = valued in another classified category**, so a hit lands on a name: deep-hole locus →
   curve type, residual graph → named graph, stabilizer → named group, concurrence defect → design
   membership. Same-category size-equalities are numerology by construction.
3. **Declare the null before looking.** A hypothesized gap is "the bulk sits at ≥ X for forced
   reasons; anything at X is caused." This converts noticing into predicting.
4. **Upgrade protocol on any hit, immediately**: stabilizer, distance to second-best, perturbation
   instability, the same invariant at the neighbouring parameter.

**The fill-signature detector (`notes/2026-07-13-gem-candidates.md`) is retired**, not re-keyed: it
fails all four rules, and C132's re-key prescription fixed only the invariant's side. Keep the table
as the record of a closed spike.

## Settled

- **The E_q reduction.** Fix the conic `C` in PG(2,q), q odd. `E_q` = graph on off-conic points,
  adjacent iff their join is external to `C`. An *arc-clique* is a clique with no 3 points collinear;
  a *healthy* arc is an arc-clique whose secants cover every off-conic point outside it — equivalently
  an arc whose deep-hole locus is exactly the full point set of a conic. This is group-free,
  complete, and cheap, and it retires C132's "does not exhaust every P¹ route" caveat.
- **The healthy census, exhaustive for primes q ≤ 37**: healthy arcs exist exactly at q ∈ {3, 5, 11}.
  q=11 is the Clebsch hexagon (all-external, stabilizer A₅); q=5 is the projective frame
  (all-internal, stabilizer S₄, a k=1 sibling the C126 family tree missed by testing the wrong
  orbit); q=3 is degenerate. Prime powers q = 9, 25, 27, 49 are unswept — q=9 matters.
  **Two of these are in Dye and are not open geometry** (2026-07-15, see § Dye warning above): the
  **q=5** frame is Dye 1991 §1.4, and **q=9** is Dye 1988's twelve internal-vertex hexagons with
  their two A₆-orbits of six. Read Dye 1988 *before* spending on a q=9 sweep; the census's framing
  and the coding reading survive, the geometry's novelty does not.
- **ω_arc census** (largest arc-clique): 3,4,4,6,6,6,6,8,10,10,10 for primes 3…37. Bounded by the
  pencil bound (q+3)/2, which is linear while the data look sublinear — that gap is unexplained.
- **Nonexistence for q ≥ 13 has no structural cause.** The crossing story (ω_arc falling below the
  covering threshold) is refuted: ω_arc ≥ n_min at q = 13, 23, 29, 31, 37, and the covering simply
  fails for finer reasons each time. Spectral routes are dead a priori — every external line is a
  (q+1)-clique, and E_q is not strongly regular (computed).
- **The object is classical.** It is the exterior-set geometry of a conic, with a lineage running
  Clebsch 1871 → Edge 1956 → Blokhuis–Seress–Wilbrink 1991/1992. The manuscript's citation debt is
  `clebsch`'s problem (C146); the conjecture is this lane's opportunity.

## Literature (swept 2026-07-14; notes `2026-07-14-gem-lit-{hexad,exterior-sets,omega-arc}.md`)

The pattern across three independent sweeps: **our geometric objects are all classical and we cited
the wrong ancestors; our coding reading of them is unclaimed.**

- **The paper's arc is Edge's.** Edge 1956 §§29–32 (read in full) constructs the q=11 object — six
  external points, fifteen joins skew to the conic — names them "Clebsch hexagons", and credits
  Clebsch 1871 for the real-plane antecedent. There are 22 of them over a fixed conic, each external
  point on exactly 2, organizing into two systems of 11 that each partition the 66 external points —
  the PGL∖PSL chirality motif again. BSW's "complete exterior set" of size (q+1)/2 is the same object
  renamed.
- **The covering fact is ours.** It appears in neither Edge nor Van de Voorde (both read in full).
  Conditioned on the two BSW originals, which are ILL-only and unread.
- **The hexad characterization is ABSENT from the literature**, and Edge is a false friend rather
  than a near-miss: his hexagons are 6 points chosen from the 66 *off* the conic; ours are 6 chosen
  from the 12 *on* it. His only on-conic Brianchon statement is at q=5, where the conic has exactly
  six points and no subset is chosen. He never mentions Mathieu, Steiner, or hexads.
- **Finiteness creates the phenomenon.** Halbeisen–Hungerbühler (J. Geometry 2024) study the same
  15-chord construction over ℝ/ℚ and find that no-accidental-concurrency is *generic* there, extra
  concurrence being measure-zero. Over F₁₁ it inverts: accidental concurrences are the norm, and the
  subsets avoiding them are exactly the Mathieu hexads. The question is not well-posed over an
  infinite field, so this cannot be a specialization of a classical fact.
- **Only one geometric hexad characterization exists** (Havlicek/Coxeter/Pellegrino's 12-cap in
  PG(5,3), hexads = hyperplane sections): different ambient space, incidence not concurrency. Curtis's
  kitten, Conway–Sloane, and Bailey use the same P¹(F₁₁) point set but never embed it as a conic.
- **ω_arc splits.** The all-external case *is* the BSW conjecture — their q=7 and q=11 examples match
  our ω_arc(7)=4 and ω_arc(11)=6, the first external validation of the census against independently
  computed ground truth. The **mixed internal/external case appears nowhere**: the literature is keyed
  to external points throughout and structurally cannot see the q=3, q=5, and q=19 configurations,
  which are all-internal.
- **Machinery aimed elsewhere.** Meagher–Spiga have character-theoretic spectra of the PGL₂(q)
  derangement graph, but for the whole group, not the involution class. Tranchida (2024) uses the
  identical involution↔point↔polar correspondence for a different question (product *order*, not
  elliptic-type). The commuting-involution-graph school never uses fixed-point-free adjacency. No
  source beats the pencil bound; ω_arc is not in OEIS.
- **The one existing coding link**: Van de Voorde connects sets-without-tangents to LDPC stopping
  sets. Nobody connects this object to MDS codes, covering radius, or deep holes.

**The census contributes nothing to the BSW conjecture — decided, not open.** Van de Voorde reports
the conjecture machine-checked for **q < 131**. Her two range statements are different claims, not a
contradiction: p.1 concerns the existence of non-linear (q+1)/2-exterior sets, checked to q < 131;
§3 states that within 11 < q ≤ 31 every such set contains three collinear points. A sweep to q=37
therefore recomputes inside an already-checked range. What remains of this lane's contribution is
the **mixed-type invariant** (absent from the literature, which is keyed to external points
throughout), the possibility of exact maxima, and the uninspected extremal-witness stabilizers. Do
not pitch the census as extending their range, and do not spend Rust effort on the sweep for that
reason. The correct citation for Van de Voorde is **Discrete Math. 311(20) (2011) 2253–2258** —
the arXiv journal-ref field for 1201.0484 is itself wrong, and the conjecture is **Combinatorica
1992**, not Giessen 1991.

**The deep-hole "first" is audited and survives.** No prior instance of a code's complete deep-hole
set being identified with the full rational-point set of a named positive-dimensional variety
(`2026-07-14-gem-lit-deep-holes.md`). ZWK's redundancy-4 result is a disjoint union of three
combinatorial families, not a variety-equality; in DMP's own examples the uncovered locus tied to a
named object is a single point or empty. Residual: Reed–Muller deep holes marked NOT SEARCHED, and
the two BSW originals remain unread.

## Queued work

C155–C157, C159, C160, C169, C174, C175, C177, C178, C190, C736, C737, C738, C740, and C741 are this lane's; C178, C190, C736, C738, and C740 are reported. C153 (`clebsch`), C154 (`relconic`), C158 (`cubic`) came out
of the same sweep. Rationale, search directions, and what was deliberately left unqueued:
[C153–C160 queue rationale](../2026-07-14-c153-c160-queue-rationale.md). **Only C153 and the running
external-source gates can cost the current novelty posture; the rigidity/gap checks are complete.

## Open frontiers

- **C147 — the hexad characterization: verified, explained, and singular.** *A 6-subset of the conic
  in PG(2,11) is a hexad of one of the two S(5,6,12) systems iff no three of its chords are concurrent
  off it.* Machine-checked end to end; literature verdict ABSENT at full-text level.
  **Proof structure found** (`notes/2026-07-14-c147-proof-structure.py`): a concurrent triple of
  chords is a perfect matching of H, hence an involution stabilising H with no fixed point in it, so
  `t(H) = 60 + #{such involutions}` — verified for all 924. PGL₂(11) has exactly four orbits on
  6-subsets, stabilisers C₅/V₄/S₃/D₁₂ contributing 0/2/3/4, and **the hexads are the orbit whose
  stabiliser has odd order**. This explains the gap at 61 (no stabiliser has exactly one such
  involution) and re-derives the classical `{0} ∪ QR` seed as `{fixed point} ∪ {5-orbit}`,
  66×2×2 = 264. **The four-orbit classification is published** — Cameron–Omidi–Tayfeh-Rezaie,
  "3-Designs from PGL(2,q)", *Electron. J. Combin.* 13 (2006) #R50, Thm 4, whose `g_k(H)` is our
  invariant and whose hypothesis covers q=11, k=6; the substitution reproduces our table exactly
  (`notes/2026-07-14-gem-lit-orbit-classification.md`). So the converse closes by citation plus a
  short involution-content argument, and no 924-case enumeration survives in the proof. Cautions:
  the S₃ oddity was a `D_n` notation clash and our table matches the classical list; **do not cite the
  genus-2 literature for the table** (it classifies geometric automorphisms, ours are F₁₁-rational —
  the 110-orbit is μ₆ geometrically and μ₆ ⊄ F₁₁); and CO-TR §8 needs p > 23, so it cannot support
  the 132+132 PSL/PGL split.
  **The octad analogue at q=23 is DEAD** and the reduction explains why: the mechanism needs
  `|H| = 2×3`, so that a concurrent *triple* is a *perfect* matching. At `|H| = 8` a triple covers
  only 6 of 8 points, determines no involution, and there are 420 triples to avoid instead of 15
  (minimum t = 295 against a null of 280). Not a Mathieu tower — a coincidence of small numbers.
- **ω_arc growth** — DOWNGRADED. The all-external half is a recomputation inside BSW's checked range
  (above); the residue is the mixed-type invariant and the uninspected extremal-witness stabilizers
  at q = 23–37. Lowest-ranked item in this lane, not the second-place bet an earlier pass called it.
- **k=4 / twisted cubic** — the one direction where a hit is a new *kind* rather than a sibling
  (the parent analysis says the family runs through k, not p). Plausibly pegs `cubic` when opened.
- **The U-atlas** — all n-arcs of PG(2,q) up to PGL₃(q) for small q, invariant = curve-fit of the
  deep-hole locus. Drops C132's genus-0 prescription, which was a restriction by fiat: elliptic-curve
  targets are the cheapest route to a new kind of gem. Its q11 seed is already complete through the
  C184 degree/rank table, including the exact quartic/quintic/sextic companions; C159 starts with the
  missing cells and must preserve C184's exhaustion boundary.

## Trust boundary

The census scripts are promoted and re-run: `notes/2026-07-14-c147-gem-sweep.py` and
`notes/2026-07-14-c147-mathieu-poles.py`, byte-identical to the artifacts that produced the reported
numbers (hashes in `2026-07-14-c147-hexad-polarity-characterization.md`). The census corroborates at
three independent points: the repo's own `check_q19_nonexample.py` (|U|=140), BSW's published q=7 and
q=11 extremal sizes, and Edge's 22 = 1320/60 hexagon count against the stabilizer-60 claim.
All five computation artifacts currently cited by the C147 report/handoff — those two scripts plus
`2026-07-14-c147-hexad-characterization.py`, `2026-07-14-c147-proof-structure.py`, and
`2026-07-14-c147-octad-q23.rs` — pass `git ls-files --error-unmatch`. C155 must retain this invariant:
no numerical claim may depend only on a session scratchpad or an untracked file, and its final
manifest records paths, hashes, commands, and expected outputs.

C174's additional verifier is
`notes/2026-07-14-c174-general-six-subset-identity.py`; it freezes the full q=5,7,11,13 joint
`(t,|U|)` tables and must likewise remain Git-tracked in the C155 manifest.

**The hexad claim is fully machine-checked** by `notes/2026-07-14-c147-hexad-characterization.py`:
both S(5,6,12) systems built and Steiner-verified, disjoint, swapped by every one of the 660 outer
maps, and the t=60 stratum equals their union exactly (264 = 132+132) with the gap at 61 confirmed.
The characterization and proof-structure scripts are fail-closed on their full spectra and orbit
tables; the latter uses order-independent representative keys.
The two-system form is forced — a polarity-defined invariant cannot separate systems that PGL₂(11)
exchanges — so it is a coherence check, not a weakness. The pencil bounds, the degenerate-conic
impossibility, and the torus-clique collinearity remain reasoned, not machine-checked.

**Companion log**: append dated riffs to `done/2026-07-14-gem-mining-archive.md` (create on first
archive).
