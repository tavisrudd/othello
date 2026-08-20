# Module 28. What Iritani's blowup theorem does not yet type

**Packet part:** Module 28.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** source theorem re-audited; the missing tensor-operation
realization and exact threshold-graph criterion isolated; no \(m=2\) theorem

## 28.1 Source and exact scope

Primary source:
Hiroshi Iritani, *Quantum cohomology of blowups*,
[arXiv:2307.13555](https://arxiv.org/abs/2307.13555).

The audited local copy is:

- cache key: arXiv:2307.13555;
- SHA-256:
  c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b;
- 69 pages; and
- full-text extraction:
  /tmp/persistent/tavis/lit-search/text/arXiv_2307.13555.txt.

Theorem 5.18 gives, after the stated formal Laurent base changes and
coordinate maps, an isomorphism

\[
\Psi:
QDM(\widetilde Y)^{\mathrm{la}}
\xrightarrow{\sim}
\tau^*QDM(Y)^{\mathrm{la}}
\oplus
\bigoplus_{j=0}^{c-2}\varsigma_j^*QDM(Z)^{\mathrm{la}}.
\tag{28.1}
\]

The theorem states that \(\Psi\):

1. commutes with the quantum connection;
2. intertwines the Poincaré pairings;
3. has the stated degree behavior;
4. satisfies explicit large-\(q\) asymptotics;
5. preserves homogeneity/Euler data through the coordinate maps; and
6. has the stated invertible Jacobian.

These are precisely the formal QDM facts consumed by the verified
\(m=1\) proof.

## 28.2 The missing operation law

The higher-stabilization source uses an additional nilpotent operation
\(N\), for example the proposed line-bundle/loop operation

\[
N_L=1-\tau_L.
\tag{28.2}
\]

Theorem 5.18 does not state that (28.1) intertwines this operation, a
Gamma/integral-structure row, tensor-by-line-bundle on \(K\)-theory, or an
Orlov exact-heart realization.

Connection compatibility must not be silently promoted to any of these
statements.  The retained \(N\) needs its own naturality theorem.

### Theorem 28.1 -- threshold equivariance is already sufficient

Let

\[
\Psi:(V_{\widetilde Y},N_{\widetilde Y})
\xrightarrow{\sim}
(V_Y,N_Y)\oplus(E,N_E)
\tag{28.3}
\]

be a linear isomorphism of the underlying finite-dimensional spaces, each
equipped with the displayed nilpotent endomorphism.  If

\[
\Psi N_{\widetilde Y}^m
=(N_Y^m\oplus N_E^m)\Psi
\tag{28.4}
\]

and \(N_E^m=0\), then projection through \(\Psi\) gives a canonical
\(K\)-linear isomorphism

\[
\operatorname{Top}_m(V_{\widetilde Y})
\xrightarrow{\sim}
\operatorname{Top}_m(V_Y).
\tag{28.5}
\]

#### Proof

Equation (28.4) and \(N_E^m=0\) identify
\(\Psi N_{\widetilde Y}^m\) with
\((N_Y^m\oplus0)\Psi\).

Taking images gives (28.5).  \(\square\)

Full operator equivariance implies (28.4), but is not necessary.  Threshold
equivariance need not make (28.5) an isomorphism of \(K[N]\)-modules:
commutation with \(N^m\) does not imply commutation with \(N\) on its image.
The linear conclusion is exactly enough for the rank or Boolean top
consumer.  Full equivariance supplies the stronger module isomorphism.

### Corollary 28.1A -- the exact projection/graph criterion

Put

\[
\widehat N=\Psi N_{\widetilde Y}\Psi^{-1},
\qquad
S_m=\operatorname{im}(\widehat N^m)
\subset V_Y\oplus E,
\tag{28.5a}
\]

and assume \(N_E^m=0\).  Projection through \(\Psi\) transports the
\(K\)-linear top image exactly when

\[
p_Y(S_m)=\operatorname{Top}_m(V_Y),
\qquad
S_m\cap(0\oplus E)=0.
\tag{28.5b}
\]

Equivalently, \(S_m\) is the graph of a unique linear map

\[
g_m:\operatorname{Top}_m(V_Y)\longrightarrow E.
\tag{28.5c}
\]

This is immediate from the kernel and image of
\(p_Y|_{S_m}\).  Theorem 28.1 is the stronger special case \(g_m=0\).
For a \(K[N]\)-module isomorphism, one must additionally type compatible
\(N\)-actions and prove that this projection intertwines them.

## 28.3 Two geometric routes, now separated

### Route A -- formal operator-equivariance

Upgrade (28.1) by proving the single commutator law

\[
\Psi N_L=(N_{L,Y}\oplus N_{L,E})\Psi
\tag{28.6}
\]

for the actual occurrence-specialized operator, together with
\(N_{L,E}^m=0\).

If (28.6) holds, Theorem 28.1 supplies strict top-image transport.  No
analytic heart, opposite exact sequence, or Hom-orthogonality theorem is
needed.

The load-bearing question is whether \(N_L\) is defined naturally on the
formal Laurent QDM comparison and whether its exceptional action has the
required exponent.  Projection formula on algebraic \(K_0\) components is
evidence for investigating (28.6), not a proof of its cyclotomic QDM
realization.

In the current C907/C925 line-bundle framing, \(\tau_L\) means tensoring by
\(L\) on rational \(K_0\), not parallel transport around a loop.  Therefore
the present Route A needs a cyclotomic realization compatible with the
integral/tensor action, or a separately proved QDM-intrinsic avatar of that
action.  Horizontality of (28.1) alone does not supply it.

### Proposition 28.2 -- an alternative typed-loop specialization

Let \(f:S\to S'\) be a coordinate map, let \(V,V'\) be flat bundles on
\(S,S'\), and let \(\Psi:V\to f^*V'\) be horizontal.  If a based loop
\(\gamma\) in \(S\) is carried by \(f\) to a based loop \(\gamma'\) in
\(S'\), up to a specified endpoint-fixed homotopy, then parallel transport
satisfies

\[
\Psi\,T_\gamma=T_{\gamma'}\,\Psi.
\tag{28.6a}
\]

Consequently, if \(\tau_L\) is this monodromy action and
\(N_L=1-\tau_L\), equation (28.6) follows with the target operation defined
by the mapped loop.

This is ordinary naturality of parallel transport for a horizontal bundle
map.  The specified path map is load-bearing.  On a ramified comparison, a
one-turn lifted path may end on a different sheet and is not yet a based
loop.  One must instead work with a closed loop on a common cover, or supply
a deck-equivariant endpoint identification in the pushforward local system.

Moreover, a nontrivial deck permutation has a semisimple part, so
\(1-T_\gamma\) need not be nilpotent.  To recover a nilpotent operation one
must first pass to a preserved generalized character sector and normalize,
for example \(N_\chi=1-\chi^{-1}T_\gamma\), or take the logarithm of the
unipotent part.  The character-sector preservation and exponent are
additional typed fields.  Proposition 28.2 is therefore a lawful alternate
specialization, not a proof of the current tensor-by-\(L\) provider.

### Route B -- analytic oriented heart

Construct the Module 26/27 data:

1. an analytic operation-framed abelian heart;
2. an actual opposite-oriented short exact QDM sequence;
3. component and kernel stability;
4. exact \(N\)-compatible realization;
5. lawful endpoint reindexing; and
6. the actual exceptional exponent.

Then Theorems 26.1, 27.1, and 27.2 give transport.

Route B is more flexible because it permits harmless nonsplit rich data, but
it asks for substantially more analytic structure.

## 28.4 What Remark 1.5 supplies

Remark 1.5 distinguishes the formal theorem from an analytic/Stokes lift.
It says that an analytification is expected.  It further reports that for
toric blowups studied in earlier work, the Stokes structure does not
orthogonally decompose; rather, its semiorthogonal decomposition corresponds
to Orlov's.

This has two consequences.

1. The arbitrary-blowup analytic heart required by Route B is not a theorem
   of the cited blowup paper.
2. Toric blowups are a useful calibration for the orientation/component
   story, but their scope does not include arbitrary cubic-threefold
   centers.

Even in the toric calibration, an analytic semiorthogonal decomposition is
not automatically the opposite heart-exact sequence required by Module 26.
The heart, orientation, \(N\)-compatibility, and kernel stability must still
be checked.

## 28.5 Source sufficiency and augmentation

The cubic/product source side is sufficient for the endpoint contradiction:

\[
(\chi,N,N^{m+1}=0,N^mV\ne0)
\]

plus diagonal-product compatibility computes the nonzero source top line.

No additional point/Gamma **row** is consumed by the ExactTop endpoint
consumer.  But the bare formal QDM comparison is not yet provider-sufficient:
because the present \(\tau_L\) is tensor-by-\(L\) on \(K_0\), the comparison
must be augmented by exactly the operation framing which realizes that
action.  A Gamma/integral realization compatible with tensoring is one
possible provider; a separately constructed intrinsic QDM automorphism is
another.  This is a comparison-side realization field, not a new source
marker.  Adding an unrelated mark without proving its naturality square does
not address the gap.

The rank-row route remains a genuinely different specialization because its
point/Gamma row is itself the retained quotient.

## 28.6 Highest-EV next calculation

For the current line-bundle route, first construct the missing realization
square between tensor-by-\(L\) on \(K_0\) and its cyclotomic QDM operation.
Proposition 28.2 supplies a separate experiment only if one deliberately
replaces this operation by normalized monodromy on a typed character sector.

For the actual comparison, transport the source operator to
\(V_Y\oplus E\),

\[
\widehat N_L=\Psi N_{L,\widetilde Y}\Psi^{-1},
\tag{28.6b}
\]

and compute both its threshold image \(S_m=\operatorname{im}\widehat
N_L^m\) and the stricter commutator

\[
\Delta_L
:=
\Psi N_{L,\widetilde Y}
-(N_{L,Y}\oplus N_{L,E})\Psi
\tag{28.7}
\]

for the codimension-two blowup pilot.  More economically, compute the
threshold defect

\[
\Delta_{L,m}
:=
\Psi N_{L,\widetilde Y}^m
-(N_{L,Y}\oplus N_{L,E})^m\Psi.
\tag{28.8}
\]

Writing \(N'=N_{L,Y}\oplus N_{L,E}\), one has

\[
\Delta_{L,m}
=\sum_{j=0}^{m-1}
(N')^{m-1-j}\Delta_LN_{L,\widetilde Y}^{j},
\qquad
\Delta_{L,2}=N'\Delta_L+\Delta_LN_{L,\widetilde Y}.
\tag{28.9}
\]

Thus the \(m=2\) defect has the same two-term algebraic shape as the
cross-composite isolated by Module 25.  It becomes that Bockstein
cross-term only when the transported operator is triangular and supplies
the corresponding \(K[N]\)-exact sequence.

Assume separately the carrier certificate \(N_{L,E}^2=0\).  There are five
decisive outcomes:

1. **\(\Delta_L=0\):** Route A becomes the shortest \(m=2\) transport
   candidate.
2. **\(\Delta_L\ne0\) but \(\Delta_{L,2}=0\):** Theorem 28.1 still gives
   strict \(K\)-linear \(m=2\) transport.
3. **\(\Delta_{L,2}\ne0\), but
   \(S_2=\operatorname{Top}_2(V_Y)\oplus0\):** strict image transport still
   holds; map-level threshold equivariance was stronger than necessary.
4. **strict image equality fails, but (28.5b) holds:** \(S_2\) is a harmless
   graph over \(\operatorname{Top}_2(V_Y)\), and projection still transports
   the rank/Boolean consumer.
5. **(28.5b) fails:** this comparison/operator pair fails the projection
   form of ExactTop.

The Module 25 boundary refines outcomes 4--5 only after the exceptional
certificate \(N_{L,E}^2=0\) and one of the exact triangular forms

\[
\widehat N_L=
\begin{pmatrix}N_Y&0\\ \delta&N_E\end{pmatrix}
\quad(0\to E\to V_{\widetilde Y}\to V_Y\to0),
\qquad
\widehat N_L=
\begin{pmatrix}N_Y&\delta\\0&N_E\end{pmatrix}
\quad(0\to V_Y\to V_{\widetilde Y}\to E\to0)
\tag{28.10}
\]

has been proved.  These equations include the correct restriction and
quotient operators, not merely stability of an unnamed summand.  In the
opposite orientation, a zero boundary permits the nonzero harmless graph of
outcome 4; in the first orientation it forces the retained image into the
ambient subobject.  Without either triangular form there is no typed
Bockstein to invoke.

This calculation must use the actual specialized comparison, not the
formal direct-sum shape alone.

## 28.7 Finite calibration

The shared categorical replay is exact at seventy-seven checks.  Four bounded
matrix calibrations distinguish the laws used here:

1. two threshold maps may differ while having the same image;
2. an isomorphism may commute with \(N^2\) but not with \(N\);
3. an opposite-oriented zero-leakage top may be a non-horizontal graph; and
4. threshold equivariance alone need not preserve the residual \(N\)-action
   on the top image.

These checks validate only the linear-algebra separations.  They do not
construct the cyclotomic tensor realization, compute Iritani's actual
\(\widehat N_L\), or prove the exceptional exponent.

## 28.8 Mystery ledger

| question | status | exact evidence or gate |
|---|---|---|
| Does Iritani give a formal direct sum? | **settled: yes** | Theorem 5.18 |
| Does that theorem intertwine the retained \(N_L\)? | **open/not stated** | prove (28.6) separately |
| Is map-level threshold equivariance necessary? | **settled: no** | exact linear consumer is the projection/graph criterion (28.5b) |
| Is strict image equality necessary? | **settled: no** | a harmless graph occurs in the opposite orientation |
| When is the Module 25 boundary defined? | **settled formally** | only after one of the typed triangular forms (28.10), with the named diagonal operators |
| Does it supply a Gamma/integral row comparison? | **settled: no in the theorem statement** | separate realization theorem required |
| Does it supply an arbitrary-blowup analytic Orlov heart? | **settled: no** | Remark 1.5 states expectation and cites toric scope |
| Is another ExactTop source augmentation needed? | **settled: no** | the missing datum is operation naturality |
| Which route is currently cheapest? | **settled provisionally** | realize tensor-by-\(L\), then compute \(\widehat N_L\) and (28.5b) before building Route B |
| Does the exceptional term satisfy \(N_E^2=0\)? | **open** | independent carrier theorem |
| Can connection compatibility imply \(N_L\)-compatibility? | **conditional yes** | Proposition 28.2, after an actual typed loop map; not for an unproved integral tensor action |

## Boundary

Theorem 28.1 is proved.  The source audit shows that the current primary
theorem does not instantiate either higher-stabilization provider without a
new operation-equivariance or analytic-realization result.  No manuscript
or Lean source is edited, and no unconditional \(m=2\) or
stable-irrationality claim is made.
