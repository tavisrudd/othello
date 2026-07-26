# C80 — minimal spoiling fibres of the q17/q19 decoys

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The marked overload decoys fail for three exact canonical obstruction types.

At q=17, the four `Ω=49` decoy targets form one projective state orbit.  Each
has exactly two minimal spoiling opponent fibres.  The eight fibres split
under the symmetric-square `PGL(2,17)` action into two canonical orbits of
multiplicity four, distinguished already by having respectively 12 and 11
jointly legal strict-`Ω` reply candidates.

At q=19, the marked `Ω=152` decoy has one spoiling fibre, with 14 strict
reply candidates, and hence one canonical fibre in the searched domain.

Every one of the `4·12 + 4·11 + 14 = 106` strict candidates lies outside
not only the positive pairing kernel `M_Ω`, but also the weaker structural
copycat survivor `F_cc`.  Thus these are genuine first-opponent
obstructions to the proposed decoys, not artifacts of the simultaneous
matching requirement.

## Exact extracted fibres

The q=17 rows are:

| marked root opponent | decoy reply | spoiling opponent(s) | strict candidates |
| --- | --- | --- | --- |
| `(4,0)` | `(5,15)` | `(0,1)`, `(0,9)` | `12`, `11` |
| `(5,0)` | `(7,7)` | `(2,10)`, `(6,14)` | `12`, `11` |
| `(8,14)` | `(6,2)` | `(9,6)`, `(3,12)` | `12`, `11` |
| `(11,9)` | `(10,13)` | `(5,12)`, `(8,6)` | `12`, `11` |

The q=19 row is:

| marked root opponent | decoy reply | spoiling opponent | strict candidates |
| --- | --- | --- | ---: |
| `(4,0)` | `(7,1)` | `(3,7)` | 14 |

Here “minimal” means one marked opponent fibre: after that opponent is
played, exhaustive enumeration finds no jointly legal reply with strictly
smaller `Ω` whose target lies in `M_Ω`.  No smaller game-quantifier
obstruction is possible.  The stronger audit finds zero `F_cc` replies in
the same fibres.

The certificate stores every one of the 106 candidates with its target
overload and both membership results.  Its canonical key is the
lexicographically least `PGL(2,q)` image of the complete marked object:
the selected projective set, the spoiling opponent, and the full strict
candidate set.  It also stores the canonical decoy state separately.  The
q=17 state orbit count is one and the marked-fibre orbit count is two.

## Consequence for the admissible-edge search

There is no single q=17 obstruction fibre to explain: even after quotienting
the four coordinate copies of the decoy, two inequivalent marked spoilers
remain.  The q=19 control adds a third finite type rather than reproducing
either q=17 candidate count.

This sharpens the next edge-certificate gate.  A sound nonrecursive
predicate must accept the known q=17 `Ω=40` repairs and q=19 `Ω=169`
survivor, while rejecting all 106 edges in these three canonical spoiling
types.  A rule derived only from the existence of some strict reply, or
from the q=17 state orbit without the marked opponent, cannot do that.
The next cheap comparison should therefore be made on marked
secant/incidence data for the three canonical fibres versus the certified
repair fibres, not on another state scalar or unmarked profile.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_spoiling_fibre_canonicalization.py
python3 rust/scripts/c80_spoiling_fibre_canonicalization.py --check
```

The deterministic generator reconstructs the five marked decoys from the
committed C80 engines, independently identifies empty fibres in two ways,
and writes canonical sorted JSON.  The first route reads isolated vertices
of the filtered strict-reply graph; the second directly enumerates every
opponent and every legal strict reply.  They agree exactly.  Orbit sizes
also satisfy orbit-stabilizer for every record.  `--check` regenerates in a
temporary directory and requires byte equality.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_spoiling_fibre_canonicalization.py` | 11,090 | `569b06a9376c9121a5a0f2a1693d60c19d5ad96c2528c95f62552abe90639092` |
| `notes/2026-07-25-c80-spoiling-fibres.json` | 47,303 | `9e90b146d55f8d330144ead2c0de714fcab4606707947a5e8dc96f2931b96513` |

The trusted boundary remains the frozen normalized prime-grid legality,
`Ω`, `F_cc`, and `M_Ω` implementations.  The two extraction routes share
those primitives, and there is no second projective-game implementation in
this bundle.  The q=19 search domain is only the previously marked decoy,
not a full reply-fibre or all-root census.  The finite orbit split does not
prove that no uniform algebraic predicate can cover all three types.

## `ej` + `tt` closeout

The free strengthening is the `F_cc` result: the 106 candidates do not
merely miss the stronger pairing shell; none reaches the weaker structural
survivor.  This removes matching deficiency as a possible explanation of
these decoy failures.

The Tao-style correction is to keep the opponent mark in the quotient.
Canonicalizing only the q=17 decoy state collapses all four examples to one
orbit and hides the actual obstruction; the marked fibres split into two
orbits.  The proof-producing object must therefore be an edge/fibre
predicate, exactly as the preceding coupled-bank negative suggested.

No incidental discovery-track item arose.  The orbit split and stronger
`F_cc` emptiness are direct deliverables of the requested extraction.

## Mystery ledger

- **[SETTLED] How many minimal q=17 spoiling fibres are present?** Eight:
  two at each of the four marked decoys.
- **[SETTLED] Are the four q=17 coordinate copies genuinely different?**
  No at the state level; all four decoy states lie in one projective orbit.
- **[SETTLED] Does state canonicalization also collapse the obstruction?**
  No.  The marked fibres split into two canonical orbits, of strict-candidate
  sizes 12 and 11.
- **[SETTLED] Is the failure caused only by the stronger pairing shell?**
  No.  All 106 strict candidates also miss `F_cc`.
- **[SETTLED] What is the marked q=19 obstruction?** One spoiler, `(3,7)`,
  with 14 strict candidates, on the stated one-decoy domain.
- **[OPEN — C80] What nonrecursive incidence predicate separates the three
  spoiling types from the certified repairs?** The exact next evidence gap is
  a marked secant/conic comparison that rejects these 106 candidates while
  accepting the q=17 `Ω=40` and q=19 `Ω=169` targets.
- **[OPEN — C80/C82 gate] Can the resulting accepted edges be proved
  opponent-complete uniformly in odd q?** Unknown; C82 remains gated.

## Vibe

Good compression: nine coordinate fibres reduce to three exact marked
types, and the stronger `F_cc` emptiness shows the obstruction is genuinely
structural.  The bad news is equally useful—the q=17 state orbit alone loses
the decisive opponent mark, so the next theorem must live at edge/fibre
level.

go C80 cap compare marked secant/incidence data on the three canonical spoiling fibres and certified repairs
