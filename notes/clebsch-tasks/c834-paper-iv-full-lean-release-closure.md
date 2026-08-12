# C834 — Paper IV full Lean release closure

**Lane:** `clebsch`

**Status:** active; required dependency of C761 by author direction 2026-08-02

**Sequencing note (2026-08-03), informational — no action required of C834.** C860 stage 1 removes
the cap-game API (`CapGame.BuildGame`) from the Paper IV gate closure
`RelativeConicArcs.Gates.PassantCodeQ13`, and stages 2--4 relocate the remaining shared
projective-plane vocabulary into a documented `RelativeConicArcs` base. C834 must not audit,
document, or remediate any `ProjectiveCap` or `CapGame` module; a residual cap-game import in the
Paper IV closure after C860's stages is a defect to report to C860. See
`notes/2026-08-03-c860-execution-design.md`.

## Resume here (2026-08-08, full referee review)

The landed C834 proof packets are mathematically substantial and, where the current tree can replay
them, sound.  The task as a whole is nevertheless at **MAJOR**, not at final-leaf-plus-release
surfaces.  A full referee pass traced the task from allocation commit `432c1165` through task commit
`5a9104ac`: ninety-four relevant commits touching 237 paper/formal files, including 218 Lean files,
all dated C834 reports, the current gates, generated artifacts, manifests and release prose.

### What the referee accepted

- The shared semantic gate and its axiom audit are trace-current and green.  No source below
  `lean/RelativeConicArcs/PassantCodeQ13/` contains `native_decide`, `sorry` or a project axiom.
- `papers/q13-passant-code/verification/verify_evidence.py` passes every recorded generator,
  statement-shape check and independent replay.
- The paper package contains no `sorry` or project axiom and only the two `native_decide` calls in
  `PassantCodeQ13.MinimumWords.Exhaustion` remain.
- The association-algebra bridges, equivariance and transporter layer, ambient-plane join and meet,
  structural row-uniqueness proof, minimum-support arc transport, weight-ten replacements and anchor
  orbit packet are genuine upgrades.  No private task, agent, session or report reference was found
  in the formal artifact.

### Blocking referee findings

1. **The full package is not currently buildable from source on this host.**  The previous report
   diagnosed the failure as Lake scheduling the four orbit modules concurrently.  The referee ran a
   genuinely serialized build through the guarded queue.  `PassantCodeQ13.MinimumWords.OrbitS4`
   alone was OOM-killed with exit 137 at `7,032,004` kB.  A Lake job cap is therefore insufficient:
   the single declaration `supportOrbit_representativeS4_eq` is itself too large for the available
   clean-build envelope.  The four orbit identifications must be sharded or structurally replaced.
   Until that happens the latest claimed `77/88` axiom state is credible from the individually
   checked terminals but is not accepted as a replayed aggregate state.
2. **The current aggregate is a component gate, not the theorem-complete Paper-IV aggregate.**
   `PassantCodeQ13.Gates.Main` says this explicitly.  It does not yet prove minimum distance twelve,
   prove that every weight-twelve word belongs to the displayed 364-word family, or state the full
   reconstruction and automorphism theorem.
3. **Required packet 6 is absent.**  No source in the shared q13 library or paper package defines an
   `F8`/`Field8` carrier, the scalar action on the code, its dimension twelve over that field, or an
   equivalence with `F8^12`.  The quartic relation `B^4+B^3+B=0` only says that the cubic cofactor
   annihilates the image.  It is not the operator-field module required by the objective.
4. **Stage 5 item 13 is gated on an open theorem, not an implementation step.**  The arc theorem for
   the displayed 364 supports cannot be used to show that an arbitrary weight-twelve codeword is an
   arc, because the exhaustion is what must first put that word in the displayed family.  The bound
   `|S ∩ gS| ≤ 6` for a translate by the involution polar to an offending passant is a lead, not a
   proof.  A proof-producing certificate for all four original pencil-profile domains remains the
   mandatory fallback.
5. **The release maps have drifted.**  `verification/claim_map.json` still calls the incidence rank
   and relation squaring native; `verification/README.md` omits newer equivariance and automorphism
   modules; and the `hiddenField_cubic_on_image` docstring calls the cubic irreducible although the
   imported quartic module expressly proves no irreducibility statement.  These are stage-6/C857
   blockers, not evidence against the accepted mathematics.
6. **The old remaining-work sentence omitted theorem assembly.**  Beyond the fixed-point leaf and
   release surfaces, C834 still owes the arbitrary weight-eight and weight-ten exclusions in their
   manuscript forms, global transport of the fixed-point classification, spanning of the semantic
   code by each family, the complete theorem-level aggregate, and the hidden-field packet.  Human
   and classical boundaries permitted by this card must still receive exact statement/trust rows;
   they may not be silently described as kernel checked.
7. **Stage 7 has an ownership cycle as written.**  C834 is forbidden to publish externally, while
   the old plan postponed reversal of the pre-release accommodations until publication and also
   blocked C761 publication on C834.  C834 prepares an exportable theorem-complete companion; C857
   performs the exhaustive release-standard audit; C761 owns publication, pinned locators and the
   downstream forward commit that reverses the manuscript-only accommodations.

### Corrected execution order

1. **Restore bounded clean-buildability.**  Replace each monolithic orbit equality by a generated
   matrix-to-orbit-index table checked in bounded matrix blocks.  A generic theorem must prove that
   the checked table covers every normalized projective matrix and every displayed orbit member,
   then derive the semantic orbit equality/permutation used by the existing rank and concurrence
   consumers.  The generated table carries no trust.  Keep the public orbit theorem names unless a
   more semantic `List.Perm`/`Finset` interface removes the need for order-sensitive equality.
2. Rebuild `PassantCodeQ13.Gates.Main` and `PassantCodeQ13.Gates.AxiomAudit` from the repaired orbit
   boundary.  Treat further clean-build OOMs, especially the pair-concurrence blocks, as sharding
   defects rather than machine-state excuses.
3. Close `fixedPoint_slices_are_stabilizer_orbits` independently with a packed `28 × 78` action-index
   table and symbolic transport.  It does not wait on the hard exhaustion theorem.
4. Give the arbitrary weight-twelve arc route one bounded mathematical attack using passant parity,
   the polar involution and the minimum-distance intersection bound.  If it does not force zero-or-two
   passant intersections, stop that route and build a proved checker for the complete four-profile
   fixed-point domain.  Do not attempt the 1,344,675,925-node raw search in Lean.
5. Assemble semantic no-weight-eight and no-weight-ten theorems from the shared reductions, exact
   finite leaves and projective transport; then globalize the weight-twelve fixed-point classification
   to all 364 minimum words.
6. State and prove the complete minimum-layer and reconstruction consequences: the four intrinsic
   families, their spans equal to the semantic code, exact weighted-pair recovery, and the projective
   automorphism conclusion, with every retained human/classical seam named exactly.
7. Construct the hidden field: prove the cubic irreducible over the binary field, define its action
   on the rho-zero kernel/code, prove field dimension three and code dimension twelve over it, give a
   noncanonical linear equivalence with `F8^12`, and identify the three conjugate scalar actions.
8. Only then build the complete theorem aggregate and refresh statement identity, trust manifest,
   theorem-to-source map, axiom transcript, generated provenance, module inventory, public allowlist
   and rejecting verifier.  Exercise the clean-checkout build before handing the package to C857.

### Referee mystery ledger

- **Settled:** the earlier aggregate-build diagnosis was not a concurrency problem; one orbit
  declaration exceeds the available envelope by itself.  Owner: corrected step 1.
- **Open:** whether minimum distance and the polar involution force every weight-twelve word to meet
  each passant in zero or two points.  Exact gap: four fixed points of the involution leave room for
  zero or one further internal two-cycle under `|S ∩ gS| ≤ 6`.  Owner: corrected step 4, with the
  proved-checker fallback mandatory.
- **Open:** the operator quartic has not been promoted to the actual `F8` module.  Owner: corrected
  step 7.
- **Open:** three families are chord-indexed conics while the symmetric family has no equally
  intrinsic geometric description.  This does not block the frozen theorem; any new description
  belongs to a successor rather than C834.

### Execution update (2026-08-08, corrected steps 1 and 2 complete)

The orbit boundary now builds in bounded memory.  The deterministic orbit generator emits, beside
each displayed 91-support orbit, the position of every one of the 2,184 normalized matrix images in
that orbit.  Fourteen leaf modules check consecutive blocks of 156 matrices against all four tables
by kernel reduction.  The common symbolic assembler proves that the blocks cover the whole matrix
list and that duplicate removal recovers the displayed orbit, then derives the original four public
semantic orbit equalities without changing their names or downstream interfaces.

The decisive structural simplification is local block lookup.  The first implementation indexed the
full matrix and orbit-index lists at `start + offset`; memory therefore grew with the block's absolute
position, reaching 5,350,616 kB even after numerical sharding.  The landed checker reads
`(projectiveMatrices.drop start).getD offset` and the corresponding dropped index table, with one
symbolic theorem identifying local and absolute lookup in range.  Across the fourteen final leaves,
peak memory is 2,827,456--3,272,272 kB.  The aggregator peaks at 1,924,060 kB and the four public
orbit modules at 2,361,240--2,490,776 kB, replacing the old single-module OOM at 7,032,004 kB.

The repaired boundary was replayed through the package.  `PassantCodeQ13.Gates.Main` built in
17m37s at 5,548,812 kB, including the stale concurrence, exhaustion, row-uniqueness, association and
equivariance dependencies.  A clean audit build exposed two obsolete cached names; the audit now
tracks `Automorphisms.relationRowsRhoThree_certificate` and
`Automorphisms.anchorImageTriple_injective`.  `PassantCodeQ13.Gates.AxiomAudit` and its aggregate
trace pass, the orbit generator's byte-for-byte check passes, and the rejecting evidence verifier
passes.  The evidence manifest and module inventory record the new generated tables and shard
family.

Corrected steps 1 and 2 are therefore closed.  The highest-EV next move is corrected step 3:
`fixedPoint_slices_are_stabilizer_orbits` via the bounded `28 × 78` action-index table and symbolic
transport.  The theorem-completeness findings above remain open; this build repair does not change
the task's overall **MAJOR** status.

### Execution update (2026-08-08, corrected step 3 structurally closed)

`fixedPoint_slices_are_stabilizer_orbits` no longer uses native evaluation.  The deterministic orbit
generator now emits the 28 rows of 78 internal-point image indices for the normalized matrices fixing
internal point zero.  `MinimumWords.FixedPointStabilizer` checks every one of the 2,184 entries against
the symmetric-square action, proves by induction that folding a checked row equals semantic action on
an arbitrary encoded support, and reduces only the four compact table-orbit comparisons.  The public
theorem and its gate wrapper retain their names and statements.  `MinimumWords.Exhaustion` now has
only the genuinely open `fixedPoint_weightTwelve_exhaustion` native leaf.

The new module elaborates under the guarded single-thread runner in 1m46s; the regenerated data module
builds in 5.89s at 586,704 kB.  Generator byte identity and the full rejecting evidence verifier pass,
and the release inventory and evidence provenance include the table.  A complete downstream package
replay remains pending because a foreign multi-target Lean queue owns the shared build lock; this is a
replay condition, not a theorem or elaboration blocker.  The highest-EV mathematical move is now
corrected step 4: the bounded arbitrary-weight-twelve arc/parity attack, with the proved four-profile
checker as the mandatory fallback.

### Execution update (2026-08-08, corrected step 4 bounded attack closed; fallback begun)

The arbitrary-weight-twelve arc route does not close.  For the involution polar to an offending
passant, if `gS != S` then minimum distance gives `|S ∩ gS| <= 6`.  Four fixed support points on the
passant still permit zero or one complete off-axis two-cycle, and six fixed support points still
permit none.  More basically, before exhaustion the stabilizer of an arbitrary `S` is unknown, so
`gS = S` is a live branch on which the distance inequality is unavailable; importing the order-24
stabilizer of a displayed support would be circular.  The code kernel is not self-orthogonal, so no
generic intersection-parity constraint repairs the gap.  The bounded route is stopped.  Full audit:
`notes/2026-08-08-c834-polar-involution-bounded-audit.md`.

The proved-checker fallback has begun with a structural simplification.  The first three pencil
profile constructors are duplicate-free by their disjoint fibre/secant parameterizations.  The
fourth profile's only duplication is the six ordered decompositions of four secant points into the
two meet-in-the-middle pairs.  Requiring the left pair to contain the two smallest secant indices
selects one decomposition.  This removes both the per-match quadratic `eraseDups` test and the final
global `eraseDups`.  The independent exact replay now returns profile counts and distinct counts
`0,0,0,56`, with union size 56.  Guarded Lean replay is queued behind the foreign shared build lock;
after it passes, split the last native aggregate into three empty-profile kernel leaves, one canonical
fourth-profile equality leaf, and a symbolic assembler.

The queued source replay subsequently passed through `PassantCodeQ13.MinimumWords.Exhaustion` in
15m17s, including restoration of the orbit, concurrence and fixed-point-stabilizer dependency forest.
A direct whole-profile `decide +kernel` probe then exposed an architectural boundary: the meet uses
`Std.HashMap`, which is opaque to kernel reduction, so the `Decidable` instance remains stuck even
with increased recursion depth.  Numerical profile modules around the same definition would not be
proof-producing.  Replace the provisional four-leaf design by transparent fingerprint/witness
certificates: Lean validates coverage of each semantic half, uses symbolic equality-implies-equal-
fingerprint reasoning, rejects all absent lookups, and validates the unique full-syndrome/support
witness at each fourth-profile hit.  Natural shards are the distinguished fibre, fibre pair and
secant-pair residue.  The generated lookup tables are acceleration data, not trusted conclusions.

The first transparent-classifier leaf now validates that architecture.  The five-one profile was
factored into named semantic left and right halves.  A deterministic generator emits a balanced
decision tree for the exact left-half syndromes of distinguished-fibre shard zero, and
`MinimumWords.ExhaustionFiveOne.fiveOneShardCheck_zero` checks by kernel reduction that all 1,296
left candidates are accepted and all 216 right targets are rejected.  The leaf elaborated in 55.62s
at 2,590,464 kB.  No property of the generated tree is trusted.  Expansion to the other six
distinguished fibres was prepared but not claimed because the shared lane was then occupied by a
long foreign q=11 certificate build; land those leaves from this measured shard-zero boundary.

There is a stronger candidate than six duplicate leaves.  Exact replay of the already generated
28-row fixed-point action table shows that the stabilizer induces 14 distinct permutations of the
seven passant fibres and is transitive on them.  Stabilizer-row indices `0,9,5,3,2,4,8` carry fibre
zero respectively to fibres `0,1,2,3,4,5,6`; their complete fibre permutations are
`0123456`, `1025634`, `2314605`, `3645012`, `4132065`, `5463102`, and `6052143`.
Consequently the one checked shard can cover the entire five-one profile if a symbolic theorem
transports zero incidence syndrome under the fixed-point projective action and then repartitions the
six singleton fibres into the canonical shard-zero halves.  Prefer that theorem when it is smaller
than six further 55-second leaves; otherwise the already measured leaf family remains the bounded
fallback.  The transitivity computation is diagnostic only until Lean checks the transport.

A second structural reduction makes duplicated leaves cheap enough that transport need not block
progress.  Exact balanced membership trees were solving a stronger problem than required: the proof
only needs a Boolean function that accepts every left-half syndrome and rejects every right target,
and Lean checks both assertions over the complete domains.  Greedy decision trees on individual
syndrome bits compress the seven five-one classifiers from 18,181 lines / 784,996 bytes to 155 lines /
3,485 bytes.  They have only 13--23 nodes and depth six.  The same diagnostic construction gives
73--91 nodes at depth nine for sampled two-triple shards, 1,257 nodes at depth fifteen for a complete
one-triple/two-secant shard (4,320 left syndromes against 128,520 right targets), and 2,699 nodes at
depth seventeen separating the fourth profile's 336 hit syndromes from its 770,688 misses.  The hit
case can then use a separate 336-entry witness lookup.

The generator now independently refuses any five-one shard with a left/right syndrome collision,
and the compact seven-leaf Lean source is prepared.  Its guarded build is not yet claimed: the shared
lane remained continuously occupied by the foreign q=11 row sequence through at least `G17`, so the
waiter was stopped without bypassing or killing that build.  Resume by building
`PassantCodeQ13.MinimumWords.ExhaustionFiveOne`; if green, refresh the two evidence-manifest hashes,
replace the shard-zero-only README language, run the rejecting verifier, and commit the seven-shard
packet before extending the same bit-separator generator to the other profiles.

The bit-separator sizing is now complete enough to fix the remaining checker architecture.  Across
all 21 two-triple fibre-pair shards, separators have 63--117 nodes, depth 8--13 and 1,829 nodes total.
Across all seven one-triple/two-secant shards they have 1,239--1,709 nodes, depth 14--16 and 9,539
nodes total.  A fixed linear projection is worse: the first large third-profile shard needs 25
syndrome bits before its projected left and right images are disjoint, leaving 81,902 distinct right
states.  Keep the adaptive trees.  Bound kernel evaluation of the large right domains by the same
natural secant-pair residue split already used by the weight-ten checker; for the fourth profile,
combine seven pair residues with six first-tail choices if a 110,000-candidate residue leaf is still
too large.  The global fourth-profile hit separator has 2,699 nodes at depth 17; only its 336 accepted
syndromes proceed to an exact witness lookup, and the canonical pair split reduces those to the 56
claimed supports.

Implementation has advanced to the next replay boundary.  The seven five-one leaves now use the
13--23-node bit separators (3,485 generated bytes total), and the complete 21-leaf two-triple packet
is prepared from 1,829 separator nodes (48,453 generated bytes).  The generator refuses any shard
whose exact left-syndrome and right-target sets intersect.  These source changes remain deliberately
uncommitted and the manifest remains pinned to the last green shard-zero packet: the foreign q=11
queue continued serial row builds through `G19`, so neither new Lean module has yet received its
guarded elaboration.  Resume by building `MinimumWords.ExhaustionFiveOne`, then
`MinimumWords.ExhaustionTwoTriple`; update provenance and claims only after both pass.

The complete seven-classifier data for the one-triple/two-secant profile is now also prepared
(9,539 decision nodes, 312,888 generated bytes).  Its first measured target is distinguished fibre
zero with first-secant-index residue zero; expand to the 49 fibre/residue leaves only after that
prototype builds.  For the fourth profile, the earlier 2,699-node hit-versus-miss tree is not alone a
coverage proof: rejected right targets must also be proved unequal to every semantic left syndrome.
The correct global separator accepts all 128,520 left syndromes and rejects all 770,688 right misses;
it has 84,707 nodes at depth 23.  Shard that generated tree at its upper branches for elaboration, then
send only its 336 accepted intersections to the exact witness table and canonical-pair check.  A
fixed 25-bit projection was measured and rejected: it still leaves 81,902 distinct right states and
is structurally worse than the adaptive separator.

The third-profile prototype passed, but its first formulation peaked at 6,564,672 kB.  Splitting
left acceptance from right rejection removes the repeated 4,320-candidate left traversal from the
seven residue leaves of each distinguished fibre.  A second reduction avoids materializing the
18,360 concatenated right halves in a residue: the checker traverses the 216 fibre tails and the
residue's secant pairs as a product, XORing their component syndromes.  The analogous product form
was applied to the five-one and two-triple checks.  Guarded replay then measured 2,743,352 kB for
the complete five-one packet, 3,998,104 kB for the complete two-triple packet, and 4,756,736 kB for
the third-profile fibre-zero/residue-zero prototype, all green.

The complete third-profile source is now partitioned across seven distinguished-fibre modules.
Each module checks its left domain once and its seven first-secant-index residues in separate kernel
declarations; the first complete fibre module passed in 2m58s but peaked at 6,307,228 kB because its
largest residue contains 111 secant pairs.  Split every residue once more by the parity of its second
secant index before the final replay: the fourteen resulting pair blocks contain at most 58 pairs,
so they preserve the same total semantic domain while restoring a material clean-build margin.  An
exact diagnostic also found that, in each of the first three profiles, the union of all left
syndromes is disjoint from the union of all right targets.  Global separators for the first two
profiles have respectively 195 and 1,441 nodes, but they do not yet reduce the semantic-domain
checks and make individual shard evaluation deeper; retain the smaller local classifiers unless a
symbolic projective-action transport removes those repeated checks.  The 14 induced fibre
permutations are dihedral: they have one orbit on fibres and three seven-element orbits on unordered
fibre pairs, represented by `(0,1)`, `(0,2)` and `(0,3)`.  This can reduce the mathematical profile
representatives from `7 + 21 + 7` to `1 + 3 + 1` only after Lean proves preservation of zero
incidence syndrome and transport of the fibre/secant parameterizations; it is not used as evidence
for the current leaves.

That balanced split is now implemented using the low incidence-index bit of the second secant point,
so Boolean case analysis supplies its eventual coverage bridge without modular arithmetic.  The
generated modules now state explicitly that their trees are untrusted accelerators, identify the
tracked generator, and defer every semantic assertion to downstream kernel checks.  A separate
search-free soundness module proves XOR over concatenated halves, acceptance/rejection
incompatibility, and the three checker-to-syndrome-separation bridges.  The evidence manifest now
pins the generator and all three generated data modules, the referee inventory lists the complete
leaf family, deterministic regeneration passes, and the rejecting evidence verifier passes.  Lean
acceptance of the balanced leaves and the new soundness module is not yet claimed: two ordinary
guarded attempts exhausted their 120-second quiet wait on a persistent foreign `lake.orig` process.

## Superseded resume note (2026-08-07, latest before the full referee review)

Stage 5 items 11 and 12 are closed, leaving item 13 as the only native-evaluation leaf in the
package. The fourteen weight-ten profile shards are deleted and the gate now names the two
kernel-checked exclusions that already existed but had never been wired in: the isolated profile is
excluded over the complete Cartesian choice domain, and the two-regular shape by the manuscript's
geometric rejection. Both anchor decisions fell too: the forced fourth anchor reduces directly,
and the regular anchor triple orbit is decided as two tables of encoded pairs — one accumulated in
a single pass over the matrices, which also records that every entry it set was previously clear,
the other read off the displayed row masks of the relations of polar invariants three, nine and ten.
Set equality and injectivity follow, and the transport is symbolic. The new modules are
`Automorphisms/RelationRows.lean` and `Automorphisms/AnchorOrbit.lean`; the generator now emits row
masks for polar invariant three. All twelve affected terminals depend only on `propext`,
`Classical.choice` and `Quot.sound`. Report:
`notes/2026-08-07-c834-anchor-and-weight-ten-native-closure.md`.

Two things that round leaves open, both recorded in the report. The package gates were **not**
rebuilt: `MinimumWords.{OrbitS4, OrbitDihedralA, OrbitDihedralB, OrbitDihedralC}` have no compiled
artifact and are OOM-killed at about 6.6 GB against roughly 6 GB of free host memory, on five
attempts across every profile and affinity setting the guarded runner offers, because Lake schedules
those four jobs concurrently and the runner exposes no cap on its job count. That cap is a
`build-sys` request, not a C834 workaround. And the now-dead executable definitions of
`WeightTen/Base.lean` and the insertion-sort apparatus of `WeightTen/Aggregate.lean` are still
there, because editing that file invalidates the same unbuildable subtree; delete them in the first
window that rebuilds it.

## Superseded resume note (2026-08-07, arc closure)

The minimum-word supports are proved to be twelve-point arcs of the plane, structurally, and the
blockwise enumeration of the 364 supports against the 78 passant rows is gone. The new module is
`PassantCodeQ13.MinimumWords.SupportArc`: the symmetric square of a two-by-two matrix has determinant
the cube of that matrix's determinant, so an invertible matrix multiplies the coordinate determinant of
three triples by a nonzero factor and carries an arc to an arc; the arc property of a whole orbit
therefore follows from that of its representative, and each of the four representatives is decided over
its twelve coordinates in three positions. `geometric_rows_have_zero_triple_concurrence` now follows
because three internal points of a line have vanishing coordinate determinant. Retired: the three
`Concurrence.RowBlock*` modules, `geometric_rows_have_zero_triple_signatures`, the module
`RowUniqueness.PassantRowMasks`, and the passant-row bit-set definitions of `ConcurrenceBase`. Both
package gates and the evidence verifier are green; the audit reports 88 terminals of which 77 are
clean, and the 11 carrying a declaration-local native-evaluation axiom are exactly the previous ones.
Report: `notes/2026-08-07-c834-support-arc-structural-closure.md`.

Two things that round establishes for stage 5 item 13. Each of the three families with dihedral
stabilizer is a conic meeting the base conic in exactly two points, with its twelve remaining points
the support; the symmetric family lies on no conic. That explains the orbit size 91 and the stabilizer
order 24 for those three, makes their arc property immediate, and is a three-`decide` Lean addition
not yet made. And the fixed-point exhaustion is reachable only through the arc property: with it, the
seven-fibre stage has 22951 nodes and 10296 eight-point partial supports; without it, an exhaustive
search pruned only by the parity-deficit bound visits 1344675925 nodes, returning the same 56
codewords the Lean statement asserts. So item 13 must first prove that an arbitrary weight-twelve
codeword meets every passant in zero or two points, using only minimum distance twelve. Counting is
exhausted — the two identities give only "at most six passants carry four support points and at most
two carry six" — and the unexploited lever is that `S + gS` is a codeword, so `|S ∩ gS| <= 6` for every
`g` outside the order-24 stabilizer, applied to the involution polar to the offending passant.

## Superseded resume note (2026-08-07, later)

Stage 5 item 10 is closed, and structurally. `admissible_seven_set_is_geometric_row` is proved from
the Gram relation of four internal points instead of an indexed passant-clique search, and
`IndexCertificate`, `Aggregate`, `PairTransport` and the seven residue shards are deleted. Two new
modules carry the geometry: `RowUniqueness.BitangentSupport` proves that the off-chord points of
`C - nu L^2` are internal and, for an admissible pair, are one of the 364 displayed minimum-weight
supports — one `decide +kernel` exhaustion over the 183 dual triples and 13 field elements — and
`RowUniqueness.BitangentWitness` derives the chord from a trace pattern, identifying `4 F` with the
adjugate row sum of the trace Gram matrix and reducing the witness conditions to two nonsquare tests
in `ZMod 13`. `RowUniqueness.Transport` assembles them; `RowUniqueness.PassantRowMasks` carries the
row bit sets the semantic transports still need.

Both package gates build, the evidence verifier passes, and the axiom audit reports 84 terminals of
which 73 are clean; the 11 carrying a declaration-local native-evaluation axiom are unchanged. What
remains of the native decisions is the fourteen weight-ten profile shards, the automorphism anchors,
and the fixed-point exhaustion — stage 5 items 11 to 13 — and then the stage 6 release surfaces.
Report: `notes/2026-08-07-c834-bitangent-support-and-row-uniqueness-assembly.md`.

The converse half was still enumerated at that point; it is now structural, as the latest resume note
above records.

## Superseded resume note (2026-08-07, earlier)

The row-uniqueness layer now has a structural proof, and the two open items of the 2026-08-06 mystery
ledger are closed by one theorem: four internal points that are pairwise passant-joined and all four
of whose triples have zero concurrence are collinear. Both halves — collinear admissible triples
extend by exactly the four remaining points of their passant, non-collinear ones do not extend —
follow, as does row uniqueness itself. The mechanism is that internal points are trace-zero
two-by-two matrices in a three-dimensional quadratic space, so four of them satisfy one Gram
relation; the elliptic invariant is \(\rho = 4B^2/(\Delta\Delta)\), the missing triple invariant is
\(\pi = -8 B_{12}B_{13}B_{23}/(\Delta_1\Delta_2\Delta_3)\), collinearity of a joined triple is
\(\sum\rho+\pi = 4\), and admissibility is a fourteen-row table in \((\rho\text{-profile},\pi)\).
Report and evidence bundle: `notes/2026-08-07-c834-row-uniqueness-structural-proof.md`,
`notes/2026-08-07-c834-admissible-quadruple-gram.py`, `.json`.

The first piece of the replacement is landed and green:
`PassantCodeQ13.MinimumWords.RowUniqueness.QuadrupleGram` carries the finite core, the exhaustion
over the six normalized traces of each of a quadruple's six pairs. It is self-contained residue
arithmetic modulo thirteen with no geometric data, is discharged by `decide +kernel` in six
declarations, and builds in **under three seconds at a peak of 0.54 GB** — against about a minute
each at 3.6 GB for the seven residue shards it is meant to replace. Nothing imports it yet, and both
package gates remain trace-current.

A closeout pass then removed the layer's dependence on the classification table, and with it on the
equivariance transport. The missing constraint is a discriminant law: for three internal points the
normalized Gram determinant \(D = 4 - \sum\rho - \pi\) vanishes when they are collinear and is a
nonsquare otherwise, because three independent lifts span the ambient three-dimensional quadratic
space and over a finite field a nondegenerate ternary form is fixed by its discriminant. That law
plus the bitangent-conic witness formula — both pure algebra, neither touching the support family —
is enough for the quadruple theorem. `QuadrupleGram` now states its hypothesis in exactly those
terms and still builds in five seconds at a peak of 0.67 GB.

Consequences for stage 5 item 10. The criterion module, the pair transporter, the group action, the
364 displayed supports, and the octahedral family all drop out of the row-uniqueness path. What
remains is two geometry lemmas in the displayed coordinates, neither of which runs a search — the
discriminant law, one determinant identity; and the bitangent support lemma, that for a secant \(L\)
and a nonsquare \(\nu\) with \(\nu \operatorname{disc}(L) - 1\) a nonsquare the twelve off-chord
points of \(C - \nu L^2\) form a weight-twelve word — followed by the semantic bridge in
`RowUniqueness/Transport.lean` from the seven-set hypothesis through `QuadrupleGram`, and then
retirement of `IndexCertificate` and the seven residue modules. The equivariance transport is still
wanted for other leaves of the package but no longer gates this one.

The first of those two geometry lemmas is closed, together with the two further algebraic inputs the
bridge needs. `PassantCodeQ13.MinimumWords.RowUniqueness.PolarGram` proves the discriminant law —
the normalized polar Gram of three internal points is never a nonzero square, and vanishes exactly
on collinear triples — from the factorization `det G = -2 (det V)^2` and the character of a product
of three nonsquares; it also writes the normalized Gram in the manuscript's invariants as
`4 - Σρ - π`, and proves that the four-by-four polar Gram determinant of any four coordinate triples
vanishes. `PassantCodeQ13.MinimumWords.RowUniqueness.PassantJoinInvariant` proves that the
dual-conic value of a join is the discriminant of the binary form it carries, that two distinct
internal points are passant-joined exactly when that value is a nonzero nonsquare, and hence that a
joined pair has elliptic parameter `9`, `10` or `12`. Both modules elaborate and build clean with no
compiled-evaluation axiom at any terminal, and neither is on a gate yet: they enter with the bridge
that consumes them. Report:
`notes/2026-08-07-c834-discriminant-law-and-join-criterion-lean.md`.

The residue dictionary is closed too.
`PassantCodeQ13.MinimumWords.RowUniqueness.NormalizedTrace` produces a normalized lift for every
internal point — the representative whose conic value is the fixed nonsquare `11`, so the
corresponding trace-zero matrix has determinant two — and carries every coordinate statement into
the natural-number residue arithmetic `QuadrupleGram` quantifies over: each modular operation casts
to its field operation, the residue Gram of a triple of lifts is the residue of
`normalizedPolarGram`, the residue Gram determinant of a quadruple vanishes, the discriminant law
reads as "zero exactly on collinear triples and a nonsquare otherwise", and the trace of a
passant-joined pair lies in `joinTraces`. The quadruple vanishing goes through a general symmetric
four-by-four Gram determinant and its scaling law, added to `PolarGram`, because the trace matrix is
`-7` times the matrix of polar values and `ring` cannot reduce numerals modulo thirteen.

`NormalizedTrace` therefore supplies every hypothesis of
`admissible_trace_quadruple_has_vanishing_triple_grams` except the absence of a bitangent witness.
What is left of the item is the bitangent support lemma, which supplies that hypothesis; the
assembly in `RowUniqueness/Transport.lean` — choose lifts for a seven-set, apply the quadruple
theorem to every four-subset, and identify the common line as the passant; and the retirement of
`IndexCertificate` and the seven residue modules.

The octahedral family is still needed for the converse half, that a passant row is admissible, which
is the statement that no minimum support meets a passant in more than two points. That is structural
for the 273 conic supports and a one-orbit-representative check for the 91 octahedral ones.

## Superseded resume note (2026-08-06)

The row-uniqueness transport is closed, which completes stage 5 item 10. Its nine compiled
evaluations — seven residue shards, the geometric rows' zero triple concurrence, and the indexed
passant-join test — are all kernel-checked. The certificate is restated on internal-point indices
and bit sets: row masks and join masks from the packed incidence table, and the union of the
minimum-word supports through a pair of indices in place of a concurrence count. The seed-extension
scan becomes a passant-clique search over increasing index lists, whose guards are exactly what the
semantic hypotheses supply. The geometric rows' statement now follows from the blockwise check that
already existed, and the join test from the incidence dictionary. Clean terminals: 83 of 94. Both
gates and the evidence verifier are green. Report:
`notes/2026-08-06-c834-row-uniqueness-kernel-closure.md`.

Two levers from that round apply to what is left. Kernel memory is released between declarations but
not inside one, so a check that exceeds the guard as a single declaration can fit as several
declarations in one module — this is what made a residue class viable without one module per index.
And a pool carried as a list, filtered from its parent at each level, beats a pool carried as a bit
mask tested against the whole index range once the levels are narrow.

The remaining native decisions are the fourteen weight-ten profile shards, the automorphism anchors,
and the fixed-point exhaustion.

The equivariance transporter theorem and the structural upgrade's three support-family leaves are
closed, which completes stage 2 item 4 and stage 4 item 7. The package now carries a genuine group
action on the internal points, an invariance theorem for the decoded minimum-word family proved from
the orbit description rather than by enumeration, and a kernel-checked transporter theorem consuming
the generated tables. Unary constancy and concurrence-eight row recovery are decided at the first
internal point, and the fused pair-color split at the six representative pairs, each over the
displayed encoded supports. Only the base row of the generated pair table is read, because all six
representatives share their first point, so the 6006-entry table needs no index split and the
measurement stage 2 asked for is moot. Two further native decisions fell to the same argument:
decoding injectivity is now proved from the bit characterization plus a bound, and the encoded
family's duplicate-freeness is decided over the displayed supports. Two of the four automorphism
anchor decisions went the same way — the anchor relation pattern and the length of the normalized
matrix list both reduce in the kernel — leaving the anchor-image identification as the module's only
compiled evaluation. Clean terminals: 69 of 94. The evidence verifier passes. Report:
`notes/2026-08-06-c834-equivariance-transporter-and-support-family-leaves.md`.

Two measurements to carry forward. A finite check stated over `minimumSupportCodes` makes the kernel
expand the four orbits and exceeds the memory guard; the same check over the displayed
`minimumWordSupports` finishes in seconds. A check stated over `InternalPoint` rather than `Fin 78`
reintroduces the `internalPointIndex` scan and also exceeds the guard. Both were observed as memory
kills in this round.

The remaining native decisions after that round were the fourteen weight-ten profile shards, the
row-uniqueness transport, the automorphism anchors, and the fixed-point exhaustion.

The association algebra is closed. `PassantCodeQ13.AssociationAlgebra` now holds only the executable
presentation, and its three former native decisions — the ranks 42, 36, 36, 36 and the two squaring
statements — are proved in the new `PassantCodeQ13.AssociationAlgebraIdentities` under their original
names and namespace, so the tracked axiom audit is unchanged. Both bridges are symbolic: the bits of
a bit-setting fold identify the computed relation rows and the triple-loop product with the packet's
mask presentation, and only the four ranks are computed, by kernel reduction on the displayed masks.
The axiom audit's 94 terminals now report 56 clean against 38 carrying a declaration-local
native-evaluation axiom. Both gates and the evidence verifier are green. Report:
`notes/2026-08-06-c834-association-algebra-kernel-closure.md`.

The weight-ten aggregate's own two leaves are closed as well, and the stage-1 merge-sort probe is
answered. `List.mergeSort` is defined by well-founded recursion, so the kernel cannot unfold it for
any input; the 595-element data reduces fine. The module now sorts by repeated structural insertion,
proved to permute its input, and `cycle_pair_partition` states the pair-level permutation its
docstring always claimed rather than an equality of sorted encodings. `local_partition` reduces in
the kernel unchanged. Clean terminals: 58 of 94. Report:
`notes/2026-08-06-c834-weight-ten-aggregate-kernel-leaves.md`. Stage 1 is therefore complete —
item 1's module was already elaborated in the previous round — and the fourteen weight-ten
syndrome-disjointness shards are unaffected, since their search is real.

The two ambient-plane axioms of stage 4 item 9 are closed, by the symbolic route the plan confirmed.
`PassantCodeQ13.PlaneJoin` builds the join of two coordinate triples as their cross product and
proves existence and uniqueness from three polynomial identities plus the existing normalization
dictionary; incidence symmetry makes the meet of two lines the join of two points with exchanged
arguments. Clean terminals: 61 of 94. Report: `notes/2026-08-06-c834-ambient-plane-join-and-meet.md`.
The structural upgrade's remaining three leaves are the per-point and per-pair statements of item 7,
unchanged and next.

Two carry-overs for later stages. The round's bit-level lemmas — a bit-setting fold's bits, a mask
list determined by the matrix it presents, tabulation as mapping, and the vanishing of a selected
exclusive-or — are private in the identities module and are exactly the transport stage 4's packed
pair concurrence needs; promote them into `AssociationTransport.PackedRows` in the build window that
first consumes them, not before, since that rebuilds the packet. And the four squaring identities now
exist in two vocabularies, the list form and the `ZMod 2` matrix form, of which only the latter feeds
the orbit-spanning spine; stage 6's statement-identity ledger must point each manuscript clause at
one of them.

Item 6 of stage 3 below is therefore done, including the header disclosure it asked to narrow. Item 5
was already discharged by the previous round, whose elaboration of the packet is trace-current.

## Superseded resume note (2026-08-05)

The paper package elaborates end to end. `PassantCodeQ13.Gates.Main` and
`PassantCodeQ13.Gates.AxiomAudit` both build, and all 94 audit terminals report: 53 clean, 41
carrying declaration-local native-evaluation axioms. Three defects were repaired to get there — a
generated transporter table overrunning the elaborator recursion depth, two automorphism rewrites
that could not see through the indexed action, and a gate terminal declaring a data-carrying
structure as a theorem — and three finite gates were moved from native evaluation to kernel
reduction. The evidence verifier passes and the referee-facing module inventory is rebuilt from the
package. Report: `notes/2026-08-05-c834-equivariance-elaboration-and-kernel-gates.md`.

The section below is retained for its plan and its account of the association-transport round. Its
statement that the association-transport packet and the hidden-field cubic are unelaborated is no
longer accurate: those modules are trace-current and were skipped as already built. Items 4 and 5 of
its build-window list, the evidence manifest and the module inventory, are done.

Kernel reduction of the checks over the 364-member decoded support family is blocked by memory, not
by recursion depth, and needs the packed-mask reformulation rather than a larger limit. The cheapest
remaining reduction is the association algebra's three native decisions, which prove identities the
association-transport packet has already reduced in a parallel mask presentation.

## Superseded resume note (2026-08-04)

The shared library is closed. No source file under `lean/RelativeConicArcs/PassantCodeQ13/`
contains `native_decide`, both replacement proofs are elaborated and committed, and all 23
terminals of `RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit` report axiom sets contained in
`[propext, Classical.choice, Quot.sound]`. Report:
`notes/2026-08-04-c834-shared-library-native-closure.md`.

The minimum-word orbit and concurrence layer of the paper's own package is also closed. Report:
`notes/2026-08-04-c834-minimum-word-kernel-closure.md`.

The association-transport packet and the hidden-field cubic are rewritten for kernel reduction but
**not yet elaborated**: the shared build tree's build-owner lock was held by another lane's q16
certificate gate for the whole of that session, so no elaboration, focused gate, or axiom audit
could be run. The mathematics is independently confirmed by the tracked generator, which refuses to
emit unless all nine identities the leaves state hold in exact integer arithmetic. Elaborating these
modules is the first task of the next build window; the exact order is in the report:
`notes/2026-08-04-c834-association-transport-kernel-closure.md`. An independent referee pass
reproduced every committed table and identity from the Lean definitions and found no soundness hole:
`notes/2026-08-04-c834-independent-review.md`. It also found that the round's first commit left the
paper's evidence verifier failing on two stale manifest records; that is repaired, the manifest now
records both generators, both generated data modules, and a statement-shape checker, and the
verifier passes.

The shared equivariance layer of stage 2 is written and committed, also unelaborated, together with
the transporter generator and its generated data, whose exhaustive self-checks pass. The open route
decision of stage 4 is resolved in favour of the symbolic route on stronger evidence than the plan
assumed. Report: `notes/2026-08-04-c834-equivariance-layer-and-ambient-plane-route.md`.

Three things the referee pass surfaced outrank the remaining leaf-by-leaf work. The four relation
identifications are the memory risk of the association-transport packet, not the orbit columns, and
should have the modular inversion removed from the checked predicate before anything is split. The
three native decisions of `PassantCodeQ13.AssociationAlgebra` prove the same identities the packet
has already reduced, in a parallel mask presentation, and need only a list identification and one
symbolic bridge. And the symmetric-square action is transitive on the internal points and on each of
the six relation classes, so an equivariance lemma plus two displayed transporters — a shared layer
the package has never built — deletes the largest automorphism enumeration outright and collapses
the structural upgrade's per-point and per-pair statements to a handful of representatives.

Assuming that elaboration succeeds, the paper package under
`papers/q13-passant-code/lean-certificates` has 44 native decisions across 31 modules — 16 in the
weight-ten profile certificates, 11 in the row-uniqueness transport, 8 in the structural upgrade, 4
in the automorphism anchors, 3 in the association algebra, and 2 in the fixed-point exhaustion.  The
two the anchors have lost are the matrix-quantified relation-preservation and bijectivity leaves,
rewritten by the stage 2 equivariance layer.

## Execution plan

Every remaining native decision, release surface, and pre-release accommodation is owned by exactly
one stage below. Stages 1 and 2 come first because their outcomes change the shape of later stages;
within a stage the order is free. The one open architectural decision is marked.

**Stage 1 — probes, before committing to any leaf work.** These are cheap and each one settles a
question that would otherwise be discovered after several failed builds.

1. Elaborate `AssociationTransport/RelationMasks/RhoZero.lean` and record its measured peak. It
   calibrates the cost of one kernel evaluation of the normalized polar invariant and therefore
   every remaining leaf that touches it, and it answers whether the kernel caches the reduction of
   `internalCoordinateList`.
2. Probe `WeightTen/Aggregate.lean`'s 595-element `List.mergeSort` for kernel reduction at
   acceptable cost. If it does not reduce, replace the sort by a sorted-insertion certificate or
   restate the partition as a multiset identity needing no sort. This is the second cliff candidate
   after the fixed-point exhaustion, and the probe is one small module.

**Stage 2 — the shared equivariance layer.** Three later stages consume it. Both items are written;
neither is elaborated.

3. Invariance of the normalized polar invariant under the symmetric-square action is proved
   symbolically in `PassantCodeQ13.SymmetricSquareInvariance`: the polar form and the discriminant
   acquire the same determinant factor and the invariant is bi-homogeneous of degree zero, so the
   two transformation laws are polynomial identities in the four matrix entries and six point
   coordinates. `Automorphisms.matrixAction_preservesRho`, the largest single native enumeration in
   the package, and `Automorphisms.matrixAction_bijective`, which the adjugate identity closes for
   free, are rewritten to consume it. What remains is elaboration and the axiom audit.
4. The displayed point transporter — one group element carrying the base internal point to each of
   the 78 — and the displayed pair transporter carrying each ordered distinct pair to one of six
   class representatives are generated and self-checked by
   `lean-certificates/generate_transporter_data.py`. What remains is the Lean theorem that each
   emitted index realizes its transport, kernel-checked once, and a measurement deciding whether the
   6006-entry pair table needs an index split. All six class representatives share the first point,
   so a pair statement reduces to one point statement and six second-point cases.

**Stage 3 — finish the association-transport round.**

5. Remove the modular inversion from the checked predicate of the four relation identifications
   before splitting anything, then elaborate the whole packet, `RelationCubic`, `StructuralUpgrade`
   and the package gate, and regenerate the axiom audit. A four-way row split of each relation
   module is the fallback if the inverse-free predicate is not enough.
6. Close the three association-algebra decisions: identify `relationMatrix v` with the displayed
   masks, prove one symbolic bridge from its `matrixProduct` to `maskProduct` and from `xorFour` to
   iterated `maskXor`, and take the ranks by kernel reduction on the displayed masks. Then narrow
   the disclosure in `AssociationTransport.lean`'s header, which currently records that this native
   evaluation exists in the import closure.

**Stage 4 — the structural upgrade's eight decisions.**

7. Reduce the per-point and per-pair statements through the stage 2 transporters:
   `unaryDegree_fiftySix` to one representative point, `pairColorEight_recovers_polarRows` and
   `fusedColorSix_splits` to six representative pairs. Pack pair concurrence as one mask per ordered
   pair, not as a scalar table; the mask form makes `fusedColorSix_splits` a single module of about
   fifty thousand kernel steps, the scalar form needs roughly six blocks.
8. Transport the toric cardinalities and parities and the determinant-conic cardinality from
   `Finset` filters over the subtype universes to filters over the displayed coordinate lists,
   reusing the packed incidence table the package already carries.
9. **The two ambient-plane axioms — symbolic route, confirmed.** Only one of the two is an
   obligation: plane incidence is a symmetric bilinear expression, so the dual statement is the
   first with its arguments exchanged. The step previously taken to be the real obligation, that a
   vanishing cross product forces collinearity, is in the pinned Mathlib as
   `crossProduct_ne_zero_iff_linearIndependent`; `dot_self_cross`, `dot_cross_self` and
   `cross_cross_eq_smul_sub_smul` from the same file give incidence of the join and the uniqueness
   expansion `L × (p × q) = (L · q) p − (L · p) q` without computation. The remaining normalization
   dictionary — nonzero representatives, normalization as a rescaling, and equality of proportional
   normalized representatives — is already proved in `PassantCodeQ13.SymmetricSquareInvariance` and
   is consumed rather than rebuilt. The tabulation fallback is not needed and is not to be built.
   Projective normalization remains unavailable: the package's group acts through the symmetric
   square and preserves the conic, so it is not transitive on ordered pairs of arbitrary plane
   points.

**Stage 5 — the remaining enumerations, where tabulation is the right tool.**

10. Row uniqueness is closed, and structurally: no search over points, lines, or supports survives.
    The finite content is the residue exhaustion of `QuadrupleGram` and the bitangent-support
    exhaustion over the 183 dual triples and 13 field elements. Neither the group action nor the
    equivariance transport is used.
11. Automorphism anchors are closed. The fourth-anchor uniqueness reduces in the kernel outright;
    the anchor triple orbit is decided as two tables of encoded pairs, compared for equality, with
    a freshness flag on the accumulating pass supplying injectivity of the anchor image map.
12. Weight-ten profiles are closed by retiring the fourteen native shards and stating the gate on
    the kernel-checked isolated-reachability and cycle-exclusion aggregates, which were already
    proved but had never been wired into the gate.
13. Fixed-point exhaustion: `fixedPoint_slices_are_stabilizer_orbits` reduces to a packed
    action-index table over the order-28 stabilizer and is small. `fixedPoint_weightTwelveExhaustion`
    is gated on the arc property for an arbitrary weight-twelve codeword, measured above as the only
    lever that brings its search within kernel reach; the arc property of the displayed family is not
    usable here, since this is the theorem that puts a codeword in that family. Once the arc property
    is available, three of the four profiles vanish and the fourth is a 22951-node tree. Both leaves
    also use `eraseDups` and `toFinset`, which are quadratic in decidable equality and need attention
    independently of the search.

**Stage 6 — the release surfaces.** The task card requires seven; only the axiom transcript and part
of generated-artifact provenance have had any work, and the rest had no owner before this plan.

14. Statement identity: a tracked map from each manuscript clause to its Lean statement, with the
    same schema discipline as the other numbered papers.
15. Claim-by-claim trust manifest, distinguishing kernel, certificate, classical and human proof
    modes exactly, with no clause advertised as kernel-checked that is not.
16. Theorem-to-source formal map.
17. Public release allowlist, and a release verifier that actively rejects a native-evaluation or
    trusted-execution placeholder rather than merely reporting one.
18. Refresh the referee-facing module inventory in `verification/README.md`. Its "Lean release
    layout" is missing every module added by the association-transport round and by the minimum-word
    round before it. Rebuild the list from the package rather than appending, and do it after the
    leaf work, since a check that has to be split adds modules.
19. Exercise a clean-checkout build of the full aggregate under the pinned toolchain with the
    companion present. This has never been run, because the companion is currently excluded from the
    export.

**Stage 7 — reverse the pre-release accommodations.** All five are listed in the section below and
none was scheduled before this plan: the `papers/repositories.toml` exclusion and its `Makefile`
rewrite, the companion-absent skip in `verify_evidence.py`, the two README sentences, the
repository-relative `lean-certificates/` paths in the manuscript and `verification/README.md`, and
the `git rm` in the standalone mirror. They are reversed only once the companion is exported,
published and pinned, and the forward version carries the pinned locators. Only then may C761
request publication authority.

The technique that carried every closure so far: state the finite content on the displayed
coordinate lists, reduce one table in the kernel, and transport to the subtype model afterwards.
Deciding directly over `InternalPoint` or `PassantLine` re-derives the subtype universe once per
element and exhausts the memory guard; deciding over a `Finset` powerset does the same.

Three further levers were established by the minimum-word closure and apply to the remaining
packets. Any operation that locates an object by scanning a coordinate list — `internalIndex`,
`incidentAt`, `rhoAt` — must be replaced by a packed natural-number table whose agreement with the
scan is kernel-checked once over the finite index domain; the scan itself is what exhausts the
guard, not the field arithmetic, which reduces cheaply. Any object recomputed inside a larger check
must first be identified with a displayed list, emitted by a tracked generator and checked by Lean,
so that downstream checks reduce on literals. What still exceeds the guard after both is split into
index blocks, one module each, and reassembled by list concatenation. The measured ceiling on the
`single` profile is roughly one million kernel operations on this data per module.

The association-transport packet added a fourth lever, reusable by every remaining matrix leaf: a
Boolean matrix presented by the list of its row bitmasks has a parity product costing one
natural-number operation per pair of a left row and a middle index, instead of one operation per
triple of indices. `PassantCodeQ13.AssociationTransport.PackedRows` proves that this word-parallel
evaluation computes `booleanParityProduct`, which linearizes to matrix multiplication over the
binary field.

The fixed-point exhaustion is the one leaf that no table substitution reaches — it meets partial
supports through a hash map keyed by incidence syndrome, over domains far larger than anything
reduced so far — and needs a proved checker in the style of the weight-ten reachability kernel. The
two ambient-plane axioms of the structural upgrade are the other leaves no table reaches, for the
opposite reason: they should stop searching altogether and be proved from the cross-product formula
for the join of two distinct normalized points.

## Current state

The incidence/dimension packet is partially closed.  The normalized 183-point coordinate model,
the 78 internal and 78 passant coordinate enumerations and their indexing equivalences, the
independent bit-row rank calculation, and the recovery/expansion masks transporting rank 42 to the
semantic incidence map now use kernel reduction.  The four-anchor signature injectivity leaf is
also kernel checked.  Focused guarded elaboration and the semantic rank-transport target are green.

The reusable weight-ten reachability kernel is also in place.  It checks generated transition
layers, proves coverage for every member of the complete Cartesian choice domain, supports compact
selected-row projections through a proved XOR homomorphism, and derives target exclusion from a
checked terminal list.  This infrastructure is kernel checked, but no native weight-ten leaf has
yet been removed.

Direct kernel reduction is not an admissible replacement for the larger finite leaves: even one
semantic unary-degree point and one raw isolated weight-ten shard exceed the measured memory gate.

The seven isolated-profile generated layer certificates are now complete on that checker.  Each
option bridge, transition, and sharded terminal disjointness check is kernel reduced in its own
module, and the seven profile aggregates exclude syndrome equality for every choice in the complete
Cartesian domain rather than only for generator-emitted paths.  Report:
`notes/2026-08-02-c834-isolated-weight-ten-reachability.md`.

The cycle profile is now closed too, by kernel reduction of the manuscript's geometric rejection
search rather than by a projected-state cover of the syndrome product, which is not viable: the
disjointness product is fixed at 1.67e8 regardless of the split, and projection does not shorten an
exact-traversal transition list.  Seven residue shards discharge all 595 secant pairs with no
generated data, no generator, and no group action.  Report:
`notes/2026-08-02-c834-cycle-profile-kernel-exclusion.md`.

The first half of the semantic bridge is landed.  `PassantCodeQ13.WeightTen.PencilTransport`
identifies the indexed base pencil, its fibres, and its secant neighbours with the corresponding
semantic objects, and `PassantCodeQ13.WeightTen.SyndromeBits` characterizes every incidence-syndrome
bit by induction on the row bound and proves that the certificates' two bitwise obstruction tests
are exactly absence of a common passant and existence of a passant through three points.  Neither
module runs a finite search.  What remains of the bridge is the list-versus-finset assembly turning
the profile theorem's fibre sizes and secant-neighbour count into the selection shape the
certificates consume, and the projective transport of an arbitrary support point to the fixed base
point.  Report: `notes/2026-08-02-c834-weight-ten-semantic-bridge.md`.

The semantic weight-ten module's own three finite leaves are now kernel checked.  The passant
pencil of an internal point, uniqueness of the passant joining two distinct internal points, and
the passant/secant dichotomy for their join are decided on the displayed coordinate lists through a
single pencil table and transported to the subtype model, so both weight-ten terminals in the
Paper IV gate axiom audit depend only on the foundational axioms.  Report:
`notes/2026-08-03-c834-weight-ten-pencil-kernel-closure.md`.

The weight-eight tangent-graph module and the reconstruction row cardinality are also kernel
checked.  The base point, the internality, distinctness, and
neighbour identification of the cyclic vertex triples, the base pencil and its join uniqueness, the
four-clique enumeration with unique extension, five-clique collapse and maximality, the
common-neighbour cardinality of each four-clique set, and the seven internal points on each passant
line are all decided by kernel reduction.  The ambient dual-line evaluation, secant coordinates,
and secant-line subtype moved into the geometry module so the pencil results are available
upstream.  The last two exceptions were closed on 2026-08-04:
`WeightEight.adjacent_iff_tangentCompatibleAtBase` now reduces one table over the ordered vertex
pairs through the precomputed pencils and bridges symbolically to the semantic relation, and
`WeightEight.fourCliqueSets_complete` is proved from a general sublist lemma rather than computed.
Reports: `notes/2026-08-03-c834-weight-eight-kernel-closure.md` and
`notes/2026-08-04-c834-shared-library-native-closure.md`.

The earlier cycle-profile report also settles the route for the rest of weight ten.  The already-formalized pencil-profile
dichotomy of `RelativeConicArcs.PassantCodeQ13.WeightTen.arbitrary_weightTen_word_has_pencil_profile`
closes the endpoint with the two existing certificates, so neither the global moment identity and
its `m=6`/`m=10` shape classification nor the thirty-seven stabilizer obstruction records need to be
formalized.  The next implementation packet is the semantic bridge carrying the fibre decomposition
and the secant-join relation between the coordinate-index model of the certificates and the
`InternalPoint` model of the profile theorem, followed by the projective transport of an arbitrary
support point to the fixed internal point, which is the sole remaining weight-ten gap.  No native
leaf may be removed until its replacement is connected to the complete domain.  Unary constancy will
use the manuscript's orbit-transitivity and double-count mechanism rather than semantic support
filtering.

## Standalone pre-release accommodations to reverse

A manuscript-only pre-release of `papers/q13-passant-code` was authorized on 2026-08-03 before the
formal closure finished, so the standalone export omits the Lean companion.  The deposit is
published from the mirror `~/src/math-papers/q13-passant-code` and its archival locator is
[`10.5281/zenodo.21783971`](https://doi.org/10.5281/zenodo.21783971), recorded as the README badge.
That deposit is immutable: the formal closure lands as a forward version, never as an edit to it.
The manuscript itself carries no locator yet, since printing this DOI inside the PDF it identifies
would need a later version anyway; insert it with the pinned formal-package locators in the same
release pass.  The README states that the Lean development is deposited separately and expected
the day after the deposit.  The manuscript, its README, and the evidence
verifier were all changed to make a manuscript-only checkout coherent, and the deposit's verifier
passes standalone while reporting the seven digests and one command it cannot check.  Every accommodation below
exists only because the companion is not yet publishable, and each must be reversed once the shared
library is exported, published, and pinned:

- `papers/repositories.toml` excludes `lean-certificates/**` from the `q13-passant-code` export and
  rewrites the `Makefile` to drop the `lean` target; both the exclusion and that rewrite go away
  when the companion ships.
- `papers/q13-passant-code/verification/verify_evidence.py` skips the manifest records naming the
  companion package or the shared library when the companion directory is absent, reporting the
  count of skipped checks.  The skip stays only while a manuscript-only checkout is a supported
  distribution; if the companion always ships, delete it.
- `papers/q13-passant-code/README.md` states that the Lean development is deposited separately and
  that this version's formal artifact still contains native-evaluation leaves.  Both sentences must
  be replaced when the closure lands.
- The manuscript's public-command paragraph and `verification/README.md` still name
  `lean-certificates/` as a repository-relative path; the release chain must replace those with the
  pinned public locator.
- The standalone mirror `~/src/math-papers/q13-passant-code` has a `git rm` commit removing the
  companion.  Restoring it downstream is an ordinary forward commit through the exporter, not a
  history repair.

## Objective

Replace Paper IV's partial formal mirror by a theorem-complete public Lean
development before release.  The terminal theorem must cover the complete
published result: parameters \([78,36,12]_2\), all 364 minimum words and their
four intrinsic families, spanning by every family, exact weighted-pair
reconstruction, the full marked \(\operatorname{PG}(2,13)\), and the
automorphism group.

## Meaning of “full Lean”

For release purposes, the formal package is complete when every manuscript
clause has an exact entry in the series-standard statement, trust, and formal
coverage ledgers, and every claim described as Lean-proved names an elaborated
declaration with its actual axioms.  Release-facing Lean terminals have no
declaration-local native-evaluation axiom or trusted Python premise.  Ordinary
foundational axioms reported by Mathlib—such as choice, propositional
extensionality, and quotient soundness—are permitted and must be listed.

Short structural human proofs and exact classical inputs remain legitimate
proof modes under the series trust standard.  They must be complete in the
manuscript or pinned to precise literature, and the aggregate must not advertise
their clauses as kernel checked.  Python programs may remain independent
cross-checks but carry no logical weight.

Proof-producing reflection, kernel reduction, generated proof terms, and
proved reusable finite certificates are permitted.  `native_decide` is not a
release proof endpoint.

## Required closure packets

1. **Incidence and dimension:** kernel-check the normalized conic, polarity,
   incidence matrix, rank 42, and code dimension 36.
2. **Distance:** internalize the weight-eight tangent/theta argument, including
   PSD and the equality/kernel calculation, and the weight-ten moment plus all
   stabilizer exclusions; derive minimum distance 12 without a trusted search.
3. **Minimum layer:** prove the complete 364-word exhaustion, identify one
   octahedral and three toric families intrinsically, compute stabilizers and
   prove every family spans.
4. **Pair recovery:** prove the exact pair table, the fused-color splitter,
   color-eight recovery of every polar row, parity-image equality with the
   code, unary constancy, and exact arity two.
5. **Symmetry and plane:** formalize the compact anchor and coordinate-algebra
   mechanisms; retain sharp three-transitivity, the Sylow/involution
   construction, and the classical adjoint/polarity dictionary as exact
   human/classical trust rows when formalizing their general group theory would
   create a disproportionate dependency tree.
6. **Hidden field:** construct the operator field, prove its identification
   with \(\mathbf F_8\), the equivalence \(K\simeq\mathbf F_8^{12}\), the three
   scalar actions, and the Gram/spanning consequences.
7. **Release aggregate:** expose one theorem matching the manuscript's main
   theorem, run a complete `#print axioms` audit, generate a theorem-to-source
   map, and make the public release gate reject native/trusted placeholders.

## Engineering constraints

- Keep the human semantic geometry in `TavisRuddFiniteGeom.Papers.Q13PassantCode`.
  The heavyweight finite certificate is instead a Mathlib-only package under
  `TavisRuddFiniteGeom.Certificates.Q13PassantCode`, with its own deliberately
  small finite coordinate/index model.  The downstream paper bridge must prove
  the model compatibility and transport the finite terminals into the semantic
  geometry.  This duplication is intentional: changes to human geometry,
  theorem assembly, or paper prose must never invalidate certificate oleans.
- Match the other numbered papers' release machinery: tracked statement
  identity, claim-by-claim trust manifest, formal theorem map, frozen axiom
  transcript, generated-artifact provenance, public release allowlist,
  aggregate import gate, and a single release verifier.  Paper IV may strengthen
  those standards, but it may not use a weaker or bespoke ledger.
- Shard expensive proof-producing computations and keep generated artifacts
  deterministic, reviewable, and hash-addressed.
- Each packet must have a cheap focused build before entering the aggregate.
- Keep statement identities synchronized with the manuscript; if a statement
  cannot be formalized as written, repair the proof or report the precise
  mathematical blocker rather than weakening it silently.

## Acceptance

- A clean public checkout builds the full aggregate under the pinned toolchain.
- The statement-identity, trust-manifest, formal-map, axiom-transcript,
  provenance, allowlist, and release-verifier surfaces use the same schema
  discipline and cross-checks as the rest of the series.
- The release correspondence covers every clause of the manuscript main
  theorem and distinguishes kernel, certificate, classical, and human proof
  modes exactly.
- Its axiom closure contains no native-evaluation or project-local axiom and no
  trusted-execution premise.
- Every former native or Python theorem boundary is replaced by a Lean proof,
  a proof-producing Lean certificate, or an explicitly nonformal independent
  replay.  Human and classical boundaries are retained only where the
  architecture report justifies them and the trust ledger states them exactly.
- Independent Python replay, source hygiene, warning-free PDF, isolated build,
  and immutable-artifact checks pass.
- Only after C834 is complete may C761 request publication authority.

## Stop boundary

C834 does not add new mathematical claims, pursue all-\(q\) generalizations,
or publish externally.  Its sole purpose is proof-complete formalization of the
frozen Paper IV theorem.
