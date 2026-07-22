# C474 — exact Ext classification of the lower-Weil Lagrangian carriers

**Lane:** `crowns`

**Date:** 2026-07-22

**Verdict:** `GREEN FOR THE EXACT TWO-CASE THEOREM; NO UNIFORM q-FAMILY IS ASSERTED`

## Result

For the frozen pointed matching sheets, with `S_q` the C465 simple core and `A_q` the sheet
augmentation, exact group cohomology gives

```text
Ext^1_{F_2 PSL_2(7)}(3_epsilon^*,3_epsilon) = F_2,
Ext^1_{F_3 PSL_2(11)}(5_epsilon^*,5_epsilon) = F_3.
```

In both cases the frozen sequence

```text
0 -> S_q -> A_q -> S_q^* -> 0
```

is the nonzero class.  Moreover

```text
End(S_q)=F_p,       End(S_q^*)=F_p,
```

so `Aut(S_q) x Aut(S_q^*)` acts on the one-dimensional Ext space through the scalar ratio.
It is transitive on its nonzero elements.  Consequently each case has exactly one nonsplit
extension up to module isomorphism: one nonzero cocycle at `q=7`, and two scalar cocycles but one
endpoint-automorphism orbit at `q=11`.

C473 orients the notation without an arbitrary character-table label.  The frozen `q=7` socle is
the lower constituent selected by `(2,alpha+1)` in `Z[alpha]`, while the frozen `q=11` socle is
selected by `(3,alpha)`, where `alpha^2+alpha+(q+1)/4=0`.

## Exact cohomology calculation

Use the two frozen generators in the order `(T,S)`.  Put the augmentation basis in the canonical
form

```text
(C465 RREF basis of S_q, followed by the first C465 augmentation RREF rows that extend it).
```

The resulting row-action matrix has blocks

```text
R_g = [[V_g, 0], [C_g, W_g]].
```

Here `V_g` acts on the socle and `W_g` on the head.  For `F in Hom(S_q^*,S_q)`, use the row-module
action

```text
g.F = W_g F V_g^(-1).
```

Then

```text
z(g)=C_g V_g^(-1)
```

satisfies `z(gh)=z(g)+g.z(h)`.  The literal frozen values on `(T,S)` are

```text
q=7, F_2:
z(T) = [1 1 0]    z(S) = [0 0 0]
       [0 0 0]           [0 0 0]
       [0 0 1]           [1 1 1]

q=11, F_3:
z(T) = [1 2 0 0 0]    z(S) = [0 0 0 0 0]
       [0 0 0 2 2]           [2 1 0 1 1]
       [0 2 1 1 0]           [2 0 1 2 1]
       [0 0 0 2 2]           [0 0 0 0 0]
       [0 0 0 2 2]           [0 0 0 0 0].
```

The certificate records the values on every group element, not only on the generators, and checks
the cocycle identity on all ordered pairs.

Writing a cocycle by its two generator values gives the exact ranks

| case | cochain parameters | relation rank | `dim Z^1` | `dim B^1` | `dim H^1` | ordered-pair checks |
|:--|--:|--:|--:|--:|--:|--:|
| `q=7`, `F_2` | 18 | 8 | 10 | 9 | 1 | 28,224 |
| `q=11`, `F_3` | 50 | 24 | 26 | 25 | 1 | 435,600 |

Thus in both cases `dim Z^1=d^2+1` and `dim B^1=d^2`.  The latter equality is also the expected
one from `Hom_G(S_q^*,S_q)=0`; the exact endpoint commutant calculations give dimension one on
both simples.  Against the certificate's canonical complement to `B^1`, the frozen class has
coordinate `1` at `q=7` and `2=-1` at `q=11`, so neither extension is a coboundary.

### Extra-juice upgrade: a one-scalar splitting detector

The clean ranks permit a literal operational strengthening.  For any generator cocycle `z`, put

```text
delta(z) = <Lambda_T,z(T)> + <Lambda_S,z(S)>,
```

where the pairing is entrywise matrix dot product.  In the canonical bases above, take

```text
q=7:
Lambda_T = [0 0 0]    Lambda_S = [0 1 0]
           [1 1 0]               [0 0 0]
           [0 1 1]               [0 0 0]

q=11:
Lambda_T = [1 0 1 1 1]    Lambda_S = [0 0 1 0 0]
           [1 1 2 1 1]               [0 0 0 0 0]
           [0 0 1 0 0]               [0 0 0 0 0]
           [2 0 0 0 2]               [0 0 0 0 0]
           [0 0 0 1 1]               [0 0 0 0 0].
```

Exact linear algebra proves that `delta` annihilates every coboundary and takes value one on the
recorded `H^1` basis.  Since `H^1` is one-dimensional, this gives the sharp test

```text
the extension represented by z splits  <=>  delta(z)=0.
```

The frozen cocycles have `delta=1` at `q=7` and `delta=2=-1` at `q=11`.  Thus the full
retraction-consistency calculation compresses, after the cocycle relations are known, to one
certified field element.

There is a second rigidity consequence.  In both cases the relation rank is exactly `d^2-1`, the
coboundary rank is `d^2`, and the carrier endomorphism ring is `F_p`.  Hence the projectivized Ext
space is a single point, there are exactly two extension middle-module classes (split and
nonsplit), and

```text
Aut_G(A_7)=1,       Aut_G(A_11)=F_3^* of order 2.
```

So arithmetic orientation is needed to name the socle constituent, but no scalar, cocycle-basis,
or endpoint gauge can create a second nonsplit carrier.

## Strongest honest common theorem

Let

```text
Q = {(7,2,B3), (11,3,H3)}.
```

For every `(q,p,type)` in `Q`, take the pointed Coxeter-matching sheet, its shared-edge core `S_q`,
and its sheet augmentation `A_q` with the conventions frozen by C406, C465, and C473.  Then:

1. `p=(q+1)/4`, and `x^2+x+(q+1)/4` splits as `x(x+1)` over `F_p`;
2. the shared-edge and disjointness Grams reduce respectively to `0` and `-J`;
3. `S_q` is a simple lower-Weil module, canonically oriented by the pointed sheet;
4. `S_q` is a stable Lagrangian in the self-dual augmentation `A_q`;
5. `A_q/S_q` is `S_q^*`, and `A_q` is nonsplit; and
6. `Ext^1_{F_p PSL_2(q)}(S_q^*,S_q)` is one-dimensional, with `A_q` its unique nonzero
   extension up to module isomorphism.

This is a uniform statement over the exact two-element domain `Q`, not a theorem for arbitrary
prime powers `q`.

## Exact obstruction to a larger family claim

The common integer `m=(q+1)/4` controls the period and Gram identities, but those scalar identities
do not define a `PSL_2(q)`-set, identify simple endpoint modules, or determine a group-cohomology
dimension.  The frozen carriers come from two exceptional pointed Coxeter-matching actions only:
the task's evidence supplies no corresponding sheet, incidence pair, simple core, or extension for
any `q` outside `{7,11}`.  C471 also proves that its simple-bad-prime operator mechanism is specific
to the `q=11` Hadamard scalar; its valuation hypothesis fails for the binary order-eight analogue.

Accordingly, extrapolating the Ext conclusion from the shared polynomial and Gram formulas would
discard the load-bearing representation data.  A genuine larger-family theorem requires, for a
quantified new domain, all of the following new inputs: a uniform carrier construction, proof of
simple Lagrangian socle and dual head, and a cohomology calculation or structural argument forcing
`dim Ext^1=1`.  None is implied by `m` alone.  This is the sharp stopping point requested by the
card.

## Signed and arithmetic refinements

C472 does not alter the Ext group.  Its signed preimage over the frozen `PSL_2(11)` is the split
group `C2 x PSL_2(11)` and restricts on the six-space as the central-sign twist of `1+5_epsilon`;
the lower five-dimensional carrier and its augmentation extension remain exactly those computed
here.  C473 supplies the pointed arithmetic orientation recorded above, while proving that the
unpointed object retains only the corresponding free two-point torsor.

## Certificate and reproducibility

The atomic evidence bundle is:

- `notes/2026-07-22-c474-uniform-ext-carrier.md`;
- `notes/2026-07-22-c474-uniform-ext-carrier.py`;
- `notes/2026-07-22-c474-uniform-ext-carrier-replay.py`;
- `notes/2026-07-22-c474-uniform-ext-carrier.json`;
- `notes/2026-07-22-c474-uniform-ext-carrier.sha256`.

The checksum manifest pins the report, primary script, independent replay, and canonical JSON
certificate; their exact byte counts are recorded there by the adjacent bundle audit.

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-22-c474-uniform-ext-carrier.py --check
python3 notes/2026-07-22-c474-uniform-ext-carrier-replay.py
sha256sum -c notes/2026-07-22-c474-uniform-ext-carrier.sha256
```

Intentional regeneration is the primary command without `--check`.  It rebuilds both pointed
matching sheets from C406, reconstructs the C465 core and augmentation actions, solves the full
generator-cocycle and coboundary systems, locates the frozen block cocycle, computes both endpoint
commutants, and verifies the cocycle identity on all group-element pairs.

The independent replay imports no primary code.  Starting from C465's frozen core bases and
C473's independently recorded coordinate permutations, it reconstructs both augmentation block
actions with a separate linear-algebra implementation, rebuilds the relation systems through
canonical group words, checks the Ext dimensions and non-coboundary rank gaps, and repeats all
463,824 ordered-pair cocycle checks.

Trusted boundary: exact prime-field arithmetic, complete enumeration of groups of orders 168 and
660 from their two recorded generators, and the hash-pinned C406/C465/C471/C472/C473 certificates.
The computation proves no claim about a carrier outside the two frozen matching actions and makes
no literature novelty or priority claim.

## Extra-juice closeout and mystery ledger

- **Settled — nonsplit versus the whole Ext group.** C465's inconsistent retraction systems showed
  only that the frozen classes were nonzero.  C474 computes `Z^1/B^1` and proves that each class
  spans the entire one-dimensional Ext group.
- **Settled by explicit `ej` — cocycle versus module uniqueness.** Both endpoint endomorphism
  rings are the base field.  Hence endpoint scalars are transitive on nonzero Ext classes; the two
  nonzero `F_3` cocycles give one nonsplit module-isomorphism class, not two hidden carriers.
- **Settled by explicit `ej` — literal representatives.** The two generator matrices above and
  every group-element value are frozen in the JSON, with all ordered-pair identities checked by
  two implementations.
- **Settled by the follow-up `ej` — one-scalar obstruction.** The explicit functional `delta`
  kills every coboundary, normalizes the recorded `H^1` generator to one, and evaluates nontrivially
  on both frozen cocycles.  Splitting can therefore be decided by one field operation after the
  cocycle relations are checked.
- **Settled by the follow-up `ej` — carrier moduli collapse.** The projectivized Ext space is one
  point and `End_G(A_q)=F_p`, leaving exactly the split and unique nonsplit middle modules.  Their
  nonsplit automorphism groups have orders one and two respectively.
- **Settled — effects of C472/C473.** The signed split cover introduces no second extension class;
  the pointed trace-prime rule canonically names the socle in each case.
- **Open, with exact Phase-3 boundary — why the same rank defect occurs twice.** Both relation
  systems have rank `d^2-1`, leaving `dim Z^1=d^2+1`, but no mechanism derives this one-dimensional
  defect from `m` alone.  The evidence gap is a uniformly defined carrier and a structural
  cohomology theorem outside `{7,11}`.  The bounded Phase-3 synthesis must classify the Rosetta row
  as checked rather than family-proved.
- **No other genuine C474 mystery remains.** Ext dimensions, cocycle representatives, frozen-class
  coordinates, endpoint automorphisms, scalar orbits, and the exact larger-family obstruction are
  closed.
