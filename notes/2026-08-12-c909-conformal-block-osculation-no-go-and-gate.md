# C909 — conformal blocks versus the osculating web filtration

Date: 2026-08-12

Status: exact no-go for the proposed literal integral identification; the
unimodular osculating-web theorem remains the unique all-degree gate. No
manuscript, PDF, mirror, or Lean edit.

## Verdict

The coordinate-jet filtration on the \(q=1\) two-row Specht/web lattice is
**not literally** the ordinary finite-level Jones--Wenzl or genus-zero
\(\mathfrak{sl}_2\) conformal-block filtration over
\[
 \mathbf Z[t_1,\ldots,t_{2n},\Delta^{-1}].                  \tag{1}
\]
Those theories correctly predict the bounded-height Dyck ranks in
characteristic zero, but they do not supply the required integral
local-freeness or dyadic saturation.

The closest valid structural statement is conditional:

> An integral, configuration-dependent fusion lattice would prove the C909
> crown if it embeds the dual level-\(\ell\) conformal-block module into the
> classical web bundle with image \(\mathscr F^{n-\ell}\), and if that image
> is saturated over (1).

Constructing that lattice and proving saturation is equivalent in substance
to the universal osculating-web Fitting/Rees theorem. It is not presently a
consequence of standard conformal blocks or Temperley--Lieb theory.

## 1. What the rank coincidence really says

The genus-zero \(\mathfrak{sl}_2\) conformal block with \(2n\) fundamental
insertions at level \(\ell\) has rank
\[
 B(n,\ell)=\#\{\text{Dyck paths of semilength }n
                     \text{ with height at most }\ell\}.   \tag{2}
\]
The \(q=1\) two-row web lattice has rank \(C_n\), and the C909 candidate is
\[
 \operatorname{rank}\mathscr F^{n-\ell}=B(n,\ell).          \tag{3}
\]
Thus level and osculating depth have the expected dictionary
\[
                    \ell=n-r.                              \tag{4}
\]
This explains the Dyck numbers. It is only a rank dictionary: it gives no
map of lattices, no identification of filtrations, and no Smith statement.

## 2. First exact obstruction: the web subbundle moves

The ordinary Temperley--Lieb/Jones--Wenzl level filtration is a
configuration-independent construction in the diagram lattice. By contrast,
the coordinate-jet filtration is a moving subbundle.

Already at \(n=2\), write
\[
 A=[12][34],\qquad B=[14][23].
\]
The first osculating kernel is
\[
 \mathscr F^1
 =\mathcal O_{\mathscr C_4}
  \bigl(\delta_{14}\delta_{23}A-\delta_{12}\delta_{34}B\bigr). \tag{5}
\]
The coefficient ratio in (5) is a nonconstant function of the marked
configuration. Hence \(\mathscr F^1\) cannot equal the scalar extension of
any fixed Jones--Wenzl submodule of \(W_2\).

It could only be compared with a conformal-block object after a
configuration-dependent gauge, for example one built from coinvariants,
KZ/Gaudin transport, or a universal Plucker map. Such a gauge is itself the
missing mathematical construction.

## 3. Second exact obstruction: Jones--Wenzl is not integral at two

At \(q=1\), the two-strand Jones--Wenzl projector in the Temperley--Lieb
algebra with loop value \(2\) is
\[
                         f_2=1-\tfrac12e_1.                 \tag{6}
\]
It is not an element of \(\operatorname{TL}_2(\mathbf Z)\). More generally,
\(f_{\ell+1}\) has denominators at primes at most \(\ell+1\). Therefore the
standard relation \(f_{\ell+1}=0\) defining the finite-level quotient is not
a relation over (1), and it cannot prove a theorem at \(p=2\).

Clearing denominators changes the integral problem. For instance the
numerator \(2f_2=2-e_1\) reduces to \(e_1\) modulo two; it does not retain
the characteristic-zero projector relation. A proof based on the numerator
must separately establish saturation of its image or quotient. That
saturation is precisely what C909 needs and cannot be assumed from the
Jones--Wenzl recursion.

This is a no-go for the proposed *proof mechanism*, not a counterexample to
the C909 filtration: the line in (5) is primitive even at two because its
two displayed coefficients are units on \(\mathscr C_4\).

## 4. Conformal-block level is also not the needed integral object

Finite-level WZW conformal blocks are governed by the root-of-unity fusion
parameter and by the level shift \(\ell+2\). Their standard
Temperley--Lieb realization is therefore not the \(q=1\) classical web
lattice. Over characteristic zero this causes no rank problem: both sides
are indexed by the same bounded-height paths. Integrally it is decisive:
the root-of-unity and KZ normalizations introduce precisely the primes which
the C909 theorem must retain, notably two.

Consequently, an equality of ranks in (2)--(3), or an abstract
identification after tensoring with \(\mathbf Q\), does not imply local
freeness of \(\mathscr F^r/\mathscr F^{r+1}\) over (1).

## 5. The exact remaining theorem

The theorem that would recover the useful part of the conformal-block
picture is:

> **Integral osculating-fusion theorem.** There are locally free
> configuration-dependent lattices \(\mathscr C_{n,\ell}\) and saturated
> injections
> \[
> \mathscr C_{n,\ell}^{\vee}\hookrightarrow\mathscr W_n,
> \qquad
> \operatorname{im}=\mathscr F^{n-\ell},
> \]
> over (1), with a path basis indexed by Dyck paths of height at most
> \(\ell\), compatible under \(\ell\mapsto\ell-1\).

This statement is equivalent to the unimodular osculating-web theorem:
the injections make every graded quotient locally free of exact
Dyck-height rank; conversely those saturated quotients define the lattices.
It is the correct way to make the conformal-block analogy theorem-grade.

The integral proof must be built from the coordinatewise Plucker jets,
not imported from root-of-unity projectors. A plausible route is an
integral Gaudin/coinvariant gauge followed by a coefficient-one
standard-monomial Rees degeneration. Until that gauge is constructed and
shown saturated, the result remains an exact gate.

## Mystery ledger

The ej+tt pass settles the apparent shortcut: conformal blocks explain the
Catalan/Dyck shape but do not close the dyadic Smith theorem. The live
mystery is sharply localized to an integral, configuration-dependent
fusion/coinvariant lattice; it is no longer reasonable to seek a proof from
the ordinary Jones--Wenzl quotient alone.
