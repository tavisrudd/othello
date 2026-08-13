# C907 relative-fibre cutoff no-go

**Lane:** `clebsch`

**Status:** exact negative theorem.  Replacing the absolute support mechanism
by a quotient that kills objects of relative fibre dimension at most two
cannot construct Silver's packet: it trivializes the base hyperplane and
therefore kills the endpoint (J_3) itself.

## The general theorem

Let (S=\mathbf P^2), let (X) be a smooth connected projective (d)-fold, and suppose
that a line bundle (H) on (X) has three linearly independent sections
(s_0,s_1,s_2).  Put (Y=X\times S), with projection (f:Y\to S), and let

\[
 \mathcal A_{<d}(Y/S)
 =\left\langle A\in\operatorname{Perf}(Y):
   \dim\operatorname{Supp}(A)_q\le d-1\text{ for every }q\in S
  \right\rangle_{\mathrm{thick}}.
\]

This is a thick tensor ideal.  In the monoidal Verdier quotient

\[
 \mathsf Q_d(Y/S)=\operatorname{Perf}(Y)/\mathcal A_{<d}(Y/S),
 \tag{1}
\]

the pullback (f^*\mathcal O_S(1)) is isomorphic to the tensor unit.
Consequently tensor by (f^*\mathcal O_S(1)) is naturally equivalent to the
identity and

\[
 N_L=1-\tau_{f^*\mathcal O(1)}=0
 \tag{2}
\]

in every additive realization of (1).

## Proof

Choose a nonzero section (s_0\in H^0(X,H)).  Its pullback cuts a divisor
(D_0\subset Y) whose fibres have dimension at most (d-1).  Hence the cone
of

\[
 \mathcal O_Y(-H,0)\xrightarrow{s_0}\mathcal O_Y
\]

belongs to \(\mathcal A_{<d}(Y/S)\), and therefore

\[
 \mathcal O_Y(-H,0)\simeq\mathcal O_Y
 \quad\text{in }\mathsf Q_d(Y/S).
 \tag{3}
\]

With homogeneous coordinates (q_0,q_1,q_2) on (S), the section

\[
 s=q_0s_0+q_1s_1+q_2s_2
 \in H^0(Y,H\boxtimes\mathcal O_S(1))
\]

is nonzero on every fibre: otherwise a nonzero linear combination of the
three (s_i) would be the zero global section.  Its zero scheme (D_1) thus
also has fibre dimension at most (d-1).  The same cone argument gives

\[
 \mathcal O_Y(-H,-1)\simeq\mathcal O_Y.
 \tag{4}
\]

Tensoring (4) with the inverse of (3) yields

\[
 f^*\mathcal O_S(-1)=\mathcal O_Y(0,-1)\simeq\mathcal O_Y,
\]

which proves (2).

The argument is object-level.  It is stronger than observing a collapse in
rational (K_0): the two divisor cones make the base line bundle itself
isomorphic to the unit in the quotient.

## Silver consequence

Take (X) to be a smooth cubic threefold and (H=\mathcal O_X(1)).  The
endpoint operator required by Silver is

\[
 1-\tau_{\operatorname{pr}_2^*\mathcal O_{\mathbf P^2}(1)}
\]

on the primitive-sixth cubic line tensored with the three Tate levels of
(\mathbf P^2); it must be one block (J_3).  The quotient (1) instead makes
this operator zero.  Therefore no packet functor factoring through the
relative-fibre cutoff can satisfy the endpoint normalization, regardless of
which cyclotomic coefficient is applied afterward.

For the calibration (X=\mathbf P^3), write
(u=[\mathcal O(-1,0)]), (v=[\mathcal O(0,-1)]).  The same two divisors give
(1-u) and (1-uv) in the killed subgroup; tensor closure then also gives
(1-v).  In fact the image on (K_0) is the full rank-zero ideal and the
quotient (K_0) is only \(\mathbf Z\).  The object
(\mathcal O_{\mathbf P^3\times\{q\}}) survives the Verdier quotient but its
(K_0)-class ((1-v)^2) is zero.  This distinction is another reason not to
infer the required nilpotent from quotient (K_0).

## Correct design boundary

The absolute support-square theorem does not make this mistake.  It retains
horizontal divisors and the three endpoint Tate levels.  Only after applying
(N_L^2) does it ask the resulting exceptional support
(E\cap f^{-1}(q)) to vanish, now by its **absolute** dimension at most two.

Thus the positive construction must keep the full coniveau filtration and
its extension data.  It may kill the primitive-sixth coefficient of an
absolute surface after the point-kernel action, but it cannot quotient out
all relative surface fibres before that action.  In slogan form:

> kill the coefficient at the terminal support grade, not the support grade
> that carries the hyperplane extension.

## AA / EJ / TT and mystery ledger

- **AA:** the tempting base-relative quotient is closed negatively.  The
  surviving routes are a full filtered coniveau coefficient, or a direct
  support-compatible formal-monodromy operator which retains every grade and
  proves the point-kernel square only after realization.
- **EJ:** the obstruction is universal for every fibre carrying three
  independent sections; it is not a pathology of the linear-projection
  model.  It rules out a whole class of apparently well-calibrated relative
  localizations.
- **TT:** the same horizontal divisors used to simplify the source also
  trivialize the base hyperplane.  A quotient has forgotten the extension
  data before asking whether the extension is cyclotomic.
- **Settled:** object-level failure of every relative-fibre cutoff of the
  form (1), including the cubic endpoint.
- **Open:** construct a filtered, support-compatible primitive-sixth
  coefficient without passing to this quotient; prove that formal monodromy
  and the base-hyperplane tensor action commute on that filtered realization.
