# Reed--Solomon reconstruction import into the arcs and Clebsch papers

## Verdict

C485 contains one compact theorem that strengthens the arcs paper without changing its proof or
verification architecture:

> For six-arcs in `PG(2,q)`, `q>=16`, equality of the literal uncovered loci forces equality of
> the unlabelled parent arcs.

The closeout pass shows that the proof is uniform: for `k>=3`, equality of the literal uncovered
loci determines the unlabelled parent whenever `q+1>choose(k,2)`. It first recovers all secant
lines from their union and then recovers the vertices as the points incident with `k-1` secants;
a nonvertex lies on at most `floor(k/2)` secants. This is proof-only and introduces no
computational claim. The arcs manuscript now states and proves the general result as
`prop:arc-reconstruction`, records it in the proof audit, and registers it as
`thm-uncovered-parent-reconstruction`.

The Clebsch manuscript uses the result only as a conclusion-level comparison. The large-field
theorem reconstructs a literal unlabelled parent from equality of the complete uncovered locus.
The Clebsch theorem is a distinct small-field statement: at `q=11`, conic containment of the
deep-hole locus determines the projective Clebsch class and its `A5` stabilizer. The manuscript now
states this difference explicitly instead of treating both as the same kind of reconstruction.

## Deliberate non-import

C490 proves the sharper bounded statement that the fixed `q=11` conic child has 22 literal parents
and that every triple of coherent projected-sextic signatures separates them. That result is not
imported into the Clebsch manuscript. It depends on a separate finite classification and replay
bundle and would create a certificate-heavy second reconstruction spine beside the selected
Clebsch rigidity spine. It is better reserved for a Reed--Solomon reconstruction paper or a later
explicitly scoped companion theorem.

Likewise, C485's four-view Gale double cover, Kummer/Artin--Schreier descent, and rank-one radical
marker are not needed for either current manuscript claim. They remain valuable adjacent results,
but integrating them here would blur the distinction between:

1. recovery from the literal complete child;
2. recovery from abstract coherent projections; and
3. projective-class rigidity from conic containment.

## Claim boundary

The imported proposition:

- assumes equality of the full literal sets `U(A)=U(B)`, not equality of cardinalities or sampled
  syndrome directions;
- recovers unlabelled point sets, not column labels;
- applies to fixed-size `k`-arcs under the explicit inequality `q+1>choose(k,2)` (hence to
  six-arcs for `q>=16`); and
- makes no claim about higher redundancy or the general Reed--Solomon deep-hole conjecture.

## Extra-juice closeout

The generalized proof gives two free upgrades.

First, it is algorithmic. If `S=PG(2,q)\U(A)` and `N=choose(k,2)`, then the parent secants are
exactly the lines containing more than `N` points of `S`; the vertices are exactly the points
incident with `k-1` recovered secants. Equivariance then gives

```text
Stab_PGammaL(U(A)) = Stab_PGammaL(A).
```

Thus above the threshold the deepest-syndrome locus recovers both the unlabelled parent and its
full projective-semilinear code automorphism group.

Second, the strict inequality is best possible in general. At `(q,k)=(5,4)`,
`q+1=choose(k,2)=6`, and the projective frame has a conic as its literal uncovered locus. The
conic stabilizer has order `|PGL(2,5)|=120`, while a projective-frame stabilizer has order 24.
Consequently at least five distinct literal frames have that same conic child. This explains why
the line-union proof cannot be repaired at equality without additional data.

## Mystery ledger

- **Settled — is reconstruction merely existential?** No. The high-incidence lines give a
  canonical recovery algorithm, followed by a canonical vertex multiplicity test.
- **Settled — does the locus remember symmetry?** Yes above the threshold: its full semilinear
  stabilizer is exactly the parent's.
- **Settled — is the strict threshold an artefact of the proof?** No in general. The `q=5`
  frame/conic fibre is an equality-boundary collision with multiple literal parents.
- **Open outside this import — what replaces the threshold below it?** C490 shows that coherent
  projected-sextic signatures can separate recoverable small-field fibres, but importing that
  certificate-backed theory remains a distinct manuscript decision.
