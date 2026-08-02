from fractions import Fraction as F
def justified(n):
    need = n*(n-1)//2 + 1
    p = 1
    while p < need: p <<= 1
    return p - 1
def used(n):
    return F(n*n, 2) - 1
bad = [n for n in range(9, 129) if justified(n) < used(n)]
print("lengths where the justified bound is WEAKER than the one used:", bad)
for n in (16, 32, 64, 69, 70, 75, 80, 128):
    print(f"n={n:3d}  justified={justified(n):6d}  used={float(used(n)):9.1f}  dominates={justified(n) >= used(n)}")
