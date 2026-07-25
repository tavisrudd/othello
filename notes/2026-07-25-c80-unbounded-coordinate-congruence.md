# C80 — unbounded-coordinate congruence is formally trivial

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The requested fixed-dimensional, unbounded-range exact congruence **exists
trivially in dimension one** unless “algebraic” is given an explicit
complexity restriction.

Every finite mixed-capacity residual object

```text
R = (V,E,A)
```

has a canonical natural-number code. Decode the code, apply the exact
residual transform `D_x`, and re-encode. This gives one unbounded integer
coordinate whose update preserves the entire rooted continuation game and
therefore preserves `Ω`, `Y_NK`, `K_Ω`, `F_α`, and every lower-`K_Ω`
response.

Thus the literal existence question is proved positive, but it supplies no
compression and no nonrecursive membership theorem. In particular it does
**not** release C82. The word “algebraic” cannot carry that missing content
without specifying allowed formulas, information growth, and the required
nonrecursive decoder.

## 1. Coding theorem

Work with finite labelled residual objects. Fix once and for all:

- a bijective pairing function `⟨-,-⟩ : ℕ² ≃ ℕ`;
- the binary code `set(B)=Σ_{b∈B}2^b` for finite subsets of `ℕ`;
- the induced recursive codes for finite tuples and finite sets of tuples.

Encode vertices by their ambient finite labels, pair-conflict blocks as
finite sets of vertex labels, and active capacity-two blocks likewise. Nested
pairing gives an injection

```text
enc : Residual → ℕ.
```

Use a tagged encoding if the field order or ambient label convention must be
retained. Let `dec` be the inverse on the image of `enc`.

### Theorem — one-coordinate exact transition congruence

There is a one-dimensional unbounded-range coordinate

```text
π(R) = enc(R) ∈ ℕ
```

and a q-independent update operation

```text
U(z,x) = enc(D_x(dec(z)))
```

on valid coded moves such that

```text
π(D_x R) = U(π(R),x).
```

**Proof.** Substitute `z=enc(R)` and use
`dec(enc(R))=R`. The result is
`enc(D_x R)` on both sides. ∎

Because `enc` is injective, equality of codes is an exact congruence, not
merely a P/N quotient. The C80 residual-exchange theorem says that `D_x`
computes the direct geometric follower. Hence the code determines every
legal continuation and its full game tree. All residual invariants and
recursive kernels therefore factor through `π`.

The same construction can encode unlabelled residual isomorphism types:
take the least labelled code over all vertex relabellings and retain the
transported move label. This changes the cost of computing `U`, not the
existence theorem.

## 2. Why this does not advance the game theorem

The coordinate `enc(R)` contains the whole residual object. Its bit length
grows with the complete incidence description, and evaluating `U` is exactly
“reconstruct, play, recode.” Transporting `K_Ω` through this injection gives
only

```text
enc(R) ∈ enc(K_Ω)  ↔  R ∈ K_Ω,
```

which is the original recursive membership problem with different syntax.

This is the unbounded-coordinate analogue of writing an arbitrary finite
graph as one adjacency-matrix integer. Fixed coordinate count alone is not
an information bound. Consequently:

- C80's finite-state no-go remains correct;
- allowing unrestricted unbounded integers evades it completely;
- “closed under the transform” does not imply useful renormalization;
- “preserves lower-`K_Ω` responses” does not imply that those responses are
  recognized nonrecursively.

If “algebraic” is intended to mean polynomial or rational update maps, bounded
degree, bounded-height incidence moments, Presburger formulas, or another
restricted language, that language is part of the theorem statement. The
current target specifies none of these inequivalent meanings, so no stronger
positive or negative claim follows from it.

## 3. Corrected crown

A nonvacuous successor should ask for an **information-bounded algebraic
quotient**, not merely a fixed number of coordinates. One precise admissible
gate is:

1. fixed dimensions `d,e` and a constant `C`, independent of `q`;
2. state coordinates `π_q(R)∈ℤ^d` and marked-move coordinates
   `τ_q(R,x)∈ℤ^e`, each entry bounded by `q^C`;
3. a fixed finite collection of bounded-degree piecewise-polynomial update
   formulas `F` with
   `π_q(D_xR)=F(π_q(R),τ_q(R,x))`;
4. fixed decoders for `Ω=0`, the `Y_NK` boundary value, and the existence of
   a strict lower-`K_Ω` reply;
5. the lower-kernel decoder is nonrecursive in the game tree.

The polynomial range bound is the essential anti-packing clause: with fixed
dimension it limits the signature to `O(log q)` bits. The fixed formula and
nonrecursive decoder clauses prevent `D_x` and `K_Ω` from being hidden inside
an oracle-valued coordinate. The exact choice of algebraic language remains a
research decision, but it must be fixed before another proof/falsification
attempt.

The earlier conic family forces at least linearly many exact transition
classes, so it is compatible with this polynomial-information gate; it does
not itself falsify the corrected target.

## 4. `ej` upgrade — the first information lower bound

The sealed-conic family does give a quantitative constraint on any
polynomial-range **exact** quotient.

Suppose `π_q` has `d` integer coordinates and each coordinate takes at most
`Bq^C` values, with `B,d,C` independent of `q`. Then the quotient has at most

```text
(Bq^C)^d = B^d q^(Cd)
```

states. The conic family requires at least
`floor((q-2)/4)+1` exact transition classes. Therefore necessarily

```text
Cd ≥ 1.
```

So even the overload-zero boundary needs asymptotically at least `log₂q-O(1)`
bits of exact state information. This is weak—the single coordinate `n`
attains the correct order—but it is the first representation-independent
lower bound on an admissible polynomial-information signature.

### Exact congruence is probably more than C80 needs

The descent theorem has alternating quantifiers:

```text
for every opponent move, there exists a strict-overload reply
into the controlled family.
```

It does not require preserving every follower or the full rooted game.
Accordingly, the highest-EV corrected target is a **sound alternating
response algebra**, not necessarily an exact transition congruence. Such an
algebra needs:

1. an information-bounded state summary and marked-move summary;
2. a sound realization theorem from abstract opponent types to all concrete
   opponent moves;
3. an abstract reply relation with a lifting theorem producing a concrete
   legal reply;
4. strict decrease of `Ω` for the lifted reply;
5. a sound `Y_NK` base decoder.

This retains precisely the `∀o∃p` structure used by the `K_Ω` induction while
allowing many irrelevant followers to be merged. Requiring bisimulation would
spend information on game-tree distinctions that a P-strategy certificate
never queries. The exact residual transform remains the domain-level
substrate against which the lifting theorem is proved.

## 5. `tt` correction — seek a ranked invariant, not a quotient

Pushing the quantifiers one step further removes “quotient” from the
load-bearing theorem altogether.

It is enough to construct two uniformly described families of residuals:

```text
F_q = the positive-overload controlled family,
B_q = a structurally proved-P overload-zero boundary packet.
```

The required theorem package is:

```text
root_q ∈ F_q;

R∈F_q and Ω(R)=0  →  R∈B_q;

R∈F_q and Ω(R)>0  →
  for every concrete legal opponent move o,
  there exists a concrete legal reply p such that
    D_p(D_o(R))∈F_q and Ω(D_p(D_o(R)))<Ω(R);

R∈B_q  →  R is P.
```

Induction on `Ω` proves every state of `F_q` P. This is precisely the earlier
survivor-family theorem shape, now stripped of the unnecessary requirement
that `F_q` arise as fibres of a transition congruence.

The algebraic work may consist of a fixed list of incidence identities,
inequalities, and existence lemmas defining and preserving `F_q`. It need not
provide a deterministic abstract update map. Different concrete opponents
with the same coarse algebraic data may use different replies; the closure
theorem quantifies over them directly.

### The hidden boundary crown

The base condition must not be stated as an oracle for

```text
Grundy(G_R)=0.
```

That merely hides the Node--Kayles value problem at `Ω=0`. A uniform proof
needs a structurally recognizable subfamily `B_q⊆Y_NK` with its own P-proof
(for example, a valid copycat/pairing theorem or another explicit graph
decomposition). The previous fixed-size empty/pure-one-dimensional leaf was
falsified, but that does not exclude a growing-depth strategy landing in a
different structural boundary packet.

Hence C80 has two coupled construction obligations:

1. **survival:** an algebraically defined `F_q` closed by strict-`Ω`
   responses;
2. **absorption value:** a uniform, nonrecursive P-theorem for
   `B_q=F_q∩{Ω=0}`.

C82 should count replies only after both objects are stated. Counting a
packet that descends into arbitrary `Y_NK` merely transfers the unresolved
value question to the boundary.

The `Cd≥1` lower bound remains a correct diagnostic for exact quotients, but
it is not a lower bound on this one-sided strategy certificate. A direct
ranked-invariant proof may use fewer state bits because it is not separating
exact follower types.

## Trust boundary

This is a coding proof, not a computational claim. It uses only:

- finiteness of each residual object;
- the exact transform theorem `R(S+x)=D_xR(S)`;
- the already established fact that the C80 residual invariants and kernels
  factor through `R`.

No census, solver, literature claim, or uncommitted artifact is used.

## `ej` + `tt` closeout

The cheap extra conclusion is stronger than “one candidate failed”: **every
unrestricted fixed-dimensional unbounded-coordinate existence target is
vacuous**, because dimension does not control encoded information.

The Tao-style correction is to separate three resources:

```text
number of coordinates;
information/height carried by each coordinate;
complexity of update and kernel decoding.
```

C80 had constrained only the first. The second and third are where the game
theorem lives.

## Mystery ledger

- **[SETTLED positive, but vacuous] Does a fixed-dimensional unbounded-range
  exact congruence exist?** Yes, in dimension one by canonical coding.
- **[SETTLED negative] Does fixed dimension alone express genuine
  compression?** No; one integer can contain the entire residual incidence
  structure.
- **[SETTLED] Does this release C82?** No. Kernel recognition remains exactly
  as recursive as before.
- **[OPEN — C80] Which information and formula bounds define the intended
  algebraic quotient?** The report gives a concrete polynomial-information
  gate, but adopting that gate changes the theorem statement and should be
  explicit.
- **[SETTLED quantitative] What information is unavoidable for an exact
  polynomial-range quotient?** At least `log₂q-O(1)` bits; in the coordinate
  model, `Cd≥1`.
- **[OPEN — higher-EV C80 reformulation] Is a sound information-bounded
  alternating response algebra enough, avoiding exact bisimulation?** Yes at
  the level of the strict-`Ω` induction; the missing work is its geometric
  construction and lifting theorem.
- **[SETTLED tt correction] Must the response algebra be a quotient with a
  closed abstract update?** No. A directly defined ranked family `F_q` with
  concrete `∀o∃p` closure is sufficient.
- **[OPEN — hidden boundary crown] What uniformly recognizable
  `B_q⊆Y_NK` receives the absorption and has a structural P-proof?** Arbitrary
  boundary Grundy zero is not an admissible decoder; the earlier fixed-size
  pure-one-dimensional packet is already false.
- **[OPEN — C80 crown] Under the adopted anti-packing gate, can positive
  overload escape roots be placed uniformly in `K_Ω`?** No proof or
  falsification is currently known.

## Vibe

This is a useful specification failure caught cleanly: the literal crown has
a one-line coding proof, while the mathematical difficulty is untouched. The
extra squeeze improves the next shape: state the ranked survivor/boundary
pair `(F_q,B_q)` and prove its concrete `∀opponent∃reply` closure, rather than
building an unnecessarily exact quotient.

go C80 cap state and prove or falsify an algebraic ranked survivor with a
structural P boundary packet
