\\ C1014 leg B: conductors of the m = 8 isotypic abelian surfaces.
\\ A_triv = Jac(Y^2 = J(J+4)(16J^3+68J^2+16J+1))
\\ A_sgn  = Jac(Z^2 = (4J-27) J(J+4)(16J^3+68J^2+16J+1))
default(parisize, 1000000000);
Rt = x*(x+4)*(16*x^3+68*x^2+16*x+1);
Rs = (4*x-27)*x*(x+4)*(16*x^3+68*x^2+16*x+1);
print("Rt disc factors: ", factor(poldisc(Rt)));
print("Rs disc factors: ", factor(poldisc(Rs)));
Nt = genus2red(Rt);
print("A_triv conductor = ", Nt[1], "  = ", factor(Nt[1]));
Ns = genus2red(Rs);
print("A_sgn conductor = ", Ns[1], "  = ", factor(Ns[1]));
quit;
