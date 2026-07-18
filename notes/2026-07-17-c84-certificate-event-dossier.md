# C84 certificate-event viability dossier

**Date:** 2026-07-17
**Lane:** `cap`
**Status:** conceptual gate failed; deprioritize C84.

## Decision

No candidate below passes all four C84 gates: a noncircular Node--Kayles implication, uniformly
controlled witness complexity, a credible full-dimensional raw-centre locus, and an exact counting
route for its projection. C84 should therefore stop at the conceptual gate. This is a portfolio
decision, not a proof that the observed positive P-density is false or that every global abundance
argument needs a bounded pointwise certificate.

An impossibility theorem would first have to fix a certificate language. A meaningful target would
show that every sound bounded-degree pairing atlas has `O(q)` certified centres, or that every
sound bounded-state algebraic response transducer covering a positive-density family needs state
count or degree growing with q. A broader definability barrier would bound the raw-centre
projection of every sound relation in a precisely specified noncircular class by dimension at most
one. No such theorem is claimed here; “no compact certificate” without a formal certificate class
is not a mathematical statement.

The immediate broader context is C294. It crosses the full-`PGL2` escape boundary with an explicit
mirror-certified P-family for primes `p ≡ 3,27 (mod 40)`, but supplies only `O(1)` centres per
field. Thus C294 is a genuine full-group existence/crown theorem, while C84 asked for a
full-dimensional positive-density family. The C294 success neither conflicts with the q=29
class-D pairing obstruction nor repairs C84's density gate.

Fix the rooted class-D triple `T`, let `Y_D(q)` be its legal fourth centres, and let `R_y` be the
fixed/dead-vertex-deleted four-involution conic graph.

## Candidate 1: two-ply adaptive pairing atlas — fails

For fixed constants `d,m`, let a witness `w` consist of at most `m` bounded-degree rational reply
maps and bounded-degree rational involutions, with constructible guards. Define `E_atlas(y,w)` to
mean that for every live first move `v`, one guard supplies a legal reply `r`, after which its
involution is a fixed-point-free nonadjacent automorphism of
`R_y - N[v] - N[r]`.

- **Deterministic implication:** the involution gives a copycat strategy after `v,r`; hence every
  first move has a P-valued reply and `G(R_y)=0`.
- **Complexity and counting:** fixed `d,m` give a bounded first-order relation after normalizing
  rational-map coefficients. CvdDM could count its projection, or Lang--Weil could count an
  explicitly eliminated base-field component, but either route would still need a uniform witness
  fiber bound.
- **Dimension gate:** the exact q=29 check tests the strictly larger event in which every `v` may
  choose an arbitrary reply and an arbitrary abstract graph automorphism. None of the 753 class-D
  roots passes. Of those roots, 739 have no covered first move and 14 have exactly two. Therefore
  every bounded algebraic atlas is empty at this stress field. Declaring q=29 an unexplained finite
  exception would leave no credible full-dimensional mechanism and does not pass the gate.
- **Closed-attack boundary:** this was genuinely adaptive and did not assume root pairing, a fixed
  coloured word, or a rooted-S4 packet. The stronger unrestricted test, rather than a feature fit,
  closes it.

At q=13 the same checker certifies 13 of 131 roots, so the event is meaningful rather than
vacuously malformed. A separate direct Grundy recursion checks all 13 as P (`0` failures).

## Candidate 2: bounded orbit/decomposition certificate — fails

Let `w` name a bounded subgroup/orbit template for which `R_y` is a disjoint xor of paired
isomorphic components and finitely many catalogue components of known Grundy value, with total xor
zero.

- **Deterministic implication:** disjoint-sum xor and the catalogue values prove `G(R_y)=0`.
- **Complexity:** subgroup type, orbit template, and component pairing are uniformly bounded.
- **Dimension and counting:** forcing the fourth involution into a bounded polyhedral/dihedral
  overgroup or a fixed word-relation locus imposes subgroup/trace equations on the two-dimensional
  centre family. The existing Schreier boundary theorem is sharper: `V4` and `D8` have no
  subgroup-preserving fourth move, and rooted `S4` has at most three and no legal fifth. These are
  finite or divisor-scale loci, not a positive-density raw-centre family. Dickson classification
  plus direct finite-field curve counts could bound them by `O(q)`, which certifies the dimension
  failure rather than the desired `Omega(q^2)` conclusion.
- **Closed-attack boundary:** this is precisely the small-subgroup/catalogue route under new
  decomposition language, so it has no re-entry condition.

## Candidate 3: bounded-state algebraic response recursion — fails

Let `w` be a constant-size state set with constructible state invariants, bounded-degree rational
reply/update maps, and a well-founded rank. The intended event says every legal opponent move has a
legal response preserving the invariant and decreasing the rank to a terminal P-state.

- **Deterministic implication:** if the invariant and update laws were supplied, well-founded
  induction would prove `G(R_y)=0` without an oracle.
- **Potential counting route:** a genuinely fixed formula with a base-field two-dimensional
  component would be eligible for CvdDM or Lang--Weil.
- **Complexity failure:** no such invariant or update law is known. The actual residual state
  contains an arbitrary live subset. Encoding its reachable subsets or responses makes `w` a
  q-dependent strategy tree; quantifying an `O(q)`-step verification destroys fixed formula
  complexity and merely renames P. The measured bisimulation quotient grows, while fixed words,
  one-ply packets, finite templates, and the borrowed ledger have already failed. Without a new
  state theorem this is a meta-schema, not a certificate event, so it fails before a density count
  or further finite test is justified.

## Bounded falsification artifact

From `/home/tavis/src/othello`:

```sh
python3 rust/scripts/c84_two_ply_pairing.py 13 29 --class D --verify-values \
  --check notes/2026-07-17-c84-two-ply-pairing.json
sha256sum -c notes/2026-07-17-c84-two-ply-pairing.sha256
```

The checker constructs every raw class-D residual in the two stated prime fields. For every first
move it exhausts legal replies and uses the dependency-free exact automorphism backtracker from
`c84_pairing_locus.py`; no Grundy oracle enters atlas certification. The independent value check
uses the older direct recursion in `three_centre_probe.py` on every certified q=13 root. The
automorphism kernel itself was previously cross-checked against NetworkX on the q=11 and q=13 root
censuses.

Trusted boundary: the coordinate residual-graph construction, the standard Node--Kayles copycat
lemma, and exact automorphism backtracking. The computation certifies only q=13 and q=29 class D;
it does not prove eventual emptiness or refute a different global recursion.

| File | Bytes | SHA-256 |
|---|---:|---|
| `rust/scripts/c84_two_ply_pairing.py` | 4,658 | `037a29b8e8f6f03ff6f1b968dd5bf0ec3f470099c6ffd5419b039b90269422d1` |
| `notes/2026-07-17-c84-two-ply-pairing.json` | 1,465 | `eccc316a1ece0574b78bc296653ce2e49a0e5b29e2868911e9bed317cadf4088` |
