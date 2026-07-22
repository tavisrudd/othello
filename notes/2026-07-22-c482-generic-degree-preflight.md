# C482 preflight — generic degree and differential rank

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** exact obstruction found; C482 target corrected before execution.

## Result

Let `X_r` be the moduli space of a labelled six-arc in `P2` together with `r` labelled projection
centres, modulo `PGL_3`, on the open locus where every centre avoids every secant.  Let

```text
Phi_r : X_r --> (M_0,6)^r
```

record the `r` coherently labelled projected sextics.  Quotienting by one diagonal `S6` does not
change any dimension below.  The source and target dimensions are

```text
dim X_r = 2(6+r)-8 = 4+2r,       dim (M_0,6)^r = 3r.       (1)
```

Consequently two and three abstract projected sextics cannot reconstruct the parent-centre
configuration, even generically:

| centres `r` | source dimension | target dimension | generic fibre lower bound |
|---:|---:|---:|---:|
| 1 | 6 | 3 | 3 |
| 2 | 8 | 6 | 2 |
| 3 | 10 | 9 | 1 |
| 4 | 12 | 12 | 0 |

Calling the centres "known ambient points" does not remove this obstruction.  Three generic
labelled centres can be normalized by `PGL_3`, but their common stabilizer has dimension two; six
free parent points modulo that stabilizer again have dimension `12-2=10`, against nine projection
coordinates.  Four generic labelled centres form a projective frame with finite stabilizer, giving
the square `12`-by-`12` case.

The exact dual-number certificate
[`2026-07-22-c482-generic-degree-preflight.py`](2026-07-22-c482-generic-degree-preflight.py)
finds maximal-rank Jacobian witnesses on the six-arc/deep-centre open locus:

```text
                 r=1  r=2  r=3  r=4
F_101              3    6    9   12
F_256, char 2      3    6    9   12.                    (2)
```

Thus the lower bounds in (1) are exact at the certified generic points.  In particular:

> `Phi_2` and `Phi_3` have positive-dimensional generic fibres, of dimensions two and one at the
> certified generic points.  They have no finite generic degree.  Four centres are the first
> dimensionally possible pure projection-reconstruction input.

The characteristic-two rank-nine witness also rules out inseparability as the explanation for
the three-centre failure: the three-centre map is separable onto its nine-dimensional image at
that point, but its source has one further dimension.  The rank-twelve four-centre witness shows
that a separable generically finite four-centre theorem is viable in characteristic two.  The
`F_101` witnesses imply the analogous statement in characteristic zero and characteristic 101.
They do not by themselves prove maximal rank in every odd characteristic; C482 must either give
an integral minor cover or list the exceptional characteristics.

## Coordinates and replay

On the dense chart used by the certificate, normalize the first four parent points to

```text
h1=(1,0,0), h2=(0,1,0), h3=(0,0,1), h4=(1,1,1),
h5=(1,a,b), h6=(1,c,d),
```

and write each centre as `u_s=(1,e_s,f_s)`.  This gives exactly `4+2r` source variables.  For
each centre, the script sends projected points `h1,h2,h3` to `infinity,0,1` and records the images
of `h4,h5,h6`.  Its three coordinates are determinant cross-ratios, hence are precisely a chart
on labelled `M_0,6`.  Differentiation is performed in the first-order dual-number algebra over
the stated exact finite field; no finite differences or floating-point ranks occur.  Before a
witness is accepted, all parent triple determinants and all centre-secants determinants are
checked nonzero.

Replay:

```bash
python3 notes/2026-07-22-c482-generic-degree-preflight.py --check
```

## Why C478 still has three-fibre recovery

C478 did not study `Phi_3` on the unrestricted algebraic moduli space.  It fixed an entire finite
child `L=U(A)` as a literal point configuration in one ambient plane and compared a finite fibre
of parents above that child.  The unused points and incidence geometry of `L` remain side
information even when only two or three atlas fibres are selected.  That side information can cut
the one-dimensional generic `Phi_3` fibre to a finite set, and it does so in all four frozen
controls.

Therefore the two statements are compatible:

```text
three abstract coherent projections alone:     generically insufficient;
three selected fibres relative to a fixed L:   sufficient in the frozen finite controls.
```

Any all-field theorem must say which input it retains.  It may prove pure reconstruction from
four abstract projections, or a child-relative theorem from three selected fibres plus the full
ambient child.  It may not infer the former from C478's evidence for the latter.

## Consequences for the task ladder

1. C481 remains unchanged: one atlas is one projected sextic.
2. C482 must prove the exact two- and three-centre residual dimensions and target a four-centre
   rational inverse on an explicit open locus.
3. C483 must distinguish the four-centre reconstruction discriminant from the additional
   child-relative equations that can make three centres sufficient.
4. C485 must state pure and child-relative reconstruction as separate clauses.

This correction increases the odds of a correct generic theorem while lowering the odds of the
previous strongest three-projection formulation to zero.
