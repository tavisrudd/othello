# C834 polar-involution bounded audit and profile-checker reduction

## Verdict

The proposed polar-involution route does **not** prove that an arbitrary weight-twelve codeword is
an arc.  It should not receive further C834 time.  The mandatory four-profile fixed-point checker is
the correct route.

Let `S` be a weight-twelve codeword and let `L` be a passant meeting `S` in `t` points, where parity
allows `t = 4` or `t = 6` in an offending case.  The involution polar to `L` fixes the seven internal
points of `L` and its internal pole; its other 70 internal points form 35 two-cycles.  If `gS != S`,
minimum distance applied to the nonzero codeword `S + gS` gives

`|S + gS| = 24 - 2 |S ∩ gS| >= 12`, hence `|S ∩ gS| <= 6`.

Writing `epsilon` for whether the pole belongs to `S` and `p` for the number of complete off-axis
two-cycles contained in `S`, the fixed-point contribution gives

`|S ∩ gS| = t + epsilon + 2p`.

For `t = 4`, the bound permits `(epsilon,p) = (0,0), (0,1), (1,0)`.  For `t = 6`, it still permits
`(0,0)`.  Thus the distance bound leaves exactly the zero-or-one further two-cycle gap already
suspected by the referee.  There is an earlier logical branch as well: for an arbitrary `S`, its
stabilizer has not yet been classified, so one cannot assume `gS != S`; if `gS = S`, minimum distance
supplies no inequality.  The known order-24 stabilizers belong to the displayed family and cannot be
imported before exhaustion without circularity.

No generic intersection-parity repair is available.  Exact binary elimination of the 78 passant
rows gives rank 42 and a 36-dimensional kernel, but the kernel is not self-orthogonal: a row-reduced
kernel basis has 554 odd entries in its 36 by 36 binary Gram matrix.  Consequently one cannot add a
general assertion that `|S ∩ gS|` is even.  Even that assertion would not eliminate intersection
sizes four and six.

## Structural reduction of the fallback

The fixed-point pencil argument already proves that every weight-twelve word through point zero is
in one of four complete domains:

1. `(5,1,1,1,1,1,1;0)`;
2. `(3,3,1,1,1,1,1;0)`;
3. `(3,1,1,1,1,1,1;2)`;
4. `(1,1,1,1,1,1,1;4)`.

The meet-in-the-middle implementation previously tested every matching pair by quadratic list
deduplication and then deduplicated the concatenated answer again.  Neither operation is intrinsic.
The first three constructors select from disjoint fibres and, where present, a distinct secant pair.
Their candidates are duplicate-free by construction.  In the fourth domain the sole duplication is
the six ordered ways to divide four secant points between the two meet-in-the-middle halves.  Requiring
every secant index in the left pair to be smaller than every index in the right pair selects exactly
one split: the two smallest indices against the two largest.

The independent exact replay in
`notes/2026-08-07-c834-minimum-word-arc-structure.py` now checks this reduction.  The four profile
solution counts are `0, 0, 0, 56`, their distinct counts are also `0, 0, 0, 56`, and their union has
size 56.  The Lean search definitions now use the same canonical split and concatenate the four
already-disjoint profile outputs directly.

## Proof-producing endpoint

The first proposed formal boundary was four profile-sized kernel leaves, not one native aggregate:

- three leaves prove that the first three complete profile lists are empty;
- one leaf proves that the canonical fourth list is the displayed 56-support fixed-point slice and
  has length 56;
- the aggregate rewrites by those four theorems and imports the already structural fixed-point
  stabilizer orbit identifications.

The canonicalized source subsequently rebuilt successfully through
`PassantCodeQ13.MinimumWords.Exhaustion`.  A direct `decide +kernel` probe of the first three complete
profile lists did not reduce, however: the search uses `Std.HashMap`, whose implementation is opaque
at the kernel-reduction boundary.  Raising recursion depth exposes a stuck `Decidable` instance at
the profile list rather than completing the proof.  Merely putting the same definitions in smaller
modules therefore cannot replace native evaluation.

The corrected proof-producing endpoint is a transparent fingerprint/witness certificate around the
meet in the middle.  For each natural outer shard, generated sorted fingerprint tables carry no
trust: Lean checks that every semantic left half lands in its table and checks every semantic right
half against it.  Equality of full syndromes implies equality of any deterministic fingerprint, so
an absent fingerprint proves an empty shard.  For the fourth profile, the table additionally records
the unique canonical left witness for each successful right half; Lean checks the full syndrome and
encoded support at every recorded hit and proves that every lookup is either absent or one of those
hits.  The generator supplies acceleration data and witnesses only; transparent semantic checks and
symbolic lookup lemmas supply the proof.  Sharding should follow the distinguished fibre, fibre pair,
and secant-pair residue already present in the four domains.
