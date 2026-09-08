# A three-dimensional locus of cubic threefolds of exact stabilization level two

Research note, 8 September 2026.

## Status and inputs

The deductions below assume the main theorems of the two supplied manuscripts:

1. A smooth complex cubic threefold remains irrational after multiplication by P^1.
2. If S is a smooth quartic del Pezzo surface over a characteristic-zero field K, S(K) is nonempty, and Pic(S over an algebraic closure) is stably permutation, then S x P^2 is K-rational.

The additional imported lattice input is that the standard quartic-del-Pezzo Picard lattice restricted to the type-I3 subgroup of W(D5) is stably permutation. This is Proposition 4.1 and Lemma 4.2 of Tschinkel--Zhang, arXiv:2608.20029v2; the four-generator presentation used below appears in their Proposition 5.3.

This is a proposed proof building on those results, not an independent certification of them. The accompanying SymPy program verifies the finite algebra, not the imported geometric theorems. No claim of exhaustive literature novelty is made.

## 1. The family

Let k be any field of characteristic zero and B(x,y) a binary cubic. Set

    X_B : (z-x)u^2 + 6yuv + 3(z+x)v^2 - z^3
          + (3/4)(x^2+3y^2)z + B(x,y) = 0

in P^4 with coordinates [u:v:x:z:y].

**Claim.** Every smooth member has stabilization level exactly two over k, and after every field extension of k.

### A quartic-del-Pezzo presentation

Project to [x:y], and set

    K = k(a),  a=x/y,  A=a^2+3,  beta=B(a,1).

The generic cubic surface is

    w[-au^2+6uv+3av^2+beta w^2]
      + z[u^2+3v^2+(3/4)Aw^2-z^2] = 0.

It is birational to the intersection S of the two quadrics

    Q1 = -au^2+6uv+3av^2+beta w^2-zh,
    Q2 = u^2+3v^2+(3/4)Aw^2-z^2+wh

in P^4_[u:v:w:z:h]. Indeed, w Q1 + z Q2 is the displayed cubic, and on w != 0 the second quadric recovers h uniquely. S contains [0:0:0:0:1].

Write

    c(t) = t^3-(3/4)At-beta.

The determinant of the symmetric matrix for Q1+t Q2 is

    (3/4)(t^2-A)c(t).

Its five roots are distinct over an algebraic closure of K. To see this, note that

    disc(c) = (27/16)A^3-27 beta^2,
    c(s)c(-s) = beta^2-A^3/16,  where s^2=A.

Neither expression is zero in K: A=a^2+3 is not a square in k(a), so A^3 cannot be a square. The quadratic factor also has distinct roots. A regular pencil of quadrics with squarefree determinant defines a smooth intersection of two quadrics. Thus S is a smooth quartic del Pezzo surface. This argument does not require a generic-smoothness assertion for the hyperplane pencil.

### Galois action on the components

The conic bundle on the cubic surface has affine equation

    (t-a)u^2 + 6uv + 3(t+a)v^2 = c(t).

The determinant of its binary quadratic part is 3(t^2-A). Let rho_1,rho_2,rho_3 be the roots of c, and choose cyclic differences

    d_1=rho_2-rho_3, d_2=rho_3-rho_1, d_3=rho_1-rho_2.

The coefficient relations of c give

    d_i^2 = 3(A-rho_i^2).

Consequently, the singular conic over rho_i splits over the cubic splitting field, with component equations

    (rho_i-a)u + (3 +/- d_i)v = 0.

For the two remaining singular conics choose

    e_+^2=(s-a)c(s),
    e_-^2=(-s-a)c(-s).

Their components have equations

    (s-a)u+3v= +/- e_+ w,
    (-s-a)u+3v= +/- e_- w.

The product identity is

    e_+^2 e_-^2 = disc(c)/9 = (d_1 d_2 d_3)^2/9.

Choose labels so that e_+ e_-=d_1 d_2 d_3/3. Label the five pairs by the three rho_i and then s,-s. Let c_i denote exchange of the two members of pair i. Every Galois element acts through the group

    H = <(4 5), c_4 c_5, (1 2 3), c_1 c_2 c_3 c_5 (2 3)>.

For an even permutation of the cubic roots, the d_i merely permute; for an odd permutation, all three d_i acquire a minus sign. The product relation forces the corresponding parity of sign changes on e_+,e_-. Independently, s can be exchanged with -s, exchanging pairs four and five. These possibilities are exactly contained in H.

This argument proves containment even when the cubic polynomial becomes reducible or the splitting fields have extra intersections. Full generic Galois group is unnecessary. The group H has order 24 and is conjugate to type I3 in W(D5), as identified by Tschinkel--Zhang. The stable-permutation Picard lattice for H remains stably permutation upon restriction to any subgroup.

### Rationality and the lower bound

The point on S and its stable-permutation Picard lattice permit application of the second input theorem:

    S x P^2 is K-rational.

Since k(X_B)=K(S), it follows that

    k(X_B)(r_1,r_2) is purely transcendental of degree five over k.

Thus X_B x P^2 is k-rational. For smooth X_B, the first input theorem rules out rationality of X_B x P^1. Over an arbitrary characteristic-zero field, a hypothetical rationalization, its inverse, and the coefficients of X_B descend to a finitely generated subfield, which embeds in C. The same reasoning applies after any extension of k.

## 2. Three genuine moduli parameters

Take

    B=lambda x^3+mu x^2 y+nu y^3.

The point (lambda,mu,nu)=(0,0,1) gives a smooth cubic F_0. The exact checker computes the homogeneous Jacobian ideal of F_0 and verifies that each of u^6,v^6,x^6,z^6,y^6 lies in it. Its common zero is therefore only the affine origin, proving projective smoothness.

The vector space of cubics in five variables has dimension 35. The tangent space to the GL_5 orbit of F_0 is spanned by the 25 cubics x_i partial_j F_0. Their coefficient matrix has rank 25. Adjoining the three coefficient vectors of

    x^3, x^2 y, y^3

raises its rank to 28. These therefore give three independent tangent directions in cubic moduli. For reference, their remainders in the Jacobian ring under the checker's monomial order are

    x^3   -> 2 x z^2,
    x^2 y -> -3y^3-(4/3)y^2z+2yz^2,
    y^3   -> y^3.

Hence the smooth parameter locus maps generically finitely to a three-dimensional unirational locus in complex cubic-threefold moduli.

The closure of this image inside smooth cubic moduli also consists of varieties with level two. Apply specialization of geometric rationality to X x P^2 on a local family covering the relevant moduli locus; the generic geometric point is rational after this stabilization, so every smooth specialization is rational after it as well. The uniform cubic lower bound gives equality. This uses Nicaise--Ottem, arXiv:2004.08161v3, Theorem 4.1.1, rather than an assertion that an arbitrary rationality locus is Zariski closed.

## 3. Genus-two geometry and a nonzero 3-torsion class

Set q=x^2+3y^2. On the open locus where the sextic is squarefree, let

    C_B : eta^2=16 B(x,y)^2-q(x,y)^3

in weighted P(1,1,3). This is a smooth genus-two curve. It comes with the identity

    (eta-4B)(eta+4B)=-q^3.

Let D be the degree-two divisor supported above the roots of q on the sheet eta=4B, and let H be a fiber of the hyperelliptic map. At each point of D, eta-4B has a zero of order three. After choosing a base coordinate with poles along H, this gives

    div((eta-4B)/y^3)=3D-3H.

Therefore tau=[D-H] is a rational 3-torsion point of Jac(C_B). It is nonzero: the two points of D lie over different points of P^1, whereas the effective divisors linearly equivalent to H are exactly the hyperelliptic fibers. Smoothness of C_B ensures that q and B have no common root, so the two sheets are distinct at the roots of q.

The same three parameters vary C_B in all three genus-two moduli directions. At B=y^3, its binary sextic is

    -x^6-9x^4y^2-27x^2y^4-11y^6.

It is squarefree. The GL_2 orbit tangent in the seven-dimensional space of sextics has rank four; adjoining the three derivatives

    32x^3y^3, 32x^2y^4, 32y^6

raises the rank to seven. Thus the parameter family dominates genus-two moduli generically finitely. On a common dense open it supplies a generically finite correspondence between the sharp cubic locus and genus-two moduli, with a selected nonzero 3-torsion point.

This does NOT identify a Jacobian factor of the cubic's intermediate Jacobian, prove that the selected genus-two data is intrinsic to the unmarked cubic, or determine the degree of either moduli map. Those are meaningful follow-on problems. The rank computation alone does not prove that either moduli map is birational.

The cubic family has the visible involution [u:v:x:z:y] -> [-u:-v:x:z:y]. The literature on non-Eckardt involutions and Prym period maps is directly relevant: Casalaina-Martin--Marquand--Zhang, arXiv:2210.14397.

## 4. A three-dimensional family of sharp torus-linearization examples

For each complex X in this locus write K=C(X) and choose

    K(u_1,u_2) = C(t_1,...,t_5).

Scaling u_1,u_2 defines a rational action of T=G_m^2 on A^5. Its invariant field is K. After adding m variables on which T acts trivially, the invariant field is K(s_1,...,s_m).

Any linear split-torus action has a rational invariant field. Thus this action cannot become birationally linear before m=2. At m=2 the invariant field is rational and the two remaining variables have the two independent diagonal weights, so it is linearizable. Its exact trivial-stabilization linearization level is two.

For a primitive rank-one subtorus with weights (a,b), the invariant field is K(u_1^b/u_2^a). Its exact stabilization level is one, so every rank-one restricted action requires exactly one added trivial variable to linearize. For a finite subgroup of T, the invariant monomial lattice still has rank two, giving a rational field K(r_1,r_2).

Distinct cubic isomorphism classes give nonconjugate rank-two subgroups of Cr_5: conjugacy would identify the invariant fields, and smooth complex cubic threefolds are birational if and only if isomorphic. A primary statement of the latter is Kuznetsov, arXiv:math/0303037v1, Remark 2.19. After adjoining two trivial variables all these rank-two subgroups become conjugate to the same diagonal subgroup of Cr_7.

These are rational actions, not assertions about regular polynomial actions on affine space. Existence of nonlinearizable rank-two tori in Cr_5 and general stable-linearization results are already due to Popov; see arXiv:1110.2410v4. The added information here is the moduli family together with exact stabilization thresholds.

## 5. Two limitations on searches for higher stabilization depth

For finite levels s_X=ell(X), s_Y=ell(Y), with n_X=dim X and n_Y=dim Y,

    ell(X x Y) <= min(max(s_X,s_Y-n_X), max(s_Y,s_X-n_Y)).

For the first bound, add m=max(s_X,s_Y-n_X) variables, rationalize X with them, and then rationalize Y with the n_X+m resulting rational variables. Interchanging X and Y gives the other bound. In particular ell(X^r)<=ell(X): taking powers cannot amplify the depth.

Also suppose an abelian-group-valued invariant J has the blowup formula

    J(Bl_Z Y)=J(Y)+(codim(Z,Y)-1)J(Z)

and is birationally invariant on smooth projective varieties of dimension n+2. Blowing up X x P^2 along X x {p}, a codimension-two center, gives J(X)=0 for every smooth projective n-fold X. Consequently a global invariant with this formal architecture cannot detect such X after two stabilizations. This does not rule out nonadditive or marked constructions.
