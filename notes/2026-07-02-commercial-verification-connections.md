# Commercial connections survey: solver + Lean assets → verification & LLM-agent markets

**Date:** 2026-07-02
**Scope:** map STRONG vs LOOSE connections from this team's assets to (a) software/model
verification and (b) LLM agent planning, with a candid commercial view. Compiled from five
parallel web-research passes (certifying model checkers / explicit-state MC / ITP-services &
certification / LLM-agent search & verification / agent-safety formal methods) run 2026-07-02.
Claims are tagged `[web-verified: URL]` (checked by a research pass today), `[recalled-unverified]`,
or `[judgment]` (our inference). Companion docs: [solver-theory targets](2026-07-02-solver-theory-targets.md)
(the V1/V3 certificate program, T1/M1 law targets), the three 2026-07-02 proposals, and
[queens-n18-paper.md](queens-n18-paper.md) §3–4 (the engineering assets).

**Assets assumed (calibration, not re-argued):** (1) the exhaustive solver — 10^11-node-scale
search on one box: lockless single-word fingerprint TT at multi-GB scale, D4+iso
canonicalization, dense endgame tables (`getK`/W_K), huge-page memory engineering, measured
re-expansion/oversubscription phenomenology incl. a thrash→converge transition, interleaved-A/B
bench discipline; (2) the Lean 4 + mathlib pipeline heading to a certificate format + verified
checker ("DRAT for game solving", V1/V3); (3) emerging empirical laws (T1 re-expansion, M1
move-ordering); (4) CGT results (n=18, A344227 nimber extensions).

---

## Ranked summary table

Rank = connection strength × commercial credibility, jointly. "Who pays" is the *observed*
payer, not the hoped-for one.

| # | thread                                                                | strength (asset→need)          | commercial reality                                                     | minimal first move                                                  |
|---|-----------------------------------------------------------------------|--------------------------------|------------------------------------------------------------------------|----------------------------------------------------------------------|
| 1 | A2. Explicit-state engine transfer (TLC fingerprint set / symmetry; DST à la Antithesis) | **STRONG technique / moderate market** | Antithesis $105M Series A Dec 2025; TLA+ Foundation grants $1k–$100k (AWS/Oracle/MS-funded); no product market | TLC `OffHeapDiskFPSet`+symmetry grant/PR; talk to Antithesis          |
| 2 | B6. Verifier-in-the-loop / verified codegen ("LLM proposes, solver disposes") | **STRONG thesis / market forming** | Harmonic $1.45B val., Axiom ~$264M raised "prove AI code safe", Certora AI-coding pivot, AWS Kiro/Bedrock AR | Ship V1 artifact; pitch search-engineering of the verifier loop       |
| 3 | A4. Lean-at-scale competence → math-AI labor + zk grant market         | **STRONG (labor/grants, not product)** | $170–200/hr Lean contracting; Harmonic/Axiom/Math Inc hiring; EF Verified zkEVM $20M open grants | Publish cert+checker result loudly; apply zkEVM grants / lab contracts |
| 4 | A1. Certificate format + verified checker (V1 itself)                 | **STRONG science / LOOSE direct commerce** | HWMCC certs mandatory since '24 — but every checker in the ecosystem is free academic software; AWS hires, doesn't buy | Build the artifact (V3→V1), present at CAV/SAT/ITP — it is the credibility engine for #2/#3 |
| 5 | B5. M1 move-ordering law → test-time-compute economics                 | **moderate** | No vendor exposes tree search; explicit search lives only in math/code (Harmonic, AlphaProof); law is missing from the scaling literature | Paper: the law measured on a verifiable agent domain (Lean proof search / SWE-bench) |
| 6 | C. T1 TT phenomenology / perf-methodology as a service                 | **moderate as insight / LOOSE as service** | No standalone buyer; folds into #1 (DST) and #5 (inference economics)   | T1 paper as planned; cite it into #1/#5 conversations                  |
| 7 | A3. Safety-critical certification (DO-178C/DO-330 qualified checker)   | **LOOSE now, real long-term** | CompCert credit-claim landed 2026 after ~a decade at Airbus; program-length sales cycles, track-record-gated | None solo; partner/subcontract (AbsInt/Galois-shaped) if ever          |
| 8 | B8. Formal methods for agent safety (action-space reachability)        | **LOOSE commercially** | Enterprises buy red-teaming/GRC; AWS shipped the single-step layer free (AgentCore Policy, GA Mar 2026); money = gov grants (ARIA £59M, DARPA) | Open-source multi-step MCP-tool-graph reachability checker; grant rounds |
| 9 | B7. TT-style memoization for agent fleets                              | **LOOSE product / sharp insight** | Semantic caching crowded and measurably failing; provider prompt caching is exact-*prefix* (path, not state); no exact-state product exists | A note/paper: "agent caching is a canonicalization problem" — the field is arriving there without our toolkit |

---

## A. Software & model verification

### A1. Certifying model checkers & the certificate/verified-checker niche

**(a) Connection.** V1 ("DRAT for game solving") is the games instance of the exact movement
the model-checking world just completed: HWMCC made safety certificates mandatory in the
bit-level track at HWMCC'24 and kept it for '25 (AIGER witness circuits checked by Certifaiger,
whose SAT queries can emit DRAT/LRAT for a verified checker)
[web-verified: https://hwmcc.github.io/2024/, https://github.com/Froleyks/certifaiger,
https://cca.informatik.uni-freiburg.de/papers/FroleyksYuPreinerBiereHeljanko-CAV25.pdf].
Our certificate-format + Lean-checker competence maps 1:1 onto that ecosystem's shape —
including the fresh Lean prior art PBLean (VeriPB pseudo-Boolean certificates imported into a
Lean 4 reflection checker) [web-verified: https://arxiv.org/abs/2602.08692].

**(b) Strength.** STRONG as science (the lane V1 targets is real, cresting, and open for
games); **LOOSE as direct commerce**.

**(c) Commercial reality.** No company sells verified proof checkers or certificate formats —
drat-trim is Heule's personal repo, cake_lpr is Tan/Heule/Myreen, all free, all grant-funded
[web-verified: https://github.com/marijnheule/drat-trim, https://cakeml.org/checkers.html].
EDA vendors (JasperGold/VC Formal/Questa) emit **no** per-run certificates — their trust
product is TÜV tool-qualification kits, an already-paid-for competing answer
[web-verified: https://www.onespin.com/press-events/in-the-news/details/news/detail/News/tool-qualification-kit-from-onespin-certified-according-to-iso-26262-iec-61508-and-en-50128/].
AWS demonstrably *wants* proof-emitting solvers (DRAT for SMMT "used in production")
but the pattern is hire-don't-buy
[web-verified: https://assets.amazon.science/45/c8/bc0875b84cb3b5119cfbacc2e216/drat-proofs-of-unsatisfiability-for-sat-modulo-monotonic-theories.pdf].
And the pointed negative: nobody ever paid to certify Schaeffer's checkers proof — it remains
un-certified [web-verified: https://spectrum.ieee.org/checkers-solved]. **Kill loudly: a
2-person company selling a game-solving certificate format is not a business** [judgment].

**(d) Minimal first move.** Exactly the staged plan already on file
([stage-1 proposal](proposal-2026-07-02-certified-nimbers-stage1.md)): build the artifact,
publish at CAV/SAT/ITP where Biere/Heule/Froleyks/Szeider will see it. The commercial function
of V1 is **credibility manufacture** for threads A4/B6 — the Proofcraft template: they could
sell proof-engineering services only because seL4 existed first
[web-verified: https://proofcraft.systems/] [judgment].

**(e) Anti-thesis.** The field's norm is that checkers cost nothing; competing with free
requires a compliance or liability driver that game solving lacks. Takizawa's adjacent
certificate line is active (scoop pressure on the science, not the commerce).

### A2. Explicit-state model checking — the strongest direct engineering transfer

**(a) Connection.** TLC's engine is, verbatim, our specialty stack in worse form: its
fingerprint set is a lossy 64-bit-hash state set that spills to disk (`OffHeapDiskFPSet`)
[web-verified: https://docs.tlapl.us/codebase:architecture]; its symmetry reduction is
factorial-cost permutation enumeration
[web-verified: https://jack-vanlightly.com/blog/2024/12/5/an-introduction-to-symmetry-in-tla];
SPIN's bitstate hashing is our shared-fingerprint compact slot with a different name
[web-verified: https://en.wikipedia.org/wiki/Bitstate_hashing]. Our lockless flat TT,
iso-canonicalization, huge-page discipline, and re-expansion phenomenology transfer with
almost no translation. And there is a **named, public, unstaffed initiative** to fix exactly
this: Helwer's "One Billion States Per Minute" (TLC ≈1M states/min today, 1000× wanted)
[web-verified: https://ahelwer.ca/post/2025-05-15-tla-dev-status/].

**(b) Strength.** **STRONG on technique — the tightest asset→need fit in this survey.**
Moderate on market size.

**(c) Commercial reality.** Three tiers. (i) TLA+ Foundation (Linux Foundation; inaugural
members AWS, Oracle, Microsoft) runs rolling grants $1k–$100k; none awarded yet on TLC engine
performance — the lane is open, and pays reputation plus small money
[web-verified: https://foundation.tlapl.us/grants/index.html,
https://foundation.tlapl.us/grants/grant-recipients/index.html]. (ii) Product: no one sells an
explicit-state checker; the big TLC users employ their own formal-methods people [judgment].
(iii) **The real money is next door in deterministic simulation testing**: Antithesis raised a
$105M Series A led by Jane Street (Dec 2025), revenue up 12× over two years, customers incl.
Jane Street, Ethereum, MongoDB
[web-verified: https://www.prnewswire.com/news-releases/jane-street-leads-antithesiss-105m-series-a-to-make-deterministic-simulation-testing-the-new-standard-302631076.html].
Our phenomenology (transposition saturation, fingerprint soundness floors,
memory-bound-not-compute-bound diagnosis) is the *science of what their product does*
[judgment]. Note the instructive twist: DST tools deliberately dropped exhaustive visited-state
storage — the market voted scale-of-system over exhaustiveness [judgment].

**(d) Minimal first move.** A measured, interleaved-A/B PR or grant proposal against TLC's
fingerprint set + symmetry canonicalization, framed in billion-states language — cheap, lands
in weeks, and is legible to precisely the people (Helwer/Kuppe/Loncaric) and funders
(AWS/Oracle/MS) who matter. Parallel track: a conversation with Antithesis (partnership or
employment-shaped).

**(e) Anti-thesis.** Revealed preference says state-space *throughput* is not the binding
constraint — practitioners shrink specs by abstraction, and the funded wave (DST, symbolic,
LLM-generated invariants) routes *around* exhaustive enumeration. A 50× faster TLC may be
admired, granted $50k, and change few adoption decisions [judgment].

### A3. Proof-carrying computation / safety-critical certification

**(a) Connection.** The "qualify a small verified checker instead of the big analysis tool"
architecture is the canonical DO-330 cost-reduction trick, and a verified checker for
exhaustive analyses is its natural generalization. The door just visibly opened: AbsInt's
CompCert was qualified for the ATR 42/72 MFC_NG — the first certification credit claimed from
a formally verified compiler under DO-178C/DO-333/DO-330 (announced Mar 2026)
[web-verified: https://www.absint.com/releases/260320.htm].

**(b) Strength.** Conceptually solid, **LOOSE for us now**.

**(c) Commercial reality.** Airbus ran CompCert for roughly a decade before the credit claim
landed — that is the sales cycle in one datapoint
[web-verified: https://aerospace-innovations.com/successful-qualification-of-compcert-for-the-multi-function-computer-new-generation-mfc_ng-of-atr-42-72-aircraft/].
Buyers are primes and their entrenched tool vendors (AbsInt, AdaCore, LDRA); entry is
track-record- and relationship-gated. No evidence of any buyer for "exhaustive state-space
coverage certificates" today [judgment, absence].

**(d) Minimal first move.** None as a solo play. If ever: subcontract into an
AbsInt/Galois-shaped vendor after V1 exists. Treat as a 3-year-plus relationship project.

**(e) Anti-thesis.** The niche supports few players, is liability-shaped, and model-checking
evidence enters certification via qualified tools, not independent certificates — the
incumbent answer is already paid for.

### A4. Lean/ITP industrial services — where the competence sells *now*

**(a) Connection.** "Verified checkers for LARGE computations" is a scarce senior-Lean skill
profile, and the buyers of Lean skill are visible and funded: Harmonic ($120M Series C at
$1.45B, Nov 2025; Aristotle = MCTS proof search against a Lean verifier)
[web-verified: https://siliconangle.com/2025/11/25/harmonic-ai-raises-120m-1-45b-valuation-advance-mathematical-reasoning/];
Axiom Math ($64M seed then a reported $200M Series A, Mar 2026, explicitly "prove AI-generated
code is safe")
[web-verified: https://siliconangle.com/2026/03/12/verifiable-ai-startup-axiom-raises-200m-prove-ai-generated-code-safe-use/];
Math Inc (Szegedy; DARPA expMath); AWS (Cedar verified in Lean; AR-group postings list Lean)
[web-verified: https://lean-lang.org/use-cases/cedar/]. Expert Lean contracting advertises
$170–200/hr [web-verified: https://www.alignerr.com/jobs/77a38d54-e818-46d6-b863-13101973a2d8].
A direct grant lane exists: the Ethereum Foundation's Verified zkEVM project ($20M over ~3
years, Lean-native, open applications into Dec 2026)
[web-verified: https://verified-zkevm.org/] — "we verify checkers for huge computations"
translates directly to "we prove soundness of proof-system components" [judgment].

**(b) Strength.** **STRONG — as a labor/contracting/grant market, not a product market.**

**(c) Commercial reality.** This is the one lane where money changes hands this quarter for
this exact skill. Shapes: lab employment, hourly expert contracting, EF/DARPA-style grants.
Consultancy comparables: Certora (audits + now an AI-coding platform; note they open-sourced
the prover — prover-as-SaaS alone was not the business)
[web-verified: https://www.certora.com/blog/certora-goes-open-source]; Galois (multi-year
USG cost-plus); Proofcraft (tiny team, seL4-derived credibility).

**(d) Minimal first move.** Publish the certificate+checker result (V3 pilot) loudly — paper +
repo + Lean Zulip — then, same month, apply to Verified zkEVM grants and pitch
Harmonic/Axiom/Math Inc for senior contract work.

**(e) Anti-thesis.** The demand is AI-lab and crypto beta, not intrinsic "verified
computation" demand; if math-AI funding cools the lane thins fast — and autoformalization
agents (Math Inc's Gauss) are aimed at compressing the very expert labor being sold
[web-verified: https://www.math.inc/gauss] [judgment].

---

## B. LLM agent planning

### B5. Search as the agent substrate — the move-ordering law's market

**(a) Connection.** M1 literally quantifies "how much search cost a policy prior of quality X
buys" (dynamic ordering ≈2× node value; forfeiting order +94%; killer transfer decay) — the
missing law under LLM-as-policy-prior test-time search.

**(b) Strength.** **Moderate.** The law fills a real, verified gap — compute-optimal
test-time-scaling work states the nonlinearity but never the law
[web-verified: https://arxiv.org/html/2408.03314v1] — but the commercial substrate is thinner
than it looks.

**(c) Commercial reality.** Frontier vendors do **not** expose tree search; the o-series is
sequential revision + parallel sampling, and the o1-reconstruction literature says tree search
was deliberately avoided (proxy-reward overoptimization)
[web-verified: https://www.interconnects.ai/p/openais-o3-the-2024-finale-of-ai,
https://arxiv.org/pdf/2412.14135]. Even the best 2026 agentic-coding scaling result routes
around trees (tournament voting over trajectory summaries)
[web-verified: https://arxiv.org/abs/2604.16529]. Explicit LLM-policy-over-search is a live
*commercial* architecture in exactly one regime: sound verifier + reversible canonicalizable
state — formal math and code (Harmonic's Aristotle MCTS-in-Lean; AlphaProof, Nature 2025
[web-verified: https://www.nature.com/articles/s41586-025-09833-y]). That regime is our home
turf [judgment]. LATS/SWE-Search/Agent Alpha remain research lines, not products
[web-verified: https://arxiv.org/abs/2310.04406].

**(d) Minimal first move.** Do M1 as planned, but frame and measure a companion result on a
verifiable agent domain (Lean proof search or test-verified SWE tasks) — that converts the
owned data into the currency (inference economics) labs and Harmonic-style shops actually
price in.

**(e) Anti-thesis (strong and specific).** Web/agent domains break every solver assumption:
irreversible actions kill backtracking
[web-verified: https://arxiv.org/html/2512.12692]; no O(1) exact state equality (context makes
state non-Markovian); LLM-judge leaf values are noisy where alpha-beta assumes exact;
transposition rates ≈0 in open-world trajectories; and RL-on-the-policy has beaten explicit
search in every shipped frontier product [judgment + citations above]. **Kill loudly: web-agent
tree search is a world-model problem, not a search problem — do not build there.**

### B6. Verifier-in-the-loop — the thesis that already won

**(a) Connection.** "LLM proposes, sound solver disposes" is our operating worldview and the
2026 consensus: academically canon (Kambhampati's LLM-Modulo
[web-verified: https://arxiv.org/abs/2402.01817]), commercially instantiated (AWS Bedrock
Automated Reasoning checks GA Aug 2025; Kiro bringing automated reasoning into agentic dev;
Harmonic targeting software correctness; Certora pivoting to "safe AI coding"; Axiom's whole
Series A framing)
[web-verified: https://aws.amazon.com/about-aws/whats-new/2025/08/automated-reasoning-checks-amazon-bedrock-guardrails/,
https://thenewstack.io/aws-kiro-brings-automated-reasoning-to-agentic-development/,
https://ventureburn.com/certora-unveils-first-safe-ai-coding-platform-for-smart-contracts/].
Our specific seat: a search-engineering team that can make the verifier loop drastically
cheaper per accepted candidate — verifier-side throughput is a search/memoization problem,
which is our discipline [judgment].

**(b) Strength.** **STRONG** — with the caveat that the thesis being consensus means the
differentiator is execution (cheap sound verification at scale), not the idea.

**(c) Commercial reality.** Who pays today: crypto protocols (six-figure Certora-style
engagements), AWS enterprise/compliance customers, and math-AI investors (Nvidia NVentures
into Harmonic, Jan 2026). "Certificates for agent decisions" as compliance: the EU AI Act's
Aug 2, 2026 applicability drives a real market — but it buys *logging/GRC* (Credo AI, Holistic
AI, watsonx.governance), not soundness proofs
[web-verified: https://www.helpnetsecurity.com/2026/04/16/eu-ai-act-logging-requirements/]
[judgment]. Proof-carrying agent decisions are DARPA-stage (PROVERS/ANSR/CLARA), 2–4 years
from procurement [judgment].

**(d) Minimal first move.** V1's artifact doubles as the entry ticket: a demonstrated
"certificate + verified checker for a 10^11-node computation" is a legible, differentiated
credential in this lane. Then pitch the verifier-loop-throughput angle to the
verified-codegen players.

**(e) Anti-thesis.** The wave's incumbents embed formal tech and price it at zero (AWS);
being right about the thesis earns nothing — only owning a hard piece of it does.

### B7. Memoization/dedup for agent state spaces

**(a) Connection.** TT phenomenology → caching of sub-plans/sub-agent results across fleets.

**(b) Strength.** **LOOSE as a product; sharp as an insight.**

**(c) Commercial reality.** Semantic caching is productized (Redis LangCache, GPTCache) and
measurably weak — a Feb 2026 evaluation found GPTCache at 37.9% accuracy and plan-caching
near-zero on real benchmarks, and *reframes agent caching as a canonicalization problem*
[web-verified: https://arxiv.org/abs/2602.18922] — i.e., the field is independently arriving
at the transposition-table framing without the toolkit. Provider prompt caching is the
**anti**-TT: exact character-prefix matching memoizes the *path*, a TT memoizes the *state*
regardless of path [web-verified: https://platform.claude.com/docs/en/build-with-claude/prompt-caching]
[judgment]. Exact canonicalized-state caching is well-posed only where state externalizes:
code agents (repo tree + test results), proof states (Lean search already uses TTs),
canonicalized DOMs [judgment]. **Kill loudly: a generic agent-memory/caching startup — the
semantic-similarity lane is crowded and failing, and the exact-state lane lacks a state.**

**(d) Minimal first move.** A short position paper/note: "agent caching is a canonicalization
problem — here is what thirty years of transposition-table phenomenology predicts," anchored
on the 2602.18922 result. Cheap, timely, plants the flag.

**(e) Anti-thesis.** For general agents the state is the context window — non-Markovian by
construction; canonical keys may simply not exist outside code/math domains.

### B8. Formal methods for agent safety — market reality check

**(a) Connection.** Exhaustive search + verified checker → verifying an agent's tool-use
policy can't reach bad states (model-check the environment/tool graph, not the LLM).

**(b) Strength.** The *framing* won; the *market* is **LOOSE**.

**(c) Commercial reality.** AWS already productized the single-step layer and gives it away as
a platform feature: AgentCore Policy (Cedar-based deterministic per-tool-call authorization,
GA Mar 2026, with automated-reasoning policy analysis; Cedar itself Lean-verified)
[web-verified: https://aws.amazon.com/blogs/security/why-policy-in-amazon-bedrock-agentcore-chose-cedar-for-securing-agentic-workflows/].
Enterprises buy governance/red-teaming (Gartner: AI-governance-platform spend $492M in 2026 —
small) [web-verified: https://www.speakeasy.com/blog/2026-year-of-ai-governance]; every funded
agent-security startup (Lakera, HiddenLayer, Haize, Cisco/Robust Intelligence) sells
red-teaming + classifiers; the lone formal-adjacent one (Virtue AI, ~$60M raised) still leads
with red-teaming [web-verified: https://www.businesswire.com/news/home/20250415693312/en/].
**Kill loudly: "formal agent safety" as standalone SaaS has zero demonstrated procurement.**
Where formal-methods money actually flows: government — ARIA Safeguarded AI (£59M; the
proof-backed-software TA2 call closed July 1, 2026; future rounds/ecosystem remain, >50%-UK
constraint) [web-verified: https://aria.org.uk/opportunity-spaces/mathematics-for-safe-ai/safeguarded-ai],
DARPA CLARA-class awards, UK AISI Alignment Project (£27M pool)
[web-verified: https://www.aisi.gov.uk/blog/funding-60-projects-to-advance-ai-alignment-research].

**(d) Minimal first move.** The one uncaptured technical layer is **multi-step reachability**
over tool-composition graphs (chained side effects) — today academic-only. An open-source
"reachability checker for MCP tool graphs" with Lean-checked certificates would establish the
category AWS's single-step gateway doesn't cover, positioned for the EU-AI-Act-driven
high-risk deployers post-Aug-2026 and for grant rounds [judgment].

**(e) Anti-thesis.** Single-step deny + sandboxing may be good enough forever; the state space
that matters (real side-effecting environments) resists faithful modeling, so proofs attach to
a model nobody trusts; auditors may accept documentation + evals, never demanding proofs
[judgment].

---

## C. Everything else, incl. anti-connections

- **"Empirical-law methodology as a service"** (perf phenomenology for search-shaped
  workloads): no standalone buyer found; the two entities that would value it are DST
  companies (thread A2) and inference-economics teams (thread B5) — it is a résumé line and a
  citation, not a service [judgment]. Do T1/M1 as the planned papers; they compound into
  threads 1/2/5.
- **ZK/succinct-proof world as the funded cousin:** "sell certificates of big computations" is
  a real, large market — but the product is SNARKs, and our entry point is the Lean
  verification of proof-system components (folded into A4 via the EF Verified zkEVM grants),
  not competing with prover networks [web-verified: https://verified-zkevm.org/] [judgment].
- **Anti-connections (surface similarity, no transfer) — stated once, plainly:**
  - *Game-solving certificates as a paid product*: nobody paid to certify checkers or Othello;
    the ecosystem's checkers are free. Scientific asset only.
  - *Web-agent tree search*: irreversibility + no state equality + noisy values — a
    world-model problem wearing a search costume.
  - *Generic semantic agent caching*: crowded, measurably failing, and not our mechanism.
  - *Faster SPIN*: academically alive, commercially dead; the energy moved to DST.
  - *Standalone formal-agent-safety SaaS*: zero procurement; grants or open-source only.
  - *Parallel-search consulting*: our own five-way negative says the deep result is when
    parallelism *doesn't* help — a paper (P1), not a service.

## Bottom line

The single most credible commercial thread is the **verifier-in-the-loop / Lean-at-scale
lane (B6+A4)**: money is demonstrably changing hands there now (Harmonic/Axiom valuations, EF
zkEVM grants, $170–200/hr Lean contracting, Certora's pivot), and the V1 certificate artifact
is the legible credential that opens it — realistically shaped as contracting, employment, or
grants rather than product revenue. The strongest *direct engineering transfer* with a cheap,
concrete first move is **A2** (TLC fingerprint-set/symmetry work → TLA+ Foundation visibility;
Antithesis as the well-funded employer-shaped buyer of exactly this phenomenology). Keep as
research, on their existing plans: **V1/V3, T1, M1** — they are the credibility engine every
commercial thread above draws from, and none of them has a direct buyer today.

---
*Method: five parallel web-research passes on 2026-07-02 (certifying MC market; explicit-state
MC/DST; ITP services & certification; LLM-agent search/verification/caching; agent-safety
formal methods); load-bearing claims carry their URLs above. Funding figures and GA dates are
snapshots as of today — re-verify before quoting externally.*
