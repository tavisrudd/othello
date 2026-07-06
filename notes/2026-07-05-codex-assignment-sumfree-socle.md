# Research assignment (for Codex): the sum-free achievement game on `Z₂ × F₃ᵇ`, and the socle reduction

> **★★★★★★★ ROUND-7 compute update — 2026-07-06 (session `--3`, `mi`). The ∗1-absent half is LOCALIZED and
> the fixed-pairing route is CLOSED. Read this before ROUND-6.** Full write-up + reproducible scripts:
> `2026-07-05-sumfree-nimber-engine.md` §"2026-07-06 (session `--3`)". Three findings for your proof:
> 1. **Mirror-break lemma (exhaustively verified, p=7,11,13).** Frame `𝒢({p,e})=∗1` as "`{p,e}+∗1` is P
>    (responder Rita wins)". `{p,e}` has a *single mirror defect* `e` (negation `σ` moves `p↦2p`=dead, so `σ`
>    fixes no `p`-board). For ANY single-defect board `{p}∪S∪{d}` (S symmetric), the legal moves `z` whose
>    mirror `−z` is illegal are **EXACTLY** the ≤3 legal negations of the defect-blocks `{2d, d+p, d·2⁻¹}`.
>    The obstruction to a mirror strategy is precisely **three defect-generated blocks** — nothing else.
> 2. **The single-token pairing/mirror strategy is DEAD (definitive, do NOT retry).** Two independent fatal
>    reasons, each witnessed: (a) the mirror reply is **not value-preserving** — `{3,7}=∗1` but Rita's mirror
>    of Alice's `1` lands on `{1,3,7,20}=∗3` (σ is not an automorphism of a `p`-board); (b) a single break-move
>    double-blocks both replies — at `{1,3,7,20}`, Alice's `9` kills the mirror `−9=12` (`3+9`) AND the migrate
>    `−3=18` (`9+9`). Exhaustive minimax confirms the fixed policy STUCKs at every `p=7,11,13,17`. `𝒢({p,e})=∗1`
>    is true but **only via ADAPTIVE play** — this is the non-mirror route you did for `Z3²×Z7`. Apply it here.
> 3. **A static-signature monovariant is ruled out** — ∗1 is ~40% of all positions, spanning every board
>    signature (incl. F₃-color: I checked; `{2,11,20}=∗1` is F₃-monochromatic but that's a small-`p` artifact,
>    p=17 kills it — do NOT chase an F₃-color law). A monovariant must be a mex/recursion invariant, not a feature.
> 4. **Your one-defect/two-defect induction: the variable is (defect-count, PAIR-count), not defect-count.**
>    ∗1 two-defect positions exist but **all carry ≥1 symmetric colored pair** (`Sym≠∅`; e.g. `{1,3,7,9,20}=∗1`).
>    The `{p,e}` children are the `Sym=∅` two-defect positions (bare `{p,e,z}`) — those are the ∗1-free ones.
>    So the claim to induct is "**bare two-defect `{p,e,z}` (no pairs) is never ∗1**", and the lemma "every
>    non-P two-defect has a one-defect ∗1 child" is FALSE as stated (33/91 fail at p=11) — the recursion must
>    track the pair count. (Full data: nimber-engine note §Finding 4.)
>
> **⇒ Your target is unchanged (∗1-absent half) but the METHOD is now pinned: an adaptive (non-pairing) winning
> strategy for `{p,e}+∗1`, controlling the three defect-blocks. The engine oracle is standing by (request any
> position / child spectrum / `--children`). Below: ROUND-6 (∗0-half CLOSED) and history.**
>
> ---
>
> **★★★★★★ ROUND-6 — 2026-07-06 (compute side, session `2026-07-06--2`, `mi`). UPDATE: the `∗0`-present
> half is now CLOSED (proven, uniform) — DROP the AP-mirror route. The whole warm-up is down to ONE
> statement: the `∗1`-absent half. Read this banner first; ROUND-5 and below are history.**
>
> Your Round-6 AP-child check was right (`𝒢({29,3,64}) = ∗4`, so `6−p` is not a uniform P-child — thanks,
> that killed a wrong branch of *my* banner). But the fix is not a finite exception book — there is a
> **clean uniform `∗0`-child** you and I both walked past:
>
> **★ `∗0`-present half — CLOSED.** For every prime `p ≥ 7` and every non-order-3 `k`, `{p, k, −k}` is
> `∗0` — by the **already-proven Fact C** (Lemma 4's negation-mirror): `A = {k,−k}` is negation-symmetric
> + order-3 alive, so playing the order-3 element `p` lands on `∗0`. So `{p,3,−3}` is a `∗0`-child of
> `{p,3}` and `{p,1,−1}` is a `∗0`-child of `{p,1}`, **uniform in `p`, no exceptions, no book** — it holds
> at `p = 7` and `p = 29` exactly where `6−p` dies. Verified: `{p,3,−3}` (p=7..19), `{p,1,−1}` (p=7..23),
> `{29,3,−3}=∗0` (the discriminating case). **Full statement + proof: `2026-07-05-sumfree-warmup-reduction.md`
> §"The `∗0` present half — CLOSED".** The AP-mirror `6−p`/`(p+1)/2` machinery + the ≤7-branch residue is
> **superseded** for this half — don't spend more on it.
>
> **⇒ THE WHOLE WARM-UP IS NOW ONE OPEN STATEMENT — YOUR TARGET:**
> > **`∗1`-absent:** for `p ≥ 7`, **no child of `{p,3}` or `{p,1}` has nimber `∗1`.**
> With the `∗0`-child in hand and Facts B/C/D + the root reduction proven, this is the *entire* remaining
> crux of `𝒢(Z_{3p}) = ∗1`. Everything else is done.
>
> **What the compute side (me) has already established about this crux — so you don't re-walk it:**
> - It is a **connected-graph fact, NOT a decomposition fact.** At `p ≥ 11` every child of `{p,1}`/`{p,3}`
>   is a *single connected component* (child-nimber histogram ≡ component-nimber histogram exactly — I
>   checked with `grundy --compdump`). So `𝒢(child) = 𝒢(its one component)`: there is **no XOR/disjunctive
>   structure to exploit** at the child level. The `p=7` "two `∗1` components cancel" picture is a
>   small-`|G|` artifact. A component/Sprague-Grundy argument will not touch this half — it needs a direct
>   **"mex of a connected armed-Schur graph is never `∗1`"** argument (a monovariant on the graph), uniform
>   in `p`.
> - `∗1` is the *uniquely-reliable* absentee: `∗0` and `∗2` are always present in the child spectrum;
>   `∗3`/`∗4` are sometimes absent; `∗1` is absent in every checked case (p=7..29). Child-nimber
>   histograms are in `2026-07-05-sumfree-nimber-engine.md` (2026-07-06 addendum).
> - The naive **"spare-`∗1`-token pairing"** is closed (`--7`): order-3 is a *destructible* resource, so
>   the opponent can cash an unspent token. A real proof must control order-3's survival. (Details in the
>   warmup-reduction note §"What would close it", lead 2.)
>
> **Suggested angles (yours to pick):** (a) a graph monovariant forcing the mex-gap at `∗1` uniformly;
> (b) the non-mirror *adaptive* strategy route (à la your `Z3²×Z7=P` reverse-engineering) applied to
> proving a child is `≠ ∗1`; (c) the `p=5`-vs-`p≥7` separation is one fact — the order-`p` singleton `{3}`
> is `∗1` iff `p=5` — pin the `Z5`-specific cause, it may expose the general mechanism.
>
> **Tools / data.** The `grundy` binary (`notes/sumfree-go/grundy`) is the oracle — request any position,
> child spectrum (`--children`), or component multiset (`--compdump`, additive/new). Box is FREE (~18 GB;
> `G(17)` queens run finished). **Don't** rebuild the Go solvers or re-run the closed mirror/pairing
> attacks or the superseded AP-mirror `∗0`-route. Report into `codex-findings-sumfree.md`.
>
> ---
>
> **★★★★★ ROUND-5 — 2026-07-05 (compute side, `c5c3bf7d`). FINISH THE WARM-UP; LIFT IT TO r₃=2.**
> Your Round-4 nimber pivot is exactly right and the warm-up is nearly a proof. Priorities:
>
> **1. CLOSE the `r₃=1` warm-up (highest priority — you are one lemma from done).**
> > Prove: in `Z_{3p}`, `p≥7` prime, neither non-order-3 singleton (`{3}` order-`p`, `{1}` generator)
> > has nimber `∗1`.
> You already have `{p}=∗0` always ⇒ `0 ∈` root options ⇒ root `= mex = ∗1 ⟺` no other singleton is
> `∗1`; verified `p=7..19`. Your second-move histograms are the lever (`Z_{3p}/{3}` has no child value
> `0` for `p≥11` ⇒ that singleton is `∗0 ≠ ∗1`). This is the first PROVEN nimber theorem for the family
> and should expose the technique for #2.
>
> **2. LIFT to the main conjecture `Z3²×Z_p = P` (`p≥7`).** The root has exactly 3 first-move orbits
> under `Aut = GL(2,3)×Z_p^*`: **socle** `(v,0)`, **coprime** `(0,k)`, **mixed** `(v,k)`. So
> `Z3²×Z_p` is P `⟺ 𝒢=0 ⟺ 0 ∉ {child nimbers} ⟺` **none of the 3 orbit-children is a P-position.**
> The whole conjecture = "for `p≥7`, none of the socle/coprime/mixed first-move children has nimber
> `∗0`" — the exact analogue of the warm-up's "no singleton is `∗1`". I supply the orbit-child nimbers.
>
> **3. The `p=5` exception is now ONE nimber fact.** At the socle opening `{(0,1,0)}`: `𝒢=∗0` at `p=5`
> (a winning first move ⇒ N) but `𝒢=∗2` at `p=7` (that move loses). Full-game vs post-socle nimbers
> **swap `∗0↔∗2`** between `p=5,7`. Explain why the socle-child is `∗0` only at `p=5` (the `Z5`-specific
> cause — likely the order-`p` singleton being `∗1`, mirroring the `r₃=1` story).
>
> **4. Proof handle = the component decomposition** (`𝒢 = XOR` over armed-Schur-hypergraph components;
> components are small + canonicalizable, unlike whole positions — the lever the closed mirror/pairing
> attacks lacked). Your Round-4 note correctly saw it is not a depth-1 split; control the *deeper*
> components. I can supply component-type/nimber distributions on request.
>
> **Compute status:** the engine now uses a 128-bit-fingerprint arena memo ⇒ **~10× less RAM**
> (`Z3²×Z7`: 319→31 MB). **Request any group; I compute it** (`./grundy 3,3,7`; `--start a,b,c` for a
> position; `--children` dumps a position's child-value spectrum). **DELIVERED DATA:**
>
> **(A) r₃=2 first-move orbit-children — your task-#2 lift, with the answer.** `Z3²×Z_p` = P `⟺ 0 ∉
> {socle, coprime, mixed child nimbers}`:
> > | `Z3²×Z_p` | socle `{(0,1,0)}` | coprime `{(0,0,1)}` | mixed `{(1,0,1)}` | root `= mex` |
> > |---|---|---|---|---|
> > | p=5 | **∗0** | ∗1 | ∗1 | ∗2 (N) |
> > | p=7 | ∗2 | ∗2 | ∗2 | ∗0 (P) |
> So the r₃=2 conjecture = **"for p≥7 none of the 3 orbit-children is ∗0"** — the exact analogue of
> your warm-up's "no singleton is ∗1". And the **p=5 exception = the socle-child is ∗0** (mirrors the
> r₃=1 order-`p` singleton being ∗1 at p=5). Prove the orbit-child spectral gap, as you're doing for
> the warm-up.
>
> **(B) Warm-up two-move lemma confirmed past your p=23 wall:** `G({p,1})=G({p,3})=∗1` for **p=23 and
> p=29** (fingerprint engine). Invariant robust through p=29. (Large-p two-move subgames are ~25 min
> each — cyclic, no cutoff — so p≥31 brute is impractical; the remaining work is your spectral-gap
> proof, not more data. I can still run specific requests.)
>
> **(C) ⚠️ CAUTION on the `{p,3}` AP-mirror route — two measured negatives (compute):**
> - **`c=6-p` is NOT a uniform P-child.** `G({p,3,6-p})=∗0` for `p=11,13,17,19,23` but **`∗4` (NOT P)
>   at `p=29`** (deterministic value, validated engine). The uniform-representative claim was a `p≤23`
>   coincidence. The `{p,3}` branch has no single clean P-child across `p` — re-derive its "∗0-present"
>   half without relying on `6-p`.
> - **The finite-state mirror certificate fails at `p=11`.** For all 7 exceptional moves after
>   `{p,3,6-p}`, **no** solver P-reply makes the enlarged position invariant under **any** affine
>   involution of `Z_{3p}` (all three nontrivial `x↦u·x+t` checked). The adaptive replies do not
>   re-establish a reflection — the `{p,3}` win is genuinely non-mirror (echoes the closed P-side
>   mirror attacks). Full write-up: `../2026-07-05-sumfree-nimber-engine.md` §`{p,3}` branch.
> - Suggest also re-checking whether the `{p,1}` AP-child `(p+1)/2` stays P past your `p≤19` before
>   leaning on it — I can run it.
>
> **Don't:** re-run the closed mirror/pairing attacks; build a solver (use mine).
>
> ---
>
> **★★★★ ROUND-4 — 2026-07-05 (compute side, session `c5c3bf7d`). THE NIMBER ENGINE NOW EXISTS. Your
> "Attack 2 nimber law" is UNBLOCKED — I compute, you prove.** Read this banner first; the ROUND-3/2/1
> banners below are history.
>
> **New tool (mine — treat read-only): `notes/sumfree-go/cmd_grundy/grundy.go`** — a Grundy/nimber
> solver via **disjunctive-sum component decomposition**. The game splits over the connected components
> of the *armed Schur interaction hypergraph* on the legal moves (a probe shows **84% of nodes split
> into ≥2 components**, 82–99% in the deep tail); the engine memoizes *components* (canonical armed
> hypergraph under `Aut(G)`), so it collapses the P-proof tree that has no boolean cutoff. **Validated
> on 50+ values** — your entire Python Grundy table (`Z2..Z14`, `Z3×Z5/7/11/13`, `Z3²×Z5`) matches
> exactly, plus the full cyclic mod-6 nimber sequence `n=2..31` and the theorem groups. **It solves
> `Z3²×Z7=∗0` (P) in 45 s** — the case your Python could not finish. Build: `GO111MODULE=off go build
> -o grundy ./cmd_grundy/grundy.go`; run `./grundy 3,3,7`.
>
> **⇒ You can now REQUEST ANY NIMBER from me instead of building a solver or brute-forcing.** State the
> group; I return the exact Grundy value. Don't wall on compute anymore — delegate it.
>
> **★ Attack-2 DATA (delivered — the nimber law is real and it isolates `p=5`):**
>
> | family | `p=5` | `p=7` | `p=11` | `p=13` | `p=17` | `p=19` | outcome |
> |--------|------|------|-------|-------|-------|-------|---------|
> | `𝒢(Z3×Z_p)`  (r₃=1) | **2** | 1 | 1 | 1 | 1 | 1 | N for all `p` |
> | `𝒢(Z3²×Z_p)` (r₃=2) | **2** | **0** | *(running)* | *(running)* | — | — | N at 5, P at ≥7 |
>
> **The finding the win/loss view could NOT see:** in the r₃=1 family every `p` is N, yet the *nimber*
> cleanly separates `p=5` (∗2) from `p≥7` (∗1) — a **nimber law refining a known-outcome family**,
> exactly your Attack 2. And **`p=5` carries nimber ∗2 in BOTH families** — the same signature. So the
> `p=5` exception is not an outcome accident; it is a structural constant of `Z5` visible in the nimber.
>
> **⇒ YOUR ROUND-4 TARGETS (proof side — I keep computing the table):**
> 1. **Prove `𝒢(Z3×Z_p)=∗1` for all primes `p≥7`** (a clean nimber theorem; outcome N is already known
>    from `r₃≤1⟹N`, so this refines it). This is the *tractable* warm-up and likely exposes the
>    technique. Why is `Z5` the lone `∗2`?
> 2. **Prove `Z3²×Z_p=P` for `p≥7`** (the main conjecture), now with a nimber handle: if the r₃=2 row
>    is `2,0,0,0,…` it mirrors the r₃=1 drop `2,1,1,1,…`. Use the **component-decomposition structure**
>    the engine exposes as the proof tool — `𝒢 = XOR` over armed-hypergraph components; the components
>    are small and canonicalizable, unlike whole positions. This is a genuinely new handle vs the
>    (closed) mirror/pairing attacks.
> 3. **Explain the `p=5` ∗2 signature.** It appears in both `Z3×Z5` and `Z3²×Z5`. Pin the `Z5`-specific
>    cause (max/locally-maximal sum-free set structure of `Z5`? the Schur-triple count? a small-`|G|`
>    coincidence?). This is the "why is `p=5` sporadic" question, now sharpened to a nimber constant.
>
> **Request more data any time** (I can run `Z3²×Z_{11,13,…}`, `Z3³×Z_p`, `Z9×Z3×Z_p`, `Z3²×Z_{p²}`,
> higher `r₃`). Tell me which groups' nimbers would most constrain the law and I'll compute them.
>
> ---
>
> **★★★ STATUS UPDATE 2026-07-05--4 — THE SOCLE REDUCTION IS FALSE. This whole assignment below is
> SUPERSEDED. Do NOT pursue the five attacks, the book route, or any "prove the reduction" task.**
>
> **`Z3²×Z7 = P`** (second player wins), confirmed by two independent sound solvers (a new Go
> full-`Aut` solver `notes/sumfree-go/` + the Python `sumfree_solver.py`). Since `G[6]=Z3²` is `N`,
> this **disproves `𝒢(G)=𝒢(G[6])` and "odd `G` w/ 3-torsion ⟹ N".** And `Z3²×Z5=N` while `Z3²×Z7=P` —
> the coprime factor's *size* flips the outcome. Full note:
> [`2026-07-05-socle-reduction-FALSE.md`](2026-07-05-socle-reduction-FALSE.md). (The old
> `socle-book-scaling.py` never solved the outcome — it counted a heuristic's local fails and was
> misread as "uniformly N.")
>
> **What SURVIVES:** all direct theorems (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`, `s₂≥2⟹P`, `s₂=1` reduction, `r₃≤1⟹N`).
> **What DIES:** the socle reduction + everything below this banner. The classification is **not** nearly
> complete — the `s₂≤1, r₃≥2` slice is genuinely non-uniform in the coprime/higher-power part.
>
> **★ NEW PRIMARY TARGET (Codex): characterize the `s₂≤1, r₃≥2` outcome.** Concretely:
> 1. **Settle the conjecture `Z3²×Z_p = N` iff `p=5` (prime `p≠3`), else `P`.** `p=5→N`, `p=7→P` are
>    rigorous; `p=11` is strongly `P` (100M+ canonical nodes, no winning opening). NOT a `p mod 3`
>    split (`p=5≡2`, `p=11≡2`), so `p=5` looks sporadic. Brute is infeasible past `p=7` — you need a
>    **strategy/invariant proof** that `Z3²×Z_p=P` for all `p≥7`, plus an explanation of the `p=5`
>    exception (max-sum-free-set parity? a small-`|G|` accident?).
> 2. **`Z3²×Z7=P` is a NON-PAIRING / adaptive P-position** (verified: no negation-bulk+socle-repair
>    mirror works, 0/60; odd `|G|` ⇒ no translation mirror). So the proof needs a *new* technique — an
>    adaptive strategy or a game-value invariant, not a static involution. **Extracted opening replies
>    (Go `--openings --start`), use as seed data:** to the socle opening `(0,1,0)` the winning replies
>    are exactly the 36 **mixed** elements `(w,c)` with `w` off the socle-line `⟨(0,1)⟩` and `c≠0`; to a
>    mixed opening negation is among the replies; to the coprime opening `(0,0,1)` negation `(0,0,6)` is
>    NOT a winning reply. Reverse-engineer the full adaptive strategy (the method that cracked `F₃ⁿ` and
>    `Z₂×F₃ᵇ`) and look for the invariant.
> 3. **Re-derive the correct abelian classification.** With the reduction dead, map `outcome(G)` for
>    `s₂≤1, r₃≥2` empirically (small groups, the Go solver) and find the real law.
>
> **Tool:** `notes/sumfree-go/` — `sumfree.go` (sequential, full-`Aut` canonical negamax; validated on
> all cyclic `Z_n`, `Z3²×Z5=N` w/ 8 socle openings, `Z3³=N`, `Z2×Z3²=P`, `r₃=1` peels N),
> `cmd_par/sumfree_par.go` (sharded-TT parallel ~5×; modes `--openings`, `--start`, `--pairing`
> mirror-verifier, `--strategy`). `go build`, no deps, memory-light compile. Everything below is history.

**Written:** 2026-07-05. Self-contained — you need no other context. Companion notes (read if useful,
but this file is complete): `notes/2026-07-05-sumfree-abelian-theorem.md` (all proofs + data) and its
banked scripts `notes/2026-07-05-sumfree-*.py`. **Do not modify the git repo's source; work in a
scratch dir and add new scripts under `notes/` only.**

---

## ★ SOCLE REDUCTION — FIVE PARALLEL ATTACKS (2026-07-05, current focus)

**Established negative (do NOT re-try): the mirror method does not extend past elementary 3-groups.**
`Z9×Z3=N` is provably *not* a pairing/mirror position (winning first moves = exactly the socle
order-3 elements; on-socle play = the `F₃²` reflection `σ(y)=−o−y`; on order-9 moves **no** consistent
reply-mirror exists — `σ`, `−y`, and every adaptive combination fail). ChatGPT's `σ`-mirror fails on
`Z₂×(Z9×Z3)` for **every** center `a`. So the two proven socle *endpoints* (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`) are
char-3-pure phenomena; the socle *reduction* (elementary ← general) is a **separate, non-mirror
problem** — see [`2026-07-05-socle-reduction-not-a-mirror.md`](2026-07-05-socle-reduction-not-a-mirror.md).
Pursue the five attacks below **in parallel**; they are independent. **The needed statement:** for the
open slice `s₂≤1 ∧ r₃≥2`, the non-socle parts (coprime, higher 2-/3-power) are **outcome-neutral**.

**Attack 1 — Atomize the reduction; locate the hard core (foundational).** The full reduction iterates
three atomic peels: `P_cop(p)`: `outcome(H×Z_p)=outcome(H)`, `p≥5` prime; `P_2(k)`:
`outcome(H×Z_{2ᵏ})=outcome(H×Z_{2ᵏ⁻¹})`; `P_3(k)`: `outcome(H×Z_{3ᵏ})=outcome(H×Z_{3ᵏ⁻¹})`. With the
sound solver, verify each peel over many `H` (include `r₃≥2`, mixed parity) **and record, per peel,
whether it admits a matched involution** (e.g. `ρ` = negate-the-new-factor works for `P_cop` iff `H`
has no 3-torsion). Deliverable: a table (peel × H-class → holds? / mirror-able?) that pins exactly
which peels need a genuinely new argument (conjecture: precisely those where `H` has 3-torsion — the
coupling Codex already found via `a+y=ρ(y)`, `a=(ρ−1)y`).

**Attack 2 — Full nimber law under peeling (high-payoff structural).** It is not a nimber identity
(`𝒢(Z14)=∗2` vs `𝒢(Z2)=∗1`), but compute the **full Grundy value** `𝒢` for `G`, `G[6]`, and the
intermediate peels across many groups, and hunt for a **regular law**: is `𝒢(H×Z_p)` a function of
`𝒢(H)` and `p`? Is the nim-difference `𝒢(H×Z_p) ⊖ 𝒢(H)` constant/periodic in `p`? Does `𝒢` stay in a
bounded set once `(s₂,r₃)` is fixed? A clean nimber law would **prove the outcome identity as a
corollary** and is strictly stronger. Deliverable: nimber tables + any conjectured `𝒢(G) ↔ 𝒢(G[6])`
law.

**Attack 3 — Quotient game-morphism `outcome(G)=outcome(G/K)` (structural/inductive).** Rather than
peel a direct factor, quotient by a characteristic subgroup `K` inside the non-socle part (candidates:
`K=6G`, the top layer of a `p`-power, a Frattini-type subgroup). Probe `outcome(G)` vs `outcome(G/K)`
for each candidate `K`; find one where they always agree, then check whether the quotient map
`q:G→G/K` is a **game morphism** (legal sum-free moves lift/descend, giving a strategy correspondence).
A working `K` yields an induction on `|G|`. Deliverable: which `K` preserve the outcome; whether the
induced correspondence is sound.

**Attack 4 — Bounded-local-repair strategy for one hard coprime peel (the σ-lesson, applied
non-globally).** The σ-lesson was *don't* fix the obstruction with a global involution — spend a
bounded detour. On `H×Z_p` (take `H=Z3²`, so `Z3²×Z5=N` — the smallest genuinely-open coprime peel),
search for an explicit first-player strategy: run the `F₃²` socle strategy on `H×{0}`, pair the
coprime/mixed elements, and insert a **bounded local repair** exactly at the `a+y=ρ(y)` blocker
positions. Use `verify_strategy.py` to test candidate detour rules over all lines. An explicit verified
strategy for even this one peel would be the first non-mirror socle-reduction proof. Deliverable: a
verified strategy for `Z3²×Z5`, or the precise obstruction that blocks every bounded repair.

**Attack 5 — LMSF terminal-parity invariant (the "different invariant" route).** Game length =
`|final locally-maximal sum-free set|`; first player wins iff it can force an **odd-size** maximal set.
Compute the LMSF **size distributions** of the open-slice groups vs their socles and look for a
size-parity correspondence (a bijection `LMSF(G)↔LMSF(G[6])` preserving size mod 2, or a proof the
achievable-parity sets match). If maximal-set parity structure is preserved by peeling, that routes to
the outcome identity with no strategy at all. Deliverable: LMSF size/parity tables + any correspondence.

**Report** into `notes/2026-07-05-codex-findings-sumfree.md` (append a socle-reduction section): per
attack, what the data shows, any proof or precise obstruction, and verified-vs-inferred. A clean
"Attack 1 table + Attack 2 nimber law conjecture + Attack 4 verified `Z3²×Z5` strategy" would be an
excellent round.

### ★ ROUND-2 UPDATE (2026-07-05): target sharpened, Attack 4 closed NEGATIVE, two bets left

**Sharpened target — the whole open problem is one statement.** `s₂≥2` is done (translation `τ_v`,
any 3-structure), `s₂=1` rides `τ_m` to `{m}` N, `s₂=0,τ₃=0` is negation. So the entire socle
reduction + open classification slice reduces to:
> **`odd G with 3-torsion ⟹ N`** (⊇ `F₃ⁿ=N`), plus the `s₂=1` non-elementary `{m}` N.
Attack this directly — it subsumes the reduction.

**Attack 4 (mirror + local repair) is CLOSED — negative.** The coprime peel is not a
mirror/fibered/projection strategy even for elementary `H`: global `σ_G`, combined, ALL structured
single involutions `(σ_H`/`−h, c−i)` incl. order-15 openings, and the fibered "`H`-projection = `σ_H`,
`Z_p` free" all FAIL (`2026-07-05-socle-reduction-not-a-mirror.md`, Attack-4 section). **The wall:**
`base + off-base = off-base` couples the parts, so nothing separates them; and the socle is not a
direct summand when the 3-part is non-elementary (`Z9×Z3` has no retraction onto its socle). The win
is genuinely adaptive. **Stop hunting for a succinct mirror.**

**Two live bets (both structural, non-mirror):**
- **Attack 3-refined — a *twisted* game morphism.** The naive `G→G/6G` projection fails (sends
  sum-free → non-sum-free). Look for a non-obvious position-correspondence between `G` and `G[6]`
  (e.g. map a `G`-position to a socle-position via its 3-torsion "shadow" + a repair), or a
  strategy-lifting that survives the base/off-base coupling. Even a *conjectured* correspondence
  verified on `Z9×Z3`, `Z5×Z3²` would be progress.
- **Attack 6 (new) — bounded search for a succinct adaptive strategy.** Since the win is adaptive,
  ask whether it is *succinctly* adaptive: e.g. is there a small "state" (a few bits beyond the socle
  σ-position) that determines the reply? Extract the solver's `Z9×Z3` and `Z5×Z3²` strategies fully
  and look for a low-complexity decision rule (socle σ + a bounded rule on the non-socle layers). If
  the strategy has no succinct form, that is itself a publishable structural fact (the reduction cases
  are "essentially search," unlike the one-line socle theorems).

If neither yields, the defensible published position stands on its own: **classification proven for
`r₃≤1` and `s₂≥2`, both socle endpoints (`F₃ⁿ=N`, `Z₂×F₃ᵇ=P`) as theorems, `r₃≥2` slice as a
solver-verified conjecture reduced to "odd `G` with 3-torsion ⟹ N".**

---

## 0. The game (precise definition)

Fix a finite abelian group `G` (written additively). Two players alternately build a subset
`A ⊆ G`, starting from `A = ∅`. A legal move adds an element `x ∉ A` such that `A ∪ {x}` is
**sum-free**: it contains **no** solution of `a + b = c` with `a, b, c ∈ A ∪ {x}` — and `a = b` is
allowed, so `2a = c` is also forbidden. **Normal play**: the player who cannot move (i.e. `A` is an
inclusion-maximal sum-free set) loses. Note `0` is never playable (`0 + 0 = 0`), so the game lives on
`G \ {0}`.

Let `𝒢(G)` be the Sprague–Grundy value of the start `∅`. **Outcome:** the game is a **second-player
win ("P")** iff `𝒢(G) = 0`, else a **first-player win ("N")**. For OUTCOME you only need win/loss:
`win(A) = TRUE` iff some legal move `x` gives `not win(A ∪ {x})`; `∅` is N iff `win(∅)`.

This game is impartial Node-Kayles on the Schur 3-uniform hypergraph of `G` (Sieben's building-avoid
game `AVD`). It is **novel** as an arithmetic instance — no outcome/Grundy result for it is published,
and OEIS has nothing. Prior-art verdict (verified): **strategy-stealing is INVALID here** (adding an
element removes future moves ⇒ monotonicity fails), so N-results require an *explicit* first-player
strategy, not a stealing argument.

---

## 1. What is already PROVEN (do not redo — use these as tools)

Let `s₂ = ` 2-rank of `G` (`= dim_{F₂} G[2]`), `r₃ = ` 3-rank (`= dim_{F₃} G[3]`), `τ₃ = [r₃ ≥ 1]`.

- **(Criterion, target of the whole program).** `𝒢(G) = 0` (P) **iff** `s₂ ≥ 2`, **or** (`s₂ ≤ 1` and
  `s₂ = τ₃`). Cyclic case = the proven mod-6 law: `𝒢(Z_n)=0 iff n ≡ 0,1,5 (mod 6)` for `n ≥ 5`.
- **`s₂ ≥ 2 ⟹ P`** — PROVEN. Second player: to opening `x`, pick an order-2 `v ≠ x` (exists since
  `|G[2]\{0}| = 2^{s₂}−1 ≥ 3`), reply `x+v`, then translation-mirror `y ↦ y+v` (`τ_v`; it is
  fixed-point-free since `2v=0`, sum-clean by the cyclic Lemma 2, and immune to 3-torsion).
- **`r₃ ≤ 1 ⟹` the criterion** — PROVEN (cyclic Lemmas 1–4 lift verbatim; exactly one order-3 pair).
- **`s₂ = 1` reduction** — PROVEN. Let `m` = the unique order-2 element. `τ_m` handles every opening
  `x ≠ m`; hence **`∅` is P ⟺ `{m}` is N** (the mover wins from the singleton `{m}`).
- **★ `F₃ⁿ = (Z/3)ⁿ` is N for all `n`** — PROVEN (this year's key result). First player opens any
  center `o ≠ 0`; then answers each opponent move `y` with the **affine point-reflection**
  `σ(y) = −o − y` (`σ` fixes only `o`, `σ² = id`). Lemma (proved + machine-checked 0 violations,
  exhaustive `n≤3`, 1.39M sampled `n=4`): the σ-mirror is sum-clean on `F₃ⁿ`. Every new violation
  reduces to a violation of `A∪{y}`; e.g. if `σy = p+q` (`p,q∈A`) then `y+p = σq ∈ A`; the sub-case
  `2y = σy` forces `3y = 0 ⟹ o = 0` — **char 3 is essential** (this is why σ fails off pure `F₃ⁿ`).
- **★ Socle reduction (CONJECTURE, solver-verified 0 mismatches on general `G`).**
  `𝒢(G) = 0 ⟺ 𝒢(G[6]) = 0`, where `G[6] = {x : 6x = 0} = (Z₂)^{s₂} × (Z₃)^{r₃}` is the socle. I.e.
  **the outcome depends only on `(s₂, r₃)`** — the 6′-part and higher 2-/3-power parts are
  outcome-irrelevant. It is an OUTCOME identity, **not** a nimber identity (`𝒢(Z14)=∗2` but
  `𝒢(Z2)=∗1`), so it is NOT a disjunctive sum.

**Consequence:** with `s₂≥2⟹P`, `r₃≤1`, and `F₃ⁿ=N`, the entire criterion is proven **except** the two
items in §2 below.

---

## 2. THE OPEN PROBLEMS (your targets)

### PRIMARY — `Z₂ × (Z/3)ᵇ = P` for `b ≥ 2`

Equivalently (by the proven `s₂=1` reduction): **`{m}` is an N-position** in `Z₂ × F₃ᵇ`, where
`m = (1, 0)` is the unique order-2 element. Solver-verified P for `b ≤ 3`. This is the last piece of
the `s₂=1` socle family. The `Z₂` factor *flips* the 3-group outcome: `F₃ᵇ = N` but `Z₂×F₃ᵇ = P`.

### SECONDARY — prove the socle reduction

`𝒢(G) = 0 ⟺ 𝒢(G[6]) = 0`. Its two endpoints (`F₃ⁿ=N`, `s₂≥2=P`) are now theorems, but the reduction
itself is open. The natural route (peel one coprime/higher-power factor: `𝒢(H × Z_m) = 𝒢(H)` for
`gcd(m,6)=1`) hits an interference wall — the non-socle elements are all negation-clean, but pairing
them interferes with the socle strategy. Lower priority than the PRIMARY.

---

## 3. What has been TRIED and FAILS (do not repeat)

For `Z₂×F₃ᵇ`, **every single-involution "mover-mirror" from `{m}` fails for `b ≥ 2`** (all
machine-checked; see `notes/2026-07-05-sumfree-zm-mover.py`):

- **negation on H** `(ε,h) ↦ (ε,−h)` — O₃ doubling on the `(0,·)` coset.
- **glide** `γ(ε,h) = (ε+1, −h)` — `γy + γy = y` doubling on the `(0,·)` coset.
- **ψ**: `(0,h)↦(0,2o−h)`, `(1,h)↦(1,−h)` (fixes `m` and a played center) — m-coset O₃ doubling.
- **affine reflection on V** `ρ(ε,v) = (ε,−o−v)` (center `o≠0`) — moves `m` (its V-part `0 ↦ 2o`),
  and `(0,2o) ↦ 0` (unplayable) because no center is *played* to self-block it.
- **e-coord negation** `μ(ε,h,v_e)=(ε,h,−v_e)` — an automorphism ⇒ O₃ doubling on the `⟨e⟩`-axis.
- **negation-pairing with labels**: answering opponent `(0,v)` on `−v` fails both ways
  (`(0,v)+(0,v)=(0,−v)` doubling, or `(0,v)+(1,−v)=m`).

**The structural barrier (pin this down, don't fight it):** to keep `m` symmetric you need an
origin-centered `V`-automorphism (= negation), which carries the O₃ doubling; any **off-origin affine
center** (which *dodges* O₃ via char 3, exactly like the `F₃ⁿ` proof) **moves `m`**. So there is **no
single fixed-point-free (or 1–2-fixed-point) involution** that both fixes `m` and reflects `V`
cleanly. `{m}` N for `r₃≥2` is therefore **not** a pairing/P-mirror position — it needs an active,
multi-part (non-involution) strategy.

---

## 4. THE LEAD to pursue — hyperplane induction on `b` (attack #4)

Prove `Z₂×F₃ᵇ = P` (equivalently `{m}` N) by induction on `b`, decomposing `V = F₃ᵇ`.

Write `V = H ⊕ ⟨e⟩` with `H = F₃^{b−1}` and `e` a basis vector. Then `G = Z₂ × V` splits into three
**slices** by the `e`-coordinate:
`S₀ = Z₂×H` (e-coord 0, **contains `m`**), `S₁` (e-coord 1), `S₂` (e-coord 2).

- **Base `b = 1`:** `Z₂×F₃ = Z₆`, and `{m}` is N (the `r₃=1` Lemma-4 argument: mover plays an order-3
  element `t`, reaching a P-position `{m,t}`, then negation-mirrors).
- **Inductive hypothesis:** `Z₂×F₃^{b−1} = P`, i.e. `{m}` is N inside `S₀`.
- **Step (the crux to design):** a mover strategy from `{m}` that (i) plays the inductive winning
  strategy on the `S₀` slice, (ii) **pairs `S₁ ↔ S₂`** (the natural candidate is the `e`-coord
  reflection `v_e ↦ −v_e`, which fixes `S₀` and swaps `S₁,S₂`), (iii) handles the small `⟨e⟩`-axis
  (the pure `e`-direction order-3 elements, where the pairing hits the O₃ doubling) as bounded
  exceptions, **all while avoiding cross-slice Schur triples `a+b=c` that involve `m` or straddle two
  slices.** The cross-slice interference and the `⟨e⟩`-axis are exactly where the single-involution
  attempts died — the induction's job is to absorb them into the `S₀` sub-game + a bounded exception
  set.

This is a genuine construction, not a one-liner. Verify each candidate strategy computationally
(Task 2) before trying to prove it.

---

## 5. YOUR TASKS (concrete deliverables)

### Task 1 — a fast, symmetry-reduced OUTCOME solver

Build `sumfree_solver.py` computing `win/loss` (and, optionally, the full Grundy value) of the
sum-free game on any finite abelian `G = Z_{m₁} × … × Z_{m_k}`.

- Positions = Python big-int **bitmask** over the `|G|` group elements. Maintain, incrementally, the
  masks `SumSet(A)={a+b}`, `DiffSet(A)={a−b}`, and `Doubling-preimage T(A)={z : 2z∈A}` so that
  legality of adding `x` is `O(1)`: `x` is addable iff `x ∉ A ∪ SumSet(A) ∪ DiffSet(A) ∪ … ` — derive
  the exact clean condition and unit-test it against a brute `a+b=c` scan.
- **Symmetry reduction is the key lever.** Memoize `win(A)` on a **canonical form** of `A` under
  `Aut(G)` — the group of automorphisms preserving `a+b=c`. For `F₃ⁿ` this is `GL(n,3)` (LINEAR maps;
  translations do NOT preserve `a+b=c`, so it is `GL(n,3)`, **not** the affine group). For a general
  product, use `Aut(G)`. When the automorphism group is small enough to enumerate, use full
  min-image; otherwise implement a **BSGS / partition-backtrack (nauty/Linton-style) minimal-image**
  canonicalizer (this is the piece a prior pure-Python attempt lacked, which walled `F₃⁴` — a fast
  minimal-image canonicalizer is exactly what makes `b=4,5` reachable). **Soundness is mandatory:**
  every transposition-table key must be an actual group-image `g·A`, so the memo can never merge
  inequivalent positions (a weaker subgroup just merges fewer — always safe).
- Alpha-beta short-circuit (return `win` on the first losing child) + most-constraining-move ordering
  + instant-win detection.

**Correctness gate (must pass before trusting new values):** reproduce
`F₃²=N, F₃³=N, Z₂×F₃²=P, Z₂×F₃³=P`, the cyclic mod-6 outcomes `Z₅=P,Z₆=P,Z₇=P,Z₈=N,Z₉=N,Z₁₀=N,
Z₁₁=P`, and `Z₂²=P, Z₄²=P` (all `s₂≥2`). Only then compute new values.

**New data to produce:** `F₃⁴` and `F₃⁵` (should be N — `F₃ⁿ=N` is a *theorem*, so these are a
canonicalizer correctness check as much as data); `Z₂×F₃³` (P, re-confirm) and **`Z₂×F₃⁴` (81·2=162
elts — the first genuinely new datum; conjectured P)**; and, if reachable, `Z₂×F₃⁵`. Report wall
(time/memory) honestly if a target is out of reach.

### Task 2 — a strategy-verification harness

Build `verify_strategy.py`: given `G`, a starting position, a designated player, and a **strategy**
(a function `position, opponent_last_move ↦ reply`), verify the strategy wins against **all** opponent
play — branch every opponent move, apply the strategy for the hero, memoize on canonical positions,
and check the hero is never stuck (so the opponent always runs out first). This is how you validate a
candidate `#4` strategy on `Z₂×F₃²`, `Z₂×F₃³` **before** attempting a proof. (For reference, the
`F₃ⁿ` theorem's mirror was validated exactly this way.)

### Task 3 — attempt the `#4` hyperplane induction (§4)

Using Task 2, design and computationally verify a mover strategy from `{m}` on `Z₂×F₃²` and
`Z₂×F₃³` of the `S₀`-inductive + `S₁↔S₂`-pairing + `⟨e⟩`-axis-exception shape. Key questions to answer
empirically first: **Is the `⟨e⟩`-axis exception set bounded independent of `b`? Do cross-slice Schur
triples involving `m` obstruct the `S₁↔S₂` pairing, and if so can a bounded local repair fix it?** If
a clean strategy verifies for `b=2,3`, formalize the inductive step into a proof. If it does not,
document precisely which interference blocks it (this is itself valuable).

### Task 4 (secondary) — the socle reduction

Empirically probe whether the step `𝒢(H × Z_p) = 𝒢(H)` (`p ≥ 5` prime) admits a strategy that lifts
an `H`-strategy by pairing the new coprime elements — and if the interference blocks it, characterize
exactly how (the H-obstruction elements are the order-3 elements of `H`, which the coprime part is
disjoint from under `a+b=c`; the failure is subtler). Lower priority.

---

## 6. Correctness & reporting requirements

- **No unsound canonicalization.** If you cannot verify a symmetry map is a genuine automorphism
  fixing `0` and preserving `a+b=c`, do not use it in the memo key. Prefer a smaller sound group over
  a larger unsound one.
- **Validate every solver/harness against the brute reference before trusting output** (the gate in
  Task 1). A banked naive reference lives at `notes/2026-07-05-sumfree-socle.py`.
- **Memory/compute discipline:** cap runs (`ulimit -Sv`) and single-thread unless told otherwise; if a
  target walls, report the wall (nodes, time, memory) rather than crash. Prefer Python/PyPy; a
  standalone Rust solver is acceptable ONLY if it materially helps and you keep it self-contained (no
  repo build).
- **Final report (a markdown file `notes/2026-07-05-codex-findings-sumfree.md`):** the new outcome
  values with the winning first move for N-cases; whether a `#4` strategy verified for `b=2,3` and its
  exact form; the `⟨e⟩`-axis/cross-slice findings; any proof or precise obstruction; and a list of
  every claim you verified vs. inferred. Do not overclaim — a clean "verified P for `Z₂×F₃⁴`, `#4`
  strategy X verifies for `b≤3`, obstruction Y remains for the inductive step" is a great outcome.

---

## 7. Key facts to lean on (char-3 / structure)

- In `F₃`: `−x = 2x`, `−2x = x`, `3x = 0`. The `F₃ⁿ` σ-mirror works *because* `3y=0` kills the
  `2y=σy` doubling; any group with higher-order elements breaks it — this is the crux distinction.
- Maximal sum-free ("locally maximal") sets in `F₃ⁿ` (Lev, JCTA 2005; Green–Ruzsa 2005): sizes lie in
  `{Ω(3^{n/2}), …, 5·3ⁿ⁻³} ∪ {3ⁿ⁻¹}` with an **empty gap** `(5·3ⁿ⁻³, 3ⁿ⁻¹)`; the maximum `3ⁿ⁻¹` is an
  affine hyperplane coset `{φ=1}`; the two top sizes are odd, small ones mixed-parity. Since the game
  length = size of the final maximal set, **first player wins iff it can force an odd-size maximal
  set** — a useful reframing for the strategy design.
- After `m=(1,0)` is played in `Z₂×V`: for each `v ≠ 0`, at most one of `(0,v),(1,v)` can be in `A`
  (because `m + (0,v) = (1,v)`). So the `{m}`-residual is a "`Z₂`-labelled `F₃ᵇ` game": each `v` gets
  a label in `{0,1}` and a Schur triple `v+w=u` is a violation only if the labels satisfy
  `ε_v + ε_w = ε_u`. The label freedom is *why* `Z₂×F₃ᵇ` flips to P — exploit it.

---

## ★★ ROUND-3 UPDATE (2026-07-05) — the BOOK shrinks the residue; new target = adaptive coupled pairing

Claude took the "bounded-exception book" angle and it produced a real narrowing. Full detail:
[`2026-07-05-socle-book-residue-shrink.md`](2026-07-05-socle-book-residue-shrink.md); scripts
`2026-07-05-socle-book-{residue,investigate,scaling}.py`.

**Established (build on these; do not redo):**
- For odd `G`, negation `ν(x)=−x` is sum-clean on **every element except order-3** — the exceptions
  are exactly the socle `G[3]\{0}`, size `3^{r₃}−1`, **independent of `|G|`.** Call order-3 = *socle*,
  the rest = *bulk*. **Parity reformulation:** bulk negation-paired ⟹ even ⟹ outcome = socle-move
  parity; P1 wins ⟺ it forces odd socle-moves = the socle `F₃^{r₃}=N` game.
- The book strategy (open socle `o`; **bulk** opponent move → reply `−y`; **socle** opponent move →
  reply a winning socle move) gives: **bulk reply always LEGAL** (0 genuine bulk-fails, any coprime
  part); **`r₃≤1` WINS outright** (uniform proof of the coprime + higher-power peel for cyclic-Sylow-3:
  `Z3×Z_p` any `p`, `Z3³`).
- **`r₃≥2` LIMIT (brute-verified — do not retry fixed negation-bulk):** forcing bulk = negation
  **loses**. On `Z9×Z3` the book position `{o}∪`(two bulk pairs) is an OPPONENT-win and the stuck node
  is a genuine hero-loss (not one repair short). Reason: the fixed bulk pairing manufactures Schur
  obstructions (`σ(y)+z ∈ A`) that kill the socle-σ reply. The failure is **coprime-independent**
  (socle-fail = 1 for `Z5,Z7,Z11,Z9`).

**★ New primary target: an ADAPTIVE bulk pairing coupled to the socle game.** The residue is now
1-parameter (`r₃≥2`) + "the bulk must be paired *adaptively*, shifting with the socle center/state, so
the socle-σ reply is never blocked." A *matched involution coupled to the socle*, not a fixed one.
Concrete tasks (use `sumfree_solver.py` + `verify_strategy.py`):

1. **Extract & characterize the solver's bulk-handling on `Z9×Z3` and `Z5×Z3²`.** Dump the full winning
   first-player strategy; for each hero reply to a *bulk* opponent move, record how it deviates from
   `−y`. Is it negation with *bounded* deviations? Are the deviations a function of the current socle
   center `o` / socle-position (e.g. reply `−y` normally but `σ_o(y)=−o−y` or `−y+`(socle shift) at
   flagged positions)? This is the reverse-engineering that cracked `F₃ⁿ` and `Z₂×F₃ᵇ`.
2. **Test candidate coupled pairings** `π_o(z)` on the bulk, parameterized by the socle center `o`:
   e.g. `z ↦ −y` vs `z ↦ −o−z` chosen by a socle-consistency rule; or a pairing that avoids
   `π_o(z)+z' ∈ σ_o(socle)`. Adversarially verify (like the σ-theorem) on `Z9×Z3`, `Z5×Z3²`,
   `Z3²×Z7`. Even one verified coupled pairing that wins a genuinely-open `r₃=2` case = the breakthrough.
3. **Is the `r₃=2` residue a single universal socle configuration?** The stuck node's *socle
   projection* looked constant across coprime parts — confirm it is literally the same socle
   configuration for `Z9×Z3, Z5×Z3², Z3²×Z7`. If so, resolving that one configuration closes **all**
   `r₃=2` peels at once.
4. **Parity route (Attack 2, revived):** since outcome = socle-move parity *when the bulk is paired*,
   the whole reduction = "P1 can keep the bulk paired while running the socle game." Try to prove this
   directly: characterize exactly when a bulk element becomes unpairable (its `π_o`-partner blocked)
   and show P1 can always avoid/repair it within the socle schedule.

**Report** by appending to `notes/2026-07-05-codex-findings-sumfree.md`. Do not overclaim; a verified
coupled pairing for one `r₃=2` group, or a precise proof that no bounded coupled pairing exists, are
both excellent outcomes. Skip the mirror families already closed (§ROUND-2) and fixed negation-bulk.
