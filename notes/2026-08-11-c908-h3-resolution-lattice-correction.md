# C908: pass-2 Theorem 1 is false in degree three — the triple point enlarges H³(M,Z)

Date: 2026-08-11

Status: **certified refutation of a committed corpus claim, with independent
verification, an identified proof gap, and the exact surviving/fallen
dependency map.** C908 mathematics only; no manuscript, PDF, mirror, Lean,
or C904-surface edit. The pass-2 note
(`notes/2026-08-11-c908-m-cross-m-exceptional-residue.md`) is left unedited
per append-only conventions; this note is the correction of record.

## 1. The refuted claim and the measurement

Pass-2 Theorem 1 asserted: `b^* : H^k(J,Z) → H^k(M,Z)` is an isomorphism
for `k = 1` and `k = 3` (`M = Bl_0 Θ`, `b : M → J`).

Measured refutation of the `k = 3` half. For `T'' ∈ H^3(F×F,Z)`, the class
`q_*μ^*T'' ∈ H^3(M,Z)` has `b_*`-image `ψ_*T''` (all maps as in the pass-7/8
notes). If `b^*` were surjective in degree three, `ψ_*T''` would lie in
`L_3(∧³Λ)` with **integral** preimage. The gate-A certificate computes, for
all 940 integral Künneth generators of `H^3(F×F,Z)`:

- 626 generators have `L_3`-preimage with denominator exactly two (all are
  rationally solvable — `ψ_*` lands in the saturation);
- the 626 are **precisely** the generators whose diagonal restriction
  `i_Δ^*T''` is odd;
- in particular all ten `H^3⊗H^0` generators `β⊗1` are half-integral.

Hence `b_*H^3(M,Z) ⊋ L_3(∧³Λ)` and `H^3(M,Z) ⊋ b^*H^3(J,Z)`: the map is
not surjective. An independent implementation (different code path, direct
`L_3`-solve on four `H^3⊗H^0` generators and one integral control) confirms
denominator two exactly where predicted:
`notes/2026-08-11-c908-halfint-independent-check.{sage,out}`.

## 2. The identified proof gap, and the mechanism

The pass-2 proof's step (ii) asserted "removing the single point 0 from the
four-dimensional Θ changes nothing in degrees k ≤ 6". That is a
smooth-point statement. `0` is the ordinary triple point, whose punctured
neighbourhood retracts onto the link `L` of the cone over the cubic
threefold `X ⊂ P^4`. The Gysin sequence of the circle bundle `L → X` gives

    H^2(L,Z) = 0,   H^3(L,Z) = Z^10   (H^1(X) = 0; ∪h : H^2(X) → H^4(X)
                                        is multiplication by 3, injective),

so `H^3(Θ∖0)/H^3(Θ)` embeds in `Z^10` and the deletion step fails exactly
there. The new classes in `H^3(M,Z)` are link classes of the triple point —
degree-three content of the exceptional cubic `X` re-entering integrally.
The `k = 1` half of Theorem 1 is unaffected (`H^1(L) = 0` by the same
Gysin computation), and its proof stands.

Consistent numerology, recorded not adjudicated: `coker(L_3) ≅ (Z/2)^10`
(Smith form `1^110 2^10`, corpus-certified), `H^3(X,Z) ≅ Z^10`, and the
measured enlargement is exponent two detected by diagonal parity. The
precise integral structure of `H^3(M,Z)` — rank, torsion, the exact index
`[b_*H^3(M,Z) : L_3(∧³Λ)]` — is the first open item of the adjudication
(§4).

## 3. Dependency map: what survives, what falls

Survives, checked:

- **All pass-6 and pass-7 verdicts.** Those readouts (the Pontryagin
  transfer image, the span-incidence sweep) were computed intrinsically on
  `J` and `J×J`; no `H^3(M)`-surjectivity entered any of them.
- **The residue functional's first-leg recovery** (pass-2 §1.1): it uses
  only the `k = 1` half, which stands.
- **Pass-2 Theorem 3 and the candidate verdicts of pass-2 §5**: they rest
  on `b∘e_X` constant and dimension counts, not on Theorem 1's `k = 3`
  half.
- The `k = 1` half of Theorem 1 itself.

Falls or needs re-derivation:

- **Pass-2 Theorem 2** (`b_* : H^5(M,Z)/tors ≅ ∧^7Λ`): its proof dualizes
  the `k = 3` isomorphism. With `b^*∧³Λ ⊆ H^3(M,Z)` of finite index `2^k`,
  duality gives `b_*` on `H^5/tors` injective with image of index `2^k` —
  not surjective. **Corollary 2.1's identification of the escape group**
  `H^5(M,Z)/(b^*H^5(J,Z)+tors) ≅ coker(L_5) = (Z/2)^10` therefore needs
  re-derivation on the corrected lattice; the escape quotient may be finer
  or differently normalized in up to ten directions.
- **The pass-8 gate-A interpretation**: the transfer condition was derived
  assuming every test `q_*μ^*T''` is `b^*(integral)`; the certificate's
  formal answer ("gate opens in every direction") is arithmetic fact, but
  what it *means* for reading λ must be re-derived over the corrected
  `H^3(M,Z)` — the enlarged test lattice may make detection finer, not
  blocked.
- Any downstream statement quoting "the escape lattice is exactly
  `(Z/2)^10` realized as `H^5(M)/(b^*H^5+tors)`" inherits the Theorem-2
  caveat until re-derived. The C904-level degree formula itself is
  `J`-level and untouched.

## 4. Certificate bundle and reposed work

Gate-A certificate (contains the refutation data; replay from repository
root, delete `.sage.py` debris after):

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-11-c908-gate-a-transfer.sage \
  --json notes/2026-08-11-c908-gate-a-transfer.json \
  --out notes/2026-08-11-c908-gate-a-transfer.out
```

It re-runs the full pass-7 certificate as an assertion suite (loaded, not
copied), then computes the 940-generator transfer table. Independent check
as in §1.

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-11-c908-gate-a-transfer.sage` | `82ced36dff77732282a47e43a30735b04f476013a3758b31a4e032b25ea2f84d` |
| `notes/2026-08-11-c908-gate-a-transfer.out` | `4159d3a158d5c45b14b9c6bf36e1f0db5fdc95a385e7d2362d22e3d2f5b3bc2e` |
| `notes/2026-08-11-c908-gate-a-transfer.json` | `b7d58d5e50df6d013e52f8be8df9cd4baed8ba579a9d06ca6efc976e4c0e452a` |
| `notes/2026-08-11-c908-halfint-independent-check.sage` | `e26453b65207629a0c5bbb3fe7a403d8ac7136d2b04d743ee16063b162e21127` |
| `notes/2026-08-11-c908-halfint-independent-check.out` | `cdd4de913bb16259e0c90879b6ce9be6b365ed6e0b49ab74e97daaf04221af53` |
| input `notes/2026-08-11-c908-span-incidence-residues.sage` | `6f7f015c864884059d21f75c790aa382f8ca353fe4a21d617560588baddb323d` |

Reposed work, in order:

1. **Adjudicate the integral structure of `H^3(M,Z)`**: rank, torsion, the
   exact index of `b_*H^3(M,Z)` over `L_3(∧³Λ)` (measure the lattice
   `ψ_*H^3(F×F) + L_3∧³Λ` exactly — expected `(Z/2)^10`, and prove the
   topological side via the link sequence rather than only measuring the
   algebraic image).
2. **Re-derive pass-2 Theorem 2 / Corollary 2.1** on the corrected
   lattice: the exact escape quotient and the residue-functional
   normalization in the ten affected directions.
3. **Re-derive the pass-8 transfer identity** for the λ-bit over the
   corrected `H^3(M,Z)`, then re-issue gate A with its true meaning and
   proceed to the leg computation
   (spec: scratchpad pass-8 draft, to be promoted with that pass).
4. **Upgrade lead (logged):** the enlargement is new integral structure on
   the theta resolution — exponent-two link content of the exceptional
   cubic, the same `(Z/2)^10` size as the escape group and the incidence
   cokernel of the extraction note §A5. Three groups of the same shape in
   one geometry is now a pattern demanding a common explanation, not a
   coincidence to log.

## 5. Mystery ledger (interim)

- **Settled:** the refutation itself, with mechanism (link classes) and
  independent verification.
- **Settled:** the survival of every pass-6/7 verdict (J-level readouts).
- **Open (owns the next pass):** items 1–3 above.
- **Open (structural, high upside):** item 4 — the three-fold coincidence
  of `(Z/2)^10`s.
- **Process note:** the refutation was found because a certificate asserted
  integral solvability instead of assuming it, and the failure pattern
  (diagonal parity) was reported rather than suppressed. The blanket
  assertion in the gate-A request was wrong; the sub's decision to measure
  and report is the behavior to keep.
