# Master-stroke ej pass — extra value from the certified torsor-Rosetta close

**Lane:** `crowns`

**Date:** 2026-07-22

**Status:** ej closeout pass on the certified close ("one torsor, one swap", banked in
`2026-07-22-alt-master-strokes.md`, all legs certified in `2026-07-22-c480-close-gap-certificates.md`);
no allocation.

Inputs read in full: the alt-master-strokes note, the C480 gap-closing certificates, C473, C445,
the integral-golden-model note, and the Close revision block of `2026-07-20-clebsch-paper-planning.md`.
Additional pulls: the `reed-solomon` lane handoff (`notes/handoffs/2026-07-22-reed-solomon-deep-holes.md`),
the C482 preflight (`2026-07-22-c482-generic-degree-preflight.md`, owner-directed), and the C448 row
of the weil-roof results ledger. C368/C398/C474 facts below are consumed from the
handoff's certified summaries and the owner's brief, not re-derived. Every exact computation in this
pass is replayable via

```bash
python3 /tmp/claude-1000/-home-tavis-src-othello-rust/5b0be73a-68e6-49f6-a333-7cff28705cb1/scratchpad/ej_arith.py
```

(pure integer arithmetic, Euler-criterion Legendre symbols; the load-bearing values are reproduced
inline below so the note is self-contained if the scratchpad is gone).

## 1. Cheap upgrades within reach of the close

### 1.1 Rank-three completion: the q=5 degenerate form makes the torsor statement three-of-three

The close is stated for `q = 7, 11`. The A3/q=5 case is not an absent third instance; it is the
degenerate value of the same statement, and the pieces are already certified. C445's closing theorem
records "the A3 Frobenius-conjugate spin lifts fuse to one projective marker fibre over `F_5`", and
the golden-model note's uniform clause (claims 1--4, certified per the planning doc via
C441/C442/C444/C445/C458) gives the mechanism: 5 is inert in the A3 frame field, so the two
would-be sheets are Frobenius-conjugate and fuse.

REASONED (assembly of certified parts, no new computation): the rank-uniform statement is that each
frame carries an etale `C2`-algebra of orientations — the two-element fibre with its Galois action.
When the working prime splits in the frame field (B3 at 7, H3 at 11) the algebra is split: two
points, a free `C2`-torsor, no equivariant section, one classical bit that exists but cannot be
canonically chosen (C417/C448/C473). When the prime is inert (A3 at 5) the algebra is connected: one
closed point, Frobenius-fused, and there is no bit at all. "No unpointed section" and "no bit"
are the two faces of one dichotomy — the torsor is trivialized not by acquiring a section but by
losing its second rational point. This upgrades the close from a two-case theorem with a boundary
remark to a rank-three trichotomy-free statement (split => free torsor, inert => fused point), at
the cost of one paragraph. Proposed as a queue candidate (assembly-only certificate: check the
fused F_5 fibre is literally the Frobenius orbit of the two spin lifts under the certified A3 data).

### 1.2 The B-falsifier residue asymmetry: no rule one level up is certifiable from two cases — and the exact experiment that would decide one

C480's B leg found residue value `0` names the *opposite* sheet at q=7 but the *marked* sheet at
q=11. The question posed: does the per-case sign covary with something certified — `(2/q)`,
`(-1/q)`, silver/golden, det of the outer element — resurrecting a uniform rule one level up?

Computed exactly (script above):

| q  | (5/q) | (2/q) | (-1/q) | (-3/q) | q mod 8 | marked residue |
|:---|------:|------:|-------:|-------:|--------:|:---------------|
| 7  |    -1 |    +1 |     -1 |     +1 |       7 | `-1` (=1, F_2) |
| 11 |    +1 |    -1 |     -1 |     -1 |       3 | `0` (F_3)      |

- `(-1/q)` is `-1` at both primes: cannot covary. Same for the outer determinants (2 at q=11,
  `-1` at q=7): both nonsquare by construction (C445/C480-A1), so their square classes carry no
  distinguishing datum.
- `(2/q)` flips between the primes and matches: marked residue is `-1` exactly when `(2/q) = +1`.
  Note `(2/q) = +1` is also exactly the silver case (`q` split in `Q(sqrt2)`: q=7) and `(5/q) = -1`
  its complement, so "covaries with `(2/q)`", "covaries with silver/golden", and "covaries with
  q mod 8" are the same one-bit statement here.
- But so does `(-3/q)` (equivalently `q mod 3`): `+1` at 7, `-1` at 11 — a different natural
  character that also fits both cases.

The structural point, and the answer to the question: **with two data points, any character that
separates 7 from 11 covaries perfectly, so no uniform rule one level up is certifiable from the
current configuration** — the apparent structure is underdetermination, not evidence. This is the
sharp reason the mystery survives C480's exhaustion of *residue-side* rules: the *character-side*
rule space is nonempty but has at least two inequivalent members fitting the data.

What makes this actionable rather than a shrug: the two families diverge at the first
frame-compatible prime beyond 11. Computed: q=19 has `m = (q+1)/4 = 5` prime (the trace-rule frame
`x^2 + x + m ≡ x(x+1) mod p`, `p = m`, extends verbatim: roots `{0, 4}` in `F_5`), and

- the `(2/q)`/silver/golden family predicts marked residue `0` at q=19 (since `(2/19) = -1`, like 11);
- the `(-3/q)` family predicts marked residue `-1` (=4 in `F_5`) (since `(-3/19) = +1`, like 7).

SPECULATIVE as a prediction (no frozen q=19 configuration exists; whether one does is a
continuation-program question), but the fork itself is exact and computed. If a q=19 marked
configuration is ever frozen, one trace computation kills at least one family. Recorded as the
canonical falsification site; proposed for the discovery track of the continuation program.

### 1.3 Cliffhanger primes: what the close forces for free

Exact facts (same script):

- **q=19 is character-identical to q=11**: its full C466 character triple
  `((5/q), (2/q), (-1/q)) = (+1, -1, -1)` equals 11's, and its trace-rule characteristic
  `p = (q+1)/4 = 5` is prime. Among the C453 cliffhanger primes, 19 is the unique one where the
  C473 frame specializes with no modification at all. Sharper than the current wording: the torsor
  statement's q=19 instance is *fully typed* today (coefficient field `F_5`, split primes
  `(5, alpha)` and `(5, alpha + 4)` of `Q(sqrt(-19))`, trace rule verbatim); only the geometric
  carrier is missing.
- **q=31 breaks the frame pattern**: `m = (31+1)/4 = 8` is composite, so `p = m` fails for the
  first time. But `-31 ≡ 1 mod 8`, so 2 splits in `Q(sqrt(-31))` and `x^2 + x + 8 ≡ x(x+1) mod 2`:
  the natural H4-era coefficient characteristic is 2 (via `p | m`), with lower-constituent
  dimension `(q-1)/2 = 15`. SPECULATIVE beyond the computed splitting facts. Also computed:
  31 splits in *both* `Q(sqrt5)` and `Q(sqrt2)` (`(5/31) = (2/31) = +1`) — the first prime where
  the golden/silver dichotomy itself degenerates, consistent with C453's "fused" disposition being
  a genuinely new regime rather than a repeat of A3-style inertness (which was `(5/13) = -1`,
  `(2/13) = -1` at 13). REASONED gloss on certified C453/C466 characters.

So the certified close does force something for free about the cliffhangers: 19 is the canonical
third test case (frame extends verbatim, characters match 11, and section 1.2's fork lives there),
and 31 is structurally *not* a fourth instance of the same frame — composite `m`, characteristic
forced down to 2, and both real quadratic frames split simultaneously. The prophecy's program
wording can be sharpened accordingly (proposed, no edit made).

### 1.4 M12 layer: one free clause not yet in the closing statement

C480-F certifies `N_{M12}(PSL_2(11)) = PSL_2(11)`, `PGL_2(11)` not a subgroup of `M12`, the two
`M11` parents non-conjugate in `M12`, and the sheet swap realized only by the outer
row/column-exchanging class. Free strengthening already implicit (REASONED assembly, zero new
computation): **at the extended layer the bit is invisible to every inner symmetry** — no element
of `M12` whatsoever induces the sheet swap on the frozen `PSL_2(11)`, so any labeling of the two
`M11` parent classes is pure `Out(M12)` gauge, exactly mirroring C417 one level up. At the sheet
level the swap at least lives in the index-2 overgroup acting on the same `P^1`; at the Mathieu
layer it cannot be realized without leaving the group entirely. This is a one-sentence sharpening
of the "outer `M12` hinge" row: the hinge is not just outer, it is *forced* outer by
self-normalization. The `S(5,6,12)`/Hadamard layer thereby joins the realization list canonically
(the parent-class pair is the torsor's Steiner-system face, via C470's certified duality); no new
certificate needed beyond C470 + C480-F. On 2.M12: C473's normalization table already certifies the
C472 central signed lift is orientation-inert ("fixed — uniform scalar; unique complement is
pure"), so there is no extra sign story to extract there; that question stays closed.

## 2. The three no-section certificates: one class or three?

The close cites the no-section clause three ways: C417 (nontrivial cocycle), C448 (equivariant
orbit-valued selector exists; point-valued section costs exactly one bit — ledger row), C473 (free
`C2`-torsor, no natural section). Are these THE SAME obstruction class under certified
dictionaries, or distinct?

REASONED: they are three functors of one class — the class of the orientation torsor `T_q` itself.
C473's identifications are certified *torsor isomorphisms*, so all five (now ten) realizations
share one isomorphism class; C417's cocycle is the Cech expression of that class on the sheet
carrier; C448's one-bit selector cost is its information-theoretic norm (`log2 |T_q|` with free
action). What is certified today is each obstruction separately plus the torsor isomorphisms among
the *carriers*; what is not yet a certificate is the two comparison squares "C417's class = image
of `[T_q]` under the sheet dictionary" and "C448's cost bound is attained exactly by `[T_q]`'s
nontriviality". Both look like bounded assembly lemmas over already-frozen data (the same shape as
C480's legs: push one certified object through one certified dictionary and compare). Either
outcome is a sharp closing-theorem clause: "the three certified obstructions are one class" is the
stronger sentence and the expected one; "provably distinct" would be a genuine discovery. Proposed
queue candidate (small; days at most). Until it lands, the closing theorem should continue to cite
the three C-IDs as three certificates, not as one class.

## 3. Overly loose: certified strength the theorem does not consume

Ranked by what the unconsumed clause could buy.

1. **A2 total agreement (strongest).** C480-A2 proves `Rz` and C378's involution `J` induce the
   *identical* permutation on all 16 scalar-`A4` relations (`Rz o J^{-1} = id`), while the close
   consumes only the four signed-sector pairs. Unconsumed: the entire even part. What it buys: any
   Fourier-side observable — even-sector statistics, future quantum/LU quantities built on C378's
   scheme (the C456/C467 boundary) — is automatically swap-equivariant with no new certificate; the
   outer action on the whole Fourier scheme is pinned, not just on the torsor quotient. This is the
   cheapest source of future "survival ledger" rows.
2. **F's amalgam data.** C480-F proves `P ∩ K = PSL_2(11)`, `<P, K> = M12` on top of the consumed
   self-normalization. Unconsumed: `M12` is the amalgam closure of the two parents over the frozen
   intersection. What it buys: a presentation-level route for Paper 2's gluing mechanism (the
   char-11 gluing as an amalgam statement), and the section-1.4 clause above.
3. **C473 intertwiner rigidity.** The certificate carries full explicit companion-matrix
   intertwiners with both group orders (168, 660) generated and every power gauge exhausted; the
   close consumes only the trace rule. Unconsumed: a frozen-basis realization of the selected lower
   constituent strong enough to support any future integral-lattice comparison (relevant only if
   C479 is ever resumed).
4. **A1 determinants (explained, nothing to buy).** Spinor norm 2 of `Rz` (C445) and determinant
   `2 mod 11` of its reduction agree on the nose, but only the square class is invariant under the
   dictionaries, so the on-the-nose equality carries no extra datum; likewise `-1` vs `2` at the
   two primes are just two nonsquare representatives (C480 already marks this expected).

## 4. Program implications beyond Paper 1

### 4.1 Paper 2 / weil-roof

- **The sequel's question is sharpened, not changed**: with the object certified and closed, Paper
  2 owns exactly the *mechanism* of the characteristic-q gluing (as the Close revision already
  says). What the close adds: the mechanism target now has a certified restriction profile it must
  hit — any candidate mechanism must induce the C480-certified swaps on all ten realizations.
  Candidate C (orbit-category `lim^1`, from the alt-master-strokes note) is thereby *promoted in
  shape*: its first-gate falsifier ("does the class restrict to the C472 central word") now
  extends to a ten-row restriction test, making the gate more decisive in both directions.
  Candidate D's one-day outer-parity falsifier is still worth running for the record, as the
  banked note already ordered; nothing here changes that.
- **C465/C471/C474 carriers**: unchanged as the top-ranked mechanism package (planning doc), but
  their role is sharpened from "explain the structure" to "explain why the *torsor* glues" — the
  metabolic-but-nonsplit carrier must be exhibited as the thing whose two orientations are `T_q`'s
  two points, which is a more falsifiable brief than before.
- **C472 gluing phase**: demoted for orientation purposes (C473's table certifies the central lift
  is orientation-inert) but untouched as the signed-lift question; it should no longer be listed
  among candidate carriers of the bit.
- **C466 Dickson / conductor-40**: the close settles that Candidate E is continuation-axis, not
  Paper-2-axis; its sharp negative ("no tested object carries all three characters") plus section
  1.3's computed fact that 31 degenerates the golden/silver dichotomy suggests the conductor-40
  carrier hunt should be re-aimed at the 31-regime first, where the two real frames merge.
  REASONED.
- **C459 descent**: its certified `Spec Q(sqrt5)` intrinsic recovery (ledger row) is the
  characteristic-zero face of the torsor — the degree-six resolvent `Q(sqrt5)^3` with no rational
  section is the same no-section shape upstairs. Cheap check worth queueing: does the outer swap
  exchange C459's cocycle pair under the certified dictionaries, adding a characteristic-zero
  realization row to the close? If yes, the torsor list acquires its first non-finite entry.
- **Phase-3 synthesis go/no-go**: the close lowers the bar for "go" — the synthesis no longer needs
  to *produce* the unifying object (it exists, certified); it needs only mechanism plus
  continuation. A no-go on mechanism would now leave a shippable Paper 2 shaped as
  "the object, its ten realizations, and the certified boundary of every mechanism attempt",
  which was not true before the close. REASONED.

### 4.2 Reed-Solomon lane (C475 atlas / C478 controls / planned separation theorem)

The close defines "geometric recovery" as: a pointed torsor with a trace rule — recovery succeeds
exactly on the pointed category, and the unpointed output type is a torsor isomorphism, not a
point (C473's output-type correction). Visible implications:

- **C478's q=8 collapse is the same shape.** The handoff records the q=8 `3+3` collapse under the
  colourwise Frobenius quotient as "exactly erased `Gal(F_8/F_2)` orientation". That is verbatim a
  torsor-erasure statement (with `C3` in place of `C2`). The planned C484 descent theorem
  ("q=8 `C3` orientation explained structurally") can import C473's pointed/unpointed framing
  wholesale: state the recovery as unqualified on the pointed category and as a torsor
  identification after forgetting, rather than as a qualified failure. Free precision, no new
  mathematics. REASONED.
- **C474's one-bit loss at q=11 is plausibly the same bit.** Decorated recovery reverses the
  transform in exactly two of the four classes with a one-bit loss at q=11 (owner's brief; C474).
  Whether that bit is torsor-isomorphic to `T_11` under a certified dictionary is, as far as this
  pass can see, *not yet a certificate* — and it is the single highest-reach bounded check the
  close makes available (see section 5.4). If it passes, Paper 1's torsor and the RS lane's
  extremal fibre are provably one object, and the C485 synthesis inherits the no-section clause
  with three certificates behind it.
- **C482's pure/child-relative separation is the moduli-level analogue of pointed/unpointed.**
  The C482 preflight (`2026-07-22-c482-generic-degree-preflight.md`, read in full for this pass)
  proves three abstract projections have a positive-dimensional generic fibre (Jacobian ranks
  `6/9/12` for 2/3/4 centres, exact at `F_101` and `F_256`) while C478's three-fibre recoveries
  succeed only because the fixed ambient child is retained as side information; C485 must state
  pure and child-relative reconstruction as separate clauses. That is structurally the same
  discipline the close enforces: recovery statements must declare their pointing datum (the
  marked matching there, the ambient child here), and the unpointed/pure clause has a different
  and weaker output type. The mechanisms must not be conflated — C482's pure-side loss is a
  continuous moduli dimension, the close's is a free finite torsor — but the clause-separation
  *format* is one pattern, and C485 can adopt the close's typed phrasing ("the pure output is an
  identification up to the residual fibre, not a point") verbatim. No conflict with anything
  above: the C474 one-bit loss and the transform of section 5.4 are fixed-child (child-relative)
  statements, so C482's pure-side negative does not touch them.

### 4.3 Continuation program (13 / 19 / 31, H4, mod-40)

Strengthened and re-aimed. Before the close, the cliffhanger asked for an object and a law; the
object is now certified at 7 and 11, so the program becomes *specialization of a known frame*:

- 13 (inert, `m` non-integral as a prime-frame: `(q+1)/4 = 3.5`): stays the negative control.
- 19: promoted to canonical next instance — frame extends verbatim (`p = 5` prime), full character
  agreement with 11, and it hosts the section-1.2 fork that would decide the residue-rule family.
- 31 / H4: re-aimed — not a fourth instance of the rank-3 frame (composite `m`, characteristic
  forced to 2, golden/silver dichotomy degenerate). The H4 door should be planned as a new-regime
  statement, not a parameter bump. The mod-40 law (C453) now has a frame to specialize, rather
  than only characters to tabulate: each residue class should be assigned its predicted
  torsor disposition (split-free / fused-connected / degenerate-frame) as a stated conjecture.
  SPECULATIVE beyond the computed splitting facts.

### 4.4 Priority shifts visible from the close

- **C479 resumption**: strictly optional and mildly *disfavored* beyond its option value. The close
  currently states, as content, that the bit is carried by the prime fiber and not by an integral
  tensor (C443/C461). A C479 GREEN would append a realization but would also force rewording of
  that clause from "not by an integral tensor" to "also by an integral carrier" — a small but real
  editorial cost against an already-shipped-shape close. Resume only if Paper 2's mechanism work
  independently wants the integral carrier. REASONED.
- **QR-ladder scanning** (queued item not loaded by this pass; statement is REASONED from A1
  alone): C480-A1 identifies the QR/QNR skew-Hadamard Barker-polarity flip with the sheet swap at
  both primes. Any scan over q ≡ 3 mod 4 QR designs is therefore now *for* locating which q admit
  the full realization stack above the design pair (matching sheets, unipotent classes, trace
  rule) versus the bare polarity torsor that every such q has trivially. The scan's positive
  criterion can be stated in advance: `m = (q+1)/4` prime is the frame-compatibility line
  (7, 11, 19, ...), per section 1.3.

## 5. Usability: converting depth into reach

Ranked by value-per-cost at the end of this section.

### 5.1 A portable template theorem (the pattern, abstracted)

The close instantiates a pattern that is stateable with no Clebsch vocabulary. REASONED (the
abstraction is near-formal; its value is as a checklist, not as deep mathematics):

> Let `G < G*` with `[G* : G] = 2`. Suppose given carriers `X_1, ..., X_n`, each a `G*`-set with a
> distinguished two-element quotient on which `G*` acts through `G*/G`, together with certified
> `G*`-equivariant identifications of these quotients, and one pointing datum `M` whose full
> `G*`-stabilizer lies in `G`. Then the quotients are one free `C2`-torsor; marking `M` selects one
> point of every carrier simultaneously (read by any one equivariant readout, e.g. a trace rule);
> and no `G*`-equivariant section exists unpointed — the type-correct unpointed output is the
> torsor identification itself.

Minimal hypotheses: (i) the two-element quotients with outer action, (ii) the equivariant
comparison maps, (iii) `Stab_{G*}(M) ≤ G`. Everything in the close is an instance
(`G = PSL_2(q)`, `G* = PGL_2(q)`, `M` = the Coxeter matching); the RS q=8 `C3` case is the obvious
next instantiation with `C2` replaced by a cyclic Galois group. Cost: an afternoon to state and
prove (it is formal descent); value: it is the organizing lens that makes every future "erased
orientation" finding a one-line corollary instead of a bespoke theorem. It also names the failure
modes: a leg falsifies exactly when (ii) fails (C480's demotion rule for legs, already exercised
by B). Scope caution from C482: the template covers *finite* discrete losses only; C482's
positive-dimensional pure-reconstruction fibres are a different (continuous) loss type, and an RS
instantiation of the template applies to the child-relative clause, never as a substitute for
C482's dimension counts.

### 5.2 The most reusable single leg

Ranked:

1. **The trace rule** (C473): `alpha -> tr(T|C)` reads a split-prime choice of `Q(sqrt(-q))` off
   one modular character value of a unipotent on a lower constituent, with no basis choice, no
   polynomial factorization, no period-table names — valid whenever `p | (q+1)/4`-style frame
   conditions hold (7, 11, 19, ... computed in 1.3). This is a genuinely portable computational
   tool for anyone relating modular representations of `PSL_2(q)` to imaginary quadratic
   arithmetic.
2. **The self-normalization discriminator** (C480-F method): to decide whether a symmetry extends
   inner or outer in an ambient group, compute `N_{Ambient}(L)` and the induced automorphism class;
   `N = L` forces every extension outer. One bounded computation, decisive both ways; applicable to
   any exceptional-embedding situation (the `M12` result is the exemplar).
3. **The gauge-exhaustion table style** (C473's normalization-change table): as a documentation
   pattern — every convention the result could secretly depend on gets one row with
   fixed/exchanged and a reason. This is what made the B falsifier cheap to state and fire. Style,
   not theorem, but it is the export most likely to be copied.

### 5.3 Cheap user-facing corollaries (non-RS)

- **Design theory** (cheapest): for q = 7, 11 the QR <-> QNR (Barker polarity, skew-Hadamard
  complement) flip on the Paley difference set is induced by one explicit Mobius map of nonsquare
  determinant, and this map simultaneously swaps two icosahedral/cubic matching sheets and two
  split primes of `Q(sqrt(-q))` (C480-A1 + C473). Standalone needs only: difference sets,
  `PGL_2(q)`, and the statement. Essentially a framing exercise over existing certificates.
- **Quantum information**: the C456/C467 erasure theorems restate as "the decoder's advice is one
  classical bit that no LU-invariant sees; the LU passage forgets exactly the point of a free
  `C2`-torsor". Standalone cost is medium (the LU framing has to be carried along); value depends
  on Paper 1's quantum boundary section, where it already lives.

### 5.4 The non-GRS <-> GRS connection (strongest reach lever)

Certified base: C368 (arithmetic phase: non-GRS q=11 parent with full-conic GRS child), C398
(complete four-class classification of conic-contained non-GRS deep-hole configurations at
q = 8, 9, 9, 11), C474 (fixed-child fibre sizes 6/8/2/22; decorated recovery reverses the
transform in exactly two classes; one-bit loss at q=11).

**(a) Standalone transform statement.** Pure parity-check language, minimal definitions needed:
redundancy-3 code <-> `3 x n` parity-check matrix <-> projective arc `A` in `PG(2, q)`; GRS <->
`A` on a nonsingular conic; deep hole / weight-3 coset <-> syndrome point on no secant of `A` <->
one-column MDS extension (all already fixed in the RS handoff's coding dictionary). The transform:
send a non-GRS MDS parent to the conic-supported child its deep-hole geometry determines; C398
proves the four-class classification of what can sit over a conic child, C474 computes every fixed-
child fibre. The torsor enters as the exact information loss at the extremal fibre: REASONED —
the q=11 one-bit loss is the candidate literal instance of `T_11`, and the missing piece is one
bounded certificate ("the C474 q=11 recovery ambiguity is exchanged by the reduction of `Rz` /
lands in the outer coset, torsor-isomorphically to C473's identification"). That single check is
the cheapest new certificate with the highest reach available anywhere in this pass: it would make
the close's central object appear inside a plain coding-theoretic inversion theorem.

**(b) User-facing corollary — a deep-hole-based non-GRS certificate.** Statement sketch: *given a
redundancy-3 MDS code presented by a parity-check matrix, compute its deep-hole syndrome set and
the decorated fibre data of C474's transform; if the decoration profile matches one of the four
C398 classes, the code is certifiably non-GRS, with the witness being finite, computable, and
independent of any generator-matrix normal form.* For a coding theorist this is a recognition-type
tool: a positive, checkable witness of non-GRS-ness from coset-weight geometry alone. Cost: low-
medium — the mathematics is C398 + C474 as they stand; the work is standalone definitions, the
statement, and the audits in (d). No novelty claim is made here about the recognition problem
itself; the corollary's value survives even if recognition per se is classical, because the
witness *format* (deep-hole decoration) is the program's own.

Both (a) and (b) are child-relative statements in C482's sense: the child configuration is given
and the fibre is finite over it. They are therefore untouched by C482's pure-side negative, and in
C485's mandated clause separation they belong to the child-relative clause, where the torsor is
the exact residual ambiguity at the extremal fibre — a cleaner fit than before C482, since the
close now supplies the typed language for exactly that clause.

**(c) Placement.** State the transform once, in the RS-lane paper (C485's synthesis is its natural
home; the handoff's ceiling statement already reserves the spot). Paper 1 cites the q=11 case as
the extremal instance where the transform's information loss is the paper's torsor. Gains: the RS
paper gets a marquee, program-independent corollary (the non-GRS certificate) plus a principled
language for its exceptional fibres; Paper 1 gets an exhibit that its central object does work
outside its own configuration — the strongest available answer to "usable, not just admired".
Neither paper duplicates the other's proofs; the bridge is one citation each way plus the (a)
certificate.

**(d) Literature-boundary flags before any external wording** (audit surfaces only; no novelty
claims, per `notes/literature-audit-conventions.md`):

- GRS recognition / distinguishing: Sidelnikov--Shestakov-style attacks, Wieschebrink's work, and
  the code-based-crypto distinguisher literature (recognizing GRS structure from a generator
  matrix) — the closest existing "is it GRS" toolset.
- Classical non-GRS MDS constructions: Roth--Lempel codes, Glynn's arcs, hyperoval/oval-derived
  MDS codes, and the Segre/complete-arc line — where the four C398 classes must be positioned.
- Reed--Solomon deep-hole literature: the Cheng--Murray line and successors on deep holes of
  standard RS codes — to bound the deep-hole-side claims.
- The MDS-extension/one-column literature already flagged in the RS handoff's `arcs` bank.

**Value-per-cost ranking of the usability items:**

1. The (a)-certificate identifying C474's q=11 lost bit with `T_11` — one bounded check, program-
   wide payoff. 2. The non-GRS certificate corollary (b) — low-medium cost, highest external reach.
3. The design-theory corollary (5.3) — near-zero cost, modest reach. 4. The template theorem
   (5.1) — cheap, internal-facing value first. 5. The trace-rule abstraction (5.2.1) — medium
   cost, niche but real audience. 6. The quantum restatement — already housed in Paper 1's
   boundary, lowest marginal value.

## 6. Proposed queue / discovery-track candidates (no allocation made)

1. **Queue**: bounded certificate identifying C474's q=11 one-bit recovery loss with `T_11` under
   the certified dictionaries (section 5.4a). Cross-lane bridge; needs its own routing decision
   (RS lane owns the transform, crowns owns the torsor).
2. **Queue**: assembly lemma "the three no-section certificates C417/C448/C473 exhibit one torsor
   class" (section 2).
3. **Queue**: rank-three completion certificate for the q=5 fused fibre as the degenerate torsor
   form (section 1.1).
4. **Queue**: C459 characteristic-zero realization row — does the outer swap exchange the descent
   cocycle pair (section 4.1)?
5. **Discovery track (continuation)**: the q=19 residue-rule fork, with the computed predictions
   of the `(2/q)` and `(-3/q)` families (section 1.2), and the q=31 frame-degeneration facts
   (section 1.3).
6. **Discovery track (RS)**: C484 should import C473's pointed/unpointed output-type framing for
   the q=8 `C3` orientation (section 4.2).

## 7. Mystery ledger

- **B residue asymmetry (the prompt's lead question) — settled negatively at current data, with
  the deciding experiment named.** No uniform rule one level up is certifiable: with only q = 7, 11
  in hand, every 7/11-separating character fits (computed: both `(2/q)` [= silver/golden = q mod 8]
  and `(-3/q)` [= q mod 3] fit), so the covariation question is underdetermined, not structured.
  The exact evidence gap: a frozen q=19 configuration, where the two families give opposite marked-
  residue predictions (0 vs 4 in `F_5`). Proposed owner: continuation program (discovery-track
  item 5).
- **Marked residues select opposite roots of `{0, -1}` at the two primes** — open as before; C473
  already attributes it to independently frozen B3/H3 conventions, and this pass adds that no
  cheap character-side explanation can currently be certified (same n=2 gap as above).
- **19 is character-identical to 11** (full C466 triple plus prime frame characteristic) —
  surprising, computed here, settled as fact; its meaning (whether q=19 hosts a genuine
  configuration) is the continuation program's question.
- **31 degenerates the frame twice over** (composite `m` forcing characteristic 2; simultaneous
  golden and silver splitting) — computed, settled as fact; open what the H4 statement's correct
  regime is. Proposed owner: continuation program / H4 planning.
- **Whether C474's q=11 lost bit IS `T_11`** — open; the single proposed certificate (queue item
  1) settles it either way, and either answer is publishable content (identity: the reach lever;
  distinctness: a second, independent one-bit obstruction in the same configuration, which would
  itself be a finding).
- **Whether the three no-section obstructions are one class** — REASONED yes, open until queue
  item 2 lands.
- **Spinor norm / determinant on-the-nose agreement (2 = 2 mod 11)** — settled as explained: only
  the square class is dictionary-invariant, so the agreement carries no hidden datum (C445,
  C480-A1).
- **A2 total agreement (`Rz = J` on all 16 relations)** — settled by C480 as expected; this pass
  reclassifies it from anomaly-adjacent to the strongest unconsumed clause (section 3.1): its
  content is rigidity of the outer action on the whole Fourier scheme, available free to any
  future even-sector claim.

No other genuine mystery from the certified close remains visible to this pass: every C480 leg
passed independent replay, the one negative (B) is exactly bounded, and the remaining opens above
each have a named experiment, certificate, or owner.

## Vibe check

The close is in the best state a depth result can be: nothing in this pass found a crack, the
loose ends are all *surplus* strength rather than gaps, and the two cheapest next moves (the
C474-bit identification and the non-GRS certificate) would convert the prize from admired to used.
