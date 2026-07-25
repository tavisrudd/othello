# C80 — positive-overload pairing shell

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The adaptive copycat boundary does lift through most positive-overload
states, but the clean pairing lift is false at q=17.

Let `M_Ω` be the well-founded survivor with boundary `B_cc` at `Ω=0`.
At positive overload, form the marked strict-reply graph `H_M(S)` on the
legal moves, joining `x` and `y` exactly when

```text
S+x+y is legal,
Ω(S+x+y) < Ω(S),
and S+x+y ∈ M_Ω.
```

Accept `S` when `H_M(S)` has a perfect matching, or, at odd order, a
near-perfect matching whose unmatched vertex has a separate neighbour.
This is a structural pairing shell: a matched opponent is answered by its
mate, while the unmatched marked opponent uses the separate neighbour.
Every response lands at lower `Ω`, so induction proves `M_Ω⊆P` without
Grundy values or cap minimax in the membership predicate.

Exact replay gives:

| q | exact P escape roots | `M_Ω` roots | exact agreement |
| ---: | ---: | ---: | ---: |
| 13 | 5/5 | 5/5 | yes |
| 17 | 5/10 | 4/10 | no |

All five q=17 N roots are still rejected. The sole missed P root is
`{13,14,15,16}`. Thus a persistent perfect/near-perfect response packet at
every positive rank is too strong and cannot be the uniform C80 theorem.

## 1. Sound positive pairing packet

The matching packet is weaker than a geometric involution and stronger than
the bare `∀ opponent ∃ reply` kernel clause.

- If `|H_M(S)|` is even, a perfect matching supplies one strict lower-rank
  reply for every marked opponent.
- If `|H_M(S)|` is odd, remove one nonisolated bye vertex, perfectly match
  the rest, and give the bye any incident strict lower-rank reply.

In either case every opponent has an explicitly stored response into a
lower-`Ω` member. The `Ω=0` leaves have the previously proved persistent
pairing or one-exchange adaptive copycat certificate `B_cc`. Well-founded
induction therefore proves every accepted state P.

This is a genuine nonrecursive strengthening of the finite survivor: the
positive predicate calls only lower-`Ω` instances of itself. It does not
consult the old `K_Ω`, `F_cc`, P/N value, or Grundy value.

## 2. Exact q=17 obstruction

At the missed root `{13,14,15,16}`:

```text
Ω = 820
legal moves = 104
strict replies into M_Ω = 158 undirected edges
maximum matching size = 50
matching deficiency = 4
isolated marked fibres = 4
```

The four isolated opponent cells and their unique replies into the older
copycat survivor `F_cc` are:

| opponent | unique `F_cc` reply | target `Ω` | target in `M_Ω` |
| --- | --- | ---: | --- |
| `(4,0)` | `(7,1)` | 40 | no |
| `(5,0)` | `(4,10)` | 40 | no |
| `(8,14)` | `(4,10)` | 40 | no |
| `(11,9)` | `(7,1)` | 40 | no |

These are not failures of strict overload descent: each marked fibre has a
unique strict reply in `F_cc`. They are failures of the stronger demand that
the target already carry the positive pairing shell.

Following only these exceptional replies produces exactly four size-six
targets. Each target has no isolated marked fibre into `M_Ω`, but its reply
graph has matching deficiency two. Hence a two-exchange adaptive wrapper
around `M_Ω` repairs this finite root:

```text
missed root
  -- one of four exceptional marked exchanges -->
size-six target with no isolated fibre into M_Ω
  -- one adaptive exchange -->
M_Ω.
```

The whole exceptional thread has five states and four transitions; its
canonical transition digest is
`3433a03c9ac3a336d8d60be046075b5a34470436d0c031e62b650d206de058d2`.
This is a useful exact normal form, not evidence that two adaptive layers
suffice uniformly.

## 3. Audit against the older strict survivor

For diagnosis only, the script also forms the reply graph whose edges land
in the older `F_cc` survivor over every positive state reached by its
deterministic q=13/q=17 certificate DAG.

- q=13: all 32 positive states have maximum matching deficiency equal to
  parity.
- q=17: 163 of 1,083 positive states exceed parity deficiency.
- Expanding from the selected certificate replies to all strict `F_cc`
  replies repairs 159 of those 163 by one exchange into a pairable state.
  Four states retain one or four uncovered marked opponents.

This audit explains why a pairing law looked nearly exact while remaining
false. Because its edges use `F_cc` membership, it is not itself a
nonrecursive theorem; the well-founded `M_Ω` experiment above is the
load-bearing falsifier.

## 4. q=19 boundary probe

The older single certified q=19 strict-kernel root `{15,16,17,18}` also
survives when its arbitrary `Y_NK` leaves are replaced by `B_cc`:

```text
copycat-boundary survivor = yes
accepted B_cc boundary states = 23,936
certified positive response edges = 54,501
boundary-mask SHA-256 =
  374fbcb2a723201ab518dbf9a42962f1294f3260573b65931fec9d4c11c700cd
response-map SHA-256 =
  46450a12385cac5cbab384596222abd90eacc91e1e08f4c44c0d5bd0a0004961
```

This is the first boundary test beyond q=17 and is positive. Its domain is
one previously certified q=19 root, not all q=19 escape roots or all
overload-zero residual graphs. It supports boundary uniformity while leaving
the positive pairing obstruction and the uniform marked-reply construction
open.

## 5. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_positive_pairing_shell.py
python3 rust/scripts/c80_positive_pairing_shell.py --check
```

Load-bearing inputs:

- `notes/data/c20-q13-q17-states.jsonl.gz`;
- `rust/scripts/c80_adaptive_copycat_survivor.py`;
- `rust/scripts/c80_strict_overload_kernel.py`;
- the normalized prime-grid legality and projective-line constructors
  imported by those scripts;
- `notes/2026-07-24-c80-scale-survivor-falsifiers.json` for the identity and
  prior strict-kernel sizing of the q=19 probe root.

The output is canonical JSON. `--check` regenerates it in a temporary
directory and requires byte equality. The Edmonds matching implementation is
cross-checked exhaustively against an independent subset-DP matcher on all
33,867 labelled graphs of orders one through six. Exact cap root values are
computed on a separate code path from pairing-kernel membership and agree
with the prior q=13/q=17 value ledger. There is no second independent
projective-grid implementation in this bundle; geometric legality and `Ω`
use the already frozen normalized engine, and the claim is limited to the
listed domains.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_positive_pairing_shell.py` | 27,095 | `3f4dacaa20a8894f8bea2c40bd91d10183b43bf81b95cb375a81135dbbf72bf5` |
| `notes/2026-07-25-c80-positive-pairing-shell.json` | 53,349 | `7e972c4c0c1879ae95e7e8194bc9c7634291a49247de75e7d379be9f59025fdb` |

The computation does not prove a q-independent pairing packet, a uniform
bound on adaptive-shell depth, or odd-q escape. It proves the stated
q=13/q=17 finite positive and the exact q=17 bounded negative.

## `ej` + `tt` closeout

The cheap upgrade was to replace the tempting old-kernel matching audit by
the well-founded survivor `M_Ω`. That removes a hidden semantic oracle and
turns the q=17 miss into a theorem-shaped counterexample: perfect or
near-perfect strict-response matching at every positive rank is false.

The Tao-style residue is the four-fibre defect thread. The important object
is not its small cardinality but its quantifier change:

```text
pairing packet
or marked exceptional exchange into a state whose reply relation is
opponent-complete but Tutte-deficient.
```

The next proof attempt should explain that marked exchange by normalized
secant algebra and allow the defect to contract across rank. It should not
promote the observed two-layer depth or the four q=17 cells to a uniform
lookup rule.

## Mystery ledger

- **[SETTLED negative] Does the `B_cc` pairing packet persist at every
  positive `Ω` rank?** No. The P root `{13,14,15,16}` is rejected by the
  well-founded positive pairing kernel.
- **[SETTLED] Is the miss caused by lack of strict overload replies?** No.
  There are four isolated pairing fibres, each with one strict reply in
  `F_cc`.
- **[SETTLED finite] What happens after those replies?** They give four
  size-six targets with no isolated fibres and matching deficiency two; one
  further adaptive exchange reaches `M_Ω`.
- **[OPEN — C80] Is there a q-independent algebraic contraction of this
  marked Tutte defect?** Unknown. This is the new positive-overload lifting
  target.
- **[OPEN — C80] Is adaptive-shell depth bounded, slowly growing, or
  unbounded in q?** The present q=13/q=17 data do not decide it.
- **[SETTLED finite positive] Does the structural `B_cc` boundary survive
  beyond q=17?** Yes on the single previously certified q=19 root, with
  23,936 accepted boundary states. The all-root q=19 and uniform statements
  remain open.
- **[OPEN — C80/C82 gate] Can secant/orbital counting guarantee the marked
  defect exchange without recursive kernel membership?** Unknown; C82
  remains gated.

## Vibe

The direct lift is a near miss, but a valuable one: the failure is not diffuse
or profile-level. It is one P root, four marked fibres, and a two-step
Tutte-defect thread. That is much sharper than another classifier failure,
while still being a real obstruction to the clean pairing theorem.

go C80 cap contract the marked positive-overload Tutte defect
