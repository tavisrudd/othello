# C447 — q=11 cap knife edge versus the golden singleton pair

**Lane:** `crowns` (read-only `cap` inputs)

**Date:** 2026-07-21

**Verdict:** `SHARP NEGATIVE; THE KNIFE EDGE RECONSTRUCTS, BUT THE GOLDEN IDENTIFICATION IS NOT EQUIVARIANT`

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

## Identification verdict

The proposed identification of the size-two P orbit with the golden singleton pair is false in
the only projectively meaningful, equivariant sense.

First, the two sides have different object types.  The cap P orbit is a two-subset of the twelve
conic points.  The two C406 singleton fibres are two *perfect matchings* in the 22-element marker
orbit.  Under the frozen parameter projectivity, neither cap P pair is even an edge of either
singleton matching.

More decisively, the symmetry groups obstruct every attempted repair:

- each cap frame stabilizer is `D10`, with five determinant-square and five
  determinant-nonsquare elements;
- each frozen singleton matching has stabilizer `A5` of order 60 entirely inside
  `PSL_2(11)`;
- the unordered pair of singleton matchings has setwise stabilizer `S4` of order 24.

Thus no conic projectivity can conjugate the cap `D10` into either singleton stabilizer: the
determinant character already forbids it.  Nor can it conjugate `D10` into the unordered-pair
stabilizer, whose order is not divisible by five.  Exhaustion of all 1,320 projectivities confirms
zero symmetry-compatible maps for either reading in both cap classes.

An unframed incidence comparison is not a weaker positive result.  For each cap P pair there are
exactly 120 projectivities sending it to an edge of the base singleton and another 120 sending it
to an edge of the J-mate.  Either answer can therefore be manufactured by coordinate choice.  The
frame symmetry is what could have made the comparison canonical, and it is precisely what fails.

Consequently dossier register row 35 closes negative.  X3 retains only its abstract
orbit-valued-selector statement; C447 supplies no cap-to-golden causation or identification.

## Exact certificate

The primary generator parses the committed cap dump independently of the cap scripts, reconstructs
the conics and child values, enumerates `PGL_2(11)`, derives the orbit/stabilizer data, checks both
projectivity layers, and performs the complete compatibility exhaustion.  Its canonical JSON
contains every acceptance object required by X2.

The replay does not import the primary generator or any cap script.  It reparses only classes 4
and 7, independently enumerates projective matrices as scalar-equivalence classes, recomputes the
matching stabilizers and determinant obstruction, and checks the conic maps and recorded zero
counts.

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
| primary generator/checker | 15,090 | `4a9c7381f98dde08159901a38f01702b4ada9335687a3ff86e37880c04d119fc` |
| independent replay | 3,915 | `2b0e0917d7b1ffd54942eef0a3ac5b761bc2cf46067677c56588c954f4093b4c` |
| canonical JSON | 7,144 | `d5ab60fba45849a7aa24707f8ddffc1099be654b9fff7bdbe7b455c54f91d64c` |

The JSON also records SHA-256 hashes and byte counts for the four frozen inputs: the q=11 cap
feature dump, C406 Gate 1 JSON, C406 module JSON, and C458 golden-frame freeze JSON.

## Trusted boundary and limits

The trusted boundary is exact prime-field arithmetic, parsing of the committed cap P/N labels,
the frozen C406/C458 matching and coordinate data, and exhaustive enumeration of `PGL_2(11)`.
The certificate does not re-solve the cap games, claim that the cap values follow from symmetry,
or change any cap-lane artifact.  It proves a bounded q=11 reconstruction and refutes the named
equivariant identification.  It makes no novelty or literature-absence claim.
