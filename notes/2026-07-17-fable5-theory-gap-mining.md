# Fable 5 theory-gap mining: prospective transport-triple sweep

**Lane**: `gem-mining`

**Date:** 2026-07-17
**Status:** PROVISIONAL — mining output, not vetted; per the method's trust boundary the mine does
not commission its own vet. Nothing here is load-bearing, citable, or promotable until a
user-launched vet passes over it.

**Method:** [gap-mining method](2026-07-15-gems-theory-gaps-method.md). Every cell below was
scored prospectively (nulls, factoring checks, and promotion priors frozen to a scratch record
before any search output was read), then run through the cheap kill-order prefix: statable null →
factoring check → naturality → search-to-kill → answer-keyed search where a key existed. Seed
cells came from an L0 brainstorm treated as model memory throughout; every literature claim below
carries its own L-level. Search sweeps with no hits are L1 and are marked as near-worthless
absence support wherever they appear; search positives are recorded as immediate kills.

**Scope exclusions applied:** cryptography/secret-sharing, security applications,
blockchain/distributed ledgers, and quantum computing/QEC far sides are excluded by charge. One
dictionary landed there and is recorded as excluded in one line (cell N1).

## Ledger

Owned objects: `seqcl` = sequential radius-r Horn/peeling closure on matroids (rp-next);
`a_k(M,x)` = pointed repair profile; `inert-seed` = nucleus-gated spanning-but-propagation-inert
witness family; `cubic-spec` = twisted-cubic transversal spectrum; `baer-eq` = Baer equivariant
robust completion; `hexads` = conic hexads (gem-mining).

| # | Cell `(O, D, q)`                                                        | Declared null                                        | Cause class / named cause                  | Kill stage | Verdict                          | Evidence |
|---|-------------------------------------------------------------------------|------------------------------------------------------|--------------------------------------------|------------|----------------------------------|----------|
| R1 | `seqcl` / matroid→graph / zero forcing: forcing closure = rank closure  | known-under-another-name (matroid ZF exists)         | social-thin, fame asymmetry (s4)           | step 4     | SURVIVES-TO-GATE (re-keyed)      | L2       |
| R2 | `seqcl` / rigidity matroid→sensor nets / sequential localizability      | known (trilateration literature is this)             | dense                                      | step 4     | DEAD — Eren+ 2004, Aspnes+ 2006, wheel extensions | L2 |
| R3 | `seqcl` / matroid circuits→Horn CNF / bounded-radius propagation completeness | trivial (Horn ⇒ PC) or known-under-our-name    | social-thin + invariant-postdates (s7+s4)  | survived   | SURVIVES-TO-GATE                 | L2       |
| R4 | `seqcl` / algebraic matroid→completion masks / sequential vs global completability | known ("closability" exists)              | dense                                      | step 4     | DEAD — Király–Theran–Tomioka JMLR 2015 "closability"; Cossé–Demanet rank-1; Singer–Cucuringu | L2 |
| R5 | `a_k(M,x)` / →Lorentzian machinery / is `a_k` log-concave               | corollary (of ULC/morphism results) or false         | s7 (pointed invariant is the lane's); machinery dense, instance unfound | survived | SURVIVES-TO-GATE (conditional)   | L1/L2    |
| G1 | `cubic-spec` / RNC→secants+tensor rank over F_q / exceptional rank loci | known (F_q rank classification exists)               | dense (active, OA)                         | step 4     | DEAD — Lavrauw–Zullo 2024; Davydov–Marcugini–Pambianco orbit corpus; arXiv:2312.07118 | L2 |
| G2 | `baer-eq` / →subspace codes / equivariant extension, cohomological obstruction | known (extendability classical) or vacuous    | structural, definitional keying (s2)       | survived   | SURVIVES-TO-GATE (equivariant slice only; composed dictionary, image unchecked) | L1/L2 |
| G3 | `inert-seed` / →GNN & LOCAL bounds / info-sufficient locality-unreachable families | known genre                               | dense                                      | step 2     | DEAD — factors through LOCAL lower bounds (Linial; Loukas ICLR 2020); fails forced-to-care | L2 |
| G4 | `hexads` / →S(5,6,12)→ternary Golay+M₁₂ / (method doc item 4)           | — (only gate accessibility advanced)                 | (per method doc)                           | —          | GATE MEASURED: obtainable via OA substitutes | L2 |
| N1 | matroid ports / →access structures / ideality-style questions           | —                                                    | —                                          | step 0     | EXCLUDED BY SCOPE (secret sharing) | —      |
| N2 | harmonic cascade / →bootstrap percolation on designs / random-seed SQS threshold with nucleus gate | known-under-another-name ("spreading sets") | social-thin + parameter regime (s4+s5) | survived | SURVIVES-TO-GATE | L1/L2 |

Kill details for the dead cells (killer citations at title/abstract level, L2, from the search
records in the session scratchpad):

- **R2.** Sequential localizability is an existing program: Eren–Goldenberg–Whiteley et al.
  (INFOCOM 2004, trilateration graphs), Aspnes et al. (IEEE TMC 2006 — NP-hard even for globally
  rigid instances), Yang–Liu wheel extensions and arXiv:1308.6464 "Beyond Wheel Extension",
  surveyed in Jackson–Jordán 2009. The full characterization is open, but it is that community's
  open problem, not an un-asked question; nothing in the lane's matroid machinery visibly
  advances their frontier. Recorded kill prevents re-mining.
- **R4.** Király–Theran–Tomioka (JMLR 2015, OA) already contains "closability" — entry-at-a-time
  propagation — explicitly contrasted with algebraic-matroid closure; rank-1 propagation
  completeness via bipartite connectivity is classical (Cossé–Demanet); local vs global at
  rank ≥ 2 is Singer–Cucuringu (arXiv:0902.3846) and Jackson–Jordán–Tanigawa. The seed question
  is their vocabulary already. Residual note-grade lead: exact characterization of masks where
  closability strictly lags closure at fixed rank ≥ 2 appears open *inside their program*; our
  gap witnesses could serve as examples, but nobody is forced to care about a matroid-side
  witness there.
- **G1.** Rank/identifiability over finite fields is an active, OA seam: Lavrauw–Zullo, "Waring
  identifiable subspaces over finite fields" (J. Algebraic Combin. 2024, arXiv:2207.13456);
  symmetric tensor decomposition over F_q algorithmics (arXiv:2605.12295, 2401.06857, 2502.12390);
  the twisted-cubic orbit classifications of Davydov–Marcugini–Pambianco implicitly carry the
  n=3 rank stratification, and binary quartics are done (arXiv:2312.07118). The seam is populated
  and working; dense — skip. Residual: whether the lane's transversal spectrum adds anything to
  their tables was not assessed (would need an L3 read; not priced here because the cell is dead
  as a gap).
- **G3.** The transported pattern factors through the standard locality-lower-bound genre: Loukas
  (ICLR 2020, arXiv:1907.03199) imports LOCAL lower bounds (Angluin, Linial, Naor–Stockmeyer)
  into GNN impossibility; Xu et al. and Morris et al. give the 1-WL cap. Killed at the factoring
  check, and independently by the forced-to-care predicate: one more hard family changes no
  belief in that community without a benchmark-scale packaging effort this program will not fund.

## Survivors, ranked

### 1. R3 — bounded-radius propagation completeness of matroid Horn CNFs

`(O, D, q)`: sequential radius-r Horn closure; dictionary = matroid circuits → definite Horn
CNF, **earned on our side** (the lane's encoding) and now **documented on the far side** —
Bérczi–Boros–Makino, "Matroid Horn functions" (JCTA 2024, arXiv:2301.06642, OA, in the shared
lit cache), where forward chaining over the full circuit representation computes matroid
closure. Question: *for which matroids (and which bounded-circuit-width / bounded-radius
subrepresentations) is unit propagation complete for entailment* — the knowledge-compilation
community's propagation-completeness question (Bordeaux–Marques-Silva 2012) instantiated on the
one CNF class whose propagation is matroid closure.

- **Nulls refuted.** *Trivial*: false — definite Horn does **not** imply propagation-complete; a
  4-variable 2-clause Horn counterexample circulates in the Čepek–Kučera line (AIJ 2013)
  [L2, search snippet]. Horn is unit-*refutation* complete (Gwynne–Kullmann, JAR 2013, OA), which
  is the weaker property; the PC question has content. *Known-under-another-name*: the citer set
  of BBM was enumerated — four citing papers, the only propagation-adjacent one being Savický
  (TCS 2026, arXiv:2309.01750, ucp-irredundancy, not matroids, not PC) [L2, enumerated closure].
  *Known-under-our-name*: the lane's closure-vs-span theorems are about radius-r closure vs rank
  closure; PC is a strictly different predicate (entailment of *all* clauses, not just unit
  consequences), so the owned results do not already answer it — they feed it.
- **Cause named + out-of-sample prediction.** s7 (the bounded-radius family is the lane's, days
  old) + s4 (matroid theory and knowledge compilation met only in 2023 via BBM). Prediction: no
  BBM citer treats propagation completeness or width — confirmed on the enumerated closure
  [L2]. The instrument caveat applies: citer enumeration under-indexes (method § Instruments),
  so this confirmation is a lead, not a reading.
- **Value predicates.** Re-keys a corpus in both directions: our inert-seed witness family
  becomes, if the translation holds, an explicit certificate of PC-failure for a structured CNF
  class the KC community can name; their PC machinery (empowering implicates) becomes a tool on
  matroid closure. Dual audience: SAT/KC (they classify PC classes) and matroid optimization
  (BBM's own audience). Non-specializable: PC of the matroid class does not follow from any
  char-0 or generic statement. Mechanism has a parameter (radius r, circuit width).
- **Seam thinness.** Four indexed citers of the seam's founding paper, none on the question
  [L2]. Thin by any reading, with the standard under-indexing caveat.
- **Gate accessibility.** BBM, Savický, Gwynne–Kullmann, ALOV-adjacent background: all OA. The
  one identified dark spot is Čepek–Kučera-line "Complexity issues related to propagation
  completeness" (AIJ 2013, paywalled) — a preprint hunt is part of the bill, and the cell does
  not die if it stays dark (the counterexample is reproducible from the snippet and checkable by
  hand). Not thin-and-dark.
- **Reading bill (bounded).** (1) BBM full text — already cached, zero fetch cost. (2)
  Bordeaux–Marques-Silva 2012 (PC definition + empowering implicates; OA copies circulate).
  (3) Savický arXiv:2309.01750. (4) Čepek–Kučera AIJ 2013 if obtainable. Four items, three
  known-OA.
- **Cheapest next probe.** Translate the lane's nucleus-gated inert-seed witness into its circuit
  Horn CNF and machine-check whether it witnesses PC-failure (an empowering implicate that unit
  propagation misses) for the bounded-radius subrepresentation — one small script over an object
  the lane already owns; a positive turns an owned witness directly into far-side coin, a
  negative teaches where the two predicates come apart.

### 2. R5 — log-concavity of the pointed repair profile

`(O, D, q)`: `a_k(M,x)` = number of k-subsets of `E−x` whose closure contains x; dictionary
earned (C227 identifies `S_x(u)` with a Las Vergnas perspective specialization); question =
log-concavity / ultra-log-concavity, standard on the Lorentzian side.

- **Nulls.** *Corollary*: live and unrefuted — this is the survival's condition. The nearest
  hammer found is Eur–Huh, "Logarithmic concavity for morphisms of matroids" (OA), which proves
  log-concavity for Las Vergnas polynomials of morphisms; since `S_x` is a Las Vergnas
  specialization for the morphism `M → M/x`, the cell may close *by citation* at the first read.
  That outcome is not a failure: it converts gap-review item 3 into a cited theorem for the
  pointed-Tutte paper at the cost of one read. *False*: unrefuted; no counterexample sought yet.
- **Cause + prediction.** s7 — the pointed profile as a named invariant is the lane's. Prediction:
  the exact sequence "k-subsets whose closure contains a fixed element" appears nowhere under any
  name — searches found the unpointed machinery (ALOV III ULC of independent sets; Brändén–Huh
  Lorentzian polynomials; Lenz; spanning-set ULC as an unnamed dual) but not the pointed instance
  [L1 for the absence — near-worthless as support, stated as such; L2 for the positives].
- **Value.** High if true and not a one-line corollary: per the gap review, the prestige outcome
  of the rp-next program; even as a data-verified conjecture it strengthens the pointed-Tutte
  paper. Weak on "re-keys a corpus" (it adds an instance to a hot program rather than
  reinterpreting one) — this is the factor a vet should push on.
- **Seam.** Dense machinery, unfound instance. The method reads dense as skip for *seam-mining*;
  this cell is conjecture-shaped, and its gate is a single bounded read plus compute, so the
  dense-skip rule is not the binding constraint. Flagged for the vet as a deliberate deviation.
- **Gate accessibility.** Everything OA (Eur–Huh, ALOV, Brändén–Huh preprint, Lenz). The Las
  Vergnas morphism-Tutte source paper is in the shared lit cache already.
- **Reading bill.** Eur–Huh (the one section stating the log-concave coefficient sequences), plus
  the cached Las Vergnas paper to pin the specialization. Two items, both obtainable.
- **Cheapest next probe.** Compute: log-concavity check of `a_k(M,x)` over every committed
  uniform/cubic/harmonic profile in the rp-next certificates — data already in the repo, an
  afternoon script, and a single failure kills the conjecture before any read is spent.

### 3. N2 — random-seed cascade thresholds on Steiner systems (new cell, earned)

`(O, D, q)`: the harmonic-family Horn cascade on `S(3,4,q+1)` with a nucleus gate; far side =
bootstrap percolation / weak saturation. Found while killing the seeded threshold question: the
**deterministic** half is already named on the far side — "spreading sets" in Steiner triple
systems (Nagy–Szemerédi, J. Combin. Des. 2022, arXiv:2103.00922, OA; also arXiv:1906.03149) is
exactly cascade-closure seeding studied extremally [L2]. The **probabilistic threshold** version
on designs (random seeds on STS/SQS, a fortiori with a nucleus gate) returned nothing in any
sweep [L1 — near-worthless as absence support, but the deterministic anchor gives the seam a
name and a venue].

- **Nulls.** *Known-under-another-name*: refuted for the probabilistic question at L1/L2 —
  spreading sets are extremal, not threshold; the bootstrap-percolation community works lattices,
  grids, random graphs/hypergraphs, and `K_n`-bootstrap, not design ground sets (their surveyed
  problem lists; L2 titles). *Trivial*: for the cubic family the threshold collapses to the span
  threshold (C236) — so the *harmonic* family with its real closure/span gap is where the content
  is; a vet should check the question does not trivialize there too.
- **Cause + prediction.** s4 + s5 (parameter regime: design-structured rule systems sit outside
  the ground-set families that community computes on). Prediction: no bootstrap-percolation paper
  samples a Steiner system as substrate — held across the sweeps run [L1/L2].
- **Value.** The gap review (item 4) argues well-posedness and names the serial-bottleneck twist;
  the spreading-set anchor now supplies a far-side venue and a citable adjacent literature, which
  is what the review's version lacked. Dual audience: probabilistic combinatorics + the design
  community that already owns spreading sets.
- **Gate accessibility.** All identified seam papers OA.
- **Reading bill.** Nagy–Szemerédi arXiv:2103.00922 (their bounds and whether they transfer from
  STS to SQS), one bootstrap-percolation survey section (Balogh–Bollobás–Morris line, OA).
- **Cheapest next probe.** Answer-keyed: extract the exact small-case cascade thresholds from the
  rp-next reports (not done this session — no numeric keys surfaced in the handoff-level grep)
  and run kill step 7 on those values before anything else.

### 4. R1 — zero forcing / power domination vs matroid sequential closure

Re-keyed by a search positive that is not a kill: no matroid generalization of zero forcing
surfaced, and the AIM zero-forcing problem list reportedly poses the zero-forcing↔matroid
relationship as an open problem [L2 — verify at the source before any use]. The cell therefore
converts from "un-asked question" (dead as such — the far side has asked it) to "asked-and-open
question the lane owns candidate machinery for": sequential radius-r closure, the 2-sum
interface calculus (their cut-vertex reductions are the graph shadow), and probabilistic
thresholds (their probabilistic zero forcing exists: arXiv:1909.06568, 2208.12899 [L2]).

- **Near-misses to price first**: skew zero-forcing closures that are matroid closures
  (arXiv:2303.17419) — the one paper that already crosses the seam and the place a scoop would
  hide; connected forcing vs greedoids (arXiv:1607.00658); rigid linkages via forcing
  (arXiv:1808.05553). All OA.
- **Cause + prediction.** s4; the prediction (no object-level crossing) is *partially* broken by
  arXiv:2303.17419, which is why that paper heads the bill.
- **Value.** Strong on forced-to-care (the far side wrote the open problem); weaker on re-keying
  until the dictionary is validated.
- **Reading bill.** The three arXiv papers above + the AIM problem-list entry. All obtainable.
- **Cheapest next probe.** Dictionary validity: check on small graphic matroids whether radius-r
  sequential closure restricted to graphs reproduces any established forcing variant (standard,
  skew, power domination) — a factoring computation, not a read; if none matches, the transport
  is a new rule for their taxonomy rather than a translation, which changes the pitch.

### 5. G2 — equivariant completion of partial spreads / subspace-code extension

Coarse form dead on schedule: partial-spread completion is classical
(Beutelspacher/Bruen/Blokhuis/Metsch deficiency thresholds; Heden's searches) and
constant-dimension-code extendability exists (Nakić–Storme, DCC 2015) [L2]. The surviving slice
is exactly the seeded refinement: **completing a group-invariant partial spread equivariantly**,
and any cohomological obstruction language for completion. Searches found construction/search of
invariant partial spreads (arXiv:1607.03371; Leonard's PG(3,7) classifications) but no
equivariant-completion problem and no cohomological-obstruction literature [L1 — stated as
near-worthless absence support].

- **Cause + prediction.** s2, definitional keying: the extendability corpus keys to cardinality
  maximality. Prediction: sampled extendability papers state no invariant-completion problem —
  sampled only at abstract level so far [L2]; a three-paper sample per the method's s2 protocol
  is part of the bill.
- **Caution — composed dictionary, image unchecked.** The owned object is equivariant *arc*
  completion in PG(2,25); the far leg (partial spreads → constant-dimension codes) is documented,
  but the near leg (Baer equivariant completion machinery → spread completion) is a composition
  whose image on our object has not been computed at any non-degenerate instance. Per the
  method's composed-dictionary rule, this cell may not enter as live until that check runs; it is
  recorded as SURVIVES-TO-GATE with the composite-image check as a *precondition*, ahead of any
  reading.
- **Gate accessibility.** Mostly OA (Honold–Kiermaier–Kurz corpus on arXiv); Nakić–Storme is
  paywalled — preprint hunt needed; not yet thin-and-dark but the one survivor with a dark risk.
- **Value.** Moderate: network-coding mathematics in scope; equivariance is the program's export.
  Weakest survivor on forced-to-care.
- **Reading bill.** Composite-image check (compute, no read) → Nakić–Storme (or preprint) → the
  s2 three-paper keying sample from the HKK corpus.
- **Cheapest next probe.** The composite-image check: state the smallest non-degenerate
  equivariant spread-completion instance reachable from the lane's Q25 machinery, or record that
  none exists and kill the cell.

## G4 — hexads → S(5,6,12) → ternary Golay / M₁₂: gate accessibility measured

The one unmeasured promotion factor named in the method doc (First steps, item 4) is now
measured [L2]: the primary Curtis 1984 "kitten" chapter is dark (no OA copy found; Academic
Press volume), and SPLAG / MacWilliams–Sloane are library-access books — but the leg-2
correspondence is carried by obtainable OA substitutes: E. A. Lord, "Geometry of the Mathieu
groups and Golay codes" (Proc. Indian Acad. Sci. 98, 1988, free at the publisher), Cameron's
open lecture notes, arXiv:1606.04857, and the Error Correction Zoo entry. Verdict for the
method doc: **not thin-and-dark**; the gate-accessibility factor is positive with the caveat
that leg-2 must be established from the OA substitutes rather than the dark primary. The leg-2
read itself (L0 in the method doc) remains unread; no promotion is claimed here. Note for the
vet: a "Lord 1988" full-text read already exists in this lane's record (vet §1.6) — whether it
is this same Lord 1988 should be checked before double-buying the read.

## New cells found via earned dictionaries (beyond the seed list)

- **N1 — matroid ports → secret-sharing access structures.** The repair-ports vocabulary maps
  natively onto the access-structure literature; excluded by scope (cryptography/secret-sharing)
  in this one line.
- **N2 — random-seed cascades on Steiner systems** (ranked survivor 3 above). The genuinely new
  content over gap-review item 4 is the far-side anchor: the deterministic problem already has a
  name and venue ("spreading sets", Nagy–Szemerédi), which converts the review's free-floating
  proposal into a cell with a measurable seam.
- **Earned-dictionary observation, no cell allocated:** the sweeps confirmed that the gap
  review's items 1–4 are re-derivable as transport triples from the lane's own invariants — the
  review and the dictionary method converge on the same four doors, independently. Recorded as
  corroboration of the review's ranking, not as new cells.
- **Answer-keyed probe not run:** the exact cascade-threshold values (kill step 7 keys for N2)
  were not extracted this session; a handoff-level grep surfaced no numeric keys, and deeper
  report reads were out of this pass's budget. Priced at one bounded read of the C219/C226
  reports.

## Nonclaims

This report proves nothing, allocates no task, and promotes no cell. Every verdict — including
every DEAD — is provisional pending an independent, user-launched vet; the seeded brainstorm it
prices was L0 throughout, and the search layer beneath the ledger is L1/L2 (titles, abstracts,
and enumerated-but-under-indexed citation closures), which supports kills far better than it
supports absences. No L3/L4 reading was performed except the cached Bérczi–Boros–Makino skim
(abstract + closure sections). The survivors' "reading bills" are prices, not commitments; the
"cheapest next probes" are candidate first steps for normally-allocated C-items, not started
work. Session search records (per-question queries, hits, and OA statuses) are in the session
scratchpad only and are deliberately not part of the durable record; anything load-bearing must
be re-established at its stated L-level by the consumer.
