# C72 — Johnson-scheme / PGL permutation-module decomposition of the on-conic value f_q

**2026-07-10 (Codex).** A5-lane concentration instrument. Tests whether the on-conic value
function `f_q` carries a **harmonic / design identity** that forces the link sums
`onP(A) = Σ_{x∉A} f_q(A∪{x})` (the `W_{5,6} f_q` vector) to be near-constant — the §6
class-stability target. **Scope guard (enforced):** this is a concentration instrument, NOT a
config→value dictionary. It does not predict individual P/N labels (the C55/C64/C69 failure mode);
Cluster 1 stays closed.

Script: [`rust/scripts/c72_fq_decomposition.py`](../rust/scripts/c72_fq_decomposition.py).
Raw outputs: `rust/s4-dumps/2026-07-10/c72/c72-run.out`, `c72-selftest.out`. Single-core, ~10 s,
RSS well under 2 GB (pure-stdlib Python; peak structure ≈ C(20,6)=38,760 tuples). The running
`gridcap-arena s4arena 25` census (PID 1736515) was not touched.

## Verdict headline

**Read (b): no design identity forces near-constant link sums.** At the depleted orders the value
function's spectral mass sits in the **top** Johnson components (j ≥ 4), never the low ones, and it
**migrates UP** with q — the top component `V_6` carries 7.9% at q=11 but **72.6% at q=17**. The
flip/control test fails decisively for any "low-component concentration" reading. The concentration
of `onP` seen in §6 is not spectrally forced; it is arithmetic (arc-depletion), consistent with the
C42 negative.

The one genuine q-uniform harmonic fact extracted for A5 is a **partial** identity, not a forcing
one: PGL(2,q) 3-transitivity makes `f_q ⊥ V_1 ⊕ V_2 ⊕ V_3` for **every** q, so `onP`'s variance
never sees the three highest-leverage nonconstant levels. But the residual dispersion lives in
`V_4 ⊕ V_5`, whose mass is arithmetic and bounded by no identity, and `f_q`'s bulk sits in the
link-invisible top `V_6`. A5 must still supply the `V_4 ⊕ V_5` bound; the harmonic structure only
removes the easy part.

## 1. Object, method, and the linear-algebra core

The conic is `P¹(F_q)`, `n = q+1` points (integer `q` = the `∞` sentinel). An on-conic S4 state is a
6-subset `B` of `P¹(F_q)`; by the C53 full-PGL bridge the game value is constant on PGL(2,q)-orbits
of 6-subsets, so `f_q(B) = 1` iff `B` is P. The 6-subset space `M_6 = R^{C(n,6)}` is an `S_n`-module
splitting into Johnson-scheme eigenspaces `M_6 = V_0 ⊕ V_1 ⊕ … ⊕ V_6`, with `V_j` the Specht module
`S^{(n-j, j)}` and `dim V_j = C(n,j) − C(n,j−1)`.

**Spectral mass without a large matrix.** Let `W_i` be the (i-subset × 6-subset) inclusion matrix and
`g_i = W_i f` the down-projection `g_i(T) = #{P 6-subsets B : T ⊆ B}`. `W_i` intertwines `S_n`, and
`W_i^T W_i` has eigenvalue `λ_{i,j} = C(n−i−j, 6−i)·C(6−j, i−j)` on `V_j` (`0 ≤ j ≤ i`; else 0).
With `S_i = ‖g_i‖² = Σ_T g_i(T)²` and `m_j = ‖P_{V_j} f‖²`:

```text
S_i = Σ_{j=0}^{i} λ_{i,j} · m_j        (lower-triangular, positive diagonal)
```

solved forward for `m_0..m_6`. No `C(n,6)×C(n,6)` matrix is ever formed. Exact cross-checks (all
asserted in-code): `m_0 = (#P)²/C(n,6)`, `Σ_j m_j = S_6 = #P`, and `onP = W_{5,6} f = g_5` so
`Var(onP) = Σ_{j≥1} λ_{5,j} m_j / C(n,5)`.

**Self-test (linear-algebra core, verbatim).** The `λ_{i,j}` eigenvalue formula and the
triangular solve are validated against an independent exact projection: build `W_i` explicitly and
compute `c_i = (W_i f)^T (W_i W_i^T)^{-1} (W_i f)` over `Fraction`, `m_j = c_j − c_{j−1}`, on a
non-constant pseudo-random `f`:

```text
$ python3 scripts/c72_fq_decomposition.py --selftest
SELFTEST: triangular-solve masses vs explicit inclusion-matrix projection (exact)
  n=7 k=3: mA=[2.8571, 1.5429, 2.9333, 2.6667]
           mB=[2.8571, 1.5429, 2.9333, 2.6667]  match=True
  n=8 k=3: mA=[4.5714, 1.4667, 3.2619, 6.7]
           mB=[4.5714, 1.4667, 3.2619, 6.7]  match=True
  n=9 k=4: mA=[8.127, 1.3587, 4.2857, 10.0952, 8.1333]
           mB=[8.127, 1.3587, 4.2857, 10.0952, 8.1333]  match=True
  n=10 k=4: mA=[14.4048, 1.0714, 4.7, 20.0952, 14.7286]
           mB=[14.4048, 1.0714, 4.7, 20.0952, 14.7286]  match=True
SELFTEST PASS
```

## 2. Anchors and cross-checks (all pass)

**(a) `f_q` built from exact labels; bucket fibers reproduce `s4arena` byte-for-byte.** Each bucket
rep `[t1,t2,t3,t4]` gives the 6-subset `{∞,0,t1,t2,t3,t4}`; its full-PGL orbit is generated and every
6-subset of `P¹(F_q)` is labeled. The recomputed fiber over the fixed burned pair `{0,∞}` (6-subsets
in the orbit containing both) equals the exact-solver `size` for **every** bucket at **every** q, and
the orbit sizes partition `C(q+1,6)`:

```text
q=11  #P 6-subsets = 594 / 924    fiber-match all 4 buckets: True
q=13  #P 6-subsets = 3003 / 3003  fiber-match all 5 buckets: True
q=17  #P 6-subsets = 3876 / 18564 fiber-match all 10 buckets: True
q=19  #P 6-subsets = 38760/38760  fiber-match all 13 buckets: True
```

The over-all-6-subsets `ν(q)` (fraction N) reproduces C68b exactly: `0.3571` (q=11), `0` (q=13),
`0.7912` (q=17), `0` (q=19). The recomputed orbit sizes also independently confirm the round-one
**fiber–stabilizer identity** `fiber(B) = 30(q−1)/|Stab_PGL(B)|`
([`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md) §B) for
every bucket at every q (`|Stab| = |PGL|/orbit_size`, asserted in-code — see §4b).

**(b) `onP = g_5` value set + min-witness reproduce C68b.** Grouping game frames `{∞,0,t1,t2,t3}` by
full-PGL orbit (0 within-orbit onP violations at every q):

```text
q   onP value set (PGL frame-orbits)   C68b onP-types (grid size-3 classes)   value-set  min-wit
11  {2:1, 5:1}                         {2:2, 5:6}                             match       2 = 2
13  {9:3}                              {9:12}                                 match       9 = 9
17  {1:1, 3:3}                         {1:3, 3:18}                            match       1 = 1
19  {15:5}                             {15:27}                                match      15 = 15
```

The onP **value set** and **min-witness** match C68b. The class *counts* differ only because a full-PGL
frame-orbit (there are `orb_5 = 2,3,4,5` of them) is **coarser** than a C68b grid size-3 class (grid
symmetry fixes the burned pair, so those are stabilizer orbits). The min-witness `onP≥1` and the q=17
knife edge (`min onP = 1`) are reproduced.

## 3. Spectral mass per q (the deliverable)

`m_j = ‖P_{V_j} f_q‖²`, `Σ_j m_j = #P`, share `= m_j / #P`. Verbatim:

```text
        q=11 (#P=594)              q=13 (#P=3003)            q=17 (#P=3876)            q=19 (#P=38760)
 j  dim V_j   m_j/#P          dim V_j  m_j/#P            dim V_j  m_j/#P            dim V_j  m_j/#P
 0    1      0.642857           1     1.000000             1     0.208791             1     1.000000
 1   11      0.000000          13     0.000000            17     0.000000            19     0.000000
 2   54      0.000000          77     0.000000           135     0.000000           170     0.000000
 3  154      0.000000         273     0.000000           663     0.000000           950     0.000000
 4  275      0.277778         637     0.000000          2244     0.056140          3705     0.000000
 5  297      0.000000        1001     0.000000          5508     0.009023         10659     0.000000
 6  132      0.079365        1001     0.000000          9996     0.726046         23256     0.000000
```

Width-aligned share table (the object of interest):

```text
  component        q=11        q=13        q=17        q=19
  ----------  ----------  ----------  ----------  ----------
  V_0 share     0.642857    1.000000    0.208791    1.000000
  V_1 share     0.000000    0.000000    0.000000    0.000000
  V_2 share     0.000000    0.000000    0.000000    0.000000
  V_3 share     0.000000    0.000000    0.000000    0.000000
  V_4 share     0.277778    0.000000    0.056140    0.000000
  V_5 share     0.000000    0.000000    0.009023    0.000000
  V_6 share     0.079365    0.000000    0.726046    0.000000
  ----------  ----------  ----------  ----------  ----------
  hi j>=4       0.357143    0.000000    0.791209    0.000000
  top V_6       0.079365    0.000000    0.726046    0.000000
```

Two exact identities fall out (both verified against the table):

- **`V_0 share = 1 − ν(q)`.** Since `#P = (1−ν)C(n,6)` and `m_0 = (#P)²/C(n,6)`, the constant-component
  share is `m_0/#P = 1 − ν`. Check: `0.642857 = 1 − 0.3571` (q=11), `0.208791 = 1 − 0.7912` (q=17).
- **All non-`V_0` mass sits in `j ≥ 4`, and its total share is exactly `ν(q)`.** Because `V_1,V_2,V_3`
  carry zero mass (next item), `hi j≥4 share = 1 − V_0 share = ν(q)`. Check: `0.357143` (q=11),
  `0.791209` (q=17).

## 4. PGL(2,q) permutation-module refinement (the 3-transitivity floor)

`f_q` is PGL(2,q)-invariant, so it lives in the PGL-fixed subspace of `M_6`. Its intersection with each
Johnson component is `dim(V_j^{PGL}) = orb_j − orb_{j−1}`, where `orb_i = #`PGL-orbits on i-subsets
(Burnside; `orb_6 = #buckets`, asserted):

```text
q    orb_0..orb_6            dim V_j^PGL  (j=0..6)     first nonconstant invariant   #buckets
11   [1,1,1,1,2,2,4]         [1,0,0,0,1,0,2]           V_4                           4
13   [1,1,1,1,3,3,5]         [1,0,0,0,2,0,2]           V_4                           5
17   [1,1,1,1,3,4,10]        [1,0,0,0,2,1,6]           V_4                           10
19   [1,1,1,1,4,5,13]        [1,0,0,0,3,1,8]           V_4                           13
```

`orb_0 = orb_1 = orb_2 = orb_3 = 1` at **every** q — this is PGL(2,q) 3-transitivity on `P¹` (transitive
on i-subsets for `i ≤ 3`). Consequences, uniform in q:

- **`dim V_1^{PGL} = dim V_2^{PGL} = dim V_3^{PGL} = 0`.** Any PGL-invariant function on 6-subsets —
  in particular every `f_q` — has **identically zero** projection onto `V_1 ⊕ V_2 ⊕ V_3`. This is an
  exact q-uniform harmonic identity.
- **The first nonconstant PGL-invariant component is `V_4`** at every order, and the bulk of the invariant
  dimension (hence of the buckets) is in the **top** component `V_6` (`dim V_6^{PGL} = 2,2,6,8`). So the
  PGL-fixed subspace itself has no low-degree room: `f_q` is a combination of the constant, a little
  `V_4/V_5`, and a lot of `V_6`.

## 4b. Cross-links to the round-one counting identities

A parallel round ([`2026-07-10-codex-odd-plane-round1-report.md`](2026-07-10-codex-odd-plane-round1-report.md))
proved two facts that sit directly under this decomposition; both are folded in and independently
re-derived here.

**(1) Fiber–stabilizer identity [PROVED, round1 §B] — confirmed.** `fiber(B) = 30(q−1)/|Stab_PGL(B)|`.
My orbit generation gives `|Stab| = |PGL|/orbit_size`; the identity `30(q−1)/|Stab|` reproduces the
exact-solver fiber for every bucket at every q (asserted). The per-bucket stabilizer orders (verbatim):

```text
q=11  N: |Stab|=4 (V4)       P: |Stab|=5, 6, 12
q=17  N: |Stab| in {1, 2}    P: |Stab| in {4, 6, 12, 24}
q=13  all P: |Stab|=2,4,2,12,24              q=19  all P: |Stab| in {1, 2, 4, 6, 12}
```

This makes the C68b within-q genericity split ("P = small-fiber = higher-symmetry, N = large-fiber =
lower-symmetry") an **exact** counting statement, uniform in q — small fiber *is* large stabilizer.
And it locates my spectral objects inside proven counting: since `orbit_size = fiber·q(q+1)/30`, the
orbit-size weights that enter every mass `m_j` are fixed by the identity — `m_j` is a quadratic form
in the P/N bucket labels with weights the identity pins down, not a free parameter.

**(2) Naive value bridge [REFUTED, round1 §D] — consistent with, and dual to, read (b).** Round1
refutes "nontrivial stabilizer / fpf-involution / V4 / order ≥ 4 ⇒ P": the q=11 N bucket
`{∞,0,1,2,3,4}` has stabilizer `V4` (order 4) yet is N. My table shows exactly why there is no
q-uniform threshold in either direction:

- q=17 has a clean gap (`N |Stab| ≤ 2 < 4 ≤ P |Stab|`), but the q=11 N bucket sits at `|Stab| = 4`,
  squarely inside q=17's *P* range — so "large stabilizer ⇒ P" fails across q.
- Conversely, the trivial stabilizer `|Stab| = 1` is **N** at q=17 but **P** at q=19 (q=19 is all-P) —
  so "trivial stabilizer ⇒ N" also fails across q.

Stabilizer order fixes value at neither end. This is the **same fact my spectral read reports in dual
language**: `f_q`'s mass concentrates in the *top* Johnson component `V_6` (a high-degree/generic
function), not in low-degree/high-symmetry structure, and does so *more* as q grows. A "special ⇒ P"
(low-symmetry-complexity) rule is refuted on the config side and finds no low-degree harmonic identity
on the spectral side.

To be clear about scope: this instrument does **not** surface any "special ⇒ P" read — that is the
closed config-dictionary / C68b-genericity angle, not this task — so there is no conflict with the
refutation. Where the two meet, they agree: the value function is high-complexity, and the stabilizer
strata (proven fiber identity) are the counting basis under both.

## 5. The link operator `onP = W_{5,6} f_q` and its variance decomposition

`onP = g_5`. `W_{5,6}: M_6 → M_5` **annihilates `V_6`** for any function (V_6 has no image in `M_5`).
So the 72.6% of `f_q`'s mass in `V_6` at q=17 is invisible to `onP`; its variance is fed only by the
`V_1..V_5` components — and `V_1,V_2,V_3 ≡ 0` — leaving `V_4, V_5`:

```text
q=11: onP hist {2:132, 5:660}  mean 4.5000  var 1.2500  std 1.1180
      Var contributions: j=4 -> 1.250000 ;  j=5 -> 0 ;  (j=1,2,3 -> 0)
q=17: onP hist {1:1224, 3:7344} mean 2.7143  var 0.4898  std 0.6999
      Var contributions: j=4 -> 0.457143 ; j=5 -> 0.032653 ;  (j=1,2,3 -> 0)
q=13: onP hist {9:2002}   mean 9  var 0   (all-P control)
q=19: onP hist {15:15504} mean 15 var 0   (all-P control)
```

`Var(onP) = (λ_{5,4} m_4 + λ_{5,5} m_5)/C(n,5)` exactly (asserted to machine precision). The §6
"near-point-mass" is reproduced: at each depleted order `onP` takes only **two** distinct values,
tightly around the mean (Fano factor `var/mean = 0.278` at q=11, `0.181` at q=17; std/mean `0.25`,
`0.26` — both ≤ 0.4, matching the §6 dispersion claim).

**Which components carry the depletion dips.** The dip in `onP` (values below the mode: `onP=2` vs mode
`5` at q=11; `onP=1` vs mode `3` at q=17 — the min-witness edge) is carried **entirely by `V_4` at
q=11 and by `V_4` + `V_5` at q=17** (the only nonzero variance-feeding components). The dominant `V_6`
mass does not participate — it is the part of `f_q` the link operator cannot see.

## 6. Flip / control verdict (mandatory)

```text
  component        q=11(dep)   q=17(dep)   |   q=13(full)   q=19(full)
  ----------      ----------  ----------  |  ----------    ----------
  V_0 share         0.642857    0.208791  |    1.000000      1.000000
  hi j>=4 share     0.357143    0.791209  |    0.000000      0.000000
  top V_6 share     0.079365    0.726046  |    0.000000      0.000000
```

- **Controls {13,19}:** `ν=0`, so `f_q ≡ 1` — trivially 100% in `V_0`. This is the degenerate baseline
  (no N state exists to spread mass), not evidence of a design identity.
- **Depleted {11,17} do NOT share a spectral signature.** A "concentration in low components" reading
  would need the non-`V_0` mass to sit low and stably. Instead the mass is **forbidden** from `V_1,V_2,V_3`
  and lands in `V_4..V_6`, with the **top** component `V_6` jumping from **7.9% (q=11) to 72.6% (q=17)**
  — an order of magnitude, and now the dominant component. The mass migrates UP with q; `V_0` share
  collapses `0.64 → 0.21`. Per the C64/C69 lesson (both prior near-hits were q=11 artifacts that dissolved
  at q=17), any low-component concentration suggested at q=11 is **refuted** at q=17. `f_q` becomes MORE
  high-degree (more generic, less design-like) as q grows.

## 7. Route verdict

- **Read: (b) — no harmonic identity forces near-constant link sums.** The design/concentration angle for
  the §6 class-stability target is **closed negative**. `f_q` is not a low-degree function whose link
  sums are forced flat; at the depleted orders it is dominated by the *top* Johnson component `V_6`, and
  the domination grows with q. The empirical near-constancy of `onP` is an artifact of the link operator
  discarding that top-component mass, not of `f_q` being harmonic. This corroborates C42 (the
  concentration is arc-depletion-driven, not a q-uniform design/type invariant) from the spectral side.

- **The one gift for A5 (a partial, not a forcing, identity).** PGL(2,q) 3-transitivity gives the exact
  q-uniform fact `f_q ⊥ V_1 ⊕ V_2 ⊕ V_3`. In link-operator terms it kills the **three highest-leverage**
  variance terms (`λ_{5,1},λ_{5,2},λ_{5,3}` are the largest multipliers), so:

  ```text
  Var(onP) = ( λ_{5,4}·m_4 + λ_{5,5}·m_5 ) / C(q+1,5)
  ```

  with **no `j=1,2,3` contribution, ever**. This reduces the §6 class-stability lemma to a clean,
  finite target: **bound the `V_4 ⊕ V_5` spectral mass of `f_q` from above** (the `V_6` mass is
  link-invisible and does not need bounding). But that residual mass is exactly the arithmetic
  (arc-depletion) quantity — it is not itself forced small by any identity found here (at q=11
  `m_4/#P = 0.278` is not small; it is the small `λ_{5,4}=6` weight that keeps the variance down). So A5
  still owns the hard step: prove the extremal class-type's `V_4 ⊕ V_5` contribution stays below the
  min-witness edge as `ν(q)` climbs. The Johnson analysis does not hand A5 the anchor `maxonN(q) ≤ q−5`;
  it hands A5 a sharper coordinate to prove it in (the `V_4 ⊕ V_5` mass), and rules out the shortcut of a
  low-degree design identity.

- **Re-entry / next.** This angle needs no re-run. If the q=25 census lands depleted, re-running the
  script at q=25 (`python3 scripts/c72_fq_decomposition.py 25`, after dropping the bucket file into
  `notes/data/c68b-onconic-buckets-q25.txt`) will test whether the `V_6`-domination trend continues and
  whether the `V_4 ⊕ V_5` mass stays link-suppressed — the only spectral datum that would move this verdict.

## 8. Reproduce

```bash
cd rust
python3 scripts/c72_fq_decomposition.py --selftest     # linear-algebra core validation
python3 scripts/c72_fq_decomposition.py                # q = 11, 13, 17, 19
python3 scripts/c72_fq_decomposition.py 11 17          # any subset
```

Inputs are the on-disk exact bucket labels `notes/data/c68b-onconic-buckets-q{11,13,17,19}.txt`
(`s4arena --all`, validated byte-identical to FnvMap + C54). All PGL machinery (`mobius`, `pgl_maps`,
`canon`) is the C5/C15-validated code from `notes/2026-07-07-pgl2-orbit-census.py`; the bucket
fiber-match cross-check confirms it against the exact solver's own bucketing at every q.
