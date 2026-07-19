# C346 — arithmetic good reduction of the `H3`/Clebsch configuration

**Lane:** `crowns`

**Date:** 2026-07-19

**Verdict:** `THEOREM; UNIQUE BAD MIRROR-LATTICE PRIME (2)`

## Theorem

Let

```text
O = Z[tau],                 tau^2-tau-1=0,
```

and let `A_H3` be the central arrangement whose fifteen normal directions are

```text
(1,0,0), (0,1,0), (0,0,1),
cyclic permutations of (1, +/-tau, +/-(tau-1)).
```

For a prime ideal `P` of `O`, reduce this fixed coordinate model over the residue field
`k(P)=O/P`.

1. `A_H3` has intersection-lattice good reduction at exactly the prime ideals
   `P != (2)`. At every good prime its projectivization consists of fifteen distinct lines
   with six fivefold, ten triple, and fifteen double points and no other multiple points.
2. At every odd prime ideal, the projectivized `H3` reflection action is a faithful `A5`
   action. Its three singular strata are single `A5` orbits of sizes `6,10,15`.
3. The field-of-definition split is:

   - `p=5` is ramified, with residue field `F_5` and `tau=3`; it is lattice-good and the
     projective `A5` action is faithful;
   - for `p congruent to +/-1 mod 5`, the two primes over `p` have residue field `F_p`, and
     the two choices of a root of `x^2-x-1` give the two reduced coordinate models;
   - for odd `p congruent to +/-2 mod 5`, `(p)` is inert, the residue field is `F_(p^2)`,
     and the fixed model is not defined over `F_p`: only the three coordinate mirrors are
     Frobenius-fixed and Frobenius does not preserve the fifteen-line set in this
     normalization. Its faithful projective `A5` action is over `F_(p^2)`, not `F_p`.
4. At the unique bad prime `(2)`, with residue field `F_4`, the fifteen displayed mirror
   directions collapse to four. Their projective point spectrum is
   `n_0=7, n_1=8, n_2=6`; the `6_5,10_3,15_2` lattice and the associated faithful action
   on fifteen distinct mirrors are gone. This does not classify unrelated `A5` embeddings in
   `PGL_3(F_4)`.

Thus “rationality,” “lattice good reduction,” and “projective-group preservation” really are
separate conditions. In particular, characteristic five is not a bad-reduction prime for the
arrangement: its special behavior is that the complement has size
`(5-5)(5-9)=0`. All 31 points of `PG(2,5)` are arrangement singularities, split as
`15+10+6`, even though the full lattice and faithful `A5` action survive.

At `p=11`, the prime splits and the two roots are `tau=4,8`. Both reductions have spectrum

```text
n_0=12, n_1=90, n_2=15, n_3=10, n_5=6
```

and projective group order 60 with singular orbits `15,10,6`. The `tau=8` case is the one
carried by C211's explicit projectivity to the displayed Clebsch parity-check columns.

## Exact proof

There are `binom(15,3)=455` three-by-three determinants of mirror normals. Exactly 70 vanish
in `O`; the remaining 385 have absolute norm distribution

| absolute norm | number of minors |
|---:|---:|
| 1 | 37 |
| 4 | 156 |
| 16 | 188 |
| 64 | 4 |

Hence every nonzero rank-three minor is supported only at the prime ideal `(2)`. The zero
pattern reconstructs 31 rank-two flats, with multiplicity distribution
`15_2,10_3,6_5`.

This is the rank-three, `O`-linear specialization of Palezzato--Torielli's minimal-strong-
Groebner criterion. The required extension from `Z` is elementary here: `O` is Euclidean,
so an independent triple of linear forms has a Smith/strong basis over `O`; a prime ideal
`P` is lucky for that triple exactly when its determinant is not in `P`. Identically zero
minors remain zero after reduction, so the complete determinant matroid—and therefore the
intersection lattice—is preserved exactly when none of the 385 nonzero minors vanishes.
The norm ledger proves that this fails exactly at `(2)`.

For the group statement, use the division-free scaled reflection

```text
M_r = (r.r) I - 2 r r^T.
```

The exact checker verifies over `O` that the fifteen such transformations permute the
fifteen mirror directions and generate a projective permutation group of order 60, with
single singular-stratum orbits of sizes `6,10,15`. The three coordinate-root matrices have
determinant absolute norm 1; the other twelve have determinant absolute norm 4096. Thus all
remain invertible away from `(2)`. Since the fifteen mirrors also remain distinct there,
their 60 distinct permutations remain distinct after reduction. This is the faithful
projective `A5=H3/{+/-I}` action at every odd prime ideal.

For inert `p`, a faithful `A5` action cannot descend to `PGL_3(F_p)`: when
`p congruent to +/-2 mod 5`, the order of `PGL_3(F_p)` is not divisible by 5. This agrees
with the direct Frobenius check and cleanly separates residue-field action from prime-field
rationality.

## Independent replay

The symbolic proof and the independent finite-field replay are in:

- `notes/2026-07-18-c346-h3-clebsch-good-reduction.py`
- `notes/2026-07-18-c346-h3-clebsch-good-reduction.json`

Regenerate the canonical JSON, then verify it without changing the worktree:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-18-c346-h3-clebsch-good-reduction.py --write
python3 notes/2026-07-18-c346-h3-clebsch-good-reduction.py --check
sha256sum -c notes/2026-07-18-c346-h3-clebsch-good-reduction.sha256
```

The checker is standard-library-only under Python 3.13.12. It independently enumerates every
point of `PG(2,q)` at `q=4,5,9,11`; both roots at `q=11` are checked. At every odd sample it
constructs the projective reflection matrices, closes the group to order 60, verifies that it
preserves all mirrors, and computes the three singular-stratum orbits. The symbolic and finite
point-enumeration paths share only the displayed coordinate model, not their incidence-counting
algorithm.

| artifact | bytes | SHA-256 |
|---|---:|:---|
| checker `.py` | 19,770 | `8c6ae76fbdcdca71637fe018a040c33da05ee9f0a9f549ca7438bfe2e0c2468f` |
| certificate `.json` | 3,522 | `823275f819928ca466104e638409f5524d33cbe67ecd5712248b160522d194ee` |

The trusted boundary is exact integer/quadratic-ring arithmetic, deterministic enumeration,
and the elementary Smith-basis reduction above. The artifact does not formalize the theorem in
Lean, classify arbitrary integral lattices for `H3`, or claim that every conjugate coordinate
model descends as the same unlabelled arrangement to an inert prime field.

## Source-level literature matrix

| source | exact overlap | boundary and C346 decision |
|:---|:---|:---|
| Palezzato--Torielli, *Combinatorially equivalent hyperplane arrangements*, Adv. Appl. Math. 128 (2021), 102202, [arXiv:1906.05463](https://arxiv.org/abs/1906.05463) | Theorem 4.14 characterizes lattice-preserving reduction over `Z` using good and lucky primes from minimal strong Groebner bases. | `SURVIVES`: C346 specializes and extends the mechanism to the Euclidean quadratic integer ring `Z[tau]`, where the complete determinant ideal is explicitly `(2)`-supported. The general criterion is credited, not claimed. |
| Monson--Schulte, *Modular Reduction in Abstract Polytopes*, Canad. Math. Bull. 52 (2009), 435--450, [arXiv:0805.1479](https://arxiv.org/abs/0805.1479) | Gives the prime classification in `Z[tau]` and modular reflection-group machinery; its rank-four `[3,5,3]` model retains spherical `H3` subgroups even at primes over 2. | `SURVIVES WITH SEPARATION`: group reduction in a suitable invariant lattice does not imply good reduction of this 15-mirror coordinate arrangement. C346's bad `(2)` result is therefore compatible, not contradictory. |
| Calvo, *The icosahedral line configuration and Waldschmidt constants*, J. Pure Appl. Algebra 228 (2024), 107563, [arXiv:2209.01499](https://arxiv.org/abs/2209.01499) | Owns the characteristic-zero 15-line configuration, `6_5,10_3,15_2` ledger, and `A5 x C2` symmetry. | `NARROW`: none of these characteristic-zero facts is new here. C346 claims only their exact arithmetic reduction boundary and residue-field stratification. |
| Athanasiadis's finite-field characteristic-polynomial method and the C211 Edge/Dye/Calvo audit | Supplies the classical finite-field counting method and the Clebsch/icosahedral identification. | `NARROW`: once good reduction is proved, `(q-5)(q-9)` is a consequence, not a new arrangement-count theorem. The new work is the exact good-prime certificate and separation of the three descent notions. |

The cached full texts actually read for the two reduction mechanisms are:

```text
arXiv:1906.05463  sha256 01973a6ff9a6a09303473f787afad0b15e153d6d24b6ce6b761d0d2fac9c0003
arXiv:0805.1479   sha256 149eeb36d30adc3cba20813bc7dad33d7a42cc0f39de0f3f3b9e6ab501c019ee
```

Calvo's cached full text has SHA-256
`3ef91a2818d27bbd0a09b1095d1095a1f8ae2d162f7a7d3da729e0e7b4ffa252`.
The publisher's forward-citation display for Calvo listed one unrelated 2024 Waldschmidt-constant
paper; a targeted title/finite-reduction search found no finite-field `H3` arrangement theorem.
The institutional index for Palezzato--Torielli reported two Scopus citations, and targeted
finite-`H3` searches again found no collision. Public MathSciNet/zbMATH title queries returned no
accessible records. That is not exhaustive priority proof, so the defensible paper language is
“an exact arithmetic reduction theorem for this Clebsch coordinate model,” not “the first finite
reduction of the icosahedral arrangement.”

## Consequences and hand-back boundary

- C339 may use every odd prime ideal as lattice-faithful, with `q=|O/P|`; its complement formula
  is valid there. It must treat `q=5` as the empty-complement case and `(2)` as excluded.
- C341 may use the faithful projective `A5` action at every odd prime ideal. Characteristic five
  is group- and lattice-good; its separate quadratic-evaluation/GRS degeneration is not caused by
  bad arrangement reduction.
- Over inert rational primes, statements requiring coordinates or the projective action over the
  prime field must pass to `F_(p^2)` or prove a separate twisted descent. C346 supplies no such
  descent.
- The Clebsch manuscripts, their checker, and their handoffs remain unchanged and read-only.
