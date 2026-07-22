# C466 — Dickson mechanism for the mod-40 fusion law

**Verdict:** `GREEN`.  At each tested golden-split prime `q=11,19,29,31,41`, the two reduced golden
`A5` subgroups fuse in `PSL_2(q)` if and only if the rational octahedral hinge `S4` descends into
`PSL_2(q)`.  The hinge's sheet-swapping coset has determinant/spinor squareclass `2`, so the test is
exactly `(2/q)=+1`.  This supplies the requested subgroup-level mechanism behind C453's certified
mod-40 law.

## Exact theorem on the tested domain

Let `phi_q` run over the two roots of `phi^2-phi-1` in `F_q`, let `H(phi_q)` be the projective
golden `A5` generated from the frozen H3 reflections, and let `O` be the rational signed-monomial
octahedral group on `x^2+y^2+z^2`, projectively of order 24.  Reduction of

```text
Rz = [[0,-1,0],[1,0,0],[0,0,1]]
```

conjugates `H(phi_q)` to `H(1-phi_q)` and lies in `O`.  Exact enumeration gives:

| `q` | roots of `phi^2-phi-1` | `(2/q)` | `|O intersect PSL_2(q)|` | PSL sheet transporters | hinge PSL swaps | verdict |
|---:|:---:|:---:|---:|---:|---:|:---|
| 11 | `4,8` | `-1` | 12 | 0 | 0 | visible |
| 19 | `5,15` | `-1` | 12 | 0 | 0 | visible |
| 29 | `6,24` | `-1` | 12 | 0 | 0 | visible |
| 31 | `13,19` | `+1` | 24 | 60 | 12 | fused |
| 41 | `7,35` | `+1` | 24 | 60 | 12 | fused |

At every prime, each golden subgroup has order 60, its PGL normalizer has order 60, the full PGL
transporter between the two sheets has order 60, and exactly 12 of the 24 hinge elements exchange
the sheets.  At 11, 19, and 29 those 12 hinge swaps are outside PSL; at 31 and 41 all 12 are inside PSL.
Thus this is not merely the abstract presence of some `S4`: the frozen rational hinge itself
realizes the exchange.

In the certificate's canonical conic coordinate, `Rz` is represented at every tested prime by

```text
[[1,-1],[1,1]],   determinant = 2.
```

The remaining hinge coset has the same determinant squareclass.  Direct determinant enumeration
therefore recovers the classical `S4 <= PSL_2(q)` congruence test on this concrete subgroup:
the full hinge lies in PSL exactly for `q congruent +/-1 mod 8`.  No appeal to Dickson's criterion
is load-bearing.

## The q=19 matching boundary

The frozen carrier that transfers uniformly is the golden `A5` subgroup, not always C445's
12-point polar matching.  At 11, 31, and 41 the six golden polar lines cut six rational pairs on
the invariant conic.  At 19 and 29 none of those six pairs is rational; at 19 the golden `A5`
is transitive on all 20 conic points, as C453 predicted.  The computation therefore compares the
two reduced `A5` subgroups at every prime and records the matching only where it exists.  This is a
boundary of the matching model, not a failure of the sheet-fusion mechanism.

## Biquadratic framing

The combined law has the exact Frobenius reading

```text
Q(sqrt(2),sqrt(5)) / Q,     conductor 40.
```

- `(5/q)=+1` says that the two golden reductions exist over `F_q`.
- Conditional on that split, `(2/q)=-1` leaves them PSL-distinct and `(2/q)=+1` fuses them.

Hence C453's visible classes `11,19,21,29 mod 40` and fused classes `1,9,31,39 mod 40` are the
four Frobenius classes of the biquadratic field read through the golden-existence and
octahedral-fusion bits.  Two previously certified faces align exactly: C445/C450 has
`det(Rz)=spinor_norm(Rz)=2`, and the invariant-origin theta model below has
`(-1)^Arf=(2/q)` for the tested `q congruent 3 mod 4` primes.

This is framing over exact endpoint and subgroup checks; it makes no class-field-theoretic claim
beyond the elementary quadratic-character table.

## Arf face at 19 and 31

C451's approved invariant-origin Mumford subset model transfers without a new convention because
`g=(q-1)/2` is odd at both primes.  Its origin has

```text
h^0(kappa_empty) = (g+1)/2 = (q+1)/4,
Arf(Q) = h^0(kappa_empty) mod 2.
```

Thus:

| `q` | genus `g` | origin `h^0` | Arf | `(2/q)` |
|---:|---:|---:|---:|:---:|
| 19 | 9 | 5 | 1 | `-1` |
| 31 | 15 | 8 | 0 | `+1` |

The predicted odd/even values are therefore exact, and `(-1)^Arf=(2/q)`.  As at 7 and 11, this
is an invariant-origin parity statement; it does not distinguish two sheets at a fixed prime.

## The second characteristic-31 A5 control

The checker reconstructs C395's `t=-1` six-arc stabilizer from its two integral `A4` generators
and the certified characteristic-31 enhancement matrix.  Its projective group has order 60 and a
unique invariant nonsingular conic with 32 points.  Its conic action has orbit split `12+20`, the
same abstract split as the golden marker shadow.

The comparison is sharper than an order-level coincidence:

- the induced C395 conic subgroup is PGL-conjugate to each golden subgroup;
- each comparison has exactly 60 PGL conjugators;
- none of those 60 conjugators lies in `PSL_2(31)`.

So C395 supplies the *other* PSL conjugacy class of `A5` inside the same PGL class.  The two golden
reductions are PSL-conjugate to one another, while the C395 control is only outer-PGL-conjugate to
them.  Canonical certificate conjugators are `[[0,1],[1,6]]` from the `phi=13` golden subgroup and
`[[1,1],[3,15]]` from the `phi=19` subgroup.

This comparison is exact for the induced invariant-conic actions and their projective point
orbits.  It does not identify C395's non-GRS six-arc with a golden or H4 geometric object.

## q=29/q=41 replication and the Weil-normalization face

The optional fused replication at `q=41` was cheap and passed: the whole hinge lies in PSL, all 60
sheet transporters lie in PSL, and its 12 sheet-swapping elements realize fusion.

The ej closeout also added `q=29`, a visible split prime with `q=1 mod 4`.  Its hinge intersection
is only `A4`, and it has no PSL sheet transporter, so the positive Gauss sign below is independent
of the fusion bit.

For the canonical additive character at each of `q=29,41`, the checker forms

```text
G_q = sum_(t in F_q) psi(t^2).
```

Exact multiplication in `Z[zeta_q]` verifies `G_q^2=q`; the canonical complex embedding selects
the positive root, so `gamma=G_q/sqrt(q)=+1` at both primes.  In ambient dimension three, C455's fixed
linearization therefore gives

```text
rho(w) = gamma^(-3) F = F.
```

This contrasts with `rho(w)=iF` at `q=11` and is exactly the predicted `q=1 mod 4` Gauss-sum face.
It remains an ambient Weyl-operator statement, not a claim that a restricted orbit space is a
module for the whole Weil representation.

## Evidence and replay

The atomic bundle is:

- `notes/2026-07-21-c466-dickson-fusion-mechanism.py` — generator and exhaustive ternary/PGL
  checker;
- `notes/2026-07-21-c466-dickson-fusion-mechanism.json` — canonical subgroup, conjugator, Arf,
  and Gauss certificate;
- `notes/2026-07-21-c466-dickson-fusion-mechanism-replay.py` — independent PGL2/Gauss replay;
- `notes/2026-07-21-c466-dickson-fusion-mechanism.sha256` — byte counts by SHA-256 manifest.

From the repository root:

```bash
python3 notes/2026-07-21-c466-dickson-fusion-mechanism.py --check
python3 notes/2026-07-21-c466-dickson-fusion-mechanism-replay.py
```

The generator uses deterministic prime-field enumeration only.  It reconstructs the two golden
H3 reflection groups, the signed-monomial hinge, all of `PGL_2(q)` for the four tested primes, the
C395 group and its unique invariant conic, and the cyclotomic Gauss identity.  The independent
replay consumes only the canonical Möbius groups and re-enumerates every PGL transporter and the
Gauss product without importing the generator.

The checked domain is exactly `q in {11,19,29,31,41}`.  The uniform statement outside that set follows
only as the elementary determinant-squareclass mechanism under the frozen golden-sheet hypotheses;
the computation makes no construction, continuation, or H4-parent claim at any other prime.

## Mystery ledger (ej closeout)

- **Settled — why q=19 and q=29 have no transferred matching.**  Each golden polar line has no
  rational conic pair (and at 19 the `A5` action is transitive on the 20 conic points).  The
  subgroup, not a 12-point matching, is the uniform carrier there.
- **Settled — whether q=31 fusion is merely an ambient PSL accident.**  No: all 12 swaps in the
  frozen rational hinge lie in PSL and explicitly fuse the sheets; the determinant squareclass is
  exactly 2.
- **Settled — whether the q=1 mod 4 Weil sign predicts fusion.**  No: both 29 and 41 have
  `gamma=+1`, while 29 is visible and 41 is fused.  The Gauss sign and the octahedral fusion bit
  are distinct faces.
- **Open — geometric meaning of the second characteristic-31 A5 class.**  The C395 control is
  exactly outer-PGL-conjugate, never PSL-conjugate, to the fused golden class, but no natural map
  between the non-GRS six-arc and the golden/H4 marker was part of the tested data.  A geometric
  identification would require new conventions and remains with the pre-allocation-gated
  characteristic-31/H4 gateway, not C466.
