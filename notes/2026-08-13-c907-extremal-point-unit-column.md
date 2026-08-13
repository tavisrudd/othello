# C907 — extremal point unit column

Date: 2026-08-13

Status: exact overlap lemma.  At zero ambient Novikov degree, the intrinsic
large-radius Gamma point section of a blow-up has no exceptional-degree tail.
It therefore belongs simultaneously to the large-radius and exceptional-cusp
solution completions, and Iritani's initial matrix sends it to the ambient
point with zero center coordinates.  This proves the unit column required by
the Gold constancy attack without transporting a normalization across an
inverted variable.

## Lemma

Let

\[
 p:\widetilde Y=\operatorname{Bl}_Z Y\longrightarrow Y
 \tag{1}
\]

be a smooth blow-up, let `E` be its exceptional divisor, and choose a closed
point `y` outside `Z`, with inverse image `\widetilde y` outside `E`.  Set every
non-exceptional Novikov variable to zero, retaining only the exceptional line
variable `q`.

Then the intrinsic large-radius Gamma flat section of
`O_{\widetilde y}` has no positive exceptional-degree correction.  Under
Iritani's Laurent-cusp decomposition at this specialization,

\[
 \Psi\bigl(s^{\mathrm{LR}}_{\widetilde Y}
 (\mathcal O_{\widetilde y})\bigr)
 =s^{\mathrm{LR}}_Y(\mathcal O_y)\oplus0.
 \tag{2}
\]

In particular its ambient large-radius coordinate is the unit point column.

## Proof

Every stable map of positive exceptional degree has curve class `d[L]` and
is contained in `E`: its composition with `p` has degree zero and its image is
the center point over which its exceptional line lies.  In the descendant
fundamental solution, insertion of `O_{\widetilde y}` forces the corresponding
evaluation map to meet `\widetilde y`.  This is impossible because
`\widetilde y` is disjoint from `E`.  Hence every positive-degree coefficient
in the point column vanishes.

The degree-zero Gamma factors do not change the top class.  Multiplication by
the positive-degree part of `Gamma_{\widetilde Y}`, by `z^{c_1}`, or by a
positive-degree mirror shift annihilates the top class.  Up to the common
dimension-dependent scalar convention, the point section is therefore the
classical top-degree section and is independent of `q`.

This finiteness is the key completion statement: a `q`-independent section
belongs both to the large-radius `q`-adic solution completion and to
Iritani's `q^{-1/s}` Laurent-cusp completion.

Now take `c_i=p^*[pt_Y]` in Iritani's formula (5.44).  Since `y` is outside
`Z`,

\[
 i_Z^*[pt_Y]=0.
 \tag{3}
\]

Every ambient correction and every center Fourier component in (5.44) is
linear in this restriction.  Thus

\[
 \Psi^\circ([pt_{\widetilde Y}])=([pt_Y],0).
 \tag{4}
\]

The reconstruction mirror shifts have positive cohomological degree and
again fix the top class.  Combining the no-tail statement with (4) proves
(2).

## Why this is not the false point-covector theorem

For nonzero ambient curve degree, mixed stable maps can carry arbitrarily
many exceptional bubbles.  Their point column can have unbounded positive
powers of `q`, so it need not belong to the Laurent-cusp solution ring.  No
identity between the two normalized frames follows there.

The present lemma evaluates a `Q`-constant comparison datum at the single
specialization where the point section has finite exceptional support.  The
remaining constancy lemma must still justify that this datum, rather than the
whole point section, is independent of the ambient Novikov variables.

## AA / EJ / TT

- **AA:** evaluate only after all non-exceptional curve variables are zero;
  geometric avoidance then removes the entire exceptional descendant tail.
- **EJ:** turn on one ambient curve class.  Mixed curves with arbitrarily many
  exceptional bubbles return, and the overlap argument immediately stops.
- **TT:** the legal overlap is section-specific and specialization-specific.
  It cannot be promoted to a continuous homomorphism between the two full
  solution completions.

## Source

H. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, formula
(5.44) and Section 5.8.2.  Shared-cache SHA-256 prefix recorded in the source
audit: `c16f56`.
