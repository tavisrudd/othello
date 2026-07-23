# C499 report review (Fable, adversarial pass)

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · Files reviewed:
`2026-07-22-c499-sporadic-pencil-structure.{md,py,json}` against the C491 report; script re-run
(exit 0, `ALL C499 STRUCTURE CHECKS PASS`); independent probes below imported the script's own
helpers plus the frozen census module, with extra prime fields injected via `FIELD_SPEC`.

## Verdict

**DEFECTS FOUND** — the core theorems (C499.1, C499.2, the §3 classification, the q=8 torsor, the
persistence table) check out, but the §6.1 "exact mechanism" is falsified beyond the tested range
by direct computation, and the report states it as a certified for-every-q fact.

## Findings

1. **[blocking] §6.1 mechanism is false for q ≥ 67; report states it as "certified ... for every
   q".** The claims "the totally-split type `111` occurs only on the two special A₄-orbits —
   never on a free 12-orbit", the boldfaced "deep ⟺ neither special orbit is totally split",
   "n₁₁₁ ∈ {0,4,6} ... which is why it never grows with q", and the parenthetical "the reason no
   type-I deep hole survives for q ≥ 25 is that at least one of the two special orbits is forced
   to split there — an exact statement" are extrapolations from q ≤ 49.
   Probe (equianharmonic scan `f=(0,1,0,0,c)` at primes ≡ 1 mod 3, using `analyze()` from the
   script): n₁₁₁ = 6 at q=61, but **12** at q=67,73,79,97,103, **16** at q=109,127, **24** at
   q=139,151. At q=67 (c=4, μ=30, μ²−μ+1≡0) the stats are {111:12, 1.2:24, 1^2.1:4, 3:28}.
   Since the two special A₄-orbits have sizes 4 and 6 (max joint contribution 10, and PGL₂(67)
   contains no S₄/A₅ overgroup: 67 ≢ ±1 mod 8, mod 5), n₁₁₁=12 must be a free 12-orbit, with
   *neither* special orbit split — so the biconditional fails and n₁₁₁ grows exactly as
   equidistribution (~(q+1)/6) predicts. Consequences: the sentence "type-I deepness is a joint
   congruence condition on two orbits" and "The split/inert type of each special orbit is a
   finite Frobenius (cube-splitting) condition on a fixed number field, so ..." are unsupported
   as stated; the certificate block `equianharmonic_deepness_mechanism` carries the same
   unbounded "never on a free 12-orbit" statement under verdict CONFIRMED though its data stop at
   49; the §8 ledger bullets repeating "n₁₁₁ ∈ {0,4,6} never grows with q" and the closing "No
   open mystery remains" are wrong (a real mystery reopens: why splits first appear on special
   orbits in 25 ≤ q ≤ 61 and only later on free orbits); §6.2's "Deepness ⟺ a Frobenius/
   point-count condition on the two special orbits" inherits the defect, and the C500 framing's
   premise ("two conditions" controlled by one genus-1 curve) is weakened. What survives: the
   certified table for 7 ≤ q ≤ 49 is correct (matches my recomputation), deep ⟺ n₁₁₁=0 is
   trivially true, and the correct bounded statement is "within 7 ≤ q ≤ 61 the split members lie
   only on special orbits". Fix: restate the mechanism with its true range, delete the
   "never grows" and "exact statement" sentences, and re-open the ledger item.

2. **[should-fix] `_k` integer-embedding bug at non-prime q (script lines 134–137), executed at
   q=25 and 49 despite its own precondition.** `_k(F,n) = n % F.q` returns the field element with
   *index* n, not the prime-subfield constant n mod p; the docstring's guard ("only invoked for
   prime fields") is violated by the persistence loop (CONTINUATION_Q ∋ 25, 49) and the mechanism
   loop. Probe: at q=25, `_k(F,12)=12` (= 2t+2) vs correct 2; at q=49 `cubic_disc` disagrees with
   a correct-constant reimplementation on 48 of the scanned representatives. The internal assert
   `equianharmonic == equianharmonic_via_I` fired 8 times at q=25 and 16 at q=49 and passed only
   because the corrupted I's vanishing locus coincidentally matched (verified: 0 vanishing
   mismatches against the corrected I on this slice). Impact is contained — the published
   certificate emits quartic_I/J only for prime sporadic fields, and the q≥25 equianharmonic
   detection uses the cross-ratio — but the "independent cross-check" is unsound at q ∈ {25,49}
   and the script passes by luck, not design. Fix `_k` to reduce mod p and re-embed.

3. **[should-fix] §6 / summary 5 "persists as a PGL₂-orbit for every q ≡ 1 mod 3": neither the
   single-orbit claim nor the all-q claim is certified.** The scan finds slice points
   (0,1,0,0,c) and never checks they form one PGL₂-orbit at q ≥ 25; the all-q statement is
   certified only to 49 (certificate verdict CONFIRMED overstates). Supporting but not proving:
   my probe extends existence to q = 151 and the (q−1)/3 slice count persists (20, 22, …, 50),
   and at q = 7,13,19 the census orbit sizes equal (q³−q)/12 exactly. Say "constructed for
   25 ≤ q ≤ 49; single-orbit unverified there" or add the orbit check.

4. **[should-fix] §6.2 "Concretely (C491, and re-observed here) O⁻ has no split member for every
   q ≡ 1 mod 3 tested, 7 ≤ q ≤ 43".** Nothing in the C499 script or certificate touches O⁻ —
   `is_family_orbit` explicitly *skips* O± — so "re-observed here" is unsupported by this bundle.
   It also understates: C491 Lemma 6(1) *proves* O⁻ deep for all q ≡ 1 mod 3, so a bounded test
   range is the wrong epistemic register, and the cutoff 43 (excluding the census field 49) is
   unexplained. The rest of the O± description in §6.2 is consistent with C491 (conjugate
   ramification pair for O⁻ is not misstated).

5. **[should-fix] §4 "dictated by pure q mod 12 arithmetic".** The law "which exceptional
   A₄-orbits are F_q-rational is q mod 12" is asserted from 8 fields (7,13,19,25,31,37,43,49 —
   consistent: octahedron rational iff q ≡ 1 mod 12 in the data) with no proof or citation; the
   rationality of the octahedral orbit (fixed points of the three involutions) needs a
   square-class argument that is never given. The per-field tables themselves are certified.

6. **[should-fix] §7 independence paragraph: "two independent ways ... agree on every
   rational-branch orbit" — false as written.** At q=9 (char 3) the I(Δ) cross-check is skipped
   (JSON entry has no `equianharmonic_via_I`), so only the cross-ratio method ran there; and in
   char 3 the test μ²−μ+1 = (μ+1)² degenerates (equianharmonic ⟺ harmonic ⟺ μ = −1), so the
   dichotomy is not meaningful at q=9 anyway. Restrict the sentence to char ≥ 5. Theorem C499.1
   itself is unaffected (q = 7,13,19 are prime ≥ 5, both methods ran and agree; μ = 5,10,12
   satisfy μ²−μ+1 ≡ 0 — verified by hand).

7. **[nit] §6.1 Riemann–Hurwitz parenthetical is garbled-compressed.** "(2·3−2 branch points,
   transposition monodromy)" conflates two RH applications: 2·3−2 = 4 is the branch-point count
   of the degree-3 genus-0 cover; genus 1 of the degree-6 Galois closure then follows from
   2g−2 = 6(−2) + 4·3 = 0 (each transposition contributes 3 simple points upstairs). Conclusion
   correct in the tame case (char ≥ 5, indices 2); wildness caveat unstated but irrelevant for
   q ≡ 1 mod 3, q ≥ 7. The CM language is properly hedged ("consistent with", "natural C500
   follow-up") — no overclaim there beyond finding 1's premise damage.

8. **[nit] §3 "member profile is forced by the type together with deepness" — true but no
   argument given.** One line suffices: counting rational points of X ≅ P¹ over the pencil,
   3n₁₁₁ + n₁․₂ + 2n_dbl + n_cusp = q+1, which with n₁₁₁ = 0 forces n_irr (e.g. type III:
   n₁․₂ = q−3, n_irr = 2). Checked against all JSON entries; all consistent.

9. **[nit] Theorem C499.2's headline clause is a priori, and the §6.1 decomposition silently
   relies on that.** Type-constancy on stabilizer-orbits follows formally from PΓL-equivariance
   of the pencil (C491 Lemma 2): stabilizer elements act by invertible rational substitutions,
   which preserve F_q-factorization type. The script does certify it explicitly for every
   type-I/II orbit (matching the report's scope claim), but `equianharmonic_a4_decomposition`
   (used for q up to 49) records only the seed member's type per orbit without re-checking
   constancy — sound only because of the a priori fact, which the report never states. Worth one
   sentence; the substantive certified content of C499.2 is the orbit-size decomposition, which
   matches the JSON at all fields.

Cross-checked and clean: §3 table ⟷ JSON ⟷ C491 §5 sporadic inventory (all sizes, stabilizers,
branch types, dbl/irr counts match; q=11 harmonic entry has μ = 10 = −1, J = 0 ✓); A₄
identification via order-multiset {1:1,2:3,3:8} is conclusive (all other order-12 groups contain
order-4 or order-6 elements) and the stabilizer is computed as an actual subgroup of PGL₂ with
independent 2×2 projective orders; "exactly" in C499.1 holds within the sporadic list (all
non-stab-12 rational-tetrad orbits certified non-equianharmonic); q=8 torsor arithmetic verified
({2,4,6} = {t,t²,t⁴} = roots of x³+x+1 under t³=t+1, cycle 578→580→582 from the frozen census
map — reliance on frozen Frobenius data is disclosed) and the C484 relation is correctly framed
as a structural analogy, not an identification; §6 correctly confines the persistence
construction to type I and routes types II–V to C491 Lemma 7; the (q−1)/3 remark matches the
data at 25–49 and continues to hold at 61–151 (probe).

## Proven vs certified vs conjectural

- **Proven (inherited or elementary):** deep ⟺ no `111` member (C491 Lemma 3); type-constancy on
  stabilizer-orbits (equivariance); two size-4 A₄-orbits are the two C₃-stabilized tetrads;
  member profile forced by branch type + deepness; genus 1 of the S₃ Galois closure (tame case).
- **Computationally certified (correct as bounded statements):** the five-type classification and
  stabilizer/order-multiset data for all sporadic orbits at q ∈ {7,8,9,11,13,17,19}; the
  equianharmonic/A₄ theorem at q = 7,13,19 with the dual I(Δ) cross-check; the pencil-line orbit
  decompositions; the q=8 torsor; equianharmonic persistence and non-deepness for
  23 ≤ q ≤ 49; the §6.1 table for 7 ≤ q ≤ 49.
- **Conjectural / falsified:** the "only special orbits split / n₁₁₁ never grows" law is
  **false** for q ≥ 67 (finding 1); "pure q mod 12" rationality law unproven; single-PGL₂-orbit
  persistence at q ≥ 25 unverified; the CM identification is explicitly deferred to C500 and its
  "two-condition" premise needs restating per finding 1.
