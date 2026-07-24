# C585 — Sporadicity comparison across gateway avatars

**Lane:** `gateway` · **Date:** 2026-07-24 · **Kind:** finite cross-avatar comparison (synthesis;
all source q-sets are read-only inputs owned by other lanes).

## Question

Do `beyond4`'s redundancy-five deep-hole **sporadic** orbits, occurring at
`q ∈ {7,8,9,11,13,17,19}`, *carry* the C474 seven-gate perfect-code carrier at those `q` — so that
deep-hole sporadicity and modular-carrier sporadicity are the **same** mechanism — or do the two
exceptional-`q` sets merely **overlap** at shared small `q`, so the coincidence is accidental?

## One-line verdict

**Coincidental overlap, not a shared mechanism.** The deep-hole sporadic orbits carry the C474
carrier at exactly `{7,11}` and fail it at `{8,9,13,17,19}`; conversely the C474 boundary `q=23` is
not deep-hole-sporadic. The two exceptional sets are neither equal nor nested — they intersect in
`{7,11}` because both mechanisms are attracted to the same *small exceptional PSL₂(q)* substrate, not
because one obstruction is the other. Hence `Φ_deep ≠ Φ_mod`, and handoff sub-question **Q1 ("one
defect identity common to all avatars") is answered in the negative**: it is a family resemblance,
not an equality of obstructions.

## The three exceptional mechanisms and their exact `q`-sets

Each avatar's sporadicity rides a **different** exceptional classification/census. That is the whole
content of the comparison.

| # | Mechanism (avatar) | Obstruction that must vanish | Exact `q`-set | Why finite | Provenance |
|---|--------------------|------------------------------|---------------|------------|------------|
| M1 | Deep-hole **conic-fill** (Clebsch, `r=3`, `k=6`) | chord-defect `Φ_deep = (q−4)(q−11)`, `q ≡ 3 (mod 4)` | `{11}` | arithmetic factorization | `clebsch` chord-defect; gateway handoff §"Deep-hole sporadicity mechanism" |
| M2 | Deep-hole **`r=5` sporadic** (`beyond4`) | S₃-geometric-monodromy stratum on the PRS deep holes is **nonempty** | `{7,8,9,11,13,17,19}` | S₃ stratum empties for large `q` (soft orbit-count bound; generic lemma needs `q ≥ 23`) | `beyond4` `04-redundancy-five.tex:225-228`, Lemma "S₃ stratum" |
| M3 | **Modular carrier** (C474) | (a) a **self-dual-extendable perfect code** of length `q` exists **and** (b) PSL₂(q) has the exceptional index-`q` sheet | realized `{7,11}`; boundary `{23}` | perfect-code classification (van Lint–Tietäväinen) + PSL₂ subgroup arithmetic | C474 note; gateway handoff §"Modular gateway (C474)" |

Fourth reference sequence (not itself an avatar, but the shared substrate below):

| — | **Biplane / A₅-index sequence** | PSL₂(q) has a strikingly small exceptional transitive action | `{7,11,19}` | finite list of exceptional PSL₂(q) actions | brainstorm G16 (11-cell / (11,5,2) biplane), G17 (57-cell / Perkel) |

### Sharpening of the M3 perfect-code gate (C585 contribution)

C474 lists the two proved instances (`[7,4,3]₂` binary Hamming; `[11,6,5]₃` ternary Golay) and flags
`q=23` (binary Golay). C585 identifies what the perfect-code gate **actually solves to**. Gate 2 of
the Modular Gateway Theorem is not "a perfect code of length `q` exists"; it is the *metabolic*
condition `D = ⟨1⟩ ⊕ S` with `S = D^⊥`, forcing `dim S = (q−1)/2`, `dim D = (q+1)/2`. A perfect code
meeting this is precisely a perfect code whose **extension is self-dual**. Those are classified:

- `[7,4,3]₂` → extended `[8,4,4]₂` self-dual,
- `[11,6,5]₃` → extended `[12,6,6]₃` self-dual,
- `[23,12,7]₂` → extended `[24,12,8]₂` self-dual.

and no others (higher Hamming codes such as `[15,11]₂`, and the length-13 ternary Hamming `[13,10,3]₃`
with `dim 10 ≠ 7`, are **not** self-dual-extendable). So

> **perfect-code gate solution set = `{7, 11, 23}`** — a hard, classified trio, not two happened-upon
> examples.

The index gate then removes 23 (PSL₂(23) has no index-23 sheet; its smallest natural action is on 24
points), leaving the modular carrier at `{7,11}`. This upgrades the modular avatar's field-sporadicity
from "we found two rows" to "the gate is a finite classification with a named boundary," and it
directly defends against C587's F1 falsifier (the "sporadic ⟺ Φ(q)=0 tautology" risk) *for the
modular avatar*: the obstruction is a genuine classification theorem, not a tautological indicator.

## The decisive check — does M2 carry M3, per `q`?

Evaluate the C474 seven-gate carrier at every `beyond4` `r=5` sporadic `q`:

| `q` | deep-hole `r=5` sporadic (M2) | self-dual-extendable perfect code (M3a) | PSL₂ index sheet (M3b) | **C474 carrier present?** |
|-----|:---:|:---:|:---:|:---:|
| 7  | yes | `[7,4,3]₂` → `[8,4,4]` | yes (Fano, PSL₂(7)≅PSL₃(2)) | **yes** (proved C474 row) |
| 8  | yes | none | — | **no** |
| 9  | yes | none | — | **no** |
| 11 | yes | `[11,6,5]₃` → `[12,6,6]` | yes (11-cell, A₅ index 11) | **yes** (proved C474 row) |
| 13 | yes | none (Hamming `[13,10,3]` not metabolic) | — | **no** |
| 17 | yes | none | — | **no** |
| 19 | yes | none (Golay is length 23) | index-19 sheet also absent | **no** |
| 23 | **no** | `[23,12,7]₂` → `[24,12,8]` | **no** (no index-23 sheet) | boundary — code but no sheet |

Reading the columns:

- M2 carries M3 at **`{7,11}` only**; at `{8,9,13,17,19}` the perfect-code gate fails outright (no
  self-dual-extendable perfect code of those lengths exists).
- The single M3 boundary `q=23` is **not** in M2 at all (the `r=5` S₃-stratum census is empty there).

So `M2 = {7,8,9,11,13,17,19}` and `M3 = {7,11}(+23)` are **neither equal nor nested**;
`M2 ∩ M3 = {7,11}`, with `{8,9,13,17,19}` and `{23}` as the separating witnesses in each direction.

## Why this is a coincidence, and what the `{7,11,19}` clustering actually is

The intersection `{7,11}` is **forced by nothing except smallness**. The three mechanisms are
independent:

- M2 vanishing ⟺ an **S₃-monodromy census** on cubic resolvents of PRS deep holes is nonempty — a
  finite-geometry orbit coincidence, finite by a soft orbit-count bound.
- M3a vanishing ⟺ a **self-dual-extendable perfect code** of length `q` exists — finite by the
  perfect-code classification (a deep number-theoretic theorem, `{7,11,23}`).
- M3b vanishing ⟺ PSL₂(q) has an **exceptional small-index sheet** — the biplane / A₅-index sequence
  `{7,11,19}`.

Neither M2 nor M3a implies the other: `q=23` witnesses "code without census," and `{8,9,13,17,19}`
witness "census without code." Their meeting at `{7,11}` happens only because both need `q` small and
PSL₂(q) exceptional.

That common need **is** the previously "unexplained" `{7,11,19}` clustering the handoff flagged. It is
the **index/biplane sequence** — the one sub-gate every avatar brushes against, because a small
exceptional configuration requires a small exceptional symmetry group, and PSL₂(q) only has a
strikingly small transitive action at `q ∈ {7,11,19}` (Fano, regular 11-cell, 57-cell/Perkel). The
per-avatar filters then act on top of this shared substrate:

```
index / biplane substrate:   {7, 11, 19}       (every avatar needs a small exceptional group)
  ∩  self-dual-extendable perfect code (M3a): {7, 11}        = modular carrier
  ∩  arithmetic conic-fill Φ_deep (M1):       {11}           = Clebsch
deep-hole r=5 census (M2, its own axis):      {7,8,9,11,13,17,19}   (rides the substrate at 7,11,19; extends off it at 8,9,13,17)
```

So `{7,11,19}` is a **shared attractor, not a shared theorem**, and the avatars agree only where two
independent exceptional conditions happen to coincide.

## Consequences

- **Q1 (single defect identity across avatars): NO** as an equality of obstructions.
  `Φ_deep = (q−4)(q−11)` (arithmetic factorization) and `Φ_mod` (self-dual-extendable perfect code
  AND exceptional PSL₂ index) are structurally different obstructions with different `q`-sets and
  different reasons for finiteness. The "ambient capacity − legal locus = collisions + obstructions"
  identity is a *template each avatar instantiates*, not one obstruction shared across avatars.
- **Feeds C586.** The mechanism account C586 must produce is now pinned: **three distinct sporadicity
  mechanisms**, not one — arithmetic factorization (M1), S₃-monodromy census (M2), self-dual-perfect-
  code classification + PSL₂ index (M3) — plus the field-independent MDS-shortening for the uniform
  quantum avatar. C586 should not seek a single Φ.
- **Feeds C589.** Since the sporadic avatars are sporadic for genuinely different classified/census
  reasons, the "one defect identity" cannot be the headline theorem. This pushes C589 toward
  **program-identity / framing** for the sporadic side and **theorem** only for the uniform (quantum)
  side, unless C587's transport-category / first-order-transfer core (still open) can exhibit the
  three obstructions as shadows of one transport-natural obstruction — which this comparison gives no
  evidence for and one structural reason against (different finiteness types).

## Mystery ledger (post `ej`+`tt` closeout)

| Feature | Status after closeout | Evidence / owner |
|---------|-----------------------|------------------|
| Why `{7,11,19}` and not `{5,7,11,19,…}` | **settled** — exceptional-index PSL₂(q) trio; `q=5` is degenerate (PSL₂(5)≅A₅ itself) | brainstorm G16/G17; A₅<PSL₂(q) index |
| Is the `{7,11}` overlap forced? | **settled — no** (free coincidence via smallness attractor); separating witnesses `23` and `{8,9,13,17,19}` | this report's per-`q` table |
| Exact M3 perfect-code `q`-set | **settled** — `{7,11,23}` = self-dual-extendable perfect codes; a classification, not two examples | van Lint–Tietäväinen; extended `[8,4,4]/[12,6,6]/[24,12,8]` |
| Different *reasons* for finiteness across avatars | **settled** — soft orbit-count (M2) vs. deep classification (M3a) vs. arithmetic factorization (M1) | §"Why this is a coincidence" |
| Upper cutoff of the M2 census (nothing above 19 at `r=5`) | **deferred — `beyond4`-owned**, not a gateway mystery | `beyond4` Lemma S₃ (`q ≥ 23` generic) |
| Transport-natural obstruction unifying M1/M2/M3 as one shadow | **open** — no evidence for; one structural reason against (different finiteness types) | C587 §4 transport category / first-order transfer; owned by C589 gate |

No manufactured mystery: the genuine open item is the transport-category unification, correctly the
C589/first-order-transfer question, not a C585 gap.

## Extra juice — second-order closeout (2026-07-24)

The first-order closeout separated the mechanisms. Looking at the *structure* of the two exceptional
sequences yields more. Cross-checked against prior `crowns`-lane gateway work to avoid reinventing or
re-treading closed ground (`notes/2026-07-21-cocycle-gateway-novelty-consolidated.md`,
`notes/handoffs/2026-07-17-crowns.md`, `notes/2026-07-20-c437-c438-gateway-chain-spikes.md`).

**1. The `{7,11}` overlap is a two-tower intersection — *prior framing*, sharpened here.** The
"**code-tower `(7,11)` vs polytope-tower `(7,11,19)` divergence**" is already on record as a novelty
*falsifier* ("facts classical; the juxtaposition new as framing, not theorem" —
`cocycle-gateway-novelty-consolidated`, which also names the Galois/Kostant `L_2(5,7,11)` trinity vs
the Arnold–Coxeter trinity). C585 does **not** claim this framing. What C585 adds on top:

```
{7,11,23}   self-dual-extendable perfect codes   (extended [8,4,4],[12,6,6],[24,12,8]; Mathieu-adjacent)
  ∩ {index sheet available}   =  {7,11}   =  the C474 modular carrier.
```

i.e. the sharpening of the *code tower* to the classified trio `{7,11,23}` and the identification of
the modular carrier as `code-tower ∩ index-sheet`. Two provenance corrections the prior work forces:
the strict **A₅ / self-polar-conic tower is `{5,11,19}`** (Dye 1991; Storme–Van Maldeghem,
`q ≡ ±1 mod 10`), *not* `{7,11,19}` — `q=7` enters only via the Fano/biplane (PSL₂(7)≅PSL₃(2), `S₄`)
route, a different tower that happens to share `7,11`. And the code tower's top `q=23` is **carrier-
only**: its perfect-code *permutation* family was refuted (`crowns` C488), leaving exactly the C474
index-gate boundary this report derived. So "gateway = intersection of two exceptional towers" is a
*candidate organizing definition to float at the C589 gate*, credited to the two-tower framing — not
a C585 theorem.

**2. `(19, 23)` are the two complementary half-gateway witnesses.** The conjunction "perfect code AND
index sheet" fails in exactly two ways, each realized once at a tower top:

- `q = 19`: index sheet exists (57-cell), **no** self-dual-extendable perfect code → sheet-only.
- `q = 23`: binary Golay exists, **no** PSL₂(23) index sheet → code-only.

C587 called `q=23` "the diagnostic"; C585 upgrades it to a *diagnostic pair* `(19,23)` bracketing the
carriers `{7,11}`, one witness per failed half. Free, and concrete for the C589 exposition.

**3. The census contains the biplane sequence and adds exactly `{8,9,13,17}` — a cheap C586 check.**
`{7,11,19} ⊆ {7,8,9,11,13,17,19}`. Forced (every exceptional-index `q` lands in the S₃-census) or
accidental? Probably accidental — the extras are non-A₅ (`8≡3`, `13,17≡2 mod 5`; only `9≡−1 mod 5`
gives `A₅<A₆`) — but a *forced* containment would mean the deep-hole avatar carries the modular
**index** half everywhere, isolating the carry-failure entirely on the **perfect-code** half. One
finite scan for C586; either answer sharpens the verdict.

**4. A `q ≡ 3 (mod 4)` thread runs through the design-heavy avatars, not the raw census.** All of
`{7,11,19,23} ≡ 3 (mod 4)`; M1 (conic-fill) *requires* `q ≡ 3 (mod 4)`, and prior work has the same
congruence in the Klein-frame robust-rate crown ("`q ≥ 7, q ≡ 3 mod 4`", C358) and in the outer-
stabilizer being outer at `q=11` (`−1` nonsquare, `11≡3 mod 4`; `c498` review). The census strays
`{8,9,13,17}` are the only exceptions — consistent with M2 being the *loosest* avatar (soft bound,
fewest congruence constraints). Suggestive, not proven; a cheap congruence check for C586.

## Alt-attack routes (`aa`) to make the `{7,11}` overlap a theorem

The direct route — a transport-natural obstruction with vanishing set `{7,11}` unifying M2 and M3 —
is *doubly discouraged*: C585 shows different finiteness types, and `crowns` **C438 already closed**
the adjacent "one category-correct commuting square" for `q=9/q=11` ("no obstruction square survives;
Frobenius fusion lives on the wrong fibre"). Also dead, do not re-propose: the single metaplectic/
theta roof (C472/C489/C501, "theta parity dead as a bit detector"), the M₁₂-at-`q=11` enlargement
(C436, false), and the `q=23` perfect-code permutation family (C488, refuted). Live scaffolding to
build on instead: the one-torsor `[T_q]=sgn: PGL₂(q)→C₂`, the C434 double-coset information-lattice
transport theorem, the three functors (C486), and the based golden-pair groupoid (C492).

Ranked routes:

- **A — Flip the objective: prove the *separation* is a theorem (highest EV, provable now).** Instead
  of unifying M2 and M3, prove **no transport-natural map identifies `Φ_deep` with `Φ_mod`**, using
  C585's two separating witnesses (`23` = code without census; `{8,9,13,17}` = census without code):
  any natural map would equate their vanishing sets, which the witnesses forbid. This converts C585's
  coincidence verdict into a rigorous no-go, in the same family as the lane's clean C438/theta closes.
  Same objective, inverted I/O.
- **E — Settle the forced-vs-accidental containment (cheap, decisive either way; ej item 3).** One
  finite scan. Forced ⇒ a partial unification theorem ("deep-hole ⊇ index gate; perfect-code gate is
  the sole discriminant"). Accidental ⇒ reinforces Route A. Do first alongside A.
- **B — Narrow transport to the `q=11` fibre only.** Don't transport the whole family (that is what
  C438 killed); build the C434/C492 transport *only on the intersection object* at `q=11`, exhibiting
  the deep-hole sporadic orbit and the modular carrier as two forgetful images of the single
  A₅-decoration. C438 died because Frobenius fusion sat on the wrong fibre; at `q=11` in char 11 that
  fusion may not obstruct — worth one check. Same I/O as C438 restricted to the good fibre.
- **D — Model-theoretic complexity separation (the C589 first-order-transfer core, aimed at Route A).**
  Classify the obstructions by definitional complexity: M2 an orbit-count (`Δ₀`) condition, M3a a
  classification (`Π`) condition, M1 a polynomial-vanishing condition. Provably different quantifier
  complexity ⇒ a logic proof they cannot be one obstruction — a rigorous "different finiteness types."
  This is exactly C587 §4's open engine, here pointed at separation rather than unification.
- **C — Exponential-sum route (low EV, near a dead precedent).** Ask whether both `q`-sets are
  vanishing loci of one Gauss/Jacobi-sum identity. Must avoid the closed theta/Weil sign detectors;
  use ordinary Gauss-sum congruences only. Flagged low-EV given the dead metaplectic roof.

Recommendation: **A + E together** are the near-term move (both essentially provable/checkable now and
mutually reinforcing); **D** is the real prize but is the C589-gated first-order-transfer probe; **B**
is a targeted long shot; **C** is a backstop. None re-opens a closed idea. No IDs allocated — A/E/B
feed C586, D feeds the C589 gate.

## Provenance and reproducibility

This is a comparison of already-established finite `q`-sets, not a new census. No new computation is
introduced; every `q`-set is cited to its owning source (table above). The only C585-original content
is (i) the identification of the M3 perfect-code gate with the self-dual-extendable-perfect-code
classification `{7,11,23}`, and (ii) the per-`q` carry check and its coincidence verdict — both
derivations from the cited facts, requiring no replay bundle. Source papers, `beyond4`, and the C474
note remain read-only.

**Vibe check.** Clean, decisive, better than a bare "coincidence" verdict: the comparison didn't just
separate the two `q`-sets, it identified *why* they touch (shared PSL₂(q)-smallness substrate) and
*why* they diverge (three unrelated finiteness types), and it sharpened the modular gate into a named
classification. That is real forward motion for C586 and C589, and it kills the tempting but wrong
"one Φ across avatars" story cheaply.
