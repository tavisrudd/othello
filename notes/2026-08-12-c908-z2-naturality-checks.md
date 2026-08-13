# C908: naturality checks for the (Z/2)^10 identifications (successor pass)

Date: 2026-08-12

Status: **closed -- both deferred items settled, both CONFIRMED.** This note
discharges the two successor items pass-9 and pass-9b flagged as cheap,
one-session finite checks:
`notes/2026-08-12-c908-h3-lattice-adjudication.md` §7 ("What remains of item
4 is only naturality: whether the composite identifications commute with the
geometric maps ... left to the successor") and
`notes/2026-08-12-c908-h3-compression.md` §6 ("Open (small, sharpened by
K2): the fourth `(Z/2)^10` ... should now match the closed form under `a_*`
... a one-session naturality check"). C908 mathematics only; no manuscript,
PDF, mirror, Lean, or C904-surface edit; only files under
`notes/2026-08-12-c908-z2-naturality-*` were written.

Notation as in pass 9 (`notes/2026-08-12-c908-h3-lattice-adjudication.md`)
and pass 9b (`notes/2026-08-12-c908-h3-compression.md`). `Λ = H^1(J,Z)`
with fixed unimodular alternating Gram matrix `S` (the principal
polarization, from the corpus `principal_lattice` construction -- **not**
the standard symplectic block form: `S² ≠ -I` in this basis, verified
below); `Θ = two_form(S) ∈ ∧²Λ`; `L_3 = Θ∧(-): ∧³Λ→∧⁵Λ`,
`L_5 = Θ∧(-): ∧⁵Λ→∧⁷Λ`; `Sat` the saturation of `L_3∧³Λ` in `∧⁵Λ`,
`[Sat : L_3∧³Λ] = 2^10`; `ρ : (∧⁹Λ)⊗F_2 → Sat/L_3∧³Λ` the pass-9 glue,
closed form `ρ(γ) = [Θ^{[2]}∧S·w(γ)]` (pass-9b K2), `w : ∧⁹Λ→Λ` the
K2c top-wedge pairing.

## Method

Explicit finite linear algebra over `Z`/`F_2`, in Sage, reusing (loading,
not copying) the committed pass-7 machinery
(`notes/2026-08-11-c908-span-incidence-residues.sage`) and cross-checked
against the committed pass-10 compression certificate
(`notes/2026-08-12-c908-h3-compression.json`). Certificate:
`notes/2026-08-12-c908-z2-naturality-checks.sage`. Replay:

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-12-c908-z2-naturality-checks.sage \
  --json notes/2026-08-12-c908-z2-naturality-checks.json \
  --out notes/2026-08-12-c908-z2-naturality-checks.out
```

Every check is an in-script assertion (failure aborts the run with the
assertion message, not a silent downgrade). Two modes are used and labeled
per check: **computational** (an explicit matrix/Smith-form/equivariance
test) and **structural** (a short proof, stated explicitly, for steps where
forcing a computation would just re-verify a general algebraic fact).

## Item 1 — naturality of the three-way `(Z/2)^10` identification

**Verdict: CONFIRMED**, for all three named structures (deck action,
Sp(Λ) monodromy, and the L_3/L_5 adjointness mechanism), on every check run.

### 1a. Deck action (`-1 ∈ J`)

**Structural, cross-checked computationally.** `∧^k(-\mathrm{id})=(-1)^k\,\mathrm{id}`;
mod 2, `-1≡1`, so `-1` acts as the identity on `∧⁵Λ`, `∧⁹Λ`, and hence on
every mod-two space in play, for **any** degree. Verified directly by
building the exterior-power matrices of `-id` at degrees 5 and 9 and
checking they reduce to the identity mod 2. This is the correct reading of
pass-9b's own finding ("`(−1)^*` acts by `−1` on `∧⁵Λ`") at the mod-two
level relevant to `ρ`: it commutes with every identification here because
the action is trivial mod 2, not because of any special compatibility.

### 1b. Sp(Λ,S) monodromy naturality of ρ

**Precise map.** `ρ : (∧⁹Λ)⊗F_2 → \mathrm{Sat}/L_3∧³Λ`. The monodromy group
of the family of cubic threefolds is (Beauville, cited in
`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md` line 654)
`Sp(10,\mathbf Z)` acting on `Λ = H^3(X,Z)`; naturality of `ρ` means: for
every `g∈\mathrm{Sp}(Λ,S)` (i.e. `gSg^\top=S`, the condition making `g`
fix `Θ∈∧²Λ` as a bivector), `ρ\circ(∧⁹g \bmod 2) = (\text{induced action of
}∧⁵g\text{ on }\mathrm{Sat}/L_3∧³Λ)\circ ρ`.

**A basis subtlety, recorded not glossed over.** The corpus polarization
`S` is not written in the standard block form: `S² ≠ -I` in this basis
(verified directly). This matters because the "obvious" argument for
Sp-equivariance (using `S²` central, hence commuting with every `g`) is
**not available** here; the check was done by direct matrix computation
against explicit elements of `\mathrm{Sp}(Λ,S)` instead of by that shortcut.

**Construction of test elements.** Symplectic transvections
`g_v = I + v\,v^\top S^{-1}` satisfy `g_vSg_v^\top=S` exactly for *any*
integer vector `v` (since `S^{-1}` is alternating, `v^\top S^{-1}v=0`
always); `\det(g_v)=1`. Three transvections (different `v`) plus one
product of two were tested.

**Results (all four elements, all sub-checks PASS):**
- `Θ` is fixed exactly (`∧²g(Θ)=Θ`) for every tested `g` — confirms the
  transvection construction targets the correct group.
- `L_3\cdot(∧³g) = (∧⁵g)\cdot L_3` exactly (structural once `Θ` is fixed,
  by wedge-functoriality; verified directly).
- `\mathrm{Sat}` is `∧⁵g`-invariant (consequence of the above plus
  invertibility; verified on the ten torsion representatives).
- **Payload:** `ρ\cdot(∧⁹g \bmod 2) = (\text{induced }∧⁵g)\cdot ρ` holds
  exactly, for all four tested elements.

`ρ` is therefore Sp(Λ,S)-equivariant on every generator tested — not a
proof for the full infinite group from a finite check, but a decisive,
non-trivial confirmation (a random symplectic transformation had no reason
to satisfy this unless `ρ`'s K2 closed form, `ρ(γ)=[Θ^{[2]}∧S\!\cdot\!w(γ)]`,
is genuinely built from `Θ`, `Θ^{[2]}` and `S` alone, which is exactly what
makes the wedge-functoriality argument above go through structurally once
the computation confirms `Θ` is fixed).

### 1c. `L_3`/`L_5` adjointness — the mechanism behind `Q_15 = coker(L_5)`

**Precise maps.** Two canonical, always-available perfect pairings on a
rank-10 free module: `P_{3,7}:∧³Λ\times∧⁷Λ\to\mathbf Z` and
`P_{5,5}:∧⁵Λ\times∧⁵Λ\to\mathbf Z`, both via wedge into the fixed top form
`∧^{10}Λ\cong\mathbf Z`. **Checked:** both are unimodular
(`\det=1`), and the exact integral identity

\[ L_3^\top P_{5,5} = P_{3,7}\,L_5 \]

holds **on the nose** — `L_5` is literally the adjoint of `L_3` under these
two orientation pairings, not an independently chosen map. Consequence
(structural, general homological algebra, applied to the now-confirmed
identity): dualizing `0\to∧³Λ\xrightarrow{L_3}∧⁵Λ\to∧⁵Λ/L_3∧³Λ\to0` gives
`\mathrm{coker}(L_3^\top)\cong\mathrm{Ext}^1(∧⁵Λ/L_3∧³Λ,\mathbf Z)`, which
by the universal coefficient theorem is canonically the dual of the torsion
subgroup `\mathrm{Sat}/L_3∧³Λ`. Since `P_{3,7}` identifies
`\mathrm{coker}(L_5)` with `\mathrm{coker}(L_3^\top)` (the adjointness
identity), **`Q_15=\mathrm{coker}(L_5)\cong(\mathrm{Sat}/L_3∧³Λ)^\vee`
canonically**, with no extra choice beyond the fixed orientation — refining
pass-9's `Q_15\cong Λ_2^\vee` to its more primitive, directly-verified
source. Also checked: `L_5`'s elementary divisors match `L_3`'s exactly
(`1^{110}2^{10}`, forced by the adjointness), and both pairings are
`g`-invariant on every tested monodromy element (structural — any
`\det(g)=1` fixes an orientation pairing — and spot-checked directly).

## Item 2 — the fourth `(Z/2)^10`: `coker(C_s∪(-))`

**Verdict: CONFIRMED.** The fourth space is canonically the same object as
the other three, under an explicit map built from exactly the same two
ingredients `ρ` itself needs.

**Setup (structural).** A5.e
(`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md`) gives, for
`α,β∈H^1(F,\mathbf Z)=Λ` (via `a^*`, A5.b): `\int_F C_s∪α∪β = 2S(α,β)`. Under
Poincaré duality `H^3(F,\mathbf Z)=\mathrm{Hom}(H^1(F,\mathbf Z),\mathbf Z)`
(A5.a, torsion-freeness), `C_s∪(-)` **is** the matrix `2S`. Since `S` is
unimodular, `\mathrm{image}(2S)=2H^3(F,\mathbf Z)` exactly, so
`\mathrm{coker}(C_s∪(-)) = H^3(F,\mathbf Z)\otimes F_2` canonically —
no computation needed beyond confirming `S` unimodular (already standing).

**The bridge to `ρ`'s domain (computational, the actual payload).** The
certified 940-generator machinery (pass-9b's `Cs(x)a*e_k` block, reused
verbatim, not re-derived) already fixes, in its own bookkeeping,
`a_*(C_s∪e_k) = 2\,Θ^{[4]}∧e_k \in ∧⁹Λ` for the diagonal restriction of the
Künneth class `C_s\otimes e_k`. A **first naive guess** — that
`Θ^{[4]}∧e_k` (as a matrix in `k`) equals `S` itself (or `S^\top`,
`S^{-1}`, `-S`, or the identity) — **is REFUTED**: none of these five
match; the computed matrix (recorded in the json,
`item2_fourth_space.half_V4_matrix`) has determinant 1 (so it is itself
unimodular) but does not coincide with any of them. This is a genuine,
reportable negative for the simplest hypothesis.

The correct closed form, found by testing the same combination-with-`w`
pattern pass-9b's K2 already used for `ρ` (`w`, the K2c orientation pairing,
composed with `S` or `S^{-1}`):

\[ Θ^{[4]}∧e_k \;=\; \bigl(w^\top S^{-1}\bigr)_{\cdot,k} \;=\; \bigl(-w\,S^{-1}\bigr)_{\cdot,k}, \]

confirmed **exactly** (all ten columns, integer entries) against the
independently-recomputed `w` matrix (not reloaded from pass-10's json).
So `a_*(C_s∪α) = 2\,w^\top(S^{-1}α)` — built from exactly the two canonical
ingredients (`w` and `S`) that `ρ`'s own closed form `ρ(γ)=[Θ^{[2]}∧S w(γ)]`
uses, not an independent or unexplained twist. This map is also
Sp(Λ,S)-equivariant on every tested monodromy element (structural — `Θ`,
hence `Θ^{[4]}`, is `g`-fixed, so `k\mapsto Θ^{[4]}∧e_k` is automatically
equivariant by the same wedge-functoriality argument as 1b; spot-checked
directly).

**Reading.** The fourth `(Z/2)^10` is not merely isomorphic to the other
three by a rank coincidence: `\mathrm{coker}(C_s∪(-))\cong H^3(F,\mathbf
Z)\otimes F_2` lands on `ρ`'s domain `(∧⁹Λ)⊗F_2` via `w^\top S^{-1}\bmod 2`
and from there onto `\mathrm{Sat}/L_3∧³Λ` via `ρ` itself — the same map
used throughout, confirming pass-9b's prediction ("should now match the
closed form under `a_*`").

## Certificate bundle and replay

```sh
nix shell nixpkgs#sage -c sage \
  notes/2026-08-12-c908-z2-naturality-checks.sage \
  --json notes/2026-08-12-c908-z2-naturality-checks.json \
  --out notes/2026-08-12-c908-z2-naturality-checks.out
```

| artifact | SHA-256 |
|---|---|
| `notes/2026-08-12-c908-z2-naturality-checks.sage` | `724da742e7c5e491fabb7fa627b9cfcd6da25fe825f77e969ae38ee4a67e795f` |
| `notes/2026-08-12-c908-z2-naturality-checks.out`  | `f426eb4db604f007b345aa001b5f80e7dc04cdb3f98bc47c9e4927c548be6c4e` |
| `notes/2026-08-12-c908-z2-naturality-checks.json` | `10e222d045c25514ba802d8b5fa97b883a07bb54486904aebcc4a56dc17b100a` |
| input `notes/2026-08-11-c908-span-incidence-residues.sage` | `6f7f015c864884059d21f75c790aa382f8ca353fe4a21d617560588baddb323d` |
| input `notes/2026-08-10-c904-minimal-class-divisor-lattice.sage` | `d77752dcf242cdd3e8ecf15d34785eba583aa4c4c7770b79decd2f43e260f734` |
| input `notes/2026-08-12-c908-h3-compression.sage` | `ae28a8025858b8a738660ba17b3fc58b6f0d649b6ba33773a378c8b8c0601378` |
| input `notes/2026-08-12-c908-h3-compression.json` | `5409ce0528f82327232827d1ee10695efcf12e8d1bc9cb72699e24ace7a391c2` |

(As recorded live by the certificate under `inputs` in the emitted json;
transcribed here for a self-contained report.)

**Independent-check discharge.** No separate reference implementation in a
different backend was built for this bounded pass (unlike pass-9's PARI
cross-check). The following internal cross-checks and invariant tests serve
the role instead: (i) this script's own Sat/class_map pipeline is verified,
before `ρ` is borrowed, to reproduce pass-10's independently-hashed K1
half-Lefschetz class matrix exactly, byte for byte; (ii) the `ρ`-equivariance
payload (item 1b) is tested against four distinct, independently-constructed
group elements (three transvections from different vectors plus a product),
any one of which could have falsified it; (iii) the `L_3`/`L_5` adjointness
identity (item 1c) is itself a strong invariant check on the already-fixed
`L_3` Smith form from pass-9/9b — a wrong `L_3` would generically break the
exact matrix identity; (iv) item 2's bridge match was found by exhaustive
search over the natural finite candidate set (`S`, its transpose/inverse,
`±`, and combinations with `w`), not asserted.

## Mystery ledger (EJ + TT closeout)

- **Settled:** naturality of the three-way `(Z/2)^10` identification
  (pass-9's ledger item), via explicit Sp(Λ,S) monodromy checks against
  concrete transvections built from the corpus's actual (non-standard-form)
  polarization, and via the exact `L_3`/`L_5` adjointness identity. No
  residual open naturality question for these three.
- **Settled:** the fourth `(Z/2)^10` (pass-9b's ledger item) is canonically
  the same object as the other three, via `w^\top S^{-1} \bmod 2`. The
  naive guess (plain `S`) is refuted — recorded as a genuine, if minor,
  correction to the simplest closed-form expectation; the actual bridge
  needs the same orientation pairing `w` that `ρ` itself needs, which in
  hindsight is the more natural guess (both `ρ` and this bridge cross a
  parity change between `Λ` and `∧⁹Λ`, and `w` is the canonical map doing
  that crossing).
- **Surprising and unexplained (new, small):** `S² ≠ -I` in the corpus's
  own basis for `Λ`. This is very likely a harmless artifact of how
  `principal_lattice` in the shared corpus
  (`notes/2026-08-10-c904-minimal-class-divisor-lattice.sage`) builds its
  integral basis (any unimodular alternating form is `GL(n,\mathbf Z)`-
  congruent to the standard block form, but congruence does not preserve
  `S²`), not a defect — but it blocked the naive equivariance shortcut and
  is worth a one-line note if a future pass reuses `S²`-centrality
  anywhere. No successor action needed; flagging only.
- **No genuine mystery remains for the two items this pass was scoped to.**

## Verdict

Both deferred successor checks are closed, both CONFIRMED. Item 1
(naturality of the three-way identification) holds under the deck action
(trivially, mod 2) and under Sp(Λ,S) monodromy (checked against concrete
transvections of the corpus's actual polarization), with the `L_3`/`L_5`
adjointness identity giving a structural reason `Q_15` is naturally dual to
`Sat/L_3∧³Λ`, not just isomorphic to it. Item 2 (the fourth `(Z/2)^10`) is
canonically identified with the other three via `w^\top S^{-1}\bmod 2`,
after the simplest guess (plain `S`) was tested and refuted.

Vibe check: clean close, no loose ends, one small refuted guess along the
way that self-corrected within the same run.

`go clebsch` -- no unblocked concrete C-item is allocated past this point in
the material read for this task; the next step is the successor's own
choice (the λ-leg computation, pass-9b §4, remains the frontier item named
by pass-9/9b's own ledgers).
