# Independent replay of the Clebsch -> quantum memo (4 Sept 2026)

All work done in `clebsch-replay/`. `common.py` holds the transcribed data;
`checkN.py` are the replay scripts. Arithmetic is exact integer arithmetic
mod p (no floating point except in check 8).

Format: CLAIM | STATUS | evidence

## 1. Linear algebra of E, G, L

- p=7 rank G = 7 | VERIFIED | check1.py: rank over F_7 of the 7x14 matrix (1^T;E^T) is 7
- p=11 rank G = 11 | VERIFIED | check1.py: rank over F_11 of the 11x22 matrix is 11
- p=7 G D G^T = 0 mod 7 | VERIFIED | all 49 entries zero
- p=11 G D G^T = 0 mod 11 | VERIFIED | all 121 entries zero
- p=7 rows of E distinct | VERIFIED | 14 distinct rows of 14
- p=11 rows of E distinct | VERIFIED | 22 distinct rows of 22
- p=7 dim L^{o2} = 13 = 2p-1 and L^{o2} = eps^perp | VERIFIED | rank of the 28 pairwise
  coordinatewise products of a basis of L is 13; every product is killed by eps,
  and dim eps^perp = 13, so the inclusion is an equality
- p=11 dim L^{o2} = 21 = 2p-1 and L^{o2} = eps^perp | VERIFIED | rank of the 66 pairwise
  products is 21; all lie in eps^perp (dim 21)

## 2. Raw phase polynomials B1, B2

- p=7 F_7 = sum_i eps_i (x_i.u)^3 equals the claimed B1 | VERIFIED | check2.py:
  independent sympy expansion of the 14 cubes, reduced mod 7, has exactly the 9
  claimed monomials with exactly the claimed coefficients
- p=11 F_11 equals the claimed B2 | VERIFIED | check2.py: independent expansion of the
  22 cubes mod 11 has exactly the 19 claimed monomials with the claimed coefficients

## 3. Normal forms and transvectants

- p=7 substitution u = (a,b,s+c,3s+c,d,e) gives F_7 = 4 s I + 3 J | VERIFIED |
  check3.py, coefficient-by-coefficient equality mod 7 in F_7[a,b,c,d,e,s]
- J equals det [[a,b,c],[b,c,d],[c,d,e]] | VERIFIED | symbolic determinant equals the
  stated expansion a c e + 2 b c d - a d^2 - b^2 e - c^3 over Z
- p=11 substitution u = (z0,z1,7z2,6z3,3s+6z4,s+3z4,6z5,7z6,z7,z8) gives
  F_11 = 4 s I2 + 2 I3 | VERIFIED | check3.py, coefficient-by-coefficient mod 11
- I2 = (f,f)_8 with f = sum_i C(8,i) z_i S^{8-i} T^i and the stated normalization
  | VERIFIED | check3.py, exact equality mod 11, no scalar fudge needed. With the
  UNnormalized transvectant one gets 4^{-1} times I2, i.e. the normalizing factor
  (m-r)!(n-r)!/(m!n!) = 1/(8!)^2 reduces to 4 mod 11
- I3 = ((f,f)_4, f)_8 | VERIFIED | check3.py, exact equality mod 11 when the stated
  normalization is applied to BOTH transvectants. Using the unnormalized convention
  throughout gives 9^{-1} I3; unnormalized inner with normalized outer gives 5^{-1} I3.
  So the memo's normalization is the one that works, unambiguously

## 4. Radical and centroid

- p=7 radical of T on L is exactly <1> | VERIFIED | check4.py: the p(p+1)/2 = 28
  conditions cut a 1-dimensional subspace of L, and the all-ones vector lies in it
- p=11 radical of T on L is exactly <1> | VERIFIED | check4.py, same computation,
  solution space inside L has dimension 1 and contains 1
- p=7 centroid system has rank 35 | VERIFIED | rank exactly 35 of 36; centroid dim 1,
  identity is a solution, so the centroid is exactly the scalars
- p=11 centroid system has rank 99 | VERIFIED | rank exactly 99 of 100; centroid dim 1,
  identity is a solution, so the centroid is exactly the scalars

## 5. Rank-one exclusion

The Hessian is H_ab(v) = 3! * T[a,b,:] . v where T[a,b,c] = sum_i eps_i x_ia x_ib x_ic;
the constant 3! is invertible mod p, so it does not affect ranks.

- p=7 no nonzero v with rank H(v) = 1 | VERIFIED | check5.py, exhaustive over all
  117648 nonzero v in F_7^6. Count of rank-1 Hessians = 0; count of v with H(v) = 0
  is also 0. Full rank distribution: rank 3: 48 v, rank 4: 2940, rank 5: 26502,
  rank 6: 88158. MINIMUM RANK OVER NONZERO v = 3 (attained on 48 vectors = 8
  projective points)
- p=7 certificate "H00 and H55 vanish identically" | PARTIALLY VERIFIED |
  check5.py/check5b.py: the identically-zero diagonal index set is exactly {0,5}, i.e.
  H_00 and H_55 vanish identically and no other diagonal entry does. But forcing rows 0 and 5 of H(v) to vanish is
  a rank-5 (NOT full-rank) system in 6 unknowns: its solution space is the line
  spanned by v = (0,0,1,2,0,0), 6 nonzero vectors. So the diagonal certificate ALONE
  does not exclude rank one at p=7; the surviving line has rank H(v) = 4, which closes
  the gap. The memo's p=7 conclusion is correct, its stated certificate is one step short
- p=11 certificate "H00, H11, H88, H99 vanish identically" | VERIFIED | check5.py: those
  four and only those four diagonal entries vanish identically (the identically-zero
  diagonal index set is exactly {0,1,8,9}). Forcing rows 0,1,8,9 of H(v) to vanish gives
  40 linear equations in 10 unknowns of rank exactly 10, so v = 0 only. Hence no nonzero
  v has rank H(v) = 1
- p=11 sampled minimum rank | VERIFIED (sample) | 100000 random nonzero v (seed
  20260906): ranks seen 8 (91 times), 9 (8856), 10 (91053). MINIMUM RANK SEEN = 8

## 6. Weight enumerators

- p=7 weight enumerator of L | VERIFIED | check6a.py, exhaustive over all 7^7 = 823543
  words of L = rowspace(G). Computed A_w = {0:1, 6:378, 7:516, 8:6468, 9:25284,
  10:74382, 11:154644, 12:247842, 13:218064, 14:95964}, identical to the claimed table;
  total 823543
- p=7 enumerator of L equals that of L^perp = ker G | VERIFIED | ker G independently
  computed (dim 7) and exhaustively enumerated; the two distributions agree entrywise
- p=7 minimum nonzero weight 6 | VERIFIED | A_1..A_5 = 0, A_6 = 378
- p=7 witness word support (0,1,2,4,7,13) values (2,2,5,5,6,1) | VERIFIED | lies in
  ker G (G w = 0 mod 7), weight 6
- p=11 witness word support (0,1,2,3,4,9,17,20) values (2,2,9,9,2,9,10,1) | VERIFIED |
  lies in ker G (G w = 0 mod 11), weight 8
- p=11 no nonzero word of ker G of weight <= 7 | VERIFIED | check6a.py, exhaustive over
  all C(22,7) = 170544 column subsets S of size 7: every one has rank(G_S) = 7, so no
  subset of size <= 7 supports a nonzero kernel word. Minimum distance is therefore 8
- p=11 FULL weight enumerator | VERIFIED | check6b.py + enum11.rs: subset-rank identity
  B_w = sum_{|S|=w} 11^{w-r(G_S)} over all 2^22 subsets (depth-first with a rank-11
  pruning shortcut, 0.4 s), then A_w = B_w - sum_{j<w} C(22-j,w-j) A_j in exact
  integers. Computed A = {0:1, 8:1100, 10:41800, 11:157320, 12:2436940, 13:17133600,
  14:112941400, 15:595194160, 16:2622117190, 17:9214830020, 18:25660748300,
  19:53955314600, 20:80976004780, 21:77104831760, 22:35049917640}, all other A_w = 0
  including A_9 = 0. Every value equals the memo's claim, all A_w >= 0, and the total is
  285311670611 = 11^11

## 7. Reconstruction from the conic

check7.py implements the recipe from scratch: conic Q = XZ - Y^2, points a -> (1:a:a^2)
and inf -> (0:0:1), secant forms L_ab = abX - (a+b)Y + Z and L_{a,inf} = aX - Y (both
verified to vanish at the two named conic points), the stated base matchings, the orbit
under the Moebius action, P_M = product of the secant forms over the pairs of M, and
x_M = (P_M - P_base)/Q by exact multivariate division over F_p (a single divisor is a
Groebner basis of the ideal it generates, so a zero remainder certifies divisibility).

- orbit size 2p | VERIFIED | p=7: 14 matchings; p=11: 22 matchings. (The group was
  enumerated as GL_2(F_p) of order 2016 resp. 13200; the stabiliser of the base matching
  has order 144 = 6*24 resp. 600 = 10*60, i.e. 24 resp. 60 in PGL_2, matching |PGL_2|/2p)
- sheet labelling by the square class of det is well defined | VERIFIED | every element
  of the stabiliser of the base matching has square determinant, and the Legendre symbol
  of det g is constant over all g carrying the base matching to a given M. The two sheets
  have exactly p matchings each
- P_M - P_base divisible by Q | VERIFIED | zero remainder for every M at both primes
- p=7 reconstruction reproduces E_7 | VERIFIED EXACTLY UP TO ROW ORDER WITHIN EACH SHEET
  | the 7 positive-sheet coefficient vectors are the same multiset as rows 0..6 of E_7,
  and the 7 negative-sheet vectors the same multiset as rows 7..13. No linear change of
  the k coordinates is needed. The recipe as stated does not fix an order within a sheet
- p=11 reconstruction reproduces E_11 | VERIFIED EXACTLY UP TO ROW ORDER WITHIN EACH
  SHEET | same statement for the 11+11 rows of E_11, again with no change of coordinates
- CAVEAT on the p=11 monomial list | the quotient x_M is a general quartic, and 5 of the
  15 quartic monomials are absent from the memo's stated order, namely Y^2Z^2, Y^3Z, Y^4,
  XY^3 and X^2Y^2. These five coefficients are genuinely nonzero for some M, so the
  stated coordinate list is a projection, not the full coefficient vector. It is
  nevertheless faithful: check7b.py finds the full 22x15 coefficient matrix has rank 10
  over F_11 and the 10 retained columns already have rank 10, so the 5 dropped columns
  are F_11-linear combinations of the retained ones and no information is lost

## 8. Acceptance formula sanity (p=7, n=14, delta=0.01)

Computed in exact rational arithmetic from the p=7 enumerator verified in section 6.

- P_acc = (1 + (p-1)(1 - p delta/(p-1))^n)/p = 0.870136753241266 | VERIFIED | memo says
  0.870136753; the two agree to all 9 quoted digits (difference 2.4e-10, i.e. the memo
  value is the correct rounding)
- conditional block infidelity 1 - W_C(1-delta, delta/(p-1))/P_acc = 0.001598530882760
  | VERIFIED | memo says 0.001598530883; difference 2.4e-13, again the correct rounding
- supporting values: W_C(0.99, 1/600) = 0.868745812768986, W_C(1,1) = 823543 = 7^7,
  and W_C <= P_acc as required

## Summary

Every numerical and algebraic claim in the memo was reproduced independently and none was
contradicted. Two presentational gaps, neither of which changes a stated conclusion:

1. The p=7 rank-one exclusion certificate as stated is incomplete. H_00 and H_55 do
   vanish identically, but forcing rows 0 and 5 of the Hessian to vanish is a rank-5
   system in 6 unknowns, leaving the line spanned by v = (0,0,1,2,0,0). That line has
   Hessian rank 4, so the conclusion holds, but the certificate needs this extra line to
   be checked. The p=11 certificate is complete as stated: the analogous system has rank
   10 and only v = 0 solves it.
2. The p=11 monomial order lists 10 of the 15 quartic monomials. The dropped five occur
   with nonzero coefficients, so the stated vector is a projection; it is faithful (rank
   10 both before and after the projection), so E_11 is a legitimate coordinatisation.

Additional numbers not stated in the memo: the minimum Hessian rank over nonzero v is 3
at p=7 (attained on exactly 8 projective points; distribution 3:48, 4:2940, 5:26502,
6:88158 over the 117648 nonzero vectors) and 8 over a 10^5 random sample at p=11.
