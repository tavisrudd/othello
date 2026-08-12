# C908: adjudicating the (1,5) unordered-degree normalization

Date: 2026-08-11

Status: **ruled — the `F_2`-linear readout wins**, by an integral lattice
computation plus an independent axis-channel calibration. C908 mathematics only.
No manuscript, PDF, mirror, Lean, or foreign-note edit; the disputed C904 notes
are cited by locus and left untouched. **No channel-closure theorem is promoted
here**; see §6.4 for exactly what the ruling does and does not license.

## 1. The dispute, and the conventions fixed once

Two readouts of the `(1,5)` mod-two residue were in conflict.

- **(A) `F_2`-linear.** `d_(1,5) = -Σ_i c_i ∫_J Θ·α'_i·b_*β_i`, i.e. the raw
  contraction, which under the perfect pairing `P(a,[B]) = ∫_J Θ·a·B mod 2` is
  the `F_2`-linear trace of the residue endomorphism. The Clemens--Griffiths
  identity is then **even**. Derived in
  `notes/2026-08-11-c908-m-cross-m-exceptional-residue.md` §1.1.
- **(B) `F_4`-coefficient trace.** The degree is the five-dimensional coefficient
  trace `tr_5`; the identity is then **odd**. Asserted in
  `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §2.3 and in the
  executive verdict of
  `notes/2026-08-11-c904-exotic-deck-final-move-red-team.md`.

**Conventions, fixed once and used throughout** (and in the certificate). On
`H^*(M x M,Z)` the swap acts by `s^*(x (x) y) = (-1)^{|x||y|} y (x) x`. In
bidegree `(p,q)` with `p ≠ q` the relevant module is
`V_{p,q} = (H^p (x) H^q) (+) (H^q (x) H^p)`, on which `s^*` interchanges the two
summands with the Koszul sign `(-1)^{pq}`. The transfer (norm) sublattice is
`T_{p,q} = (1+s^*)V_{p,q}`; the invariant lattice is `V_{p,q}^s`. Inversion `ι`
acts by `(-1)^k` on the inherited `H^k(M)`, and `y·x = (-1)^{|x||y|}x·y`. With
`Λ = H^1(J,Z)` of rank ten, `H^1(M,Z) = b^*Λ` and
`b_* : H^5(M,Z)/tors ≅ ∧^7Λ` of rank 120 (both proved in the pass-2 note, §§2--3).

## 2. The lattice verdict

The crux, as frozen: can `q^*` of an integral class on `Sym^2 M` have a `(1,5)`
component that is **not** an integral combination of the transfer classes
`x (x) y - y (x) x`?

**Answer: no, and the reason is that the module is free.**

**Lemma 2.1.** In bidegree `(1,5)+(5,1)`, `V` is a free `Z[C_2]`-module, so
`V^s = (1+s^*)V = T`: invariants **equal** transfers, with index one.

*Proof, and its certification.* `s^*` sends the basis vector
`e_{a,b} = u_a (x) v_b` to `-f_{b,a} = -(v_b (x) u_a)` and back, so `V` is the
direct sum of the `10 x 120 = 1200` rank-two blocks `Z e_{a,b} (+) Z f_{b,a}`,
each a free `Z[C_2]`-module with the sign twist; the decomposition is
`s^*`-stable by construction. On one block, `x e + y f` is invariant iff
`x = -y`, so `V^s = Z(e-f) = (1+s^*)(Ze) = T`. The certificate computes: the
single block exactly; the full case at the true ranks
(**ambient rank 2400, invariants rank 1200, transfers rank 1200, all inclusion
elementary divisors 1, invariants = transfers**), verifying blockwise that `s^*`
is a signed permutation of the basis whose orbits are all of size two
(`{2: 2400}`) with **no fixed basis vector**; and, as a cross-check on the
lattice code, the same computation monolithically at reduced ranks
`10 x 12` (ambient 240, elementary divisors `1^120`, invariants = transfers). ∎

**Corollary 2.2 (the image of `q^*`).** In this bidegree
`image(q^*) = T` exactly. Indeed `s^*q^* = q^*` puts `image(q^*) ⊆ V^s`, while
`q^*q_* = 1+s^*` puts `T = (1+s^*)V = q^*(q_*V) ⊆ image(q^*)`; combine with
Lemma 2.1. Equivalently: if `Γ = q^*Z` then `q_*Γ = 2Z` and
`q_*(1+s^*)u = 2q_*u`, so `Z = q_*u` for some `u ∈ V` and every element of `T`
is realized.

**So the `(1,5)` component of `q^*Z` is `Σ_i c_i(α_i (x) β_i - β_i (x) α_i)` with
arbitrary integers `c_i`, and there is no room for a second factor of two.**

**The control has teeth.** Run on a repeated-**even** bidegree `(p,p)` with
Koszul sign `+1` (rank six model), the same code returns inclusion elementary
divisors `1^15 2^6` and `invariants = transfers: False` — the six fixed diagonal
basis vectors each contribute a factor two. This is exactly the phenomenon the
Kunneth audit §5 calls "the repeated-even generator already contains its factor
two". A repeated-**odd** bidegree (Koszul sign `-1`, rank six) returns `1^15` and
`True`, since the diagonal vectors are then anti-invariant. So the test detects a
factor two precisely when one is present, and reports none in `(1,5)`.

**Torsion caveat, and why it is harmless.** `H^*(M,Z)` may have torsion, so the
integral Kunneth sequence for `H^6(M x M,Z)` carries `Tor` terms and the
bidegree decomposition above is a statement modulo torsion. This cannot affect
the ruling: the readout is `∫_J Θ·α'·b_*β` with values in `Z`, `b_*` kills the
torsion of `H^5(M,Z)` (pass-2 Theorem 2), and `∧^7Λ` is torsion-free — so no
torsion class contributes to the degree at all.

## 3. The anti-graph factor is `±2` in every channel

The certificate evaluates, from the fixed conventions alone,
`(1,ι)^*(x (x) y + (-1)^{pq} y (x) x) = c_{p,q}·(x·y)`:

| channel `(p,q)` | Koszul sign | `c_{p,q}` |
| --------------- | ----------: | --------: |
| `(0,6)`         |        `+1` |      `+2` |
| `(1,5)`         |        `-1` |      `-2` |
| `(2,4)`         |        `+1` |      `+2` |
| `(3,3)`         |        `-1` |      `-2` |
| `(4,2)`         |        `+1` |      `+2` |
| `(5,1)`         |        `-1` |      `-2` |
| `(6,0)`         |        `+1` |      `+2` |

So `|c_{p,q}| = 2` uniformly. This reproduces the Kunneth audit's own §1
statement — "Pulling every transfer generator to the anti-graph therefore gives
twice an integral class. Hence `λ(Z) := ½ j^*Γ ∈ H^6(M,Z)` is integral" — and
pins the arithmetic: **the `½` in `λ(Z) = ½(1,ι)^*Γ` is consumed exactly once, in
every channel, cancelling precisely this factor two.** No further halving exists
anywhere in the chain.

## 4. Independent geometric calibration

**Test class: the axis channel `(0,6)`.** For a transfer generator `1 (x) y + y (x) 1`
with `y ∈ H^6(M)` even, `c_{0,6} = +2`, so `λ = y` and

\[ d \;=\; \int_M h\,y \;=\; \int_J \Theta\cdot b_* y . \]

For the minimal curve class, the certificate computes directly from the
polarization

\[ \int_J \Theta\cdot\frac{\Theta^4}{4!} \;=\; \frac{5!}{4!} \;=\; \mathbf 5 . \]

**Why this is independent of both disputed notes.** Three reasons, and I claim no
more than they support. (i) The value is a property of the principal
polarization alone — `Θ^{[5]}` is the positive top class, certified — so it uses
no trace, no coefficient structure, and neither normalization. (ii) The Kunneth
audit states the same value independently in its §2.1, in the *other* direction
of its own argument: "Conversely such a curve gives the usual **degree-five**
multisection by pairing it with `[M]`". That sentence is a statement about the
axis channel, where the degree is a plain intersection number and no
divided-trace step is even available. (iii) **Five is odd, so it is not twice
anything**: applying a second halving in this channel would return `5/2`, not an
integer. Since §3 shows the halving mechanism is uniform across channels
(`|c_{p,q}| = 2` everywhere), a second halving cannot be legitimate in `(1,5)`
either.

**Scope of the calibration.** I looked for a test class *inside* the `(1,5)` channel
whose unordered degree is known independently, and there is none in the corpus:
every recorded `(1,5)` value is computed by one of the two disputed readouts, so
using any of them would be circular. I say that explicitly rather than
manufacture a test. The `(0,6)` calibration is genuinely independent, and it
tests the load-bearing step — the number of halvings — which is shared by all
channels.

## 5. Ruling

**Winner: readout (A), the `F_2`-linear one. The raw contraction *is* the
unordered degree.** Both tests agree: the lattice verdict (§2) leaves no room for
a second factor of two, and the calibration (§4) shows the halving is used
exactly once.

**Exact defect in the losing chain, by locus.** A second halving is applied when
passing from the raw contraction to the "coefficient trace":

- `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`, §2.3, at the
  sentences "For the generic marked non-CM `E^5` structure, (2.3) turns the Hodge
  residue into an endomorphism of the five-dimensional coefficient lattice. Its
  unordered degree is the coefficient trace. The identity therefore has degree
  five, not ten." The step from the pairing (2.3) to "the coefficient trace" is
  the unsupported halving.
- `notes/2026-08-11-c904-exotic-deck-final-move-red-team.md`, executive verdict:
  "This is the five-dimensional **coefficient** trace, not the ordinary
  `F_2`-linear trace on the ten-dimensional Hodge lattice; the latter is even and
  is divided by two on passage to the symmetric quotient." The final clause is
  the defect: the passage to the symmetric quotient is `λ(Z) = ½(1,ι)^*Γ`, and
  that `½` has already been spent cancelling the transfer generator's factor two.
- The contradiction is **internal to the first note**: its §1 uses the `½` once,
  for exactly that cancellation; its §2.3 spends it again.

The same note's §4 "sharp construction target" inherits the defect: "an integral
codimension-three correspondence on `M x M` whose mod-two Lefschetz residue is
the identity on the coefficient lattice" names a class whose degree is, under the
ruling, **even**.

## 6. Consequences

### 6.1 The computations stand; the interpretations flip

Nothing computed in the disputed notes is wrong. Their exotic-deck fixed
dimensions (25 in `p15`, 396 in `p24`), their residual module structures
(`Q_15 = 5W`, `Q_24 = 1^24 (+) 10W`), and their observation that the raw ordered
contraction vanishes identically on the full-`S_3`-fixed `p15` space (their
equation (2.1)) are all confirmed or untouched. What changes is that **the raw
contraction is the degree**, so (2.1) is a parity statement rather than "the
wrong functional".

Certified here, abstractly and independently of the geometry: with
`End_{S_3}(V^5) ≅ M_5(F_2)` and `End_{C_3}(V^5) ≅ M_5(F_4)`,

- `tr_{F_2}(φ) = Tr_{F_4/F_2}(tr_{F_4}(φ))` for `F_4`-linear `φ` on `F_4^5`
  (verified on all canonical samples), with `Tr_{F_4/F_2}(0)=Tr(1)=0` and
  `Tr(w)=Tr(w^2)=1`;
- hence `tr_{F_2}` vanishes identically on `M_5(F_2)` (verified on every
  elementary matrix `e_{ab}`, which span it);
- and `tr_{F_2}` is **not** identically zero on `M_5(F_4)`: it is odd exactly when
  the `F_4`-coefficient trace lies outside `F_2`. The identity has
  `tr_{F_4}(I_5) = 5 = 1 ∈ F_2`, so its degree is even.

### 6.2 What the full-`S_3` vanishing then obstructs

**Statement.** A `(1,5)` residue that is invariant under the full `S_3` has even
degree. Consequently a codimension-three class on `M x M` whose `(1,5)` residue
is forced to be `S_3`-invariant cannot contribute odd degree in that channel.

**The exact hypothesis under which an algebraic class is forced to be
`S_3`-invariant.** The class must be defined over the **unmarked** base — i.e.
horizontal over a base whose monodromy on `H^1(-,F_2)` is the full
`S_3 = C_3 ⋊ C_2` generated by the residual order-three monodromy and the exotic
deck. Two inputs, both already recorded: the valid integral direction of the
invariant-cycle argument (`notes/2026-08-11-c904-relative-invariant-cycle-franchetta-audit.md`
§1 — a cycle defined over the generic field spreads after shrinking and its
integral cohomology class is monodromy invariant, by functoriality of cycle
classes alone), and the deck statement itself
(`notes/2026-08-11-c904-exotic-deck-kunneth-descent.md` §2, "Relative
consequence": "A cycle defined over the unmarked base gives a flat integral class
fixed by both the residual monodromy and the deck").

### 6.3 What flips, precisely

The live records state the finite-monodromy route as **dead** as a parity
obstruction, because the invariant spaces contain odd contractions. The
corrected statement, channel by channel:

- **`(1,5)`, full `S_3`:** the invariant space contains **no** odd contraction.
  The exotic deck **is** a parity obstruction here, for classes defined over the
  unmarked base. *This reverses the recorded verdict for this channel and this
  hypothesis.*
- **`(1,5)`, residual `C_3` only:** odd contractions **do** exist (those with
  `F_4`-coefficient trace outside `F_2`), so residual `C_3` alone is still not an
  obstruction. *The recorded verdict stands for the marked base.*
- **`(2,4)`:** unchanged. The corpus's own reading there is already the direct
  contraction — "the direct contraction is already the quotient degree" — which
  is what the ruling endorses, and their equation (3.2) gives a nonzero
  contraction on the `S_3`-fixed space. No divided-trace step is involved.
- **`(3,3)` and `(0,6)`:** unchanged. `(3,3)` is even for the independent
  `Θ^2 = 2Θ^{[2]}` reason; `(0,6)` is the calibration of §4.
- **Construction target:** replace "residue = the coefficient identity" by
  "residue with odd `F_2`-linear trace", equivalently — for `F_4`-linear
  residues — "`F_4`-coefficient trace outside `F_2`". The identity is **not** such
  a class.
- **Pass-2 §6 suspicion:** resolved in favour of the derivation there.

### 6.4 What is **not** claimed

Per the frozen scope, no channel-closure theorem is promoted in this pass.
Specifically I do **not** claim:

- that the `(1,5)` channel is closed. It is closed only for `S_3`-invariant
  residues, i.e. for classes over the unmarked base. **Paper V and C904 live on
  the marked exotic base**, where only `C_3`-invariance is forced and odd
  residues remain available.
- that any relevant algebraic class must be `S_3`-invariant. That is a hypothesis
  about the base, stated in §6.2, not a theorem proved here.
- anything about algebraicity, Hodge-ness, Chow descent, or the unordered-theta
  index. The ruling is about a normalization.

A closure theorem, if the unmarked-base hypothesis can be made to bind, is the
next pass's business.

## 7. Flags for the C904 owner

Every committed statement this ruling contradicts, with loci and no edits made:

1. `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md` §2.3: "Its
   unordered degree is the coefficient trace. The identity therefore has degree
   five, not ten." — Contradicted; the degree is the raw contraction and the
   identity is even.
2. Same note, §4, bullet "**Invalid obstruction:** even rank-ten trace or square
   characteristic polynomial. Symmetric descent halves that trace." — The premise
   is contradicted: symmetric descent does not halve it a second time.
3. Same note, §4, "Sharp construction target: an integral codimension-three
   correspondence on `M x M` whose mod-two Lefschetz residue is the identity on
   the coefficient lattice" — target misidentified; see §6.3.
4. Same note, §5 and Mystery ledger, "whether the odd `(1,5)` Hodge coset is
   integrally algebraic" — the coset called odd (the identity) is even; the
   question survives with a different coset.
5. `notes/2026-08-11-c904-exotic-deck-final-move-red-team.md`, executive verdict
   and its table row for `p15` ("raw contraction: identically even; actual
   quotient degree: odd; fixed identity has degree `5 ≡ 1`") — the two columns
   should be the same functional; the raw column is the degree.
6. `notes/2026-08-11-c904-exotic-deck-kunneth-descent.md` §2, equations
   (2.3)--(2.4) and the Mystery-ledger line "full exotic monodromy preserves the
   odd divided-degree `p15` identity; the vanishing raw contraction is the wrong
   ordered-trace functional" — reversed for the `S_3`-invariant case.
7. `notes/2026-08-11-c904-c3-kunneth-descent-boundary.md` §5 item 1 and the
   ledger line "residual `C_3` does not force evenness" — **stands** for `C_3`;
   only the full-`S_3` extension of it flips.
8. The live handoff/ledger line recording the finite-monodromy route as closed
   in both mixed channels — needs the split of §6.3: `(1,5)` under full `S_3`
   flips, `(2,4)` and `C_3`-only do not.

## 8. Bundle, replay, checksums

Working directory: the repository root `/home/tavis/src/othello`.

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-11-c908-unordered-degree-normalization.sage \
  --json notes/2026-08-11-c908-unordered-degree-normalization.json \
  --out notes/2026-08-11-c908-unordered-degree-normalization.out
```

The Sage run leaves a preparsed `.sage.py` translation which must be deleted; the
committed bundle is debris-free.

| artifact                                              |  bytes | SHA-256                                                          |
| ----------------------------------------------------- | -----: | ---------------------------------------------------------------- |
| `2026-08-11-c908-unordered-degree-normalization.sage` | 22,139 | 5f2b7cf4a8c1dc1c97f7e0c55fbb9d45b5804409d2c78948b946bbcd5316b9ed |
| `2026-08-11-c908-unordered-degree-normalization.json` |  7,593 | 40bda760589d3f0a885e87d65da3740fa2384c38a27a9e5428d9fcc4712c0972 |
| `2026-08-11-c908-unordered-degree-normalization.out`  |    665 | 78ea8035f4a60d7c9d92c5fcf8debe4cf281a8dededb9b9c803cba62859b7987 |

Load-bearing input:
`notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`, SHA-256
`d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734`.

**Certified:** the `(1,5)` invariants-equal-transfers fact at the true ranks
(blockwise, with the signed-permutation and no-fixed-vector checks) and
monolithically at reduced ranks; the repeated-even and repeated-odd controls; the
per-channel anti-graph factors; `∫_J Θ·Θ^4/4! = 5` and `Θ^{[5]}` being the
positive top class; the absolute-trace identity and the vanishing of `tr_{F_2}`
on `M_5(F_2)`. **Not certified:** any geometric input from the pass-2 note
(`H^1(M,Z) = b^*Λ`; `b_* : H^5(M,Z)/tors ≅ ∧^7Λ`), which are human proofs there;
the `Tor` terms of the integral Kunneth sequence (§2, torsion caveat — argued
harmless, not computed); and the base-monodromy hypothesis of §6.2.
**Cross-checks:** the derivation of §3 independently reproduces the Kunneth
audit's own §1 integrality statement; the axis calibration independently
reproduces that audit's own §2.1 value five; and the control cases show the
lattice test is sensitive to a genuine factor two.

## 9. Mystery ledger (EJ + TT closeout)

- **Settled:** in bidegree `(1,5)` invariants equal transfers, index one, at the
  true ranks. `q^*` cannot produce an extra factor two. This is the fact that
  decides the dispute.
- **Settled:** the anti-graph factor is `±2` in every channel, so the `½` in
  `λ(Z)` is consumed exactly once. A second halving is arithmetically impossible
  in the `(0,6)` channel, where it would return `5/2`.
- **Settled:** readout (A) wins; the defect is a double-counted halving, with
  loci in §5, and it is internally inconsistent with §1 of the same note.
- **Settled, and the genuine surprise:** the exotic-deck vanishing that the
  corpus explained away is real. The full-`S_3` invariant `(1,5)` space carries no
  odd degree — so the deck computation was a parity obstruction all along, for
  classes over the unmarked base. The corpus talked itself out of its own result.
- **Settled:** `(2,4)`, `(3,3)`, `(0,6)` and the `C_3`-only `(1,5)` conclusions are
  unaffected.
- **Open, and the next frozen target:** does the unmarked-base hypothesis of §6.2
  bind any class relevant to the C904 gate? The marked exotic base is where
  Paper V lives, and there only `C_3`-invariance is forced, so the obstruction as
  proved does not reach it. Making it bind — or showing it cannot — is the
  closure question.
- **Open:** the corrected construction target (residue with `F_4`-coefficient
  trace outside `F_2`) has no candidate class. Note that such a residue is *not*
  `S_3`-invariant, so any construction realizing it must be genuinely
  marked-base and deck-asymmetric.
- **No manufactured mystery:** the torsion gap in §2 is real but provably
  harmless for the degree, and I have not dressed it up as an open problem.
