# Analytic Node-Kayles targets beyond flat queens

**Date:** 2026-07-04
**Scope:** plan + first lightweight proof probes. No Rust builds or solver runs. All computations in
this pass were small Python scripts under `ulimit -Sv 800000` (800 MB virtual-memory cap).

## Operating rule

Do not start any process expected to use more than 1 GB RAM. In practice this means:

- no Rust compiling;
- no production queens solver / heap-sum engine runs;
- no broad full-DAG searches except tiny Python sanity checks;
- any Python search gets an explicit memory cap and, when backtracking is involved, a short timeout.

The goal is analytical progress: find families where a closed form can be proved, with computation
used only to discover or refute candidate proof shapes.

## Ranked target plan

### 1. Toroidal queens parity law

**Target theorem.** For toroidal queens on `n x n`,

```text
G(TQ_n) = n mod 2 for n >= 4.
```

Current status:

- `G(TQ_n) in {0,1}` for every `n` follows from vertex transitivity. This is already noted in
  OEIS A344227, so it is not novel.
- Odd torus ray pieces are already solved by the defective-involution note: center-steal plus
  transitivity gives `G = 1` exactly for every odd `n`.
- Even torus queens are computed `0` at `n = 4, 6, 8, 10`.

So the analytical problem is just:

> For every even `n >= 4`, after a normalized first move at `(0,0)`, prove the residual is an
> N-position.

This is the closest target because a proof of "the residual is N" plus transitivity immediately
gives `G(TQ_n)=0`.

### 2. Even plane/cylinder kings

Even kings have only an O(1) obstruction set: the central `2 x 2` block on the plane, and two
domino-shaped defects on the cylinder. This is the smallest nontrivial test case for the
S1/S2 machinery:

- prove all even boards are P, or identify the finite exceptional pattern;
- then compute exact odd/even nimbers only as a secondary sequence project.

This is probably the best place to demonstrate a full "large mirror + finite repair" theorem.

### 3. Odd generalized Petersen `P(n,2)`

Brown et al. / OEIS A316533 already give:

- `G(P(n,2)) = 0` for even `n`;
- root values are bounded by the two root-orbit types;
- no explicit formula/recursion for the odd terms.

This is an attractive closed-form target because the family is sparse and highly symmetric, and
the published paper explicitly leaves the odd side open.

### 4. `3 x n` and `5 x n` lattice Node-Kayles

This is a finite-state / interval-DP project rather than a mirror project.

- OEIS A316632 has only a short `3 x n` table.
- Brown et al. explicitly flag `n x 3` / lattice graphs as not covered by their recurrences.
- A damaged fixed-width strip decomposes into bounded end-state intervals, so component XOR should
  be the right tool.

Deliverable: either an eventual period proof, or a much longer table plus a finite-state
certificate explaining why a period was not yet proved.

### 5. Rectangular queens and fixed-generator circulants

Mixed-parity rectangular queens can have a smaller obstruction than square queens, especially
even-by-odd boards where the mirror obstruction is one center column rather than two diagonals.
Fixed-generator circulants are vertex-transitive, so root values are in `{0,1}`; even circulants
with odd generators are thin-obstruction examples.

These are good second-wave targets after torus queens and kings clarify what kind of repair
certificate is realistically reusable.

### 6. Paley graphs: the quadratic character of 2 (added 2026-07-04, later session)

**Target theorem.** `G(Paley_p) = 1` for every prime `p ≡ 1 (mod 4)` with `p > 37`.

The `p ≡ 1 (mod 8)` half is already a corollary of L2 (2 is a QR, so the residue set is
halving-closed); the `p ≡ 5 (mod 8)` half is open, with computed exceptions exactly
`{5, 29, 37}`. Full data, reduction, structure, and plan: see **"Second probe: Paley graphs"**
below. Rank: this slots directly behind torus queens — half is proven, the residual object is
tiny (`≈ p/4` vertices), and the closure tool (Weil character-sum bounds) is off-the-shelf.

## Cheap lemma queue

These are general-purpose statements worth proving/formalizing before more computation. They are
ranked by expected reuse in the torus/kings/strip/Petersen programs.

### L1. Cayley translation pairing

**Statement.** Let `Γ = Cay(A,S)` be a finite undirected Cayley graph over an **abelian** group
`A`. If `A` contains an order-2 element `h` with `h notin S`, then Node-Kayles on `Γ` has `G = 0`.

**Proof shape.** Translation `x -> x+h` is a fixed-point-free involutive automorphism. Since
`h notin S`, no vertex attacks its mate (`x` and `x+h` are adjacent iff `h in S`). Apply the
Copying Lemma / Closed-Pairing theorem.

**Non-abelian caveat.** For general groups, `x` and `hx` are adjacent iff `x^{-1}hx in S`, so
`h notin S` alone does not prevent a vertex attacking its mate. The general hypothesis is that
the whole conjugacy class of `h` is disjoint from `S`; `h` central with `h notin S` suffices.
Write the abelian version as the default and the conjugacy-class version as the general form.

**Use.** Solves many even torus/circulant/abelian-board games instantly; explains exactly why
queens fail on even tori (all three order-2 elements `(n/2,0)`, `(0,n/2)`, `(n/2,n/2)` are queen
moves — column, row, diagonal).

**Status.** Queue as PROVEN-on-write in the abelian form; the conjugacy-class form is a one-line
extension.

### L2. Odd Cayley steal with halving-closed generators

**Statement.** Let `Γ = Cay(A,S)` with `|A|` odd. If `S` is closed under multiplication by
`2^{-1}` in `A`, then `G(Γ) = 1`.

**Proof shape.** Lower bound: play the identity, then copy by inversion `x -> -x`; the
halving-closed condition makes the obstruction set exactly `S`, i.e. the neighborhood killed by
the opening move. Upper bound: Cayley graphs are vertex-transitive, so root option values form a
singleton and the root mex is at most 1.

**Use.** Generalizes the odd-torus ray-piece theorem. Separates ray pieces from odd cycles like
`C_5`, where halving does not preserve the generator set. New corollary (2026-07-04): for primes
`p ≡ 1 (mod 8)`, `G(Paley_p) = 1` — see target 6 and the Paley probe section.

**Status.** Queue as PROVEN-on-write. Hypotheses to state explicitly: `A` abelian of odd order,
`S = -S`, `0 notin S`. The two facts the write-up must pin down: negation is fixed-point-free off
the identity because `2x = 0` forces `x = 0` when `|A|` is odd, and `2x in S => x in S` is exactly
halving-closure, so the pairing's obstruction is contained in the opening move's kill set
`N[0] = S ∪ {0}`.

### L3. False-twin parity compression

**Statement candidate.** Let `C` be an independent false-twin class: all vertices of `C` are
nonadjacent and have the same open neighborhood outside `C`. Replacing `|C| = k` by `1` vertex
when `k` is odd, and by `2` vertices when `k` is even, preserves the Node-Kayles Grundy value of
the whole position.

**Proof shape.** A move outside `C` either deletes all of `C` or none of it. A move inside `C`
deletes one twin and the common outside neighborhood, leaving `k-1` isolated vertices plus the
same outside residual. Since isolated vertices contribute parity by XOR, only `k mod 2` plus the
ability to play in `C` matters; expected induction on `(outside state, k)`.

**Sanity check.** Random small graphs with a planted false-twin class passed 200/200 trials for
each `k = 1..7` under an 800 MB memory cap, comparing `k` against its parity representative.

**Use.** Exact neighborhood-diversity-style kernel for generated residuals, strips, and blow-up
families. Complements the already-proven true-twin deletion lemma.

**Status.** Queue as HIGH priority proof. Do not wire into any solver/certificate until written.

### L4. Complete multipartite formula

**Statement.** For `K_{a_1,...,a_m}`,

```text
G(K_{a_1,...,a_m}) = mex({ (a_i - 1) mod 2 : a_i > 0 }).
```

Equivalently:

```text
all nonzero a_i odd  -> G = 1
all nonzero a_i even -> G = 0
mixed                -> G = 2
```

**Proof shape.** A move in part `i` deletes all other parts and leaves `a_i-1` isolated vertices,
whose value is `(a_i-1) mod 2`.

**Use.** Terminal/evaluator lemma for dense quotient states and a closed-form asymptote for
multipartite blow-ups.

**Status.** Queue as PROVEN-on-write.

### L5. Residual orbit-mex bound and orbit move reduction

**Statement.** If a position `A` has live-vertex orbits `O_1,...,O_k` under its stabilizer
automorphism group, then:

```text
G(A) <= k
```

and exact mex/outcome search need consider only one move per live orbit.

**Proof shape.** Moves in the same orbit produce isomorphic residuals, hence duplicate option
values.

**Use.** Root transitivity is the `k=1` case. This should be standard in every certificate
extractor: after a forced prefix, quotient by the prefix stabilizer before classifying replies.

**Status.** Queue as PROVEN-on-write.

### L6. Obstruction clique event bound

**Statement.** Let an involutive automorphism `ρ` pair a position except for an obstruction set
`D`, and suppose `D` is covered by `c` cliques. Along any play, at most `c` moves can be made in
`D`.

**Proof shape.** Each move in a clique deletes the rest of that clique; an independent set can
contain at most one vertex from each clique.

**Use.** Generalizes the queen facts "two long diagonals" and "two torus obstruction lines" into
a search-space bound: any non-mirror line has at most `c` defect events. It does not decide the
value, but it bounds certificate branching.

**Status.** Queue as PROVEN-on-write. Add a warning: clique cover bound can overcount if clique
covers overlap, but it is always safe.

### L7. Paired core + c-clique defect certificate schema

**Statement candidate.** Combine L6 with S2: if the defect set is covered by `c` cliques and
every reachable sequence of at most `c` defect events has a repair oracle back into a closed
pairing, then the position is P.

**Proof shape.** This is not a value theorem; it is a certificate theorem. The game alternates
between automatic mirror replies in the paired core and a finite table of defect-event repairs.

**Use.** This is the right theorem language for even kings (`c <= 4` but constant), torus queens
(`c = 2`), and plane central-strike border/scar certificates.

**Status.** Queue as certificate-schema theorem; likely a polished version of S2 plus L6.

**Warning — the repair-oracle premise is essential, not decorative.** The bare class "paired
core + defect set covered by `c` cliques" contains N-positions: a nonadjacent pair `{p, ρ(p)}`
plus one isolated defect vertex is three isolated vertices, `G = 1 XOR 1 XOR 1 = 1`, and no
defender strategy wins. So no unconditional "paired core + small defect ⇒ P" theorem exists;
every use of the schema must discharge the repair-oracle condition, including the endgame case
where the opponent saves the defect moves until the paired core is exhausted and then takes the
last defect move(s) for parity.

### L8. Fixed-width strip finite-state transfer

**Statement candidate.** For any fixed-width graph strip whose moves delete a bounded-radius
neighborhood and split the board into left/right strips plus bounded boundary damage, the Grundy
sequence is generated by a finite transfer system over boundary profiles. Any repeated window in
the transfer state certifies eventual periodicity.

**Proof shape.** Define canonical boundary-damage profiles; show every move decomposes into XOR
of completed intervals plus a bounded live profile. Then use finite-state recurrence and
pigeonhole / explicit repeated-window verification.

**Use.** `3 x n`, `5 x n`, maybe Petersen-like cyclic strips after cutting one edge orbit.

**Status.** Queue as a program theorem; needs family-specific profile definitions before it is a
formal theorem.

### L9. Blow-up / module asymptote

**Statement candidate.** For a fixed base graph whose vertices are replaced by true-twin cliques
or false-twin independent sets, Node-Kayles values depend only on clique presence and independent
class parity (after applying true-twin deletion and false-twin parity compression).

**Proof shape.** Combine true-twin deletion with L3. The quotient becomes a finite weighted graph
with each module count truncated to `{0,1}` or `{0,1,2}` depending on module type.

**Use.** Gives closed-form or ultimately periodic asymptotes for many dense graph families,
including complete multipartite graphs as the first corollary.

**Status.** Queue after L3.

### L10. Torus-queen midline reply theorem schema

**Statement candidate.** For even torus queens after root `(0,0)`, a reply on the midline
`(1,n/2)` (or its orbit) moves to a P-position with bounded-depth S2 certificate independent of
`n`.

**Proof shape.** Current data:

- `n=8`: some midline replies leave an S1-paired residual.
- `n=10`: `(1,5)` leaves no S1 pairing, but has a depth-two repair certificate.

The theorem would classify live cells into modular regions around the two killed queens and give
a finite reply table by region.

**Use.** Would prove the even half of toroidal queens parity, hence the full `G(TQ_n)=n mod 2`
law for `n >= 4`.

**Status.** Active target from this note.

## First probe: even torus queens

Normalize the first move to `(0,0)`. The residual is

```text
R_n = {(r,c): r != 0, c != 0, r != c mod n, r + c != 0 mod n}.
```

Because the torus queen graph is vertex-transitive, the root has a single option value:

```text
G(TQ_n) = mex({G(R_n)}).
```

Thus the even theorem is equivalent to proving `G(R_n) != 0`.

### Probe A: two-ply automorphism certificate

Question: does there exist a reply `t in R_n` such that
`R_n \ N[t]` is P by a pure obstruction-free involution?

Result:

```text
n = 4: yes, e.g. t = (1,2), residual empty
n = 6: yes, e.g. t = (2,3), residual has 4 live cells and point-reflection certificate
n = 8: no
n = 10: no
n = 12: no
```

Interpretation: the parity law is not proved by a uniform "reply once, then copy by an
automorphism" strategy. That path dies at `n = 8`.

### Probe B: exact residual values and zero replies

Small full-Grundy check of `R_n`:

```text
n = 4:  G(R_n) = 1, live = 4
n = 6:  G(R_n) = 1, live = 16
n = 8:  G(R_n) = 1, live = 36
n = 10: G(R_n) = 2, live = 64
```

For `n = 10`, the residual is still N, but not value 1. The zero-valued replies are exactly:

```text
(1,5), (3,5), (5,1), (5,3), (5,7), (5,9), (7,5), (9,5)
```

These all lie on the two midlines through `n/2`, excluding the attacked four-line set.

Two structural facts worth carrying forward:

- `|R_n| = (n-2)^2` exactly, for even `n`: the four killed lines pairwise meet only at `(0,0)`
  except the diagonal/antidiagonal re-crossing at `(n/2,n/2)`, so `4n-4` cells die. Matches the
  live counts above (4, 16, 36, 64). (For odd `n` the re-crossing is absent and the count is
  `n^2-4n+3 = (n-1)(n-3)`.)
- The eight zero replies at `n = 10` are **two orbits, not one**, under the stabilizer of `R_n`
  (the order-8 group generated by transpose and single-coordinate negation — both preserve
  torus-queen adjacency and fix the killed line set): representatives `(1,5)` and `(3,5)`.
  The L10 schema keys on `(1,n/2)`; track the `(3,n/2)` family as the fallback in case the
  `(1,n/2)` child stops being a zero child at some larger even `n`.

### Probe C: static Closed-Pairing certificates

Question: do the zero replies leave a position certified by Theorem S1?

Result:

- `n = 8`: yes for some central-midline replies, e.g. after `(1,4)` the remaining 16 cells have
  an S1 closed pairing.
- `n = 10`: no S1 pairing for any of the eight zero replies listed above.

Interpretation: even torus queens are simpler than plane queens but still not "static matching"
simple. Starting at `n = 10`, a proof needs either:

- an adaptive S2-style repair oracle;
- a different invariant proving `R_n` is N without exhibiting a P child by S1;
- or a higher-level decomposition of the zero child that the generic S1 matcher does not see.

### Probe D: one-step S2 attempt at `n = 10`

Take the normalized line:

```text
P1: (0,0)
P2: (1,5)
```

The resulting position `A` has 40 live cells and `G(A) = 0`, but has no S1 closed pairing.
Question: for every opponent move `x in A`, is there a defender reply `y` such that
`A \ N[x] \ N[y]` has an S1 closed pairing?

Result: **no**.

```text
40 opponent moves
24 have at least one zero reply leading to an S1-paired residual
16 have zero replies, but none of the sampled/exhaustive zero replies has an S1 pairing
```

The position's geometric stabilizer has order 4:

```text
identity
point reflection / translation-affine map encoded by (D4=2, shift=(1,5))
row reflection encoded by (D4=4, shift=(0,0))
composition encoded by (D4=5, shift=(1,5))
```

Under this stabilizer, the 40 live cells split into ten 4-element move orbits. Representatives:

```text
(2,1), (2,3), (3,1), (3,2), (3,4),
(4,1), (4,3), (5,2), (5,3), (5,4)
```

Orbit-level outcome:

```text
S1-certifiable after one reply:
  (3,2), (3,4), (4,1), (4,3), (5,2), (5,4)

not S1-certifiable after one reply:
  (2,1), (2,3), (3,1), (5,3)
  plus their stabilizer mates, 16 moves total
```

Interpretation: the natural S2 proof is not "one move repairs to S1" at `n = 10`. Either the
certificate needs depth >= 2 on four bad orbit types, or the proof must abandon S1 as the terminal
certificate for this torus child.

### Probe E: depth-two repair certificate at `n = 10`

The same child **does** have a depth-two certificate:

```text
cert_depth(A) = 2 succeeds
closed-pairing memo entries: 171
certificate memo entries: 176
full Grundy memo entries: 3307
```

Here `depth = 0` means "already S1-paired"; `depth = 1` means every opponent move can be answered
into S1; `depth = 2` means every opponent move can be answered into a depth-1 certificate.

Top-level quotient table under the 4-element stabilizer of `A`:

| opponent orbit rep | selected reply | child live cells | terminal status |
|--------------------|----------------|------------------|-----------------|
| `(2,1)`            | `(5,7)`        | 14               | depth 1         |
| `(2,3)`            | `(5,2)`        | 12               | depth 1         |
| `(3,1)`            | `(5,2)`        | 12               | depth 1         |
| `(3,2)`            | `(4,7)`        | 8                | S1              |
| `(3,4)`            | `(4,9)`        | 10               | S1              |
| `(4,1)`            | `(3,6)`        | 10               | S1              |
| `(4,3)`            | `(3,8)`        | 8                | S1              |
| `(5,2)`            | `(2,3)`        | 12               | depth 1         |
| `(5,3)`            | `(2,9)`        | 14               | depth 1         |
| `(5,4)`            | `(6,9)`        | 4                | S1              |

Reply-selection caveat: Probe D lists `(3,2), (3,4), (4,1), (4,3), (5,2), (5,4)` as
S1-certifiable after one reply, but the table's selected reply for `(5,2)` is `(2,3)`, which
lands at depth 1 — the extractor takes the first certifying reply it finds, not the
depth-minimal one. Harmless for the depth bound (the four hard orbits force depth 2 anyway),
but compression to modular cases should run on a **depth-minimal, orbit-canonical** reply
choice; re-extract with that preference before attempting the formula.

This is the first positive proof-shape result for the even torus problem: the failed static
pairing at `n = 10` is not random complexity; it is bounded adaptive repair of very small depth.
The next mathematical task is to express these orbit representatives and replies in modular
coordinates around the two killed queens `(0,0)` and `(1,n/2)`, then test whether the same formula
or finite-state vocabulary scales.

## Next proof obligations for torus queens

1. **Classify the winning replies after `(0,0)` for even `n`.**
   Data suggests midline replies when `n = 10`; check whether `t = (1,n/2)` or the midline orbit is
   always a zero child for larger even `n` before proving anything around it. Also check whether
   the zero-reply set stays exactly the two stabilizer orbits `(1,n/2)` and `(3,n/2)` at `n = 12` —
   a stable orbit census is itself a compressible pattern, and its failure mode (new orbits
   appearing) is an early warning that the reply vocabulary grows with `n`.

2. **Describe the child after a midline reply arithmetically.**
   For `t = (1,m)`, `m=n/2`, write the surviving set as modular line inequalities. Compute its
   stabilizer and orbit structure by hand; the lack of S1 pairing at `n=10` says not to expect a
   simple global involution.

3. **Look for a finite-state quotient.**
   The torus child has no boundary. If the remaining set decomposes into repeated congruence
   classes around the midlines, a quotient proof may replace a matching proof.

4. **Compress the depth-two S2 vocabulary at `n=10`.**
   The depth-two certificate exists. The open step is to replace the selected reply table with a
   formula or a small set of modular cases. If the cases survive at `n=12` in a non-Grundy
   validator, this becomes a plausible theorem schema.

## Second probe: Paley graphs (added 2026-07-04, later session)

`Paley_p`: vertices `F_p` (`p ≡ 1 mod 4` prime), `x ~ y` iff `x - y` is a nonzero quadratic
residue. Vertex-transitive, so `G in {0,1}`. All computations below: a ~40-line memoized Python
search under the 800 MB cap (`notes/2026-07-04-paley-kayles-probe.py`); games are short because
the graphs are dense — even `p = 293` memoizes only ~600k positions.

### Data

`G(Paley_p) = 1` for `p = 13, 17` and every prime `41 <= p <= 293`;
`G(Paley_p) = 0` exactly at `p in {5, 29, 37}`.

By residue class:

- `p ≡ 1 (mod 8)` (17, 41, 73, 89, 97, 113, 137, 193, 233, 241, 257, 281): all `G = 1`,
  as L2 predicts.
- `p ≡ 5 (mod 8)` (5, 13, 29, 37, 53, 61, 101, 109, 149, 157, 173, 181, 197, 229, 269, 277,
  293): `G = 1` except at `5, 29, 37`.

**Conjecture.** `G(Paley_p) = 1` for every prime `p ≡ 1 (mod 4)`, `p > 37`.

### Why the two residue classes differ

After the normalized root `0`, the live set is `A_p` = the non-residues (`N[0] = {0} ∪ QR`).
The L2 pairing `x -> -x` is closed (`χ(-1) = 1` since `p ≡ 1 mod 4`) and its obstruction is
`x ~ -x ⟺ χ(2x) = 1 ⟺ χ(2) = -1`:

- `p ≡ 1 (mod 8)`: `χ(2) = 1`, no live vertex attacks its mate, `A_p` is P by S1, `G = 1`.
  This is L2's halving-closure in character form. PROVEN once L2 is written.
- `p ≡ 5 (mod 8)`: `χ(2) = -1`, so **every** live vertex attacks its mate — the pairing fails
  maximally, not marginally. All three exceptions live on this side; so do infinitely many
  computed `G = 1` primes.

### Reduction chain

Two levels of transitivity normalize the first two moves — exactly the torus template:

1. `Paley_p` is vertex-transitive (translations): `G = mex({G(A_p)})`.
2. `A_p` is vertex-transitive under multiplication by residues (the non-residues are one coset
   `g·QR`, and multiplication by residues is a graph automorphism fixing the dead set): all
   first replies are equivalent, so `G(A_p) = mex({G(B_p)})` with

```text
B_p = { x : χ(x) = -1, χ(x - g) = -1, x != g }    (g = any fixed non-residue)
```

So the open half of the conjecture is exactly: **`B_p` is an N-position for `p ≡ 5 (mod 8)`,
`p > 37`.** `|B_p| ≈ (p-3)/4`, so full Grundy analysis of `B_p` stays cheap well past `p = 400`.

### Canonical structure on `B_p` (`p ≡ 5 mod 8`)

The map `φ(x) = g - x` is an automorphism of the induced graph, swaps the two defining
character conditions, and is **fixed-point-free on `B_p`**: its fixed point `g/2` has
`χ(g/2) = χ(g)·χ(2) = (-1)(-1) = +1`, hence dead. The same fact `χ(2) = -1` that destroys the
parent pairing at every vertex is what evicts this fixed point — the obstruction moves down one
ply and shrinks. The defect of `φ` is one more character condition:

```text
D = { x in B_p : χ(2x - g) = +1 }      (mate-closed, since χ(-(2x-g)) = χ(2x-g))
```

`D` has density ~1/2 in `B_p`, so this is NOT a finite-defect position — L6/L7 do not bind, and
the certificate needs either a mixed matching on `D` (the generic S1 matcher may find one) or
bounded-depth repair expressed in signature coordinates.

### Endgame proof shape: signature vocabulary + Weil closure

Every classification in this family is a conjunction of quadratic-character conditions on
rational expressions in `(x, y, g)`. A conjunction of `k` such conditions has
`p/2^k + O(k·sqrt(p))` solutions, so every existence claim in a finite certificate vocabulary
("for each opponent move of signature σ there is a reply of signature σ'") holds for all `p`
beyond an explicit bound, with the finitely many small `p` machine-checked. This is the standard
Paley pattern — the same shape as the proofs that Paley graphs satisfy all first-order adjacency
axioms (Blass–Exoo–Harary; Bollobás–Thomason — re-verify these citations before external use).
Quasirandomness is the heuristic reason to expect a `p`-independent vocabulary: all bounded
configurations equidistribute.

### Plan of attack

1. **Extend the scan.** More `p ≡ 5 (mod 8)` primes past 293 as memory allows; prime powers
   `q = 9, 25, 49` as an L2 sanity check (predict `G = 1`; needs small GF(q) arithmetic) and
   `q = 125` as the first prime-power data point on the open side.
2. **Zero-reply census of `B_p`.** Full Grundy of `B_p` for the good 5-mod-8 primes; extract the
   zero replies and classify them by character signatures (`χ(y)`, `χ(y - g)`, `χ(2y - g)`,
   cross-ratio-style combinations). This is the analog of the torus midline discovery.
3. **Certificate ladder.** Run the S1 matcher and `cert_depth` (the torus probe tooling,
   unchanged) on the zero children of `B_p`; record certificate depth as `p` grows. Bounded
   depth + stable signature vocabulary = the theorem is live; growing vocabulary = downgrade to
   a data/conjecture note.
4. **Weil closure.** If the vocabulary stabilizes, write the character-sum existence lemma,
   compute the explicit threshold `p_0`, machine-check `p < p_0`, assemble the theorem. The
   exceptional set `{5, 29, 37}` needs no structural explanation — it sits below the threshold.
5. **Follow-ups if it lands.** Generalized Paley graphs (k-th power residues — L2's hypothesis
   becomes "2 is a k-th power residue") and Peisert graphs; both reuse the whole pipeline.

## Generalized Paley & Peisert — computed (2026-07-04, go-deep run)

A boolean win/loss short-circuit engine (valid since these are vertex-transitive ⇒ G∈{0,1};
validated against full Grundy on 9 Paley + 12 GP(p,3) primes, all match) extended the Paley result
and tested the k-th-power generalization. Scripts in scratchpad (`arith_cayley.py` + runners).

**Paley extended:** G(Paley_p)=1 for all p≡1 mod 4 up to **509**, exceptions still exactly
{5,29,37}, all p≡1 mod 8 → 1. The k=2 exception set stays finite.

**The sufficient direction generalizes — essentially a lemma, not just data.** For k=2,3,4 and
Peisert: **"2 is a k-th power residue ⟹ G=1", with ZERO exceptions on the clean side across all
four families.** Mechanism: the S1 pairing x↦−x has no obstruction exactly when χ_k(2)=1 (then
2x∉S for x in the residual, so no vertex attacks its mate). So the χ₂→χ_k generalization of the
halving-closure lemma holds — the clean side is *proven* by the pairing; the computed samples are
consistency checks (thin for k=3,4 due to memory, but the pairing is the evidentiary basis).

**Peisert is a clean theorem — all G=1, no exceptions.** For Peisert P*_q (q=p², p≡3 mod 4), 2∈F_q*
has dlog(2)≡0 mod 4 FORCED (2∈F_p*=⟨g^{p+1}⟩ and p+1≡0 mod 4), so x↦−x always succeeds ⇒
**G(P*_q)=1 for every valid q, with no exceptional set** (confirmed q=9,49,121,361). Provable, not
just empirical — the Weil scout's flagged "next domino," landed. [Correction to earlier notes: the
classic Peisert orders are q=9,49,121,361,529 (p², p≡3 mod 4), NOT 81,169 — 169=13² has 13≡1 mod 4;
81=3⁴ is a general-Peisert order needing GF(3⁴), deferred.]

**But the full Paley finite-exception story is SPECIAL to k=2 — it does NOT generalize.** The
*insufficient* side (2 not a k-th power) behaves differently:
- k=2: bad side still eventually all G=1 with finite exceptions {5,29,37}.
- **k=3: bad side has G=0 at {13,19,61,67,103,139,199,211} — ~50% density to 211, NOT finite**, and
  the finer cubic-coset of 2 mixes G=0/G=1 ⇒ no clean secondary power-residue law. The real break.
- k=4: memory-limited (ceiling p=137), undecided; exceptions {17,41,97} seen.

**Honest scope:** the *sufficient* direction (χ_k(2)=1 ⇒ G=1) generalizes cleanly and Peisert is a
full clean theorem; but the *complete* "value = arithmetic invariant with finite exceptions"
characterization is special to Paley (k=2). For k≥3, only the one-way sufficient law + a
positive-density bad side survive. Feasibility ceilings (sparser graphs blow the memo): k=3 ~p=181,
k=4 ~p=137, Peisert q=361.

## Prior art anchors

Web-verified 2026-07-04. What each technique in this note can cite:

- **Pairing strategies (S1):** Hales & Jewett, "Regularity and Positional Games", Trans. AMS 106
  (1963). Machine-found pairing certificates: Győrffy–Makay–Pluhár, "The pairing strategies of
  the 9-in-a-row game", Ars Math. Contemp. 16 (2019) — computer-enumerated *all* winning
  pairings; Uiterwijk, "Set Matching: An enhancement of the Hales–Jewett pairing strategy",
  ICGA J. 40(3) (2018) — pairing generalized to overlapping set-matchings with local case
  handling, the nearest published relative of S2; Fisher & Sieben, rectangular polyomino weak
  achievement games (arXiv:1010.0424).
- **Adaptive symmetry with discrepancy absorption (S2-adjacent):** the "imagination strategy" of
  Brešar–Klavžar–Rall in domination games (SIAM J. Discrete Math. 24, 2010) — play an imagined
  game, map moves back, absorb discrepancies. A search found no formal "mirror strategy with
  bounded repairs" technique in the literature under any name; a cleanly written L7/S2 schema
  would be filling a real gap, not reinventing one.
- **Finite-state periodicity certificates (L8):** Guy & Smith, "The G-values of various games",
  Proc. Camb. Phil. Soc. 52 (1956). Node-Kayles on paths ≡ Dawson's chess (octal 0.137, period
  34; restated in Guignard & Sopena, "Compound Node-Kayles on Paths", TCS 410, 2009) — so the
  fixed-width strip project is the 2D extension of a solved classic. Newest family periodicity
  result: Songsuwan, "Node-Kayles on Trees" (arXiv:2512.24221, 2025). Nimber formulas/recursions
  on graph families: Brown et al., "Nimber Sequences of Node-Kayles Games", J. Integer Seq. 23
  (2020) — the paper behind the `P(n,2)` target above.
- **Algebraic quotient certificates:** Plambeck & Siegel, "Misère quotients for impartial
  games", JCTA 115 (2008) — the precedent for "a finite algebraic certificate replaces
  unbounded search", the same spirit as L9's module quotients.

## Number theory and open-problem adjacencies

Citations web-verified 2026-07-04 (later session). These are **positioning, not
contributions** — the work sits next to these problems, it does not attack them — except where a
game statistic is itself an unasked question in the neighboring field, flagged `[NEW-Q]`. Three
items were corrected against the sweep and are marked *(corrected)*.

**Paley-adjacent (the tightest links).**

- **Clique/independence number = the tractability floor.** Node-Kayles game length in `Paley_p`
  is at most `alpha(Paley_p) = omega(Paley_p)` (self-complementarity), which is exactly why the
  sweeps stay cheap. The clique number is a well-known hard problem: upper bound
  `omega <= (1+sqrt(2p-1))/2 ~ sqrt(p/2)` (Hanson & Petridis, arXiv:1905.09134, *Proc. LMS*
  2019-21), improving the classical `O(sqrt p)`; lower bound `Omega(log p . log log p)` under GRH
  (`Omega(log p . log log log p)` unconditional), Graham-Ringrose. *(corrected)* the polylog
  *conjecture* is folklore (random-graph analogy), **not** attributed to a named author, and
  `log p . log log p` is a proven lower bound, **not** an empirical typical value. We do not touch
  `omega`; the certificates live in its shadow. `[NEW-Q]` "adversarial greedy independent-set
  size" — game length under optimal Node-Kayles play — is a natural statistic between `omega` and
  the maximal-independent-set spectrum that this literature does not study.

- **Sum-free / independent-set counting (Cameron-Erdos lineage).** Independent sets in
  `Cay(Z_n,S)` are exactly `S`-free sets; counting sum-free subsets of `{1..n}` (`~2^{n/2}`) was
  the Cameron-Erdos conjecture, proved by Green (*Bull. LMS* 36, 2004) and independently
  Sapozhenko (2003). Counting *maximal* sum-free sets: Balogh-Liu-Sharifzadeh-Treglown
  (*Proc. AMS* 143, 2015; sharp in *JEMS* 20, 2018). Node-Kayles terminates on a maximal `S`-free
  set. `[NEW-Q]` the *parity distribution* of maximal `S`-free sets (recall: all-facets-same-parity
  forces the outcome) is the game-relevant statistic that counting program does not ask.

- **Effective character sums (the Weil-closure step).** Plan step 4's explicit threshold `p_0` is
  a Burgess-bound question. The extreme form, the least quadratic nonresidue, has Burgess's
  exponent `1/(4 sqrt e)+eps` (~1957/62), Vinogradov's conjectured `O(p^eps)`, and Ankeny's
  `O((log p)^2)` under GRH (1952). We stay on the tractable side *only if* the certificate
  vocabulary needs "a reply of signature sigma" and never "a *small* reply" — keep it size-free.

- **Explicit Ramsey graphs (Erdos $100 problem).** Paley graphs were long the best explicit
  construction with no clique/independent set `> c.log n`; the $100 Erdos problem (an explicit
  graph matching the random `O(log n)` bound) is still open — recent progress reaches only
  quasi-polylog (Chattopadhyay-Zuckerman, STOC 2016 / *Annals* 2019, Godel Prize 2025; Gil Cohen
  ~2015). Pure context, no game hook.

**Broader-program-adjacent.**

- **Toroidal queens <-> complete mappings.** Torus-queen placements are (strong) complete
  mappings of `Z_n` / diagonal Latin squares; complete solutions exist iff `gcd(n,6)=1` (Polya,
  1918). Existence theory runs through Hall-Paige (a group has a complete mapping iff its Sylow-2
  subgroup is trivial or non-cyclic), proved 2009 (Wilcox + Evans + Bray, via CFSG). Counting is
  the *(corrected)* **Rivin-Vardi-Zimmerman** conjecture (1994) — not "Vardi" alone — upper bound
  Luria (arXiv:1705.05225, **2017**, *(corrected)* not 2021), matching toroidal lower bound
  Bowtell-Keevash (arXiv:2109.08083, 2021); ordinary n-queens count `c=1.942+-0.003` (Simkin,
  arXiv:2107.13460, 2021). `[NEW-Q]` our torus *endgames* depend on *maximal partial* strong
  complete mappings, essentially untouched in that line.

- **k-slope lattice games <-> no-three-in-line.** The "k slopes of the projective line over `Z_n`"
  generalization points at general-position problems. No-three-in-line (Dudeney 1917) has Erdos's
  parabola construction (published by Roth 1951), lower bound `(3/2)n - o(n)`
  (Hall-Jackson-Sudbery-Wild 1975), and conjectured constant *(corrected)* **~1.814** (Ellmann;
  the older ~1.874 figure was revised down); whether `2n` (the trivial upper bound) is reachable
  for all large `n` is open. The line-pairing machinery transfers; the game version appears new.

- **Certificate theory <-> Erdos-Selfridge.** The potential criterion `sum_A 2^{-|A|} < 1/2 =>`
  second player (Breaker) wins (*JCTA* 14, 1973) is the canonical compact certificate in
  positional games. It does not apply verbatim to last-player-wins vertex deletion, but a
  potential-function analog would be a fourth certificate type beside S1/S2/dense leaves — worth
  shelving for the `p = 5 (mod 8)` side, where pairing fails maximally.

- **Generalized Paley <-> Chebotarev/Artin.** For k-th-power Paley graphs, L2's hypothesis becomes
  "2 is a k-th-power residue," so the good/bad prime classes become splitting conditions in
  `Q(zeta_k, 2^{1/k})` (Chebotarev density); the degenerate extreme ("2 generates the residues")
  is Artin's primitive-root conjecture, open unconditionally as of 2026 (Hooley 1967 under GRH;
  Heath-Brown 1986: at most two exceptional *base values* `a` — *(corrected)* base values, not
  primes). Only relevant if plan step 5 runs.

**Complexity anchor.** Node-Kayles is PSPACE-complete in general (Schaefer, *JCSS* 16, 1978), so
a bounded-first-order-depth certificate on a *specific* family is a genuine complexity collapse,
not a triviality — the clean statement of why the Paley and torus laws are worth proving.

## Near-term work order

1. Make the extractor's reply selection depth-minimal and orbit-canonical (prefer S1-terminal
   replies; break ties by a fixed orbit-representative rule), re-extract the `n=10` table, then
   compress it into modular cases.
2. Test those cases at `n=12` with a purpose-built validator that checks the proposed replies,
   not with a broad full-Grundy search.
3. If the S2 vocabulary does not compress, switch to even kings; they are the better finite-defect
   laboratory.
4. Keep lattice strips and odd `P(n,2)` as separate projects because their likely proof method is
   finite-state recursion, not scar repair.
5. Paley (target 6): run plan-of-attack steps 1-3 — cheap, parallelizes with the torus work, and
   the same S1/cert_depth tooling drives both. Promote to a proof push only if the signature
   vocabulary stabilizes across `p`.
