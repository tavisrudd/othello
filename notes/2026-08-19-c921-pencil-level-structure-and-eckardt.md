# C921 — the pencil's forced level structure, and its Eckardt locus

**Lane:** `cubic-threefolds` · **Date:** 2026-08-19 · **Task:** C921

## Results

Two independent questions about the nonstandard `A_5`-cubic pencil, both settled
computationally against the explicit rational model.

1. **The two level-structure predictions of
   `2026-08-19-c921-integral-glued-model.md` are confirmed.** Hartlieb's elliptic
   factor has square discriminant and carries a rational three-isogeny, over 112
   smooth members across five finite fields, with no violation. This is an
   independent confirmation of the epilogue's principal gluing packet
   proposition, arrived at from the equations rather than from the lattice.
2. **The Eckardt locus of the pencil is not empty.** It is exactly the conjugate
   pair of members `b = 3ω` and `b = 3ω̄`, the roots of `b^2 + 3b + 9`, each
   carrying thirty Eckardt points — the Fermat cubic threefold's count. These are
   the two members that also admit the permutation action of `A_5`.

The second result is negative for the upgrade it was meant to support, and the
negative is the useful part: the qualifier "all but finitely many" in the
manuscript's separation theorem **cannot** be removed, because the exceptional
set genuinely contains the Fermat members, which are literally of
separated-variable type. What can be done instead is to name them.

## 1. Why the Eckardt locus was the target

The epilogue's two finiteness propositions reduce to one object.
`prop:A5-not-coprime` ("Finite Eckardt locus") proves that only finitely many
members carry an Eckardt point, by a soft argument: the locus is closed, the
projection is proper, the base is an irreducible curve, and one computed member
has none. `prop:A5-nonseparated` ("Finite separated-variable intersection") is a
corollary of it through `lem:eckardt-rank`, since a smooth cubic threefold of
separated-variable type carries an Eckardt point. And `prop:A5-nonseparated` is
what puts "all but finitely many" into `thm:separation-family`, the manuscript's
separation theorem.

So emptiness of the Eckardt locus on the smooth part of the pencil would have
removed the qualifier from a theorem statement. It is not empty.

## 2. What the sweep found

For every prime in `{11, 19, 29, 31, 41}` and every member of the pencil over
that field, the script tests each point of `P^4(F_q)` on the member for the
manuscript's own Eckardt criterion, rank of the Hessian at most two, applied as a
cascade of the hundred three-by-three minors.

    q = 19    Eckardt at b = 2, 14        thirty points each
    q = 31    Eckardt at b = 13, 15       thirty points each
    q = 11, 29, 41                        none

`2, 14` are the roots of `b^2 + 3b + 9` modulo 19 and `13, 15` are its roots
modulo 31; the polynomial is irreducible modulo 11, 29 and 41. Its roots are
`b = 3ω` for `ω` a primitive cube root of unity, so the Eckardt members are
`F_q`-rational exactly when `q ≡ 1 mod 3`, which is precisely the observed
pattern. Both facts are checked in the script rather than inferred.

**The Fermat control.** The same detector run on `x_1^3 + ... + x_5^3` finds
thirty Eckardt points when `q ≡ 1 mod 3` and ten when `q ≡ 2 mod 3` — the
Eckardt points of the Fermat cubic threefold are the thirty points with two
nonzero coordinates in ratio a cube root of `-1`, of which ten are rational when
the cube roots of unity are not. The two Eckardt members of the pencil track that
count exactly. Together with the manuscript's own statement that the pencil
contains the Fermat cubic threefold as one of the two members admitting the
permutation action of `A_5`, this identifies them.

**New concrete datum.** In the rational model the Fermat members sit at
`b = 3ω, 3ω̄`. The manuscript exhibits the Fermat member only in the monomial
model, where the cube roots of unity are in the matrix entries.

## 3. What this means for the manuscript

The direction I had hoped for is closed. Neither `prop:A5-not-coprime` nor
`prop:A5-nonseparated` can be strengthened to "no member", and
`thm:separation-family` keeps its qualifier. That is not a defect in the
manuscript; the manuscript is right as written, and the reason is structural
rather than accidental — the Fermat member is a member of the pencil, it is of
separated-variable type as literally as possible, and it is exactly where the
Colliot-Thélène criterion does apply. The remark on the Fermat member already
says as much from the other side.

The available sharpening is to replace "only finitely many" with the named pair.
Subject to the geometric statement in section 5 below, the exceptional set of
both propositions is exactly the two Fermat members, and the exceptional set of
the separated-variable proposition is exactly the two Fermat members as well —
the containment runs both ways there, since separated-variable implies Eckardt
and the Fermat form is separated-variable. That converts two soft finiteness
statements into an exact description, and it makes the corollary on the Fermat
member and the general separation statement into the two halves of one dichotomy
over the pencil.

No manuscript edit is made here. This is a research record; adopting it needs the
proof of section 5 and is the user's call.

## 4. The level-structure tests

The gluing packet proposition says the relative kernel `K_p` is a section of the
local system of `A_5`-stable maximal isotropic halves. As derived in
`2026-08-19-c921-integral-glued-model.md`, that forces the mod-two monodromy of
`E_b` into the order-three subgroup of `GL_2(F_2)`, equivalently square
discriminant, and forces a monodromy-invariant line in `E_b[3]`, equivalently a
rational three-isogeny.

**Recovering the elliptic factor from point counts.** `A_5` acts by coordinate
permutations, hence over the prime field, so the isotypic decomposition
`H^3(X_b) = W_5 ⊗ H^1(E_b)(-1)` is Galois-equivariant with `W_5` carrying the
trivial action. For a smooth member,

    #X_b(F_q) = q^3 + q^2 + q + 1 - 5 q a_b,      a_b = tr(Frob | H^1(E_b)).

That `5q` divides the deficit on every smooth member, over all five fields, is a
nontrivial confirmation of the decomposition itself, not just a way to read off
`a_b`. It held without exception, as did the Weil bound `|a_b| <= 2 sqrt(q)`.

**Test at two.** If Frobenius acted on `E_b[2]` with order two there would be
exactly one rational point of order two, forcing `#E_b(F_q) ≡ 2 mod 4`. No smooth
member over any of the five fields has that residue. The test is invariant under
quadratic twist, since `(q+1-a) + (q+1+a)` is divisible by four for odd `q`, so
the sign ambiguity in `a_b` does not affect it.

**Test at three.** Frobenius fixes a line in `E_b[3]` exactly when `x^2 - ax + q`
has a root modulo three, that is when `3` does not divide `a_b` for `q ≡ 1 mod 3`
and does divide it for `q ≡ 2 mod 3`. Every smooth member satisfies the relevant
condition. This is also twist-invariant.

The three-adic test is the sharper of the two. Over `F_41` all thirty-eight
smooth members have `3 | a_b`; for curves without a rational three-isogeny that
would be a one-in-three coincidence repeated thirty-eight times.

**Incidental: the singular members.** The sweep also records where the pencil is
singular over `F_q`: six members when `q ≡ 1 mod 3` and four when `q ≡ 2 mod 3`,
always including `b = 0`, which is the Segre cubic and has ten nodes as it should.
The two-member difference by residue suggests a conjugate pair among them, but
this is an observation from five fields, not a determination of the geometric
singular locus, and it is disjoint from the Eckardt pair.

## 5. What is not proved

The Eckardt sweep detects `F_q`-rational Eckardt points on `F_q`-rational
members. A member could in principle carry Eckardt points defined only over an
extension, which the sweep would not see. So the statement "the Eckardt locus is
exactly the two Fermat members" is established in one direction rigorously — the
Fermat members do carry Eckardt points, which the manuscript already has — and
computationally in the other.

Turning the other direction into a proof is an elimination over `Q`: the ideal
generated by `F_{1,b}` together with the three-by-three minors of its Hessian, in
the five coordinates and `b`, eliminated down to `b`, should have radical
`b^2 + 3b + 9` up to the singular members. That is the same kind of Singular
computation `2026-08-18-c914-a5-pencil-eckardt.py` already runs for individual
members, extended over the pencil parameter. It is the natural successor and is
what an adopted manuscript sharpening would need.

The two level-structure predictions are likewise confirmed rather than proved.
They are consequences of the gluing packet proposition, so confirmation is a
consistency check on that proposition; the value was in the possibility of a
disagreement, which would have been a defect in a manuscript proposition. There
was none.

## 6. Evidence bundle

| artifact | bytes | sha256 |
|---|---|---|
| `2026-08-19-c921-pencil-level-structure.py`  | 10288 | `e535191f6dc0537ed34028c6840a8fe70d2edeb53c10cc2aefd001249e233ba0` |
| `2026-08-19-c921-pencil-level-structure.txt` |  3222 | `8ce95325009aa387bc0f4082787b17b0453f41c458fda03fba530591d8193528` |
| `2026-08-19-c921-pencil-eckardt-sweep.py`    | 11746 | `73439c132ce59da1a74de0236317e52afee9f44ebfdf324257e788469adc731b` |
| `2026-08-19-c921-pencil-eckardt-sweep.txt`   |  3669 | `d40d19ecd501be8ed41c36eb4563978433d2dad08a6c42ce85cb831ca28ace52` |

Manifest: `notes/2026-08-19-c921-pencil-tests.sha256`, which carries the
authoritative hashes.

Replay, from the repository root:

    uv run --with numpy python3 notes/2026-08-19-c921-pencil-level-structure.py \
        > notes/2026-08-19-c921-pencil-level-structure.txt
    uv run --with numpy python3 notes/2026-08-19-c921-pencil-eckardt-sweep.py \
        > notes/2026-08-19-c921-pencil-eckardt-sweep.txt
    uv run --with numpy python3 notes/2026-08-19-c921-pencil-level-structure.py \
        --check notes/2026-08-19-c921-pencil-level-structure.txt
    uv run --with numpy python3 notes/2026-08-19-c921-pencil-eckardt-sweep.py \
        --check notes/2026-08-19-c921-pencil-eckardt-sweep.txt
    (cd notes && sha256sum -c 2026-08-19-c921-pencil-tests.sha256)

Both `--check` modes regenerate in memory and compare against the tracked output
without writing to the worktree.

Inputs and conventions: the pencil is C914's rational model,
`F_{a,b} = a p_3 + b T_1` on the sum-zero subspace of the six-point permutation
module, with `T_1` the sum over the `A_5`-orbit of squarefree monomials
containing `x_1 x_2 x_3`; the other orbit gives the conjugate pencil and the same
answers. Fields `F_q` for `q` in `{11, 19, 29, 31, 41}`, chosen to include both
residues modulo three and to avoid `5`, where the six-point model degenerates.
Members are the `q + 1` points of `P^1(F_q)`; smoothness is tested by the
existence of an `F_q`-rational point where all five partial derivatives vanish.

Cross-checks reported in the certificates: divisibility of the point deficit by
`5q` on every smooth member; the Weil bound on every trace; the Segre member at
`b = 0` detected as singular at every prime; the Fermat control reproducing
thirty and ten Eckardt points by residue; and the root set of `b^2 + 3b + 9`
matching the detected Eckardt members at every prime. The `A_5`-orbit structure
of the twenty squarefree triples is recomputed from the `PSL(2,5)` action rather
than assumed.

## Mystery ledger

- **Why the Eckardt locus is exactly the Fermat pair and nothing else.** Settled
  in substance, open as a proof. The Fermat members must be in it, and the sweep
  finds nothing else over five fields. What is unexplained is why the locus is
  *reduced* to that pair, given that the Eckardt condition is several equations
  on a curve and could easily have cut out more. The elimination of section 5
  would settle it.
- **Why the level-structure predictions came out so cleanly.** Settled. The
  three-adic condition is forced by a monodromy-invariant line in `E_b[3]`, and
  the data shows it with no near misses. Nothing here is surprising once the
  gluing packet proposition is granted; the point of the test was that a
  disagreement would have been serious, and there was none.
- **The geometric singular locus of the pencil is not determined.** Open. Six
  members over the primes congruent to one modulo three and four over the others,
  which is consistent with a conjugate pair among six, but five fields do not
  determine it. It is not needed for anything in this report, and it would be
  needed by any future degeneration analysis of the Schottky pullback.
- **The upgrade this pass was aimed at is closed negative, for a structural
  reason.** The separation theorem's qualifier is necessary because the Fermat
  member is in the pencil and is of separated-variable type. No mystery remains
  about why the qualifier is there.
