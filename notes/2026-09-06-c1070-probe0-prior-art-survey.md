# C1070 probe 0 — prior-art survey for the compositional leakage interface

**Lane**: `ergodis`
**Task**: C1070 probe 0 (brief: `notes/2026-09-06-c1070-ergodis-compositional-leakage-brief.md`, §6)
**Kind**: **product survey, not a novelty audit.** Per the brief's standing constraints, prior art is
gathered to be known and cited; it never gates a probe or a shipped capability. This report contains
**no novelty verdict** and none should be quoted from it. The deliverables are (i) what exists,
(ii) what to cite for each C1070 result, (iii) what the engine should absorb, and (iv) where the
labelled compositional theory differs from what these works provide.
**Recording standard**: `notes/literature-audit-conventions.md`. Every named source carries a read
depth. Cache keys and SHA-256 are recorded for cached bytes.

**Scope of the object being positioned.** The linear-uniform model only: uniform `Z` over `F_q^k`,
secret `A Z`, coalition observation `B_H Z`, leakage `dim(row A ∩ row B_H)`. Non-uniform priors,
noisy observations, adaptive observers, and computational (as opposed to information-theoretic)
privacy are outside everything discussed below.

---

## 0. Read-depth summary

Filled in at the end of the survey; see §9 for the coverage statement and the full-text count.

---

## 1. The three C1070 results being positioned

Stated here in the form a citation has to attach to, so that §§2–7 can point at them.

**R1 — masks are label pinning on an enlarged message space** (probe 1,
`notes/2026-09-06-c1070-probe1-mask-quotiented-associativity.md`, §§0, 2, 3.3, 4, 9). A level that
injects fresh randomness has message space `Msg ⊕ R`; the masked prescribed-coset cost equals the
mask-free cost of the enlarged code with the requested label pinned to `0` on every mask coordinate
(Proposition 1). Under hypothesis (F) — mask spaces of distinct blocks at one level are independent —
the labelled min–sum composition and its associativity through a finite tower hold verbatim
(Theorem 2, Corollary 3), with coefficient witnesses propagating. When (F) fails, the fresh-mask
formula is **unsound in one known direction only**: it never under-reports cost, so it can only
overstate privacy (Lemma 5); shared randomness is repaired mechanically by promoting it to a message
coordinate of the lowest level at which it is common, at a state-count price of `q^(t·dim R_sh)`.

**R2 — per-class minimum coalitions with witnesses, and a direct `t`-symbol profile** (probe 5,
`notes/2026-09-06-c1070-probe5-privacy-interface-tower-case.md`, §§1, 8). For each projective class
of secret functional in `row A`, the minimum-cost coalition recovering it plus the coefficient witness
that reconstructs it, or a statement of privacy against every coalition in the model; and the
`t`-symbol leakage profile for `t = 1..dim row A` by direct minimisation over `t`-dimensional
`T ⊆ row A`. Observation model: coalitions of coordinates at any tower level, whole-block or partial,
each unit priced.

**R3 — Pareto antichains of cost vectors under per-level budgets** (probe 3,
`notes/2026-09-06-c1070-probe3-vector-costs.md`, Parts B and C). An adversary limited to `a`
compromised blocks and `b` coordinates per block has a vector cost; the minimum is replaced by the
antichain of minimal cost vectors, each carrying its own coalition and witness, and the `t`-profile
becomes the antichain of the pooled per-subspace antichains — genuinely set-valued. Part C is
reasoning, not proof: exactness of the contextual quotient looks order-agnostic, finiteness survives
only in the weak sense (per-label state becomes an antichain in a grid, a Dedekind-style count), and
"settled class is final" borrowed from shortest paths has to be redone.

---

## 2. Relative generalized Hamming weights and linear secret sharing

**What the literature gives.** The coset construction `C_2 ⊊ C_1` for a linear ramp secret sharing
scheme, with the equivocation of the secret given `m` shares determined by the relative
dimension/length profile and the relative generalized Hamming weights of the nested pair.

- **Kurihara, Uyematsu, Matsumoto, "Secret Sharing Schemes Based on Linear Codes Can Be Precisely
  Characterized by the Relative Generalized Hamming Weight", IEICE Trans. Fundamentals E95-A(11),
  pp. 2067–2075, 2012.** — *read depth: partial* (cache key `10.1587/transfun.E95.A.2067`, sha256
  `fb9ff1882908f58735fed34c85cafb1f53dfac0effc90b84b7a487fe368827d8`, 9 pp., fetched 2026-08-24 from
  `https://doi.org/10.1587/transfun.E95.A.2067`; published version; sections read: abstract,
  introduction, §3.1 "Equivocation of the Secret", the Theorem 19 statement region, conclusion; the
  proofs of §4 were not read).

  The object is an **amount, minimised over coalitions of a given size**. Verbatim, §3.1: "the
  minimum uncertainty of `S` given `m` shares is defined by `Δ_m = min_{I ⊆ X, |I| = m} H(S | C_I)`,
  which is called equivocation" and "the equivocation of `S` is precisely characterized by the
  relative dimension/length profile (RDLP)". The abstract's framing is likewise quantitative: "This
  paper precisely characterizes secret sharing schemes based on linear codes" and the schemes
  "always achieve the `α`-strong security where the value `α` is precisely characterized by the
  RGHW."

  **Labelled?** No. `Δ_m` collapses over `I` and over which secret coordinates leak; the secret is a
  vector `s ∈ F^l` and the statistic is `H(S | C_I)` in symbols, not the subspace `row A ∩ row B_I`.
  There is no coalition witness and no per-functional answer. Strong security in this sense — every
  `α`-subset of secret symbols is protected — is the closest the paper comes to a per-functional
  statement, and it is still a uniform quantifier over subsets rather than a computed identity of the
  leaked subspace.

- **Geil, Martin, Matsumoto, Ruano, Luo, "Relative generalized Hamming weights of one-point algebraic
  geometric codes"** — *read depth: partial* (cache key `arXiv:1403.7985`, sha256
  `25e31e23e4238ae33a08b4730c558fe071861a87c6e4fc0e1161d4bbcda581e7`, 30 pp., fetched 2026-08-22
  from `https://arxiv.org/abs/1403.7985`; **arXiv preprint version read, not the published version**;
  sections read: title/authors/keywords, introduction, §2 opening "Ramp secret sharing schemes and
  wiretap"). The paper's own framing, verbatim from the abstract region: "Security of linear ramp
  secret sharing schemes can be characterized" by these weights; "A linear ramp secret sharing scheme
  can be described as a coset construction `C_1/C_2` where `C_2 ⊊ C_1` are linear codes"; and "RDLP
  was proposed by Luo et al." The contribution is computing the weight hierarchy for a code family
  (one-point algebraic geometric codes), which is orthogonal to labelling.

  **Labelled?** No — the deliverable is a weight hierarchy, i.e. a sequence of integers per code pair.

- **Luo, Mitrpant, Han Vinck, Chen, "Some new characters on the wire-tap channel of type II", IEEE
  Trans. Inform. Theory 51(3), pp. 1222–1229, 2005** (DOI `10.1109/TIT.2004.842763`) — *read depth:
  secondary only*, via the reference lists and in-text uses in the two sources above (each itself
  `partial`). Both attribute the relative dimension/length profile and the relative generalized
  Hamming weights to this paper. Bibliographic detail is taken verbatim from those reference entries;
  the paper itself was not opened, so nothing beyond the attribution of the definitions is claimed
  here.

- **Wei, "Generalized Hamming weights for linear codes", IEEE Trans. Inform. Theory 37(5),
  pp. 1412–1418, 1991** — *read depth: secondary only*, same two reference lists. The duality this
  survey refers to (the weight hierarchy of a code and that of its dual determine each other) is
  attributed from background and is **not** verified against the paper here; probe 4 owns labelled
  duality and should open Wei directly.

- **Massey, "Some applications of coding theory in cryptography", in Codes and Ciphers: Cryptography
  and Coding IV, pp. 33–47, 1995** — *read depth: secondary only*, via Kurihara et al. (which cites
  it as `[11]` and repeatedly identifies its construction with the coset scheme) and Geil et al.
  (`[31]`). The 1993 item the brief names alongside it was not located as a separate consulted
  source, so only the 1995 entry is cited here, with detail verbatim from those two reference lists.
  The coding view of secret sharing — shares are codeword coordinates, minimal access sets are
  minimal codeword supports — is the identification used in probe 1 §1.2 and probe 5 §1.

**Headline for the comparison table.** Amount-only, and per-coalition-size: this literature computes
`H(S | C_I)` minimised over coalitions of a fixed size, for one code pair at a time. It supplies no
identity of the leaked functionals, no coalition witness, and no composition rule across a tower.

**What to cite it for.** R2's underlying single-level identity — that the leakage of a linear
encoding to a coalition is a rank difference determined by the nested pair — is exactly this
literature and must be cited as such wherever C1070 states the one-level case. The brief's §1
landscape claim ("RGHW characterizes secret sharing is established") is **confirmed** at the depth
recorded above.

**What to absorb.** Two things. First, the coset-construction input format `C_2 ⊊ C_1` is the
canonical way practitioners describe a linear ramp scheme, and the privacy interface should accept it
directly rather than only its own tower parameterisation. Second, the "`α`-strong security" statistic
is a cheap derived output of the labelled compiler — it is the largest `α` such that no `α`-subset of
secret coordinates leaks — and reporting it lets a user compare the compiler's output against the
number this literature would give them.

---

## 3. Masking verification and the probing model

This is the closest literature to C1070 by mechanism: these tools decide, by Gaussian elimination
over the field, exactly the rank condition of the brief's §2. The differences are in what is exported
and in how gadgets are composed.

### 3.1 The model

- **Ishai, Sahai, Wagner, "Private circuits: Securing hardware against probing attacks", CRYPTO 2003,
  LNCS 2729, pp. 463–481** — *read depth: secondary only*, via IronMask (`partial`), which introduces
  it as "The most famous one is probably the `t`-probing model, introduced by Ishai, Sahai, and Wagner
  in 2003". Bibliographic detail verbatim from IronMask's reference [32]. The paper itself was not
  opened; only the model attribution is claimed here.

### 3.2 What the tools return: a witness, but not the leaked functional

- **Belaïd, Mercadier, Rivain, Taleb, "IronMask: Versatile Verification of Masking Security", IEEE
  S&P 2022, pp. 142–160; eprint 2021/1671** — *read depth: partial* (cache key `eprint:2021/1671`,
  sha256 `f9b1b936d56256649c22fd564c80e921d866be3b5f6da25ea993b38d41d24f47`, 35 pp., fetched
  2026-09-06 from `https://eprint.iacr.org/2021/1671.pdf`; **eprint version read, not the IEEE
  published version**; sections read: abstract, §1 introduction, §2 preliminaries including the
  security-notion definitions and Table 1, §3.1 on the Gaussian-elimination method and Lemma 1, the
  implementation notes on wire representation and glitches, and the tool-comparison section; the
  quadratic-gadget proofs and the benchmark tables were skimmed only). The IEEE volume and page range
  are from a web search result page for the published version, not read off the article.

  The exported object is the **set of input share indices**, not the leaked linear combination.
  Verbatim: the single building block is "the set of input shares (SIS) function. The latter takes as
  input a set of probes on internal wires of the gadget as well as a set of output shares, and returns
  a set of input shares necessary (and sufficient) to perfectly simulate these internal probes and
  output shares."

  The labelled information is computed and then discarded. Verbatim on the mechanism: "after
  executing the Gaussian elimination, we are guaranteed that the remaining expressions cannot be
  simplified any further in the given field `K` and they are solely formed of operations between input
  shares (they do not include any random variables)", after which the function `shares(.)` "simply
  consists in extracting the indices of the input shares that are contained in the symbolic
  expressions". So the residual expressions after elimination *are* the surviving secret-side
  functionals — the same object C1070 calls the leaked space and the coefficient witness — and the
  tool's interface projects them to an index set. (That reading of what the residual expressions are
  is my own inference from the quoted mechanism, not the paper's framing.)

  The security notions are then **cardinality conditions on those index sets**. Verbatim from
  Definition 2: "A gadget `G` is `t`-NI if for any tuple `P` of `t1` internal probes and any set `O`
  of `t2` output share indices such that `t1 + t2 ≤ t`, the sets `(I_1, …, I_ℓ) := SIS_G(P, O)`
  satisfy `|I_i| ≤ t` for all `i`", and Table 1 gives the whole family in the same shape:
  `t`-SNI is `|I_i| ≤ t1`, `t`-TNI is `|I_i| ≤ t1 + t2`, `t`-PINI is `|(∪_i I_i) ∩ O| ≤ t1`, and
  probing security is `|I_i| ≤ n − 1`. Failure in the probing model is likewise all-or-nothing per
  input: "a failure occurs when all the shares (of one input) are necessary".

  Randomness freshness is **built into the model, not verified**: "A randomized arithmetic circuit is
  equipped with an additional random gate of fan-in 0 which outputs a fresh uniform random value
  of `K`."

- **Barthe, Belaïd, Cassiers, Fouque, Grégoire, Standaert, "maskVerif: Automated Verification of
  Higher-Order Masking in Presence of Physical Defaults", ESORICS 2019, LNCS 11735; eprint 2018/562**
  — *read depth: partial* (cache key `eprint:2018/562`, sha256
  `98b9c223fed48755678440d8aec22a4022a3aa3936767416c137928f83cfb3c0`, 20 pp., fetched 2026-09-06 from
  `https://eprint.iacr.org/2018/562.pdf`; **eprint version read, not the ESORICS published version**;
  sections read: abstract, §1 introduction, §2.1 implementation and verification procedure, the
  strong-non-interference definition, §5 experimental evaluation preamble). The ESORICS
  volume/series detail is from a web search result listing, not read off the article.

  On failure the tool reports **the probe tuple**, not the leaked functional. Verbatim: "Whenever
  verification fails, i.e. a potentially flawed tuple is detected, our tool computes the joint
  distribution of this tuple, so as to verify exactly whether this tuple is an attack for the weakest
  security notion considered. This step is exact, therefore all false negatives are removed. Our tool
  successfully concludes for the secure examples, and outputs and checks the flawed tuple of
  intermediate computations for the insecure examples." Composition is again by cardinality: strong
  non-interference "imposes more stringent cardinality constraints", and its purpose is that
  "it allows analyzing smaller (computationally tractable) parts of them independently, with global
  security guarantees thanks to composition."

  The earlier 2015 tool in the same line is **Barthe, Belaïd, Dupressoir, Fouque, Grégoire, Strub,
  "Verified proofs of higher-order masking", EUROCRYPT 2015, LNCS 9056, pp. 457–485** — *read depth:
  secondary only*, bibliographic detail verbatim from IronMask's reference [5]; not opened.
  Strong non-interference was introduced in **Barthe, Belaïd, Dupressoir, Fouque, Grégoire, Strub,
  Zucchini, "Strong non-interference and type-directed higher-order masking", ACM CCS 2016,
  pp. 116–129** — *read depth: secondary only*, detail verbatim from IronMask's reference [6]; not
  opened.

### 3.3 Composition: sufficient, one-directional, and stated as such

- **Cassiers, Standaert, "Trivially and Efficiently Composing Masked Gadgets with Probe Isolating
  Non-Interference", IEEE Trans. Inf. Forensics and Security 15, pp. 2542–2555, 2020
  (DOI `10.1109/TIFS.2020.2971153`); eprint 2018/438** — *read depth: partial* (cache key
  `eprint:2018/438`, sha256 `b42403afae17e89aa04e13434d3eaf1c917f49eb0b623a47fbcefa066391b117`,
  13 pp., fetched 2026-09-06 from `https://eprint.iacr.org/2018/438.pdf`; **eprint version read, not
  the IEEE published version**; sections read: abstract, the non-interference definitions in §II, the
  opening of §III on trivial composition). The volume, page range and DOI are from a web search
  result page for the published version and were not read off the article itself.

  Two statements settle the exactness question, verbatim. Sufficiency but not necessity: "`t`-NI is
  however not a necessary condition for probing security, because it requires indistinguishable
  simulation for any value of the input shares, not only for any value of the sensitive variables,
  which sometimes makes the simulation of probing secure gadgets impossible". And the composition
  rule is a one-directional closure: PINI "enjoys a simple and practical composition property: any
  composite gadget whose composing gadgets are all PINI is itself PINI."

- **Knichel, Sasdrich, Moradi, "SILVER — statistical independence and leakage verification",
  ASIACRYPT 2020, Part I, LNCS 12491, pp. 787–816** — *read depth: secondary only*, via IronMask,
  which characterises it as "the only previous tool providing complete verification for quadratic
  gadgets with non-linear randomness" and as suffering "low performance". Bibliographic detail
  verbatim from IronMask's reference [33]; not opened. That characterisation is IronMask's and is
  unverified against SILVER.

- **Belaïd, Coron, Prouff, Rivain, Taleb, "Random probing security: Verification, composition,
  expansion and new constructions", CRYPTO 2020** (the VRAPS tool) — *read depth: secondary only*,
  via IronMask, which calls it "the only previous tool verifying random probing composability and
  expandability" and notes that VRAPS is incomplete in the direction that matters here: IronMask
  "avoids failure false positives i.e. detected failure tuples which are not really failures, unlike
  VRAPS". Bibliographic detail is from IronMask's reference [13]; that entry's page range was not
  captured in the bounded read and is therefore omitted rather than recalled. Not opened, and the
  incompleteness characterisation is IronMask's, unverified against VRAPS.

### 3.4 Direct answers to the questions the brief asked

1. **Do these tools return which secret linear combination a probe set reveals?** No. IronMask
   returns the minimal set of input **share indices** sufficient for perfect simulation; maskVerif
   returns the flawed **probe tuple**. Both compute residual functionals internally during Gaussian
   elimination and then project them away. Nothing in the exported interface names a secret
   functional or hands back a coefficient vector reconstructing it.
2. **Is their composition exact or a sufficient condition?** A sufficient condition, and the papers
   say so: non-interference is explicitly "not a necessary condition for probing security", and the
   PINI composition theorem is stated only in the direction PINI-parts implies PINI-whole. All the
   notions in IronMask's Table 1 are cardinality bounds on index sets, so a composite that fails the
   bound may still be secure, and the notions cannot express *which* functional would leak.
3. **Is there an exact compositional labelled result for linear gadgets already?** None was located
   at the depth of this survey. Verification of a *fixed* linear gadget is exact and complete in these
   tools; what is approximated is the **composition step**, and the approximation is exactly the loss
   of labels. Two later works surfaced in search whose titles promise tighter composition —
   "Unifying Freedom and Separation for Tight Probing-Secure Composition" (CRYPTO 2023) and "Probing
   Security through Input-Output Separation and Revisited Quasilinear Masking" (IACR TCHES) — *read
   depth: abstract/metadata only, from search-result listings*; neither was opened, and this survey
   makes no claim about them beyond recording them as the first place a later check should look.
   This is a product survey, not a novelty audit: nothing here is a priority claim.

### 3.5 Headline, citations, and what to absorb

**Headline for the comparison table.** Exact per-gadget decision of the same rank condition; the
answer is exported as index-set cardinalities, composition is a sufficient condition (NI, SNI, PINI)
that discards which functional leaks, and per-gadget fresh randomness is an axiom of the model rather
than something checked.

**What to cite it for.** The probing model itself (Ishai–Sahai–Wagner) whenever C1070 describes a
coalition of observed wires; IronMask's set-of-input-shares function as the prior art nearest to R2's
per-class minimum coalitions with witnesses; and the NI/SNI/PINI family as the named unlabelled
composition conditions that R1's Theorem 2 and Lemma 5 refine. Probe 1's §9 asserted this comparison
from memory and flagged it for this probe; it is **confirmed** at the depth recorded above, with one
correction of emphasis: the set-of-input-shares function *is* a witness of a kind — a minimal
necessary-and-sufficient input-share set — so the accurate statement is not "these tools give no
witness" but "these tools give a coordinate-side witness and no secret-side label."

**What to absorb, concretely.**

1. **The gadget corpora are ready-made benchmark inputs.** IronMask and maskVerif ship standard
   gadgets — ISW multiplication, refresh gadgets, DOM-AND, parallel and hardware variants, a 2-share
   AES — in machine-readable form. Ingesting that format gives the engine a test suite with known
   expected answers at low authoring cost, and directly supports the reconciliation probe 5 §8 asks
   for.
2. **Report the minimal input-share set alongside the labelled answer, not instead of it.** That
   makes the output a strict refinement of what a masking engineer already reads, which is the
   cheapest adoption path.
3. **Freshness as a discharged obligation is the concrete differentiator.** These tools take
   per-gate fresh randomness as a modelling axiom. Probe 1 §4 shows what that costs when it is false,
   and §3.3's Lemma 5 shows the error is always in the unsafe direction. An interface that *verifies*
   independence from the encoding, and reports shared randomness as a rank drop in the mask block, is
   a capability none of these tools offers.

---
