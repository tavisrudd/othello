# Sum-free achievement game — literature / prior-art check (2026-07-05)

**Scope.** Novelty check for: the impartial **sum-free achievement (building) game** on a finite
abelian group G — players alternately add elements keeping A ⊆ G sum-free (no a+b=c, a=b allowed so
2a=c also forbidden), normal play, facing a maximal sum-free set = loss. Equivalently **Node-Kayles
on the Schur 3-uniform hypergraph** of G (a *building/avoidance* game, not a removal game). Specific
claims being checked for prior art:
1. Z_n outcome law: 2nd player wins (G=0) iff n ≡ 0,1,5 (mod 6).
2. Nimber laws on Z_3×Z_p and Z_3²×Z_p: 𝒢(Z_3²×Z_p) = N iff p=5, P for all primes p≥7 ("sporadic p=5");
   warm-up 𝒢(Z_3×Z_p) = ∗1 for p≥7, ∗2 at p=5.
3. Any nimber-sequence / periodicity work on Node-Kayles or achievement games over Cayley/Schur
   hypergraphs of abelian groups.

**Method / caveat.** WebSearch + WebFetch only (no local compute, per instruction). The two most
load-bearing PDFs (Sieben EJC, Wong JIS) returned as raw binary through WebFetch — details below rely
on their abstract pages + search snippets, not a full read. Impartial SET is paywalled (Springer 303 /
ResearchGate 403); its rules were confirmed only from a search snippet. Flagged inline.

---

## Ranked findings

### 1. Sieben, *Impartial Hypergraph Games* — THE umbrella framework (must cite). OVERLAPS.
- **Nándor Sieben**, "Impartial Hypergraph Games," *Electronic J. Combinatorics* **30(2)** (2023),
  #P2.13. DOI 10.37236/11665.
- Defines four impartial games on any finite hypergraph H: **building achievement ACV**, **building
  avoidance AVD**, **removing achievement DST**, **removing avoidance PRV**; last player to move wins.
  In AVD "players are not allowed to select a set that contains an edge" — i.e. build an independent
  set of the hypergraph. Gives **generic tools for the nim-value** and shows nim-values can be any
  nonnegative integer.
- **Verdict: OVERLAPS (framework), DISTINCT (result).** Our sum-free game **is exactly AVD(H) for H =
  the Schur 3-uniform hypergraph** {(a,b,c): a+b=c} of G (= Node-Kayles on that hypergraph). This is
  the paper that names our game's genus and MUST be cited as the general framework. But — from the
  abstract + searches — it develops only *generic* machinery and worked examples; it does **not**
  instantiate the Schur/sum-free hypergraph, Cayley/abelian families, the Z_n mod-6 outcome law, or the
  p=5 nimber. The specific game, its outcome theorem, and the nimber phenomenon are not in it.
  *(Caveat: PDF unreadable via WebFetch; based on abstract page + Sieben's game taxonomy as reported.)*

### 2. Wong et al., *Nimber Sequences of Node-Kayles Games* — the Node-Kayles nimber-sequence method. DISTINCT.
- Brown, Daugherty, Fiorini, Maldonado, Manzano-Ruiz, Rainville, Waechter, **Wong**, "Nimber Sequences
  of Node-Kayles Games," *J. Integer Sequences* **23** (2020), Article **20.3.5**.
  (URL is `wong24.pdf` but the article number/volume is 2020 — the "Wong 2024" in the task is the
  filename, the actual publication is 2020.)
- Computes Node-Kayles nimber sequences (explicit formula / recursion) for: **3-paths, lattice graphs,
  prism graphs, chained cliques, linked cliques, linked cycles, linked diamonds, hypercubes,
  generalized Petersen graphs.**
- **Verdict: DISTINCT — different families.** No Cayley graphs, circulant graphs, abelian groups, Schur
  hypergraphs, or sum-free sets. It is the standard **methodology reference** for "nimber sequence of a
  Node-Kayles family," so cite it for method/precedent, but it does not touch our game or any group
  Cayley/Schur family.

### 3. Group-*generation* achievement/avoidance games (Anderson–Harary lineage). DISTINCT.
- Anderson & Harary (orig.); **F.W. Barnes**, "Achievement and avoidance games for generating abelian
  groups," *Int. J. Game Theory* (1988); **Benesh, Ernst, Sieben**, "Impartial achievement and
  avoidance games for generating finite groups" (arXiv:1407.0784) and the family
  1508.03419 (symmetric/alternating), 1608.00259 (generalized dihedral), 1805.01409 (nilpotent),
  **2004.08980** ("the spectrum of nim-values is {0,1,2,3,4}"); three-person variant 1607.06420.
- Target condition = the chosen set **generates the group**; last legal move wins/loses.
- **Verdict: DISTINCT — different winning condition** (generate-the-group, not stay-sum-free). Two
  false-alarm coincidences to note and preempt in our write-up:
  - The **mod-3 residue law** that surfaced ("if n≡1 mod 3 and some prime p|n has p≡1 mod 3 then P1
    wins; if all p|n have p≡2 mod 3 then P2 wins") is from the **three-person generation game**
    (1607.06420) and comes from **maximal-subgroup indices n/p**, not Schur triples. It depends on the
    prime factorization of n; **our law is a clean n mod 6 with no factorization dependence** — unrelated
    mechanism, coincidental mod-3.
  - "Achievement/avoidance for **abelian** groups" (Barnes 1988) is title-similar but is the generation
    game, not sum-free.

### 4. Uiterwijk & Hufkens, *Impartial SET* — closest SET/cap-set cousin, but a REMOVAL game. DISTINCT.
- Jos W.H.M. Uiterwijk & Lianne V. Hufkens, "Solving Impartial SET Using Knowledge and Combinatorial
  Game Theory," *Computers and Games* (CG 2022), LNCS **13865**, Springer 2023.
- A move = **taking (removing) a valid "Set" of cards** (a line in (Z_3)^c, 3 cards summing to 0) from
  the layout; last to move wins; SET-4-3 solved as a first-player win (~2 B nodes). *(Rules confirmed
  from a search snippet only — paper is paywalled.)*
- **Verdict: DISTINCT — removal game, opposite polarity.** It *removes* lines from (Z_3)^c; our game
  *builds* a line-free (cap/sum-free) set. It is nonetheless the **nearest cousin in the SET/cap-set
  space** and worth a one-line contrast, especially against our AG(n,q) cap-game theorem (where the
  built set is a cap = no 3 collinear). No overlap with the Z_n sum-free law or the p=5 nimber.

### 5. Node-Kayles on Trees (recent, corroborates the separate trees thread). DISTINCT.
- Songsuwana et al., "Node-Kayles on Trees," arXiv:**2512.24221** (Dec 2025). Nimber sequences of
  n-regular trees (and two trees joined by a path) are **eventually periodic**, with explicit
  formulas/recursions.
- **Verdict: DISTINCT** from sum-free, but a fresh (2025) Node-Kayles-nimber-sequence data point that
  lines up with our handoff's separate "trees Node-Kayles nimbers unbounded" result; cite as related
  contemporary work, not prior art for the sum-free game.

### Lower-relevance / checked-and-not-prior-art
- **"Nimber-Preserving Reductions and Homomorphic Sprague–Grundy Game Encodings"** (arXiv:2109.05622):
  general SG-encoding theory; Node-Kayles is PSPACE-complete context. Not our game. DISTINCT.
- **"Colored Node-Kayles: Algorithms and Computational Complexity"** (PRIMA 2025, Springer): complexity
  of a colored Node-Kayles variant. Not group/Schur, not nimber laws. DISTINCT.
- **Sum-free / Sidon set combinatorics** (e.g. arXiv:2304.07906 "Sidon sets, sum-free sets and linear
  codes"; math/0502374; the symmetric-complete-sum-free-set line): additive combinatorics on the
  *structure* of sum-free sets, **no game / no Grundy value**. Background only, not prior art.
- **OEIS**: no sequence found for the game's nimber/outcome data or the "0,1,5 mod 6" law (consistent
  with the handoff's "no match" and the prepared draft submission).

---

## Bottom line

**The sum-free achievement/building game on abelian groups — its Z_n outcome law (2nd player iff
n ≡ 0,1,5 mod 6) and the Z_3²×Z_p "N iff p=5" nimber phenomenon — appears NOVEL.** No source found
computes this game, this outcome law, or this nimber on any group family. The result is not pre-empted.

**Prior art to cite (not overlapping the result, but required context):**
1. **Sieben, *Impartial Hypergraph Games* (EJC 2023, #P2.13)** — the umbrella: our game is the building
   avoidance game AVD on the Schur 3-uniform hypergraph (= Node-Kayles on that hypergraph). Cite as the
   framework we instantiate. **This is the one paper a referee will expect to see.**
2. **Wong et al., *Nimber Sequences of Node-Kayles Games* (J. Integer Seq. 23 (2020), 20.3.5)** — the
   Node-Kayles nimber-sequence methodology precedent (different families only).
3. **Group-generation achievement/avoidance games (Anderson–Harary; Barnes 1988; Benesh–Ernst–Sieben,
   incl. the {0,1,2,3,4} nim-spectrum, 2004.08980)** — cite explicitly to *distinguish*: different
   target (generate the group), and to defuse the coincidental mod-3 cyclic law in the three-person
   variant (1607.06420), which is a subgroup-index effect, not a Schur effect.
4. **Uiterwijk & Hufkens, *Impartial SET* (CG 2022 / LNCS 13865)** — nearest SET/cap-set cousin;
   contrast it (removal of lines) against our building cap-game.

**Uncertainties / to double-check before submission:**
- Sieben EJC PDF and Wong JIS PDF were not machine-read here (binary via WebFetch) — verify by eye that
  neither contains a worked Schur/sum-free or Cayley/abelian-group example. Low risk (abstracts and all
  searches say no), but it is the one place a hidden pre-emption could sit.
- Impartial SET rules confirmed from a snippet only (paywalled) — verify it is a removal game if we lean
  on the contrast in print.
- No arXiv listing/search-alert sweep was done for a 2026 preprint that could pre-empt; recommend one
  last "sum-free game / Schur game / cap game Grundy" arXiv-listing check just before posting.
