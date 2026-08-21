# Module 58. Separable primitive projectors cannot remove wall-fixed leakage

**Packet part:** Module 58. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the tensor no-go theorem below is proved. It shows that a
primitive-character projector acting only on a cubic/base factor cannot make
Module 57's eigenrow law true if the wall/window factor contains a
rank-visible fixed vector. Thus the naive external-product realization of
the primitive phase cannot instantiate Module 56. This is a conditional
no-go for a separable receiver, not a refutation of the actual projected
variation or of a coupled/moving-quotient receiver.

## 58.1 Tensor fixed-leakage theorem

Let \(R\) be a domain. Let \(U,W\) be \(R\)-modules with rows

\[
                   p:U\to R,\qquad s:W\to R,                 \tag{58.1}
\]

and let \(M\in\operatorname{End}_R(W)\). On
\(V=U\otimes_R W\), set

\[
        T=1_U\otimes M,qquad r=p\otimes s.                  \tag{58.2}
\]

### Theorem 58.1 -- separable-projector no-go

Suppose there are \(u_0\in U\) and \(w_0\in W\) such that

\[
        p(u_0)\ne0,qquad Mw_0=w_0,qquad s(w_0)\ne0.         \tag{58.3}
\]

Then for no nonzero \(a\in R\) and unit \(q\in R^\times\) does

\[
                         r(1-T)=a q\,r                       \tag{58.4}
\]

hold.

#### Proof

The vector \(u_0\otimes w_0\) is fixed by \(T\), while

\[
             r(u_0\otimes w_0)=p(u_0)s(w_0)\ne0
\]

because \(R\) is a domain. Corollary 57.1A now contradicts (58.4).
\(\square\)

### Corollary 58.1A -- a projector on the base factor does not help

Let \(E\in\operatorname{End}_R(U)\) be an idempotent commuting with the
base operations, and replace \(U\) by \(E(U)\). If \(p|_{E(U)}\ne0\), the
same fixed \(w_0\) still obstructs (58.4) on

\[
                         E(U)\otimes_R W.                     \tag{58.5}
\]

In particular, if the primitive-sixth projector is typed as
\(E_{\zeta_6}\otimes1_W\), it cannot kill wall-fixed leakage in \(W\).
The primitive row remains nonzero on the base factor by the source
nonvanishing certificate, and generic rank is nonzero on every character
line in the common window.

This is the precise limit of saying that the primitive character comes from
the cubic factor. Such a separable marking retains the entire multiplicity
space of the wall/window factor.

## 58.2 The common-window pilot fails separably

In Module 43's common-window \(K\)-theory receiver, every character line has
generic rank one:

\[
                          s(e^\lambda)=1.                     \tag{58.6}
\]

Spenko--Van den Bergh, Proposition 12.6, fixes every common window
generator. Therefore, whenever an adjacent pair has a common generator
\(e^\lambda\), it supplies \(w_0=e^\lambda\) in Theorem 58.1.

Consequently the following package is impossible:

\[
 \left(E_{\zeta_6}U\right)\otimes W_{\rm full},
 \quad T=1\otimes M_{\rm wall},
 \quad r=p_{\zeta_6}\otimes\operatorname{rk},                \tag{58.7}
\]

provided \(p_{\zeta_6}\ne0\) and the two windows really share a generator.
No resonant limit, Stokes normalization, or unit rescaling repairs this
algebraic failure.

The last common-generator hypothesis is occurrence data. Proposition 12.6
describes what happens **if** a generator lies in the window intersection;
it does not say that every adjacent pair has a nonempty intersection. For
the five completed unit pilots this must be checked from the actual window
lattice, not inferred from the wall formula.

## 58.3 What can still work

The theorem leaves three genuinely different source shapes.

1. **Moving quotient.** Replace \(W_{\rm full}\) by a quotient on which the
   common fixed span is killed, and prove that the wall defect has a single
   positive-order eigenvalue there. This is Module 57's intended repair.
2. **Coupled projector.** Use an idempotent on \(U\otimes W\) which is not
   \(E_U\otimes1_W\), and prove directly that its image contains no
   row-visible fixed vector. The coupling is load-bearing, not a change of
   notation.
3. **Direct projected row.** Abandon the common eigenrow factor and prove
   Module 54's directed covector vanishing by a support, purity, or central-
   charge argument. This may still use Yu--Zhang after constructing an
   independent pure constructible morphism.

The moving quotient is cheapest if it is canonical. It need not preserve
the full QDM or full Stokes matrix; it need only carry the actual image
packet, divided row, and exact closed reader consumed by Module 56.

## 58.4 Upstream type consequence

The producer API must distinguish

\[
\begin{aligned}
 &\mathsf{SeparablePhase}(E_U,W),\\
 &\mathsf{MovingPhase}(E_U,W/K_{\rm fixed}),\\
 &\mathsf{CoupledPhase}(E_{U\otimes W}).                       \tag{58.8}
\end{aligned}
\]

There is deliberately no coercion

\[
       \mathsf{SeparablePhase}\longrightarrow
       \mathsf{EigenrowLaw}.                                  \tag{58.9}
\]

`MovingPhase` can reach `EigenrowLaw` only with proofs that the quotient is
operation-stable, kills the complete row-visible fixed span, has a uniform
positive-order moving eigenvalue, and is identified with the actual packet.
`CoupledPhase` requires the corresponding direct kernel/eigenrow proofs.

This makes the most tempting source-level mistake unrepresentable: attaching
a primitive label to the cubic factor cannot silently certify the wall
multiplicity factor.

## 58.5 Hostile tests

1. \(U=W=R\), \(p=s=1\), and \(M=1\) already refute (58.4).
2. Let \(W=Rw_{\rm mov}\oplus Rw_{\rm fix}\), with
   \((1-M)w_{\rm mov}=a w_{\rm mov}\) and
   \(Mw_{\rm fix}=w_{\rm fix}\), and let \(s\) be nonzero on both basis
   vectors. The moving line passes the
   eigenrow test; the full space fails it.
3. Projecting \(U\) to any nonzero primitive line leaves the second example
   unchanged on the \(W\)-factor.
4. A coupled projector whose image is
   \(U_{\zeta_6}\otimes Rw_{\rm mov}\) passes. This confirms that the theorem
   forbids separability, not projection itself.

## 58.6 Source audit

- Module 43, Proposition 43.1 and (43.5), supplies generic-rank one on every
  character line of a common window.
- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  [arXiv:2007.04924](https://arxiv.org/abs/2007.04924), Proposition 12.6,
  fixes generators lying in the adjacent-window intersection and gives the
  moved-generator formula. It does not identify the cubic primitive phase.
- Module 47 explicitly leaves the occurrence-level primitive-phase adapter
  open. Therefore (58.7) is a tested separable candidate, not an attributed
  theorem about the actual QDM occurrence.

## 58.7 EJ/TT and mystery ledger

**EJ.** The fixed-summand obstruction commutes with every projector on the
other tensor factor. This rules out an entire class of apparently natural
primitive markings at once, not merely one basis choice.

**TT.** Before computing any resonance arc, enumerate the actual window
intersection. If it is nonempty, the separable route is dead. Then ask for
the canonical moving quotient and test whether all of its generators have
one defect eigenvalue; do not try to normalize the full receiver.

| question | status | evidence or remaining gate |
|---|---|---|
| Can a base-only primitive projector kill window-fixed leakage? | **no** | Theorem 58.1 and Corollary 58.1A |
| Does generic rank see a common character generator? | **yes** | Module 43, (43.5) |
| Do all five unit pilots have a common adjacent-window generator? | **open finite window enumeration** | actual \(L_{C_-}\cap L_{C_+}\) |
| Is the actual primitive occurrence separable as in (58.7)? | **open and not assumed** | Module 47 item 4 |
| Can a moving or coupled phase still satisfy Module 57? | **yes in principle** | Section 58.3; occurrence proof missing |
| Does this refute Module 54 projected vanishing? | **no** | it refutes only the separable eigenrow implementation |

## Boundary

The naive source construction “primitive cubic projector tensor full wall
window” cannot close Module 56 in the presence of one common rank-visible
window generator. The next finite calculation is the adjacent-window
intersection for the five completed unit pilots. A nonempty intersection
eliminates the separable route and forces either the moving quotient, a
coupled projector, or a direct projected-row theorem.
