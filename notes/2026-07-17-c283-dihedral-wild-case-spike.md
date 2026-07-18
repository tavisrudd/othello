# C283 — Wild-case (`p | 2m`) scoping spike for the dihedral Schreier Node-Kayles paper

**Lane**: `dihedral` (task C283)
**Date**: 2026-07-17
**Manuscript**: `notes/2026-07-12-dihedral-schreier-node-kayles-submission.md` (Discussion is §15)
**Report**: this file. **Evidence bundle**: `2026-07-17-c283-dihedral-wild-case-spike.{rs,json,sha256}`.

**No classification is claimed.** This is a time-boxed scoping spike: it computes the wild residual
examples the manuscript excludes, identifies exactly what breaks relative to the tame case, proposes
one §15 remark with a displayed example, and reports a feasibility frontier. It does not edit the
manuscript and does not attempt a wild classification.

---

## 1. What "wild" means here

The manuscript assumes **tame**: `p = char F_q` does not divide the order `2m` of the dihedral
subgroup under consideration (§1, lines 63–68; §14 header, line 1066). Since `q` is odd, `p` is odd,
so `p | 2m ⇔ p | m`. The wild case is therefore `p | m`.

The spike enumerates, over `q = p ∈ {3, 5, 7, 11, 13}` (odd prime fields), **all** legal pairs of
off-conic points `{x, y}` whose induced involutions `σ_x, σ_y ∈ PGL₂(p)` have a product
`r = σ_xσ_y` of order `m` with `p | m`, and records the full fixed-point / orbit / residual
structure of each. Exact searched domain: every unordered involution pair over these five fields
(22,968 pairs total; 1,992 of them wild). The residual is the same fixed-point-deleted Schreier
graph `R_S` of §2–§3.

## 2. What breaks, precisely (all machine-confirmed over the searched domain)

The single controlling fact is an embedding obstruction:

> **A cyclic subgroup of `PGL₂(q)` whose order is divisible by `p` has order exactly `p`.**
> Elements of `PGL₂(q)` are either semisimple (order dividing `q∓1`, coprime to `p`) or unipotent
> (a transvection, order exactly `p`); there is no element of order `p·d` with `d > 1` acting on
> `P¹`. Hence the rotation `r = σ_xσ_y` cannot have order `2p`, `3p`, … — only `p`.

Consequences, each verified on all 1,992 wild pairs (histograms in the JSON):

1. **`m = p` is forced.** Every wild pair has `m = p` (`wild_pairs_with_m_neq_p = 0`). The only wild
   dihedral group is `D_{2p}`, in which the rotation is a **unipotent** element (transvection) of
   order `p`. Wild `D₆, D₁₀, D₁₄, D₂₂, D₂₆, …` are exactly `D_{2p}` for `p = 3, 5, 7, 11, 13`.

2. **The rotation has one fixed point, not zero or two.** In the tame case `r` is semisimple and its
   `P¹`-fixed points are the torus pair (2 rational points, split) or an inert pair (0 rational,
   nonsplit). Wild: `|Fix(r)| = 1` on **every** pair (`rotation_fixed_point_count_histogram = {1:
   1992}`). A unipotent has a single fixed point.

3. **The deleted set has odd size 1.** `D_S = Fix(σ_xσ_y) = Fix(r)` is a single point on every wild
   pair (`deleted_set_size_histogram = {1: 1992}`). This breaks the tame even-deletion pattern: in
   §14 the rotation cosets are deleted **in pairs** (Prop 6.2 / Thm 14.1, `R(D_{2m},⟨r⟩,T)=∅` is a
   two-point orbit), and the reflection fixed points that survive are paired by the torus/central
   structure. The lone wild deleted point is not part of any such pair.

4. **The group is reducible — it has a global fixed point.** The wild `D_{2p}` fixes exactly one
   point of `P¹` (`wild_pairs_global_fix_neq_1 = 0`): it lies in a **Borel subgroup** (the
   stabiliser of the unipotent axis). Both reflections and the rotation share that point. The tame
   dihedral action is irreducible on `P¹` (no global fixed point); the wild action is not. This is
   the structural collapse — "dihedral rotation ≈ regular rotor" is exactly what fails.

5. **Both reflections are automatically split.** Each reflection fixes the rational global point, so
   it has a rational fixed point and is split (`|Fix(σ_x)| = |Fix(σ_y)| = 2` on every wild pair).
   The nonsplit reflection class — which drives the tame parity `δ = 1_{2m | q∓1}` of Thm 14.4 —
   **cannot occur** in a wild pair. The tame reflection-parity dichotomy therefore has no wild
   analogue: there is only one reflection geometry.

6. **The orbit shapes collapse to `{size p, size 1}`.** The `G`-action on `P¹` (`p+1` points) has
   orbits of sizes `[p, 1]` with stabiliser orders `[2, 2p]` on every wild pair. There is **no free
   (regular) orbit** of size `2p`, hence **no cycle template `C_{2p}`** (Thm 14.1's free row is
   empty). There is one orbit of size `p` and stabiliser `2` (a "reflection-type" orbit) plus the
   deleted global fixed point.

7. **The residual is a single path `P_p`, and the paper's headline P-position result fails.** The
   fixed-point-deleted residual `R_S` is, on **every** wild pair, one connected path on `p` vertices
   (`wild_pairs_residual_not_single_path_P_p = 0`; two degree-1 ends, the rest degree 2), with
   Node-Kayles value `NK(R_S) = NK(P_p) = A002187(p)` (Dawson's chess), matching directly on all
   pairs (`wild_pairs_NK_neq_dawson_p = 0`).

   The template `P_p` is the *same shape* the tame theory attaches to a reflection orbit (`P_m`), so
   the path/Dawson byproduct survives in a degenerate way. But the **classification conclusion does
   not**. Manuscript Thm 14.4 / Cor 14.5 state that for **odd** `m` the tame dihedral game is
   **always a P-position** (`𝒢 = 0`). Wildly, `m = p` is odd, yet `NK(R_S) = A002187(p)` which is
   **nonzero** for `p ∈ {3, 5, 11, 13}` (values `2, 3, 2, 4`) and zero only when `p` is a Dawson
   zero (`p = 7` gives `NK = 1`; among primes, `A002187(p) = 0` never happens for these `p`). So the
   tame "odd order ⇒ P" law is exactly what the wild case violates: wild `D_{2p}` is generically an
   N-position.

**Summary of the tame→wild break.**

| Feature                     | Tame `D_{2m}` (pair, §14)                    | Wild `D_{2p}` (`p \| m`, this spike)        |
|-----------------------------|---------------------------------------------|---------------------------------------------|
| admissible `m`              | every `m ≥ 3`, both parities                 | `m = p` only (forced)                       |
| rotation `r = σ_xσ_y`       | semisimple, `|Fix| ∈ {0, 2}`                 | unipotent, `|Fix| = 1`                      |
| action on `P¹`              | irreducible, no global fixed point           | reducible, one global fixed point (Borel)   |
| deleted set `D_S`           | even (rotation cosets deleted in a pair)     | odd, a single point                         |
| reflection classes          | 1 (odd `m`) or 2 (even `m`), split/nonsplit  | 1, always split (fixes the rational axis)   |
| orbit sizes / stabilisers   | `{2m:1, m:2, …}` incl. free orbits           | `{p, 1}` / `{2, 2p}`, no free orbit         |
| free-orbit template         | cycle `C_{2m}`                               | absent                                       |
| residual `R_S`              | `⊔` of `C_{2m}`, `P_m`, `∅` by orbit         | one path `P_p`                              |
| odd-order value law         | odd `m` ⇒ **P-position** (`𝒢 = 0`)           | `𝒢 = A002187(p)`, generically **N-position**|

**Triples cannot be wild.** A legal *triple* generates `D_{4n}` and requires the central involution
`z = rⁿ` (§4, lines 313–316). A wild rotation is unipotent of odd order `p`, which has no order-2
power, so no central involution exists and no legal wild triple can form. The wild phenomenon is
confined to the two-selected-point family, and there to `D_{2p}` alone.

## 3. Proposed §15 remark (ready to paste; coordinator applies)

> **Remark 15.x (the wild case `p \mid 2m`).** Every result above assumes the tame hypothesis
> `p \nmid 2m`. When `p \mid 2m` — equivalently, since `q` is odd, `p \mid m` — the classification
> changes character completely, and for a single structural reason. A cyclic subgroup of
> \(PGL_2(q)\) whose order is divisible by `p` has order exactly `p`, because a nonsemisimple
> element of \(PGL_2(q)\) is unipotent of order `p`. Hence the rotation `r=\sigma_x\sigma_y` can
> never have order `2p, 3p,\dots`; the only wild dihedral group that arises is \(D_{2p}\), with `r`
> a transvection. Three consequences follow. First, `r` has a **single** fixed point on
> \(\mathbf P^1(q)\) instead of the tame `0` or `2`, so the deleted set \(D_S=\operatorname{Fix}(r)\)
> is a single point and the even orbit-deletion pattern of Section 14 fails. Second, that fixed
> point is fixed by the **whole** group: \(D_{2p}\) lies in a Borel subgroup and acts **reducibly**
> on \(\mathbf P^1(q)\), so there is no regular orbit and no cycle template \(C_{2p}\); the action
> splits into the deleted fixed point and one orbit of size `p` with stabiliser of order `2`. The
> residual is therefore a single path,
> \[
> R_S \;\cong\; P_p, \qquad \mathcal G(R_S)=\mathcal G(P_p)=A002187(p)\ \text{(Dawson's chess)}.
> \]
> Third, because `m=p` is odd, this directly contradicts the tame law that odd-order dihedral games
> are `P`-positions (Theorem 14.4): the wild game \(D_{2p}\) is generically an `N`-position. For
> example, the smallest odd nontrivial case `p=5` gives \(D_{10}\) with `r` unipotent, `D_S` a single
> point, residual `P_5`, and \(\mathcal G = A002187(5) = 3\neq 0\) — an `N`-position, whereas every
> tame \(D_{10}\) is a `P`-position. Legal triples cannot be wild at all: a wild rotation is unipotent
> of odd order and has no central involution, so no legal generating triple exists. A full wild
> classification is left open.

*(Displayed example above uses `p = 5`. To use `p = 3`: `D₆`, residual `P₃`, `𝒢 = A002187(3) = 2`.
The JSON `representatives` array carries the exact structure for `p = 3, 5, 7, 11, 13`.)*

## 4. Feasibility frontier for a future wild classification

- **Tractable / essentially done here.** The wild *pair* case is a finite, fully-determined
  phenomenon: `D_{2p}` only, residual always `P_p`, value always `A002187(p)`. A proof-quality
  statement needs only (i) the standard `PGL₂(q)` element-order fact (unipotent ⇒ order `p`), (ii)
  the Borel-reducibility observation, and (iii) the existing `P_p`/Dawson template already in §14.2.
  This is a short lemma, not a research programme; the spike gives the full structure and a machine
  check over `p ∈ {3,…,13}`. Realizability over infinitely many `q` (Dirichlet-style, as in Thm
  14.6) is plausible but not checked here.

- **What a wild pair classification does *not* need.** No new template graphs (only `P_p`), no new
  nimber sequence, no torus/parity split (reflections are always split). The tame density machinery
  (§12, §15) does not transfer: there is no `½`, only the single value `A002187(p)`.

- **Genuinely open / harder.** (a) A clean *density* statement across primes `p` (how often
  `A002187(p) = 0`, i.e. `p` a Dawson-zero index) is a question about the Dawson sequence on primes,
  outside this framework. (b) The wild behaviour of the **larger residuals** the manuscript already
  defers in §15 — full `PSL₂(q)`/`PGL₂(q)` and the polyhedral coset templates — is untouched and
  looks hard: there the unipotent/Borel structure interacts with much larger orbit sets and is not a
  finite table. (c) Prime-power fields `q = p^k` were not enumerated (this spike uses prime fields);
  the element-order argument predicts `m = p` still forces `D_{2p}`, but that is a prediction, not a
  checked claim.

- **Not attempted (out of scope, per task).** No wild classification theorem, no manuscript edit, no
  Lean, no `PSL/PGL` or polyhedral wild analysis.

## 5. Reproduce / verify

Working directory: `notes/`. Deterministic output, no timestamps.

```
cd notes
rustc -O 2026-07-17-c283-dihedral-wild-case-spike.rs -o /tmp/c283bin
/tmp/c283bin 2026-07-17-c283-dihedral-wild-case-spike.json 3 5 7 11 13
sha256sum -c 2026-07-17-c283-dihedral-wild-case-spike.sha256
```

**What the checker certifies** over `q = p ∈ {3,5,7,11,13}` (all 22,968 pairs; 1,992 wild):
`m = p` on every wild pair; group order `2p`; `|Fix(r)| = 1` and `|D_S| = 1`; whole-group fixed
points `= 1`; both reflections split (`|Fix| = 2`); orbit sizes `{p, 1}` with stabilisers `{2, 2p}`;
residual a single path `P_p`; and `NK(R_S) = A002187(p)` computed directly — all six mismatch
counters are `0`. The Grundy core is the memoised component Sprague–Grundy routine shared with
`rust/scripts/nodekayles_cayley.rs` and the C263 pair-template script; trust boundary is that
routine (no external solver). **What it does not certify**: any `q` outside `{3,5,7,11,13}`, any
prime-power (non-prime) field, `p ∤ m` (tame, covered by C263), or any non-dihedral / larger-image
residual. It is not a classification.

## 6. Vibe check

Better than a spike had any right to be. The wild case looked like it might be a messy open-ended
mess of degenerate graphs; instead it collapses to a single crisp phenomenon — `p | m` forces
`D_{2p}` with a unipotent rotor, a Borel-reducible action, one deleted point, and residual `P_p` —
provable from one standard `PGL₂` element-order fact. The sharpest headline is that it *breaks the
paper's own "odd order ⇒ P-position" law* (wild `D_{10}` is an N-position at `𝒢 = 3`), which makes
the §15 remark worth including rather than a throwaway. Feasibility verdict: a full wild *pair*
classification is a short lemma, easily in reach if the coordinator wants it promoted; the wild
`PSL/PGL`/polyhedral residuals remain the genuinely hard deferred frontier and this spike says
nothing new about them.
