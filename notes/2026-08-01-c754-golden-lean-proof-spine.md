# C754 Golden Lean proof-spine formalization

## Scope

The formalization is staged by mathematical dependency rather than manuscript
order.  Its first kernel-checked layer consists of the five noncrossing
matching cubics and their affine covariance and collision vanishing.  Exact
Jacobian-minor identities follow as a separate algebraic layer.  Pfaffian
evaluation and corank-one adjugate factorization are reusable structural
layers.  Specht-module equality, saturation, and Luna-slice descent remain
outside the initial kernel boundary unless separately formalized from explicit
hypotheses.

## Initial acceptance gate

The first module must compile independently with `guarded-lean`, contain no
workflow references, and prove affine covariance plus representative
three-plus-three vanishing over a general commutative ring.
