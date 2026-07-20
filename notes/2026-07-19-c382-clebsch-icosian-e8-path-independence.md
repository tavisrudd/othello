# C382 — Clebsch-to-icosian `E8` path-independence gate

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `RED; CATEGORY AND CHARACTER MISMATCH BEFORE THE ISOMETRY GATE`

## Result

C381's marked integral object and the icosian `E8` lattice do not carry the required `A5`
actions in the same category.  The prescribed cheap gate therefore stops C382 before an explicit
`E8` isometry, root-orbit comparison, or canonicity search.

For a fixed Clebsch parent, the six matched child pairs form `A5/D10`.  Thus the Picard lattices of
the six blow-ups form an `A5`-equivariant family, but one fibre has only its `D10` stabilizer.  There
is no supplied `A5` action on that single marked lattice.  On the icosian side, the natural
single-sided quaternion action is an action of the binary group `2.A5`; its central element acts as
`-I`, so it does not descend to a linear `A5` action.  Quaternion conjugation does descend, but its
rational rank-eight character, in class order `1,2,3,5a,5b`, is

```text
(8,0,2,3,3) = 2*1 + 3 + 3'.
```

The only coordinate-fixed comparison obtained by making the two child exceptional classes
artificially constant lets `A5` permute the six parent classes and fix `H,E7,E8`.  After removing
the canonical class its `E8` character is

```text
2 + (6,2,0,1,1) = (8,4,2,3,3) = 3*1 + 5.
```

The involution traces `0` and `4` disagree.  Moreover this coordinate-fixed action does not
preserve C381's geometric marked family: a general `A5` element moves the matched child pair and
hence moves the blow-up fibre.  It is a diagnostic comparison, not a repair of the category.

Consequently there is no named `A5`-equivariant diagram to test.  Choosing identifications among
the six Picard fibres would introduce unproved transport data; choosing one lattice isometry after
that would suppress a nontrivial torsor.  Both moves are forbidden by C382's stop rule.

The legitimate fibrewise comparison is negative as well.  Restrict to the `D10` stabilizer of one
matched pair.  Its exact action on the eight exceptional classes, equivalently on `K^perp`, has
character `(8,2,3)` on elements of orders `1,2,5`.  Icosian conjugation restricts with character
`(8,0,3)`.  Hence even the stabilizer representations are non-isomorphic over `Q`, so there is no
`D10`-equivariant rational, and therefore no integral, comparison isometry.

## Marked `D8` gate

The integral `D8<E8` calculation is exact but supplies no surviving orientation datum.

- The `112` integer roots `+-e_i+-e_j` form `D8`; adjoining one spinor class gives the `128`
  half-integral roots and the unimodular `E8` overlattice.  Hence `[E8:D8]=2` and
  `E8/D8=C2`.
- The four discriminant classes are `0`, vector, spinor, and cospinor.  The chosen `E8`
  overlattice retains one spinor class.  The outer odd-sign automorphism of `D8` exchanges the two
  spinor classes and therefore does not extend to this overlattice.  Thus the ambient normalizer is
  `W(D8)`, of order `2^7*8! = 5,160,960` and index `135` in `W(E8)`.
- There are exactly `1,344` unordered root pairs of inner product `-1` in `D8`, and `W(D8)` is
  transitive on them.  The stabilizer of C381's unordered inherited `A2` marking therefore has
  order `5,160,960/1,344 = 3,840`.
- The centralizer of `W(D8)` in `W(E8)` is `{+I,-I}`.  The action on the quotient `C2` is
  necessarily trivial.

Thus the glue class is unique only after choosing the `D8` embedding, and the unordered `A2`
marking still has a large stabilizer.  Neither the glue quotient nor the marked-subsystem
centralizer produces the sheet character exchanged by C381's golden `J`.

## Why the icosian actions are different

Let `F=Q(sqrt(5))`.  The icosian order is rank four over the golden integers and rank eight over
`Z`.  Left or right multiplication by a unit binary icosian is faithful on the lattice, so the
central unit `-1` acts as `-I`; quotienting by the centre loses linearity.

Conjugation instead kills the centre.  Over `F`, the quaternion algebra decomposes under
icosahedral conjugation as the scalar line plus the three-dimensional rotation representation.
Restriction of scalars from `F` to `Q` gives `2*1+3+3'`.  In particular an order-two rotation has
trace zero on the rational rank-eight lattice.  This is the character used above.  The calculation
does not assert that conjugation preserves a natural image of C381's effective `D8`; the category
mismatch fires before that question is authorized.

## Exact evidence and independent replay

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-19-c382-clebsch-icosian-e8-path-independence.py --check
python3 notes/2026-07-19-c382-clebsch-icosian-e8-path-independence-replay.py
sha256sum -c notes/2026-07-19-c382-clebsch-icosian-e8-path-independence.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-19-c382-clebsch-icosian-e8-path-independence.py --write
```

The primary pins C379's checker, enumerates the `112` `D8` roots and all `1,344` unordered `A2` markings, proves
transitivity by the standard `D8` simple reflections, constructs `A5/D10` directly from even
permutations, computes the matched-fibre `D10` character, and computes both icosian rational
characters exactly in `Q(phi)`.  The replay imports no C382 code: it pins C379's independent
formula replay, reconstructs the six Sylow-five subgroups of `A5`, obtains the coset character by
conjugation, independently enumerates the marked `D8` orbit and fibre stabilizer, and checks the
two decompositions against the `A5` character table.

The trusted boundary is Python 3 exact integer arithmetic; the standard coordinate description of
`D8<E8`; the elementary discriminant-form proof of the normalizer and centralizer statements; and
the quaternionic fact that conjugation is scalar plus the spatial rotation representation.  The
certificate proves the cheap-gate obstruction.  It does not classify all `A5` subgroups of
`W(E8)`, construct an icosian-to-Picard isometry, or rule out comparisons after adding genuinely
new transport data.

## Sources and claim boundary

Two sources were read at `full text`; one was read at `partial` depth.  This report makes no
novelty or priority claim, and the full-theorem citation/forward-citation audit was not launched
after the mandatory cheap stop.

- **P.-P. Dechant, “The Birth of `E8` out of the Spinors of the Icosahedron.”** Read depth:
  `full text`, arXiv v1, all sections.  Shared-cache key `arXiv:1602.05985`, SHA-256
  `2aa45df48f99b3fc675f976ca3b21679cf65840350baef8145c8c25e45014c35`.  Sections 4--6
  supply the binary-icosahedral left/right actions, the rank-eight Clifford construction, and its
  reduced inner product.
- **J. C. Baez, “From the Icosahedron to E8.”** Read depth: `full text`, arXiv v2, all sections.
  Shared-cache key `arXiv:1712.06436`, SHA-256
  `e9939fe117882fbb897df8b5921f6e36f7140ad1004b4e28119e43a475c49f2b`.  This is an
  expository map rather than a priority source; its icosian section fixes the binary group,
  quaternion, golden-field, and rank-eight lattice dictionaries.
- **R. Winter and R. van Luijk, “The Action of the Weyl Group on the `E8` Root System.”** Read
  depth: `partial`, arXiv v2, abstract and Section 1 through Theorems 1--2.  Shared-cache key
  `arXiv:1901.06945`, SHA-256
  `c41c71202b1b366ca7cec364c9f4241c40fd7790708e48fdab3aefba54893bb2`.  It supplies the
  explicit `E8` coordinate convention and the orbit/extension framework for small marked root
  cliques; the task-owned checker handles the narrower `D8` orbit directly.
- **U. Derenthal, “Cox rings of generalized del Pezzo surfaces.”** Read depth: `full text` in C381,
  arXiv version, especially Section 2.1 and the degree-one tables.  Shared-cache key
  `arXiv:math/0604194`, SHA-256
  `3afa85f837868aecfe5a5084fa9d4652c4ea5baef5c0388226fc2201112a5276`.  C382 reuses
  C381's Picard/root-lattice convention and does not re-audit the surface classification.

MathSciNet and Google Scholar are `NOT COVERED`; zbMATH and forward-citation closure are likewise
not used for an absence verdict.  No manuscript-bound “to our knowledge” sentence is authorized.

## Hand-back

C382 closes red at cheap-gate step 2.  The index-two `D8` bridge is exact, but its `C2` glue action
is trivial and its unordered `A2` marking has stabilizer order `3,840`.  More decisively, C381's
geometric object is an `A5`-equivariant six-fibre family with `D10` fibre stabilizer, whereas the
natural icosian linear object is a `2.A5` representation; the descended conjugation representation
has the wrong involution trace already on that legitimate `D10` fibre action.  This yields a clean
non-comparison proposition but no positive icosian or famous-object continuation.
