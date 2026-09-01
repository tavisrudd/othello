# C1029 — parametric certificate instrument test (Erdős–Straus unit fractions)

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-08-31
**Status**: COMPLETE. Bundle committed; independent checker accepts; all ten deliberately broken
certificates rejected.

**What this task is for.** The certificate machinery is the deliverable. The repository can
currently certify a witness ("here is the object") or a symmetry-reduced exhaustion ("no object
exists in this finite domain"). It had never emitted a *parametric* certificate: a finite set of
polynomial identities that discharges infinitely many cases, composed with a finite witness list
for the residual cases, plus a composition rule making the two together a complete claim over a
stated range. This task builds that format, a generator, and an independent checker, on the
vehicle chosen in `notes/2026-08-31-ergodis-instrument-test-targets.md` §6.

---

## 1. Ground truth (literature gate) — completed before any construction

Fetched 2026-08-31; the slate's recall-level claims were checked against sources rather than
assumed.

| Claim under test | Verdict | Source, read depth |
|---|---|---|
| Verified range ≈ `10¹⁷` (slate, recall-level) | **Stale.** Salez 2014 reached `10¹⁷`; the current published range is `10¹⁸`. | Salez, "The Erdős–Straus conjecture: new modular equations and checking up to N = 10¹⁷", arXiv:1406.6307 — abstract plus search-result summary. Current record: "Further verification and empirical evidence for the Erdős–Straus conjecture", arXiv:2509.00128 — abstract fetched verbatim: "We provide empirical evidence for the Erdős-Straus conjecture by improving computational bounds to $10^{18}$ and by evaluating the solution-counting function $f(p)$ for this conjecture." |
| Mordell's exceptional residues are `1, 11², 13², 17², 19², 23² (mod 840)` | **Confirmed.** | Several independent secondary sources agree on `{1, 121, 169, 289, 361, 529} (mod 840)`, `840 = 2³·3·5·7`. Re-derived from scratch here (§3) and reproduced exactly by the generator. |
| Polynomial-family approaches are unpublished ground | **False — well-trodden.** | arXiv:2508.07383 "Exact Polynomial Families Solving the Erdős–Straus Equation" (four explicit multivariable families, conjectured to cover `n ≡ 1 mod 4`, computational check to `10⁹`); arXiv:2404.01508 "A Complete Congruence System for the Erdős–Straus Conjecture"; arXiv:2602.20036 "A unified parametric approach … natural density one". Abstracts read. |

**Consequence, stated up front.** This task makes **no mathematical novelty claim and no record
claim**. The tier-1 identities are classical; the certified range `10⁸` is ten orders of magnitude
below the published `10¹⁸`. What is new here is local and instrumental: a machine-checkable
certificate format for a parametric claim, a generator, and an independent checker that
demonstrably rejects bad input. None of the cited papers appears to ship a machine-checkable
certificate, but that is a weak negative drawn from abstracts, not a literature audit, and nothing
below depends on it.

---

## 2. What was built

| Artifact | Path | Role |
|---|---|---|
| Generator | `ergodis-private/src/bin/c1029_parametric_cert.rs` | Builds tier-1 families, searches for tier-2 families, sieves, finds witnesses, emits the certificate. No crate dependencies; contains its own exact `Z[t]` arithmetic and its own SHA-256. |
| Independent checker | `ergodis-private/python/c1029_check.py` | Verifies everything from the specification, sharing no code with the generator. sympy for the symbolic identities, numpy for its own prime sieve. |
| Corruption suite | `ergodis-private/python/c1029_break.py` | Builds ten deliberately broken certificates and reports which layer catches each. |
| Replay driver | `ergodis-private/python/c1029_replay.sh` | Build, regenerate, byte-compare against committed evidence, check, break. 15 s end to end. |
| Certificate | `ergodis-private/evidence/c1029-cert-n1e8.txt` | 540 identity families + header + witness binding. |
| Witness file | `ergodis-private/evidence/c1029-witnesses-n1e8.txt` | 685 explicit residual witnesses. |

The generator is built **out of tree** at `~/.cache/ergodis/c1029/build` because the
`ergodis-private` library does not currently compile (untracked work from a concurrent session).
It needs nothing from that library, so this cost nothing and did not block the task.

---

## 3. The certificate format

### 3.1 Layer 1 — the parametric layer

A family is a row `family <tier> <name> <m> <r> <tmin>` followed by three integer coefficient
vectors `A`, `B`, `C` (low-to-high in `t`). Writing `n = m·t + r`, the family asserts

> for every integer `t ≥ tmin`, `4/n = 1/A(t) + 1/B(t) + 1/C(t)`.

The checker discharges that assertion with three exact, finite tests:

1. **Symbolic identity.** `n·(B·C + A·C + A·B) − 4·A·B·C = 0` as an element of `ℤ[t]` — exact
   polynomial equality via sympy, *not* evaluation at sample points. Nowhere in this task is an
   identity accepted on the strength of sampled values.
2. **Positivity, proved.** All coefficients of `A`, `B`, `C` are non-negative and each value at
   `t = tmin ≥ 0` is `≥ 1`. Non-negative coefficients make each polynomial non-decreasing on
   `t ≥ 0`, so the check at `tmin` extends to the whole half-line. This is a proof, not a sample.
3. **Reach.** The least integer `n ≥ 2` in the class has `t ≥ tmin`, so no `n ≥ 2` in the class
   escapes the family below its threshold.

### 3.2 Layer 1 — the covering

The header declares `cover_modulus 840` and `exceptional 1 121 169 289 361 529`. The checker
enumerates all 840 residues and requires each to be covered by some tier-1 family whose modulus
divides 840, or else to be declared exceptional. The twelve tier-1 families are:

| Family | Class | Construction |
|---|---|---|
| `even` | `n ≡ 0 (mod 2)` | `4/(2t) = 1/t + 1/(2t) + 1/(2t)` |
| `div3` | `n ≡ 0 (mod 3)` | `4/3 = 1/1 + 1/6 + 1/6`, scaled |
| `div5` | `n ≡ 0 (mod 5)` | `4/5 = 1/2 + 1/4 + 1/20`, scaled |
| `div7` | `n ≡ 0 (mod 7)` | `4/7 = 1/2 + 1/28 + 1/28`, scaled |
| `n3mod4` | `n ≡ 3 (mod 4)` | `s = 1`, `d = M` |
| `n2mod3` | `n ≡ 2 (mod 3)` | `4/n = 1/n + 1/((n+1)/3) + 1/(n(n+1)/3)` |
| `n13mod24` | `n ≡ 13 (mod 24)` | `s = 3`, `d = 2` |
| `n73mod168` | `n ≡ 73 (mod 168)` | `s = 7`, `d = n` |
| `n97mod168` | `n ≡ 97 (mod 168)` | `s = 7`, `d = x` |
| `n145mod168` | `n ≡ 145 (mod 168)` | `s = 7`, `d = 2x` |
| `n97mod120` | `n ≡ 97 (mod 120)` | `s = 15`, `d = 2n` |
| `n73mod120` | `n ≡ 73 (mod 120)` | `s = 15`, `d = 2x` |

The `(s, d)` recipe generating most of them: set `x = (n+s)/4` (so `4 | n+s`), `M = n·x`,
`y = (M+d)/s`, `z = M(M+d)/(s·d)`. The rational identity `1/x + 1/y + 1/z = 4/n` is then automatic
for *any* `d`; the entire content is integrality, which the generator decides by exact division in
`ℤ[t]` and the checker re-decides symbolically. The generator's covering computation reproduces
Mordell's exceptional set exactly, which is the first calibration rung.

The derivation also explains *why* those six classes survive. The condition for `d = e` (a
constant) is `p² ≡ −4e (mod s)` — a quadratic-residue condition on `p`. The classes left
uncovered are precisely those where `p ≡ 1 (mod 24)` and `p` is a quadratic residue mod 5 and mod
7; the quadratic-residue shape of the exceptional set is a direct shadow of the recipe's own
congruence condition, not a coincidence of the classical presentation.

### 3.3 Layer 2 — the ladder (auto-generated families)

Tier-2 families have arbitrary moduli and take no part in the mod-840 covering. They exist only
to shrink the witness layer. The generator enumerates candidate classes over a grid of `(s, d)`
shapes with `d ∈ {c, c·n, c·x}`, constructs the polynomials, and accepts a candidate exactly when
the exact divisions succeed and the coefficients come out non-negative — **exact polynomial
division is the acceptance oracle**, so the identity layer is discovered by machine rather than
hand-derived. It then greedily selects families by how many residual primes they absorb.

In the committed certificate, 528 of the 540 families are machine-found this way.

### 3.4 The residual layer and the composition rule

A witness line is `p s d`. The checker reconstructs `x = (p+s)/4`, `M = p·x`, `y = (M+d)/s`,
`z = (M + M²/d)/s`, requires each to be a positive integer, and then verifies the equation in the
form `4·x·y·z = p·(y·z + x·z + x·y)` — an integer identity independent of how the triple was
derived. The certificate header binds the witness file by SHA-256.

The composition rule, which the checker enforces as a finite condition:

> If `n mod 840` is non-exceptional, layer 1 solves `n` itself. Otherwise let `q` be the least
> prime factor of `n`; then `q ≤ n ≤ N`, and `q` must be solved by a tier-2 family or appear in
> the witness list. A solution for `q` gives one for `n = q·k` by scaling every denominator by `k`.

The checker therefore sieves `[2, N]` itself, extracts every prime whose residue mod 840 is
exceptional, and demands that each one is either matched by a tier-2 class or present as a
witness — and, in the other direction, that no witness is a non-prime or out of range. The one
mathematical step it does not re-derive is the scaling lemma, which is stated in the certificate's
`claim` line and argued above.

---

## 4. The committed claim and its evidence bundle

**Claim certified:** for every integer `n` with `2 ≤ n ≤ 10⁸` there are positive integers
`x, y, z` with `4/n = 1/x + 1/y + 1/z`.

| Quantity | Value |
|---|---|
| Cover modulus / exceptional residues | 840 / `{1, 121, 169, 289, 361, 529}` |
| Tier-1 families (covering layer) | 12 |
| Tier-2 families (ladder) | 528, selected greedily from 1394 candidates (`s ≤ 203`, `c ≤ 20`) |
| Primes `≤ 10⁸` in exceptional classes | 179,468 |
| Absorbed by the ladder | 178,783 (99.618%) |
| Explicit witnesses | 685 |
| Certificate size / witness file size | 63 KB / 11 KB |
| Generation time | 1.2 s, one core |
| Independent check time | ~2 s |
| Full replay (build, regenerate, diff, check, break) | 15 s |

SHA-256:

```
bb46177b5afb746fcf881bf10a70d95ed664916768108f697be80adb989e0f72  ergodis-private/evidence/c1029-cert-n1e8.txt
844f7630583a18cf3c75e6259b5a3629d3be8366a68c4801b39380e59bd7f68b  ergodis-private/evidence/c1029-witnesses-n1e8.txt
```

**Exact replay command** (rebuilds, regenerates, byte-compares against the committed evidence,
runs the independent checker and the corruption suite):

```
bash ergodis-private/python/c1029_replay.sh
```

Or the checker alone against the committed certificate:

```
uv run --with sympy --with numpy python3 ergodis-private/python/c1029_check.py \
    ergodis-private/evidence/c1029-cert-n1e8.txt
```

**Independent cross-check.** The checker is a separate implementation in a different language that
re-derives every quantity: its own sieve reproduces the residual-prime count 179,468 that the Rust
generator found; its own sympy polynomial arithmetic reproduces the identity verdicts; its own
`hashlib` reproduces the generator's hand-written SHA-256, which was additionally cross-checked
against coreutils `sha256sum`.

---

## 5. Does the checker reject? Ten deliberately broken certificates

A checker never shown rejecting anything has not been tested. Each mutant attacks one layer;
all ten are caught, each by the layer intended.

| Mutant | Layer attacked | Verdict | Reason reported |
|---|---|---|---|
| `wrong-identity` | symbolic identity | REJECTED | `n13mod24`: `n(BC+AC+AB) − 4ABC` not identically zero |
| `missing-class` | covering of `ℤ/840` | REJECTED | residues 481, 649 covered by no tier-1 family and not declared exceptional |
| `widened-class` | identity ties `A,B,C` to `(m, r)` | REJECTED | halving a family's modulus breaks the identity |
| `zero-denominator` | positivity | REJECTED | `even`: `A(0) = 0 < 1` |
| `bad-witness` | witness equation | REJECTED | `p = 66529`: `s` does not divide `M+d` |
| `missing-witness` | residual completeness | REJECTED | `p = 66529` has neither a tier-2 family nor a witness |
| `tampered-witness-file` | SHA-256 binding | REJECTED | witness hash differs from the declared one |
| `dropped-ladder-family` | residual completeness | REJECTED | the primes that family absorbed now have nothing |
| `overclaimed-range` | residual completeness | REJECTED | primes just above `10⁸` unaccounted for |
| `extra-exceptional-class` | residual completeness | REJECTED | class 481 declared exceptional with no witnesses behind it |

Two of these deserve comment.

`widened-class` is the attack the brief singles out — a class believed covered but not. It is
caught by the **identity** check rather than the covering check, because the polynomials encode
`m` and `r`: relabelling a family to cover a wider class immediately falsifies its identity in
`ℤ[t]`. That is a structural property of the format worth keeping in any successor: tying the
witness data to the class parameters makes class-widening self-detecting.

`extra-exceptional-class` is the same failure mode seen from the other side. Declaring an extra
class exceptional is sound in itself — it only *adds* obligations — but the composition check then
demands witnesses that do not exist, and rejects. So the format cannot be quietly weakened by
inflating the exceptional set either.

---

## 6. What the format can and cannot express

This is the part of the task that outlives the vehicle.

### Can

1. **One line of certificate, infinitely many cases.** A congruence class `n ≡ r (mod m)` with an
   explicit triple in `ℤ[t]`, verified as an exact polynomial identity. The twelve tier-1 families
   discharge 834 of 840 residue classes — every integer outside six classes mod 840, unconditionally
   and for all sizes.
2. **Positivity as a proof, not a sample.** Non-negative coefficients plus one evaluation at the
   threshold.
3. **A finite covering argument**, checked by exhaustion over the cover modulus.
4. **Composition with a finite residual layer** over a stated range, with the composition rule
   itself checked rather than trusted.
5. **Machine-discovered identities.** The generator searches candidate classes and lets exact
   polynomial division decide validity; 528 of 540 families were found this way, not written down.
6. **A cryptographic binding** from a small, human-readable certificate head to a bulk data file.

### Cannot

1. **It cannot finish.** No finite ladder of these families empties the residual. Absorption
   saturates below 1 for every grid tried, and the residual count grows linearly with `π(N)`:

   | Grid (`s`, `c`) | Candidates | Families used | Witnesses left at `10⁸` | Absorbed |
   |---|---|---|---|---|
   | none | – | 0 | 179,468 | 0% |
   | `s ≤ 103`, `c ≤ 30` | 1066 | 200 | 2,767 | 98.46% |
   | `s ≤ 203`, `c ≤ 20` | 1394 | 528 | 685 | 99.618% |
   | `s ≤ 403`, `c ≤ 20` | 2778 | 642 | 237 | 99.868% |

   Widening the grid keeps buying absorption at a rapidly worsening exchange rate. The witness
   layer is **structurally necessary**, not an artifact of insufficient effort — which is the
   computational face of the conjecture still being open.
2. **Positivity is a sufficient condition, not a decision procedure.** A family whose polynomials
   have a negative coefficient but are nonetheless positive for all `t ≥ tmin` would be rejected.
   The format has no vocabulary for "positive on a half-line" beyond non-negative coefficients.
3. **It can only express conditions on `n`'s residue, never on its factorization.** "Every `n` with
   a prime factor `≡ 3 (mod 4)`" is inexpressible. This is exactly why the residual is irreducible:
   the surviving cases turn on whether `−4e` is a quadratic residue modulo quantities built from
   `p`, which is not a fixed-modulus congruence condition on `p`.
4. **It expresses existence only, never a bound.** Nothing here certifies that something does *not*
   exist. The repository's bound-shaped questions still have no certificate format.
5. **The residual layer does not compress.** 685 witnesses at `10⁸`, ~26,000 at `10⁹` (with the
   smaller 200-family ladder). Reaching the published `10¹⁸` in this format would need on the order
   of `10¹³` witnesses. Range extension is not a compute problem in this shape; it is a format
   problem.
6. **Two steps stay outside the checker**: the multiplicativity/scaling lemma and the reduction to
   the least prime factor. They are stated in the certificate and argued in prose. Discharging them
   formally is a natural successor and would close the last gap between "the checker accepts" and
   "the claim is proved".

---

## 7. Integer-sieve kernels this needed, and whether Ergodis served

The slate predicted this target would exercise kernels the repository does not have. It did, and
**nothing in Ergodis served**:

| Kernel needed | In Ergodis? | Note |
|---|---|---|
| Segmented sieve of Eratosthenes over `[2, N]` | No | Written here; ~4 s to `10⁹`. |
| Trial-division factorization and divisor enumeration | No | Needed per candidate `x = (p+s)/4`. |
| Exact polynomial arithmetic in `ℤ[t]` with exact integer *and* polynomial division | No | Ergodis's algebra is `SmallField`: table-backed `u8`, order ≤ 256. Characteristic-zero polynomials over `ℤ` have no home there. |
| 128-bit integer arithmetic (`M²` reaches ~`10³⁴`) | No | Same reason. |
| SHA-256 | Available as a crate dependency in `ergodis-private`, but not usable from the out-of-tree build | Written here and cross-checked against coreutils. |

This is a clean confirmation of the §1 inventory in the slate: the finite-field, `u8`,
Hamming-metric assumptions leave the whole integer/characteristic-zero side unserved. The
transferable piece is not the sieve — it is the **exact `ℤ[t]` layer used as a trust boundary**:
the generator may search however it likes, and the checker accepts only what survives exact
polynomial arithmetic.

---

## 8. `ej` + `tt` closeout

**Free upgrades taken during the pass.**

- *Auto-generated identity layer.* The initial design had a hand-derived twelve-family covering and
  a witness list of 179,468 entries at `10⁸`. Noticing that the witness search's own `(s, d)` output
  is itself a congruence condition turned those witnesses into identities: 528 machine-found
  families now absorb 99.6% of them, and the committed bundle is 74 KB instead of 2.8 MB.
- *Holdout test against overfitting.* Greedy selection is fitted to observed primes, so the ladder
  was re-fitted on primes `≤ 10⁷` only and measured on the unseen `10⁷`–`10⁸` band: 98.952% on the
  fitting window versus 98.166% on the holdout. The ladder is a genuine density statement about
  residue classes, not a fit to the sieve output. Any future greedily-selected certificate in this
  repository should carry the same holdout line.
- *Deep-path instrumentation.* The witness search has a fast path (`d | M`) and a fallback
  (`d | M²`). Exactly **one** prime below `10⁸` — `p = 2521` — needs the fallback.

**What Tao would see.** He would reach immediately for Elsholtz–Tao, "Counting the number of
solutions to the Erdős–Straus equation on unit fractions", which classifies solutions into types
and shows the exceptional set has density zero but not finite support. Read against that, the
saturation table in §6 is the empirical shadow of a known structural fact: solubility for
`p ≡ 1 (mod 24)` depends on factorization data, not on `p`'s residue at any fixed modulus, so a
congruence-only certificate provably cannot close. He would also press on where the machine earns
its keep: the twelve-family covering mod 840 is checkable by hand, so the certificate's value
begins exactly at the 528-family ladder, which is not. And he would flag the positivity criterion
as the format's crudest joint — sufficient, cheap, and strictly weaker than the property it stands
in for.

**Where this shape transfers inside the repository.** Not to the existing "the family stops here"
statements — those are exhaustion-shaped, not covering-shaped, and this format expresses no
non-existence claim. What transfers is narrower and real: exact `ℤ[t]` verification as a trust
boundary, the SHA-256 binding from a small certificate to bulk data, the composition check that
refuses to trust a declared covering, and the holdout discipline for any greedily-selected
certificate.

### Mystery ledger

| Surprise | Settled by this pass? | Gap, gate, or owner |
|---|---|---|
| Absorption saturates near 99.6% for a fixed grid instead of climbing to 1 | **Partly.** Greedy exhausts the candidate pool (gain hits zero at 528 of 1394 families); widening `s` to 403 moves it to 99.868% but never to 100%. | Open: whether a richer `d`-shape (`d = c·n·x`, or non-constant cofactors of `M²`) keeps climbing, and whether there is a provable ceiling. A successor task with a wider shape grid would answer the first cheaply; the second is the open conjecture in disguise. |
| Exactly one prime below `10⁸` (`p = 2521`) needs the `d \| M²` fallback | **Yes, measured**, not explained. | No soundness consequence — the checker validates the equation regardless of which path found it. Why the sparse exception exists at all is unexplained; recorded rather than chased. |
| The six exceptional residues are exactly the quadratic-residue-defined classes | **Yes, explained** by the recipe's own condition `p² ≡ −4e (mod s)`. | Closed. Worth stating because it was not obvious going in that the classical exceptional set and the generator's acceptance oracle share one mechanism. |
| The witness search never fails across 1.6M residual primes to `10⁹` with `s ≤ 4001` | No proof offered. | Not a mystery of this instrument — it is the empirical content of the published verifications, and the certificate does not depend on it (every found witness is checked; a failure would have been a hard stop, not a silent gap). |

No further genuine mystery remains in the machinery itself. The mathematics stays open, by design;
that was never this task's business.

---

## 9. Scaling, for the record

Not certified — the committed claim stops at `10⁸`, where the whole bundle is small enough to
commit and the independent checker runs in seconds on any machine.

| `N` | Residual primes | Witnesses (200-family ladder) | Generation |
|---|---|---|---|
| `10⁷` | 20,513 | 215 | 0.05 s |
| `10⁸` | 179,468 | 2,767 | 0.6 s |
| `10⁹` | 1,587,581 | 26,558 | 3.8 s |

The independent checker's numpy sieve needs about `N` bytes of memory, so `10⁹` would need ~1 GB;
that, not generation time, is why `10⁸` is the committed range. The point of §6.5 stands
regardless: this format does not reach `10¹⁸` at any budget.

---

## 10. Foreign-lane issues raised, not touched

1. `ergodis-private`'s library was reported not to compile (untracked work from a concurrent
   session: `src/hadamard_2092.rs`, `src/proof_synthesis.rs`, `src/g53_*.rs`, `src/reduction_proof.rs`,
   `tests/`, and others). Not verified and not repaired — this task built out of tree at zero cost.
   Anything that needs a `cargo` build inside `ergodis-private` is blocked until that session lands.
2. `ergodis-private/controls/query-design-c1011/target/` is an untracked Cargo build tree sitting
   inside the repository. It matches the standing "no build trees in the source tree" rule and
   should get a `target-dir` under `~/.cache/`. Not touched.
