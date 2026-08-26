# C969 structural canonicalization complexity

**Status:** implemented and regression-checked.

Let `r=n+1`, let `q=p^d`, and write one syndrome as a nonzero divided-power
binary form of degree `n`. This note counts the current reference algorithm;
it does not hide full PGL enumeration inside an orbit primitive.

## Transport bound

The lex charts partition every form by maximal rational-root multiplicity.

| stratum | exact retained transports |
|---|---:|
| rootless | `d(q^2-1)` |
| simple root, nondegenerate successor | at most `d n q` |
| simple root, characteristic-two zero successor | at most `d n q(q-1)` |
| multiple root, nondegenerate successor | at most `d n q` |
| multiple root, Lucas-zero successor | at most `d n q(q-1)` |
| pure power | at most `d n` |

The `n` factor is only the elementary bound on the number of distinct rational
roots. Pre-chart root discovery adds at most two passes over `P^1(F_q)`.
Consequently every request with `r>=5` and `q>=r` has an exact canonical form
and replayable transporter after `O(d r q^2)` retained transports and `O(q)`
root probes. The explicit `d(q^3-q)` enumerator is a defensive oracle, not a
generic-form stratum.

This theorem is structural. It does not extend the R5--R10 covering-radius or
deep-hole theorem domain.

## Cost of one transport

Put `X=beta+alpha*x` and `Y=delta+gamma*x`. The symmetric-power action needs
the rows

```text
R_i = X^i Y^(n-i),  0 <= i <= n.
```

The implementation constructs `R_0=Y^n`, then uses the exact recurrence

```text
R_(i+1) = (R_i / Y) X.
```

Division by the known nonzero linear factor and multiplication by `X` each
take linear work in the current degree. Building all rows and pairing them
with the syndrome therefore costs `O(r^2)` field operations, replacing the
former independent-power `O(r^3)` evaluator. Frobenius and projective
normalization add `O(r log q)` field multiplications in this reference backend.
Thus one transport costs

```text
O(r^2 + r log q)  operations in F_q.
```

The recurrence is checked against the former direct power-row definition for
every semilinear element over the q=7 and GF(8) regression fixtures.

## Reference-backend word accounting

In the polynomial-basis backend, addition uses `O(d)` base-prime coefficient
operations and schoolbook multiplication/reduction uses `O(d^2)`. Excluding
one-time field/modulus validation, the conservative end-to-end bound is

```text
O((d r q^2 + q) (r^2 + r log q) d^2)
```

base-prime coefficient operations. This is a word-operation bound for the
crate's `u32` field representation, not a claim about asymptotically fast
finite-field arithmetic. Degenerate affine stabilizers are streamed, so the
reduced charts use `O(r+q)` transient storage, including the `q+1` projective
root rows. Only the defensive explicit oracle materializes `Theta(q^3)`
normalized matrices.

## Frozen checks

- all 781 projective q=5/R5 binary forms agree with full PGL minima and replay
  their returned transporters;
- a slow release-mode oracle checks all 4,681 projective GF(8)/R5 binary forms,
  including characteristic-two successor degenerations, against full
  semilinear minima without reaching the defensive fallback; it also confirms
  the Lucas consequence that this degree-four divided-power space has no
  rootless stratum because fourth power is an automorphism of `F_8`;
- a second slow oracle checks all 7,381 projective GF(9)/R5 forms against full
  semilinear minima, covering the characteristic-three Lucas-degenerate wild
  orbit in its complete ambient projective space;
- the GF(9)/R5 Lucas-degenerate wild form uses 144 transports and agrees with
  all 1,440 semilinear transports;
- q=13/R11--R13 tangent, sigma, and multiple-root forms agree with full PGL;
- the slow GF(16)/R11 regression agrees with all 16,320 semilinear transports.
- GF(16)/R16 exercises the full-length `r=q` boundary and replays its reduced
  transporter without entering explicit enumeration.
- GF(32)/R17 freezes the general Frobenius/Lucas fact that binary degree
  `n=p^a` has no rootless divided-power stratum at redundancy `r=p^a+1`.
