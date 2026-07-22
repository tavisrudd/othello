# Alternative master strokes — contingency designs for a C479 negative

**Lane:** `crowns`

**Date:** 2026-07-22

**Status:** design note; no allocation; contingency planning for C479 (claim 5 of the integral
golden model, in flight elsewhere). This note does not attack claim 5 and does not duplicate any
C479 route. If C479 returns GREEN or EQUIVALENT, this note is moot and the master-stroke note's
promotion rule applies unchanged.

## Frame

The template being replaced is `2026-07-21-clebsch-master-stroke-integral-golden-model.md`.
Claims 1--4 are certified (C441/C442/C444/C445/C458). Claim 5 — an integral Galois-odd cubic over
`Z[phi]` whose mod-`pi` shadow is the frozen `+/-6` orientation — is the only open clause, and
C443/C461 prove the specified functorial construction cannot supply it (four companion orbits, no
`kappa`-fixed companion, zero permitted weight-line kernel mod 11). This note assumes every C479
route may also fail and asks: what other single theorem would collapse the certified incarnations
of the chirality bit — sheet swap, design polarity, cubic sign, split-prime choice, quantum swap,
Fourier sector — into consequences of one object, at the strength "the decoder's missing bit IS
X, made finite," inside Paper 1's roof-free close
(`2026-07-20-clebsch-paper-planning.md`)?

Every "certified" claim below carries its C-ID from
`2026-07-21-clebsch-weil-roof-results-ledger.md`, `2026-07-22-c472-c474-publication-value-review.md`,
or `2026-07-22-c473-arithmetic-orientation.md`. Everything else is marked REASONED or
SPECULATIVE. No novelty is claimed for any candidate; each would still owe its bounded literature
audit before external wording.

## Candidate A — the torsor Rosetta ("the bit IS one free C2-torsor")

**(a) Stroke.** The decoder's missing bit IS one free `C2`-torsor — the fiber of the arithmetic
orientation over the frozen configuration — canonically realized by every certified incarnation
at once, with the marked Coxeter matching as its universal pointing and provably no unpointed
section.

**(b) Exact-statement sketch.** For `q = 7, 11` there is a free `C2`-torsor `T_q` with the outer
`PGL_2(q)/PSL_2(q)` coset as its structural swap, together with canonical outer-equivariant torsor
isomorphisms

```text
T_q  =  two matching sheets                    (C406/C445)
     =  two nontrivial unipotent classes       (C473)
     =  two cyclotomic period factors          (C473)
     =  two split primes of Q(sqrt(-q))        (C473)
     =  two conjugate lower Weil constituents  (C473)
     =  two golden/silver reductions, i.e. the
        two primes of Z[phi] (resp. Z[sqrt2])
        above q                                (C442/C458, C444)
     =  two cubic orientation signs            (C406: stabilizer of the sign is PSL)
     =  two QR difference designs / Barker
        polarities                             (C452, leg to be certified)
     =  two signed Fourier sectors             (C378/C455, leg to be certified),
```

and the pointed statement: the Coxeter-invariant matching `M` has full stabilizer inside `PSL`
(C473), so marking `M` selects one point of every realization simultaneously, read off by the
single trace rule `alpha -> tr(T|C)` (C473). Unpointed, no section exists (C417, C448, C473); the
type-correct output is the torsor isomorphism itself.

**(c) Collapse achieved / left out.** Collapses sheet swap, split-prime choice (both arithmetic
fields: `Q(sqrt(-q))` via C473 and `Q(sqrt5)`/`Q(sqrt2)` via C442/C444), cubic sign, period
factors, unipotent classes, lower Weil constituents, design polarity, Fourier sector — every
incarnation row. The quantum swap enters as it does in the golden model: C456/C467 are certified
erasure theorems (the LU passage forgets the point of `T_q`; the transport bitorsor is `T_q`-shaped
but noncanonical), so quantum is a boundary row, not a realization, exactly as Paper 1 already
states it. Left out: the *mechanism* of the characteristic-11 gluing (stays C445 + Paper-2
pointer), the mod-40 continuation mechanism (C453 law stated, C459/C466 stay sequel), and any
integral tensor — claim 5 is dropped, not replaced by a lift.

**(d) Certified vs new.** Already certified: the five-way identity, the trace rule, the
gauge-exhaustion and normalization-change table, and the pointed/unpointed dichotomy (C473); the
sheet swap as the reduction of the rational rotation `Rz` (C445); golden and silver reductions
landing on the frozen sheets (C442/C458, C444); the cubic sign as an outer-odd function of the
sheet (C406); the cross-sheet disjointness sets being the two QR designs (C452). To be newly
certified: two finite equivariance legs — (1) the design-polarity swap and (2) the signed
Fourier-sector swap are induced by the same certified outer element (Rz's reduction / C470's outer
duality), as torsor maps, in the frozen normalization; plus the assembly theorem statement itself.
Zero-new-proof answer to the review's question (i): with no new computation at all, C473 + C445 +
C442/C444 + C406 already give a seven-realization torsor identity in PROVED-assembly form; the two
new legs only extend the list.

**(e) First falsifier.** One bounded finite computation: apply the reduction of `Rz` (the C445
outer element) to the frozen C452 design pair and to the C378 signed sector decomposition and
check it exchanges each pair equivariantly, consistent with C473's normalization-change table. If
either swap is not induced by the outer coset, the corresponding leg is not a canonical torsor
map and must be demoted to an unordered-pair row.

**(f) Cost and risk.** Days (2--4): two finite certificates plus an assembly note. Risk low; the
core cannot fail because it is already certified. Residual risk is only that a leg falsifies and
the list shrinks by one row.

**(g) Epistemic key.** PROVED-assembly for the seven-realization core; REASONED for the
design-polarity and Fourier-sector legs until their certificates land.

## Candidate B — modular-derived cubic ("the +/-6 IS the split-prime residue, derived not lifted")

**(a) Stroke.** The decoder's missing bit IS the residue of one split prime, and the frozen
`+/-6` cubic readout is *derived* from the certified modular side by the trace rule — no integral
lift exists to be proved, so claim 5 becomes unnecessary rather than unproven.

**(b) Exact-statement sketch.** In the pointed category of C473 (input: the marked Coxeter
matching), the composite

```text
marked matching -> containing sheet (C406)
               -> selected split prime of Q(sqrt(-q)) via alpha -> tr(T|C) (C473)
```

and the composite

```text
marked matching -> containing sheet -> signed cubic moment / mu_3 sign (C406/C412/C444)
```

are the same point of the orientation torsor: there is an intrinsic identity
`cubic sign = f(residue of alpha)` with `f` a fixed convention-free bijection, natural under the
outer swap, uniform over `q = 7, 11`. The closing theorem then reads: the cubic-first threshold
(certified sharp by C406/C412) computes an arithmetic residue; the `+/-6` is the mod-`p` shadow
of a split-prime choice, established downward from the finite side instead of upward from a
`Z[phi]` tensor.

**(c) Collapse achieved / left out.** Collapses cubic sign, sheet swap, split primes, and (through
C473) unipotent classes, period factors, and Weil constituents into one pointed identity; the
`+/-6` stops being a sixth incarnation and becomes the readout formula of the torsor. Leaves the
design-polarity and Fourier-sector rows as they now stand in the survival ledger (they are not
touched), and leaves the golden `Z[phi]` prime pair connected only through C442's reduction, not
through a new integral object. Strictly smaller collapse than Candidate A; strictly closer
replacement for claim 5's specific role (it answers "where does the +/-6 come from" with an
arithmetic mechanism).

**(d) Certified vs new.** Certified: both composites exist and each is separately outer-odd
(C406 stabilizer statement; C473 exchange rows); the trace values (1 at q=7, 0 at q=11) and the
opposite-sheet controls (C473); the `mu_3` normalization `mu_3(s) = 2s mu_3(4)` (C444). New: the
identity between the two composites *as one convention-free rule uniform in q*. C473 itself flags
the exposure: q=7 selects residue `-1` and q=11 selects residue `0`, an exact feature of
independently frozen conventions — so the uniform `f` may not exist, only a per-case dictionary.

**(e) First falsifier.** Transport the C444 cubic-sign normalization through C473's dictionary at
both `q` and ask for one formula (e.g. in terms of the quadratic character of the unipotent
parameter, or the period `-c_(d-1)`) giving the cubic sign from the residue in both cases without
naming a frozen table. A short exact computation over `F_2`/`F_3`; if every candidate rule needs a
per-case sign, the theorem degrades to "compatible after conventions" and loses master-stroke
strength.

**(f) Cost and risk.** Days (1--3). Risk medium-low: the two orientations certainly co-vary (both
are outer-odd on the same torsor — that much is PROVED-assembly); the risk is entirely in whether
the linking rule is intrinsic or convention-bound.

**(g) Epistemic key.** PROVED-assembly for co-variation; REASONED for the intrinsic uniform rule.

## Candidate C — orbit/fusion-category descent ("the bit IS one gluing class")

**(a) Stroke.** The decoder's missing bit IS a single nontrivial class in the first higher limit
over the orbit category of the frozen configuration, of which every certified
local-split/global-nonsplit phenomenon is a restriction.

**(b) Exact-statement sketch.** Build the orbit/fusion category on the certified subgroup frame
(`A5, A4, S4, D12, ...` inside `PSL_2(11) < PGL_2(11)`, and the `M11 <- PSL_2(11) -> M11` span of
C470/C472); define one coefficient system from the C465/C474 carrier; prove `lim^1` is `Z/2`,
generated by a class whose restrictions are: C472's global central word (parents split and agree,
glue nonsplit), C474's q=7 bi-essential class (zero on every involution, nonzero on both `V4`s),
C462's nonsplit `C2 -> C4 -> C2`, and the C417 cocycle. The bit is that class; each incarnation
is the obstruction it induces on one subdiagram.

**(c) Collapse achieved / left out.** Collapses the *obstruction-shaped* shadows: sheet
nonchoosability (C417), selector cost (C448), signed gluing (C472), companion torsors (C462/C463),
Ext nonsplitness (C474). It does not by itself collapse the *readout-shaped* shadows (cubic sign,
design polarity, Fourier sector) — those still need Candidate A's torsor maps — and it says
nothing about the mod-40 continuation.

**(d) Certified vs new.** Certified inputs: the complete `D8` restriction profile computed by
C474 ("the complete finite input for the first orbit-category equalizer theorem," per the
C472--C474 review), the C472 length-eight central word, C462's extension class, C417. New: the
category and coefficient-system definitions, the `lim^1` computation, and every restriction
identification — the comparison spine across genuinely different ambient categories (group
extensions, module Ext, torsors) is the hard new part and is exactly the "changing ambient
category" issue the review flags.

**(e) First falsifier.** Compute the first higher limit over the frozen finite orbit category
with the C474 `D8` profile as coefficients. If it vanishes, or is nonzero but its restriction to
the C472 span does not hit the recorded central word, the candidate dies at the first gate.

**(f) Cost and risk.** One to two weeks. Risk medium: the finite computation is bounded, but the
theorem may fracture into "four analogous obstructions" without one class mapping onto all of
them, which is the current state restated.

**(g) Epistemic key.** REASONED (the recurrence of the local-split/global-nonsplit shape is
certified fourfold; the common class is not).

## Candidate D — quadratic/Maslov refinement ("the bit IS a secondary quadratic invariant")

**(a) Stroke.** The decoder's missing bit IS the value of a quadratic (Maslov-type) refinement on
the C471 Hadamard-degeneration complex — the secondary invariant that survives the unpointed
quotient where every linear invariant provably dies.

**(b) Exact-statement sketch.** Construct a quadratic refinement of the Bockstein--Tor pairing on
the rank-six exact complex `ker(H) = im(H^T)` (C471), invariant under `PSL_2(11)`, outer-odd,
whose automorphism extension is the nonsplit signed gluing (C472's central word), and whose two
values on the metabolic-but-nonsplit carrier (C465/C474) are the two sheet orientations. C473
proves no linear/character datum survives forgetting the marking; a quadratic refinement is the
minimal type that could.

**(c) Collapse achieved / left out.** If it exists it is the roof itself: it would collapse the
incarnations *and* explain the gluing mechanism, subsuming Candidates A and C and settling the
review's item 2 in the positive. Left out: continuation/mod-40 (unchanged). If it provably does
not exist, the metaplectic program closes with a theorem — also valuable, but that outcome is a
Paper-2 boundary, not a Paper-1 close.

**(d) Certified vs new.** Certified: the complex, its Bockstein inverse and SNF mechanism (C471);
the nonsplit-but-metabolic carrier and unique-extension statements (C465/C474); the central word
(C472); the linear no-go (C473). New: the refinement's construction, equivariance, outer-oddness,
and the identification of its automorphism extension — all of it.

**(e) First falsifier.** Enumerate all `PSL_2(11)`-invariant quadratic refinements of the frozen
pairing on the rank-six `F_3` complex (a finite, small linear-plus-torsor computation) and test
outer parity. If every invariant refinement is outer-even, the bit cannot live there and the
candidate is dead at one afternoon's cost.

**(f) Cost and risk.** Weeks if alive; the falsifier itself is under a day. Risk high; ceiling
highest. As a Paper-1 contingency it violates the mutual-protection rule ("paper 1's referee
cannot demand the roof"), so it can only be the close if it lands fully — otherwise it is Paper-2
work regardless of outcome.

**(g) Epistemic key.** SPECULATIVE (three certified doors demand the same missing datum; the
datum itself is unconstructed).

## Candidate E — conductor-40 Galois carrier ("the bit IS the fiber of one mod-40 module")

**(a) Stroke.** The decoder's missing bit IS the fiber over the working prime of one Galois
module over `Q(sqrt5, sqrt2, i)` (conductor 40) whose three quadratic quotients are the certified
existence, fusion, and phase characters.

**(b) Exact-statement sketch.** Construct a torsor or rank-small Galois module `W` over the
conductor-40 compositum with quotient characters `(5/q), (2/q), (-1/q)` (C466), such that
specializing at a split-visible prime `q` yields the sheet torsor `T_q` of Candidate A, at a
split-fused prime yields the certified fused control, and whose Chebotarev statistics reproduce
the certified `1/4, 1/4, 1/2` densities (C453).

**(c) Collapse achieved / left out.** Collapses along the *prime axis*: the mod-40 law, fusion at
31, visibility at 19, inertness at 13 become one module's splitting behavior, and the H4 prophecy
gets a carrier. It does not collapse the six incarnations at fixed `q = 11` — that job still
belongs to A/B/C. So it is a master stroke for the continuation, not for Paper 1's close.

**(d) Certified vs new.** Certified: the three characters, their independence, and the sharp
negative that no tested object carries all three (C466); the mod-40 class table and densities
(C453); the per-field integral models `Z[phi]`, `Z[sqrt2]`, `Z[i]` on separate carriers
(C442/C444/C463). New: the object one level up — and C466's negative is direct evidence that
nothing currently in hand is it.

**(e) First falsifier.** Test the minimal candidates (the regular representation of the
`(Z/2)^3` Galois group and its induced submodules from the C462 `C4` and C463 `Z[i]` torsors)
against the certified specializations at `q = 11, 13, 19, 29, 31, 41`: any mismatch with the
recorded visible/fused/inert dispositions kills that candidate immediately.

**(f) Cost and risk.** Weeks, open-ended. Risk high for Paper-1 purposes (wrong axis), moderate
as a Paper-2/continuation program.

**(g) Epistemic key.** SPECULATIVE (the Chebotarev fit is a certified unexplained coincidence;
the module is unconstructed).

## Candidate F — the outer hinge ("the bit IS one involution, made finite")

**(a) Stroke.** The decoder's missing bit IS the orientation of a single certified outer
involution — the `PGL_2(11)/PSL_2(11)` coset, realized rationally by `Rz`, extended monomially as
the Hadamard row/column duality and the outer automorphism of `M12` — and every certified swap is
that one involution acting through a certified equivariant map.

**(b) Exact-statement sketch.** There is one `C2` acting on the whole frozen configuration:
its rank-three geometric form is the reduction of the rational spinor-norm-2 rotation `Rz`
exchanging the sheets with hinge `S4/A4` (C445); its torus form is the nonsquare coset swapping
the Legendre blocks (C449); its arithmetic form is Galois conjugation `alpha -> -1-alpha`
exchanging the split primes (C473 table); its extended form is Hadamard row/column duality, the
outer automorphism of `M12` exchanging the two `M11` classes over the frozen `PSL_2(11)` (C470).
The theorem: these are the same involution under the certified dictionaries, its orbit on each
certified carrier is the corresponding incarnation pair, and choosing the bit = choosing a
component of its complement, impossible without a marking (C417/C448/C473).

**(c) Collapse achieved / left out.** Same collapse surface as Candidate A viewed from the acting
side rather than the acted-on side — the two candidates are Cayley-dual phrasings and can merge
into one closing theorem ("one torsor, one swap"). F adds one thing A lacks: the `M12`/Hadamard
extension (C470) enters as a realization of the *same* hinge, tying the even/extended layer into
the close. It leaves out mechanism and continuation exactly as A does.

**(d) Certified vs new.** Certified: every clause named above per its C-ID; the C473
normalization-change table already records that C470's outer duality exchanges the primes. New:
the identification of the four forms as *one* involution under the dictionaries (each pairwise
comparison is a bounded finite check; the Rz-vs-Hadamard-duality comparison through C470's coset
grid is the only one not already implicit in a certificate).

**(e) First falsifier.** Push the reduction of `Rz` through C470's signed coset-grid dictionary
and check it lands in the outer (row/column-exchanging) class of `M12` rather than an inner one.
Finite; if it lands inner, the extended form is a different involution and F shrinks back to A.

**(f) Cost and risk.** Days (2--4), largely shared with A's legs. Risk low-medium; the single
genuinely open comparison is the falsifier above.

**(g) Epistemic key.** PROVED-assembly for each form separately; REASONED for their identification
as one involution.

## Ranking

1. **A — torsor Rosetta** (primary)
2. **B — modular-derived cubic** (backup)
3. **F — outer hinge** (merge into A if its falsifier passes; A+F together are the strongest
   Paper-1 close available without new mathematics)
4. **C — orbit-category descent** (best bounded *new* theorem; Paper-2-shaped, promote only if
   its `lim^1` falsifier passes)
5. **D — quadratic/Maslov refinement** (highest ceiling, roof-tier; run its one-day falsifier
   regardless, but never as a Paper-1 dependency)
6. **E — conductor-40 carrier** (wrong axis for the Paper-1 close; continuation program)

Rationale: the master-stroke criterion is collapse strength per unit of new proof under a
roof-free constraint. A achieves the widest certified collapse at near-zero new proof and cannot
return empty; B is the only candidate that specifically replaces claim 5's *job* (an arithmetic
origin for the `+/-6`) and composes with A rather than competing with it; F is A's other face and
its `M12` extension is the one cheap widening move. C and D are real theorems-to-be with real
kill-switches and belong to Paper 2's allocation gates. E answers a different question.

**Recommended primary: A (with F merged if its falsifier passes). Recommended backup: B.**
Note the compositional structure: A is the floor, B is A plus a readout formula, F is A plus the
extended layer — a C479 negative can be answered by A alone in days, then upgraded.

## Paper-1 close phrasing under each recommendation

**Under A (+F):** the closing section keeps C445 as the certified arithmetic-gluing flagship and
adds one assembled theorem directly after it: *the decoder's missing bit is one free `C2`-torsor,
canonically realized as the two sheets, the two unipotent classes, the two period factors, the
two split primes of `Q(sqrt(-11))`, the two primes of `Z[phi]` above 11, the two lower Weil
constituents, and the two cubic signs [plus design polarity, Fourier sector, and the `M12` outer
hinge as their legs certify]; the marked Coxeter matching orients every realization at once
through the single trace rule, and after forgetting the marking no section exists.* The
survival/forgetting ledger then reads as the list of passages that do or do not see this one
torsor, and the cliffhanger asks for the mechanism (Paper 2) rather than the object. The
integral golden model survives as claims 1--4 plus a stated boundary: the certified obstruction
(C443/C461, and C479's negative) shows the bit is carried arithmetically by the prime fiber, not
by an integral tensor — which is the torsor theorem's point.

**Under B:** the close is phrased as a derivation instead of a lift: *the sharp cubic-first
threshold is certified (C406/C412), and the sign it computes is an arithmetic residue — the
`+/-6` readout equals the split-prime selection of the marked sheet under the trace rule
`alpha -> tr(T|C)`.* Claim 5's question "which integral object has this shadow" is replaced by
the theorem "the shadow is itself the arithmetic datum"; the cliffhanger then asks whether any
characteristic-zero object realizes it (explicitly open, with C443/C461/C479 as the certified
boundary). If B's uniform-rule falsifier degrades it to per-case dictionaries, B collapses into
one extra sentence inside A's close and A ships alone.

## Next-step discipline

No allocation is made here. If C479 returns negative, the cheap ordering is: run A's two leg
certificates and F's hinge comparison (days, bounded), run D's one-day parity falsifier for the
record, and only then decide whether C's `lim^1` computation is worth a Paper-2 allocation.
Promotion of any candidate to a C-ID goes through the normal queue process.
