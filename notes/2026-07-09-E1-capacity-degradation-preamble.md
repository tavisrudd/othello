# E1 — Structured capacity degradation (D3 formal preamble)

Date: 2026-07-09.

Draft of the one definition + one proposition + one corollary that the line-capacity vet
([`2026-07-09-line-capacity-framing-vet-extensions.md`](2026-07-09-line-capacity-framing-vet-extensions.md))
identified as the genuine payoff of the capacity umbrella and the highest-value extension. It is
the *formal preamble* for D3 (the conic-localization reduction) — the statement that says *why* the
game localizes to a Node-Kayles problem on the conic, stated so a reader sees it is a structural
consequence, not an ad hoc trick.

**Novelty demarcation (load-bearing — read first).** The *bare* fact "a Nofil/cap game whose
residual is line-saturated equals Node-Kayles on the conflict graph" is prior art
(Huggan–Huntemann–Stevens; the capacity-1 = Node-Kayles reduction is folklore / Sieben). This note
claims **only the structured form**: (i) the *specific* Möbius-involution-matching structure the
collapse takes on an odd-`q` conic (driven by Segre), and (ii) the blocking-set corollary that pins
the collapse as necessarily *local* and explains why static pairing/matching certificates fail. Do
not phrase E1 as "we observe Nofil collapses to Node-Kayles."

## Setup: line-capacity games and residual capacity

A **line-capacity game** is `(P, L, c)`: a point set `P`, a family of lines `L ⊆ 2^P`, and a
capacity `c : L → ℕ`. A position `S ⊆ P` is **legal** iff `|S ∩ L| ≤ c(L)` for every `L ∈ L`. Play
is impartial, normal (last legal placement wins); a move adds one point preserving legality.

- Queens = capacity-1 (`c ≡ 1`), four affine-grid line families. Legal = independent set in the
  queen graph = Node-Kayles.
- Affine/projective cap = capacity-2 (`c ≡ 2`), all geometric lines. Legal = cap (no 3 collinear) =
  Nofil on the collinearity-triple hypergraph.

For a legal `S`, the **residual capacity** (slack) of a line is `r_S(L) = c(L) − |S ∩ L|`. A point
`x ∉ S` is legal to add iff `r_S(L) ≥ 1` for every `L ∋ x`. Classify lines by slack:

```text
r_S(L) = 0   saturated   — a capacity-0 blocker: every remaining point of L is now dead
r_S(L) = 1   slack-1     — a capacity-1 (graph) constraint: ≤1 more point may join, so the live
                           points of L are pairwise exclusive (a Node-Kayles clique/edge set)
r_S(L) ≥ 2   slack-≥2    — a genuine capacity-≥2 (hypergraph) constraint survives
```

## Definition (mixed-capacity residual)

The **residual game** at `S`, written `G_S`, is the line-capacity game on the live point set
`P_S = { x ∉ S : x legal after S }` with each line `L` carrying its residual capacity `r_S(L)`,
keeping only slack-`≥1` lines. `G_S` is in general a **mixed-capacity** game: its slack-1 lines are
capacity-1 (Node-Kayles) constraints and its slack-`≥2` lines are genuine hypergraph constraints.
As play proceeds slacks only decrease, so `G_S` **degrades monotonically toward Node-Kayles** — but
only where slacks have actually reached 1.

This is the precise sense in which "cap locally *becomes* queens." The dynamics gap that kills
static certificates is now visible: at `c = 1` the conflict graph is fixed, but at `c ≥ 2` each
selected pair *mints* a new slack-1 line (a new Node-Kayles edge among future points), so the
conflict structure is play-dependent — which is why matchings/pairings computed on a snapshot do
not survive play (reservoir→Hall dead for `q < 38`; the C28 mirror census; the invalid
`conic_xor ⊕ zone` sum).

## Proposition (structured local collapse on the conic)

Fix an odd `q` and a legal size-3 residual grid position with its conic `C` (the unique conic
through the 5-arc = 3 selected cells + 2 burned directions; Segre 1955 makes the odd-`q` oval a
conic, so `C` is a conic uniformly). Then the **conic-restricted residual** — play confined to the
live points of `C` — is a **capacity-1 (Node-Kayles) game whose conflict graph is a union of
involution matchings**:

- each legal off-conic intruder `x` induces a Möbius involution `σ_x` on the parameter line
  `P¹(F_q)` of `C` (pairing the two conic points collinear with `x`), and the live-conic conflict
  edges are exactly the `σ_x`-matchings;
- the conflict graph decomposes into **even cycles** (Grundy-0, so the bulk cancels) plus small
  **defect skeletons** carrying Dawson's-chess values (octal `0.137`, OEIS A002187);
- consequently the conic-restricted value is a XOR of Dawson path/defect values over the skeleton,
  independent of the cancelled even-cycle bulk.

*Status of the pieces.* The involution / even-cycle-cancellation / Dawson-defect structure is the
intrusion calculus (`lean/ProjectiveCap/IntrusionCalculus.lean`; the NK-involution residual note
[`2026-07-08-nk-involution-residual.md`](2026-07-08-nk-involution-residual.md), NK1–NK3
machine-validated; the C20 census). The conic uniqueness / hyperbola normal form is Lean
(`uniqueConicThroughFiveArc…`, `exists_hyperbolaNormalForm`). What this proposition adds is the
*framing*: it names the conic-restricted residual as the capacity-1 stratum of the mixed-capacity
`G_S`, so D3's reduction reads as "localize to the slack-1 stratum," not as an isolated device. It
is **not** the (ON) escape theorem — that (a P-valued on-conic child always exists) is still open;
this is the frame in which that theorem lives.

## Corollary (global non-collapse; why the frontier is genuine)

The whole-board cap game **never** collapses to pure Node-Kayles: a global collapse needs every
line at slack `≤ 1`, i.e. every line to contain a selected point — `S` a **blocking set**. In
`AG(2,q)` the minimum blocking set has size `2q − 1` (Jamison 1977; Brouwer–Schrijver), while a cap
has at most `q + 1` points (odd `q`: the conic). Since `2q − 1 > q + 1` for every `q > 2`, **no cap
is ever a blocking set** — a permanent frontier of genuine slack-`≥2` lines survives all cap play.

Hence the Node-Kayles structure is *necessarily local* (the conic / a residual subboard); the cap
game stays strictly harder than its Node-Kayles shadow; and any collapse-based proof must be
localized, not whole-board. This is the positive structural reason the static-certificate routes
were dead, and it scopes the umbrella's "collapse to capacity-1" claim correctly.

*Extension pointer (E2).* At `c ≥ 3` the inequality `blocking-set-min > max-arc-size` is not
automatic, and maximal-`(k)`-arcs exist only for even `q` — so the even/odd dichotomy plausibly
re-enters at higher capacity. A crisp remark for D1's framing subsection, not pursued here.

## How this feeds the papers

- **D3 (conic-localization reduction):** this definition + proposition are its preamble — the
  reduction is "restrict to the slack-1 (Node-Kayles) stratum of the mixed-capacity residual on the
  conic," with the corollary explaining why that stratum is all one can get.
- **D1/D2 (umbrella / mirror principle):** the mixed-capacity residual is the one place the
  capacity umbrella does real work (queens `c=1` is the whole-game version of what the cap `c=2`
  endgame degrades into); state it in D1's framing subsection and as D2's general setting, never as
  the lead (Segre + the outcome theorems lead). Keep the novelty demarcation above verbatim.
