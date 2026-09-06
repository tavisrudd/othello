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

**No source in this report was read at `full text`.** Six were read at `partial`:
Kurihara–Uyematsu–Matsumoto 2012, Geil–Martín–Matsumoto–Ruano–Luo (arXiv version), IronMask (eprint),
maskVerif (eprint), Cassiers–Standaert on probe-isolating non-interference (eprint), and
Cramer–Damgård–Maurer 2000 (abstract and introduction only). Every other source is `secondary only`
or `abstract/metadata only`, marked in place. The §3 verdicts on the masking tools rest on `partial`
reads of the papers themselves and are the strongest claims here; the §4 "amount-only" verdicts rest
on abstracts and are correspondingly weaker. §9 carries the full coverage statement, including what
was not reachable.

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

## 4. Secure distributed storage, regenerating codes, and secure network coding

The eavesdropper-on-repair-transcripts literature runs the same rank-equivocation arithmetic as the
brief's §2, on the axis probe 1 calls the transcript axis: an observer accumulates the data stored at
some nodes plus the data downloaded during repair of others.

- **Pawar, El Rouayheb, Ramchandran, "Securing Dynamic Distributed Storage Systems against
  Eavesdropping and Adversarial Attacks", arXiv:1009.2556 (2011), published IEEE Trans. Inform.
  Theory 58, pp. 6734–6753, 2012** — *read depth: abstract/metadata only* (arXiv abstract page
  `https://arxiv.org/abs/1009.2556` fetched 2026-09-06; **arXiv version's abstract, not the published
  version**; the PDF was not fetched or cached; the journal volume/page detail comes from the same
  search-result summary and is unverified against the article). Verbatim from the abstract: "In this
  scenario, we give upper bounds on the maximum amount of information that can be stored safely on
  the system. For an important operating regime … which we call the 'bandwidth-limited regime', we
  show that our upper bounds are tight and provide explicit code constructions."
  **Amount-only.** The deliverable is a secrecy capacity plus matching constructions.

- **Shah, Rashmi, Kumar, "Information-theoretically Secure Regenerating Codes for Distributed
  Storage", arXiv:1107.5279; presented in part at IEEE GLOBECOM 2011** — *read depth:
  abstract/metadata only* (arXiv abstract page `https://arxiv.org/abs/1107.5279` fetched 2026-09-06;
  arXiv version; PDF not fetched; the GLOBECOM venue attribution is from a search-result summary).
  Verbatim: "we consider a threat model where an eavesdropper may gain access to the data stored in a
  subset of the storage nodes, and possibly also, to the data downloaded during repair of some nodes.
  We provide explicit constructions of regenerating codes that achieve information-theoretic secrecy
  capacity in this setting." **Amount-only**, and this is the paper that states the repair-transcript
  threat model most directly.

- **Rawat, Koyluoglu, Silberstein, Vishwanath, "Optimal Locally Repairable and Secure Codes for
  Distributed Storage Systems", arXiv:1210.6954; IEEE Trans. Inform. Theory 60(1), pp. 212–236,
  January 2014** — *read depth: abstract/metadata only* (arXiv abstract page
  `https://arxiv.org/abs/1210.6954` fetched 2026-09-06; arXiv version; PDF not fetched; volume, issue
  and page range from a search-result summary, unverified against the article). The contributions are
  "an improved bound on the secrecy capacity for minimum storage regenerating codes", secure coding
  schemes against colluding eavesdroppers, and minimum-distance bounds for locally repairable codes.
  **Amount-only**, with the added axis of locality — which is the closest thing in this literature to
  C1070's per-level observation budget.

- **Cai, Yeung, "Secure network coding", Proc. IEEE ISIT 2002, Lausanne, p. 323; and
  "Secure Network Coding on a Wiretap Network", IEEE Trans. Inform. Theory 57(1), pp. 424–435, 2011**
  — *read depth: abstract/metadata only*, from search-result listings on 2026-09-06; neither paper was
  opened and neither is cached. Bibliographic detail is from those listings. Nothing about their
  contents is claimed here beyond that they are the origin of the wiretap-network model that the
  rank-metric line below extends.

- **Martínez-Peñas, Matsumoto, "Unifying notions of generalized weights for universal security on
  wire-tap networks", arXiv:1607.01263 (v1 July 2016, v2 December 2016)** — *read depth:
  abstract/metadata only* (arXiv abstract page `https://arxiv.org/abs/1607.01263` fetched 2026-09-06;
  arXiv version; PDF not fetched). Verbatim: "we introduce new parameters (relative dimension/rank
  support profile and relative generalized matrix weights) for linear codes that are linear over the
  field used in the network, measuring the universal security performance of these codes", and the
  parameters "strictly extend relative dimension/length profile and relative generalized Hamming
  weights, respectively, and relative dimension/intersection profile and relative generalized rank
  weights, respectively." **Amount-only**, and explicitly so: the parameters are profiles and weights
  that *measure* performance. A companion in the same line, Martínez-Peñas, "On the similarities
  between generalized rank and Hamming weights and their applications to network coding",
  arXiv:1506.04036 (2015/2016), is recorded at *read depth: abstract/metadata only* from a
  search-result listing and was not opened.

- **Herzberg, Jarecki, Krawczyk, Yung, "Proactive Secret Sharing Or: How to Cope With Perpetual
  Leakage", CRYPTO 1995, LNCS 963, pp. 339–352** — *read depth: abstract/metadata only*, from a
  search-result listing on 2026-09-06 (a Springer chapter page and a Google Research publication
  page); not opened, not cached. It is cited here only as the origin of periodic share refresh, which
  is the operation that motivates the transcript axis: refresh injects new randomness and the question
  becomes what a long-lived observer of many refresh transcripts accumulates. Whether the paper
  contains any labelled statement was **not** checked, and no claim about its contents is made.

**Headline for the comparison table.** Amount-only, uniformly: secrecy capacity, equivocation, and
weight/profile parameters, with matching constructions. Every source reachable at this survey's depth
states its guarantee as a maximum secure file size or an information-theoretic capacity, and none
identifies which secret functionals a given eavesdropper set recovers, nor returns a coalition
witness. The brief's §7 expectation ("these give amounts, not labelled spaces, as far as memory
serves") is **confirmed** at abstract depth, and the caveat that this depth is abstracts rather than
full texts belongs on the claim.

**What to cite it for.** The threat model, not the mathematics: whenever C1070 or the interface
describes an observer of repair or refresh transcripts, Shah–Rashmi–Kumar and Pawar–El Rouayheb–
Ramchandran are the model's home, Cai–Yeung is the network-coding origin, Martínez-Peñas–Matsumoto
is the rank-metric generalisation of the weight parameters, and Herzberg et al. is proactive refresh.

**What to absorb.** The secure regenerating-code constructions are **demo inputs with published
expected answers**. A construction that "achieves secrecy capacity" against `ℓ` eavesdropped nodes is
a tower the interface can compile; the compiled per-functional profile must be consistent with the
published capacity, which is a free correctness check, and the profile then says more than the
capacity does — which node subsets recover which combination. The locality axis in Rawat et al. is
also the natural real-world instance of probe 3's per-level budget: local repair groups are exactly
"at most `b` coordinates within a block".

---

## 5. Hierarchical and multilevel secret sharing

The brief's §6 anticipated the answer and it is correct: **these are hierarchical *access structures*,
not hierarchical *encodings*.** The hierarchy lives in who may reconstruct, expressed as a
multipartite threshold condition on participant levels. It does not live in the encoding, which is a
single-level polynomial or vector-space construction. Nothing in this line concatenates one linear
encoding inside another, so nothing in it composes labelled costs through a tower — the object C1070
is about does not appear.

- **Tassa, "Hierarchical Threshold Secret Sharing", Journal of Cryptology 20(2), pp. 237–264, 2007** —
  *read depth: abstract/metadata only*, from search-result listings on 2026-09-06 (a Springer article
  page and the author's own conference-version PDF listing); not opened, not cached. The mechanism,
  as reported in those listings: the scheme "uses Birkhoff interpolation, i.e., the construction of a
  polynomial according to an unstructured set of point and derivative values." That is a single
  polynomial encoding with participants at different levels receiving different derivative orders —
  a hierarchical access structure over a flat encoding. The characterisation is the auditor's
  inference from the reported mechanism, not a quotation of the paper's own framing.
- **Brickell, "Some ideal secret sharing schemes", Journal of Combinatorial Mathematics and
  Combinatorial Computing 9, pp. 105–113, 1989** — *read depth: abstract/metadata only*, from a
  search-result listing; not opened. The vector-space construction for multilevel and compartmented
  structures is attributed from that listing.
- **Simmons, "How to (Really) Share a Secret", CRYPTO '88, LNCS 403, pp. 390–448, Springer, 1990** —
  *read depth: abstract/metadata only*, from search-result listings, which report that Simmons gave
  the definitions of the compartmented and hierarchical access structures. Not opened. Note the
  publication-year discrepancy the brief's shorthand hides: the conference is 1988, the proceedings
  volume is dated 1990; cite whichever is intended explicitly.

**Headline for the comparison table.** Hierarchical access structure over a flat encoding. No
composition of encodings, therefore no tower, no per-level observation budget, and no labelled cost.

**What to cite it for.** One disambiguating sentence, wherever C1070 says "hierarchical": to state
that hierarchical here means composed encodings, not the multipartite access structures of this line.
Getting that sentence in early prevents the most likely misreading by a reader from the
secret-sharing community.

**What to absorb.** Little mathematically, but one interface idea: multipartite access structures are
the standard vocabulary a practitioner brings, so accepting a level-and-threshold description and
compiling it into the observation model would remove a translation step for exactly the audience the
privacy interface targets.

---

## 6. Secret sharing from composed and multiplicative codes

- **Chen, Cramer, Goldwasser, de Haan, Vaikuntanathan, "Secure Computation from Random Error
  Correcting Codes", EUROCRYPT 2007, LNCS 4515, pp. 291–310** — *read depth: abstract/metadata only*,
  from search-result listings on 2026-09-06 (the IACR EUROCRYPT 2007 programme page and a Springer
  chapter page); not opened, not cached. It is cited by Kurihara et al. (read at `partial`) as
  reference [4], repeatedly paired with Massey's construction: verbatim from that paper, "the schemes
  of Massey [11] and Chen et al. [4, Sect. 4.1]" are shown to be equivalent to the coset construction
  and to "always achieve the `α`-strong security". So its secret-sharing content sits inside the same
  amount-only frame as §2.
- **Cramer, Damgård, Maurer, "General Secure Multi-party Computation from any Linear Secret-Sharing
  Scheme", EUROCRYPT 2000** — *read depth: partial* (cache key `10.1007/3-540-45539-6_22`, sha256
  `f89720b98a76ca6394a416ff7c16a5b37e7458131a05507595678d7d9b2218f7`, 19 pp., fetched 2026-07-16 from
  the IACR archive copy `https://www.iacr.org/archive/eurocrypt2000/1807/18070321-new.pdf`; sections
  read here: abstract and the introduction's summary of multiplicativity; the protocols and proofs
  were not read). The relevant composition notion is multiplicativity, not concatenation. Verbatim:
  "an LSSS is multiplicative if each player `P_i` can, from his shares of secrets `s` and `s'`,
  compute a value `c_i`, such that the product `s s'` can be computed as a linear combination of all
  the `c_i`'s", and "multiplicativity can be assumed without loss of generality: we give an efficient
  procedure that transforms any LSSS into a multiplicative LSSS of size at most twice that of the
  original one."
- **Cascudo, Chen, Cramer, Xing, "Asymptotically good ideal linear secret sharing schemes with strong
  multiplication over any fixed finite field", CRYPTO 2009, LNCS 5677, pp. 466–486** — *read depth:
  abstract/metadata only*, from search-result listings; not opened. Same axis: multiplicativity and
  asymptotic parameters, and the composition being exploited is algebraic-geometric tower
  construction for *parameters*, not an analysis of leakage through the composition.
- **Márquez-Corbella, Martínez-Moro, Suárez-Canedo, "On the Composition of Secret Sharing Schemes
  Related to Codes", arXiv:1211.5566, 2012** — *read depth: abstract/metadata only* (arXiv abstract
  page fetched 2026-09-06; arXiv version; PDF not fetched). This is the nearest title in the
  literature to "leakage through the composition" and it is **not** about leakage. Verbatim from the
  abstract: "we construct a subclass of the composite access structure introduced by Martínez et al.
  based on schemes realizing the structure given by the set of codewords of minimal support of linear
  codes … all the schemes on this paper are ideal (in fact they allow a vector space construction)".
  Composite access structures, ideality, and vector-space realisability — access structures and
  parameters, no leakage analysis.

The textbook treatment (Cramer, Damgård, Nielsen, *Secure Multiparty Computation and Secret
Sharing*) named in the brief was **not consulted** in this survey; it is recorded in §9 as a
coverage gap, not as a source.

**Headline for the comparison table.** Composition appears as multiplicativity and as composite
access structures, both aimed at parameters and realisability. No source located here analyses what
leaks *through* a concatenation, and no source composes a per-functional leakage cost across levels.

**What to cite it for.** Chen et al. as the standard companion to Massey for the coding construction;
Cramer–Damgård–Maurer for the linear-secret-sharing-scheme formalism the interface's input model
should match; Márquez-Corbella et al. as the existing meaning of "composition" in this community,
which is a different meaning from C1070's.

**What to absorb.** The multiplicativity property is a second, orthogonal question the same compiled
object could answer — "for which pairs of functionals is a product locally computable" is again a
membership test on row spaces — and is a plausible later feature, not a C1070 deliverable. Recorded
here rather than pursued.

---

## 7. Leakage-resilient secret sharing: a different model, not to be conflated

- **Benhamouda, Degwekar, Ishai, Rabin, "On the Local Leakage Resilience of Linear Secret Sharing
  Schemes", CRYPTO 2018, LNCS 10993; journal version in Journal of Cryptology (DOI
  `10.1007/s00145-021-09375-2`); eprint 2019/653** — *read depth: abstract/metadata only*, from
  search-result listings on 2026-09-06 (Springer chapter and article pages, the IACR CRYPTO 2018 PDF
  listing, and the eprint listing); not opened, not cached. As reported there, the model is that "the
  adversary can apply an arbitrary function of a bounded output length to the secret state of each
  party, but cannot otherwise learn joint information about the states", and the results are that
  additive sharing and high-threshold Shamir are locally leakage resilient over large prime fields
  with enough parties, "obtained via tools from Fourier analysis and additive combinatorics".

**Why it must not be conflated with C1070.** Three separate differences, each sufficient on its own.

1. **The leakage function.** There, an *arbitrary* bounded-output function of each share
   individually. Here, the adversary sees exact field values of chosen coordinates and nothing else.
   Neither model contains the other: the local model allows nonlinear compression of a whole share
   that the linear model forbids, and the linear model allows joint observation across parties that
   the local model forbids.
2. **The statistic.** There, statistical distance between the leakage distributions for two secrets,
   with parameters. Here, an exact integer rank and an exactly identified subspace of functionals.
   No labelled statement is even expressible in the local model, because the leakage function is
   arbitrary.
3. **The proof technique.** Fourier analysis and additive combinatorics over large prime fields,
   versus linear algebra over any finite field. Nothing transfers in either direction.

**Headline for the comparison table.** Different leakage model entirely — arbitrary bounded-output
functions applied per share, with statistical-distance guarantees. Not comparable, and it should be
cited only to disclaim the overlap.

**What to cite it for.** A single scoping sentence in any C1070 write-up: "leakage-resilient secret
sharing in the sense of Benhamouda et al. is a different model (local, arbitrary bounded-output
functions of individual shares), and none of the results here bear on it."

---

## 8. Comparison table

One row per literature. "Labelled" means the result identifies *which* secret functionals leak, not
just how many symbols. "Witness" means a coefficient vector reconstructing the functional from the
observed coordinates. "Composes" means a stated rule for a composed object built from analysed parts.

| Literature | Object it computes | Labelled? | Witness? | Composes? | What C1070 adds |
|---|---|---|---|---|---|
| Relative generalized Hamming weights and linear secret sharing (Massey; Wei; Luo et al.; Kurihara et al.; Geil et al.) | Equivocation `Δ_m = min_{&#124;I&#124;=m} H(S &#124; C_I)`, a weight hierarchy per nested code pair | No — an amount, minimised over coalitions of fixed size | No | Single level only; no composition rule | Identity of the leaked subspace, per-functional minimum coalitions, and an associative min–sum through a tower |
| Masking verification and the probing model (Ishai–Sahai–Wagner; maskVerif; IronMask; SILVER; VRAPS; NI/SNI/PINI) | Exact per-gadget decision of the same rank condition; minimal input-share index set | No — the residual functionals are computed then projected to index sets | Coordinate-side only (which input shares, which probe tuple) | Yes, but as a **sufficient** cardinality condition; "`t`-NI is … not a necessary condition" | Exact labelled composition with secret-side witnesses, and freshness verified rather than assumed |
| Secure distributed storage and secure network coding (Pawar et al.; Shah et al.; Rawat et al.; Cai–Yeung; Martínez-Peñas–Matsumoto; Herzberg et al.) | Secrecy capacity, equivocation, rank/matrix weight profiles, with matching constructions | No — amount-only throughout | No | Per-construction analysis; no compositional calculus | Which node or transcript subsets recover which combination, and the transcript-axis composition rule |
| Hierarchical and multilevel secret sharing (Simmons; Brickell; Tassa) | Multipartite access structures over a single flat encoding | No — and no encoding hierarchy at all | No | Not applicable | Hierarchy in the *encoding*, with per-level observation budgets |
| Secret sharing from composed and multiplicative codes (Chen et al.; Cramer–Damgård–Maurer; Cascudo et al.; Márquez-Corbella et al.) | Multiplicativity, composite access structures, asymptotic parameters, ideality | No | No | "Composition" means composite access structures or multiplicativity, not leakage through a concatenation | Leakage analysis *through* the concatenation, which this line does not address |
| Leakage-resilient secret sharing (Benhamouda et al.) | Statistical distance under arbitrary bounded-output functions of each share | Not expressible in the model | No | Not applicable | Not comparable; cite to disclaim overlap |

---

## 9. Coverage statement and read depths

**Full-text count.** **Zero** sources were read at `full text`. Five were read at `partial`:
Kurihara–Uyematsu–Matsumoto 2012; Geil–Martín–Matsumoto–Ruano–Luo (arXiv version); IronMask (eprint);
maskVerif (eprint); Cassiers–Standaert PINI (eprint); plus Cramer–Damgård–Maurer at `partial` for its
abstract and multiplicativity summary only, which makes six. Everything else in this report is
`secondary only` or `abstract/metadata only`, and each is marked in place. A reader should treat every
"amount-only" verdict resting on an abstract as exactly that strong and no stronger.

**Searched and found nothing.** No exact labelled compositional rule for linear gadgets, and no
per-functional leakage witness through a composed encoding, was located in any of the six
literatures at the depths recorded. This is a **survey observation, not a novelty verdict**, and it
must not be quoted as one: the brief's framing is that prior art informs and never gates, and this
report deliberately carries no priority claim. Any future novelty claim would need the owning paper's
claim–proof–novelty ledger row, deeper reads, and the citation-graph width requirement of
`notes/literature-audit-conventions.md`.

**Could not access / not attempted — carried forward as open gaps.**

- MathSciNet: **NOT COVERED** (institutional authentication, unreachable from this session).
- zbMATH Open, OpenAlex, Crossref, Semantic Scholar: **not queried.** No forward-citation closure or
  citing-set enumeration was attempted, because no deliverable here rests on an absence. The
  three-service width requirement therefore did not bind; it would bind on any later novelty task.
- Not opened, and named in the brief: Luo–Mitrpant–Vinck–Chen 2005; Wei 1991; Massey 1993 and 1995;
  Ishai–Sahai–Wagner 2003; SILVER; VRAPS; Barthe et al. 2015 and 2016; Cai–Yeung 2002 and 2011;
  Martínez-Peñas 2016 full texts; Herzberg et al. 1995; Tassa 2007; Brickell 1989; Simmons 1988;
  Chen–Cramer–Goldwasser–de Haan–Vaikuntanathan 2007; Cascudo–Chen–Cramer–Xing 2009; Benhamouda
  et al. 2018.
- Cramer, Damgård, Nielsen, *Secure Multiparty Computation and Secret Sharing* (textbook): **not
  consulted.**
- The two tighter-composition works surfaced in search — "Unifying Freedom and Separation for Tight
  Probing-Secure Composition" (CRYPTO 2023) and "Probing Security through Input-Output Separation and
  Revisited Quasilinear Masking" (IACR TCHES) — were **not opened**, and are the first place a deeper
  check of §3.4 question 3 should go.

**Cached this session** (all `status: ok`, extraction by poppler `pdftotext`):

| key | sha256 | pages |
|---|---|---|
| `eprint:2021/1671` | `f9b1b936d56256649c22fd564c80e921d866be3b5f6da25ea993b38d41d24f47` | 35 |
| `eprint:2018/562` | `98b9c223fed48755678440d8aec22a4022a3aa3936767416c137928f83cfb3c0` | 20 |
| `eprint:2018/438` | `b42403afae17e89aa04e13434d3eaf1c917f49eb0b623a47fbcefa066391b117` | 13 |

Already present in the cache and used here: `10.1587/transfun.E95.A.2067`, `arXiv:1403.7985`,
`10.1007/3-540-45539-6_22` (hashes recorded in place above).

---

## 10. The three things the product should absorb first

1. **The masking-tool gadget corpora as the benchmark suite.** IronMask and maskVerif distribute
   standard gadgets in machine-readable form with published verdicts. Ingesting that format gives the
   privacy interface a test suite with known expected answers and makes every comparison against
   NI/SNI/PINI concrete rather than rhetorical. This is the highest-value item because it is
   engineering with no research risk.
2. **Freshness as a discharged obligation, reported as a diagnostic.** Every tool in §3 takes
   per-gadget fresh randomness as an axiom. Probe 1 §4 gives the two-block counterexample, §3.3's
   Lemma 5 proves the error direction is always toward overstating privacy, and §7 gives the
   mechanical repair. Verifying independence from the encoding and reporting shared randomness as a
   rank drop is a capability no surveyed tool has, and it is the sharpest single product claim
   available.
3. **Speak the two input vocabularies the audiences already use.** The coset construction
   `C_2 ⊊ C_1` from §2 and the multipartite level-and-threshold description from §5 are how the
   secret-sharing community states a scheme; the secure regenerating-code constructions of §4 are
   demo inputs whose published secrecy capacities are a free correctness check on the compiled
   profile — and the profile then says strictly more than the capacity does.

---
