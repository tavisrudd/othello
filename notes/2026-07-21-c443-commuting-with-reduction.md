# C443 — commuting-with-reduction blocker

**Lane:** `crowns`

**Date:** 2026-07-21

**Executor:** `5.6-sol-xhigh`, standing in for the Weil-roof program's Fable formulation role

**Verdict:** `SHARP BLOCKER AT THE REQUIRED UNIQUE 1+10 GOLDEN SHEET; M3 STOPS BEFORE TENSORS`

## Conclusion

The literal M3a construction fails before secant products or quotient-space division.  On C458's
frozen twelve-point golden `A5` orbit there is one `A5`-fixed polar matching, as required, but
there are **four**, not one, size-ten `A5`-orbits whose union with that matching is a
one-factorization of `K_12`.

Complex conjugation `kappa` fixes none of the four companions and permutes them in two transpositions.
Moreover, after the frozen C440/C406 specialization maps are applied, each companion produces one
of the two frozen C406 sheets at exactly one of the four cyclotomic primes
`zeta = 3,4,5,9`, and at neither of the other three.  Thus no single generic companion realizes
the required reductions at both primes of `Z[phi]` above 11.  Selecting a different companion in
each special fibre would be precisely the post-hoc prime selection that M3a forbids.

The C448-motivated repair of retaining a conjugate pair was also tested.  Uniform moment averages
over both `kappa`-pairs do descend: their arrays agree at `zeta=3,4` and at `zeta=5,9` in degrees
one through three.  But both fail the C406 moment square already in degree one.  The target signed
linear moment is zero, whereas either pair-average difference has support three in the frozen
15-coordinate quotient basis.  Thus the canonical unordered-pair repair does not recover the
required tensor; no cubic interpretation can repair its failed lower-moment condition.

This triggers the program's stop-and-escalate guardrail: the claimed matching-orbit multiplicity
differs from the frozen specification.  The computation therefore does **not** proceed to the
secant products, conic quotient, denominator set `N`, or `mu_1,mu_2,mu_3`.  In particular C443 does
not certify an integral cubic or its `+/-6` shadow.

## Exact finite obstruction

The deterministic enumeration gives:

| object | exact result |
|:--|--:|
| golden group order | 60 |
| golden vertices | 12 |
| perfect matchings enumerated | 10,395 |
| `A5` matching orbits | 267 |
| orbit-size census | `1:1, 5:2, 6:4, 10:14, 15:20, 20:4, 30:116, 60:106` |
| fixed matching orbits | 1 |
| size-ten companions completing the fixed matching to `K_12` | 4 |
| companions fixed by `kappa` | 0 |
| `kappa` cycle lengths on companions | `2,2` |
| frozen-C406-sheet hits at each of `zeta=3,4,5,9` | `1,1,1,1` |
| cyclotomic-prime hits made by each companion | `1,1,1,1` |

Every claimed one-factorization is checked by counting all 66 edges of `K_12` exactly once.  The
canonical JSON records all forty companion matchings, the conjugation permutations, the complete
four-root reduction table, the frozen-sheet label when a hit occurs, and hashes of every reduced
factorization.  It also verifies the C458 split-conic matrix identities and that the bridge
determinant is nonzero at all four roots.  The blocker is therefore not caused by a bad split-conic
chart or a denominator detected at 11; the denominator audit is simply unreached.

## What C448 contributes

C448 is directly useful as a scope rule.  The canonical characteristic-zero object exposed here
is the **unordered four-element family** of companion orbits.  C448 permits retaining such an
orbit-valued object but forbids silently promoting one member to a canonical point selector.  Its
selector theorem therefore explains why the fourfold result cannot be repaired by naming one
companion “the positive sheet.”  A choice of special prime can pick a member locally, but that is
extra data and does not give the single global `Z[phi,1/N]` object required by M3a.

Nor is the unordered pair alone sufficient: the exact pair-average test above gives a nonzero
linear moment.  A future abstract lift would therefore need a **nonuniform, intrinsically defined
weight line** on the four companions.  If `W` is their rank-four permutation lattice and
`m_k:W -> Sym^k(S_4)` their moment maps, the sufficient missing datum is a primitive saturated
rank-one line in `ker(m_1) intersection ker(m_2)`, fixed by `kappa`, golden-odd, and mapped by
`m_3` to the two frozen cubic lines.  C411's `+6` depth functional could orient a generator after
the line itself was obtained.  C443 neither constructs nor rules out that stronger object.

This is not a proof that no abstract integral tensor can have the two desired special fibres.  It
is a proof that the specified functorial secant-product construction from one golden `1+10` sheet
cannot supply it under the frozen conventions.  CRT interpolation, a convention change, or a
matching selected from its reduction remains outside the certified claim.

## Weil-roof consequence

The failure is disappointing but cleanly localized.  C440--C442 and C458 remain intact: the
golden vertex set, its two reductions, and the singleton/polar matching theorem survive.  The
paper-1 closing theorem must retreat to that sheet/matching level and cut the integral tensor
clause, exactly as the Weil-roof program prescribes for an M3 blocker.  The broader paper-2 roof is
not refuted; its unresolved job is now more explicit—it must explain gluing without assuming this
global characteristic-zero sheet selector.

## Reproducibility

From the repository root `/home/tavis/src/othello`:

```bash
uv run python3 notes/2026-07-21-c443-commuting-with-reduction.py --check
uv run python3 notes/2026-07-21-c443-commuting-with-reduction-replay.py
```

The primary checker reconstructs C458's golden anisotropic-plane frame over `Q(zeta_5)`, finds an
exact split-conic bridge from C440's primitive roots, enumerates all perfect matchings, and compares
all four candidates at all four cyclotomic primes with C406's frozen 22-point orbit.  It writes a
canonical JSON certificate and a manifest containing SHA-256 hashes and byte counts for this
report, the M3a specification, both scripts, and the JSON.

The independent replay does not import the primary checker and does not use its anisotropic-plane
bridge.  It works directly in C440's binary icosahedral root frame, independently enumerates the
10,395 matchings and their `A5`-orbits, reconstructs the conjugation action and all four finite
reductions, and checks the invariant counts against the certificate.

The trusted boundary consists of Python exact rational arithmetic, the hash-pinned C406/C440/C441/
C442/C458 inputs listed in the JSON, and exhaustive deterministic enumeration.  No randomness,
floating point, literature/novelty claim, or hand-edited generated evidence is involved.
