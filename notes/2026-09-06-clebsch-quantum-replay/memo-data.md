# Data transcribed from the "Clebsch → quantum" memo (4 Sept 2026)

Conventions: p in {7,11}, n=2p, k=p-1. E is n x k over F_p with rows x_i^T.
First p rows have sign +1, last p rows sign -1; eps = (1^p, (-1)^p), D=diag(eps).
L = {a*1 + E u}. G = (1^T ; E^T) is p x n. Claims: rank G = p; G D G^T = 0;
L^{o2} (span of coordinatewise products of pairs in L) = eps^perp, dim 2p-1.
CSS code: S_X = <1>, S_Z = L^perp = D L, H_Z = G D. Parameters [[2p, p-1, 2]]_p.
Classical min distance of L (and of L^perp): 6 for p=7, 8 for p=11.
Logical cubic: F(u) = sum_i eps_i (x_i^T u)^3 (polynomial in u_0..u_{k-1}).

## E_7 (14 x 6), coefficient order X^2, XY, XZ, Y^2, YZ, Z^2
```
 3  5  0  0  3  2
 0  0  0  0  0  0
 6  4  6  5  3  6
 2  4  0  0  2  3
 1  0  6  5  2  5
 5  5  6  5  0  1
 4  3  3  6  4  4
 3  5  0  5  0  0
 0  0  0  5  2  3
 6  4  6  3  2  5
 2  4  0  5  3  2
 1  0  6  3  0  1
 5  5  6  3  3  6
 4  3  3  4  4  4
```

## E_11 (22 x 10), coefficient order X^4, X^3Y, X^3Z, X^2YZ, X^2Z^2, XY^2Z, XYZ^2, XZ^3, YZ^3, Z^4
```
 0  0  0  0  0  0  0  0  0  0
 6  8  3  4  9  6 10  6  6  5
 8  5  4  1  0  0  4  2  1  9
 9 10  2  7  0  0 10  4  6  8
 3  1  1  2  0  0  7  7  3  7
10  1  9  2  9  6  0 10  0  2
 4 10  8  7  9  6  4  8  1  4
 5  5  6  1  9  6  7  3  3  6
 7  8  7  4  0  0  9  1 10  3
 2  0 10  0  9  6  9  9 10 10
 1  7  5  5 10  3  6  5  4  1
 0  0  0  0  0  1  9  1 10  3
 6  8  3  4  9  7  9  9 10 10
 8  5  4  1  0  1  7  7  3  7
 9 10  2  7  0  1  4  2  1  9
 3  1  1  2  0  1  0  0  0  0
10  1  9  2  9  7  7  3  3  6
 4 10  8  7  9  7 10  6  6  5
 5  5  6  1  9  7  4  8  1  4
 7  8  7  4  0  1 10  4  6  8
 2  0 10  0  9  7  0 10  0  2
 1  7  5  5 10  4  6  5  4  1
```

## Claimed raw phase polynomials (coefficients mod p, in raw coordinates u_0..u_{k-1})
B1 (p=7):
F_7 = 6 u0u2u5 + 4 u0u3u5 + 4 u0u4^2 + 4 u1^2u5 + 3 u1u2u4 + 3 u1u3u4 + 2 u2^2u3 + u2u3^2 + u3^3

B2 (p=11):
F_11 = 4 u0u4u9 + 7 u0u5u9 + 3 u0u6u8 + 5 u0u7^2
     + 3 u1u3u9 + 9 u1u4u8 + 8 u1u5u8 + 4 u1u6u7
     + 5 u2^2u9 + 4 u2u3u8 + 3 u2u4u7 + 5 u2u5u7 + 9 u2u6^2
     + 9 u3^2u7 + 5 u3u4u6 + 8 u3u5u6 + 3 u4^2u5 + 4 u4u5^2 + 5 u5^3

## Claimed normal forms
p=7: substitute u = (a, b, s+c, 3s+c, d, e). Then
F_7 = 4 s I + 3 J,  I = a e - 4 b d + 3 c^2,
J = a c e + 2 b c d - a d^2 - b^2 e - c^3 = det [[a,b,c],[b,c,d],[c,d,e]].

p=11: substitute u = (z0, z1, 7 z2, 6 z3, 3 s + 6 z4, s + 3 z4, 6 z5, 7 z6, z7, z8). Then
F_11 = 4 s I2 + 2 I3,
I2 = 2 z0z8 + 6 z1z7 + z2z6 + 9 z3z5 + 4 z4^2,
I3 = 6 z0z4z8 + 9 z0z5z7 + 7 z0z6^2 + 9 z1z3z8 + 6 z1z4z7 + 7 z1z5z6
   + 7 z2^2z8 + 7 z2z3z7 + z2z5^2 + z3^2z6 + 4 z3z4z5 + 2 z4^3.
Also claimed: with f(S,T) = sum_{i=0}^8 binom(8,i) z_i S^{8-i} T^i and normalized transvectants
(f,g)_r = ((m-r)!(n-r)!/(m! n!)) sum_{j=0}^r (-1)^j binom(r,j) d^r f/dS^{r-j}dT^j * d^r g/dS^j dT^{r-j},
I2 = (f,f)_8 and I3 = ((f,f)_4, f)_8 (mod 11).

## Other claimed exact facts
- Symmetric trilinear form T(v,w,z) = sum_i eps_i v_i w_i z_i on L has radical exactly <1>.
- Centroid of T (matrices A on F_p^k with T(Au,v,w)=T(u,Av,w)=T(u,v,Aw)) is scalars; the
  defining linear system on the k^2 entries of A has rank 35 (p=7) and 99 (p=11).
- Rank-one exclusion: no nonzero v in F_p^k with rank(Hessian of F at v) = 1.
  (p=7 certificate: Hessian entries H00, H55 vanish identically; p=11: H00,H11,H88,H99 vanish identically.)
- Ordinary weight enumerator of L (= that of L^perp) for p=7: A_0=1, A_6=378, A_7=516, A_8=6468,
  A_9=25284, A_10=74382, A_11=154644, A_12=247842, A_13=218064, A_14=95964 (total 7^7).
  For p=11: A_8=1100, A_10=41800, A_11=157320, A_12=2436940, A_13=17133600, A_14=112941400,
  A_15=595194160, A_16=2622117190, A_17=9214830020, A_18=25660748300, A_19=53955314600,
  A_20=80976004780, A_21=77104831760, A_22=35049917640 (total 11^11), A_9=0 and A_w=0 for 1<=w<=7.
- Witness words in ker G: p=7 support (0,1,2,4,7,13) values (2,2,5,5,6,1);
  p=11 support (0,1,2,3,4,9,17,20) values (2,2,9,9,2,9,10,1).
- Reconstruction recipe: conic Q = XZ - Y^2, points a -> (1:a:a^2), inf -> (0:0:1);
  secant factors L_ab = ab X - (a+b) Y + Z, L_a,inf = a X - Y; base matchings
  M_7 = {{0,2},{1,4},{3,inf},{5,6}}, M_11 = {{0,1},{2,5},{3,7},{4,9},{6,8},{10,inf}};
  enumerate PGL_2(p) orbit of the base matching (size 2p), sheet sign = square class of det of a
  transformation carrying base matching to it; x_M = (P_M - P_{M_base})/Q with P_M = prod of L_ab
  over pairs in M; take coefficient vectors in the stated monomial order; sort positive sheet first.
