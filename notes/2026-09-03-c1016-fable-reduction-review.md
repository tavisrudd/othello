# C1016 — review of the order-2092 reduction program for overlooked mathematics

**Lane**: `complete-ports`
**Task**: C1016
**Date**: 2026-09-03. Read-only review; no code, build, or campaign was touched.

Evidence key used throughout: **[doc]** = a claim made by the banked documents
(`notes/2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`, cited as SYN:line, and
`notes/2026-09-03-c1016-unrestricted-2092-campaign.md`, cited as CAMP:line); **[verified]** = I
recomputed it here (exact Python, negligible CPU; script
`scratchpad/c1016_checks.py` of this session, not committed); **[proposed]** = my own claim or
suggestion, not yet checked by anyone else. Code was read only to pin semantics
(`ergodis-private/src/q29_inventory_scope.rs:1-33`, `order6_margin_evolve.rs:14-27`,
`hadamard_2092.rs:330-460,680-832`).

## 0. The object, stated once

[verified] The bordered Goethals–Seidel shape searched by C1016 is a supplementary difference
set 4-{522; 260, 261, 261, 261; 520} in the cyclic group Z/522: four subsets X_i with
sum k_i = 1043, every nonzero difference represented lambda = 520 times in total. Parameter
check: sum k_i(k_i - 1) = 260·259 + 3·261·260 = 270,920 = 520·521. Group-ring form:

    sum_i X_i X_i^(-1) = 523 + 520·T      in Z[Z/522],   T = sum of all group elements,

and n = sum k_i - lambda = 523 = v + 1 is the bordered condition: the ±1 rows have sums
(2, 0, 0, 0) and sum_i A_i A_i^T = 2092·I - 4·J (SYN:1208 states the same weights and target).
[verified] With 200 <= k_i < 300 the only bordered parameter sets are (260,261,261,261; 520) and
its complement-equivalent (261,261,261,262; 522), so the weight choice is forced, not a design
decision.

Two arithmetic facts about 523 drive everything below.

- 523 is prime, 523 ≡ 3 (mod 4), 523 ≡ 3 (mod 8); 522 = 2·3²·29; 524 = 4·131; (523-1)/2 = 261
  is composite (Djokovic's "hard case" heuristic, arXiv:2404.14375 §5, singles out primes with
  (v-1)/2 prime; 523 is not one).
- **523 ≡ 1 (mod 522)**, hence 523 ≡ 1 modulo every divisor d of 522. So 523 splits completely
  in every cyclotomic field Q(zeta_d) that a character of Z/522 lives in, and 523 is
  self-conjugate modulo no d > 2. Every Turyn/Schmidt self-conjugacy or field-descent
  obstruction is therefore vacuous for this shape (Section 3.2). This is the structural reason
  behind the banked "no congruence can exclude a deviation pattern" result (CAMP:359–390).

[verified] Multiplier orders in (Z/522)^* ≅ Z/6 × Z/28 (order 168): 41 and 133 have order 12,
53 and 91 have order 14. The element-order histogram of the unit group is
1:1, 2:3, 3:2, 4:4, 6:6, 7:6, 12:8, 14:18, 21:12, 28:24, 42:36, 84:48. The four banked
shards are therefore all "small-multiplier" shards (orbits of size ≤ 14); the 120 units of
order 21, 28, 42, 84 have never been used (Section 4, move A).

## 1. What the fourteen reductions are, compressed

Every banked reduction is one of three mechanisms applied to the single identity above.

**Mechanism Q (quotient / compression).** For H ≤ Z/522 of order f and G/H ≅ Z/d, the
projection pi_H : Z[G] → Z[G/H] is a ring homomorphism, so

    sum_i pi(X_i) pi(X_i)^(-1) = 523 + 520·f·T_{G/H}.

In coset-count coordinates B_{i,c} = |X_i ∩ (c + H)| this reads, for every d | 522 [verified
against SYN:324 (d=18: 15603/15080), SYN:966 (d=29: A0 = 9883), SYN:2384 (d=174: 2083)]:

    E_d(0) := sum_{i,c} B_{i,c}^2          = 1043 + 520 (f - 1),
    E_d(s) := sum_{i,c} B_{i,c} B_{i,c+s}  = 520 f          (s ≠ 0 in Z/d).

In ±1 units the zero-shift value is 2092 - 4f, which is the "2080, 2056, 2068, 2020" quartet at
SYN:2534 for d = 174, 58, 87, 29. Instances: the Z/18 quotient-PAF theorem (SYN:313–329), the
q29 shell (SYN:2594–2607, CAMP:67–79), the divisor-lattice miner (SYN:1205–1223), the q58/q87/
q174 shells (SYN:1231–1257, 1364–1384, 1499–1507), the E174 = 1043+520+520 identity
(SYN:2380–2386), the q18 cyclic/negacyclic split (SYN:2445–2459; that one is the further
factorisation Z/18 = Z/2 × Z/9 of the same quotient).

**Mechanism C (character / norm equation).** Evaluating the identity at a character chi of
order d gives sum_i |chi(X_i)|^2 = 523 in Z[zeta_d]. When X_i is invariant under a multiplier g,
chi(X_i) lies in the fixed field of the Galois element sigma_g, so the four norms live in a small
subfield and their irrational parts must cancel. Instances: order-three Eisenstein energies
(SYN:36–40, 106–131), order-nine fixed fields (SYN:44–47), the g91 Q(sqrt 29) three-square
argument b_1²+b_2²+b_3² = 18 (SYN:72–78, 133–141), the g53 q29 CRT norm (SYN:146–177), the q87
Eisenstein four-token endgame (SYN:1364–1384), the q174 2×3 local table and
8E_s = 6E174 - 2E58 - 3E87 + E29 (SYN:2513–2538, which is local Parseval on Z/2 × Z/3).
"Complete cyclic character coverage" (SYN:316–320) is just Fourier inversion: the characters of
Z/d of all orders together are equivalent to Mechanism Q at d.

**Mechanism O (multiplier-orbit congruence + convexity).** If X_i is a union of orbits of a
multiplier group M, then each coset count is B_{i,c} = e + m·k with e the number of selected
singleton (small) orbits meeting c and m the large orbit size. Substituting into E_d(0) gives a
"defect budget" Diophantine equation; minimising sum B² over admissible patterns gives a
convex lower bound. Instances: g53 "B = e + 7k", budget 34, 15n29+13n27+4n15+3n13 = 34
(SYN:331–343, 506–537); g91 "B = e + 14k", 13n27 + 15n29 = 34 impossible (SYN:555–574);
g133 "B = e + 4k", budget 83 (SYN:588–594); g41 "B = e+4k / e+2k", budget 230 (SYN:857–862);
the g41 q174 bound E174 ≥ 2675 > 2083 (SYN:2360–2394); the translation- and unit-normalizer
Burnside quotients (SYN:65–71, 92–100) are the symmetry bookkeeping of the same orbit algebra.

**What is exact-computational rather than structural.** g53 q0–q4 join (SYN:518–537), g133
q2/q6/mod-11 joins (SYN:652–695, 769–853), g41 768-root filter and 1,984,512-interface census
(SYN:855–1006), the q58/q87/q174 tablebases. These are all "Mechanism Q at several d jointly,
solved by meet-in-the-middle"; none introduces a new invariant.

**Shared-mechanism verdict.** [proposed] There is one theorem here, not fourteen: the quotient
identity above, evaluated (a) at coset counts (Q), (b) at characters (C), (c) restricted to
M-invariant sets (O). The documents already say "the common mechanism is a CRT orbit algebra"
(SYN:82–90) but never state the general theorem or run it uniformly; Section 2 states it.

## 2. General theorems that subsume several banked arguments

### 2.1 The uniform multiplier-shard killer (subsumes O for g41, g53, g91, g133) — [proposed]

**Theorem (energy-window test).** Let M ≤ (Z/522)^* be any subgroup, d | 522, f = 522/d. For
each H-coset c (H of order f) and each M-orbit O, put w(O, c) = |O ∩ (c+H)|. For M-invariant
X_i with |X_i| = k_i, the coset counts are B_{i,c} = sum_{O ⊂ X_i} w(O,c). Let
[m_i, M_i] be the min/max of sum_c B_{i,c}² over M-invariant sets of size k_i (a small
knapsack DP over orbits, since each orbit contributes a fixed vector (w(O,c))_c). Then the
M-shard is empty at level d unless

    sum_i m_i  <=  1043 + 520(f - 1)  <=  sum_i M_i,

and, more finely, unless the multiset {sum_c B_{i,c} B_{i,c+s}} can hit 520 f at every s.

This is exactly what killed g41 at d = 174 (min 2675 > 2083, SYN:2360–2386) and g91 at d = 18
(SYN:555–574), and what produced the g53/g133 "defect budgets". The cost per (M, d) pair is
milliseconds. There are 168 units, hence a few dozen subgroups M, and ten nontrivial d: the whole
table is seconds of CPU and would (i) decide every multiplier-assumed shard at once, including
the 120 never-touched units of order 21, 28, 42, 84, (ii) replace four bespoke sealed proofs by
one generic sealed extractor with a (M, d) parameter, and (iii) for surviving (M, d) pairs
output the exact list of coset-count profiles, which is what the per-root "canonical profile"
censuses compute by hand (SYN:41, 58, 111, 121, 129). Convexity note: the unconstrained
minimum of E_174(0) is 1737 (347 cells at 2, 349 at 1) [verified], so the unrestricted target
2083 is interior; only the orbit structure pushes the minimum above it.

### 2.2 Mean-equals-target, and the entropy null model for the residual floor — [verified]

For any integer row y of length 29 with sum r and energy E, sum_{s≠0} PAF_y(s) = r² - E.
Summing over the four q29 rows with sums (1,0,0,0) and total energy 505 gives
sum_{s≠0} P(s) = 1 - 505 = -504, i.e. **the average off-zero value is exactly -18, the target.**
So the deviation e(s) = P(s) + 18 is a mean-zero quantity on the 13-dimensional hyperplane
sum e = 0, and the shell condition e = 0 is "P is constant off zero". By Cauchy–Schwarz,
sum_{s≠0} P(s)² ≥ 504²/28 = 9072 with equality iff shell; since sum_{s≠0}(P+18)² =
sum P² - 9072, the campaign score 16·sum_{s=1..14} e² equals 8·(sum_{s≠0} P(s)² - 9072). The
phase-one objective is therefore a merit-factor (LABS-type) objective, which is why local search
on it shows a golf-course landscape.

Now count deviation patterns. N(k) = #{e ∈ Z^14 : sum e = 0, sum e² = k}:

| k (score/16) | 2   | 4     | 6      | 8       | 10      | 12        |
|--------------|-----|-------|--------|---------|---------|-----------|
| N(k)         | 182 | 6,006 | 62,244 | 290,472 | 996,996 | 2,740,738 |
| N(k)/N(k-2)  | —   | 33.0  | 10.36  | 4.67    | 3.43    | 2.75      |

(N(4)/14 = 429 and N(2)/14 = 13 are exactly the orbit counts at CAMP:311–316; N(6) = 60,060
three-plus/three-minus patterns plus 2,184 patterns containing a ±2, which is why every
residual-96 state seen is of the 3/3 form, CAMP:82–84, 102–104.)

The campaign's worker-best histogram (CAMP:51–58) is 96:12, 128:53, 160:104. The observed
left-edge ratio 53/12 = 4.4 matches the pattern-count ratio N(8)/N(6) = 4.67, not the
"two-to-three per step" geometric model used at CAMP:197–203. Extrapolating with the pattern
counts, the expected number of residual-64 worker bests among 288 runs is 12/10.36 ≈ 1.2 and of
residual-32 bests is 12/343 ≈ 0.035. **Observing none is the expected outcome; the "floor at 96"
is pattern entropy, not an obstruction.** This answers the residual-floor question in Section 3.4
without any new theorem, and it says what more compute buys: at the measured 4% rate of
residual-96 per worker-run, a q29 shell (one pattern) by this annealer costs on the order of
62,244/0.04 ≈ 1.5·10^6 worker-runs, roughly two machine-years, unless the move geometry changes.
The multiplier macro-move (CAMP:319–325) permutes patterns within an orbit and does not change
this count.

### 2.3 Heuristic solution counts (Gaussian / circle-method model) — [verified arithmetic, proposed interpretation]

- q29 shell: the number of y-quartets on the energy-505 sphere in Z^116 is ≈ 10^106; the four
  row-sum constraints cost ≈ 10^-4; the standard deviation of the four-row PAF sum at one shift is
  ≈ 47, so P(e = 0) over 13 free coordinates is ≈ 10^-27. **Expected number of exact q29
  shells ≈ 10^75.** The shell is not rare; the search geometry is the whole problem, and no
  exclusion theorem for score 2 or 4 should be expected to exist.
- Unrestricted SDS: 2^2088 ≈ 10^628.6 sign patterns, row sums ≈ 10^-5.8, 260 independent PAF
  constraints at density 4/(45.7·sqrt(2π)) each ≈ 10^-378.8: **expected ≈ 10^244 solutions**
  before quotienting by the ≈ 10^13 symmetry group. This is the usual reason the Hadamard
  conjecture is believed; it also says that the exclusion of the four small multiplier shards is
  informative only because Mechanism O shifts the *mean* of the coset energies away from the
  target (2675 vs 2083), not because solutions are scarce. The naive per-shard estimate
  10^(244/t) for a multiplier of order t is therefore wrong for small t and should not be used to
  rank shards; the energy-window test of 2.1 should.

### 2.4 The 2-D (CRT) formulation as the master sufficient statistic — [proposed]

Z/522 ≅ Z/18 × Z/29, so each block is an 18×29 binary matrix M_i and the whole SDS condition
is a two-dimensional periodic autocorrelation: sum_i PAF2_{M_i}(u, v) = 520 for (u,v) ≠ (0,0).
The q29 layer is the column-sum projection, q18 the row-sum projection, and the "mixed"
characters (orders 58, 87, 174, 261, 522) are the 2-D characters with both components
nontrivial. The Galois orbits of characters are indexed by the twelve divisors of 522, so the
complete condition is **eleven norm equations** sum_i |chi_d(X_i)|² = 523, one per d > 1.
The q29 program handles d = 29 only; the q18 program handles d ∈ {2,3,6,9,18}; the q58/q87/q174
tablebases handle d ∈ {58,87,174}; d = 261 and the primitive d = 522 are handled only by full
replay. Stating the ladder this way makes it obvious which layers are missing from any
"sufficient state" and gives a principled order for the contraction ladder of CAMP:334–346:
contract along Z/29 first (the only prime layer without a divisor ladder), keep the Z/18 layer
exact, since Z/18 has the richer quotient structure.

### 2.5 Necessary-only → equivalence upgrades — [proposed]

- Gale–Ryser (SYN:2483–2496) is already an equivalence for *one block's margins*; the missing
  equivalence is for the 2-D autocorrelation, which no margin condition can give. The right
  exact bridge is the 2-D character system of 2.4, not more margin inequalities.
- The "quotient PAF is necessary-only" caveat (SYN:48–50) becomes an equivalence exactly when
  all eleven d-levels are imposed; that is a theorem (Fourier inversion on Z/522), not a
  conjecture, and could be sealed once as the top of the proof hierarchy so that every
  lower-level sealed proof cites one statement.

## 3. Classical results bearing on order 2092

### 3.1 Is 2092 open? — [verified from cache]

Cati–Pasechnik, *A database of constructions of Hadamard matrices*, arXiv:2411.18897v2
(30 Aug 2025), lit-cache key `arXiv:2411.18897` (bytes 715,327; text lines 1466 and 1698):
Table 4 lists `523(3)` for both Hadamard and skew-Hadamard, i.e. the least known exponent is
m = 3, so 8·523 = 4184 is known and 4·523 = 2092 is not. The in-repo C999 note
(`notes/2026-08-29-c999-open-orders-above-2000.md`:84–92, 282–286) records 2092 as the smallest
open admissible order after the external order-2060 construction. Web search 2026-09-03 for
`"Hadamard matrix" "order 2092" OR "4·523" OR "4*523"` returned no construction (domain: one
general web search; not a forward-citation closure).

### 3.2 Why every classical family misses 2092 — [verified arithmetic]

| Family | Needs | At 2092 | Verdict |
|---|---|---|---|
| Paley I, order q+1 | q = 2091 prime power | 2091 = 3·17·41 | no |
| Paley II, order 2(q+1) | q = 1045 pp, q ≡ 1 (4) | 1045 = 5·11·19 | no |
| Turyn/Whiteman Williamson, order 2(q+1) | q = 1045 pp | — | no |
| Szekeres/Spence, 2(q+1), q ≡ 5 (8) | q = 1045 | — | no |
| Miyamoto, order 4q, q ≡ 1 (4) | 523 ≡ 3 (4) | — | hypothesis fails |
| Legendre pairs, order 2ℓ+2 | ℓ = 1045 | no known family | no |
| Yang / T-sequences, order 4t | T-seq of length 523 | 523 prime, no product | unknown |
| Williamson order 523 | four symmetric circulants | unknown | open |
| Kronecker from 524 = 4·131 | 2092/524 not an integer | — | no |
| Two Paley-type blocks + 2-SDS on Z/523 | (2a-523)²+(2b-523)² = 2090 | 2090 = 2·5·11·19, 11 ≡ 3 (4) to an odd power | **impossible** |
| One Paley block + 3-SDS on Z/523 | a parameter set with some k_i = 261 | eight of the 33 sets qualify, e.g. (240,256,256,261; 490) | admissible, untried |

The two-Paley-block row [verified]: with Q the (523,261,130) quadratic-residue difference set,
Q Q^(-1) = 131 + 130T and (Q∪{0})(Q∪{0})^(-1) = 131 + 131T, so whichever two of
{Q, Q∪{0}, and their complements/translates} are used, the remaining two blocks must form a
2-{523; a, b; λ''} SDS with a + b - λ'' = 261, which forces (2a-523)² + (2b-523)² = 2090; that
has no integer solution. So the "repeated block / Paley core" route of
Abuzin–Balonin–Djokovic–Kotsireas (2019, *Hadamard matrices from GS difference families with a
repeated block*) is closed at v = 523 for any pair of (523,261,130) difference sets, not only the
Paley ones. One Paley block plus three free blocks remains parametrically admissible and inherits
Q's multiplier group (the index-2 subgroup of Z_523^*, order 261 = 9·29), so a cyclotomic sweep of
the three free blocks under a subgroup of order 29 or 87 keeps Q fixed and is cheap.

### 3.3 The plain Z/523 form and cyclotomy — [verified parameter sets; proposed route]

The C999 note calls the plain shape "unattacked but uncompressible". Uncompressible is true
(523 is prime, no divisor ladder), but for a prime v the classical replacement for compression
is **cyclotomy**: Z_523^* is cyclic of order 522, with subgroups of every order in
{2,3,6,9,18,29,58,87,174,261}, and a block invariant under the subgroup of order t is a union of
cyclotomic classes of index e = 522/t (plus optionally 0). Exhaustive counts: e = 6 → 2^7 per
block, e = 9 → 2^10, e = 18 → 2^19, e = 29 → 2^30 (meet-in-the-middle trivial), e = 58 → 2^59
(needs the character-norm prefilter). [verified] There are 33 admissible plain parameter sets
with k_i ≤ 261 (sum k_i - λ = 523), among them two Djokovic "special" sets
(240; 257,257,257; 488) and (244; 253,253,253; 480), and since 3 | 522 the spin structure of
arXiv:2404.14375 (μ of order 3 cycling X_1 → X_2 → X_3) is available, reducing the family to
two free blocks. That paper lists spin/slide families for v = 127…631 and is silent on 523
(grep for 523 in the cached text: no hit), so this route is unattacked in the literature I can
see. This is the classical high-symmetry sweep and costs minutes per (e, parameter set); it is
also the natural home for the Paley-core composites of 3.2.

### 3.4 The residual-floor question — classical status

There is no classical theorem about which off-zero correlation profiles a bounded-energy
four-row integer system can realize; the relevant classical facts are (i) the mean identity of
2.2, which makes the shell the *typical* value and the deviation a mean-zero fluctuation, and
(ii) the Gaussian solution-count heuristic of 2.3. Barker-type and perfect-sequence
nonexistence arguments (Turyn–Storer, Schmidt's field descent, the Hall–Ryser and Turyn exponent
bounds) all need a *single* sequence whose spectrum is a fixed norm, so that the ideal
(chi(X)) is pinned by Stickelberger; a sum of four norms carries no ideal constraint, and here
523 splits completely in every relevant field, so even the single-block machinery would be
vacuous. Conclusion: the floor is entropic (2.2), scores 2 and 4 are realizable with
overwhelming heuristic probability, and effort spent proving a floor is misdirected.

### 3.5 What the banked "spectral filter is dead" argument really is — [verified]

CAMP:359–390 proves that the mod-p reduction of the q29 system is solvable for every p. Over
Z that is Hasse-principle-style local solvability; the global obstruction, if any, would be a
"lattice + bounds" statement, exactly as the campaign note concludes. Section 2.2–2.3 sharpen
that conclusion: no global obstruction is expected either.

### 3.6 Sources consulted

- `arXiv:2411.18897` (cache, sha per manifest; lines 1–12, 1455–1470, 1690–1702 read).
- `arXiv:2404.14375` Djokovic, *Two classes of Hadamard matrices of Goethals–Seidel type*
  (cache; lines 96–140 and 440–456 read; grep for "523": none).
- `arXiv:0903.5053` Djokovic, *Supplementary difference sets with symmetry for Hadamard
  matrices* (abstract page fetched 2026-09-03).
- `arXiv:1802.00556` Djokovic–Kotsireas, *GS difference families with symmetric or skew base
  blocks* (abstract page fetched 2026-09-03).
- Abuzin–Balonin–Djokovic–Kotsireas 2019, *Hadamard matrices from GS difference families with a
  repeated block* (cyberleninka abstract page fetched 2026-09-03).
- `notes/2026-08-29-c999-open-orders-above-2000.md` (in-repo).
- Web searches 2026-09-03: the 2092 query above; `supplementary difference sets "q-1"
  multiplicative group GF(q) …`; `Djokovic Kotsireas "Goethals-Seidel difference families" …`.
  None surfaced a bordered 4-{q-1;…} family for q = 523 or a plain v = 523 family.
- Not consulted: Miyamoto 1991 (paywalled, as in the C999 note), Handbook Table 1.53, MathSciNet.

## 4. Proposed next moves, ranked by expected value

**A. Run the energy-window test of 2.1 over every subgroup M of (Z/522)^* and every d | 522.**
Buys: a uniform decision of all multiplier-assumed shards (the 120 units of order 21–84 have
never been examined; those shards are small enough that any survivor of the window test is
exhaustible by meet-in-the-middle in minutes), plus a single generic sealed extractor replacing
the four bespoke O-proofs. Costs: one small Rust module (orbit/coset incidence + knapsack DP),
CPU seconds. Risk: none; a survivor is a search target, an exclusion is a theorem.

**B. Plain Z/523 cyclotomic and Paley-core sweeps (3.2–3.3).** Buys: the classical route that
found every Djokovic family at v = 127…631, unattacked at 523; a hit is a Hadamard matrix of
order 2092 outright (GS array, no border). Costs: a new carrier (523) in code that currently
fails closed on 523 (SYN:400–401); the searches themselves are minutes to hours. Order:
spin-type special sets with index-6/9/18 cyclotomy → one Paley block plus three cyclotomic
blocks under a multiplier subgroup of order 29 or 87 → index-29 meet-in-the-middle on all 33
parameter sets.

**C. Retire the residual-floor program; replace the q29 annealer objective.** Buys: stops
spending on an entropic floor (2.2). If phase one is kept at all, use the LABS/merit-factor
toolkit (tabu with O(n) incremental PAF updates and self-avoiding restarts) and the multiplier
canonicalisation only as deduplication. Costs: nil; it is a decision.

**D. Reorder the contraction ladder by the eleven-norm structure (2.4).** Buys: a principled
sufficient state (Z/18-exact, Z/29-contracted) and an explicit list of which d-levels a
"sufficient-state theorem" must cover before it can be sufficient. Costs: design only.

**E. Symmetric/skew shards on Z/522 (classical Williamson/good/best analogue).** The special
block has k = 260 = (522-2)/2, exactly the size of a skew set in an even cyclic group
(G∖{0,261} = X ∪ -X), and 261 is the size of a symmetric set containing exactly one of {0,261}.
Imposing skew X_0 and symmetric X_1..X_3 halves the free bits per block and makes
chi(X_1..X_3) real, turning the norm equations into sums of squares in the real cyclotomic
subfield (the order-two instance is 523 = a_0²+…+a_3², SYN:345). Buys: a classical shard
with strong arithmetic; composes with A. Costs: an orbit-of-{±} bookkeeping layer. Caveat: the
bordered array with a skew X_0 does not automatically give a skew Hadamard matrix; the border
breaks the antisymmetry, so this is a search-reduction assumption only.

**F. Seal the top-level equivalence (2.5).** Buys: one theorem that every lower proof cites.
Costs: documentation and a small extractor.

## 5. Dead ends checked here, so they are not repeated

1. Any two (523,261,130) difference-set blocks (Q, Q∪{0}, complements, translates, in any
   combination) plus a 2-SDS on Z/523: impossible, 2090 is not a sum of two squares [verified].
2. Turyn/Schmidt self-conjugacy and field-descent exponent bounds: vacuous, 523 ≡ 1 mod every
   d | 522 [verified].
3. Stickelberger / ideal-theoretic constraints on chi(X_i): only bind a single norm equation
   |chi(X)|² = n; the four-norm equation carries no ideal constraint. Consistent with
   CAMP:359–390.
4. Any congruence, lattice-parity, or "sum of four squares in Z[zeta_29]^+" exclusion of
   deviation score 2 or 4 on the q29 layer: the mean identity and the pattern counts (2.2) show
   the observed floor needs no such theorem, and the heuristic count 10^75 of shells (2.3) says
   none should exist.
5. Kronecker/product routes: 2092 = 4·523 has no factorisation into known Hadamard orders
   (1046 is not a Hadamard order; 524 does not divide 2092).
6. Paley-type "multiplicative-group" reading of Z/522 ≅ GF(523)^*: the quadratic-residue set
   is a subgroup, so its multiplicative PAF is trivial; the classical difference-set structure
   of GF(523) lives in the additive group Z/523 (route B), not in the bordered carrier.
