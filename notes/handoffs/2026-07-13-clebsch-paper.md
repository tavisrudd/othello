# Clebsch three-paper program

**Lane**: `clebsch`

**Date**: 2026-07-25

> **LIVE MAP ONLY.** The three-paper program below is the active publication
> path. The 37-page mega-paper and its evidence surface are preserved
> unchanged as a fallback, not as the active release target. Historical
> planning and review records are linked at the end.
>
> **ROUTING AUTHORITY.** This handoff is the single entry point for all active
> Clebsch paper work. No dated planning note, archived mega-paper verdict, or
> completed task report may override the order stated here.

## Current verdict

Paper I, *Deep-hole rigidity of the Clebsch hexagon code*, is a
warning-free 19-page candidate with a complete nineteen-row release surface.
It lives in `papers/clebsch-rigidity/`. The first user-launched C320 review
returned `NO-GO` and commit `3ed43a0d` repaired its findings. The separately
user-launched PDF-only post-fix review found one remaining enumeration-boundary
overstatement; commit `70fb1e7f` repairs it and its clean replay is green.
A fresh separately user-launched, context-free PDF review returned final
`GO`, with no blocking or material minor finding. C320 is complete; C182 is
the active Paper I archive/release task. A later editorial review's
Dye-bound rigor clarification and presentation findings are repaired on
current `main`. A subsequent elevation pass replaces four separate
small-arc counts by a universal chord-defect theorem, proves
$|\mathcal U(A)|=q+1\Rightarrow q<\binom{k}{2}$ together with a sharper
quadratic field-size barrier and the passant lower bound $q\ge2k-3$,
plus the stronger even-order oval obstruction, and classifies conic filling
through eight points. The last three fields are excluded by a complete
passant-edge-orbit search: over each of $q=13,17,19$, the maximum arc with
all chords passant has size six. Compact certificates and a separate
discriminant/backtracking replay agree. The regenerated nineteen-row release
surface now has sixteen checks.
The final dependency audit explicitly attributes the Clebsch-only
$c(A)=10$ value to Dye, restores the point-orbit subtraction, and uses that
orbit proposition in the uncovered-conic proof.
The closing copy-edit removes the unused discrepancy column and stale
perturbation-checker reference and adds the exact secant-covering
reformulation.  The final referee pass adds its necessary
$A\cap\mathcal Q(\mathbb F_q)=\varnothing$ clause, aligns the two dependency
tables, records all four non-Clebsch degree-four classes, and identifies the
complete $q=9$ Clebsch specialization of
$|\mathcal U(K)|=q^2-14q+45$.  The $q=5$ root is explicitly separated as
an exceptional-characteristic counting degeneration, not an instance of
the associated-conic construction.  The final consistency pass cites the
unique $K_6$ one-factorization, folds the $k\le5$ clause into Theorem 2.2,
harmonizes frame order, and routes the $q=9$ exclusion to Theorem 6.2.
The final claim-preserving editorial pass now foregrounds the unified
inverse statement---coarse decoding data reconstruct the hidden Clebsch
geometry---rather than presenting the abstract as a flat result list.  It
regenerated the statement identity, PDF, trust manifest, and release
certificate; the clean fifteen-check replay is green at `949ec7b2`.

The five prose--Lean synchronization findings are repaired.  The polarity
route, support-bipartition trust boundary, Dye theorem numbering,
icosahedral-local-data name, ambiguity wording, and public docstrings now
match the exact formal statements.  The formal gate passed at `6d4766d1`;
the manuscript and nineteen-row surface were regenerated at `59f6babe`;
the refreshed certificate and final clean fifteen-check replay passed at
`341fabbf`.

C605 is complete. Its report, exact search, compact certificates, independent
replay, and mystery ledger are in
`notes/2026-07-25-c605-eight-point-conic-filling-search.md`. The final clean
sixteen-check release replay is green at `91db7b5c`.

C610 is complete. Paper I now states the length-at-most-eight projective MDS
consequence, promotes C605's sharp maximum-six exterior-set arc bound, names
the exterior-set framework, and exposes the \(q=13\) passant-saturation
mechanism without adding a new evidence route. The warning-free 19-page PDF,
nineteen-row trust surface, and clean sixteen-check release replay are green
at `fd2dee6e`. C611 owns the broader conceptual mechanism and
v2/other-paper disposition.

C182 follows C610. Its blocker is external publication packaging. The
previously cited GitHub artifact URL is not publicly reachable, and this
workspace has no GitHub or Zenodo publication credential. The manuscript
now gives the exact Git-bundle replay command, stable checker and Lean-gate
hashes, and the two principal results with no Lean coverage; it must not
ship until that bundle has an immutable DOI or Software Heritage identifier
and the identifier is added to the paper.

C577 has begun under the permitted external-wait exception. Paper II now has
a standalone headline factorization theorem, marked-conic notation, the
general matching-secant quotient with proof, and the four-endpoint switch
mechanism. It also defines the three matching orbits explicitly and proves the
exact `3,6,10` rank theorem, distinguishing the full spaces in types `A_3`
and `B_3` from the canonical harmonic-plus-radial ten-space in type `H_3`.
An `ej` upgrade proves that the omitted five-space is exactly the middle
Fischer layer `Q H_2`; a coordinate-free reason that the finite `H_3` orbit
annihilates precisely this layer remains a nonblocking conceptual refinement.
A `tt` pass isolates the exact proof target:
`Delta_Q Phi(M) in F_11 Q`. Proving this covariant identity conceptually
would leave only ten-space spanning to the finite certificate.
The same pass promotes the uniform Coxeter-number formula
`dim W_T = h_T - 1 + 1_(h_T/2-1 even)`, whose three values are `3,6,10`.
C616 is queued as a nonblocking Paper II trust-boundary upgrade: prove the
radial-trace identity without coordinates and replace ten-space row reduction,
as far as possible, by equivariant nonvanishing on `1+4+5`.
Paper II now also proves the abstract radical--Hadamard recovery lemma,
specializes it to the `B_3` `7+7` and `H_3` `11+11` sheets without subset
enumeration, and proves that the first signed tensor orientation moment is
cubic and carries the outer character. The C406 and C430 primary certificates,
independent replays, and checksum gates are green. The six-profile section
now derives the `1,4,6 / 1,4,6` rows from subgroup marks, defines the
secant-incidence profiles, proves set-theoretic row separation despite the
rank-two image, recovers the `1,4,6` orbit weights from the three unlabeled
profile rays, forces the compressed cubic by a general three-ray lemma, and
derives its doubled-line/residual-line Hessian flag from the modular
mass-zero identity `1+4+6=0` while stating the exact singleton
matching/parent recovery boundary. The modular section now identifies the
depth plane as `P(1)^A4 / soc(P(1))`, separates its six-row set-theoretic
memory from its rank-two linear memory, and proves the frozen `A_3`
fused / `B_3,H_3` split arithmetic theorem with the
`A5 cap A5 = A4` and generated `PSL_2(11)` hinge. The canonical
relative-cubic Tate plane and its divided-transfer non-identification with
the depth plane are isolated in an appendix. Its clean fifteen-page build
is warning-free. The next drafting frontier is the Paper II verification
architecture and conclusion. The current theorem,
evidence boundary, and mystery ledger are in
`notes/2026-07-25-c577-clebsch-factorization-memory.md`.

The active order is strict:

1. **C182:** make the immutable public deposit and insert its identifier.
2. **C611:** pursue the broader exterior-set mechanism for v2 or its actual
   owning paper without holding v1.
3. **C577:** build and referee-test standalone Paper II after Paper I is
   submission-ready.
4. **C579:** test Paper III after Paper II; require one principal theorem or
   return the material to an inventory.

If C182 has passed every local gate and waits only for a user-controlled
DOI, licence, or repository-release action, C577 may begin without treating
that external wait as a Paper I defect.

C321 was not triggered: Paper I retains no load-bearing Singular claim.

The authoritative split records are:

- `notes/2026-07-24-clebsch-paper-split-trial.md` — three-paper charter and
  acceptance gates;
- `notes/2026-07-24-c575-clebsch-split-disposition.md` — exact source and
  content disposition;
- `notes/2026-07-24-c575-clebsch-trust-disposition.csv` — exact 58-row
  partition;
- `notes/2026-07-24-c576-clebsch-rigidity-candidate.md` — Paper I build,
  hashes, and referee assessment.
- `notes/2026-07-24-c182-clebsch-paper-release.md` — universal-bound
  elevation, release verification, and remaining archive blocker.

## Source roots and status

| role | root | status |
|---|---|---|
| Paper I | `papers/clebsch-rigidity/` | C320 final `GO`; C182 archive/release next |
| Paper II | `papers/clebsch-factorization/` | C577 active; standalone quotient/switch opening built |
| Paper III | `papers/clebsch-passages/` | exploratory spine; C579 gated behind Paper II |
| mega-paper fallback | `papers/clebsch-hexagon-code/` | preserved unchanged with its 58-row/18-check evidence surface |

Never rename, delete, repurpose, or silently filter the mega-paper fallback.
Its manuscript, manifest, aggregate gate, and release replay remain a
matched historical surface. Do not use them to certify a split-paper source
hash.

## Paper I — rigidity and decoding

Paper I owns:

- the code--arc dictionary and explicit Clebsch parity-check matrix;
- the syndrome conic, decoding oracle, automorphisms, and complete ambiguity
  census;
- symmetry-free rigidity, the sharp numerical and nearest-conic gaps, and
  low-degree rigidity;
- Brianchon reconstruction and the intrinsic unordered `10+10` invariant
  support bipartition;
- uniqueness at `q=11`, the Clebsch-family formula, and the
  `4 <= k <= 7` classification;
- the nineteen-row Paper I claim/evidence map and its future C320 release
  surface.

Paper I has no Paper II or Paper III theorem dependency. It omits the
optional `H_3` paragraph. Exhaustive computation is load-bearing only for
the numerical gap, low-degree strengthening, and terminal small-arc
exclusion; the conic-containment implication is conceptual.

Current build:

```text
cd papers
make -B clebsch-rigidity
```

Inspect `papers/clebsch-rigidity/clebsch_rigidity.log`, not the fallback
Clebsch log.

## C320 — completed Paper I trust gate

C320 means **Paper I only**. The implementation and clean replay are complete
in `notes/2026-07-20-c320-clebsch-trust-ledger.md`. The exact formal source
pin is `bf4fb39ab3c3b06c3f82c2c90d37077d7aa4c520`; the manifest is
`papers/clebsch-rigidity/verification/trust_manifest.json`.

The final verification surface is:

- `papers/clebsch-rigidity/clebsch_rigidity.tex`;
- the nineteen rows `2, 11--26, 29, 58` in
  `notes/2026-07-24-c575-clebsch-trust-disposition.csv`;
- the exact manuscript-facing map in C576's report;
- the broad fallback ledger only as a source of candidate evidence routes.

C320's implemented surface:

1. has the exact nineteen-row statement identity and manifest;
2. admits 24 Lean terminals and ten release-local exact checkers, with no
   Paper II, Paper III, or Singular route;
3. has a separate aggregate gate, axiom audit, canonical checker-output
   certificate, and fifteen-check clean release runner;
4. pins hashes, toolchains, the exact formal source commit, and manuscript
   correspondence while preserving the fallback surface byte-for-byte.

The first user-launched cold review returned `NO-GO`, commit `3ed43a0d`
repaired its findings, and its fifteen-check clean replay passed. A
separately user-launched PDF-only review then returned `NO-GO` on one
localized enumeration-boundary sentence; commit `70fb1e7f` repairs it and
its clean replay is green. A fresh separately user-launched context-free PDF
review returned final `GO`, found no blocking or material minor defect, and
independently reproduced the displayed 12-point uncovered locus,
syndrome-conic equality, and secant-index counts. C320 is complete and C182
is next.

The previous C320 `NO-GO`, 58-row manifest, 29-statement extraction, and
18-check replay belong to the mega-paper fallback. They are provenance and
evidence inputs, not the active C320 acceptance state. Do not resume the old
instruction to launch its reviewer.

## Paper II — factorization memory

C577 owns the standalone paper provisionally titled *Factorization memory
in a conic ideal: the `A_3`, `B_3`, and `H_3` configurations*. Its spine is:

1. conic matching products and the general switch/divisibility quotient;
2. the `A_3/B_3/H_3` configurations and ranks `3,6,10`;
3. balanced sheets and cubic-first orientation;
4. six-profile reconstruction;
5. modular depth quotient and arithmetic splitting/gluing;
6. a Paper II-specific verification architecture.

The opening bridge is fixed: Paper I reconstructs the Clebsch configuration
from its uncovered syndrome locus and decoding data; Paper II asks the
complementary reconstruction question of what marked secant data survives
common restriction to a conic. This is motivation, not proof inheritance.
Paper II defines its marked-conic objects and quotient independently and
must cite the final Paper I release rather than changing or extending it.

Current C577 drafting state: the opening bridge, headline theorem,
marked-conic definition, general quotient proof, switch identity, explicit
rank-three configurations, exact `3,6,10` theorem, balanced-sheet uniqueness,
cubic-first orientation, six-profile matching-row reconstruction, modular
depth quotient, arithmetic splitting/gluing, and the relative-cubic Tate
appendix are in the manuscript. Continue with the Paper II-specific
verification architecture and conclusion.

### Outward-consequence bridge

The introduction may use one compact paragraph to show that the rigidity
geometry has mathematical consequences outside the three-paper sequence.
Keep the interfaces and their strengths distinct:

| Destination | Exact earned connection | Placement and boundary |
|---|---|---|
| prescribed-hole arcs | Paper I's conic-filling equality and uncovered-locus reconstruction are the exceptional small-arc face of the general defect and forward/inverse reconstruction theory | Paper I keeps its existing proposition-level citation; C182 must resolve the public provenance target. Paper II may name the general framework as context, not import a proof from it. |
| projective cap game / CGT | This is the source problem as well as a consumer. Frame reduction and conic localization of the odd-plane game exposed the exceptional `q=11` six-arc. The `4<=k<=7` equality classification then leaves only the `q=5` frame and `q=11` Clebsch hexagon as full-conic seals. The `q=11` seed is a certified P-position whose conic extension complex is the icosahedron independence complex `1+12t+36t^2+20t^3`. | Present this as an origin-and-return loop, not a one-way application. It is a finite base case and response-packet template, not a proof of the all-odd-`q` cap-game kernel or the `(ON)` response theorem. |
| AME/LU | The `H_3` six-arc gives an `[6,3,4]_{11}` MDS code and hence a minimum-support stabilizer `AME(6,11)` state. Projective rigidity fixes the discrete geometric input; the separate AME/LU theorem proves the LU-to-LC and scalar-invariant conclusions. | Use the arc--MDS--AME dictionary as a genuine application. Do not suggest that Paper I proves LU rigidity, or that Paper II's quotient theorem is needed by the AME/LU paper. The detailed backward citation belongs in the AME/LU introduction when both releases are citable. |
| PRS beyond redundancy four | Both programs begin from projective syndromes as uncovered points/MDS extensions. The beyond-four paper shows that this geometric viewpoint scales to normal rational curves via Hankel systems and coherent polar flags. | This is reach of the method, not a corollary of Clebsch rigidity. Mention only as a continuation of the syndrome/uncovered-point mechanism; do not claim that the Clebsch equality or decoder proves a higher-redundancy classification. |

Paper II's working introduction now contains this paragraph. Add exact
bibliographic citations when its bibliography is integrated. Do not reopen
the final-GO Paper I bytes to add a program survey. Paper III may synthesize
these four avatars only if C579 first produces a principal theorem that makes
them consequences or applications; otherwise retain this map as editorial
routing rather than manuscript prose.

The projective cap game has no citable public paper yet. Any manuscript
mention must therefore be self-contained: define the normal-play rule
(players alternately adjoin a point while keeping an arc; no legal move
loses), state only the exact finite consequence proved in the local
argument, and do not ask the reader to recognize `C80`, `(ON)`, `K_Omega`,
or any internal program name. Those identifiers belong only in routing and
verification records.

The exact cap-lane return path is:

```text
odd-plane frame reduction and conic-localized escape
  -> exceptional q=11 six-arc / full-conic seal
  -> Clebsch rigidity and icosahedral continuation geometry
  -> A5 orbitals, edge-to-pair packets, and marked-response compression
  -> C80 strict-overload kernel K_Omega and the Rmax incidence packet
```

The proved C80 payoff is finite but substantial: `K_Omega` agrees with exact
P/N values on the exhaustive `q=5,7` residual domains, selects exactly the
135 P roots among all 210 raw `q=11` on-conic roots, and passes the stated
`q=13,17` frozen gates. On the 135 `q=11` P roots, `Rmax` contains a
lower-kernel response on all 2,720 certified marked edges. The Clebsch
geometry supplies the exceptional seed, symmetry, and compression language;
C80 separately supplies the game-value kernel and finite certificates.

Do not promote the return path to the uniform crown. The current C80 records
also prove that fixed-depth `capOK` absorption cannot scale: an `s`-cap with
`capOK` forces `q<=binom(s,2)`, so response depth must grow with `q` or use a
different P-guard. The q=17 marked-head exceptions split into five orbits,
and the observed `Rmax` bulk is boundary absorption rather than a proved
positive-overload exchange law. C82 therefore remains gated on a uniform
membership/response theorem.

### Paper I “teeth” candidate audit

Paper I already contains its two strongest broadly legible consequences:
decoder ambiguity reconstructs the Brianchon geometry, and a degree-at-most-
three vanishing test recognizes the Clebsch class. If the introduction or
conclusion is ever reopened, foreground those existing theorems before
adding another research program.

The only new outward examples strong enough to merit a Paper I sentence are:

1. **Simultaneous MDS extensions / complete arcs.** The twelve deep-hole
   directions have icosahedral conflict graph, with independence polynomial
   `1+12t+36t^2+20t^3`; its maximal faces give exactly six complete
   eight-arcs and twenty complete nine-arcs over the fixed seed. This is a
   direct, certified continuation consequence and has a public provenance
   route through the prescribed-hole arcs paper.
2. **Self-contained cap-game origin.** Define the placement game in one
   sentence, then say that the Clebsch seed localizes play to the icosahedral
   continuation graph and is a P-position by antipodal pairing. This is
   mathematically clean and explains why the object was studied, but because
   the cap-game paper is unpublished it must include its own definitions and
   the short argument.
3. **AME state.** The displayed `[6,3,4]_{11}` code gives the equal-phase
   minimum-support stabilizer `AME(6,11)` state by the standard MDS--AME
   dictionary. This fact is immediate and citable independently of the
   separate LU paper. Stop there: LU-to-LC rigidity and marginal separators
   are the AME/LU paper's theorems, not Paper I consequences.
4. **Algorithmic recognition / robustness.** Recast the existing
   low-degree and gap theorems as an exact recognition certificate: compute
   the uncovered syndrome locus and its cubic evaluation rank; acceptance
   identifies the Clebsch class, while a one-point perturbation changes at
   least eighteen locus points. This adds no claim and may communicate the
   strength better than another external application.
5. **Quadratic-Frobenius pair extension.** Regard the displayed
   `F_11`-rational hexagon as an invariant six-arc in `PG(2,11^2)`. Exactly
   76 `F_11`-lines avoid it, and each carries
   `(11^2-11)/2=55` nonfixed conjugate pairs. Because every old secant is
   fixed, all `76*55=4180` pairs are legal; after selecting one extension,
   the remaining `4179` are alternate pair repairs. This is a clean direct
   corollary of the Baer/Frobenius pair-extension mechanism. Its numerical
   count is shared by every `F_11`-rational six-arc, so present it as reach
   of the arc/MDS object, not as another Clebsch characterization.
6. **Positive-density complete repair ports.** For the Clebsch
   `[6,3,4]_{11}` code, the dual is `[6,3,4]`; at every target coordinate
   the minimum pointed dual word has weight four and
   `z_x=4+4=8`. The prescribed-port theorem therefore transfers the entire
   radius-five coefficient-valued port (`6<8`) to density `1/6` in an
   asymptotically good fixed-`F_11` concatenated family. Its minimal support
   clutter is the generic complete three-uniform hypergraph on five helpers
   (ten locality-three supports, matching number one, transversal number
   three). The potentially Clebsch-specific content is the coefficient
   layer: the normalized repair vectors through one target span `C^perp`
   and hence recover the inner code. Prove and trust-map that reconstruction
   lemma before claiming that Clebsch rigidity, rather than only generic MDS
   locality, survives transfer.

Do not use the following in Paper I: beyond-redundancy-four PRS (method
reach only), the Paper II Coxeter/reflection theorem (wrong owner),
Mathieu-hexad transversality (correct but decorative/negative), checked
isoduality (minor side fact), or the still-open orbit-labelled repair
hypergraph agenda. The exact complete-port transfer theorem exists, but its
Clebsch-specific coefficient-reconstruction specialization is not yet a
paper result.
Any new cap, extension-complex, AME, Baer-extension, or repair-port
theorem-like statement would change Paper I's nineteen-row trust surface
and require a fresh release review; a pure motivation sentence or reframing
of an existing theorem would not.

Forwarded to the owning papers on 2026-07-24:

- **complete-ports:** the manuscript proves that the full normalized
  pointed coefficient port reconstructs `C^perp`, instantiates `z_x=8`,
  and derives density `1/6` in an asymptotically good fixed-`F_11` family;
- **Baer/Frobenius:** the manuscript proves the exact `4180/4179`
  Clebsch-over-`F_121` extension/repair corollary.

Both papers cite *Deep-hole rigidity of the Clebsch hexagon code* as a
working paper and state their generic-MDS/generic-six-arc boundaries.
Neither forward bridge changes Paper I or reopens its final-GO release
surface.

Use C399 as the conic-phase prelude and C403/C406/C411 with selective C412
upgrades. Credit Edge and Dye for the exceptional configurations and avoid
novelty claims for the raw `5/14/22` marker spaces, parent ambiguity, the
`B_3` `3+6` split, or conic--GRS identification.

Treat the specialist review's proposed `SC(j)` repair as an unverified
hypothesis, not a patch: independently derive and check every
characteristic, equivariance, and quantifier condition before it enters
Paper II.

Primary planning inputs:

- `notes/2026-07-20-c399-literature-audit.md`;
- `notes/2026-07-20-c406-matching-module.md`;
- `notes/2026-07-20-c406-priority-audit.md`;
- `notes/2026-07-20-c411-double-coset-hecke.md`;
- `notes/2026-07-20-c412-relative-cubic-depth-plane.md`.

Passage, holonomy, torsor, theta/Fourier/quantum, Mathieu, and
characteristic-zero material is inventory-only during C577.

## Paper III — passages and holonomy

C579 tests the provisional *Finite passages and holonomy in Clebsch
matching geometry*. It may proceed only if one principal theorem organizes:

- carriers, orientations, and passage maps;
- exact survival and loss statements;
- the four-sheet cover and cycle holonomy;
- theta, Fourier, and quantum realizations;
- Mathieu and characteristic-zero bridges.

If no single theorem makes the comparisons consequences or applications,
stop drafting and return the material to a disposition inventory. Do not
lengthen Paper II to absorb it.

The preferred pre-allocation test, queued behind Paper II rather than active
now, is the degree-23 `M_{23}`/Golay coherence test proposed in
`notes/2026-07-24-c589-gateway-to-clebsch-memo.md`. Test whether the
degree-11 recovery-depth lattice extends functorially to the degree-23
instance. Coherence supplies a candidate principal organizer; failure keeps
Paper III inventoried. Allocate no successor ID until C579 reaches this gate.

## Shared verification and release policy

Each split paper gets its own statement identity, claim manifest, aggregate
gate, replay entry point, toolchain pins, adequacy appendix, and
AI/provenance disclosure. Shared Lean sources stay in the pinned standalone
Lean repository; no split paper inherits trust from the fallback aggregate
gate merely by importing related terminals.

Paper I ships after `arcs` supplies the public provenance target for the
shared deep-holes-equals-conic identification. C182 packages only the
C320-approved Paper I surface. Paper II and Paper III receive separate
release passes if and when they exist.

## Lane boundaries

This lane owns the three Clebsch paper roots, the preserved mega-paper
fallback, Clebsch checkers/reports, and exact Clebsch queue rows. It does not
own Baer, alternate-orbit, gem-mining, or crowns work. Results from those
lanes may be consumed read-only only when the split disposition explicitly
admits them.

The companion discovery log is
`notes/2026-07-14-clebsch-discovery-track.md`. Logging an observation does
not add it to any paper or allocate work.

## Historical records

- Retired mega-paper planning redirect:
  `notes/2026-07-20-clebsch-paper-planning.md`; the full superseded record is
  `notes/2026-07-20-clebsch-paper-planning-archive.md`. Neither is an active
  routing source.
- Mega-paper independent cold read:
  `notes/2026-07-23-c320-independent-cold-read.md` — fallback only.
- Former replacement-spine abstract and presentation drafts:
  `notes/2026-07-21-clebsch-paper-abstract-outline.md`,
  `notes/2026-07-21-clebsch-paper-guided-tour-conclusion-draft.md`,
  `notes/2026-07-22-clebsch-geb-design.md`, and
  `notes/2026-07-22-clebsch-geb-design-red-team.md` — fallback/history,
  not active split-paper instructions.
- Full accumulated handoff history:
  `notes/handoffs/done/2026-07-13-clebsch-paper-archive.md`.
