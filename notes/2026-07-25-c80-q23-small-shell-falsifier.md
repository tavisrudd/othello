# C80 — q23 small-shell falsifier and incidence equations

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

The bounded small-shell correspondence is sound but not a uniform C80
survivor. It fails decisively on the first q23 control.

The C54 rules-checked raw archive gives

```text
S4 q=23, t4=(1,2,3,4):                         P
after opponent (0,0) and reply (5,2):          P.
```

The latter target `T` has `Omega(T)=1112` and 118 legal moves. Exact
incidence replay finds:

```text
opponents o with an R_small reply p: 0/118.
```

This is not a poor choice of the archived P reply. At the q23 root, after
opponent `(0,0)`, all 181 legal replies were tested:

```text
reply targets satisfying the outer R_small correspondence: 0/181.
```

Therefore no response to this one root opponent enters the proposed
survivor. Uniform opponent completeness is false, independently of minimax
labels on the other 180 reply targets.

The q17/q19 theorem remains valid at its stated finite scope, and
`R_small` edge soundness remains a field-uniform proof. What fails is the
coverage theorem. C82 remains gated.

## Archived P control

The normalized q23 root has affine conic cells

```text
(1,1), (2,12), (3,8), (4,6).
```

The durable C54 query rows are:

```text
STATE ply=4 cells=1,1 2,12 3,8 4,6 legal=260 value=P
REPLY x=0,0 y=5,2 ygeom=int value=P
```

The raw archive has 12,572,289 proof-DAG records and was independently
rules-checked in C54. This report uses its value only to establish that the
chosen target is a genuine P control. The `0/118` and `0/181` failures are
computed solely from projective incidence and legality.

The root's conic-projective stabilizer has order four; the selected P target
has trivial stabilizer. Hence the failure is not a forbidden canonical
selector caused by target symmetry.

## Quantitative failure

For each outer candidate follower `U=T+o+p`, let

```text
c(U) = number of legal x having some reply y into B_small,
d(U) = |Legal(U)| - c(U).
```

`Shell_small(U)` requires `d(U)=0`. For each of the 118 opponents of `T`,
the certificate tests every legal reply—between 60 and 75 per fibre—and
minimizes `d(U)`. The best attainable defects range from 3 through 22:

| minimum defect | opponent fibres |
| ---: | ---: |
| 3 | 2 |
| 6 | 2 |
| 8 | 2 |
| 9 | 7 |
| 10 | 3 |
| 11 | 9 |
| 12 | 13 |
| 13 | 9 |
| 14 | 11 |
| 15 | 14 |
| 16 | 17 |
| 17 | 8 |
| 18 | 10 |
| 19 | 5 |
| 20 | 3 |
| 21 | 2 |
| 22 | 1 |

The globally closest failed fibre is

```text
outer opponent: (9,16)
outer reply:    (17,18)
Omega(U):       18
Legal(U):       24
c(U):           21
d(U):            3.
```

Even this best row misses three inner opponents. The failure is therefore
not a tie-breaking defect or a single exceptional edge.

At the root level, the first uncovered next opponent for the 181 possible
replies to `(0,0)` lies in only eight cells:

```text
(5,2)^118 (5,9)^38 (5,10)^12 (5,11)^1
(5,13)^2 (6,3)^6 (6,4)^3 (6,5)^1.
```

That concentration is the useful residue: the bounded shell fails
globally, but its first obstruction is a small marked locus suitable for a
rank-carrying update test.

## Field-uniform incidence equations

Let `S` be a selected cap in `PG(2,q)`, let `[u,v,w]` denote the determinant
of homogeneous representatives, and write `L_S(z)` for legal membership.

### Legal locus

```text
L_S(z) iff
  z is not selected
  and [a,b,z] != 0 for every distinct selected a,b in S.
```

This is coordinate-independent because determinant vanishing is projective
collinearity.

### Zero overload

For a projective line `ell`, write

```text
Z_S(ell) iff ell contains no selected point.
```

Then

```text
Omega(S)=0 iff
  there do not exist ell and distinct u,v,w
  such that
    Z_S(ell),
    L_S(u), L_S(v), L_S(w),
    ell(u)=ell(v)=ell(w)=0.
```

Thus overload zero is a fixed-arity incidence sentence: no zero-load line
contains three legal points.

### Small boundary

The terminal clause is

```text
B_0(S) iff not exists z, L_S(z).
```

The two-move clause is

```text
B_2(S) iff exists distinct a,b such that
  L_S(a), L_S(b),
  every legal z equals a or b,
  and L_{S+a}(b).
```

The last condition says the two remaining moves are mutually legal. Hence

```text
B_small(S) iff Omega(S)=0 and (B_0(S) or B_2(S)).
```

### One-exchange shell and outer relation

```text
Shell_small(S) iff
  for every x with L_S(x),
  there exists y with L_{S+x}(y)
  and B_small(S+x+y).
```

Finally,

```text
R_small(T;o,p) iff
  L_T(o),
  L_{T+o}(p),
  and (B_small(T+o+p) or Shell_small(T+o+p)).
```

These formulas are q-independent, have fixed quantifier arity/depth, and
commute with projective transport. They prove every selected edge sound.
The q23 certificate gives an explicit model in which the required
`for every o exists p` closure is false.

## Interpretation

The q17/q19 success came from being within one exchange of a terminal or
two-point boundary. At q23 the residual scale has already escaped that fixed
shell: even the closest follower has three uncovered inner obligations.

Adding another anonymous shell layer would certify another finite depth but
would not address the known fixed-depth obstruction. The live object is
instead the defect locus

```text
Def(U) = {x in Legal(U) : no reply y reaches B_small}.
```

The q23 best row has `|Def(U)|=3`. The next useful test is whether these
three marked obligations admit a direct algebraic update that lowers a
growing rank, rather than whether depth two happens to close this one
target.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_q23_small_shell_falsifier.py
python3 rust/scripts/c80_q23_small_shell_falsifier.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_small_shell_falsifier.py` | 12,802 | `469238cea7af51daf0ba21d17c609074e1fd6d9c2d1d62e840565ec0df5ef198` |
| `notes/2026-07-25-c80-q23-small-shell-falsifier.json` | 117,259 | `a58468c2cc2bb30da1b2bef03556f72c8dfdd363e82b20665f76d6446977b0a4` |

The generator reconstructs the geometry independently, evaluates every
outer and inner incidence fibre, records the first root-level failures, and
asserts the complete defect histograms. It also queries the local C54 raw
archive:

| external oracle artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/target/gridcap-c54` | local binary | `c2ed49a6ecf4fbba8d2c3063765eada8268453c7551e8561f3c77d18078506d7` |
| `rust/s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw` | 301,735,064 | `bee6ce230878a4da653892fb093e10cef13cee3234befd03667685657d24d274` |

Those large external artifacts are not part of this commit. Their format,
root binding, and proof-DAG trust contract are documented in
[`2026-07-09-codex-q23-bucket-certification.md`](2026-07-09-codex-q23-bucket-certification.md).
The geometric falsifier itself does not depend on archived P/N values.

The JSON is canonical sorted data. `--check` reruns the oracle query and
geometric census and requires byte equality.

## `ej` + `tt` closeout

The `ej` pass checked both logically relevant levels:

1. the archived P reply target itself has `0/118` coverage;
2. all 181 root replies after `(0,0)` fail to enter the proposed survivor.

The second check prevents an overclaim based on a merely poor P-reply
choice. The candidate is genuinely unavailable in that root opponent fibre.

The Tao-style correction is not to append another fixed shell. The closest
q23 obstruction is already an explicit three-point defect locus, which is
the smallest place a growing-rank algebraic update could begin.

No incidental discovery-track item arose.

## Mystery ledger

- **[PROVED] Are the `R_small` incidence equations field-uniform and
  projectively natural?** Yes.
- **[PROVED] Is every `R_small` edge P-sound?** Yes.
- **[SETTLED negative] Is `R_small` opponent-complete on the first q23 P
  control?** No: `0/118`.
- **[SETTLED negative] Can the q23 root answer `(0,0)` by choosing a
  different reply target inside this survivor?** No: `0/181`.
- **[SETTLED] Is the failure only one missing inner opponent?** No. The
  minimum defect is three; most fibres miss substantially more.
- **[OPEN — C80] What is the projective type of the three-point defect locus
  in the best q23 failed follower?**
- **[OPEN — C80] Does that locus admit a direct update lowering an
  unbounded/growing rank without recursive survivor membership?**
- **[OPEN — C80/C82 gate] Can a repaired growing-rank correspondence be
  proved opponent-complete and counted uniformly?**

## Vibe

The q23 gate did its job: it killed an attractive fixed shell before it
could be mistaken for the uniform theorem, while leaving a sharply localized
three-obligation successor.

go C80 cap classify the q23 minimum-defect-three locus and test a rank-carrying incidence update
