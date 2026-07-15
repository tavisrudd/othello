# C163 — Clebsch coding-semantics repair

**Date**: 2026-07-14
**Lane**: `clebsch` — see CLAUDE.md § Lane routing.
**Status**: **REPORTED**. Manuscript correction landed and validation passed; C164/C165/C166 and
the later scope/submission gates remain separate.

## Correct claim boundary

Let `C=ker H` be the displayed `[6,3,4]₁₁` code. For a received word `v`, write
`sigma(v)=Hv^T` and `w(s)=min{wt(e): sigma(e)=s}`. Then `d(v,C)=w(sigma(v))`, and `v` is a deep
hole precisely when this minimum equals the covering radius `rho=3`. A syndrome is one coset of
`C`; the coset leaders are its minimum-weight representatives. Passing from a nonzero syndrome to
its projective direction identifies ten different syndrome cosets, not ten representatives of one
coset.

The four relevant finite sets are therefore:

| Object | Count | Meaning |
|---|---:|---|
| projective maximum-distance syndrome directions | 12 | exactly `C(F₁₁)`, the rational points of the invariant conic |
| nonzero affine maximum-distance syndromes / deep-hole cosets | 120 | ten scalar multiples above each projective direction |
| minimum-weight leaders in all deep-hole cosets | 2400 | 20 weight-three leaders in each of 120 cosets |
| received-word deep holes | 159720 | all 1331 words in each of 120 cosets |

Thus the headline theorem is that the **projective deep-hole syndrome locus** is a conic. The set
of received-word deep holes is not a conic and has 159720 elements.

For a redundancy-three arc code, `U(A)` is uniformly the projective extension locus, equivalently
the weight-three syndrome-direction locus. It agrees with the projective deep-hole syndrome locus
only when it is nonempty, because then `rho=3`. If `U(A)` is empty, the arc is complete and the code
has covering radius two; deep holes still exist, but their syndromes have weight two. This matters
for the q=9 exclusion and the ten-arc foil, whose old prose and checker output incorrectly said that
an empty `U(A)` meant no deep holes.

For a general `[n,k]` code, parity-check columns lie in `PG(n-k-1,q)`, not `PG(k-1,q)`. The plane
arc dictionary concerns redundancy-three `[n,n-3,4]` MDS codes. The present `[6,3]` parameters hide
the distinction because `k=n-k=3`.

## Automorphism groups

The draft's identification of the pure permutation group with the projective stabilizer is false
for the displayed column representatives. The correct dictionary is:

- the projective stabilizer of the six column rays is the exotic, faithful, 2-transitive
  `A5 < S6`, of order 60;
- the support-permutation image of the monomial automorphism group is that `A5`;
- the kernel of the support projection is the ten global coordinate scalars, so the monomial group
  has order 600;
- the pure coordinate-permutation automorphism subgroup of the displayed code is trivial.

There is a central exact sequence

`1 -> F₁₁* -> MAut(C) -> A5 -> 1`.

It splits: because `gcd(3,10)=1`, every projective class in `PGL(3,11)` has a unique
determinant-one representative, and these representatives multiply. Their induced monomial lifts
give an `A5` complement, so `MAut(C) ~= C10 x A5`. The manuscript may state this only with the
short determinant-one proof; the durable checker deliberately certifies the exact sequence and
order without treating the splitting as a computational output.

The monomial group is transitive on the 120 maximum-distance affine syndromes. Its support quotient
moves among the twelve conic directions and the scalar kernel moves regularly among the ten
nonzero vectors above each direction. Adjoining translations by codewords gives a code-preserving
Hamming-isometry group transitive on all 159720 received-word deep holes. This stronger orbit
translation belongs to C172; C163 corrects the group dictionary and may use the transitivity only
to keep the coding counts conceptually organized.

## Chirality boundary

The 20 objects on which the exotic `A5` first acts are the three-element coordinate supports, not
the code's entire set of leaders. They split into two complementary orbits of ten. For each of the
120 maximum-distance syndromes, every support determines one weight-three leader, giving a `10+10`
split in that coset and a global `1200+1200` split.

Every monomial automorphism induces an `A5` support permutation, so it preserves the unordered
bipartition. The other coset in the exotic `S5` normalizer exchanges the two support classes, but
those 60 pure permutations are not automorphisms of the displayed code. Without an independent
orientation the structure is an unordered bipartition, or a `Z/2`-torsor, not a canonically based
`Z/2`-valued label. C164 owns the coefficient-aware theorem and its dedicated checker; C163 removes
the false support/leader and group identifications now.

## Durable evidence

The new paper-package checker
`papers/clebsch-hexagon-code/check_code_automorphisms.py` is standard-library-only and asserts:

- one pure permutation automorphism;
- 60 projective support automorphisms with the `A5` element-order and degree-six cycle histograms;
- simplicity and 2-transitivity of the support group;
- 600 monomial automorphisms, support image 60, and scalar kernel 10;
- one orbit on all 120 nonzero conic syndromes.

Exact command:

`cd papers/clebsch-hexagon-code && python3 check_code_automorphisms.py`

Replay output:

```text
field=F_11 columns=6 dual_row_space=1331
pure_permutation_automorphisms=1
projective_support_automorphisms=60
support_element_orders={1: 1, 2: 15, 3: 20, 5: 24}
support_cycle_types={(1, 1, 1, 1, 1, 1): 1, (2, 2, 1, 1): 15, (3, 3): 20, (5, 1): 24}
support_group_simple=True
support_group_identification=A5
support_action_2_transitive=True
support_point_stabilizer_order=10
monomial_automorphisms=600
support_projection_image=60
support_projection_kernel=10
kernel_is_global_scalars=True
nonzero_conic_affine_syndromes=120
nonzero_conic_syndrome_orbit=120
nonzero_conic_syndrome_transitive=True
splitting_claim=NONE
all assertions passed
```

The exact counts and syndrome/leader semantics are independently represented in the Q11 Lean
modules cited in the takeover audit, including `Q11Coding.lean`, `Q11SemanticRayData.lean`,
`Q11SemanticDistribution.lean`, and `Q11SemanticSynthesis.lean`. C168 will perform the final
Git-tracked-source manifest and replay gate for every computation cited by the manuscript.

## Manuscript repair scope

C163 rewrites the title, abstract, definitions, code section, named-variety corollary, rigidity
terminology, automorphism paragraph, every later use of “deep holes” for `U(A)`, and the general
higher-dimensional question. It also removes the already-invalid statistical claim rather than
carrying a known falsehood into C167.

The following claims remain owned by their queued tasks and are not certified by C163:

- C164: the full chirality proposition and exotic-`S5` swap checker;
- C165/C171: the tracked 252-neighbour theorem and the correct local/global gap metrics;
- C166/C170: conditional versus unconditional uniqueness of `q=11`;
- C128/C167: Klein certification and final single-spine pruning;
- C168: complete tracked-computation manifest and submission closeout.

## Validation

- `python3 check_code_automorphisms.py`: passed with the exact output above.
- `python3 check_dual_code.py`, `check_mathieu_hexads.py`, `check_q19_nonexample.py`,
  `check_q9_exclusion.py`, `check_rigidity_degenerate_conic.py`, and `check_ten_arc_foil.py`: all
  exited zero. The five legacy scripts that used `U(A)` as “deep-hole locus” now state the precise
  extension/weight-three semantics; q=9 and the ten-arc explicitly retain distance-two deep holes.
- Every script named by the current manuscript passes `git ls-files --error-unmatch`; the new
  automorphism checker is explicitly staged for tracking. C165 must still add the unnamed
  perturbation computation before its theorem satisfies the same gate.
- `nix shell nixpkgs#tectonic -c tectonic clebsch_hexagon_code.tex --outdir
  /tmp/clebsch-build --keep-logs`: succeeded after three internal TeX passes, with no warnings.
- `git diff --check` passed on the manuscript, checker, report, discovery log, queue, and handoff.
- An independent post-edit adversarial review found four residual issues: a higher-redundancy
  overgeneralization, “concyclic” used for `U(A)`-conic representatives, an ill-defined Petersen
  adjacency on unoriented pairs, and an automorphism-checker evidence-scope mismatch. All four were
  corrected and the affected checkers/PDF replayed successfully.
