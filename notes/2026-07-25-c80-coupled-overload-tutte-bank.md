# C80 — coupled overload-retention/Tutte-excess bank falsifier

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The natural nonrecursive coupled bank is false, and the failure identifies a
more basic obstruction than a bad coefficient.

For a positive-overload state `S`, let `R_Ω(S)` be the graph whose vertices
are the legal moves and whose edges are the jointly legal opponent/reply
pairs that land at strictly lower `Ω`. Define the raw Tutte excess by

```text
ε_Ω(S) = |V(R_Ω(S))| - 2ν(R_Ω(S)) - (|V(R_Ω(S))| mod 2).
```

This is nonrecursive: it uses legality and strict overload descent, but no
P/N value, Grundy value, `F_cc`, or `M_Ω` membership. The simplest coupled
bank is

```text
b_λ(S) = Ω(S) - λ ε_Ω(S),       λ >= 0.
```

It is falsified simultaneously on all four marked q=17 exceptional fibres.
Each fibre has a unique certified `F_cc` reply with target coordinates

```text
(Ω, ε_Ω) = (40, 0),
```

while a non-survivor reply has coordinates

```text
(Ω, ε_Ω) = (49, 0).
```

Thus the non-survivor strictly dominates the certified reply for every
`λ>=0`. More generally, the same four witnesses falsify every two-coordinate
bank that is increasing in retained overload and decreasing in raw Tutte
excess.

The reason is exact. Each q=17 target's raw strict-reply graph has 32
vertices, 194 edges, and a perfect matching, so `ε_Ω=0`. Its previously
observed deficiency two appears only after edges are filtered by recursive
lower-`M_Ω` membership. The proposed “Tutte resource” is therefore either
too weak when defined nonrecursively or circular when defined using the
survivor it is meant to prove.

The marked q=19 control confirms the distinction. Both the maximum-drain
decoy `(7,1)` and the structural reply `(0,2)` have raw excess zero. Their
overloads are respectively 152 and 169, so retention alone orders this one
fork correctly; the Tutte coordinate contributes nothing.

The `tt` correction is sharper: the finite thread is `4→2→0` only for
simultaneous matching deficiency. For the actual alternating game
quantifiers it is `4→0`: the root has four isolated marked fibres, while
each exceptional target has deficiency two but no isolated fibre. The
intermediate “debt two” is a certificate-compression artifact, not game
debt.

## 1. Exact q=17 falsifier

The missed q=17 root is

```text
t4 = {13,14,15,16},    Ω(root)=820.
```

Each of its four isolated marked fibres has child overload 246 and exactly
58 legal strict-overload replies. The unique `F_cc` repair and a dominating
non-survivor are:

| opponent | certified reply | certified `(Ω,ε_Ω)` | non-survivor reply | non-survivor `(Ω,ε_Ω)` |
| --- | --- | --- | --- | --- |
| `(4,0)` | `(7,1)` | `(40,0)` | `(5,15)` | `(49,0)` |
| `(5,0)` | `(4,10)` | `(40,0)` | `(7,7)` | `(49,0)` |
| `(8,14)` | `(4,10)` | `(40,0)` | `(6,2)` | `(49,0)` |
| `(11,9)` | `(7,1)` | `(40,0)` | `(10,13)` | `(49,0)` |

The search enumerates all 58 strict replies in each marked fibre, orders
them by retained overload, and stops the expensive raw-graph calculation as
soon as it finds a strict dominance witness. The four displayed witnesses
are the highest-retention candidates checked and suffice to refute the
entire monotone two-coordinate family; the computation does not classify
the remaining replies by raw excess.

At each certified target:

| graph | vertices | edges | matching | deficiency | excess |
| --- | ---: | ---: | ---: | ---: | ---: |
| raw `R_Ω` | 32 | 194 | 16 | 0 | 0 |
| filtered through lower `M_Ω` | 32 | 53 | 15 | 2 | 2 |

This is the decisive gap. Tutte excess is not an intrinsic feature of the
geometric strict-descent relation here. It is created by deleting precisely
the edges whose targets are not already known to lie in the lower survivor.
Using the filtered number in a bank merely repackages the recursive
membership problem.

There is also a game-semantic warning. The filtered target graph has
deficiency two but no isolated marked fibre, so it is already
opponent-complete: every opponent move has some certified reply. A perfect
matching is a compact simultaneous response certificate, not a necessary
condition for the `∀o∃p` game quantifiers. Treating its Tutte deficiency as
debt assigns a cost to structure the winning argument does not need.

## 2. Marked q=19 control

At the existing q=19 root `{15,16,17,18}` and marked opponent `(4,0)`:

| reply | role | target `Ω` | raw graph `(v,e,ν)` | raw excess | survivor |
| --- | --- | ---: | --- | ---: | --- |
| `(7,1)` | rational maximum-drain decoy | 152 | `(48,538,24)` | 0 | outside `F_cc` and `M_Ω` |
| `(0,2)` | first structural reply | 169 | `(51,603,25)` | 0 | inside `F_cc` and `M_Ω` |

The unavoidable deficiency one of the 51-vertex graph is removed in the
definition of excess. Hence the q=19 fork supplies no positive evidence for
a Tutte charge: the proposed bank agrees with the structural choice only
because it reduces to retained overload on these two targets.

The q=19 domain is exactly this marked opponent and these two previously
identified replies. No full q=19 reply fibre or all-root census was run.

## 3. Consequence for the C80 proof shape

The coupled scalar was aimed at the wrong level. The missing information is
not a state-level exchange rate between `Ω` and matching deficiency. It is a
sound, nonrecursive **edge predicate** that recognizes which strict replies
carry a proof of future survival:

```text
E_alg(S,o,p)
  => S+o+p has a structural lower-rank certificate.
```

Once such edges are available, opponent-completeness—not perfect matching—is
the exact game gate. Tutte/Gallai--Edmonds structure can still compress an
already certified edge relation, as it did for the finite q17 orbit, but it
cannot manufacture the admissibility labels. The next C80 attack should
therefore seek a proof-producing marked secant/incidence edge certificate
that separates the four q17 `Ω=40` repairs from their `Ω=49` decoys and the
q19 `Ω=169` survivor from the `Ω=152` decoy. Another scalar state profile or
matching shell will repeat the present failure.

## 4. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_coupled_overload_tutte_bank.py
python3 rust/scripts/c80_coupled_overload_tutte_bank.py --check
```

The deterministic generator imports the committed q17 positive-pairing,
adaptive-copycat, strict-overload, and Tutte-contraction engines. It
reconstructs the marked states from normalized prime-grid coordinates,
enumerates legal strict replies, builds the raw reply graphs, and writes
canonical sorted JSON. `--check` regenerates into a temporary directory and
requires byte equality.

The matching implementation is exhaustively compared with subset-DP on all
33,867 labelled graphs of orders at most six. Every large raw graph reported
above also has a reconstructed Gallai--Edmonds/Tutte--Berge upper certificate
matching the explicit matching lower bound. Geometric legality, `Ω`, and
`F_cc`/`M_Ω` labels still use the same frozen normalized prime-grid engine;
there is no second independent projective implementation in this bundle.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_coupled_overload_tutte_bank.py` | 10,797 | `62061beb810d48a35fbe31ce8391b430267623c48656d8618c40028ca1719551` |
| `notes/2026-07-25-c80-coupled-overload-tutte-bank.json` | 8,075 | `10468f6817215be2a64eb922643f264061e774047844e7d394108f77ede134a8` |

This proves the stated bounded negative for the four q17 marked fibres and
the two-target q19 control. It does not rule out a bank using a different
nonrecursive proof-producing coordinate, a nonmonotone formula, or a
uniform odd-q response theorem.

## `ej` + `tt` closeout

The cheap `ej` upgrade strengthens the coefficient failure to a whole
monotone family: because the q17 decoys have the same raw excess and retain
more overload, no choice of scale, normalization, or monotone nonlinear
combination of these two coordinates can rescue the certified replies.

The Tao-style point is that the observed Tutte defect is endogenous to the
edge-admissibility proof. Raw geometry gives perfect matchings; recursive
survivor filtering creates deficiency. The hard theorem is therefore not
how to price the deficiency but how to certify enough edges without already
knowing the lower kernel. The exact target is `∀o∃p E_alg(S,o,p)`, with
matching used only as optional compression after `E_alg` is proved.

The further `tt` upgrade replaces the apparent `4→2→0` bank trajectory by
the game-semantic isolation trajectory `4→0`. This suggests the cheapest
next extraction: for each `Ω=49` q17 decoy and the q19 `Ω=152` decoy, emit a
minimal spoiling opponent with no proof-producing lower-rank reply, then
canonicalize those obstruction fibres. A shared normalized obstruction
would be a theorem-shaped target; a split would falsify another tempting
local law before any counting campaign.

No incidental discovery-track item arose: the raw/filtered distinction and
the q17 dominance witnesses were the requested task deliverables.

## Mystery ledger

- **[SETTLED negative] Can retained overload and raw strict-reply Tutte
  excess form the requested bank?** No. Raw excess is zero on every tested
  target, and four q17 non-survivors strictly dominate the certified repairs.
- **[SETTLED] Where did the finite q17 `4→2→0` defect come from?** From
  filtering reply edges by recursive lower-`M_Ω` membership, not from the raw
  strict-descent geometry.
- **[SETTLED negative] Does the marked q19 fork supply an independent Tutte
  signal?** No. Both targets have raw excess zero; retention alone orders the
  structural target above the maximum-drain decoy.
- **[SETTLED conceptual] Must deficiency two itself be paid down for game
  soundness?** No. The q17 target graph has no isolated fibre, so the
  `∀opponent∃reply` condition already holds despite the missing simultaneous
  matching.
- **[SETTLED `tt`] What is the correct finite defect trajectory?** For game
  semantics it is isolation count `4→0`; `4→2→0` is only the stronger
  simultaneous-matching trajectory.
- **[OPEN — C80] What nonrecursive marked edge predicate proves lower-rank
  survival?** The evidence gap is exact: it must accept the q17 `Ω=40` repairs
  over their `Ω=49` decoys and the q19 `Ω=169` target over the `Ω=152` decoy.
- **[OPEN — C80/C82 gate] Can that edge packet be constructed and counted
  uniformly from secant/conic incidence?** Unknown; C82 remains gated.

## Vibe

This is a clean and useful negative. The proposed bank does not merely need
better tuning; its Tutte coordinate disappears before the recursive oracle
is applied. That removes another attractive but circular compression and
points directly at the missing proof-producing edge relation.

go C80 cap extract a nonrecursive marked admissible-edge certificate for the q17 repairs and q19 control
