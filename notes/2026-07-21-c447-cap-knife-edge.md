# C447 — q=11 cap knife edge versus the golden singleton pair

**Lane:** `crowns` (read-only `cap` inputs)

**Date:** 2026-07-21

**Verdict:** `SHARP NEGATIVE FOR THE GOLDEN SINGLETON PAIR; GREEN TYPE-CORRECT REPAIR VIA THE 66 SHARED-EDGE CROSS-SHEET PAIRS`

## Result

The committed cap feature dump has exactly two q=11 knife-edge classes, 4 and 7.  Each has seven
on-conic children, frame stabilizer `D10` of order ten, and child-orbit/value split

```text
class 4:  P {1,4}       + N {6,7,8,9,10},
class 7:  P {3,4}       + N {1,2,5,6,9}.
```

The parameter is `w=r-rho` on the reconstructed hyperbola.  The two affine conics and the explicit
column-vector projectivities from cap coordinates `[r:c:z]` to the standard C406 conic
`XZ-Y^2=0`, parametrized by `[1:w:w^2]`, are

```text
class 4: (r-9)(c-3)=5,   cap -> standard = [[0,9,6],[0,0,1],[1,0,2]],
class 7: (r-4)(c-8)=10,  cap -> standard = [[0,10,8],[0,0,1],[1,0,7]].
```

Composing with C406's frozen standard-to-H3 matrix

```text
[[10,2,1],[1,2,10],[3,0,3]]
```

gives the requested projectivities directly into the frozen H3 coordinates:

```text
class 4: [[1,2,9],[10,9,6],[3,5,2]],
class 7: [[1,1,1],[10,10,3],[3,8,1]].
```

The checker verifies these matrices on all ten affine conic points and the two burned points, and
then against all twelve ordered points in the frozen C406 JSON.

The two knife-edge configurations do not themselves supply a binary label.  Exactly ten
projectivities carry class 4's frame, P pair, and N orbit to those of class 7.  One is

```text
w |-> 1/(4w+10),        matrix [[0,1],[4,10]].
```

Thus the two cap configurations form one `PGL_2(11)` orbit at the conic-data level; assigning one
to the base singleton and the other to the J-mate would already require an external choice.

## Identification verdict

The proposed identification of the size-two P orbit with the golden singleton pair is false in
the only projectively meaningful, equivariant sense.

First, the two sides have different object types.  The cap P orbit is a two-subset of the twelve
conic points.  The two C406 singleton fibres are two *perfect matchings* in the 22-element marker
orbit.  Under the frozen parameter projectivity, neither cap P pair is even an edge of either
singleton matching.

More decisively, the symmetry groups obstruct every attempted repair:

- each cap frame stabilizer is `D10`, with five determinant-square and five
  determinant-nonsquare elements and projective element orders `1^1 2^5 5^4`;
- each frozen singleton matching has stabilizer `A5` of order 60 entirely inside
  `PSL_2(11)`, with element orders `1^1 2^15 3^20 5^24`;
- the unordered pair of singleton matchings has setwise stabilizer `S4` of order 24, with element
  orders `1^1 2^9 3^8 4^6`.

Thus no conic projectivity can conjugate the cap `D10` into either singleton stabilizer: the
determinant character already forbids it.  Nor can it conjugate `D10` into the unordered-pair
stabilizer, whose order is not divisible by five.  Exhaustion of all 1,320 projectivities confirms
zero symmetry-compatible maps for either reading in both cap classes.

An unframed incidence comparison is not a weaker positive result.  For each cap P pair there are
exactly 120 projectivities sending it to an edge of the base singleton and another 120 sending it
to an edge of the J-mate.  Either answer can therefore be manufactured by coordinate choice.  The
frame symmetry is what could have made the comparison canonical, and it is precisely what fails.

Consequently dossier register row 35's singleton claim closes negative.  The cap-to-singleton
comparison is consistency only, not causation; the type-correct cross-sheet repair below supplies
a different exact cap-facing input for X3 alongside C460's positive geometry.

## Free upgrade — canonical shared-edge cross-sheet repair

The failed singleton target has a canonical replacement already inside the same 22-matching
geometry.  Split the 22 matchings into their two eleven-element `PSL_2(11)` sheets.  Among the 121
cross-sheet pairs, exactly 66 share one conic edge.  Exact enumeration proves

```text
{66 unordered conic edges}  <-->  {66 cross-sheet matching pairs sharing one edge}.
```

Every edge occurs once, so the map sending a cross-sheet pair to its shared edge is a
`PGL_2(11)`-equivariant bijection.  For all 66 objects, the matching-pair stabilizer equals the
edge stabilizer, has order 20, and has projective element-order distribution
`1^1 2^11 5^4 10^4` (`D20`).  This is a type-correct orbit-valued bridge, not an arbitrary fitted
projectivity.

Applying the bijection to the cap knife edge gives a unique cross-sheet pair for each P orbit:

```text
class 4: shared edge {1,4} -> one cross-sheet matching pair,
class 7: shared edge {3,4} -> one cross-sheet matching pair.
```

In each case the cap frame's `D10` is a subgroup of the order-20 edge/pair stabilizer.  Its
determinant-square `C5` kernel fixes both P endpoints and both matchings pointwise; every
determinant-nonsquare element swaps the two endpoints and simultaneously swaps the two matchings.
Thus the cap P pair and the selected cross-sheet matching pair are the same local determinant
torsor as *unordered two-sets*.  Choosing a point and choosing a matching require the same one
advice bit, although there remain two possible orientations and no canonical point-to-matching
bijection.

This is the useful bounded repair for C448: the cap smallest-orbit selector canonically returns an
edge, that edge canonically returns a cross-sheet matching pair, and orbit-valued selection avoids
the determinant obstruction.  It does **not** restore the rejected claim that the P pair is the
base/J-mate singleton pair.  The underlying shared-edge relation is classical C379/C406 geometry;
the upgrade claims only this exact cap-facing composition, with no novelty wording.

## 2026-07-22 `ej + aa` addendum — recover the objective, not the false identification

The negative result separates several objectives that the original singleton calculation had
conflated.  The certificate settles the viable replacements as follows.

| objective | verified replacement | exact boundary |
|:---|:---|:---|
| play one winning child in either certified knife-edge class | return either member of the P edge; both recorded members are P | a coordinate tie-break wins but is not an intrinsic equivariant selector |
| give the cap a canonical H3 output | return the unique cross-sheet matching pair sharing the P edge | the output is an unordered pair, not either golden singleton |
| return one matching from that pair | mark a `PSL_2(11)` sheet and take the unique member on it | the sheet mark is extra input |
| correlate a chosen P endpoint with a chosen matching over the cap-frame orbit | choose one of the two `D10`-equivariant bijections between the two determinant torsors | one calibration bit chooses the bijection; the unmarked cap does not |
| explain why the edge is P | prove that cap value factors through the unordered H3 object | not supplied by C447/C448; this is a reconstruction-to-value theorem, not a selector calculation |
| recover the base/J-mate singleton claim | none | zero symmetry-compatible maps and the stabilizer mismatch make the original intrinsic claim impossible |

The calibration statement is deliberately local to the cap-frame `D10` orbit.  The exact C447
records verify that its square `C5` fixes both endpoints and both matchings, while its nonsquare
coset swaps both.  Hence the two two-sets carry the same nontrivial `D10` character, and there are
exactly two equivariant bijections between them.  Choosing one is one global calibration bit for
that transitive cap-frame family, rather than one fresh bit at every position.

It does **not** extend over the full 66-edge `D20` family.  Matching exchange is the determinant
character because it exchanges the two `PSL_2(11)` sheets.  Endpoint exchange is the distinct
dihedral reflection character: the pointwise split torus fixes both endpoints, and its nonsquare
half exchanges the sheets.  Thus an element can fix both endpoints while swapping the matchings.
There is no `PGL_2(11)`-equivariant bijection between ordered edges and ordered cross-sheet pairs;
a sheet mark or equivalent extra datum is genuinely required.

### Alternative attacks and adjacent tasks

1. **Symmetric-consumer attack.**  Keep the certified unordered pair and prove the downstream
   value or construction is unchanged when its members are exchanged.  This is the strongest
   choice-free route and the only one that could explain game value.
2. **Marked-cover attack.**  Add a sheet mark, or add a calibration after restricting to the cap
   `D10` torsor.  This produces a member without pretending the extra orientation was intrinsic.
3. **Operational attack.**  If the only goal is legal winning play, choose either certified P
   endpoint by any deterministic implementation convention.  Naturality is unnecessary for that
   bounded objective.
4. **Randomized attack.**  Uniform choice from either two-set is equivariant in distribution.  It
   removes deterministic bias but does not provide a deterministic section or a value proof.

C449 is genuinely adjacent: its q=11 Coxeter square generates the split `C5` in `PSL_2(11)`, the
same kind of pointwise kernel appearing here after an edge is aligned.  It does not by itself name
an endpoint or matching under full `PGL_2(11)`, because the nonsquare half of its `C10` centralizer
fixes the endpoints while exchanging the sheets.  A sheet mark makes it usable; the bare Coxeter
square does not repair C447.  C436 is only an obstruction stress test.  Whether its generated group
is `PGL_2(11)` or `M_12`, enlarging symmetry cannot create a section already forbidden for the
`PGL_2(11)` subgroup, so C436 cannot recover the singleton identification or prove a game value.

## Mystery ledger

- **Settled by this `ej + aa` pass:** the exact winning-move objective needs no orientation because
  both P-edge members are P; the canonical geometry objective is met by the unordered shared-edge
  pair; a local cap-torsor correlation costs one calibration bit; and that calibration does not
  globalize to all 66 edges.
- **Open — value descent:** it is unknown whether the unordered cross-sheet pair determines the cap
  P/N value by an intrinsic rule.  The evidence gap is a reconstruction-to-value theorem; C296 is
  the gated owning frontier.
- **Open — intrinsic sheet mark:** no cap-owned invariant in the certified input chooses a
  `PSL_2(11)` sheet.  C449 supplies the split kernel but not the missing mark.  Any proposed richer
  input must pass the exact stabilizer test before this can be promoted.
- **No mystery remains about the original singleton target:** it is a proved symmetry-incompatible
  comparison, not an unexplained failed search.

## Exact certificate

The primary generator parses the committed cap dump independently of the cap scripts, reconstructs
the conics and child values, enumerates `PGL_2(11)`, derives the orbit/stabilizer data, checks both
projectivity layers and the class-4/class-7 equivalence, performs the complete compatibility
exhaustion, and verifies the full 66-edge/cross-sheet-pair bijection with all stabilizer equalities.
Its canonical JSON
contains every acceptance object required by X2.

The replay does not import the primary generator or any cap script.  It reparses only classes 4
and 7, independently enumerates projective matrices as scalar-equivalence classes, recomputes the
matching stabilizers and determinant obstruction, checks the conic maps and recorded zero counts,
and reconstructs all 66 shared-edge pairs and their order-20 edge stabilizers.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c447-cap-knife-edge.py --check
python3 notes/2026-07-21-c447-cap-knife-edge-replay.py
sha256sum -c notes/2026-07-21-c447-cap-knife-edge.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-21-c447-cap-knife-edge.py --write
```

| load-bearing artifact | bytes | SHA-256 |
|:---|---:|:---|
| primary generator/checker | 23,157 | `1dc5fd9b02c1642581e9a8b63bd7eb97878446d3858948c0883fcfbfec001d1a` |
| independent replay | 7,640 | `603d81fdf48de2a5668e976454fb39d63ac146b8178e8913453a22e024bafc81` |
| canonical JSON | 21,379 | `8c1e22da244ef2879273d3c0aeefc590e645386f70270e329d030fe48a5906c7` |

The JSON also records SHA-256 hashes and byte counts for the four frozen inputs: the q=11 cap
feature dump, C406 Gate 1 JSON, C406 module JSON, and C458 golden-frame freeze JSON.

## Trusted boundary and limits

The trusted boundary is exact prime-field arithmetic, parsing of the committed cap P/N labels,
the frozen C406/C458 matching and coordinate data, and exhaustive enumeration of `PGL_2(11)`.
The certificate does not re-solve the cap games, claim that the cap values follow from symmetry,
or change any cap-lane artifact.  It proves a bounded q=11 reconstruction, refutes the named
equivariant singleton identification, and certifies its canonical shared-edge cross-sheet repair.
It makes no novelty or literature-absence claim.
