import sys
from fractions import Fraction as F
from common import A7_CLAIM

p, n, delta = 7, 14, F(1, 100)
A = A7_CLAIM                      # verified exactly by check6a.py

Pacc = (1 + (p - 1) * (1 - p * delta / (p - 1)) ** n) / p
x = 1 - delta
y = delta / (p - 1)
W = sum(F(a) * x ** (n - w) * y ** w for w, a in A.items())
inf_cond = 1 - W / Pacc
print("P_acc            =", float(Pacc), " claim 0.870136753")
print("  |diff|         =", abs(float(Pacc) - 0.870136753))
print("W_C(0.99,1/600)  =", float(W))
print("cond. infidelity =", float(inf_cond), " claim 0.001598530883")
print("  |diff|         =", abs(float(inf_cond) - 0.001598530883))
print("high precision P_acc            = %.15f" % float(Pacc))
print("high precision cond infidelity  = %.15f" % float(inf_cond))
# sanity: W_C(1,1) = 7^7 and W_C at the depolarizing point <= P_acc
print("W_C(1,1) =", sum(A.values()), "= 7^7:", sum(A.values()) == 7 ** 7)
print("W <= P_acc:", W <= Pacc)
