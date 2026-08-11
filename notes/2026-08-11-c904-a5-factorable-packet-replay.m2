k = ZZ/5;
S = k[x0,x1,x2,x3,z, MonomialOrder => GRevLex];

q01 = -x0^2 + z*(x0+3*x1+4*x2+z);
q02 = -x2^2 + z*(2*x0+x1+2*x2+x3+3*z);
q03 = -x0*x1-x2*x3 + z*(2*x0+2*x2+2*x3+2*z);
q12 =  x0*x1-x2*x3 + z*(x0+4*x1+2*x2+4*x3+2*z);
q13 = -x3^2 + z*(2*x0+3*x1+2*x2+2*x3+4*z);
q23 = -x1^2 + z*(4*x1+3*x2+3*x3+4*z);
qs = {q01,q02,q03,q12,q13,q23};

F = (2*x0^2*x1+2*x1^3+2*x0^2*x2+x1^2*x2+2*x0*x2^2
     -2*x1*x2^2+2*x2^3+2*x0^2*x3-2*x0*x1*x3+2*x0*x2*x3
     +x1*x2*x3-2*x2^2*x3+2*x0*x3^2+x1*x3^2+x2*x3^2+x3^3
     -x0^2*z-x0*x1*z-2*x1^2*z+x0*x2*z+x2^2*z+2*x0*x3*z
     +2*x1*x3*z-x2*x3*z-x3^2*z+x0*z^2+x1*z^2-2*x2*z^2+z^3);

L0 = 4*x1+3*x2+4*x3+3*z;
L1 = 3*x0+x1+4*x2+2*z;
L2 = 4*x0+2*x1+x2+3*x3+3*z;
L3 = 2*x0+4*x1+4*x2+3*x3+z;
L4 = 2*x0+4*x1+2*x3+3*z;
A5A = (L3^3 + L3*(L0^2-L1^2+L2^2)
       + L2*(-L1^2+3*L3^2+L4^2) + 2*L2^2*L4
       + 2*L0*L1*(L2+L3+L4) + 2*L2*L3*L4);
A5B = (-L2^3 + L2*(L0^2-L1^2-L3^2)
       + L3*(L0^2-3*L2^2-L4^2) - 2*L3^2*L4
       + 2*L0*L1*(L2+L3+L4) - 2*L2*L3*L4);
assert(F == A5A+2*A5B);

assert(q01*q23-q02*q13+q03*q12 == z*F);
irrS = ideal vars S;
assert(saturate(ideal(F)+ideal jacobian matrix{{F}},irrS) == ideal(1_S));
assert(saturate(ideal(qs)+ideal(F),irrS) == ideal(1_S));

T = k[p01,p02,p03,p12,p13,p23, MonomialOrder => GRevLex];
A = matrix {
 {3*p01,       -p03+p12, 0,        0,        p01+2*p02+2*p03+p12+2*p13},
 {-p03+p12,    3*p23,    0,        0,        3*p01+p02+4*p12+3*p13+4*p23},
 {0,           0,        3*p02,    -p03-p12, 4*p01+2*p02+2*p03+2*p12+2*p13+3*p23},
 {0,           0,        -p03-p12, 3*p13,    p02+2*p03+4*p12+2*p13+3*p23},
 {p01+2*p02+2*p03+p12+2*p13,
  3*p01+p02+4*p12+3*p13+4*p23,
  4*p01+2*p02+2*p03+2*p12+2*p13+3*p23,
  p02+2*p03+4*p12+2*p13+3*p23,
  2*(p01+3*p02+2*p03+2*p12+4*p13+4*p23)}
 };

pluecker = p01*p23-p02*p13+p03*p12;
irrT = ideal vars T;
Ipacket = saturate(ideal(pluecker)+minors(3,A),irrT);
Irank1 = saturate(ideal(pluecker)+minors(2,A),irrT);
Irad = radical Ipacket;
packetParts = primaryDecomposition Ipacket;
componentDegrees = sort apply(packetParts,P -> degree P);

assert(dim Ipacket == 1);
assert(degree Ipacket == 15);
assert(Irank1 == ideal(1_T));
assert(Ipacket == Irad);
assert(componentDegrees == {1,1,1,4,4,4});

print "PASS independent A5 packet replay";
print("target smooth = " | toString(saturate(ideal(F)+ideal jacobian matrix{{F}},irrS) == ideal(1_S)));
print("wedge basepoint-free = " | toString(saturate(ideal(qs)+ideal(F),irrS) == ideal(1_S)));
print("packet projective degree = " | toString degree Ipacket);
print("rank-one packet empty = " | toString(Irank1 == ideal(1_T)));
print("packet radical = " | toString(Ipacket == Irad));
print("packet component degrees = " | toString componentDegrees);
