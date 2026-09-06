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
