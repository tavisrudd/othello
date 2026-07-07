# Related-work pulls (O4, 2026-07-07)

Literature-summary deliverable for the 2026-07-07 Fable day plan, task O4. Two parts:
**Part A** = technical inputs for the F2 (ON) conic/arc proof attempt; **Part B** = related
work for the impartial-achievement-games paper. Summaries and verbatim transcriptions only —
no novelty verdicts, no synthesis, no comparison to our own results. Transcriptions are from
primary PDFs (downloaded and text-extracted via poppler `pdftotext -layout`) except where a
line is flagged `[SECONDARY]` (search-engine summary only) or `[TRANSCRIPTION-UNCERTAIN]`
(fraction/sub-/superscript rendering ambiguity in the OCR — verify against the arXiv source
before quoting in the paper).

Coverage: **all four items primary-sourced** for their headline statements. One genuine gap:
the exact constants of the Szőnyi–Weiner *blocking-set* stability theorem (JACO 2014) —
Springer full text is paywalled/redirected; only its abstract-level framing is sourced. See
Gaps section.

---

# PART A — F2 proof inputs (arcs / conics in PG(2,q))

Two distinct bodies of work are relevant and must not be conflated:

- **(A0)** the classical "large arc ⇒ *contained in* a conic" thresholds
  (Segre / Hirschfeld–Korchmáros / Voloch / Ball–Lavrauw). These are the results that give a
  hard `q − c√q`-type size bound above which an arc *is* a conic. **They are not
  Szőnyi–Weiner.**
- **(A1)** the genuine **Szőnyi–Weiner stability theorems** (resultant/polynomial method):
  a near-extremal point set (multiset, set of even type, small blocking set) can be turned
  into an extremal one by adding/removing *few* points. Conclusion is "*close to*", not
  "*equal to*".

I give A0 first (it is the sharpest arc→conic machinery the F2 note would actually cite),
then the Szőnyi–Weiner stability theorems (A1), then Kim–Vu (item 2).

## Item 1a (context) — Classical "arc contained in a conic" thresholds

**Segre's theorem.** B. Segre, *Ovals in a finite projective plane*, Canad. J. Math. 7
(1955) 414–416. Statement (as quoted in Kim–Vu and in the Ball–Lavrauw survey): *for q odd,
an arc of PG(2,q) has at most q+1 points, and the maximum q+1 is attained iff the arc is a
conic* (the set projectively equivalent to `xz = y²`). For q even the maximum is q+2
(hyperoval) and the characterization is open.

**Ball–Lavrauw, "Planar arcs".** S. Ball and M. Lavrauw, *Planar arcs*, J. Combin. Theory
Ser. A 160 (2018) 261–287. arXiv:1705.10940 (v4, 4 Apr 2018).
DOI 10.1016/j.jcta.2018.06.012. Verbatim from the primary text:

> **Theorem 1.** Let A be a planar arc of size q + 2 − t, q odd, not contained in a conic.
> [under a condition (1) on t] then A is contained in the intersection of two curves, sharing
> no common component, each of degree at most t + p^{⌊log_p t⌋}.

> **Theorem 2.** An arc in PG(2,q), q = p^{2h}, p ≠ 2, of size at least
> q − √q + 3 + √q/p is contained in a conic.

> **Theorem 3.** An arc in PG(2,q), q prime, of size at least q − √q + 7/2 is contained in a
> conic.

The paper notes these improve prior bounds "when q is an odd square and for primes less than
1783", and that examples of arcs *not* contained in a conic of size q − √q + 1 exist when q
is an odd square (Kestenband/Hermitian-curve construction), with the long-standing conjecture
that for q ≠ 9 an odd square any larger arc is contained in a conic.

**Same thresholds in the survey** (S. Ball and M. Lavrauw, *Arcs in finite projective
spaces*, EMS Surv. Math. Sci., arXiv:1908.10772). Verbatim theorem numbers there:

> **Theorem 52.** If q is prime then a planar arc of size larger than (44/45)q + 8/9 is
> contained in a conic.  [attributed to Voloch]

> **Theorem 53.** If q is an odd non-square then a planar arc of size larger than
> q − (1/4)√(pq) + (29/16)p − 1 is contained in a conic.  [attributed to Voloch]

> **Theorem 54.** Let A be a planar arc of size q + 2 − t not contained in a conic. If q is
> odd then A is contained in the intersection of two curves, sharing no common component,
> each of degree at most t + p^{⌊log_p t⌋}.

> **Theorem 55.** If q is an odd square then a planar arc of size at least q − √q + √q/p + 3
> is contained in a conic.

> **Theorem 56** (Kestenband, q > 4 a square). The intersection of two suitable Hermitian
> curves A = V(I) ∩ V(H) is a planar arc of size q − √q + 1 which is **not** contained in a
> conic.

The survey also records the earlier Hirschfeld–Korchmáros "second largest complete arc"
bounds (improved to `q − (1/2)√q + 3` for the relevant case) obtained via Segre's tangent
curve + Hasse–Weil point counts.

*Proof-technique shape (A0).* Segre's *lemma of tangents* associates to a q-odd arc an
algebraic curve in the dual plane through the tangent lines; the classical route
(Segre / Hirschfeld–Korchmáros / Voloch) bounds the number of Fq-points on that curve via
Hasse–Weil or Stöhr–Voloch and forces the arc onto a conic. Ball–Lavrauw's newer route
(Theorems 1/54) does **not** use Hasse–Weil/Stöhr–Voloch: it starts from a coordinate-free
scaled version of Segre's lemma, builds a *tensor* (degree t in each factor) / hypersurface
of degree 2t through the arc, then applies **Bézout** to two low-degree curves containing A
to force a common conic. Input needed: q-parity (odd), a size just below q so t is small, and
a nondegeneracy/condition-(1) hypothesis on t.

## Item 1b — Szőnyi–Weiner STABILITY theorems (resultant method)

The genuine Szőnyi–Weiner "stability" line. General shape of every such theorem: *if the
number δ of "bad" lines (0-secants / tangents / non-k-mod-p secants) is below a
`≈ (√q+1)(q+1−√q) ≈ q√q` threshold, then the set differs from a perfectly-blocking /
extremal set by only `⌈δ/(q+1)⌉` points.*

### 1b-(i) k mod p multisets (the cleanest transcribable statement)

T. Szőnyi and Zs. Weiner, *Stability of k mod p multisets and small weight codewords of the
code generated by the lines of PG(2,q)*, J. Combin. Theory Ser. A 157 (2018) 321–333.
arXiv:1901.09649. DOI 10.1016/j.jcta.2018.02.005. Verbatim from the primary text:

> **Theorem 1.1.** Let M be a multiset in PG(2,q), 17 < q, q = p^h, where p is prime. Assume
> the number of lines intersecting M in not-k-mod-p points is δ, where δ < (q/2)(q+1)
> `[TRANSCRIPTION-UNCERTAIN: OCR rendered the leading coefficient as "2q"; the fraction is
> almost certainly q/2 — verify]`. Then there exists a set S of points with size ⌈δ/(q+1)⌉
> which blocks all the not-k-mod-p lines.

> **Theorem 1.2.** Let M be a multiset in PG(2,q), 27 < q, q = p^h, p prime and h > 1 (q not
> prime). Assume the number of lines intersecting M in not-k-mod-p points is δ, where
> (1) δ < (⌊√q⌋ + 1)(q + 1 − ⌊√q⌋), when 2 < h;
> (2) δ < (p−1)(p−4)(p²+1)/(2p−1), when h = 2.
> Then there exists a multiset M′ intersecting every line in k-mod-p points, and the number of
> distinct points in (M ∪ M′) \ (M ∩ M′) is exactly ⌈δ/(q+1)⌉.

> **Theorem 3.6** (per-point dichotomy, the engine). Same hypotheses with
> δ < (⌊√q⌋+1)(q+1−⌊√q⌋). Then (via Lemma 2.5) through each point there pass **either at most
> δ/(q+1) + 2, or at least q − 1 − δ/(q+1)** lines meeting M in non-k-mod-p points; a repair
> argument then adds few points of appropriate multiplicity to remove all bad lines.

> **Result 2.1** (the resultant-like condition, from [11],[12] = the "Szőnyi–Weiner method").
> Suppose nonzero u(X,Y) = Σ_{i=0}^{n} u_i(Y)X^{n−i} and v(X,Y) = Σ_{i=0}^{n−m} v_i(Y)X^{n−m−i},
> m > 0, with deg u_i ≤ i, deg v_i ≤ i, u_0 ≠ 0. Assume some y gives
> deg gcd(u(X,y), v(X,y)) = n − s; let n_h = #{y′ : deg gcd(u(X,y′), v(X,y′)) = n − (s−h)}.
> Then Σ_{h=1}^{s} h·n_h ≤ s(s − m).

Sharpness note (Remark 1.4, verbatim intent): a complete arc of size q − √q + 1 has
(√q+1)(q+1−√q) odd-secants, so Theorem 1.2 is sharp when q is an even square (smallest sets of
even type = hyperovals).

*Proof-technique shape.* Embed AG(2,q) ⊂ PG(2,q); to the affine point set attach the
Rédei-type bivariate polynomial `g(X,Y) = Σ (X + a_v Y − b_v)^{q−1} + … − |M| + k`
(deg in Y of each coefficient ≤ its X-degree). The number of "bad" lines through a point =
the degree drop of gcd(g, X^q − X) at the corresponding y; **Result 2.1** bounds the total
degree-drop count `Σ h·n_h ≤ s(s−m)`, which forces the **few-or-many dichotomy per point**.
Then a greedy "repair" adds/removes ⌈δ/(q+1)⌉ points to kill all bad lines. Input needed: a
polynomial encoding of the set, and δ below the ≈ q√q threshold.

### 1b-(ii) Sets of even type (the arc/conic-adjacent stability result)

T. Szőnyi and Zs. Weiner, *On the stability of the sets of even type*, Adv. Geom.
(referenced as [11] in the multiset paper above). A *set of even type* is a point set meeting
every line in an even number of points (exists only for q even; the smallest are hyperovals,
i.e. conic + nucleus). Claim (as described in the multiset paper's introduction and in
search-level summaries): **a sharp stability theorem for sets of even type in PG(2,q), q
even**, improving Blokhuis–Bruen's stability theorem on hyperovals — a near-minimal set of
even type differs from a hyperoval by few points. `[SECONDARY: exact size threshold and
constant not transcribed — Adv. Geom. full text not retrieved. This is the most
conic-adjacent Szőnyi–Weiner stability statement; pull the exact constant from Adv. Geom.
before citing.]` Companion technical source: Zs. Weiner, *On (k, p^e)-arcs in Galois planes
of order p^h*, Finite Fields Appl. (referenced as [12]) — contains the corrected Lemma 3.4 =
the sharp form of Result 2.1.

### 1b-(iii) Small blocking sets (general resultant-method stability)

T. Szőnyi and Zs. Weiner, *On the stability of small blocking sets*, J. Algebraic Combin.
40(1) (2014) 279–292. DOI 10.1007/s10801-013-0487-0. `[SECONDARY — Springer full text
redirected to login; only abstract/framing sourced.]` Framing (from search + the method's
standard form): a point set of PG(2,q) with few 0-secants (tangent-deficient, blocking-set-
like) and size close to the minimal blocking-set size q + √q + 1 either **contains** a small
minimal blocking set or is obtainable from one by removing few points; the small minimal
blocking set has the "1 mod p" intersection property (every line meets it in 1 mod p points)
when |B| < 3(q+1)/2, q = p^h, p > 2. Same resultant machinery (Result 2.1). Verify the exact
constants against the JACO paper.

## Item 2 — Kim–Vu, small complete arcs (probabilistic construction)

J. H. Kim and V. H. Vu, *Small complete arcs in projective planes*, Combinatorica 23(2)
(2003) 311–363. DOI 10.1007/s00493-003-0024-1 (preprint dated April 24, 2002). Verbatim from
the primary text:

> **Theorem 1.1.** There are positive constants c and M such that the following holds. In
> every projective plane of order q ≥ M, there is a complete arc of size at most q^{1/2} log^c q.

> **Theorem 1.2.** There are absolute constants c and M such that in any projective plane of
> order q ≥ M, one can find an arc with Θ(q^{1/2} log^{1/2} q) points whose secants cover all
> but q^{1/2} log^c q points of the plane.

> **Corollary 1.3.** There are positive constants c₁, c₂ and M such that in any projective
> plane of order q ≥ M, one can find a complete arc of size between c₁ q^{1/2} log^{1/2} q and
> q^{1/2} log^{c₂} q.

Context transcribed from the paper: the **Lunelli–Sce lower bound** is n(P) ≥ (2q)^{1/2}
(1958, proof: a complete arc's secants cover all q²+q+1 points, each secant covers q+1, so ≥ q
secants ⇒ ≥ (2q)^{1/2} points; holds for any *saturated* set). The **prior best upper bound**
was Szőnyi's n(PG(2,q)) ≤ c·q^{3/4}. Kim–Vu's Theorem 1.1 thus determines n(P) up to a
polylogarithmic factor for **every** projective plane of order q (not just Galois planes). The
paper notes the algorithm runs in polylog(q) phases, each O(q⁴) basic operations, and that
internally they set c = 300, c₁ = 100 (their words: "far from optimal").

*Proof-technique shape.* The **dynamic random construction / Rödl nibble** (semi-random
method): build the arc incrementally in phases, at each phase adding a random small "nibble"
of points that keeps the no-3-collinear property, tracking the set of not-yet-covered points
until only q^{1/2} log^c q remain, then complete deterministically. The load-bearing new
ingredient is a **concentration inequality for non-Lipschitz functions**: classical
Azuma/Talagrand needs a small Lipschitz coefficient (bound ~ r²n), which the number-of-
uncovered-points variable does not have; Kim–Vu instead control the **average effect** C_i(v)
and the sum of variance bounds of the martingale, yielding an Azuma-strength tail bound when
the worst-case Lipschitz coefficient is large but rare. Input needed: the greedy random
process + this concentration bound; no algebraic/curve input, hence it works for *arbitrary*
(non-Galois) planes.

---

# PART B — Related work for the impartial-achievement-games paper

Summaries only, in the papers' own claim-strength language. No comparison to our sum-free /
cap results.

## Item 3 — Benesh–Ernst–Sieben series (generating games on finite groups)

Foundational setup (Anderson–Harary): two players alternately pick previously-unselected
elements of a finite group G. **GEN(G)** (achievement, "Generate"): first player to make the
selected set a *generating set* wins. **DNG(G)** (avoidance, "Do Not Generate"): a player who
cannot move without creating a generating set loses (studied under normal play). The central
tool throughout is the **structure diagram** — an identification digraph of the game digraph,
compatible with nim-values, that collapses the position graph to a small quotient from which
the nim-number is read off.

**(3a) D. C. Ernst and N. Sieben, "Impartial achievement and avoidance games for generating
finite groups."** arXiv:1407.0784. What they prove (verbatim statements):

> **Corollary 3.21.** The nim-number of DNG(G) is 0, 1, or 3. [for arbitrary finite G]

> **Corollary 4.8.** If G is nontrivial with |G| odd, then the nim-number of GEN(G) is 1 or 2.

> **Conjecture 4.9.** If |G| is even, then the nim-number of GEN(G) is in {0,1,2,3,4}.

> **Proposition 8.2** (abelian DNG, complete): DNG(G) = ∗1 if G nontrivial of odd order or
> G ≅ Z₂; = ∗3 if G ≅ Z₂ × Z_{2k+1}, k ≥ 1; = ∗0 otherwise.

They fully determine the nim-numbers of both games for **cyclic, dihedral, and abelian**
groups (Sections 6–8; e.g. GEN(Z₂) = ∗2, and GEN(Z_n) is one more than a computed value for
n ≥ 3), via a `spread` invariant spr(G) = number of invariant factors = minimum generating
set size. Technique: structure diagrams keyed on the lattice of **maximal subgroups**.

**(3b) B. J. Benesh, D. C. Ernst, N. Sieben, "Impartial avoidance games for generating finite
groups."** arXiv:1506.07105. Reformulates Barnes' condition in terms of maximal subgroups and
gives the complete DNG classification:

> **Theorem 6.3.** Let G be a nontrivial finite group. (1) If |G| = 2 or G is odd, then
> DNG(G) = ∗1. (2) If G ≅ Z_{4n} or the set of even maximal subgroups covers G, then
> DNG(G) = ∗0. (3) Otherwise DNG(G) = ∗3.

> **Corollary 6.4** restates this: all-odd maximal subgroups ⇒ ∗1; all-even ⇒ ∗0; mixed ⇒ ∗0
> if the even maximal subgroups cover G, else ∗3.

Applied to **nilpotent** groups (Prop 7.1 generalizes the abelian result), **generalized
dihedral** groups (Prop 7.4), **symmetric** groups (DNG(Sym(n)) = ∗0 for all n ≥ 4), and
**sporadic** groups. Interpretation given in the paper: the game is "a struggle to determine
which maximal subgroup remains at the end"; first player wins iff that maximal subgroup has
odd order.

**(3c) B. J. Benesh, D. C. Ernst, N. Sieben, "Impartial avoidance and achievement games for
generating symmetric and alternating groups."** arXiv:1508.03419. Completes the S_n / A_n
analysis left open by Barnes; verbatim:

> **Theorem 4.2.** DNG(S_n) = ∗1 (n=2), ∗3 (n=3), ∗0 (n ≥ 4).
> **Theorem 4.3.** GEN(S_n) = ∗0 (n ∈ {1,4}), ∗2 (n=2), ∗3 (n=3), ∗1 (n ≥ 5).
> **Theorem 5.10.** DNG(A_n) = ∗3 (n ∈ {3,4} or n a ζ-prime), ∗0 otherwise.
> **Theorem 5.11.** GEN(A_n) = ∗0 (n ∈ {1,2}), ∗2 (n=3), ∗3 (n=4), ∗4 (n a ζ-prime), ∗1
> otherwise.

A **ζ-prime** is a prime p ≡ 3 (mod 4), p ∉ {7,11,23}, meeting an extra order condition (the
ζ-primes < 100 are 19, 43, 47, 59, 67, 71, 79, 83); these are exactly the n for which A_n has
an *odd* maximal subgroup (AGL(1,n) ∩ A_n). The paper states Theorem 5.11 **refutes** the
even-order part of the earlier Conjecture 9.1 (nim can be 4, not ≤ 3) and **verifies** its
symmetric-group part. Technique: O'Nan–Scott classification of maximal subgroups of A_n plus
the structure-diagram `type` calculus.

## Item 4 — Saturation / Maker–Breaker / hypergraph achievement games

**(4a) N. Sieben, "Impartial Hypergraph Games."** Electron. J. Combin. 30(2) (2023) #P2.13,
DOI 10.37236/11665. This is the general "build/remove a structure, last to move wins"
framework that subsumes the group games above. Verbatim setup: on a finite hypergraph
H = (V, H), two players alternately select vertices; last to move wins (normal play). Four
games:

> **Building achievement ACV(H)** — ends as soon as the selected set *contains an edge*.
> **Building avoidance AVD(H)** — players may not select a set containing an edge.
> **Removing achievement (destroy) DST(H)** — ends as soon as the complement of the selected
> set *no longer contains an edge*.
> **Removing avoidance (preserve) PRV(H)** — players may not select a set whose complement
> contains no edge.

Main results: develops **structure theory** (structure equivalence = cospanning equivalence
of the associated matroid/closure system; the quotient "structure digraph" determines all
nim-values) and proves the games' nim-values are computable from it. **Universality
(spectrum) theorem**, verbatim:

> **Corollary 9.11 / 9.14 / 9.15.** The nim-value of AVD(H), of ACV(H), and of PRV(H) and
> DST(H) can be any nonnegative integer.

> **Proposition 9.13.** If V \ ⋃S_H ≠ ∅ then nim(ACV(H)) = nim(AVD(H)) + 1.

Section 8 shows the framework specializes to many games from the literature (its own claim: it
"provides a common framework for many special cases"): **generate/do-not-generate on groups**
(closure = generated subgroup), **convex closure games**, **geodetic closure games**,
**general position games** on graphs, **connect-it games** (spanning-tree edge sets),
**minimum-degree games**, and **degree achievement/avoidance games**. Achievement games are
GEN-type; the paper unifies them as building achievement games ACV over the corresponding
minimal-generating-set hypergraph.

**(4b) D. Hefetz, M. Krivelevich, A. Naor, M. Stojaković, "On saturation games."** Eur. J.
Combin. 51 (2016) 315–335. Verbatim setup: for a monotone increasing graph property P, two
players Mini and Max alternately add edges to a graph G ⊆ K_n keeping G ∉ P, until G is
P-saturated (G ∉ P but G ∪ {e} ∈ P for every non-edge e). This is a **scoring** game (not
last-to-move): the **score** s(n, P) = number of edges at the end under optimal play, Max
maximizing, Mini minimizing. They prove lower and upper bounds on s(n, P) for the properties
"being k-connected", "having chromatic number ≥ k", and "admitting a matching of a given
size", showing the score can be as large as the Turán number or as low as the saturation
number, and that it can depend on which player moves first.

**(4c) Origin / companion saturation-game references** `[SECONDARY — cited via search, not
transcribed from primary text]`:
- **Z. Füredi, D. Reimer, Á. Seress**, *Triangle-free game and extremal graph problems*
  (1991) — introduced the F-saturation game (variant of Hajnal's triangle-free game); best
  known lower bound on the K₃ game saturation number is order n log n, with an n²/5 upper
  bound attributed to Erdős (proof lost).
- **J. Carraher, W. B. Kinnersley, B. Reiniger, D. B. West**, *The game saturation number of
  a graph*, J. Graph Theory 85 (2017). arXiv:1405.2834.

**(4d) Positional-games / Maker–Breaker background** `[SECONDARY]`:
- **P. Erdős, J. L. Selfridge**, *On a combinatorial game*, J. Combin. Theory Ser. A 14
  (1973) 298–301 — the Erdős–Selfridge theorem: in an unbiased Maker–Breaker game on winning
  sets W, if Σ_{W ∈ W} 2^{−|W|} < 1/2 then Breaker has a winning strategy (the foundational
  potential-function criterion).
- **D. Hefetz, M. Krivelevich, M. Stojaković, T. Szabó**, *Positional Games*, Oberwolfach
  Seminars 44, Birkhäuser 2014 (lecture-notes version arXiv:1404.2731) — survey of
  Maker–Breaker, achievement/avoidance (Harary-type), and biased positional games.
- **Anderson–Harary** (Internat. J. Game Theory 16, 1987) — introduced the group
  achievement/avoidance games that item 3 develops.

---

# Gaps / failed fetches (verbatim)

1. **Szőnyi–Weiner, "On the stability of small blocking sets" (JACO 2014), full text** — not
   retrieved. WebFetch of `https://link.springer.com/article/10.1007/s10801-013-0487-0`
   returned: *"REDIRECT DETECTED: The URL redirects to a different host. … Redirect URL:
   https://idp.springer.com/authorize?response_type=cookie&client_id=springerlink&redirect_uri=…
   Status: 303 See Other"* (login wall). Only the abstract-level framing (item 1b-iii) is
   sourced; exact constants unverified.

2. **Szőnyi–Weiner, "On the stability of the sets of even type" (Adv. Geom.), full text** —
   not fetched (no open PDF located this pass). Item 1b-ii is sourced only from the
   introduction of the multiset paper (arXiv:1901.09649) that cites it. Exact size threshold
   for the even-type stability theorem is `[SECONDARY]`.

3. **Direct WebFetch of every compressed PDF failed** with FlateDecode/binary-parse errors,
   e.g. for the Kim–Vu Combinatorica PDF: *"the document provided appears to be a PDF file in
   binary/compressed format that I cannot properly parse"*, and for the arcs survey
   (arXiv:1908.10772): *"the text consists primarily of binary/encoded data that cannot be
   reliably parsed or transcribed."* **Resolved** by downloading the PDFs and extracting text
   with `nix shell nixpkgs#poppler-utils -c pdftotext -layout` — all headline statements above
   are from those extractions, not from the failed WebFetch attempts. (Note: `poppler_utils`
   is renamed to `poppler-utils` in current nixpkgs; the alias throws.)

4. **PDF page-render Read unavailable** — `Read` on a `.pdf` errors with *"pdftoppm is not
   installed"*; used `pdftotext` instead.

5. **Transcription-uncertain fractions** — flagged inline: Szőnyi–Weiner multiset Theorem 1.1
   leading coefficient ("2q" vs q/2). `pdftotext -layout` mis-stacks `\frac`; verify against
   arXiv:1901.09649 before quoting any fraction verbatim in the paper.

# Source list (links / DOIs)

- Kim–Vu, Combinatorica 23(2) (2003) 311–363. DOI 10.1007/s00493-003-0024-1.
- Ball–Lavrauw, *Planar arcs*, JCTA 160 (2018) 261–287. arXiv:1705.10940.
  DOI 10.1016/j.jcta.2018.06.012.
- Ball–Lavrauw, *Arcs in finite projective spaces* (survey). arXiv:1908.10772.
- Segre, *Ovals in a finite projective plane*, Canad. J. Math. 7 (1955) 414–416.
- Szőnyi–Weiner, *Stability of k mod p multisets…*, JCTA 157 (2018) 321–333.
  arXiv:1901.09649. DOI 10.1016/j.jcta.2018.02.005.
- Szőnyi–Weiner, *On the stability of small blocking sets*, J. Algebraic Combin. 40 (2014)
  279–292. DOI 10.1007/s10801-013-0487-0.
- Szőnyi–Weiner, *On the stability of the sets of even type*, Adv. Geom.
- Ernst–Sieben, *Impartial achievement and avoidance games for generating finite groups.*
  arXiv:1407.0784.
- Benesh–Ernst–Sieben, *Impartial avoidance games for generating finite groups.*
  arXiv:1506.07105.
- Benesh–Ernst–Sieben, *Impartial avoidance and achievement games for generating symmetric
  and alternating groups.* arXiv:1508.03419.
- Sieben, *Impartial Hypergraph Games*, Electron. J. Combin. 30(2) (2023) #P2.13.
  DOI 10.37236/11665.
- Hefetz–Krivelevich–Naor–Stojaković, *On saturation games*, Eur. J. Combin. 51 (2016)
  315–335. (PDF: math.tau.ac.il/~krivelev/saturgames.pdf)
- Carraher–Kinnersley–Reiniger–West, *The game saturation number of a graph*, JGT 85 (2017).
  arXiv:1405.2834.
- Füredi–Reimer–Seress, *Triangle-free game and extremal graph problems* (1991).
- Erdős–Selfridge, *On a combinatorial game*, JCTA 14 (1973) 298–301.
- Hefetz–Krivelevich–Stojaković–Szabó, *Positional Games*, Birkhäuser 2014.
  arXiv:1404.2731.
- Anderson–Harary, Internat. J. Game Theory 16 (1987).
