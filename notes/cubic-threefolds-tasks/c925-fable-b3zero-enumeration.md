# C925 — Complete roster of smooth Fano threefolds with $h^{1,2}=0$ ($b_3=0$)

**Status**: certified 2026-08-23 — first pass drafted by a delegated agent from the fanography
data and the cached CCGK text; the two flagged rows (3-8, 3-17) and the classification criteria
audited and resolved by hand (see the escapee audit section).  Lane: `cubic-threefolds`, task
C925.  Companion closure note: `notes/2026-08-23-c925-fable-b3zero-enumeration-closure.md`.

## Provenance

### $h^{1,2}$ data

- Source: `pbelmans/fanography` GitHub repository, file `data/data.yml`.
- URL fetched: `https://raw.githubusercontent.com/pbelmans/fanography/master/data/data.yml`
- Branch: `master`. Latest commit touching `data/data.yml` at fetch time:
  `d2122e727a963b58befe8f23bd7bfb90cbe68ce8` (2026-06-30T10:09:28Z).
- Local copy: `notes/cubic-threefolds-tasks/c925-fanography-h12-source.yaml`
- SHA-256 of local copy: `a5c769b0fc4ab284669bf7328789a35f9ddff94638767eaa04620e42a43d1c6f`
- Fetched: 2026-08-23.
- Parse: 105 top-level families confirmed (Picard ranks 1..10). Field `h12` present on every entry.
  Field `toric: <n>` present on exactly 18 entries (`n` = index in the standard smooth toric Fano
  threefold list); all 18 have `h12 = 0`.

### Constructions

- Coates–Corti–Galkin–Kasprzyk, *Quantum Periods for 3-Dimensional Fano Manifolds*,
  arXiv:1303.3288. Plain-text extraction cached at
  `/tmp/persistent/tavis/lit-search/text/arXiv_1303.3288.txt`.
- Line numbers below refer to that text file.

### Spot-checks of the fanography $h^{1,2}$ values

All eight requested spot-checks agree with independent knowledge; **no disagreements flagged**.

| family | fanography `h12` | fanography `-K_X^3` | fanography description | independent check |
|---|---|---|---|---|
| 1-17 | 0  | 64 | $\mathbb{P}^3$ | agrees ($\mathbb{P}^3$, $b_3=0$) |
| 1-16 | 0  | 54 | degree-2 hypersurface in $\mathbb{P}^4$ | agrees ($Q^3$, $b_3=0$) |
| 1-15 | 0  | 40 | codim-3 linear section of $\mathrm{Gr}(2,5)$ | agrees ($V_5$, degree 5, $-K^3=40$, $b_3=0$) |
| 1-10 | 0  | 22 | zero locus of $(\wedge^2\mathcal{U}^\vee)^{\oplus 3}$ on $\mathrm{Gr}(3,7)$ | agrees ($V_{22}$, $-K^3=22$, $b_3=0$) |
| 1-1  | 52 | 2  | double cover of $\mathbb{P}^3$ branched in a sextic | agrees ($h^{1,2}=52$) |
| 2-24 | 0  | 30 | $(1,2)$ divisor on $\mathbb{P}^2\times\mathbb{P}^2$ | agrees ($b_3=0$) |
| 2-25 | 1  | 32 | blowup of $\mathbb{P}^3$ in an elliptic curve $=Q_1\cap Q_2$ | agrees ($h^{1,2}=1$, elliptic centre) |
| 4-1  | 1  | 24 | $(1,1,1,1)$ divisor on $(\mathbb{P}^1)^4$ | agrees ($h^{1,2}=1$) |
| 3-1  | 8  | 12 | double cover of $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$ branched in a $(2,2,2)$ divisor | agrees (nonzero, $h^{1,2}=8$) |

## Step 1 result — the $b_3=0$ roster

**Total: 59 families out of 105** have $h^{1,2}=0$.

Grouped by Picard rank $\rho$:

| $\rho$ | count | families |
|---|---|---|
| 1  | 4  | 1-10, 1-15, 1-16, 1-17 |
| 2  | 14 | 2-20, 2-21, 2-22, 2-24, 2-26, 2-27, 2-29, 2-30, 2-31, 2-32, 2-33, 2-34, 2-35, 2-36 |
| 3  | 22 | 3-5, 3-8, 3-10, 3-12, 3-13, 3-15, 3-16, 3-17, 3-18, 3-19, 3-20, 3-21, 3-22, 3-23, 3-24, 3-25, 3-26, 3-27, 3-28, 3-29, 3-30, 3-31 |
| 4  | 11 | 4-3, 4-4, 4-5, 4-6, 4-7, 4-8, 4-9, 4-10, 4-11, 4-12, 4-13 |
| 5  | 3  | 5-1, 5-2, 5-3 |
| 6  | 1  | 6-1 |
| 7  | 1  | 7-1 |
| 8  | 1  | 8-1 |
| 9  | 1  | 9-1 |
| 10 | 1  | 10-1 |

Checksum: $4+14+22+11+3+1+1+1+1+1 = 59$.

## FLAG — CCGK rank-4 numbering is offset by one from fanography

This is load-bearing for reading the line numbers below and must not be silently absorbed.

Mori and Mukai's original rank-4 list omitted one family. CCGK reinstate it **in degree order**, as
their section "The Fano Manifold MM4–2", with footnote 18 at line 9224:

> "Mori and Mukai initially missed this variety [49, 53]. We put it where it belongs in their scheme."

Fanography (and the now-standard convention) instead **appends** the missing family at the end of
rank 4, as `4-13`. Consequently CCGK's section labels `MM4–3` … `MM4–13` are each one higher than
the fanography label for the same variety. The verified dictionary is:

| fanography label | CCGK section label | identifying construction | $-K^3$ |
|---|---|---|---|
| 4-1  | MM4–1  | $(1,1,1,1)$ divisor on $(\mathbb{P}^1)^4$ | 24 |
| 4-13 | MM4–2  | blow-up of $(\mathbb{P}^1)^3$ in a curve of tridegree $(1,1,3)$ | 26 |
| 4-2  | MM4–3  | blow-up of the quadric cone in vertex $\sqcup$ elliptic curve | 28 |
| 4-3  | MM4–4  | blow-up of $(\mathbb{P}^1)^3$ in a curve of tridegree $(1,1,2)$ | 30 |
| 4-4  | MM4–5  | blow-up of $Y_{3-19}$ in the strict transform of a conic | 32 |
| 4-5  | MM4–6  | blow-up of $\mathbb{P}^2\times\mathbb{P}^1$ in $(1,2)\sqcup(0,1)$ | 32 |
| 4-6  | MM4–7  | blow-up of $(\mathbb{P}^1)^3$ in a curve of tridegree $(1,1,1)$ | 34 |
| 4-7  | MM4–8  | blow-up of $W$ in $(0,1)\sqcup(1,0)$ | 36 |
| 4-8  | MM4–9  | blow-up of $(\mathbb{P}^1)^3$ in a curve of tridegree $(0,1,1)$ | 38 |
| 4-9  | MM4–10 | blow-up of $Y_{3-25}$ in an exceptional line | 40 |
| 4-10 | MM4–11 | $S_7\times\mathbb{P}^1$ | 42 |
| 4-11 | MM4–12 | blow-up of $\mathbb{P}^1\times\mathbb{F}_1$ in $t\times e$ | 44 |
| 4-12 | MM4–13 | blow-up of $Y_{2-33}$ in two exceptional lines | 46 |

Cross-check of the dictionary by anticanonical degree, using
$(-K_X)^3=(-K_Y)^3-2(-K_Y\cdot C)+2g-2$ on $(\mathbb{P}^1)^3$ (where $(-K)^3=48$ and
$-K\cdot C=2(a+b+c)$ for a rational curve of tridegree $(a,b,c)$): tridegree $(1,1,3)\mapsto 26$,
$(1,1,2)\mapsto 30$, $(1,1,1)\mapsto 34$, $(0,1,1)\mapsto 38$. These match fanography's
$-K^3$ for 4-13, 4-3, 4-6, 4-8 respectively, so the dictionary is confirmed independently of the
prose match.

**No comparable offset exists in any other Picard rank.** The footnote quoted above is the only
occurrence of "initially missed" / "where it belongs" in the whole CCGK text, and the rank-2,
rank-3, and rank-$\ge 5$ constructions match fanography's descriptions label-for-label.

All fanography labels in the master table below are fanography/standard labels; the CCGK line
numbers point into CCGK's own (rank-4-shifted) sections.

## Master table — 59 families with $b_3=0$, classified

Criterion applied in the order RANK1 > TORIC > PRODUCT > CHAIN > HOMOGENEOUS > BUNDLE > ESCAPEE
(first one that applies wins). "CCGK line" is the line in
`/tmp/persistent/tavis/lit-search/text/arXiv_1303.3288.txt` carrying the quoted sentence.
Quotes are verbatim except for repair of OCR ligature/spacing noise and mathematical
retypesetting; no words are changed.

| family | h12 | criterion | base / chain | CCGK line | Mori–Mukai construction (verbatim, one sentence) |
|---|---|---|---|---|---|
| 1-10 | 0 | RANK1 | $V_{22}$ | 2452 / 2455 | §17 "The Fano Manifold $V_{22}$"; *Construction:* "The vanishing locus $X$ of a general section of the vector bundle" $(\wedge^2\mathcal{U}^\vee)^{\oplus 3}$ on $\mathrm{Gr}(3,7)$. |
| 1-15 | 0 | RANK1 | $V_5=B_5$ | 2009 / 2012 | §7 "The Fano Manifold $B_5$"; *Construction:* "A complete intersection $X$ in $\mathrm{Gr}(2,5)$ cut out by a section of $\mathcal{O}(1)^{\oplus 3}$." |
| 1-16 | 0 | RANK1 | $Q^3$ | 1849 | §2 "The Fano Manifold $Q^3$" (quadric threefold in $\mathbb{P}^4$). |
| 1-17 | 0 | RANK1 | $\mathbb{P}^3$ | 1820 | §1 "The Fano Manifold $\mathbb{P}^3$". (Also toric, index 23; RANK1 takes precedence.) |
| 2-20 | 0 | CHAIN | 1-15 ($B_5$, RANK1) | 4381 | "The blow-up of $B_5\subset\mathbb{P}^6$ with centre a twisted cubic on it." |
| 2-21 | 0 | CHAIN | 1-16 ($Q^3$, RANK1) | 4631 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre a rational normal curve of degree 4 on it." |
| 2-22 | 0 | CHAIN | 1-15 ($B_5$, RANK1) | 4872 | "The blow-up of $B_5\subset\mathbb{P}^6$ with centre a conic on it." |
| 2-24 | 0 | BUNDLE | $\mathbb{P}(E)$ over $\mathbb{P}^2$ | 5256 | "A divisor of bidegree $(1,2)$ on $\mathbb{P}^2\times\mathbb{P}^2$." (Bundle structure over $\mathbb{P}^2$ proved separately, not stated by CCGK; *Our construction*, line 5257: "A member $X$ of $\|L+2M\|$ in the toric variety $F=\mathbb{P}^2\times\mathbb{P}^2$.") |
| 2-26 | 0 | CHAIN | 1-15 ($B_5$, RANK1) | 5333 | "The blow-up of $B_5\subset\mathbb{P}^6$ with centre a line on it." |
| 2-27 | 0 | CHAIN | 1-17 ($\mathbb{P}^3$, RANK1) | 5666 | "The blow up of $\mathbb{P}^3$ with centre a twisted cubic." |
| 2-29 | 0 | CHAIN | 1-16 ($Q^3$, RANK1) | 5824 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^3$ with centre a conic on it." (CCGK writes $\mathbb{P}^3$; $\mathbb{P}^4$ is meant.) |
| 2-30 | 0 | CHAIN | 1-17 ($\mathbb{P}^3$, RANK1) | 5883 | "The blow-up of $\mathbb{P}^3$ with centre a conic." |
| 2-31 | 0 | CHAIN | 1-16 ($Q^3$, RANK1) | 5942 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre a line on it." |
| 2-32 | 0 | HOMOGENEOUS | flag threefold $W=\mathrm{Fl}(1,2;\mathbb{C}^3)$ | 6004 | "The divisor $W$ of bidegree $(1,1)$ on $\mathbb{P}^2\times\mathbb{P}^2$." |
| 2-33 | 0 | TORIC | toric index 19 | 6052 | "The blow-up of $\mathbb{P}^3$ with centre a line." |
| 2-34 | 0 | TORIC | toric index 22 | 6105 | "$\mathbb{P}^1\times\mathbb{P}^2$." |
| 2-35 | 0 | TORIC | toric index 20 | 6145 | "$B_7$, the blow-up of $\mathbb{P}^3$ at a point; equivalently, the $\mathbb{P}^1$-bundle $\mathbb{P}(\mathcal{O}+\mathcal{O}(1))$ over $\mathbb{P}^2$." |
| 2-36 | 0 | TORIC | toric index 7 | 6198 | "The blow-up of the Veronese cone $W_4\subset\mathbb{P}^6$ with centre the vertex; equivalently, the $\mathbb{P}^1$-bundle $\mathbb{P}(\mathcal{O}\oplus\mathcal{O}(2))$ over $\mathbb{P}^2$." |
| 3-5  | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC) | 6789 | "The blow-up of $\mathbb{P}^1\times\mathbb{P}^2$ with centre a curve $C$ of bidegree $(5,2)$ such that the composition $C\hookrightarrow\mathbb{P}^1\times\mathbb{P}^2\to\mathbb{P}^2$ with projection to the second factor is an embedding." |
| 3-8  | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC); alt. 2-24 (BUNDLE) | 7176 | "A member of the linear system $\|p_1^\star g^\star\mathcal{O}(1)\otimes p_2^\star\mathcal{O}(2)\|$ on $\mathbb{F}_1\times\mathbb{P}^2$ where $p_i$ ($i=1,2$) is the projection to the $i$th factor and $g:\mathbb{F}_1\to\mathbb{P}^2$ is the blowing-up." (Blowdown structures from the Mori–Mukai extremal data via fanography; see the audit section.) |
| 3-10 | 0 | CHAIN | 2-29 → 1-16 ($Q^3$, RANK1) | 7334 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre a disjoint union of two conics on it." |
| 3-12 | 0 | CHAIN | 2-27 → 1-17 ($\mathbb{P}^3$, RANK1) | 7525 | "The blow-up of $\mathbb{P}^3$ with centre a disjoint union of a line and a twisted cubic." |
| 3-13 | 0 | CHAIN | 2-32 ($W$, HOMOGENEOUS) | 7598 | "The blow-up of $W\subset\mathbb{P}^2\times\mathbb{P}^2$ with centre a curve $C$ of bidegree $(2,2)$ on it such that $C\hookrightarrow W\to\mathbb{P}^2\times\mathbb{P}^2\xrightarrow{p_i}\mathbb{P}^2$ is an embedding for both $i=1,2$." |
| 3-15 | 0 | CHAIN | 2-29 → 1-16 ($Q^3$, RANK1) | 7846 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre a disjoint union of a line and a conic on it." |
| 3-16 | 0 | CHAIN | 2-35 ($B_7=\mathrm{Bl}_p\mathbb{P}^3$, TORIC) | 7936 | "The blow-up of $B_7$ (see §52) with centre the strict transform of a twisted cubic passing through the centre of the blow-up $B_7\to\mathbb{P}^3$." |
| 3-17 | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC); alt. BUNDLE over $\mathbb{P}^1\times\mathbb{P}^1$ | 8097 | "A nonsingular divisor of tridegree $(1,1,1)$ on $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^2$." (Blowdown and bundle structures from the Mori–Mukai extremal data via fanography; see the audit section.) |
| 3-18 | 0 | CHAIN | 2-30 → 1-17 ($\mathbb{P}^3$, RANK1) | 8151 | "The blow-up of $\mathbb{P}^3$ with centre the disjoint union of a line and a conic." |
| 3-19 | 0 | CHAIN | 1-16 ($Q^3$, RANK1) | 8233 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre two points $P_1$ and $P_2$ on it which are not collinear." |
| 3-20 | 0 | CHAIN | 2-31 → 1-16 ($Q^3$, RANK1) | 8290 | "The blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre two disjoint lines on it." |
| 3-21 | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC) | 8383 | "The blow-up of $\mathbb{P}^1\times\mathbb{P}^2$ with centre a curve of bidegree $(2,1)$." |
| 3-22 | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC) | 8457 | "The blow-up of $\mathbb{P}^1\times\mathbb{P}^2$ with centre a conic in $t\times\mathbb{P}^2$ ($t\in\mathbb{P}^1$)." |
| 3-23 | 0 | CHAIN | 2-35 ($B_7=\mathrm{Bl}_p\mathbb{P}^3$, TORIC) | 8535 | "The blow-up of $B_7$ (see §52) with centre a conic passing through the centre of the blow-up $B_7\to\mathbb{P}^3$." |
| 3-24 | 0 | BUNDLE | $\mathbb{P}^1$-bundle over $\mathbb{F}_1=\mathrm{Bl}_p\mathbb{P}^2$ | 8646 | "The fibre product $W\times_{\mathbb{P}^2}\mathbb{F}_1$, where $W\to\mathbb{P}^2$ is a $\mathbb{P}^1$-bundle and $p:\mathbb{F}_1\to\mathbb{P}^2$ is the blow-up." |
| 3-25 | 0 | TORIC | toric index 18 | 8749 | "The blow-up of $\mathbb{P}^3$ with centre two disjoint lines; equivalently, $\mathbb{P}(\mathcal{O}(1,0)\oplus\mathcal{O}(0,1))$ over $\mathbb{P}^1\times\mathbb{P}^1$." |
| 3-26 | 0 | TORIC | toric index 16 | 8812 | "The blow-up of $\mathbb{P}^3$ with centre a disjoint union of a point and a line." |
| 3-27 | 0 | TORIC | toric index 21 | 8883 | "$\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$." |
| 3-28 | 0 | TORIC | toric index 17 | 8933 | "$\mathbb{P}^1\times\mathbb{F}_1$." |
| 3-29 | 0 | TORIC | toric index 6 | 8978 | "The blow-up of $B_7$ (see §52) with centre a line on the exceptional divisor $D\cong\mathbb{P}^2$ of the blow-up $B_7\to\mathbb{P}^3$." |
| 3-30 | 0 | TORIC | toric index 12 | 9057 | "The blow-up of $B_7$ (see §52) with centre the strict transform of a line passing through the centre of the blow-up $B_7\to\mathbb{P}^3$." |
| 3-31 | 0 | TORIC | toric index 11 | 9119 | "The blow-up of the cone over a nonsingular quadric surface in $\mathbb{P}^3$ with centre the vertex; equivalently, the $\mathbb{P}^1$-bundle $\mathbb{P}(\mathcal{O}\oplus\mathcal{O}(1,1))$ over $\mathbb{P}^1\times\mathbb{P}^1$." |
| 4-3  | 0 | CHAIN | 3-27 ($(\mathbb{P}^1)^3$, TORIC) | 9585 (CCGK MM4–4) | "The blow-up of $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$ with centre a curve $\Gamma$ of tridegree $(1,1,2)$." |
| 4-4  | 0 | CHAIN | 3-19 → 1-16 ($Q^3$, RANK1) | 9688 (CCGK MM4–5) | "The blow-up of $Y_{3-19}$, which is the blow-up of a quadric 3-fold $Q\subset\mathbb{P}^4$ with centre two points $P_1$ and $P_2$ on it which are not collinear (see §72), with centre the strict transform of a conic containing $P_1$ and $P_2$." |
| 4-5  | 0 | CHAIN | 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$, TORIC) | 9768 (CCGK MM4–6) | "The blow-up of $\mathbb{P}^2\times\mathbb{P}^1$ with centre two disjoint curves, one of bidegree $(1,2)$ and the other of bidegree $(0,1)$." |
| 4-6  | 0 | CHAIN | 3-27 ($(\mathbb{P}^1)^3$, TORIC) | 9942 (CCGK MM4–7) | "the blow-up of $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$ with centre the curve of tridegree $(1,1,1)$." |
| 4-7  | 0 | CHAIN | 2-32 ($W$, HOMOGENEOUS) | 10028 (CCGK MM4–8) | "The blow-up of $W$ (a divisor of bidegree $(1,1)$ in $\mathbb{P}^2\times\mathbb{P}^2$; see §49) with centre two disjoint curves on it, of bidegree $(0,1)$ and $(1,0)$." |
| 4-8  | 0 | CHAIN | 3-27 ($(\mathbb{P}^1)^3$, TORIC) | 10123 (CCGK MM4–9) | "the blow-up of $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$ with centre a curve of tridegree $(0,1,1)$." |
| 4-9  | 0 | TORIC | toric index 13 | 10223 (CCGK MM4–10) | "The blow-up of $Y_{3-25}$, which is the blow-up of $\mathbb{P}^3$ with centre two disjoint lines (see §78), with centre an exceptional line of the blow-up $Y\to\mathbb{P}^3$." |
| 4-10 | 0 | TORIC | toric index 14 | 10309 (CCGK MM4–11) | "$S_7\times\mathbb{P}^1$." ($S_7=\mathrm{Bl}_2\mathbb{P}^2$; also PRODUCT, but TORIC takes precedence.) |
| 4-11 | 0 | TORIC | toric index 10 | 10333 (CCGK MM4–12) | "The blow-up of $\mathbb{P}^1\times\mathbb{F}_1$ with centre $t\times e$, where $t\in\mathbb{P}^1$ and $e$ is the exceptional curve on $\mathbb{F}_1$." |
| 4-12 | 0 | TORIC | toric index 8 | 10427 (CCGK MM4–13) | "The blow-up of $Y_{2-33}$, which is the blow-up of $\mathbb{P}^3$ with centre a line (see §50), with centre two exceptional lines of the blow-up $Y\to\mathbb{P}^3$." |
| 4-13 | 0 | CHAIN | 3-27 ($(\mathbb{P}^1)^3$, TORIC) | 9223 (CCGK MM4–2) | "The blow-up of $\mathbb{P}^1\times\mathbb{P}^1\times\mathbb{P}^1$ with centre a curve of tridegree $(1,1,3)$." (The family Mori–Mukai initially missed.) |
| 5-1  | 0 | CHAIN | 2-29 → 1-16 ($Q^3$, RANK1) | 10532 | "The blow-up of $Y_{2-29}$, which is the blow-up of a quadric 3-fold $Q\subset\mathbb{P}^3$ with centre a conic on it (see §46), with centre three exceptional lines of the blow-up $Y\to Q$." |
| 5-2  | 0 | TORIC | toric index 9 | 10651 | "The blow-up of $Y_{3-25}$, which is the blow-up of $\mathbb{P}^3$ with centre two disjoint lines (see §78), with centre two exceptional lines $\ell,\ell'$ of the blow-up $f:Y\to\mathbb{P}^3$ such that $\ell$ and $\ell'$ lie on the same irreducible component of the exceptional set of $f$." |
| 5-3  | 0 | TORIC | toric index 15 | 10759 | "$S_6\times\mathbb{P}^1$." ($S_6=\mathrm{Bl}_3\mathbb{P}^2$; also PRODUCT, but TORIC takes precedence.) |
| 6-1  | 0 | PRODUCT | $S_5\times\mathbb{P}^1$, $S_5=\mathrm{Bl}_4\mathbb{P}^2$ | 10788 | "$S_5\times\mathbb{P}^1$." |
| 7-1  | 0 | PRODUCT | $S_4\times\mathbb{P}^1$, $S_4=\mathrm{Bl}_5\mathbb{P}^2$ | 10810 | "$S_4\times\mathbb{P}^1$." |
| 8-1  | 0 | PRODUCT | $S_3\times\mathbb{P}^1$, $S_3=\mathrm{Bl}_6\mathbb{P}^2$ (cubic surface) | 10838 | "$S_3\times\mathbb{P}^1$." |
| 9-1  | 0 | PRODUCT | $S_2\times\mathbb{P}^1$, $S_2=\mathrm{Bl}_7\mathbb{P}^2$ | 10859 | "$S_2\times\mathbb{P}^1$." |
| 10-1 | 0 | PRODUCT | $S_1\times\mathbb{P}^1$, $S_1=\mathrm{Bl}_8\mathbb{P}^2$ | 10881 | "$S_1\times\mathbb{P}^1$." |

## Toric cross-check — exactly 18

The fanography `data.yml` carries a `toric: <n>` field on exactly 18 of the 105 entries, and all 18
have $h^{1,2}=0$. This matches the classical count of 18 smooth toric Fano threefolds
(Batyrev / Watanabe–Watanabe), so no toric family is missing from the roster and none is spurious.

| MM label | toric index in fanography | classified as |
|---|---|---|
| 1-17 | 23 | RANK1 (precedence) |
| 2-33 | 19 | TORIC |
| 2-34 | 22 | TORIC |
| 2-35 | 20 | TORIC |
| 2-36 | 7  | TORIC |
| 3-25 | 18 | TORIC |
| 3-26 | 16 | TORIC |
| 3-27 | 21 | TORIC |
| 3-28 | 17 | TORIC |
| 3-29 | 6  | TORIC |
| 3-30 | 12 | TORIC |
| 3-31 | 11 | TORIC |
| 4-9  | 13 | TORIC |
| 4-10 | 14 | TORIC |
| 4-11 | 10 | TORIC |
| 4-12 | 8  | TORIC |
| 5-2  | 9  | TORIC |
| 5-3  | 15 | TORIC |

The 18 toric indices are $\{6,7,\dots,23\}$ — eighteen consecutive values with no repeat and no
gap, an independent consistency check on the extraction. 17 rows carry the TORIC label because
1-17 ($\mathbb{P}^3$) is absorbed by the higher-precedence RANK1 criterion.

## Counts per criterion

| criterion | count | families |
|---|---|---|
| RANK1 | 4 | 1-10, 1-15, 1-16, 1-17 |
| TORIC | 17 | 2-33, 2-34, 2-35, 2-36, 3-25, 3-26, 3-27, 3-28, 3-29, 3-30, 3-31, 4-9, 4-10, 4-11, 4-12, 5-2, 5-3 |
| PRODUCT | 5 | 6-1, 7-1, 8-1, 9-1, 10-1 |
| CHAIN | 30 | 2-20, 2-21, 2-22, 2-26, 2-27, 2-29, 2-30, 2-31, 3-5, 3-8, 3-10, 3-12, 3-13, 3-15, 3-16, 3-17, 3-18, 3-19, 3-20, 3-21, 3-22, 3-23, 4-3, 4-4, 4-5, 4-6, 4-7, 4-8, 4-13, 5-1 |
| HOMOGENEOUS | 1 | 2-32 |
| BUNDLE | 2 | 2-24, 3-24 |
| ESCAPEE | 0 | (3-8 and 3-17 were flagged in the first pass and resolved by audit; see below) |
| **total** | **59** | |

Checksum: $4+17+5+30+1+2+0 = 59$.

Every CHAIN row bottoms out. The chain bases used are: 1-15 ($B_5$, RANK1), 1-16 ($Q^3$, RANK1),
1-17 ($\mathbb{P}^3$, RANK1), 2-32 ($W$, HOMOGENEOUS), 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$,
TORIC), 2-35 ($B_7$, TORIC), 3-27 ($(\mathbb{P}^1)^3$, TORIC), plus the intermediate rank-2 and
rank-3 blow-ups 2-27, 2-29, 2-30, 2-31, 3-19, 3-25, 2-33, each of which is itself CHAIN or TORIC
and terminates in a RANK1 or TORIC base. No CHAIN row terminates on an ESCAPEE.

## Escapee audit and resolution (2026-08-23, closes both flags)

The first pass flagged 3-8 and 3-17 because CCGK state them only as divisors in a toric ambient.
The audit resolves both as CHAIN rows over the toric family 2-34
($\mathbb{P}^1\times\mathbb{P}^2$), on two independent grounds each: the Mori–Mukai extremal-ray
data as recorded on the fanography per-family pages (fetched 2026-08-23,
`https://www.fanography.info/3-8` and `https://www.fanography.info/3-17`; fanography sources its
birational data from the Mori–Mukai classification tables, in which the extremal contraction
types are constant across each deformation family), and direct geometric derivations with exact
anticanonical-degree cross-checks.

### 3-8 — $b_3=0$, $-K^3=24$: CHAIN over 2-34, alternatively over 2-24

- **Fanography/Mori–Mukai:** 3-8 is the blow-up of 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$) in a
  genus-0 curve, and also the blow-up of 2-24 in a genus-0 curve.
- **Derivation of the 2-24 route:** the divisor class is the pullback of $\mathcal{O}(1,2)$ along
  $g\times\mathrm{id}:\mathbb{F}_1\times\mathbb{P}^2\to\mathbb{P}^2\times\mathbb{P}^2$, so a
  member is the base change of the corresponding 2-24 member $W'$ along
  $g=\mathrm{Bl}_{x_0}:\mathbb{F}_1\to\mathbb{P}^2_x$ — the base of $W'$'s **conic-bundle**
  projection (the linear side).  Base-changing the flat conic bundle along a point blow-up gives
  $X=\mathrm{Bl}_C W'$ with $C$ the conic fibre over $x_0$ (a local complete intersection of
  codimension two).  Smoothness of $X$ forces $C$ smooth (blowing up a nodal fibre gives a
  singular threefold), so the centre is a smooth rational curve.
- **Degree check:** $(-K_X)^3=(-K_{W'})^3-2(-K_{W'}\cdot C)+2g(C)-2=30-2\cdot2+0-2=24$, using
  $-K_{W'}=\mathcal O(2,1)|_{W'}$ and $C\subset\{x_0\}\times\mathbb{P}^2$ a conic.  Matches
  fanography's $-K^3=24$.
- Classified CHAIN over 2-34 (toric) as primary; the 2-24 route is recorded because it needs the
  closure-class lemma (chains over bundle-closed bases) and exercises it.

### 3-17 — $b_3=0$, $-K^3=36$: CHAIN over 2-34, alternatively BUNDLE over $\mathbb{P}^1\times\mathbb{P}^1$

- **Fanography/Mori–Mukai:** 3-17 is the blow-up of 2-34 ($\mathbb{P}^1\times\mathbb{P}^2$) in a
  genus-0 curve, and admits a $\mathbb{P}^1$-bundle contraction to
  $\mathbb{P}^1\times\mathbb{P}^1$ with the (non-split) bundle $\mathcal E$ defined by
  $0\to\mathcal{O}_{\mathbb{P}^1\times\mathbb{P}^1}(-1,-1)\to\mathcal{O}^{\oplus3}\to
  \mathcal{E}(1,1)\to0$.
- **Derivation of the blow-up:** write the $(1,1,1)$ equation as $s_0A(u,y)+s_1B(u,y)$, linear in
  the first $\mathbb{P}^1$; projection to $\mathbb{P}^1_u\times\mathbb{P}^2_y$ is birational with
  $\mathbb{P}^1$-fibres exactly over $Z=\{A=B=0\}$, a rational curve of bidegree $(1,2)$ (its
  image in $\mathbb{P}^2$ is the conic $\det=0$ of the $2\times2$ matrix of $u$-linear forms), so
  $X=\mathrm{Bl}_Z(\mathbb{P}^1\times\mathbb{P}^2)$.
- **Degree check:** $54-2(-K\cdot Z)-2=54-2\cdot(2\cdot1+3\cdot2)-2=36$.  Matches fanography.
- Classified CHAIN over 2-34 (toric) as primary; the non-split-bundle route over
  $\mathbb{P}^1\times\mathbb{P}^1$ is an independent Iritani–Koto closure of the same family.

## Other flags

1. **CCGK rank-4 numbering offset** (see the dedicated section above). Any downstream use of CCGK
   section labels for $\rho=4$ must apply the dictionary; taking CCGK's `MM4-N` at face value
   against fanography labels mis-assigns eleven families and would, in particular, attribute the
   elliptic-curve-centre family (fanography 4-2, $h^{1,2}=1$) to fanography's 4-3, which has
   $h^{1,2}=0$.
2. **2-29 typo in CCGK.** Line 5824 reads "a quadric 3-fold $Q\subset\mathbb{P}^3$"; a quadric
   threefold lives in $\mathbb{P}^4$. Line 10532 (5-1) repeats the same typo. Harmless, but noted
   so a reader does not treat it as a different variety.
3. **1-15 naming.** Fanography's 1-15 is CCGK's $B_5$ (index 2, degree 5, $-K^3=40$), classically
   $V_5$. CCGK have no section called "$V_5$"; the $V_d$ sections are indexed by $-K^3$. Searching
   CCGK for "$V_5$" finds nothing relevant.
4. **1-17 is both RANK1 and TORIC.** Recorded under RANK1 per the stated precedence; the toric
   cross-check table records the double membership so the count of 18 still reconciles.
5. **4-10 and 5-3 are both TORIC and PRODUCT** ($S_7\times\mathbb{P}^1$ and
   $S_6\times\mathbb{P}^1$), as are 2-34, 3-27, 3-28. TORIC precedence applies; the PRODUCT count
   of 5 therefore covers only $\rho\ge 6$.
6. **No disagreement found** between the fanography $h^{1,2}$ values and independent knowledge on
   any of the eight requested spot-checks.

