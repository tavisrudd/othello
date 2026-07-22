# C473 — arithmetic orientation of the frozen lower-Weil core

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `GREEN IN THE POINTED/FUNCTORIAL FRAMING — THE ACTUAL COXETER-MATCHING INPUT ORIENTS ONE SPLIT PRIME AND LOWER CONSTITUENT; THE COARSE UNPOINTED OUTPUT IS CANONICALLY A TORSOR, NOT A PREFERRED POINT`

## Result

For `q=7,11`, put

```text
m=(q+1)/4,       alpha=(-1+sqrt(-q))/2,
O_q=Z[alpha],    alpha^2+alpha+m=0.
```

The coefficient characteristic is `p=m`, and

```text
x^2+x+m = x(x+1) mod p.
```

Thus the two split primes are fixed without table labels as

```text
p_0  = (p,alpha),       alpha |-> 0,
p_-1 = (p,alpha+1),     alpha |-> -1.
```

The frozen simple core is oriented by the minimal polynomial of C465's literal translation
`T:x->x+1`.  The exact outcomes are

| case | field | selected prime | `alpha` residue |
|:--|:--|:--|--:|
| q=7, characteristic 2 | `Q(sqrt(-7))` | `(2,alpha+1)` | 1 |
| q=11, characteristic 3 | `Q(sqrt(-11))` | `(3,alpha)` | 0 |

This is canonical relative to the marked sheet and the fixed period generator `alpha`.  It is not
an absolute orientation after quotienting by the outer/Galois sheet swap.

There is also a basis-free recovery rule which removes even the need to label the two period
factors. If `C` is the frozen simple core and `T` is the marked unipotent, then

```text
rho_C : Z[alpha] -> F_p,       alpha |-> tr(T | C),
selected prime = ker(rho_C).
```

Indeed the core is cyclic for `T`, so the trace is the negative next-to-leading coefficient of
its minimal polynomial, exactly the recorded residue root of `alpha`. Numerically the traces are
`1` for q=7 and `0` for q=11. The independent replay checks this directly from the frozen action
matrices, not from the factor labels.

## Adversarial audit and unqualified-green framing

The earlier qualification conflated two categories. The actual C406 input is pointed by its
Coxeter-invariant matching `M`. Exact stabilizer computation gives

```text
q=7:   Stab_PGL(M) = Stab_PSL(M), order 24,
q=11:  Stab_PGL(M) = Stab_PSL(M), order 60.
```

Thus no outer sheet swap is an automorphism of the pointed input. The sheet containing `M`, its
opposite cross-sheet core, and the trace-kernel prime are all intrinsic and natural under
isomorphism. In that pointed category, C473 is unqualified green.

After forgetting `M`, a preferred point is impossible, but the right theorem remains unqualified:
there is a canonical equivariant isomorphism among the five free `C2` torsors

```text
sheets = nontrivial-unipotent classes = period factors
       = split primes = lower constituents.
```

This is an output-type correction, not an arbitrary choice. Canonicity on the coarse object means
an isomorphism of torsors; it cannot mean an outer-fixed section of a free torsor.

The alternative-input audit is sharp:

| proposed extra input | enough? | disposition |
|:--|:--:|:--|
| marked Coxeter matching | yes, minimal geometric input | its full stabilizer lies in `PSL` |
| marked sheet or unipotent square-class | yes | exactly one point of the orientation torsor |
| coordinates with `T:x->x+1` | yes, but over-rigid | contains the square-class datum |
| complex embedding / sign of `sqrt(-q)` alone | no | labels arithmetic primes, not the geometric sheet |
| Hadamard signs, minority symbols, central lift | no | certified invariant under the swap |
| unpointed orbit, output a preferred prime | no | free outer action forbids a natural section |
| unpointed orbit, output the torsor identification | yes | outer-equivariant and choice-free |

## Exact period factors

Let `Phi_q(x)=1+x+...+x^(q-1)`.  In constant-first coefficient notation its two degree-`(q-1)/2`
factors are:

```text
q=7 over F_2:
  alpha -> 1: [1,0,1,1]       = x^3+x^2+1
  alpha -> 0: [1,1,0,1]       = x^3+x+1

q=11 over F_3:
  alpha -> 0: [2,2,1,2,0,1]   = x^5+2x^3+x^2+2x+2
  alpha -> 2: [2,0,1,2,1,1]   = x^5+x^4+2x^3+x^2+2
```

For a factor `f=x^d+c_(d-1)x^(d-1)+...`, the corresponding quadratic period is
`-c_(d-1)`.  This labels each factor by the residue of `alpha` without assigning arbitrary
character-table names `a,b`.

C465's frozen core has precisely the first displayed factor in each case: residue one at q=7 and
residue zero at q=11.  Direct polynomial evaluation annihilates every core basis vector, and the
other factor does not.

## Exact intertwiners

For each case the checker chooses the first nonzero frozen-core word, in the canonical enumeration
of C465's RREF basis, whose `T`-orbit is cyclic.  If that word is `v` and
`d=(q-1)/2`, the map

```text
I : F_p[x]/(f_selected) -> S_q,
    x^i                 |-> T^i v,      0<=i<d,
```

is an exact isomorphism.  The JSON contains:

- the literal cyclic vector and all `d` rows `v,Tv,...,T^(d-1)v`;
- the selected companion matrix for `T`;
- the transported frozen matrix for inversion `S`;
- the change-of-basis matrix into C465's RREF core basis; and
- both target coordinate permutations.

The two source matrices generate groups of exact orders 168 and 660, and `I` commutes literally
with both `T` and `S`.  Combined with C465's simple-module and Brauer-character certificate, this
is an explicit frozen-basis realization of the selected lower constituent.  It does not posit an
uncertified integral Weil lattice.

## Why the sheet supplies the orientation

For every exponent `1<=a<q`, the checker recomputes the minimal polynomial of `T^a` on the core.
In both cases,

```text
a square mod q       => same period factor and same split prime,
a nonsquare mod q    => conjugate period factor and conjugate split prime.
```

The sheet-preserving group is `PSL_2(q)`, so its conjugations preserve the square-class of the
unipotent parameter.  A nonsquare projective gauge lies in the outer `PGL/PSL` coset and swaps the
two sheets.  Since `-1` is nonsquare for both `q=7,11`, inversion `T->T^-1` also swaps the primes.

The extra-juice check makes this literal rather than character-theoretic: transpose the frozen
shared-edge incidence matrix and take its simple core on the opposite sheet.  Its `T` minimal
polynomial is exactly the other factor:

```text
q=7 opposite sheet:  alpha -> 0,
q=11 opposite sheet: alpha -> -1 = 2.
```

Thus sheet exchange and prime exchange are the same exact two-point action in both controls.

The trace rule also makes the torsor additive: the two sheet traces are the two roots `r` and
`-1-r`, hence sum to `-1` in both characteristics. For every `1<=a<q`, replay computes
`tr(T^a|C)` independently and finds that it equals the residue root in the exponent table.
Thus the quadratic-character switch can be read from one modular character value, without a
cyclic-basis choice, polynomial factorization, or intertwiner.

## Normalization-change table

| change | effect on selected prime | reason |
|:--|:--|:--|
| `T -> T^a`, `a` square | fixed | same frozen unipotent class |
| `T -> T^a`, `a` nonsquare | exchanged | outer sheet swap |
| `T -> T^-1` | exchanged | `-1` is nonsquare |
| global code scalar | fixed | core and `T` action unchanged |
| Hadamard row sign | fixed | row representative only |
| minority-symbol `1/2` relabeling | fixed | projective supports and core unchanged |
| C472 central signed lift | fixed | uniform scalar; unique complement is pure |
| `alpha -> -1-alpha` | exchanged | Galois swaps the two prime ideals |
| C470 row/column outer duality | exchanged | outer action swaps sheets and unipotent classes |

Consequently the Hadamard signs, minority-symbol convention, and signed lift do not independently
orient the lower pair.  They are compatible with the orientation already carried by the marked
sheet.  Removing that marking leaves a free `C2` torsor simultaneously realized as

```text
two sheets
= two order-q unipotent classes
= two cyclotomic period factors
= two split primes
= two conjugate lower Weil constituents.
```

## q=7/q=11 boundary

The arithmetic statement is uniform, but the selected root is convention-dependent and need not
have the same numeric value in the two frozen cases: q=7 selects `-1`, while q=11 selects `0`.
That difference is an exact feature of the independently frozen B3 and H3 sheet conventions, not
a failed theorem.

C471's signed Hadamard construction is used only at q=11.  No q=7 signed matrix is inferred.
C472's central sign also supplies no extra orientation: its unique frozen complement is pure and
the scalar center acts uniformly on both composition factors.

## Certificate and reproducibility

The atomic bundle consists of:

- `notes/2026-07-22-c473-arithmetic-orientation.md`;
- `notes/2026-07-22-c473-arithmetic-orientation.py`;
- `notes/2026-07-22-c473-arithmetic-orientation-replay.py`;
- `notes/2026-07-22-c473-arithmetic-orientation.json`;
- `notes/2026-07-22-c473-arithmetic-orientation.sha256`.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c473-arithmetic-orientation.py --check
python3 notes/2026-07-22-c473-arithmetic-orientation-replay.py
sha256sum -c notes/2026-07-22-c473-arithmetic-orientation.sha256
```

The primary generator reconstructs both frozen matching sheets from C406, both core actions from
C465, factors both cyclotomic polynomials, computes every power normalization, and writes literal
intertwiners.  It hash-pins C450's period convention and C471/C472's normalization boundaries.

The independent replay imports no primary code.  It independently rebuilds both sheet actions,
checks every intertwining square, generates the two matrix groups, multiplies the two period
factors back to `Phi_q`, evaluates every selected polynomial on every core basis vector, checks all
power gauges, and reconstructs the opposite-sheet cores.

Trusted boundary: exact integer, finite-field, permutation, matching, and polynomial arithmetic
plus the hash-pinned C406/C450/C465/C471/C472 certificates.  No literature priority, integral Weil
lattice, q=7 signed-Hadamard, or Ext claim is made.

## Extra-juice closeout and mystery ledger

- **Settled — which primes are selected.** The frozen B3 core selects `(2,alpha+1)` and the frozen
  H3 core selects `(3,alpha)`, with exact companion-factor intertwiners.
- **Settled — which datum carries the orientation.** It is the marked sheet/unipotent square-class,
  not Hadamard row signs, minority symbols, or C472's central lift.
- **Settled by explicit gauge exhaustion.** Every nonzero power of `T` was checked: square powers
  preserve and nonsquare powers exchange the prime, in both cases.
- **Settled by extra juice — the opposite sheet.** The transpose shared-edge core has the conjugate
  minimal polynomial and selects the other prime literally, proving the sheet/prime torsor without
  relying on table labels.
- **Settled by further extra juice — intrinsic trace recovery.** The selected prime is exactly the
  kernel of `alpha -> tr(T|C)`. This equality was checked directly for every nonzero power of `T`
  on both cores; the two sheet traces sum to `-1`. Thus orientation is already visible in the
  modular character of the marked unipotent and does not require choosing a cyclic vector or
  naming a period factor.
- **Open only after forgetting the marking.** There is no gauge-free preferred prime under the
  outer/Galois swap.  This is a proved free `C2` torsor, not missing computational evidence.
- **No other genuine C473 mystery remains.** Prime ideals, residue maps, frozen matrices,
  intertwiners, normalization changes, and both controls pass independent replay.
