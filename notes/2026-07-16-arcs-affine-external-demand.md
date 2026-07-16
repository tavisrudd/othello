# Arcs: affine line-hole significance check

## Finding

The arbitrary prescribed-hole theorem has an established specialization that
the manuscript previously did not advertise. If the hole set is a line at
infinity, `CompleteOutside A L∞` is exactly maximality of `A` as an arc in the
affine plane obtained by deleting that line.

The connection is not merely terminological. Giulietti--Montanucci study
hyperfocused arcs, whose secants meet a distinguished external line in a small
focus set, in connection with Simmons's geometry-based secret-sharing scheme:

- M. Giulietti and E. Montanucci, *On hyperfocused arcs in PG(2,q)*,
  Discrete Mathematics 306 (2006), 3307--3314,
  doi:10.1016/j.disc.2006.06.009, arXiv:math/0601488.

Korchmáros--Szőnyi's survey states explicitly that some of those constructions
are complete in the sense that every point off the distinguished line belongs
to a chord of the arc (survey p. 30, lines 529--531 in the checked extraction):

- G. Korchmáros and T. Szőnyi, *Affinely regular polygons in an affine plane*,
  Contributions to Discrete Mathematics 3(1) (2008), 20--38,
  doi:10.55016/ojs/cdm.v3i1.62767.

The survey also records the secret-sharing origin of focused arcs and the
subsequent hyperfocused/generalized-hyperfocused literature. This supports the
narrow manuscript claim that the line-hole instance belongs to an existing
research line. It does not show that the conic parameter itself was previously
asked for, and the manuscript does not claim that.

## Mathematical specialization

For a line `L∞` disjoint from a `k`-arc, every secant meets `L∞` exactly once,
so

```text
I_L∞(A) = choose(k,2).
```

Substitution into the general prescribed-hole inequality gives

```text
q²-k ≤ choose(k,2)(q-1)
       - 6/floor(k/2) choose(k,4)
       - 1/floor(k/2) choose(k,2).
```

The general zero-defect theorem gives the equality pattern at both affine and
ideal points. `RelativeConicArcs/Affine.lean` kernel-checks the equivalence,
incidence identity, integral bound, and equality criterion.
