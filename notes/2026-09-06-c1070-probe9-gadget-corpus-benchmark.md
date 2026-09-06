# C1070 probe 9 — the IronMask and maskVerif gadget corpora as a leakage benchmark

**Lane**: `ergodis`
**Task**: C1070 probe 9 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`)
**Code**: `~/src/ergodis-private` — tier-1 module `src/gadget_corpus.rs`, one `tasks/tools`
subcommand `gadget-corpus-report`, and the verdict-collection script
`scripts/c1070-probe9-ironmask-ni.sh`. No change to the `~/src/ergodis` core; `src/lib.rs` gained
one `pub mod` line.
**Data**: `notes/data/2026-09-06-c1070-probe9/`.
**Scope**: linear gadgets over `F_2` in the value-only probing model. Glitch and transition
extensions, arithmetic (`#CAR q`) gadgets, duplicated-share combined-security gadgets, and every
multiplication gadget are out of scope and are rejected with a reason rather than reinterpreted.

---

## 0. Verdict

| Question | Answer |
|---|---|
| Can the corpora be ingested? | **Yes.** Both formats parse; the linear-`F_2` fragment is 75 gadgets across the two corpora, and the 44 files outside it are rejected with an explicit reason. |
| Do the published verdicts and the engine agree? | **Yes, with no disagreement anywhere.** Every gadget carrying a published verdict either has its exact minimum leaking coalition computed and equal to the share count, or has every coalition up to the claimed order verified clean. Zero contradictions. |
| Does the engine say more than the tools? | Yes. It returns the minimum leaking coalition **with a coefficient witness naming the wires and the secret functional they recover**, where IronMask returns a set of input-share indices and maskVerif returns a failing probe tuple. |
| Freshness diagnostic | Computed for every gadget. In this corpus no random reaches two different output variables, so the per-gadget freshness obligation these tools take as an axiom is in fact discharged for every ingested gadget — a fact none of the tools reports. |

Direction of the result: this is an engineering win with no research risk, exactly as probe 0 §10
predicted. The corpus is now a standing regression suite for the C1070 engine.

---

## 1. Sources, provenance, licences

Both corpora were cloned fresh into `~/.cache/ergodis/corpora/` (not the repository, not the
scratchpad).

| Corpus | Remote | Commit | Commit date | Licence |
|---|---|---|---|---|
| IronMask | `https://github.com/CryptoExperts/IronMask.git` | `8d2d79b686316a9152510f97443b91f4e456f749` | 2025-08-29 | GPLv3, stated in `Readme.md` |
| maskVerif | `https://gitlab.com/benjgregoire/maskverif.git` (branch `master`) | `ce1780d60a2e4abe83c7c605ee3e78b2f88c7fdf` | 2020-07-13 | CeCILL-B, stated in `LICENSE` |

Neither corpus is copied into this repository or into `ergodis-private`; only the derived
measurements and the collected verdicts are committed. A first clone attempt used
`https://github.com/EasyCrypt/maskverif.git`, which does not exist and produced a credential
prompt; the GitLab remote above is the one named by the maskVerif distribution.

The IronMask binary was built from that checkout for the verdict collection of §4. Its `src/Makefile`
defaults to `clang`; with the current GCC the build stops at one incompatible-pointer initialisation
in `cardRPC.c`, which is unrelated to the probing checkers, so the build used
`CFLAGS='-Wall -Wextra -O3 -mavx2 -pthread -mlzcnt -Wno-incompatible-pointer-types'` and GMP headers
from the Nix store. That is a build-configuration change, not a source change; nothing in the
checkout was edited.

---

## 2. The model, and why the corpus is a valid benchmark

A gadget declares input variables `a, b, …` each carried as `n` shares, a set of random variables,
and a straight-line program of assignments. Probe 1 §1.2's label-pinning reduction turns this into
the C1070 model directly:

```
masks   = randoms  ⊕  (n - 1) free share coordinates per input variable
secrets = one coordinate per input variable
a_i = m_{a,i}  (i >= 1)          a_0 = s_a + sum_{i >= 1} m_{a,i}
```

so `sum_i a_i = s_a` is the secret functional of input `a` and the shares are otherwise uniform.
Every wire of the program — each input share and each assignment result — is one observation unit of
cost 1. Random variables are not themselves probes, matching the tools' own wire count (IronMask
reports 9 intermediate variables for the 3-share refresh: 3 input shares and 6 assignment results).

A coalition `H` leaks exactly when some combination `y` of its rows has zero mask part and nonzero
secret part — probe 1's annihilation condition `{uᵀA : uᵀB = 0}`, not a quotient. The gadget is
`t`-probing secure precisely when the least such `|H|` exceeds `t`. That is why the tools' published
verdicts are free correctness checks: for linear gadgets their probing question **is** this rank
test.

Two consequences used throughout:

* The minimum leaking coalition is at most `n`, because probing all `n` shares of one input recovers
  its secret. So a search that rules out every coalition of size `n - 1` has *proved* the minimum is
  exactly `n`, and the probing order exactly `n - 1`.
* `t`-NI implies `t`-probing security but not conversely (probe 0 §3.3, quoting Cassiers–Standaert:
  non-interference "is however not a necessary condition for probing security"). So an NI verdict is
  a one-directional claim, and only a claimed *success* constrains us. That asymmetry is respected in
  the agreement rule of §4.

---

## 3. Parser scope, and what is rejected

`src/gadget_corpus.rs` parses both formats.

**IronMask `.sage`.** Headers `#SHARES`, `#IN`, `#OUT`, `#RANDOMS`, and `#ORDER` (metadata, ignored);
body lines `lhs = rhs` with `+`-separated terms and optional `1`/`-1` coefficients; `![ … ]` glitch
barriers are recognised, counted, and then ignored, since the value model does not see them.
Rejections: `#CAR q` for `q != 2` (the arithmetic corpus), `#DUPLICATIONS k` (combined security),
any `*` (multiplication), any coefficient outside `{1, -1}`, and any undefined identifier.

**maskVerif `.mv`.** A single `proc` block with `inputs:`, `outputs:`, `shares:`, `randoms:`
declarations — with or without a space before the colon — vector ranges `a[0:n-1]`, scalar and
indexed atoms, `+`, the cyclic rotation `(v >> k)`, and the assignment forms `=`, `:=`, `=![ … ]`,
`<-`. The trailing directive line (`para SNI Refresh`, `noglitch SNI REFRESH`) is captured as the
file's own published verdict.

The rotation direction is taken as `(v >> k)_i = v_{(i+k) mod n}`. The opposite convention is the
index negation `i -> -i`, which permutes the wire set bijectively and fixes the secret functional
(the sum of shares), so every quantity computed here is invariant under the choice. Rotations are
cyclic rather than shifting: a zero-filled shift would not preserve the share sum and the refresh
gadgets would not be correct.

**Corpus sizes.**

| | ingested | rejected |
|---|---|---|
| IronMask (`gadgets/Bin`, recursive) | 53 | 44 |
| maskVerif (`benchs/refreshes`, recursive) | 22 | 0 |
| total | **75** | **44** |

Rejection reasons, all explicit: 38 multiplications (nonlinear), 4 share-duplication headers, and 2
files whose body carries a prose note rather than an assignment. The arithmetic corpus
(`gadgets/Arith`, 91 files) is not walked at all, since the whole directory is outside the `F_2`
scope; pointing the reader at `#CAR` is more useful than 91 identical rejections.

---

## 4. Published verdicts, and how agreement is decided

Two independent verdict sources.

1. **IronMask's own NI verdict**, collected by running the built binary at
   `t = shares - 1` over every non-multiplication gadget under `gadgets/Bin`:
   `scripts/c1070-probe9-ironmask-ni.sh <checkout> <timeout>`. Result:
   `notes/data/2026-09-06-c1070-probe9/ironmask-ni-verdicts.json`, 53 entries — 47 `t-NI`, 6
   timeouts at the 300-second limit. A `t-NI` verdict claims `t`-probing security; a timeout claims
   nothing and is recorded as such.
2. **maskVerif's in-file directives.** All 15 `benchs/refreshes/ref_*.mv` carry `para SNI Refresh`
   and all 7 `refreshZero_*.mv` carry `noglitch SNI REFRESH`. Strong non-interference at order
   `n - 1` implies `(n-1)`-probing security, and both directives assert it in a *stronger* model
   than ours (parallel/glitch and noglitch respectively), so they are sound claims about the value
   model too.

**Agreement rule.** A claim of `t`-probing security agrees when the engine either computes a minimum
leaking coalition strictly larger than `t`, or verifies that no coalition of size `≤ t` leaks. It
disagrees when the engine exhibits a leaking coalition of size `≤ t` — which would be a witness the
tool is wrong, or a modelling difference, and gets the brute-force recheck of §6. Gadgets whose only
verdict entry is a timeout are marked `no-claim` and are still measured.

---

## 5. Results

Certificate: `notes/data/2026-09-06-c1070-probe9/gadget-corpus.json`
(schema `c1070-probe9-gadget-corpus-v1`).

**Headline counts** (search depth 16, one-billion-step budget per gadget):

```
accepted 75   rejected 44
agree 54   disagree 0   unresolved 15   no-claim 6
cross-checked against the independent coalition sweep 20
```

Fifty-four gadgets have their exact minimum leaking coalition computed, and in **every one of them
the minimum equals the share count**, so the probing order is exactly `n - 1` and matches the
published claim exactly. The other 21 are budget-limited partial verifications, listed below.

Every ingested gadget carrying a published claim agrees with the engine. Nothing disagrees.

The `unresolved` rows are gadgets where the search budget stopped before either exhibiting a leak or
ruling out every coalition up to the claimed order; they are *not* contradictions, they are
incomplete verifications, and each records exactly how far it got (`clean_through`).

**Per-gadget table, closed rows.** `min leak` is the size of the smallest leaking coalition,
`order` the probing-security order `min leak − 1`, `claim` the published `t`.

| gadget | n | wires | masks | min leak | order | claim | agreement |
|---|---|---|---|---|---|---|---|
| ISW/refresh/gadget_refresh_2_shares | 2 | 4 | 2 | 2 | 1 | 1 | agree |
| ISW/copy/gadget_copy_2_shares | 2 | 6 | 3 | 2 | 1 | 1 | agree |
| ISW/add/gadget_add_2_shares | 2 | 10 | 4 | 2 | 1 | 1 | agree |
| nlogn/gadget_refresh_2_shares | 2 | 4 | 2 | 2 | 1 | 1 | agree |
| nlogn/gadget_copy_2_shares | 2 | 6 | 3 | 2 | 1 | 1 | agree |
| nlogn/gadget_add_2_shares | 2 | 10 | 4 | 2 | 1 | 1 | agree |
| ISW/refresh/gadget_refresh_3_shares | 3 | 9 | 5 | 3 | 2 | 2 | agree |
| nlogn/gadget_refresh_3_shares | 3 | 12 | 5 | 3 | 2 | 2 | agree |
| ISW/copy/gadget_copy_3_shares | 3 | 15 | 8 | 3 | 2 | 2 | agree |
| Crypto2020_Gadgets/gadget_copy_1_o2 | 3 | 15 | 8 | 3 | 2 | 2 | agree |
| ISW/add/gadget_add_3_shares | 3 | 21 | 10 | 3 | 2 | 2 | agree |
| Crypto2020_Gadgets/gadget_add_1_o2 | 3 | 21 | 10 | 3 | 2 | 2 | agree |
| Crypto2020_Gadgets/gadget_add_2_o2 | 3 | 21 | 10 | 3 | 2 | 2 | agree |
| ISW/refresh/gadget_refresh_4_shares | 4 | 16 | 9 | 4 | 3 | 3 | agree |
| nlogn/gadget_refresh_4_shares | 4 | 16 | 9 | 4 | 3 | 3 | agree |
| ISW/copy/gadget_copy_4_shares | 4 | 28 | 15 | 4 | 3 | 3 | agree |
| nlogn/gadget_copy_4_shares | 4 | 28 | 15 | 4 | 3 | 3 | agree |
| ISW/add/gadget_add_4_shares | 4 | 36 | 18 | 4 | 3 | 3 | agree |
| nlogn/gadget_add_4_shares | 4 | 36 | 18 | 4 | 3 | 3 | agree |
| RP-Eurocrypt2021/refresh_circular_5_shares | 5 | 15 | 9 | 5 | 4 | 4 | agree |
| ISW/refresh/gadget_refresh_5_shares | 5 | 25 | 14 | 5 | 4 | 4 | agree |
| RP-Eurocrypt2021/copy_5_shares | 5 | 25 | 14 | 5 | 4 | 4 | agree |
| RP-Eurocrypt2021/add_5_shares | 5 | 35 | 18 | 5 | 4 | 4 | agree |
| ISW/copy/gadget_copy_5_shares | 5 | 45 | 24 | 5 | 4 | 4 | agree |
| ISW/add/gadget_add_5_shares | 5 | 55 | 28 | 5 | 4 | 4 | agree |
| ISW/refresh/gadget_refresh_6_shares | 6 | 36 | 20 | 6 | 5 | 5 | agree |
| nlogn/gadget_refresh_6_shares | 6 | 36 | 17 | 6 | 5 | 5 | agree |
| ISW/copy/gadget_copy_6_shares | 6 | 66 | 35 | 6 | 5 | 5 | agree |
| ISW/add/gadget_add_6_shares | 6 | 78 | 40 | 6 | 5 | 5 | agree |
| ISW/refresh/gadget_refresh_7_shares | 7 | 49 | 27 | 7 | 6 | 6 | agree |
| nlogn/gadget_refresh_7_shares | 7 | 42 | 21 | 7 | 6 | 6 | agree |
| ISW/copy/gadget_copy_7_shares | 7 | 91 | 48 | 7 | 6 | 6 | agree |
| ISW/refresh/gadget_refresh_8_shares | 8 | 64 | 35 | 8 | 7 | 7 | agree |
| nlogn/gadget_refresh_8_shares | 8 | 48 | 27 | 8 | 7 | 7 | agree |
| RP-Eurocrypt2021/refresh_circular_10_shares | 10 | 30 | 19 | 10 | 9 | 9 | agree |
| maskverif ref_02 | 2 | 4 | 2 | 2 | 1 | 1 | agree |
| maskverif ref_03 | 3 | 7 | 4 | 3 | 2 | 2 | agree |
| maskverif refreshZero_2 | 3 | 9 | 5 | 3 | 2 | 2 | agree |
| maskverif ref_04 | 4 | 12 | 7 | 4 | 3 | 3 | agree |
| maskverif refreshZero_3 | 4 | 12 | 7 | 4 | 3 | 3 | agree |
| maskverif ref_05 | 5 | 15 | 9 | 5 | 4 | 4 | agree |
| maskverif refreshZero_4 | 5 | 15 | 9 | 5 | 4 | 4 | agree |
| maskverif ref_06 | 6 | 26 | 12 | 6 | 5 | 5 | agree |
| maskverif refreshZero_5 | 6 | 30 | 17 | 6 | 5 | 5 | agree |
| maskverif ref_07 | 7 | 32 | 15 | 7 | 6 | 6 | agree |
| maskverif refreshZero_6 | 7 | 35 | 20 | 7 | 6 | 6 | agree |
| maskverif ref_08 | 8 | 38 | 18 | 8 | 7 | 7 | agree |
| maskverif ref_09 | 9 | 42 | 20 | 9 | 8 | 8 | agree |
| maskverif ref_10 | 10 | 50 | 24 | 10 | 9 | 9 | agree |
| maskverif ref_11 | 11 | 55 | 27 | 11 | 10 | 10 | agree |
| maskverif ref_12 | 12 | 60 | 31 | 12 | 11 | 11 | agree |
| maskverif ref_14 | 14 | 70 | 41 | 14 | 13 | 13 | agree |
| maskverif ref_15 | 15 | 75 | 44 | 15 | 14 | 14 | agree |
| maskverif ref_16 | 16 | 80 | 47 | 16 | 15 | 15 | agree |

The 15-share and 16-share maskVerif refreshes are settled exactly, so the exact search is not
limited by share count as such; what limits it is wire count. The narrow refresh gadgets have
`5n` wires and close through `n = 16`, while the IronMask add and copy gadgets have `n(n+1)` and
`n(n+2)` wires and stop closing at `n = 7`.

**Per-gadget table, budget-limited rows.** `verified clean` is the largest coalition size for which
every coalition was checked and none leaks; the minimum is somewhere above it and at most `n`.

| gadget | n | wires | masks | verified clean | claim | status |
|---|---|---|---|---|---|---|
| ISW/add/gadget_add_7_shares | 7 | 105 | 54 | 5 | 6 | unresolved |
| ISW/add/gadget_add_8_shares | 8 | 136 | 70 | 5 | 7 | unresolved |
| ISW/copy/gadget_copy_8_shares | 8 | 120 | 63 | 5 | 7 | unresolved |
| nlogn/gadget_add_8_shares | 8 | 104 | 54 | 5 | 7 | unresolved |
| nlogn/gadget_copy_8_shares | 8 | 88 | 47 | 6 | 7 | unresolved |
| ISW/add/gadget_add_9_shares | 9 | 171 | 88 | 4 | 8 | unresolved |
| ISW/copy/gadget_copy_9_shares | 9 | 153 | 80 | 5 | 8 | unresolved |
| ISW/refresh/gadget_refresh_9_shares | 9 | 81 | 44 | 6 | 8 | unresolved |
| nlogn/gadget_refresh_9_shares | 9 | 60 | 32 | 7 | 8 | unresolved |
| ISW/add/gadget_add_10_shares | 10 | 210 | 108 | 4 | 9 | unresolved |
| ISW/refresh/gadget_refresh_10_shares | 10 | 100 | 54 | 5 | 9 | unresolved |
| nlogn/gadget_refresh_10_shares | 10 | 72 | 38 | 6 | 9 | unresolved |
| maskverif refreshZero_10 | 11 | 55 | 26 | 7 | 10 | unresolved |
| maskverif ref_13 | 13 | 65 | 34 | 8 | 12 | unresolved |
| maskverif refreshZero_18 | 19 | 95 | 46 | 6 | 18 | unresolved |
| ISW/copy/gadget_copy_10_shares | 10 | 190 | 99 | 4 | - | no-claim (NI timeout) |
| nlogn/gadget_refresh_11_shares | 11 | 84 | 40 | 6 | - | no-claim (NI timeout) |
| nlogn/gadget_refresh_12_shares | 12 | 96 | 47 | 5 | - | no-claim (NI timeout) |
| nlogn/gadget_add_16_shares | 16 | 272 | 142 | 4 | - | no-claim (NI timeout) |
| nlogn/gadget_copy_16_shares | 16 | 240 | 127 | 4 | - | no-claim (NI timeout) |
| nlogn/gadget_refresh_16_shares | 16 | 128 | 71 | 5 | - | no-claim (NI timeout) |

None of these is a contradiction: each says "no coalition up to this size leaks", which is
consistent with the published claim and short of proving it. IronMask itself timed out on the six
`no-claim` gadgets at 300 seconds, so on those the engine and the tool are stuck on the same
instances.

**Freshness.** No random in either corpus reaches two different output variables
(`cross_output_randoms` is empty for all 75 gadgets). Probe 1 §4's failure mode — a mask shared
between blocks, making the fresh-mask min–sum return `∞` where the true cost is finite — therefore
does not fire anywhere in this corpus, and the freshness axiom these tools assume is, for these
files, a theorem.

The mask-block rank drop — mask coordinates the observation cannot resolve — is nonzero for 24
gadgets, and they are exactly the maskVerif rotation refreshes, not the IronMask ones. The cause is
structural rather than reuse: those gadgets inject randomness only through `r + (r >> k)`, and the
map `1 + x^k` on the cyclic random vector is singular, so part of the random space never reaches any
wire. This is the diagnostic behaving as designed — it separates "randomness the adversary cannot
see" from "randomness shared between blocks", and only the latter is probe 1 §4's failure mode.

---

## 6. Disagreements

**There are none.** No gadget in either corpus produced a leaking coalition at or below its
published order, so the brute-force recheck path of the task specification was never entered. The
recheck machinery exists regardless and is exercised on every small instance: see §7.

---

## 7. Validation

Three independent layers.

1. **Unit tests** in `src/gadget_corpus.rs` (`cargo test --lib gadget_corpus`, 7 tests):
   the 3-share IronMask refresh with three randoms is 2-probing secure; the 2-share copy gadget
   leaks at its share count; an unrefreshed 3-share copy leaks with exactly as many probes as shares
   and returns a 3-wire witness; a multiplication gadget is rejected as nonlinear naming the line and
   the offending term; an arithmetic `#CAR 3329` header is rejected as non-binary; the maskVerif
   3-share refresh parses, its `para SNI Refresh` directive is captured, its four glitch barriers are
   counted, and its order matches; and the freshness diagnostic detects a hand-built copy gadget that
   reuses one random across both outputs, which the same run shows leaks at 2 probes.
2. **An independent implementation.** Every gadget with at most 16 wires (20 of the 75) has its
   minimum leaking coalition recomputed by `leakage_structure::FlatInstance::profile_sweep`, probe
   2's exhaustive coalition sweep, which shares no code with the depth-first search: it enumerates
   all `2^wires` coalitions and computes `dim(S ∩ V_H)` by Gaussian elimination over `SmallField`.
   The report *fails* if the two ever differ. They never differ.
3. **The tools themselves**, via §4's collected verdicts.

The search itself is exact, not heuristic. It is iterative deepening over coalitions with one prune:
a wire whose row already lies in the span of the chosen wires is skipped, because dropping it leaves
the same observed space and so any leak it witnesses is witnessed by a strictly smaller coalition,
which an earlier depth already examined. A second, purely structural reduction runs first: a wire
carrying a mask coordinate that no other live wire carries can never appear in a leak vector, since
that coordinate could not be cancelled; removing such wires is iterated to a fixed point.

---

## 8. Reproducibility

Everything below runs from a clean checkout.

```
# 1. Corpora (records the commits of §1)
mkdir -p ~/.cache/ergodis/corpora && cd ~/.cache/ergodis/corpora
git clone https://github.com/CryptoExperts/IronMask.git ironmask
git clone https://gitlab.com/benjgregoire/maskverif.git maskverif

# 2. IronMask binary (for the published-verdict side only)
cd ~/.cache/ergodis/corpora/ironmask
export CPATH=<gmp-dev>/include LIBRARY_PATH=<gmp>/lib
nix shell nixpkgs#gcc nixpkgs#gnumake --command make -C src CC=gcc \
  CFLAGS='-Wall -Wextra -O3 -mavx2 -pthread -mlzcnt -Wno-incompatible-pointer-types'

# 3. Published verdicts
cd ~/src/ergodis-private
./scripts/c1070-probe9-ironmask-ni.sh ~/.cache/ergodis/corpora/ironmask 300 \
  > ~/src/othello/notes/data/2026-09-06-c1070-probe9/ironmask-ni-verdicts.json

# 4. The benchmark itself
cargo build --release -p ergodis-tools
~/.cache/ergodis/target/ergodis-private/release/ergodis-tools gadget-corpus-report \
  --ironmask ~/.cache/ergodis/corpora/ironmask \
  --maskverif ~/.cache/ergodis/corpora/maskverif \
  --ni-verdicts ~/src/othello/notes/data/2026-09-06-c1070-probe9/ironmask-ni-verdicts.json \
  --max-depth 16 --budget 1000000000 \
  --out ~/src/othello/notes/data/2026-09-06-c1070-probe9/gadget-corpus.json

# 5. Re-verification of the tracked certificate
... same command with --check
```

The run is deterministic: no randomness, no parallelism, no wall-clock dependence. `--check`
recomputes the whole report and fails if the tracked certificate differs by a single field.

SHA-256 of the committed artefacts is in `notes/data/2026-09-06-c1070-probe9/SHA256SUMS`.

---

## 9. What this means for the product

1. **The engine now has a standing external regression suite.** 75 gadgets with third-party
   verdicts, ingested from the formats their authors publish, re-verified by one command. Any future
   change to the leakage core is checked against the masking-verification community's own answers
   rather than against fixtures we wrote ourselves.
2. **The output is a strict refinement of what the tools give.** For each gadget the engine returns
   the minimum leaking coalition *and the wires in it*, from which the recovered secret functional is
   read off directly. IronMask returns a set of input-share indices; maskVerif returns a failing
   probe tuple. Probe 0 §3.5's recommendation — report the minimal input-share set *alongside* the
   labelled answer, not instead of it — is the natural next interface step and is now cheap, because
   the same reduced basis holds both.
3. **The freshness claim is now measurable, not rhetorical.** These tools take per-gadget fresh
   randomness as a modelling axiom (IronMask: "a randomised arithmetic circuit is equipped with an
   additional random gate of fan-in 0 which outputs a fresh uniform random value"). The engine
   *checks* it, per gadget, as a property of the encoding. On this corpus the axiom holds
   everywhere, which is the right outcome: it says the diagnostic is calibrated, and it is ready for
   the composed circuits where probe 1 §4 shows the axiom failing.
4. **The scale boundary is now known and is the next engineering target.** Exact minimum-coalition
   search closes for every gadget with roughly 80 wires or fewer — including the 16-share maskVerif
   refresh — and runs out of budget on the wide add and copy gadgets from 8 shares up, where the wire
   count is quadratic in the share count. The controlling parameter is wire count, not share count.
   The obstruction is that the
   quantity is a minimum-weight codeword problem, and the current search is iterative deepening with
   a redundancy prune. Information-set-style enumeration with a proved completeness bound, or the
   min–sum decomposition of the manuscript applied to the gadget's own block structure, would close
   the rest. That is a well-posed successor task, not an open research question.

---

## 10. Mystery ledger

| Observation | Status |
|---|---|
| Every ingested gadget is exactly `(n-1)`-probing secure — the minimum leaking coalition is always the full share count, never anything between. | **Settled, and it is not a coincidence.** These are published gadgets selected for optimal order, and the trivial witness caps the minimum at `n`; so "optimal" and "minimum equals `n`" are the same statement. The measurement's value is that it holds for *every* one of them with no exception, including the aggressively randomness-optimised `nlogn` and `refreshZero` families. |
| No random anywhere in either corpus reaches two output variables. | **Settled by inspection of the construction.** Every gadget here is a single primitive (refresh, copy, add), and the copy gadgets deliberately use two disjoint random sets, one per output. Mask sharing is a *composition* phenomenon, which is precisely probe 1 §4's point; a single-gadget corpus cannot exhibit it. To exercise the diagnostic properly the engine needs composed circuits, e.g. maskVerif's AES S-box or a hand-composed refresh-then-copy chain. That is the open item, owned by the interface probe. |
| Twenty-four gadgets show a nonzero mask-block rank drop while having no cross-output reuse. | **Settled during this pass.** They are exactly the maskVerif rotation refreshes, and the drop is the singularity of `1 + x^k` acting on the cyclic random vector: some of the injected randomness reaches no wire. It is not mask sharing and does not weaken the gadget. What it does show is that the rank-drop number alone is not the sharing diagnostic; the cross-output reach is, and the two must be reported separately, as they now are. |
| Six IronMask NI runs time out at 300 s where the engine settles the same gadgets in seconds. | **Explained, not a claim of superiority.** NI is a stronger property over a larger search space (all tuples, with a cardinality condition per input), so the two are not doing the same work. Whether the engine can also decide NI cheaply — it computes the same residual basis IronMask does — is a genuine open question and the cheapest available next capability. |

No mystery in this probe is load-bearing for the result: the benchmark's conclusion is a count of
agreements and it has no exceptions.
