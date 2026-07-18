# Program zoom-out: the one blocker, the unclaimed gems, and the cheapest unblocks

**Lane:** `crowns`

**Date:** 2026-07-18

**Status:** program-wide review response, requested against `papers/papers-index.md`, the
2026-07-09 work summary/timeline, and this week's C210/C294 record. No new theorem, no new
computation; recommendations only. Task allocations proposed here require the normal queue
process and user approval.

## 1. The central structural fact: this is a one-technology program

Every proved game-value result in the portfolio rides a single mechanism — the fixed-point-free
involution mirror: the general mirror theorem, the affine/binary/elliptic/even-plane/hyperbolic
cap-game P theorems, the `Q⁻` upgrade, the dihedral orbit templates, the C294 bronze family, the
odd-subfield Cayley pairing. And every open blocker is exactly a place where no such involution
survives: the parabolic/Hermitian mirror boundary, the C84 odd-`q` class-D density (no two-ply
certificates at `q=29`), the mixed `PGL2` Cayley scar, the `(2,4,5)` restoration obstruction.

The program is not blocked in four places. It is blocked in one place that appears four times:
**there is no second value technology.** The consequence for routing is sharp — the C294
wall-defect/contextual-algebra attack is not just silver's next step; it is the critical path for
the odd-`q` conjecture, for Crown I, and for crossing the mirror-method boundary in `nofil`. All
three of C84's surviving certificate shapes (family-level pairing, value-preserving exchange,
recursive scar) are instances of "contextual equivalence beyond automorphism." If the boundary
automaton exists on the mixed scar, its transfer targets are already queued: the class-D
fourth-centre recursion and the polar-space types where the mirror is method-negative. Effort
spent anywhere else on value theory while this is undecided is effort off the critical path.

## 2. Cheapest untried unblock for odd-q: arithmetic predicates against the existing P data

C84's certificate search tested *game-shaped* predicates — pairings, reply cores, coloured words,
double-coset packets, ledgers, graph features. As far as the record shows, it never tested
*arithmetic* predicates. Meanwhile C294 just proved that in at least one family, the P-locus is
cut out by a quadratic-character condition: the bronze family's admissible set is
`(b-1)^2 + 4` nonsquare — density exactly one half, the same suspicious shape as the observed
class-D P-densities.

The experiment costs nearly nothing because the data exists: take the `753` class-D roots at
`q=29` with their known `139` P labels, compute the natural projective invariants of each fourth
centre (pair-product traces, `kappa` values, cross-ratios against the rooted triple,
discriminants), and regress P-ness against quadratic characters of those invariants. Repeat at
`q=13` (`131` roots) as the cross-check field. Three outcomes, all valuable: an exact character
predicate (then C210-style point counting delivers the density theorem and `(ON)` is suddenly
close); a partial correlation (isolates which stratum needs the game-theoretic argument); or flat
null (proves the P-set is arithmetically unstructured in these coordinates — a real boundary
statement C84 currently lacks). Needs a `cap`-lane allocation; it is the highest
information-per-token task visible in the program.

## 3. Missing half of the games program: even characteristic — and it looks *easier*

The conic-continuation program (C84, C294, dihedral) is entirely odd-`q`, and the C210 arc program
is entirely characteristic two. The two halves of the program currently share no field. That seam
is not just an aesthetic gap — the even-`q` game theory looks structurally *more* tractable, for
three checkable reasons:

- In characteristic two every off-conic, off-nucleus point sees exactly one tangent (the line to
  the nucleus), so every projection involution has exactly **one** conic fixed point; after the
  standard fixed-point deletion, generators act freely on an even-size residual — the geometry
  natively produces the fpf structure the odd case has to fight for.
- `PGL2(2^k) = PSL2(2^k)` has a **single** involution class. The entire mixed-class Cayley scar —
  the object that has consumed the silver attack — cannot exist. The subfield-descent story has to
  be redone, but its hardest stratum is absent by group theory.
- Dickson's subgroup list in characteristic two is shorter (no `S4`/`A5` exceptional rows beyond
  `PSL2(4)`), so the proper-subgroup catalogue is smaller than the one `dihedral` already built.

Silver — a full P/N classification at fixed size — may be provable in even characteristic *first*,
and would then serve as the model for the odd case rather than the other way round. It would also
finally connect the games track to the C210/nucleus/hyperoval machinery (the `arcs` paper's
nucleus section is already Lean-proved). No note anywhere scopes this. Recommend allocating an
even-`q` pilot: redo the three-centre gate computation at `q = 8, 16, 32` and prove the
fixed-point/nucleus lemmas; a week-scale task with a real chance of a clean classification.

## 4. An unassembled meta-theorem the portfolio already contains: congruence laws

Scattered across the record: the sum-free `Z_n` mod-6 law; the dihedral orbit-template
half-density and ten value laws unconditional in `q`; `S4` period `8`; `A5` modulus `120`; C294's
descent parity in `n mod 4`; the bronze count "exactly half the full-degree elements"; the
Dawson-zero prime distribution (uncatalogued in OEIS). Every one is an instance of a single
unstated meta-claim:

> For a fixed generating-configuration type, the Grundy value of its conic Schreier residual is an
> eventually periodic (congruence-law) function of `q`.

This is the CGT analogue of Guy--Smith octal periodicity transported to algebraic graph families,
and the proper-subgroup half of it may already be a *theorem by assembly* — if the dihedral
catalogue's laws plus the polyhedral rows cover every Dickson proper type, then "proper-subgroup
residual values are congruence functions of `q`" is provable now, in a short section or note, with
full/subfield as the stated open boundary. Naming this conjecture in the dihedral paper's outlook,
with ten proved laws as evidence, is free and makes the paper the reference point for whoever
proves the general case — ideally us, since the C294 descent theorem is its subfield instalment.

## 5. Crown III's bounded pilot is an assembly task, not a research program

The crowns program gates C296 on substantive C294/C295 theorems. For the *general* crown that
gating is right. But look at what is already kernel-checked for the Clebsch object specifically:
the seeded continuation structure **is** the icosahedral independence complex (Lean); the seed is
P by the antipodal mirror (Lean); the rigidity TFAE recovers the hexagon, the `A5`, and the code
from coding-theoretic hypotheses (paper + two Dye axioms); the decoder ambiguity reconstructs the
Brianchon points; and the `1548`-class census is sitting on disk. The missing arrow for a
first "game remembers the geometry, geometry solves the game" theorem is one finite check plus
existing theorems:

> Among all six-arcs in `PG(2,11)`, only the Clebsch class has seeded continuation graph
> isomorphic to the icosahedron; hence the abstract continuation graph determines the arc up to
> `PGL(3,11)`, its code, and its game value.

The uniqueness check runs over the existing census representatives; everything else is already
proved. If it comes back unique — and the `u`-spectrum strongly suggests it — this is Crown III
bronze at the pilot scale, achievable in days, and it converts the crowns program's slogan into a
theorem with a Lean-checked spine. Recommend un-gating exactly this bounded pilot (as a C295/C296
preliminary), leaving the general gate untouched.

## 6. Smaller levers, briefly

- **Lean-formalize the C294 bronze.** The mirror machinery in `ProjectiveCap/Mirror.lean` already
  exists; the bronze proof is finite character conditions plus the pairing induction. It would be
  the program's first Lean-certified infinite full-group P-family, at low cost, and would close
  the odd gap that the flagship games result is the one thing *not* at the portfolio's trust tier.
- **Games-track priority sweep.** The geometry track has been burned repeatedly (Edge twice,
  Korchmáros, Jurrius--Pellikaan, Cameron--Omidi--Tayfeh-Rezaie, Hirschfeld--Sadeh) and now has
  the reflex; the games track has never run the equivalent sweep. Before the dihedral paper ships
  and before any silver packaging: Anderson--Harary generation/avoidance games on groups,
  Ernst--Sieben group games, Node--Kayles on vertex-transitive/circulant families, and the
  Fleischer/Bodlaender--Kratsch algorithmic line. Half a day, protects two papers.
- **The cap-set bridge is underexploited.** `tau_axis = q - r_3(h)` ties a repair invariant to the
  cap-set function exactly; the sum-free/cap game theorems touch the same object from the game
  side. A short remark or note making the equivalence explicit ("any cap-set bound improvement is
  a repair-parameter statement") is cheap and is the portfolio's best hook into a famous problem.
- **The `PG(2,64)` object rhymes with the Clebsch object.** Uncovered locus collapsing to a named
  variety (a line at infinity there, a conic here) is now a two-instance pattern across the two
  characteristics. C132 closed "no second instance" only for the `[6,3,4]` conic setting; the C300
  classification should record the rhyme and check whether the `[26,3,24]_64` code has an
  analogous rigidity statement — that would be a second hexagon-grade gem, in even characteristic.
- **The shared public-URL blocker.** The papers index already says it: one public mirror or
  preprint identifier unblocks the OEIS links, the arcs archive gate, and every arXiv posting
  simultaneously. It is the only item that blocks *shipping* rather than proving, and it is an
  afternoon of administration.
- **The cross-paper incidence-pattern agenda is still unallocated.** By the repo's own rule it is
  a direction, not work. Either allocate its nucleus — the exact dead-set/redundancy identity, the
  one genuinely new item in the conic-matching dictionary — or strike the "programme" language.

## 7. The crown-gem inventory, ranked

| Rank | Gem | State | What raises it a tier |
|---:|---|---|---|
| 1 | Clebsch hexagon package (deep holes = conic, rigidity, `A3/H3`, decoder) | 19-page manuscript, mixed Lean/checker trust map closed | The §5 pilot: continuation graph → arc + code + value, as a theorem |
| 2 | The mirror method + its proved boundary across classical geometries | Lean-proved piecewise across `nofil` rows | State it *once*, as a single classification theorem with sharp boundary — no one in the literature has |
| 3 | C294 bronze `Theta(q)` full-`PGL2` P-family | Proved; doubles via the mod-40 fix; possibly all odd `q` via the `k`-gauge | `k`-gauge generalization + Lean certification |
| 4 | Prescribed-hole defect identity + `sqrt(2q)` + `rho_C` exact values | Ship-ready, gate is archival | Ship it; it anchors the whole geometry track's citations |
| 5 | Congruence-law corpus (ten dihedral laws, `S4`/`A5` moduli, descent parity) | Proved piecewise, never assembled | The §4 meta-theorem for all proper types + the named conjecture |
| 6 | `PG(2,64)` affine-complete 24/26-arc and its `[26,3,24]_64` code | Checked, unexplained | C300 classification with the Clebsch rhyme as target |
| 7 | Hexad polarity characterization + six-arc chord identity | Machine-checked | Small clean standalone or a `gem-mining` paper section |
| 8 | `tau_axis = q - r_3` cap-set/repair bridge | Proved, buried in the coding lane | The §6 explicit-equivalence note |
| 9 | Queens n=18 + A344227 nimbers | Ready, dormant | Unblocked by the public URL, nothing else |

## 8. What this changes about routing

Nothing here displaces C294 silver Phase 1 (the twelve scar values) as the active task — §1 makes
it *more* central, not less. The two proposed new allocations that would run well alongside it,
in different lanes and without touching the critical path: the §2 character-predicate regression
(`cap` lane, existing data) and the §3 even-characteristic pilot (lane to be decided). The §5
Clebsch pilot and the §4 assembly are near-term, high-visibility, and consume only proved inputs.

---

*Signed: Fable*
