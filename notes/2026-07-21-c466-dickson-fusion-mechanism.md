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

### Second-order ej — the six-arcs themselves coincide projectively

Exhausting all `6!=720` ordered frame maps finds exactly 60 projectivities from C395's non-GRS
`t=-1` six-arc to each golden six-arc.  Canonical maps are

```text
phi=13: (x,y,z) |-> (z,7y,13x),
phi=19: (x,y,z) |-> (z,13x,7y).
```

Each map conjugates the full projective `A5` stabilizers.  On the invariant conics the induced
Möbius determinants have Legendre symbol `-1`, explaining why this literal geometric
identification is PGL-visible but belongs to the other PSL class.

The two canonical identifications close through the original seam:

```text
H_19 H_13^(-1) = [[1,0,0],[0,0,1],[0,1,0]],
```

the coordinate swap `(y z)` in the rational octahedral hinge.  Thus both C395-to-golden maps are
outer, while their quotient is exactly the inner hinge element that fuses the two golden sheets at
31.  The independent A5 control, the golden collision, and the Dickson fusion mechanism form one
commuting triangle rather than three coincident order calculations.

The enhancement prime 31 is forced by the coordinate ratios, not accidental.  A monomial map from
the C395 ratios to a golden arc requires

```text
phi = 8/3,                 (8/3)^2-(8/3)-1 = 31/9.
```

Thus exactly in characteristic 31, `phi=13` (and its conjugate `1-phi=19`) becomes golden and the
C395 `t=-1` arc collides projectively with the frozen H3 six-arc.  This explains both the order-60
stabilizer jump and the earlier obstruction factor 31.  It is a direct H3-marker identification;
it still does not construct an H4 parent.

### Third-order ej — 31 is the norm of the collision divisor

The `phi=13` monomial map is the reduction of one integral golden template

```text
H(phi):(x,y,z) |-> (z,2(1-phi)y,phi x)
```

over `Z[phi]`.  Its six-point residual vanishes precisely on `3phi-8`.  For
`phi^2-phi-1=0`,

```text
N(a+b phi)=a^2+ab-b^2,
N(3phi-8)=(-8)^2+(-8)(3)-3^2=31.
```

The conjugate divisor selects the other residue prime, and the hinge swap supplies its
common-coordinate map to the other golden sheet.  Therefore characteristic 31 is not
just the numerator obtained by substituting `8/3`: it is the unique prime divisor of the integral
collision divisor.  This upgrades C395's gcd-31 obstruction into an exact golden norm mechanism.

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
H3 reflection groups, the signed-monomial hinge, all of `PGL_2(q)` for the five tested primes, the
C395 group and its unique invariant conic, all 720 six-arc frame maps, and the cyclotomic Gauss identity.  The independent
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
- **Settled in the second-order ej — geometric meaning of the second characteristic-31 A5 class.**
  The C395 non-GRS six-arc is literally projectively equivalent to each golden H3 six-arc through
  60 exact maps; the simple monomial maps above conjugate the full `A5` groups and induce the outer
  conic class.  The identity `(8/3)^2-(8/3)-1=31/9` explains why this collision occurs exactly at
  the C395 enhancement prime 31.  The two canonical identifications differ by the hinge swap
  `(y z)`, closing the C395/golden/fusion triangle exactly.
- **Still open, with an exact gate — H4 parentage.**  The six-arc/H3 marker is now identified, but
  no 600-cell object, H4 action, or continuation datum was constructed.  That remains the named
  pre-allocation-gated characteristic-31/H4 gateway.
- **Open conceptual refinement — why this norm divisor belongs to the wider roof.**  The endpoint
  coordinate calculation proves that the collision divisor is `(3phi-8)` with norm 31, but no
  integral icosian or family-level morphism has been exhibited whose degeneration divisor is that
  ideal.  Such a lift would explain the norm structurally rather than coordinately and belongs with
  the same gated H4/icosian successor.  No other genuine C466 mystery remains.
