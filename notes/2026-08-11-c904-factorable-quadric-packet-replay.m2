R = QQ[p01,p02,p03,p12,p13,p23, MonomialOrder => GRevLex];

-- Twice the symmetric matrix of the universal wedge quadric.  Scalar two
-- does not change any rank degeneracy locus over QQ.
A = matrix {
 {-2*p01, -p03+p12, 0, 0, p01-2*p02-p12-2*p13},
 {-p03+p12, -2*p23, 0, 0, 2*p02-p03+p12+p13-p23},
 {0, 0, -2*p02, -p03-p12, -2*p01+2*p02-2*p03-p12+p13+p23},
 {0, 0, -p03-p12, -2*p13, 2*p02-2*p03+2*p23},
 {p01-2*p02-p12-2*p13,
  2*p02-p03+p12+p13-p23,
  -2*p01+2*p02-2*p03-p12+p13+p23,
  2*p02-2*p03+2*p23,
  -4*p01-2*p03-4*p12-4*p13-2*p23}
 };

pluecker = p01*p23-p02*p13+p03*p12;
irrelevant = ideal vars R;
Ipacket = saturate(ideal(pluecker) + minors(3,A), irrelevant);
Irank1 = saturate(ideal(pluecker) + minors(2,A), irrelevant);
Irad = radical Ipacket;

assert(dim Ipacket == 1);
assert(degree Ipacket == 15);
assert(Irank1 == ideal(1_R));
assert(Ipacket == Irad);
packetPrime = isPrime Ipacket;
assert packetPrime;

print "PASS independent Macaulay2 packet replay";
print("packet affine-cone dimension = " | toString dim Ipacket);
print("packet projective degree = " | toString degree Ipacket);
print("rank-one packet empty = " | toString(Irank1 == ideal(1_R)));
print("packet radical = " | toString(Ipacket == Irad));
print("packet prime over QQ = " | toString packetPrime);
