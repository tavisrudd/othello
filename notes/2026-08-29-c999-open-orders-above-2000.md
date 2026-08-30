# C999 Part 2 prep — Hadamard orders still open above 2000

Date: 2026-08-29. Lane: `gem-mining`. Task: C999 Part 2 prep (target selection).
Status: research note, no compute run beyond the cheap checks recorded below.
This file is a preparatory analysis, not a task report and not a novelty verdict for a manuscript.

Companion: `notes/2026-08-29-c999-hadamard-668/README.md` (Part 1 — decoding and structural
identification of the Alpöge–Voinov–Reynolds-Haertle–Claude payload of 2026-08-12, which closed all
twelve remaining admissible orders below 2000).

---

## 0. Source register and read depth

Eleven sources are named below. **Four were read at full text or near-full text** (three Đoković
notes and the Part 1 in-repo README); three were read `partial`; four are `NOT COVERED`.

| # | Source | Read depth | Access |
|---|--------|-----------|--------|
| 1 | Cati & Pasechnik, *A database of constructions of Hadamard matrices*, arXiv:2411.18897**v2** (30 Aug 2025) | `partial` — read §1 Introduction, §2.3 (Williamson/good matrices), §4 (statements of Theorems 5, 6, 7), §6 and §6.1, Table 4 and its footnote 11. Not read: §3, §5, most of §4's worked constructions, Table 5. | lit-cache key `arXiv:2411.18897`, sha256 `12b04b17459e088618af96b624bff0d83eb072626f7de706a94a4b10746c34d6`, fetched 2026-07-31 by an earlier task; `pdftotext` extraction. Preprint version read, not a published version. |
| 2 | Đoković, *Small orders of Hadamard matrices and base sequences*, arXiv:1008.2043**v1** (12 Aug 2010) | `full text` — all 7 pages, including §3 Propositions 3.1–3.4 and the reference list. | lit-cache key `arXiv:1008.2043`, sha256 `e75f1c4094bcc77edbca48737c6e18c0b6d1e2882757bdacdab9e4d52bd64a71`, fetched 2026-08-29 for this task. **Preprint read, not the published version.** |
| 3 | Đoković, *Hadamard matrices of small order and Yang conjecture*, arXiv:0912.5091**v1** (27 Dec 2009); published as J. Combin. Designs **18** (2010), 254–259 | `partial` — read §1, §2, §3 including the full 138-element set Δ. Not read: §4 (near-normal sequences NN(32)–NN(40)). | lit-cache key `arXiv:0912.5091`, sha256 `d079bd8017f204ac91eee5d43c4e98fe0d97e3151520b64dbe23e4f4f575b725`, fetched 2026-08-29. **Preprint read, not the published version**; the journal detail is taken from reference [7] of source 2, not from the journal itself. |
| 4 | Đoković, *Two classes of Hadamard matrices of Goethals–Seidel type*, arXiv:2404.14375**v3** (16 Nov 2024) | `partial` — read the abstract, §1, the listed difference families at v = 547 and v = 631, and §5 "Appendix: Prime chains". Not read: §2–§4 proofs, the full family listings. | lit-cache key `arXiv:2404.14375`, sha256 `30b226f7568ceff89d12a843cb3d8f789e9e411412b88fdfcd3775059cd6f52c`, fetched 2026-08-29. |
| 5 | Wikipedia, *Hadamard matrix*, page state of 2026-08-22, retrieved 2026-08-29 | `partial`, **via the WebFetch summarising model** — the two sentences quoted in §1 below were returned as quotations by that model and are **not byte-verified** against the page source. Treat as `secondary only` with the summariser as the secondary work. | WebFetch, no cached bytes. |
| 6 | *A search for Hadamard matrices of Williamson type*, arXiv:2605.08661v1 (9 May 2026) | `abstract/metadata only` | arXiv Atom API listing, 2026-08-29. Authors not recorded — the API listing was read for title/date/abstract only. |
| 7 | Williamson, Yacobi & Zinn-Justin, *Generating Hadamard matrices with transformers*, arXiv:2604.11101v2 (11 May 2026; v1 13 Apr 2026) | `abstract/metadata only` | arXiv Atom API listing plus a WebFetch of the abstract page, 2026-08-29. |
| 8 | Part 1 in-repo record: `notes/2026-08-29-c999-hadamard-668/README.md` and `evidence/H*.txt` | `full text` for the README; the twelve decoded matrices were read programmatically | in-repo, this commit's parent. |
| 9 | Miyamoto, *A construction for Hadamard matrices*, J. Combin. Theory Ser. A **57** (1991), 86–108 | **NOT COVERED** — ScienceDirect returned HTTP 403. Bibliographic detail taken from reference [13] of source 2 and reference [37] of source 1; the paper itself was not seen. | — |
| 10 | Colbourn & Dinitz (eds), *Handbook of Combinatorial Designs*, 2nd ed. (2007), Table 1.53, pp. 278–279 | **NOT COVERED** — no copy reachable. Characterised only `secondary only` through sources 2 and 3, which both read it at full text. | — |
| 11 | Seberry & Yamada monograph (source 1's reference [48]), Tables A.17 and 9.2 | **NOT COVERED**. Characterised only `secondary only` through source 1. | — |
| 12 | MathSciNet | **NOT COVERED** — institutional authentication, unreachable from this session. Every claim it would have gated keeps "to our knowledge". | — |

**Forward-citation check** on the two seeds that could carry a 2025–2026 closure, resolved by pinned
identifier, run 2026-08-29:

- Seed `arXiv:2411.18897` (OpenAlex `W4405029843`).
  - OpenAlex: `GET https://api.openalex.org/works?filter=cites:W4405029843` → **0** citing works.
  - Semantic Scholar: `GET https://api.semanticscholar.org/graph/v1/paper/arXiv:2411.18897/citations` → **4** citing works, all 2026: *New constructions of optimal arrangements of 2d lines in C^d*; *Efficient Quantum Network Synchronization via LOCC*; *Counting partial Hadamard matrices in the cubic regime*; *An Explicit Skew-Hadamard Matrix of Order 1252 via Cyclotomic Unions*.
  - Crossref: `GET https://api.crossref.org/works/10.48550/arxiv.2411.18897` → HTTP **404**, no record (arXiv DOIs are not deposited with Crossref). Distinguished from an error by the explicit 404 status.
  - **The three graphs disagree (0 / 4 / no record).** That disagreement is itself the reportable finding: an OpenAlex zero here is an indexing gap, not evidence of no citing work.
  - Screened set: the 4 Semantic Scholar records, screened on title only, discriminator "does the title name a Hadamard order, or a construction of ordinary (non-skew, non-complex) Hadamard matrices at unspecified orders?". None promoted. The order-1252 paper is skew-Hadamard; order 1252 already has a known ordinary Hadamard matrix, so it closes nothing here.
- Seed `arXiv:2404.14375`. Semantic Scholar: **2** citing works — sources 7 and 1. Neither closes an order.
- Additional screen: the 30 most recent arXiv submissions matching `all:"Hadamard matrices"`, sorted by submission date descending, retrieved from the arXiv Atom API on 2026-08-29. Screened on title, discriminator "could this close a specific unknown order ≥ 2000?". Two promoted to `abstract/metadata only` reading (sources 6 and 7); neither does.

**Coverage statement.** Searched and found nothing: no 2024–2026 work closing any order in
(2000, 4000] was located. Could not access, and therefore carried forward as open gaps: Miyamoto
1991 (source 9, directly load-bearing — see §2), the Handbook Table 1.53 (source 10), the
Seberry–Yamada tables (source 11), and MathSciNet (source 12).

---

## 1. Is 2004 still open?

**No — and it never was.** Two independent confirmations:

1. **Direct construction.** 2004 = 2003 + 1, 2003 is prime, and 2003 ≡ 3 (mod 4). Paley's first
   construction therefore yields a skew Hadamard matrix of order 2004 outright. Verified here with
   `sympy.isprime(2003) = True`, `2003 mod 4 = 3`.
2. **Table position.** 2004 = 4 · 501 with 501 = 3 · 167 odd. In Table 4 of source 1 an odd n is
   listed only when the minimal exponent m with a known Hadamard matrix of order 2^m·n exceeds 2;
   501 is absent, so m(501) = 2 and order 4·501 is known. 501 is also absent from footnote 11's
   list of entries that Seberry–Yamada had at m > 2.

The published list of open orders never contained 2004. Source 5 reports: *"By 2014, there were 12
multiples of 4 less than 2000 for which no Hadamard matrix of that order was known. They are: 668,
716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916, 1948, and 1964"*, and separately *"In 2026,
Levent Alpöge shared an example of all previously unknown sizes up to 2000, attributing Philippe
Voinov, Saul Reynolds-Haertle, Claude and himself."* (Both sentences carry the source-5 caveat: not
byte-verified.) The "(2004, …)" in the C999 Part 2 framing is a misremembering — most likely of the
year 2004, in which the order-428 case was still open.

**A confirmation of Part 1 worth recording.** The twelve entries of source 1's Table 4 with
n < 500 are exactly 167(3), 179(3), 223(3), 283(3), 311(3), 347(3), 359(4), 419(3), 443(3), 479(4),
487(3), 491(5) — i.e. precisely 4n = 668, 716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916, 1948,
1964, the twelve orders in the decoded payload. The payload closed the whole of Table 4 below 2000
with nothing left over, which is independent evidence that the twelve-order announcement was
complete rather than partial.

---

## 2. Orders 4t in (2000, 4000] with no known Hadamard matrix

> **2060 closed (2026-08-23 gist, verified 2026-08-30).** A gist posted by GitHub user
> `schneiderlo` on 2026-08-23 gives a Hadamard matrix of order 2060; it was fetched and verified
> here (`max |(H Hᵀ)_ij| = 0` off the diagonal in exact `i64`), and its structure is a
> Goethals–Seidel array over four blocks of order `515 = 5 · 103` in a CRT-interleaved index order.
> See `2026-08-29-c999-hadamard-668/external/provenance.md`,
> `2026-08-29-c999-hadamard-668/certificate/H2060.json`, and the "External: order 2060" section of
> `2026-08-29-c999-hadamard-668/certificate/README.md`. **The smallest open admissible order is
> therefore 2092 = 4 · 523**, which was already this note's recommended first target in §4.1. The
> lists and analysis below still list 2060 as open and have not been rewritten.

### 2.1 How the list is derived

Source 1's Table 4 gives, for every odd n ≤ 2999, the minimal exponent m such that a Hadamard matrix
of order 2^m·n is known; n is listed only when m > 2. An order N in (2000, 4000] is therefore open
iff N = 2^a·n with n odd, a ≥ 2, and m(n) > a.

- **a = 2** (N = 4n, n odd, 500 < n ≤ 1000): the live case.
- **a ≥ 3**: requires m(n) > 3 with n odd ≤ 500. The only such entries in Table 4 were 359(4),
  479(4), 491(5) — and the 2026-08-12 closure of orders 1436, 1916, 1964 sets m(359) = m(479) =
  m(491) = 2. Sylvester doubling then covers 8n, 16n, … So **after the 2026 closure there are no
  open orders in this range with a ≥ 3.** Every open order in (2000, 4000] is of the form 4n with n
  odd, i.e. ≡ 4 (mod 8).

### 2.2 A correction to source 1's Table 4

Source 1's Table 4 descends from the Seberry–Yamada tables and records what the authors could
construct in SageMath. It demonstrably lags Đoković's own notes. Source 2 (read at full text) proves
the existence of Hadamard matrices of order 4n for

    n = 787, 823, 883, 1063, 1303, 1527, 2143, 2335, 2545, 2571, 3533, 5441, 5449, 8237, 8573, …

(42 values in all). Source 1 removed only 787 from its table, via footnote 11; **823, 883, 1063,
1303, 1527, 2143, 2335, 2545 and 2571 all remain in Table 4 with m = 3 although source 2 closed
them.** Source 1 cites source 2 (its reference [17]) but only in connection with an unrelated
skew-Hadamard repair at order 292, so the omission looks like an un-mined reference rather than a
disagreement.

Two of those nine fall in range and are removed from the list below:

- **3292 = 4 · 823.** Source 2, Proposition 3.1: apply the second Yamada theorem with q = 821 (prime);
  the required skew Hadamard matrix of order (q+3)/2 = 412 = 4·103 exists.
- **3532 = 4 · 883.** Source 2, Proposition 3.1: apply part (b) of the first Yamada theorem with
  q = 881 (prime); (q+3)/2 = 442, and Mathon's theorem supplies a symmetric conference matrix of
  order 442.

This is the load-bearing caveat on everything below: **Table 4 is an upper bound on the open set, not
the open set.** Further entries in §2.3 may already be closed in literature this audit did not reach
— particularly Miyamoto 1991 (source 9, NOT COVERED), which source 1 says claims order 4·515 = 2060
among others but which it "was unable to verify" for lack of detail. The status of 2060 is therefore
genuinely contested, not merely unknown.

### 2.3 The list

Twenty-six orders, ascending. Every one is ≡ 4 (mod 8); none admits either Paley construction
(checked mechanically: for each N, neither N−1 nor N/2−1 is a prime power of the required residue).

| # | N | N/4 | factorisation of N/4 |
|---|-------|-----|-----------------------|
| 1 | 2060 | 515 | 5 · 103 |
| 2 | 2092 | 523 | 523 (prime) |
| 3 | 2148 | 537 | 3 · 179 |
| 4 | 2284 | 571 | 571 (prime) |
| 5 | 2292 | 573 | 3 · 191 |
| 6 | 2396 | 599 | 599 (prime) |
| 7 | 2572 | 643 | 643 (prime) |
| 8 | 2588 | 647 | 647 (prime) |
| 9 | 2636 | 659 | 659 (prime) |
| 10 | 2676 | 669 | 3 · 223 |
| 11 | 2876 | 719 | 719 (prime) |
| 12 | 2884 | 721 | 7 · 103 |
| 13 | 2956 | 739 | 739 (prime) |
| 14 | 3004 | 751 | 751 (prime) |
| 15 | 3156 | 789 | 3 · 263 |
| 16 | 3356 | 839 | 839 (prime) |
| 17 | 3436 | 859 | 859 (prime) |
| 18 | 3452 | 863 | 863 (prime) |
| 19 | 3628 | 907 | 907 (prime) |
| 20 | 3668 | 917 | 7 · 131 |
| 21 | 3676 | 919 | 919 (prime) |
| 22 | 3732 | 933 | 3 · 311 |
| 23 | 3788 | 947 | 947 (prime) |
| 24 | 3820 | 955 | 5 · 191 |
| 25 | 3884 | 971 | 971 (prime) |
| 26 | 3964 | 991 | 991 (prime) |

**Two structural observations, both mine rather than any source's.**

*Every prime N/4 in the list is ≡ 3 (mod 4).* Seventeen of the twenty-six have N/4 prime, and all
seventeen are ≡ 3 (mod 4). This matches source 4's §5 remark that "the hardest cases are often those
where v is a prime congruent to 3 mod 4 and (v−1)/2 is also a prime", and it is a consequence of the
Paley screen: a prime v ≡ 1 (mod 4) usually falls to Miyamoto's or Yamada's theorems.

*Every composite N/4 in the list is a small factor times one of the hard primes.* The nine composite
cases are 5·103, 3·179, 3·191, 3·223, 7·103, 3·263, 7·131, 3·311, 5·191 — with 179, 223 and 311
being exactly the primes whose orders 716, 892 and 1244 were closed in August 2026, and 103, 131,
191, 263 the same species. All nine collapse onto **seven** Williamson-type existence questions, at
w = 103, 131, 179, 191, 223, 263, 311, through the Cooper–Wallis theorem (four T-matrices of order t
plus four Williamson-type matrices of order w give a Hadamard matrix of order 4tw; T-sequences of
every length ≤ 100 except possibly 97 are known, per source 2). In particular w = 103 alone would
close both 2060 and 2884, and w = 191 alone would close both 2292 and 3820.

**Why that route is not currently available — a negative established here.** The natural hope is
that the newly found order-716/892/1244 circulants *are* Williamson-type, which would close 2148,
2676 and 3732 for free by multiplying by 3. They are not. Reading the four circulant first rows off
the decoded matrices in `notes/2026-08-29-c999-hadamard-668/evidence/` and testing pairwise
amicability (A B^T = B A^T, equivalently symmetry of the cyclic cross-correlation) gives **6 of 6
non-amicable pairs in every one of the nine four-circulant cases** (668, 716, 892, 1132, 1244, 1676,
1772, 1948, 1964); none of the four blocks is a symmetric circulant either. There is no free
multiplication. Independently, source 6 (2026) reports exhaustive near-Williamson results only for
odd orders ≤ 35 and existence only up to 63, so a direct search at w = 103 is well beyond the
published frontier and is not a cheap first move.

---

## 3. Construction routes for the five smallest open orders

### 3.1 The two admissible Goethals–Seidel shapes, stated exactly

Both were read off the decoded matrices rather than taken from a source; the identification with the
Goethals–Seidel array is Part 1's and is mine.

**Plain shape**, order N = 4m with m = N/4 odd. Four ±1 sequences A, B, C, D of length m with

- Σ_i PAF_i(k) = 0 for every k ≢ 0 (mod m), and
- Σ_i (row sum)² = 4m.

Equivalently a 4-{m; k₁,k₂,k₃,k₄; λ} supplementary difference family on Z_m with λ = Σk_i − m
(Đoković's convention, as in his "(547; 273, 260, 260, 260; 506)"). Verified directly on the decoded
matrices — PAF sum identically zero and Σ(row sum)² = N for all five plain cases:

| order | m | row sums | derived (m; k₁,k₂,k₃,k₄; λ) |
|-------|-----|--------------------|------------------------------|
| 892 | 223 | 11, 11, 11, 23 | (223; 106, 106, 106, 100; 195) |
| 1132 | 283 | 19, 19, 19, 7 | (283; 132, 132, 132, 138; 251) |
| 1244 | 311 | 21, 19, 21, 1 | (311; 145, 146, 145, 155; 280) |
| 1948 | 487 | 17, 1, 17, 37 | (487; 235, 243, 235, 225; 451) |
| 1964 | 491 | 29, 27, 15, 13 | (491; 231, 232, 238, 239; 449) |

**Bordered shape** — the 668 case, order N = 4m + 4 with m = (N−4)/4 even. Four ±1 sequences of
length m with

- Σ_i PAF_i(k) = **−4** for every k ≢ 0 (mod m), and
- row sums (±2, 0, 0, 0), i.e. Σ_i (row sum)² = 4,

hence weights ((m∓2)/2, m/2, m/2, m/2), Σk_i = 2m ∓ 1, and Σ_i d_i(k) = Σk_i − m − 1 = m − 2. All
four bordered cases were verified: PAF sum takes the single value −4 at every nonzero shift, and row
sums are exactly (2, 0, 0, 0), at m = 166, 178, 418, 442.

**The power-spectral-density filter, in one line for both shapes.** Writing Â(ω) for the value of
the sequence polynomial at an m-th root of unity, the PAF conditions are equivalent to

    Σ_i |Â_i(ω)|² = N   for every m-th root of unity ω ≠ 1,

with Σ_i |Â_i(1)|² = 4m in the plain shape and 4 in the bordered shape. This is the filter to
implement: any candidate block with |Â(ω)|² > N at any nontrivial ω is discarded immediately, before
it is ever paired.

**An admissibility question settled here.** All four solved bordered instances have m ≡ 2 (mod 4)
(166, 178, 418, 442), which raised the worry that m ≡ 0 (mod 4) is obstructed — that would rule the
bordered route out for 2148 (m = 536) and 2292 (m = 572). It is not obstructed. The counting
identity λ(m−1) = Σk_i² − Σk_i is satisfied identically for every even m, and an exhaustive
meet-in-the-middle search over all four-tuples confirms bordered solutions exist for
m = 2, 4, 6, 8, 10, 12 — both residues. So m ≡ 0 (mod 4) is admissible; it is simply untested at
scale.

### 3.2 Per-target analysis

Read "ladder" as the set of compression divisors d > 1 of m, in the Kotsireas–Koutschan sense: the
d-compression of a length-m sequence sums entries within each residue class mod m/d, has length
m/d, and satisfies PAF_{A^(d)}(k) = Σ_j PAF_A(k + j·m/d), so a solution of the full problem always
projects to a solution of the compressed one. A rich ladder means a cheap multi-stage filter. φ(m)
is given because the order of an assumed multiplier must divide it.

**Baseline — order 668 (solved, m = 166 = 2 · 83).** Ladder {2, 83} only: the single useful stage is
d = 2 giving compressed length 83. φ(166) = 82 = 2 · 41, so the only multiplier orders available are
2 and 41 — 41 being far too strong to be plausible. Raw free bits 4m = 664. **The instance the team
solved in a weekend had the weakest possible compression ladder and essentially no multiplier
structure.**

| N | plain m | bordered m | bordered m mod 4 | plain ladder | bordered ladder | φ(plain) | φ(bordered) |
|------|---------|------------|------|-----------------------|-------------------------------|------|------|
| 2060 | 515 = 5·103 | 514 = 2·257 | 2 | {5, 103} | {2, 257} | 408 | 256 |
| 2092 | 523 prime | 522 = 2·3²·29 | 2 | — none — | {2,3,6,9,18,29,58,87,174,261} | 522 | 168 |
| 2148 | 537 = 3·179 | 536 = 2³·67 | 0 | {3, 179} | {2,4,8,67,134,268} | 356 | 264 |
| 2284 | 571 prime | 570 = 2·3·5·19 | 2 | — none — | {2,3,5,6,10,15,19,30,38,57,95,114,190,285} | 570 | 144 |
| 2292 | 573 = 3·191 | 572 = 2²·11·13 | 0 | {3, 191} | {2,4,11,13,22,26,44,52,143,286} | 380 | 240 |

Route notes per target:

**2060 = 4 · 515.** Structurally the *worst* of the five despite being the smallest. Its plain shape
has m = 515 = 5·103, so the only compression is by 5 (to length 103, over a six-symbol alphabet) or
by 103 (to length 5, too lossy to filter well); its bordered shape m = 514 = 2·257 has the single
stage d = 2 to length 257, worse than the 668 baseline. Legendre-pair route: order 2ℓ+2 = 2060 needs
ℓ = 1029 = 3·7³, which lies in no known Legendre-pair family. Cooper–Wallis needs Williamson-type
matrices of order 103, beyond the frontier of source 6. **And its status is contested**: source 1
reports that Miyamoto's §7 claims order 4·515 is known but that the details are missing; source 9 is
NOT COVERED here. Obtaining Miyamoto 1991 is the single cheapest action that could change this
target's status, in either direction.

**2092 = 4 · 523.** 523 is prime ≡ 3 (mod 4), which is precisely source 4's spin-type GS-difference-family
setting; that paper reports families only at v = 127, 129, 271, 331, 397, 547, 631 and states that
none with v > 631 is known, so the plain route at v = 523 is unattacked but also uncompressible. The
bordered shape is the attractive one: m = 522 ≡ 2 (mod 4), matching all four solved instances, with
a full ladder {2, 3, 6, 9, 18, 29, …} and φ(522) = 168 = 2³·3·7 supplying multiplier orders
2, 3, 4, 6, 7, 8, 12, 14, 21, 24 for assumed-symmetry shards. Legendre pair would need ℓ = 1045 =
5·11·19, no known family.

**2148 = 4 · 537 = 4 · 3 · 179.** Plain m = 537 compresses only by 3 (to 179). Bordered m = 536 =
2³·67 gives {2, 4, 8, 67}, and 536 ≡ 0 (mod 4), the regime shown admissible above but never tried at
scale. Cooper–Wallis with T-matrices of order 3 and Williamson-type matrices of order 179 would
close it; the newly found order-716 circulants do **not** supply those (§2.3). Legendre pair would
need ℓ = 1073 = 29·37, no known family.

**2284 = 4 · 571.** 571 is prime ≡ 3 (mod 4), so the plain shape is incompressible. The bordered
shape is the best-structured of all five: m = 570 = 2·3·5·19 ≡ 2 (mod 4), fourteen nontrivial
compression divisors, φ(570) = 144. Legendre pair would need ℓ = 1141 = 7·163, no known family.

**2292 = 4 · 573 = 4 · 3 · 191.** Bordered m = 572 = 2²·11·13 ≡ 0 (mod 4), ladder
{2, 4, 11, 13, 22, 26, 44, 52}, φ(572) = 240. Its Cooper–Wallis route (Williamson-type at w = 191)
is the one that would pay twice, also closing 3820 = 4·5·191 — but again beyond the published
Williamson frontier. Legendre pair would need ℓ = 1145 = 5·229, no known family.

### 3.3 Compute estimate relative to m = 166

Stated as a bound on what can be claimed, not as a schedule.

**No reliable extrapolation from the 668 weekend exists, and this is a finding rather than a
hedge.** Part 1 established that the posted payload contains no seed and no generator: every `+`/`-`
character is a literal matrix entry, and the search that produced the sequences left no trace. The
method is undisclosed. "A weekend" is therefore a datum about an unknown algorithm on unknown
hardware, and cannot be scaled.

What can be stated:

1. **Raw problem size grows by a factor of about 3.2–3.4 in the exponent.** Free bits 4m: 664 at the
   668 instance, versus 2056–2060 (2060), 2088–2092 (2092), 2144–2148 (2148), 2280–2284 (2284),
   2288–2292 (2292). Under any exponential search model this is not a factor of three in wall clock;
   an unaided search at these m is hopeless, and every target depends entirely on the reductions.
2. **The compression ladder more than compensates, for four of the five.** The compressed-stage
   enumeration at length ℓ = m/d over a (d+1)-symbol alphabet has about 4ℓ·log₂(d+1) bits. At the
   668 baseline the only choice was ℓ = 83 over 3 symbols ≈ 526 bits. Comparable or better options
   exist at 2092 (d = 9 → ℓ = 58 ≈ 771 bits; d = 18 → ℓ = 29 ≈ 493 bits), 2284 (d = 15 → ℓ = 38
   ≈ 608; d = 19 → ℓ = 30 ≈ 508; d = 30 → ℓ = 19 ≈ 376) and 2292 (d = 13 → ℓ = 44 ≈ 670; d = 22 →
   ℓ = 26 ≈ 470). They do **not** exist at 2060, whose best plain option is ℓ = 103 over 6 symbols
   ≈ 1065 bits — twice the 668 baseline in the exponent. The catch, stated plainly: a larger d makes
   the compressed stage cheaper but the lift back correspondingly more expensive, so the ladder buys
   a cheap *pre-filter*, not a cheap *solution*. Its value is that it shards: the compressed stage
   partitions the space into independent lifting jobs.
3. **Multiplier assumptions are where the real reduction lives, and they are gambles.** Assuming
   invariance under a multiplier of order r cuts free bits to about 4m/r. At m = 166 only r = 2 was
   available (332 bits). At m = 522, r = 7 gives ≈ 298 bits and r = 8 gives ≈ 261; at m = 570, r = 9
   gives ≈ 253 and r = 16 gives ≈ 143; at m = 515, r = 17 gives ≈ 121. Each such shard is cheap and
   may simply be empty — a negative result on an assumed-multiplier shard says nothing about
   existence.
4. **Order-of-magnitude ask.** A full multiplier-assumed sweep across all five targets, both shapes,
   every multiplier order r ≥ 3 dividing φ(m), is on the order of 10²–10³ core-hours and is
   embarrassingly parallel. An unassumed compressed PSD search at a single target is the weekend-to-
   month-scale item and is the thing that needs approval.

---

## 4. Recommended first target and search plan

### 4.1 Target

**Recommend 2092 = 4 · 523, attacked in the bordered Goethals–Seidel shape at m = 522 = 2 · 3² · 29,
with 2284 = 4 · 571 (bordered, m = 570) as the immediate second shard sharing all machinery.**

Reasons, in order of weight:

1. It is the **second-smallest open order**, so a success is a headline result and not a curiosity.
2. Its bordered length **m = 522 ≡ 2 (mod 4) matches all four solved bordered instances** (166, 178,
   418, 442). This is the only shape for which we hold four worked examples, decoded and verified.
3. It has the compression structure the 668 instance lacked entirely: the ladder
   {2, 3, 6, 9, 18, 29, …} against {2} at m = 166, and φ(522) = 168 with small multiplier orders
   3, 4, 6, 7, 8 against φ(166) = 82 with only 2 and 41.
4. Its plain-shape alternative at the prime v = 523 is exactly the family source 4 attacked and did
   not reach, so a bordered success there is not duplicating a live effort.

**Not 2060**, despite being the smallest: both its shapes are structurally worse than the 668
instance we know was hard, and its status is contested by an unverified Miyamoto claim. The right
move on 2060 is a library action, not a compute action — obtain Miyamoto 1991 (source 9) and settle
whether §7 really constructs order 4·515. That is cheap and should be done regardless.

### 4.2 Plan, sized for approval

**Stage 0 — library, ~1 day, no compute.** Obtain Miyamoto 1991 and the Handbook Table 1.53, and
re-derive the §2.3 list against them rather than against source 1's Table 4 alone. This is the
highest-value action in the whole plan: §2.2 already shows Table 4 carries at least nine stale
entries from a single un-mined 2010 note, so the true open list may be shorter than twenty-six.
Nothing downstream should be committed to publicly before this is done.

**Stage 1 — multiplier-assumed sweep, ~10²–10³ core-hours, no approval needed beyond compute.** For
each of the five smallest orders, both shapes, every multiplier order r ≥ 3 dividing φ(m): enumerate
the multiplier-invariant candidate blocks, apply the PSD filter Σ|Â_i(ω)|² = N, join. Cheap,
embarrassingly parallel, and each shard either produces a matrix or a clean emptiness certificate.

**Stage 2 — unassumed compressed PSD search at 2092, bordered, m = 522.** This is the item that
needs approval. Two-level filter: compress by d = 18 to length 29 as a fast pre-filter, then by
d = 6 or d = 9 (lengths 87 and 58) as the working level, then lift. Quotient by the equivalence
group (cyclic shift, decimation by units of Z₅₂₂, negation, block permutation) before enumerating,
and fix the weight vector ((m−2)/2, m/2, m/2, m/2) = (260, 261, 261, 261) up front.

**Disclosure discipline — the differentiator.** The August 2026 announcement published matrices with
no method and no search trace. This effort does the opposite:

- The search code, the shard-partition function, and the PSD filter are published before the run.
- **Every shard emits a coverage certificate**: a JSONL record carrying the shard's canonical spec
  (target order, shape, m, compression divisor, multiplier assumption, weight vector, and the exact
  half-open range of compressed-candidate indices), the count enumerated, the count surviving PSD,
  the count lifted, and a SHA-256 of the spec. On success it carries the four sequences.
- **The union of shards is machine-checkable against the declared domain.** An independent replay of
  the partition function must reproduce the shard boundaries exactly, so that a reader can verify
  that the shards cover the claimed search domain with no gap and no overlap — which is what makes a
  negative result publishable, not merely a failure to find.
- Certificates, generator, and replay command are committed as one atomic bundle per
  `notes/research-reproducibility-conventions.md`, with an independent orthogonality check of any
  matrix found (the `max |H Hᵀ − N·I| = 0` check already used in Part 1).

A negative outcome is a real deliverable here. "No bordered Goethals–Seidel solution exists at
m = 522 within this fully specified domain" is a publishable and citable statement in a way that
"we searched and did not find" is not.

---

## 5. Open questions

1. **How stale is Table 4 really?** One un-mined 2010 note accounts for nine stale entries. Đoković
   published a series of such notes; sources 2 and 3 were read, but the series was not enumerated.
   The open list may shrink materially. Owner: Stage 0. Evidence gap: sources 9, 10, 11 NOT COVERED.
2. **Is order 2060 already closed?** Source 1 says Miyamoto claims 4·515 and could not verify it.
   Until source 9 is read, 2060 is neither confirmably open nor confirmably closed, and it should not
   be described as "the smallest order with no known Hadamard matrix" in any public text.
3. **Why is every prime N/4 in the open list ≡ 3 (mod 4)?** Source 4's §5 observes the pattern and
   builds a prime-chain heuristic on it; the Paley screen explains why v ≡ 1 (mod 4) mostly falls,
   but not why nothing at all survives at v ≡ 1 (mod 4) in this range. Settled enough to state as an
   observation; not settled as an explanation.
4. **Does the bordered shape at m ≡ 0 (mod 4) behave differently at scale?** Shown admissible at
   m ≤ 12 by exhaustive search here, and unobstructed by the counting identity, but never solved at
   large m. If 2148 or 2292 is attacked in the bordered shape this is the first thing that could
   surprise us.
5. **Where did the August 2026 sequences come from?** Part 1 established there is no generator in the
   payload. Reverse-engineering the search from the nine four-circulant solutions — their weight
   vectors, multiplier orbits, and compressed images — is a genuinely open question and would
   directly calibrate Stage 2's cost model. None of the nine is multiplier-symmetric in the obvious
   way (no block is a symmetric circulant, and no pair is amicable), which is itself informative:
   whatever produced them did not assume symmetry.

### Provenance of the computations in this note

All checks are cheap, deterministic, standard-library or `sympy`/`uv` Python, run 2026-08-29 against
the committed files in `notes/2026-08-29-c999-hadamard-668/evidence/`. They are: extraction of the
four circulant first rows from the decoded matrices; PAF-sum and row-sum verification for all nine
four-circulant cases; the pairwise-amicability and symmetric-circulant tests; the Paley screen over
the twenty-six open orders; and the exhaustive bordered-shape search for m ≤ 12. The scripts were
written to a scratchpad and are not committed; if any of these becomes paper-facing, it must be
re-run from a committed generator under `notes/research-reproducibility-conventions.md`. Nothing in
this note is currently offered as a paper-facing computational claim.
