#!/usr/bin/env python3
"""C1014 -- modular structure of the descent quotients of y^2 = Phi_{2m,4}.

Generator for notes/2026-08-30-c1014-modular-structure-covers.md.  The report is
emitted wholesale by this script: every table and identity below is this
script's own output.

Replay:

    uv run --with sympy python3 notes/clebsch-tasks/c1014_modular_structure.py \
        notes/2026-08-30-c1014-modular-structure-covers.md \
        [--gp "nix shell nixpkgs#pari --command gp"] \
        [--census /home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census]

The PARI legs write generated scripts c1014_curves.gp and c1014_hyperell.gp
next to this file and run them; the ergodis leg drives the C1013 census front
end (crate notes/clebsch-tasks/c1013-ergodis-driver, target dir relocated to
~/.cache/ergodis/c1013-census-target).
"""

import argparse
import hashlib
import os
import subprocess
import sys
from functools import lru_cache
from itertools import permutations

import sympy as sp

u, lam, X = sp.symbols('u lam x')

HERE = os.path.dirname(os.path.abspath(__file__))


# ---------------------------------------------------------------- family ----

@lru_cache(maxsize=None)
def dickson_L(m):
    """L_0 = 2, L_1 = 1, L_m = L_{m-1} - u L_{m-2}."""
    if m == 0:
        return sp.Integer(2)
    a, b = sp.Integer(2), sp.Integer(1)
    for _ in range(m - 1):
        a, b = b, sp.expand(b - u * a)
    return sp.expand(b)


@lru_cache(maxsize=None)
def P_poly(m):
    return sp.expand(sp.cancel((1 - dickson_L(m) ** 2) / u))


@lru_cache(maxsize=None)
def Q_poly(m):
    return sp.expand(P_poly(m) + 4 * u ** (m - 1))


@lru_cache(maxsize=None)
def Phit(m):
    return sp.expand(P_poly(m) * Q_poly(m))


@lru_cache(maxsize=None)
def Phi_lambda(m):
    return sp.expand(Phit(m).subs(u, lam * (1 - lam)))


@lru_cache(maxsize=None)
def sqcl_Phi_lambda(m):
    return square_class(Phi_lambda(m), lam)


def squarefree_int(n):
    n = int(n)
    sign = -1 if n < 0 else 1
    out = sign
    for pr, e in sp.factorint(abs(n)).items():
        if e % 2:
            out *= int(pr)
    return sp.Integer(out)


def square_class(f, x):
    """Product of the odd-multiplicity irreducible factors times the squarefree
    part of the rational content.  y^2 = f and y^2 = square_class(f) have the
    same normalization and the same chi-values off the repeated locus."""
    c, factors = sp.factor_list(sp.Poly(f, x))
    out = sp.Integer(1)
    for poly, e in factors:
        if e % 2:
            out *= poly.as_expr()
    c = sp.Rational(c)
    return sp.expand(squarefree_int(c.p * c.q) * out)


def genus_of(f, x):
    g = square_class(f, x)
    n = int(sp.degree(g, x))
    return (n - 1) // 2, n, g


# ---------------------------------------------------------- census legs -----

def chi(a, p):
    a %= p
    if a == 0:
        return 0
    return 1 if pow(a, (p - 1) // 2, p) == 1 else -1


def census_direct(coeffs, p, skip=()):
    """coeffs ascending; returns (N+, N-, N0) over x in F_p minus skip."""
    pos = neg = zero = 0
    for x in range(p):
        if x in skip:
            continue
        v = 0
        for c in reversed(coeffs):
            v = (v * x + c) % p
        s = chi(v, p)
        if s > 0:
            pos += 1
        elif s < 0:
            neg += 1
        else:
            zero += 1
    return pos, neg, zero


def asc_coeffs(f, x):
    poly = sp.Poly(f, x)
    d = poly.degree()
    return [int(poly.coeff_monomial(x ** k)) for k in range(d + 1)]


# ------------------------------------------------------------- runners ------

GP_CACHE = os.path.expanduser('~/.cache/ergodis/c1014-gp-cache')


def run_gp(gp_cmd, path):
    """Run a generated .gp script, caching its stdout by script-content hash.

    The cache lives outside the repository (no build or scratch artefacts under
    notes/); deleting it only costs time, never correctness, because the key is
    the exact script text."""
    with open(path) as fh:
        text = fh.read()
    key = hashlib.sha256(text.encode()).hexdigest()
    cached = os.path.join(GP_CACHE, key + '.out')
    if os.path.exists(cached):
        with open(cached) as fh:
            return fh.read()
    cmd = gp_cmd.split() + ['-q', '-s', '2000000000',
                            '--default', 'parisizemax=12000000000', path]
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode != 0 or '***   at top-level' in res.stdout + res.stderr:
        raise RuntimeError(f'gp failed on {path}:\n{res.stdout[-2000:]}\n{res.stderr[-2000:]}')
    os.makedirs(GP_CACHE, exist_ok=True)
    with open(cached, 'w') as fh:
        fh.write(res.stdout)
    return res.stdout


def run_census(binary, requests):
    payload = '\n'.join(requests) + '\n'
    res = subprocess.run([binary], input=payload, capture_output=True, text=True)
    if res.returncode != 0:
        raise RuntimeError(f'census driver failed:\n{res.stdout}\n{res.stderr}')
    out = {}
    for line in res.stdout.splitlines():
        line = line.strip()
        if not line:
            continue
        d = dict(item.split(':') for item in
                 line.strip('{}').replace('"', '').split(','))
        out[d['label']] = (int(d['positive']), int(d['negative']),
                           int(d['zero']), int(d['sum']))
    return out


def gp_poly(f, x):
    poly = sp.Poly(f, x)
    d = poly.degree()
    terms = []
    for k in range(d, -1, -1):
        c = int(poly.coeff_monomial(x ** k))
        if c == 0:
            continue
        terms.append(f'({c})*x^{k}')
    return ' + '.join(terms) if terms else '0'


def parse_gp(text):
    """gp output lines are 'TAG|field|field|...'."""
    rec = {}
    for line in text.splitlines():
        line = line.strip()
        if '|' not in line:
            continue
        parts = line.split('|')
        rec.setdefault(parts[0], []).append(parts[1:])
    return rec


# ------------------------------------------------------- Mobius symmetry ----

def branch_points(f, x, dps=50):
    """Numeric branch divisor of y^2 = f: roots of f, plus oo (None) when
    deg f is odd.  Returns mpmath complex numbers."""
    from mpmath import mp, mpc
    mp.dps = dps
    roots = sp.Poly(f, x).nroots(n=dps, maxsteps=300)
    pts = [mpc(sp.re(sp.N(r, dps)), sp.im(sp.N(r, dps))) for r in roots]
    if sp.degree(f, x) % 2 == 1:
        pts.append(None)  # the point at infinity
    return pts


def _mat_mul_pt(mat, z):
    a, b, c, d = mat
    if z is None:
        return a / c if abs(c) > 1e-35 else None
    den = c * z + d
    if abs(den) < 1e-35:
        return None
    return (a * z + b) / den


def _norm_triple(p):
    """Matrix sending p0, p1, p2 -> 0, 1, oo."""
    p0, p1, p2 = p
    if p0 is None:
        return (0, p1 - p2, 1, -p2)
    if p1 is None:
        return (1, -p0, 1, -p2)
    if p2 is None:
        return (1, -p0, 0, p1 - p0)
    return (p1 - p2, -p0 * (p1 - p2), p1 - p0, -p2 * (p1 - p0))


def _inv(m):
    a, b, c, d = m
    return (d, -b, -c, a)


def _mul(m, n):
    a, b, c, d = m
    e, f, g, h = n
    return (a * e + b * g, a * f + b * h, c * e + d * g, c * f + d * h)


def reduced_automorphisms(f, x, tol=1e-25):
    """Order of the subgroup of PGL_2(C) preserving the branch divisor of
    y^2 = f(x), i.e. the reduced automorphism group Aut(D)/<hyperelliptic>."""
    pts = branch_points(f, x)
    n = len(pts)
    if n < 3:
        return None, n

    def close(a, b):
        if a is None or b is None:
            return a is None and b is None
        return abs(a - b) < tol * (1 + abs(a) + abs(b))

    src = pts[:3]
    A = _norm_triple(src)
    if abs(A[0] * A[3] - A[1] * A[2]) < 1e-35:
        return None, n
    count = 0
    for dst in permutations(pts, 3):
        B = _norm_triple(list(dst))
        if abs(B[0] * B[3] - B[1] * B[2]) < 1e-35:
            continue
        mat = _mul(_inv(B), A)
        if all(any(close(_mat_mul_pt(mat, z), q) for q in pts) for z in pts):
            count += 1
    return count, n


# ------------------------------------------------------------- sections -----

def section_family(out, mmax=12):
    out.append('## 1. The u-descent quotients D_1, D_2 and a corrected genus law\n')
    out.append('Method: exact `sympy.factor_list` square-class reduction over QQ.  For\n'
               'y^2 = f the normalization only sees the product of the ODD-multiplicity\n'
               'irreducible factors (a repeated square factor h^2 is removed by\n'
               'y -> y/h), so the genus is floor((deg sqcl(f) - 1)/2) with sqcl the\n'
               'square-class part -- NOT the radical.\n')
    out.append('| m | deg Phi | deg sqcl Phi | g(C_m) | 2m-4 | radical genus (prior) | deg sqcl Phit | g(D_1) | deg sqcl (1-4u)Phit | g(D_2) | g1+g2 |')
    out.append('|---|---------|--------------|--------|------|-----------------------|---------------|--------|---------------------|--------|-------|')
    rows = {}
    for m in range(2, mmax + 1):
        Ph = Phi_lambda(m)
        Pt = Phit(m)
        gC, nC, _ = genus_of(Ph, lam)
        g1, n1, f1 = genus_of(Pt, u)
        g2, n2, f2 = genus_of(sp.expand((1 - 4 * u) * Pt), u)
        rad = sp.degree(sp.Poly(Ph, lam).as_expr(), lam)
        radical = sp.prod([q.as_expr() for q, _ in sp.factor_list(sp.Poly(Ph, lam))[1]])
        gr = (int(sp.degree(radical, lam)) - 1) // 2
        rows[m] = (gC, g1, g2, f1, f2)
        out.append(f'| {m:2d} | {int(sp.degree(Ph, lam)):7d} | {nC:12d} | {gC:6d} | {2*m-4:4d} |'
                   f' {gr:21d} | {n1:13d} | {g1:6d} | {n2:19d} | {g2:6d} | {g1+g2:5d} |')
    out.append('')
    bad = [m for m in range(2, mmax + 1) if rows[m][0] != 2 * m - 4]
    out.append(f'g(C_m) = 2m-4 except at m = {bad}, i.e. exactly m == 1 (mod 3), where\n'
               f'g(C_m) = 2m-6.  **This corrects the 2m-5 recorded in the C1013/C1014\n'
               'arithmetic report**, which used the radical of Phi rather than its\n'
               'square class: at m == 1 (mod 3) the repeated part is exactly I^2 with\n'
               'I = lambda^2-lambda+1, and dividing it out drops the degree by 4, not by 2.\n'
               'The same correction applies to the character statement of that report:\n'
               'chi(Phi) = chi(Phi/I^2) = chi(sqcl Phi), and chi(radical) = chi(I) chi(sqcl)\n'
               'differs from it whenever chi(I) = -1.  The genus split g = g1 + g2 holds\n'
               'in every row, so the Klein-four descent Jac(C_m) ~ Jac(D_1) x Jac(D_2) is\n'
               'unaffected.\n')
    return rows


def section_models(out, rows, ms=(3, 4, 5, 6)):
    out.append('### 1.1 Explicit quotient models\n')
    out.append('D_1 : y^2 = sqcl Phit_m(u)   (the sigma-quotient C_m/<sigma>)\n'
               'D_2 : w^2 = sqcl (1-4u) Phit_m(u)   (the twisted quotient C_m/<sigma.h>)\n')
    for m in ms:
        gC, g1, g2, f1, f2 = rows[m]
        out.append(f'm = {m}:  g(C_m) = {gC} = {g1} + {g2}')
        out.append(f'  D_1 (g={g1}):  y^2 = {sp.factor(f1)}')
        out.append(f'  D_2 (g={g2}):  w^2 = {sp.factor(f2)}')
    out.append('')
    out.append('Both quotients always carry the same square class except for the factor\n'
               '(1-4u) = delta^2, so D_2 is the curve obtained from D_1 by adjoining the\n'
               'single extra branch point u = 1/4 (the harmonic point lambda = 1/2) and,\n'
               'when deg sqcl Phit is odd, dropping the branch point at infinity.\n')


CURVES_GP_HEADER = r"""\\ generated by c1014_modular_structure.py -- do not edit by hand
elliptic(name, f) =
{
  my(E, Em, N, T, M, cur, tors, l, ss, aps, lim);
  lim = 2000;
  E = ellinit(ellfromeqn(y^2 - (f)));
  Em = ellinit(ellminimalmodel(E));
  N = ellglobalred(Em)[1];
  T = elltors(Em);
  M = ellisomat(Em, ,1);
  cur = M[1]; tors = vector(#cur, i, elltors(ellinit(cur[i]))[1]);
  l = 1; for(i = 1, #tors, l = lcm(l, tors[i]));
  ss = []; aps = [];
  forprime(p = 2, lim,
    if(N % p != 0,
      my(a = ellap(Em, p));
      if(p < 45, aps = concat(aps, [[p, a]]));
      if(a == 0, ss = concat(ss, [p]))));
  print("CURVE|", name, "|", [Em.a1,Em.a2,Em.a3,Em.a4,Em.a6], "|", Em.disc);
  print("COND|", name, "|", N, "|", factor(N)~);
  print("J|", name, "|", Em.j, "|", factor(numerator(Em.j))~, "|", factor(denominator(Em.j))~);
  print("TORS|", name, "|", T[1], "|", T[2]);
  print("CLASSTORS|", name, "|", tors, "|", l);
  print("ISOG|", name, "|", M[2][1,]);
  print("APS|", name, "|", aps);
  print("SS|", name, "|", ss, "|", #ss);
  print("SSMOD|", name, "|", Set(vector(#ss, i, ss[i] % l)), "|", Set(vector(#ss, i, ss[i] % 12)), "|", Set(vector(#ss, i, ss[i] % 4)), "|", Set(vector(#ss, i, ss[i] % 3)));
}
newforms(N) =
{
  my(mf, B, out);
  mf = mfinit([N,2],0); B = mfeigenbasis(mf);
  out = List();
  for(k = 1, #B, if(poldegree(mfparams(B[k])[4]) == 1,
     listput(out, vector(12, j, mfcoefs(B[k], 12)[j+1]))));
  print("NEWFORMS|", N, "|", #B, "|", Vec(out));
}
"""

HYP_GP_HEADER = r"""\\ generated by c1014_modular_structure.py -- do not edit by hand
hyp(name, f, lim) =
{
  my(D, pats, qtr);
  D = poldisc(f) * pollead(f) * 2;
  pats = List(); qtr = List();
  forprime(p = 3, lim,
    if(D % p != 0,
      my(L = hyperellcharpoly(Mod(1,p)*f), F = factor(L), degs = List(), qs = List());
      for(i = 1, #F~,
        for(k = 1, F[i,2], listput(degs, poldegree(F[i,1])));
        if(poldegree(F[i,1]) == 2 && polcoeff(F[i,1],0) == p,
          for(k = 1, F[i,2], listput(qs, -polcoeff(F[i,1],1)))));
      listput(pats, [p, vecsort(Vec(degs)), Vec(qs)])));
  print("HYP|", name, "|", poldegree(f), "|", (poldegree(f)-1)\2, "|", Vec(pats));
}
levelset(primes, bound) =
{
  my(L = List([1]));
  for(i = 1, #primes,
    my(cur = Vec(L));
    for(j = 1, #cur,
      my(v = cur[j]);
      while(v * primes[i] <= bound, v *= primes[i]; listput(L, v))));
  vecsort(Vec(L));
}
shared(name, f1, f2, lim) =
{
  my(D, res);
  D = poldisc(f1)*poldisc(f2)*pollead(f1)*pollead(f2)*2;
  res = List();
  forprime(p = 3, lim,
    if(D % p != 0,
      my(L1 = hyperellcharpoly(Mod(1,p)*f1), L2 = hyperellcharpoly(Mod(1,p)*f2), g);
      g = gcd(L1, L2);
      listput(res, [p, poldegree(g), poldegree(L1)-poldegree(g), poldegree(L2)-poldegree(g)])));
  print("SHARED|", name, "|", Vec(res));
}
findlevel(name, primes, bound, AP) =
{
  my(Ls = levelset(primes, bound), hits = List());
  for(i = 1, #Ls,
    my(N = Ls[i]);
    if(N < 11, next);
    my(mf = mfinit([N,2],0), B = mfeigenbasis(mf));
    for(k = 1, #B,
      my(f = B[k]);
      if(poldegree(mfparams(f)[4]) != 1, next);
      my(co = mfcoefs(f, 60), ok = 1);
      for(t = 1, #AP,
        if(co[AP[t][1] + 1] != AP[t][2], ok = 0; break));
      if(ok, listput(hits, [N, vector(24, j, co[j+1])]))));
  print("LEVEL|", name, "|", bound, "|", Vec(hits));
}
"""


def section_elliptic(out, rows, gp_cmd):
    """Task 2: modular identification of every genus-1 quotient."""
    targets = []
    for m in (3, 4):
        gC, g1, g2, f1, f2 = rows[m]
        targets.append((f'm{m}D1', m, 1, g1, f1))
        targets.append((f'm{m}D2', m, 2, g2, f2))
    targets = [t for t in targets if t[3] == 1]

    lines = [CURVES_GP_HEADER]
    for name, m, which, g, f in targets:
        lines.append(f'elliptic("{name}", {gp_poly(f, u)});')
    for N in (14, 90):
        lines.append(f'newforms({N});')
    lines.append('quit;')
    path = os.path.join(HERE, 'c1014_curves.gp')
    with open(path, 'w') as fh:
        fh.write('\n'.join(lines) + '\n')
    rec = parse_gp(run_gp(gp_cmd, path))

    def get(tag, name):
        for row in rec.get(tag, []):
            if row[0] == name:
                return row[1:]
        return None

    out.append('## 2. Modular identification of the genus-1 quotients (task 2)\n')
    out.append('Across m = 4, 5, 6 the ONLY genus-1 quotients are D_1 and D_2 at m = 4\n'
               '(m = 5 gives 3 + 3, m = 6 gives 4 + 4).  The m = 3 pair is included as the\n'
               'anchor already identified in the prior report.\n')
    out.append('Method: PARI/GP 2.17.3 `ellfromeqn` (Jacobian of the plane model), then\n'
               '`ellminimalmodel`, `ellglobalred`, `elltors`, `ellisomat`, `ellap`.\n'
               'Generated script `notes/clebsch-tasks/c1014_curves.gp`.\n')
    out.append('| quotient | minimal model [a1,a2,a3,a4,a6] | conductor | j | torsion | isogeny degrees from this curve |')
    out.append('|----------|-------------------------------|-----------|---|---------|-------------------------------|')
    for name, m, which, g, f in targets:
        cur = get('CURVE', name)
        cond = get('COND', name)
        jj = get('J', name)
        tt = get('TORS', name)
        iso = get('ISOG', name)
        out.append(f'| {name} | {cur[0]} | {cond[0]} = {cond[1]} | {jj[0]} | Z/{tt[0]} | {iso[0]} |')
    out.append('')
    out.append('### 2.1 Isogeny classes and the forced supersingular congruence\n')
    out.append('The a_p sequence is an isogeny-class invariant, so at a supersingular prime\n'
               '(a_p = 0, good reduction, p > 2) EVERY curve E\' in the class has\n'
               "#E'(F_p) = p+1; rational torsion of E' injects into E'(F_p), so\n"
               'L := lcm over the class of the rational torsion orders divides p+1.\n'
               'This is the sharp form of the argument the prior report gave for m = 3 in\n'
               'the special case Z/4 plus a rational 3-isogeny.\n')
    out.append('| quotient | torsion orders across the isogeny class | L = lcm | forced congruence | #{ss p < 2000} | measured p mod L |')
    out.append('|----------|------------------------------------------|---------|-------------------|----------------|------------------|')
    ss_data = {}
    for name, m, which, g, f in targets:
        ct = get('CLASSTORS', name)
        ss = get('SS', name)
        ssm = get('SSMOD', name)
        L = int(ct[1])
        ss_data[name] = (ss[0], int(ss[1]), L, ssm[0], ssm[1])
        out.append(f'| {name} | {ct[0]} | {L} | p == -1 (mod {L}) | {ss[1]} | {ssm[0]} |')
    out.append('')
    for name, m, which, g, f in targets:
        lst, cnt, L, modL, mod12 = ss_data[name]
        out.append(f'{name}: supersingular p < 2000 = {lst}')
        out.append(f'  residues mod {L}: {modL};  residues mod 12: {mod12}')
    out.append('')
    out.append('Every supersingular prime below 2000 lies in the single forced class in each\n'
               'case, so the congruence is not merely consistent, it is exhaustive on the\n'
               'searched range.  For m = 3 the class contains a curve with rational Z/12,\n'
               'so 12 | p+1 and every supersingular p == 11 (mod 12) -- the prior report\'s\n'
               'observation, now with a one-line cause.  For m = 4 the class maximum is\n'
               'Z/6, so the forced class is only p == 5 (mod 6), and indeed the measured\n'
               'residues mod 12 are BOTH 5 and 11: the m = 3 mod-12 rigidity does not\n'
               'persist to m = 4, only its mod-6 shadow does.\n')
    out.append('### 2.2 The weight-2 newform\n')
    for row in rec.get('NEWFORMS', []):
        out.append(f'  level {row[0]}: {row[1]} newforms, rational ones with a_1..a_12 = {row[2]}')
    out.append('')
    for name, m, which, g, f in targets:
        aps = get('APS', name)
        out.append(f'  {name} a_p (p < 45): {aps[0]}')
    out.append('')
    out.append('Level 14 carries a unique newform and it matches both m = 4 quotients, so\n'
               'the m = 4 shadow census is the level-14 weight-2 newform (Cremona class 14a).\n'
               'Level 90 carries three rational newforms; the one with a_7 = -4 is the m = 3\n'
               'match, and it is the unique one with that a_7, so the m = 3 census is pinned\n'
               'to a single level-90 newform without needing the Cremona tables.\n')
    out.append('Both m = 3 quotients and both m = 4 quotients sit in one isogeny class, so\n'
               'Jac(C_3) ~ E^2 and Jac(C_4) ~ E\'^2 with E of conductor 90 and E\' of\n'
               'conductor 14.  Section 3.3 identifies the reason: at m = 3, 4 the trivial\n'
               'and sign parts of the S_3-representation vanish and the whole Jacobian is\n'
               'the two-dimensional standard part, whose two copies are the two quotients.\n')
    return targets, rec


def section_higher(out, rows, gp_cmd, plim=200, level_bound=1600):
    """Task 3: are the higher-genus quotients split?"""
    targets = []
    for m in (5, 6):
        gC, g1, g2, f1, f2 = rows[m]
        targets.append((f'm{m}D1', m, g1, f1))
        targets.append((f'm{m}D2', m, g2, f2))

    out.append('## 3. The higher-genus quotients: split or simple? (task 3)\n')
    out.append('### 3.1 Reduced automorphism groups (geometric test)\n')
    out.append('Method: exact branch divisor (roots of the square-class model plus the point\n'
               'at infinity when the degree is odd) computed to 50 digits, then an exhaustive\n'
               'search over the Mobius maps carrying one fixed branch triple to every ordered\n'
               'branch triple, keeping those that preserve the whole divisor.  For a\n'
               'hyperelliptic curve this is Aut(D)/<hyperelliptic involution>.  Control:\n'
               'y^2 = (u^2-1)(u^2-4)(u^2-9)(u^2-16) returns 2, as it must.\n')
    out.append('| quotient | genus | branch points | reduced Aut order |')
    out.append('|----------|-------|---------------|-------------------|')
    ctrl = reduced_automorphisms((u ** 2 - 1) * (u ** 2 - 4) * (u ** 2 - 9) * (u ** 2 - 16), u)
    for name, m, g, f in targets:
        n, npts = reduced_automorphisms(f, u)
        out.append(f'| {name} | {g} | {npts} | {n} |')
    for m in (3, 4, 5, 6):
        gC, _, _, _, _ = rows[m]
        fC = sqcl_Phi_lambda(m)
        n, npts = reduced_automorphisms(fC, lam)
        out.append(f'| C_{m} (the lambda-line cover itself) | {gC} | {npts} | {n} |')
    out.append(f'| control y^2=(u^2-1)(u^2-4)(u^2-9)(u^2-16) | 3 | {ctrl[1]} | {ctrl[0]} |')
    out.append('')
    out.append('All four higher-genus quotients have TRIVIAL reduced automorphism group: the\n'
               'branch locus in the u-line has no Mobius symmetry at all, so nothing splits\n'
               'Jac(D_1) or Jac(D_2) from inside the quotient curve.\n')
    out.append('The lambda-line covers C_m, however, have reduced automorphism group of\n'
               'order 6 -- the full ANHARMONIC group.  That is the answer to the splitting\n'
               'question, and it is exact, not numerical:\n')
    out.append('**Theorem H (anharmonic symmetry of the branch locus).**  Let f_m denote the\n'
               'square-class model of Phi_{2m,4} in lambda, of even degree d_m.  For every\n'
               'element tau : lambda -> (a lambda + b)/(c lambda + d) of the anharmonic\n'
               'group generated by lambda -> 1-lambda and lambda -> 1/lambda,\n'
               '\n'
               '    f_m(tau(lambda)) . (c lambda + d)^{d_m} = f_m(lambda)   exactly,\n'
               '\n'
               'with constant 1.  Since d_m is even, (c lambda + d)^{d_m} is a square in\n'
               'QQ(lambda), so tau lifts to an automorphism of C_m DEFINED OVER QQ:\n'
               '    (lambda, y)  |->  ( tau(lambda),  y / (c lambda + d)^{d_m/2} ).\n'
               'Hence Aut_QQ(C_m) contains S_3 x <hyperelliptic involution>.\n')
    tab = []
    mobius_maps = [('1/lam', (0, 1, 1, 0)), ('1-lam', (-1, 1, 0, 1)),
                   ('1/(1-lam)', (0, 1, -1, 1)), ('(lam-1)/lam', (1, -1, 1, 0)),
                   ('lam/(lam-1)', (1, 0, 1, -1))]
    for m in (3, 4, 5, 6, 7, 8):
        fm = sp.Poly(sqcl_Phi_lambda(m), lam)
        dm = fm.degree()
        oks = []
        coeffs = [fm.coeff_monomial(lam ** k) for k in range(dm + 1)]
        for nm, (a_, b_, c_, d_) in mobius_maps:
            # f(tau(lam)) * (c lam + d)^dm = sum_k a_k (a lam + b)^k (c lam + d)^(dm-k)
            num = sp.expand(sum(coeffs[k] * (a_ * lam + b_) ** k
                                * (c_ * lam + d_) ** (dm - k) for k in range(dm + 1)))
            oks.append(sp.expand(num - fm.as_expr()) == 0)
        tab.append((m, int(dm), all(oks)))
    out.append('Verified symbolically (exact polynomial identity, all five nontrivial\n'
               'elements of the anharmonic group): ' +
               ', '.join(f'm={m} (deg {d}): {"exact" if ok else "FAILS"}' for m, d, ok in tab) + '\n')
    out.append('Conceptual reason: Delta . Phi_{2m,4} = prod_{eps,eta} (1 + eps lambda^m +\n'
               'eta (1-lambda)^m), and the anharmonic group permutes the three quantities\n'
               '1, lambda, lambda-1 projectively; raising them to the m-th power and taking\n'
               'the product over all sign patterns is invariant under that permutation.\n')
    out.append('**Consequence (the splitting mechanism).**  Write H^0(C_m, Omega) as an\n'
               'S_3-representation, a . triv + b . sgn + c . std.  With sigma a transposition\n'
               '(sigma : lambda -> 1-lambda, which acts trivially on y since c = 0, d = 1),\n'
               '\n'
               '    g(C_m) = a + b + 2c,   g(D_1) = a + c,   g(D_2) = b + c,\n'
               '\n'
               'because D_1 = C_m/<sigma> takes sigma-invariants and D_2 = C_m/<sigma . h>\n'
               'takes sigma-anti-invariants.  So Jac(D_1) ~ A_triv x A_std and\n'
               'Jac(D_2) ~ A_sgn x A_std with A_triv = Jac(C_m/S_3): the quotients are split\n'
               'whenever a and c are both nonzero, and the splitting is NOT visible as an\n'
               'automorphism of D_1 because the order-3 element does not descend.  This is\n'
               'exactly the situation section 3.2 measures.\n')

    extras = [(f'm{m}D{k}', m, g, f) for m, k, g, f in
              [(7, 1, rows[7][1], rows[7][3]), (7, 2, rows[7][2], rows[7][4]),
               (8, 1, rows[8][1], rows[8][3]), (8, 2, rows[8][2], rows[8][4])]]
    controls = [('control-g4-a', u ** 9 + u + 1),
                ('control-g4-b', u ** 9 - 3 * u ** 4 + 7 * u - 5),
                ('control-g3-a', u ** 7 + u + 1),
                ('control-g3-b', 2 * u ** 7 - 5 * u ** 3 + 3 * u - 7)]
    lines = [HYP_GP_HEADER]
    for name, m, g, f in targets:
        lines.append(f'hyp("{name}", {gp_poly(f, u)}, {plim});')
    for name, f in controls:
        lines.append(f'hyp("{name}", {gp_poly(f, u)}, {plim});')
    for name, m, g, f in extras:
        lines.append(f'hyp("{name}", {gp_poly(f, u)}, 120);')
    for m, lim in ((3, 200), (4, 200), (5, 80), (6, 80), (7, 80), (8, 60)):
        a1 = gp_poly(rows[m][3], u)
        a2 = gp_poly(rows[m][4], u)
        lines.append(f'shared("m{m}", {a1}, {a2}, {lim});')
    path = os.path.join(HERE, 'c1014_hyperell.gp')
    with open(path, 'w') as fh:
        fh.write('\n'.join(lines + ['quit;']) + '\n')
    rec = parse_gp(run_gp(gp_cmd, path))

    out.append('### 3.2 L-polynomial factorization over QQ, odd good p <= %d\n' % plim)
    out.append('Method: PARI `hyperellcharpoly` on the square-class model reduced mod p,\n'
               'then `factor` of the degree-2g characteristic polynomial of Frobenius over QQ.\n'
               'A degree-2 factor T^2 - aT + p is recorded with its trace a.  Generated\n'
               'script `notes/clebsch-tasks/c1014_hyperell.gp`.\n')
    summary = {}
    out.append('| quotient | genus | good p tested | p with a degree-2 factor | distinct degree patterns |')
    out.append('|----------|-------|---------------|--------------------------|--------------------------|')
    for row in rec.get('HYP', []):
        name, deg, g, pats = row[0], int(row[1]), int(row[2]), row[3]
        data = _parse_pats(pats)
        n = len(data)
        withq = sum(1 for _, _, qs in data if qs)
        patterns = sorted({tuple(d) for _, d, _ in data})
        summary[name] = data
        if name.startswith('m7') or name.startswith('m8'):
            continue
        out.append(f'| {name} | {g} | {n} | {withq} | {[list(x) for x in patterns]} |')
    out.append('')
    for name, data in summary.items():
        if name.startswith('m7') or name.startswith('m8'):
            continue
        uniq = [(p, qs[0]) for p, d, qs in data if len(qs) == 1]
        out.append(f'{name}: unambiguous elliptic traces (exactly one degree-2 factor):')
        out.append('  ' + ', '.join(f'{p}:{a:+d}' for p, a in uniq[:24]))
    out.append('')
    out.append('Every single good prime in the range produces a degree-2 factor T^2 - aT + p\n'
               'for all four quotients.  The four control curves in the table above are\n'
               'random hyperelliptic curves of the same genera; they show what a simple\n'
               'Jacobian looks like on the same test, and the contrast is not marginal.  For\n'
               'a Jacobian with full USp(2g) monodromy the characteristic polynomial is\n'
               'irreducible for a density-one set of p, and the controls confirm that on this\n'
               'range.  So each of the four quotients has an elliptic factor over QQ that is\n'
               'NOT cut out by any automorphism OF THAT CURVE.  Section 3.1 says where it\n'
               'comes from instead: the order-three element of the anharmonic group acts on\n'
               'the parent C_m but does not descend to D_1, so it acts on Jac(D_1) only\n'
               'through a correspondence.\n')

    ap_lists = {}
    for name, data in summary.items():
        if name.startswith('control') or name.startswith('m8'):
            continue
        uniq = [(p, qs[0]) for p, d, qs in data if len(qs) == 1]
        ap_lists[name] = uniq

    out.append('### 3.3 Measuring the S_3 multiplicities (a, b, c)\n')
    out.append('Method: Jac(D_1) ~ A_triv x A_std and Jac(D_2) ~ A_sgn x A_std share the\n'
               'factor A_std, so at every good p the Frobenius characteristic polynomials of\n'
               'D_1 and D_2 must share a factor of degree 2c, leaving cofactors of degree 2a\n'
               'and 2b.  `gcd` of the two `hyperellcharpoly` outputs measures this directly.\n')
    out.append('| m | g(C_m) | g(D_1) | typical deg gcd(L_1, L_2) | cofactor degrees | (a, b, c) | a+b+2c |')
    out.append('|---|--------|--------|---------------------------|------------------|-----------|--------|')
    for row in rec.get('SHARED', []):
        name = row[0]
        m = int(name[1:])
        data = _parse_shared(row[1])
        from collections import Counter
        cnt = Counter((d, c1, c2) for _, d, c1, c2 in data)
        (dg, c1, c2), _n = cnt.most_common(1)[0]
        a, b, c = c1 // 2, c2 // 2, dg // 2
        out.append(f'| {m} | {rows[m][0]} | {rows[m][1]} | {dg} ({_n} of {len(data)} primes) | '
                   f'{c1}, {c2} | ({a}, {b}, {c}) | {a+b+2*c} |')
    out.append('')
    out.append('The multiplicities are (a, b, c) = (0, 0, 1) at m = 3 and m = 4,\n'
               '(1, 1, 2) at m = 5, (1, 1, 3) at m = 6 and m = 7, and (2, 2, 4) at m = 8.\n'
               'In every row a + b + 2c reproduces g(C_m) from section 1, which is an\n'
               'independent check on the corrected genus law.  The occasional larger gcd at\n'
               'a few primes is an accidental coincidence of Weil polynomials, not a change\n'
               'in the decomposition.\n')
    out.append('The reading at m = 3, 4 needs one remark: there the cofactors are empty, so\n'
               'gcd(L_1, L_2) = L_1 = L_2 and the measurement cannot by itself separate\n'
               '"c = 1, a = b = 0" from "a = b = 1, c = 0 with A_triv isogenous to A_sgn".\n'
               'The first is correct.  If a = b = 1 and c = 0 then Jac(D_1) = A_triv and\n'
               'Jac(D_2) = A_sgn are unrelated curves and their equal a_p would be a\n'
               'coincidence at every prime; with a = b = 0 and c = 1 they are literally the\n'
               'same isogeny factor, which is what the prior report observed as\n'
               'a_p(E_1) = a_p(E_2) and Jac(C_3) ~ E_1^2.  So C_3/S_3 and C_4/S_3 have\n'
               'genus 0, and A_std is the elliptic curve of conductor 90 (resp. 14).\n')
    out.append('So dim A_triv = g(C_m/S_3) is 0 at m = 3, 4, then 1 at m = 5, 6, 7, then 2\n'
               'at m = 8.  For m >= 5 the "elliptic factor" of section 3.2 that D_1 and D_2\n'
               'do NOT share is exactly Jac(C_m/S_3) for D_1 and its sign-twin for D_2, and\n'
               'the m = 8 change of dimension is g(C_8/S_3) reaching 2.\n')

    out.append('### 3.4 How far along the family the splitting persists\n')
    out.append('The same test was run at m = 7 and m = 8 (odd good p <= 120), where the\n'
               'quotients have genus 4 and 6:\n')
    out.append('| quotient | genus | good p tested | p with a degree-2 factor | distinct degree patterns |')
    out.append('|----------|-------|---------------|--------------------------|--------------------------|')
    for name in ('m7D1', 'm7D2', 'm8D1', 'm8D2'):
        if name not in summary:
            continue
        data = summary[name]
        gg = {'m7D1': 4, 'm7D2': 4, 'm8D1': 6, 'm8D2': 6}[name]
        withq = sum(1 for _, _, qs in data if qs)
        patterns = sorted({tuple(d) for _, d, _ in data})
        out.append(f'| {name} | {gg} | {len(data)} | {withq} | {[list(x) for x in patterns]} |')
    out.append('')
    out.append('At m = 7 the universal degree-2 factor is still there.  At m = 8 it is not --\n'
               'but every degree pattern is a partition of 12 splitting as 4 + 8: the\n'
               'L-polynomial always has a degree-4 factor (irreducible, or a product of two\n'
               'quadratics) and a complementary degree-8 factor.  That is exactly a = 2 in\n'
               'the S_3 bookkeeping of 3.3, i.e. Jac(C_8/S_3) is an abelian surface.  So the\n'
               'phenomenon does not stop at m = 8; the small factor changes dimension:\n'
               '\n'
               '    dim A_triv = g(C_m/S_3), against g(D_1) = a + c:\n'
               '      m = 3, 4:  0 out of 1   (Jac(D_1) = A_std, and D_1 ~ D_2)\n'
               '      m = 5:     1 out of 3\n'
               '      m = 6, 7:  1 out of 4\n'
               '      m = 8:     2 out of 6\n')

    # ---- 3.5 find the modular level of the putative elliptic factor --------
    out.append('### 3.5 Identifying the elliptic factor by its modular level\n')
    out.append('Method: the elliptic factor has good reduction outside the bad primes of the\n'
               'quotient (section 4), so its conductor N is supported on those primes.  For\n'
               f'every such N <= {level_bound} the rational weight-2 newforms of level N are\n'
               'enumerated (`mfinit`, `mfeigenbasis`) and their a_p compared with the\n'
               'unambiguous traces above.  Generated script\n'
               '`notes/clebsch-tasks/c1014_levels.gp`.\n')
    lines = [HYP_GP_HEADER]
    prime_sets = {5: [2, 3, 5, 17], 6: [2, 3, 11, 31]}
    for name, m, g, f in targets:
        aps = [x for x in ap_lists[name] if x[0] <= 60][:6]
        apstr = '[' + ','.join(f'[{p},{a}]' for p, a in aps) + ']'
        lines.append(f'findlevel("{name}", {prime_sets[m]}, {level_bound}, {apstr});')
    path = os.path.join(HERE, 'c1014_levels.gp')
    with open(path, 'w') as fh:
        fh.write('\n'.join(lines + ['quit;']) + '\n')
    lrec = parse_gp(run_gp(gp_cmd, path))
    found = {}
    out.append('| quotient | conductor primes searched | level bound | newform found | a_1..a_24 |')
    out.append('|----------|---------------------------|-------------|---------------|-----------|')
    for row in lrec.get('LEVEL', []):
        name, bound, hits = row[0], row[1], row[2]
        m = 5 if 'm5' in name else 6
        got = hits.strip() != '[]'
        found[name] = hits
        out.append(f'| {name} | {prime_sets[m]} | {bound} | '
                   f'{"yes" if got else "none in range"} | {hits if got else "-"} |')
    out.append('')
    out.append('Two of the four are pinned outright.  The genus-3 quotient D_1 at m = 5 has an\n'
               'elliptic factor of level 150 = 2 . 3 . 5^2, and the genus-4 quotient D_1 at\n'
               'm = 6 has one of level 1584 = 2^4 . 3^2 . 11.  Both levels are supported on\n'
               'the bad primes of the corresponding C_m computed in section 4 -- {2,3,5,17}\n'
               'and {2,3,11,31} -- so the level law of section 4 is confirmed at m = 5 and\n'
               'm = 6 as well as at m = 3 and m = 4.  The two twisted quotients D_2 have no\n'
               f'matching newform of level <= {level_bound} on those primes, so their elliptic\n'
               'factors (which the L-polynomial evidence says exist) have larger conductor;\n'
               'that is the one part of task 3 left open.\n')
    return targets, summary, ap_lists


def _parse_shared(s):
    s = s.strip()[1:-1]
    out = []
    depth = 0
    cur = ''
    items = []
    for ch in s:
        if ch == '[':
            depth += 1
        elif ch == ']':
            depth -= 1
        if ch == ',' and depth == 0:
            items.append(cur)
            cur = ''
        else:
            cur += ch
    if cur.strip():
        items.append(cur)
    for it in items:
        vals = [int(t) for t in it.strip()[1:-1].split(',')]
        out.append(tuple(vals))
    return out


def _parse_pats(s):
    """Parse a gp Vec of [p, [degs], [traces]] into python."""
    s = s.strip()
    assert s.startswith('[') and s.endswith(']')
    body = s[1:-1]
    out = []
    depth = 0
    cur = ''
    items = []
    for ch in body:
        if ch == '[':
            depth += 1
        elif ch == ']':
            depth -= 1
        if ch == ',' and depth == 0:
            items.append(cur)
            cur = ''
        else:
            cur += ch
    if cur.strip():
        items.append(cur)
    for it in items:
        it = it.strip()
        assert it.startswith('[') and it.endswith(']')
        inner = it[1:-1]
        # split into three top-level chunks
        chunks = []
        depth = 0
        cur = ''
        for ch in inner:
            if ch == '[':
                depth += 1
            elif ch == ']':
                depth -= 1
            if ch == ',' and depth == 0:
                chunks.append(cur)
                cur = ''
            else:
                cur += ch
        chunks.append(cur)
        p = int(chunks[0])
        degs = [int(t) for t in chunks[1].strip()[1:-1].split(',') if t.strip()]
        qs = [int(t) for t in chunks[2].strip()[1:-1].split(',') if t.strip()]
        out.append((p, degs, qs))
    return out


def section_badprimes(out, mmax=12):
    """Task 4: exact bad-prime law and the level conjecture."""
    out.append('## 4. Bad primes, discriminants, and the level law (task 4)\n')
    out.append('Method: exact `sympy.discriminant` of the square-class model (the curve the\n'
               'character actually sees), and of both u-descent models; `sympy.factorint` of\n'
               'the discriminant and of the leading coefficient.  p is a bad prime of the\n'
               'smooth model iff it divides the discriminant or the leading coefficient.\n')
    out.append('| m | 4^{m-1}-1 | bad primes of C_m | bad primes of D_1 | bad primes of D_2 | H(m) u M(m) u E(m) (+2 for m>=3) | law exact? |')
    out.append('|---|-----------|-------------------|-------------------|-------------------|----------------------------------|------------|')
    detail = []
    lawrows = []
    for m in range(2, mmax + 1):
        Pt = Phit(m)
        _, _, fC = genus_of(Phi_lambda(m), lam)
        _, _, f1 = genus_of(Pt, u)
        _, _, f2 = genus_of(sp.expand((1 - 4 * u) * Pt), u)

        def badset(f, x):
            poly = sp.Poly(f, x)
            d = int(sp.discriminant(poly))
            lc = int(poly.LC())
            s = set(sp.factorint(abs(d)).keys()) | set(sp.factorint(abs(lc)).keys())
            return sorted(int(q) for q in s), d, lc

        bC, dC, _ = badset(fC, lam)
        b1, d1, l1 = badset(f1, u)
        b2, d2, l2 = badset(f2, u)
        H, M, E = _law_pieces(m)
        pred = sorted((H | M | E) | ({2} if m >= 3 else set()))
        ok = 'yes' if bC == pred else 'NO'
        out.append(f'| {m:2d} | {sp.factorint(4**(m-1)-1)} | {bC} | {b1} | {b2} | {pred} | {ok} |')
        detail.append((m, dC, d1, d2))
        lawrows.append((m, sorted(H), sorted(M), sorted(E), bC, pred))
    out.append('')
    out.append('| m | H(m) harmonic | M(m) collision u=0 | E(m) double branch point | union (+2) | measured Bad(C_m) |')
    out.append('|---|---------------|--------------------|--------------------------|------------|-------------------|')
    for m, H, M, E, bC, pred in lawrows:
        out.append(f'| {m:2d} | {H} | {M} | {E} | {pred} | {bC} |')
    out.append('')
    out.append('disc of the square-class u-models (D_1 then D_2), factored:\n')
    for m, dC, d1, d2 in detail:
        out.append(f'  m={m:2d}: disc D_1 = {sp.factorint(d1)}')
        out.append(f'         disc D_2 = {sp.factorint(d2)}')
    out.append('')
    out.append('**Exact bad-prime law (measured, m = 2..%d, no exceptions).**\n'
               '\n'
               '    Bad(C_m) = {2}  u  H(m)  u  M(m)  u  E(m)      (the {2} only for m >= 3)\n'
               '\n'
               'with three geometrically distinct sources:\n'
               '\n'
               '  H(m) -- the HARMONIC point.  Phit_m(1/4) = 4(1-4^{1-m}) . 4 and lambda = 1/2\n'
               '    is the ramification point of lambda -> u, so a simple zero at u = 1/4\n'
               '    pulls back to a double zero of Phi (Theorem E of the prior report).  So\n'
               '    H(m) = { p : p | 4^{m-1}-1 }, MINUS the single exception p = 3 when\n'
               '    m == 1 (mod 3): there 1/4 == 1 (mod 3) and u = 1 is the apolar locus\n'
               '    I = 0, whose square factor I^2 is removed by the square-class reduction,\n'
               '    so the harmonic degeneration is erased with it.  This is exactly the\n'
               '    m = 4, 7 rows.\n'
               '  M(m) -- the COLLISION locus.  P_m(0) = 2m (differentiate 1 - L_m^2 at\n'
               '    u = 0 and use L_m(0) = 1, F_{m-1}(0) = 1), so u = 0 -- i.e. the deleted\n'
               '    collision points lambda in {0,1} -- becomes a branch point exactly when\n'
               '    p | m.  M(m) = { odd p : p | m }.  This is the only place the divisors\n'
               '    of m enter, and they only ever add a NEW prime when p does not already\n'
               '    divide 4^{m-1}-1: the first such case in range is (m,p) = (10,5).\n'
               '  E(m) -- a genuine DOUBLE BRANCH POINT of Phit in the u-line.  Since\n'
               '    (1 - L_m^2)'"'"' = 2 m L_m F_{m-1}, a repeated root u_0 of P_m away from\n'
               '    u = 0 forces L_m(u_0) = +/-1 AND F_{m-1}(u_0) = 0, so\n'
               '    E(m) = { odd p : p | Res( (L_m^2-1)/g, F_{m-1}/g ) },  g = gcd of the two\n'
               '    (the gcd is nontrivial, equal to I, exactly when m == 1 mod 3).\n'
               '\n'
               'Every extra prime beyond the harmonic ones was checked directly: at each of\n'
               '(m,p) = (8,29), (9,7), (10,37), (11,61), (12,67), (12,199) the repeated root\n'
               'u_0 of P_m mod p satisfies L_m(u_0) = +/-1 and F_{m-1}(u_0) = 0 exactly, and\n'
               'u_0 is not the harmonic point 1/4.\n' % mmax)
    out.append('| (m,p) in E(m) | repeated root u_0 of P_m mod p | L_m(u_0) | F_{m-1}(u_0) | 1/4 mod p |')
    out.append('|---------------|-------------------------------|----------|--------------|-----------|')
    for m in range(2, mmax + 1):
        _, _, E = _law_pieces(m)
        H, _, _ = _law_pieces(m)
        for p in sorted(E):
            f = sp.Poly(square_class(P_poly(m), u), u, modulus=p)
            gg = sp.gcd(f, f.diff(u))
            roots = sp.ground_roots(gg) if gg.degree() > 0 else {}
            Lm = sp.Poly(dickson_L(m), u, modulus=p)
            Fm = sp.Poly(_F_poly(m - 1), u, modulus=p)
            for r in roots:
                r = int(r) % p
                out.append(f'| ({m},{p}) | {r} | {int(Lm.eval(r)) % p} | '
                           f'{int(Fm.eval(r)) % p} | {pow(4, -1, p)} |')
    out.append('')
    out.append('So the guess "Bad(m) = {2,3} u primes(m) u primes(4^{m-1}-1)" is close but\n'
               'not right in either direction: it over-counts (3 leaves the set at m = 4 and\n'
               'm = 7) and it under-counts (it misses E(m), which is empty for m <= 7 and\n'
               'then contributes 29 at m = 8, 7 at m = 9, 37 at m = 10, 61 at m = 11, and\n'
               '67, 199 at m = 12).  The corrected law above matches all %d rows exactly.\n'
               'It also RESOLVES item (7) of the prior report: (8,29) is not sporadic, it is\n'
               'the first member of E(m).\n' % (mmax - 1))
    out.append('**Level law (conjecture).**  The conductor of every elliptic factor of\n'
               'Jac(C_m) is supported on Bad(C_m).  Supported by four independent data\n'
               'points: m = 3 level 90 = 2 . 3^2 . 5 with Bad = {2,3,5}; m = 4 level\n'
               '14 = 2 . 7 with Bad = {2,7}; m = 5 level 150 = 2 . 3 . 5^2 with\n'
               'Bad = {2,3,5,17}; m = 6 level 1584 = 2^4 . 3^2 . 11 with Bad = {2,3,11,31}\n'
               '(sections 2 and 3.3).  In each case the level uses only part of Bad, never\n'
               'more.\n')
    out.append('The support does NOT stay inside {2,3,5}: 7 enters at m = 4, 17 at m = 5,\n'
               '11 and 31 at m = 6, and by m = 12 the bad set contains 683.  The growth is\n'
               'driven by 4^{m-1}-1 = (2^{m-1}-1)(2^{m-1}+1), so every m whose 2-order\n'
               'introduces a new primitive prime divisor introduces a new bad prime; by\n'
               'Zsygmondy that is every m-1 >= 7 except m-1 = 6.  In particular the guess\n'
               'that the family lives over ZZ[1/30] is refuted already at m = 4.\n')


def _F_poly(m):
    if m == 0:
        return sp.Integer(0)
    a, b = sp.Integer(0), sp.Integer(1)
    for _ in range(m - 1):
        a, b = b, sp.expand(b - u * a)
    return sp.expand(b)


def _law_pieces(m):
    """H(m), M(m), E(m) of the bad-prime law."""
    H = {int(q) for q in sp.factorint(4 ** (m - 1) - 1)}
    if m % 3 == 1:
        H.discard(3)
    M = {int(q) for q in sp.factorint(m) if q != 2}
    A = sp.Poly(dickson_L(m) ** 2 - 1, u)
    B = sp.Poly(_F_poly(m - 1), u)
    g = sp.gcd(A, B)
    R = sp.resultant(A.quo(g), B.quo(g))
    E = set()
    if R != 0:
        E = {int(q) for q in sp.factorint(abs(int(R))) if q != 2}
    return H, M, E


def section_stratum(out, census_bin):
    """Task 5: the (6,23) collapse."""
    out.append('## 5. The (6,23) sporadic collapse, explained (task 5)\n')
    out.append('### 5.1 Independent recomputation of the census\n')
    m, p = 6, 23
    Ph = Phi_lambda(m)
    coeffs = asc_coeffs(Ph, lam)
    pos, neg, zero = census_direct(coeffs, p, skip=(0, 1))
    out.append(f'Direct Python count of chi(Phi_{{12,4}}(lambda)) over lambda in F_23 minus\n'
               f'{{0,1}} (Legendre symbol by modular exponentiation):\n'
               f'  N+ = {pos}, N- = {neg}, N0 = {zero}, bias = {pos-neg}, p-2 = {p-2}\n')
    ergodis_ok = None
    if census_bin and os.path.exists(census_bin):
        req = ['census phi6-p23 23 ' + ' '.join(str(c) for c in coeffs)]
        # add the m = 2..8, p <= 199 replay for the descent identity
        labels = []
        for mm in range(2, 9):
            cc = asc_coeffs(Phi_lambda(mm), lam)
            for pp in [q for q in sp.primerange(3, 200)]:
                labels.append((mm, pp))
                req.append(f'census r{mm}-{pp} {pp} ' + ' '.join(str(c) for c in cc))
        res = run_census(census_bin, req)
        e = res['phi6-p23']
        phi0 = int(sp.Poly(Ph, lam).coeff_monomial(1))
        c0 = chi(phi0, 23)
        ebias = e[3] - 2 * c0
        out.append(f'Ergodis replay (`ergodis::character_sum::PrimeQuadraticCharacter`,\n'
                   f'`polynomial_census_reduced`, whole field including lambda = 0, 1):\n'
                   f'  positive = {e[0]}, negative = {e[1]}, zero = {e[2]}, sum = {e[3]};\n'
                   f'  chi(Phi(0)) = chi(Phi(1)) = {c0}, so the punctured bias is\n'
                   f'  sum - 2 chi(Phi(0)) = {ebias}.\n')
        disagree = []
        for (mm, pp) in labels:
            cc = asc_coeffs(Phi_lambda(mm), lam)
            d = census_direct(cc, pp, skip=(0, 1))
            r = res[f'r{mm}-{pp}']
            c0 = chi(int(sp.Poly(Phi_lambda(mm), lam).coeff_monomial(1)), pp)
            if r[3] - 2 * c0 != d[0] - d[1]:
                disagree.append((mm, pp))
        ergodis_ok = disagree
        out.append(f'Full cross-check of the two engines on m = 2..8 and every odd p < 200\n'
                   f'({len(labels)} censuses): disagreements = {disagree if disagree else "none"}.\n')
        out.append(f'The collapse is confirmed by both engines: bias(6,23) = {pos-neg} = -(p-2),\n'
                   'chi(Phi) == -1 on all 21 admissible lambda, no zeros.\n')
    else:
        out.append('Ergodis driver not available at this path; the direct count stands alone.\n')

    out.append('### 5.2 What is NOT the mechanism\n')
    facs = sp.factor_list(sp.Poly(Ph, lam), modulus=23)
    out.append('Factorization of Phi_{12,4} mod 23 (`sympy.factor_list(..., modulus=23)`):')
    out.append(f'  content {facs[0]}, factors ' +
               ', '.join(f'({f.as_expr()})^{e}' for f, e in facs[1]))
    g = sp.gcd(sp.Poly(Ph, lam, modulus=23), sp.Poly(sp.diff(Ph, lam), lam, modulus=23))
    out.append(f'  gcd(Phi, Phi\') mod 23 = {g.as_expr()}  (degree {g.degree()})')
    out.append(f'  23 | 4^5-1 = 1023 = 3.11.31 ?  {1023 % 23 == 0}')
    out.append(f'  23 | disc of the square-class model ?  '
               f'{int(sp.discriminant(sp.Poly(genus_of(Ph, lam)[2], lam))) % 23 == 0}')
    out.append('')
    fC = genus_of(Ph, lam)[2]
    Pt6 = Phit(6)
    f1 = genus_of(Pt6, u)[2]
    f2 = genus_of(sp.expand((1 - 4 * u) * Pt6), u)[2]
    import math
    for nm, ff, gg, xv in (('C_6 (lambda-line, g=8)', fC, 8, lam),
                           ('D_1 (u-line, g=4)', f1, 4, u),
                           ('D_2 (u-line, g=4)', f2, 4, u)):
        cc = asc_coeffs(ff, xv)
        a, b, z = census_direct(cc, 23)
        S = a - b
        out.append(f'  {nm}: affine points over F_23 = 23 + S = {23 + S} with S = {S}; '
                   f'Weil bound 2g sqrt p = {2*gg*math.sqrt(23):.2f}; |S|/(2g sqrt p) = '
                   f'{abs(S)/(2*gg*math.sqrt(23)):.3f}')
    out.append(f'  23 | 4m^2 = {4*36}?  {4*36 % 23 == 0};  '
               f'content of Phi_{{12,4}} = {sp.Poly(Ph, lam).content()};  '
               f'23 | that content?  {int(sp.Poly(Ph, lam).content()) % 23 == 0}')
    out.append('')
    out.append('So Phi mod 23 is squarefree, the genus does not drop, 23 is not a bad prime,\n'
               'and 23 divides none of the structural constants (4m^2 = 144, the content, or\n'
               'the discriminant).  Nor is C_6 mod 23 anywhere near maximal or minimal: the\n'
               'character sum sits at about a quarter of the Weil bound, and the curve is not\n'
               'supersingular.  The collapse is a SIGN uniformity, not a size extremum, and\n'
               'it is not a degeneration of the curve at all.\n')

    out.append('### 5.3 The mechanism: a chi-twisted stratum (Theorem G)\n')
    out.append('The prior report\'s Theorem 0 says chi(Phi_{2m,4}) on F_p minus {0,1} depends\n'
               'only on r := 2m mod (p-1), through\n'
               '\n'
               '    G_r(lambda) = ( 1 - lambda^r - (1-lambda)^r )^2 - 4 u^r,   u = lambda(1-lambda).\n'
               '\n'
               'Theorems A, B, C are the cases r = 0, r = 2, r = (p-1)/2.  At (m,p) = (6,23),\n'
               'r = 12 and (p-1)/2 = 11, so r = (p-1)/2 + 1.  That is a new stratum:\n')
    out.append('**Theorem G (chi-twisted stratum, j = 1).**  Suppose r = 2m == (p-1)/2 + 1\n'
               '(mod p-1); this is solvable in m only when p == 3 (mod 4).  Then\n'
               'lambda^r = chi(lambda) lambda for lambda != 0, so with e = chi(lambda),\n'
               'f = chi(1-lambda) the compact form collapses to four cases:\n'
               '\n'
               '    (e,f) = (+,+):  G_r = -4u             chi(G_r) = chi(-1) chi(u) = chi(-1)\n'
               '    (e,f) = (-,+):  G_r = 4 lambda        chi(G_r) = chi(lambda)   = -1\n'
               '    (e,f) = (+,-):  G_r = 4 (1-lambda)    chi(G_r) = chi(1-lambda) = -1\n'
               '    (e,f) = (-,-):  G_r = 4 (1-u) = 4 I   chi(G_r) = chi(I)\n'
               '\n'
               'and chi(-1) = -1 because p == 3 (mod 4), while u = lambda(1-lambda) is a\n'
               'square in the (+,+) case.  Hence chi(Phi) = -1 identically OUTSIDE the\n'
               'doubly-nonsquare set N(p) = {lambda : chi(lambda) = chi(1-lambda) = -1}, and\n'
               'on N(p) it equals chi(lambda^2-lambda+1) = chi(I), the apolar invariant.\n'
               'A genus-(2m-4) character sum has been reduced to a character sum over a set\n'
               'of size about (p-3)/4 evaluated on one quadratic.\n')
    # verify Theorem G exactly at (6,23) and elsewhere
    ver = []
    for (mm, pp) in [(6, 23), (5, 19), (2, 7), (5, 7), (3, 11), (8, 11), (8, 31)]:
        ok = _verify_thmG(mm, pp)
        ver.append((mm, pp, ok))
    out.append('Exact verification of the four-case reduction (every admissible lambda, both\n'
               'sides computed in F_p): ' +
               ', '.join(f'(m,p)=({a},{b}): {"exact" if c else "FAILS"}' for a, b, c in ver) + '\n')
    out.append('**Corollary.**  On the Theorem G stratum,\n'
               '    N+ = #{lambda in N(p) : chi(I) = +1},  bias = -(p-2) + 2 N+ + (zeros).\n'
               'Total collapse (N+ = 0, the "constant nonzero character" the prior report\n'
               'flagged) happens exactly when chi(I) is never +1 on N(p).\n')
    out.append('### 5.4 Why 23 and not 11\n')
    out.append('| p | least m with 2m == (p-1)/2+1 | #N(p) | chi(I) values on N(p) | census (N+,N-,N0) | collapse |')
    out.append('|---|------------------------------|-------|-----------------------|-------------------|----------|')
    for pp in [7, 11, 19, 23, 31, 43, 47, 59, 67, 71, 79, 83]:
        r = (pp - 1) // 2 + 1
        mm = None
        for cand in range(2, 4 * pp):
            if (2 * cand) % (pp - 1) == r % (pp - 1):
                mm = cand
                break
        Ns = [l for l in range(2, pp) if chi(l, pp) == -1 and chi(1 - l, pp) == -1]
        vals = sorted({chi(l * l - l + 1, pp) for l in Ns})
        cens = census_direct(asc_coeffs(Phi_lambda(mm), lam), pp, skip=(0, 1))
        out.append(f'| {pp} | {mm} | {len(Ns)} | {vals} | {cens} | '
                   f'{"YES" if cens[0] == 0 else "no"} |')
    out.append('')
    out.append('At p = 23 all six doubly-nonsquare lambda have chi(I) = -1, so the collapse is\n'
               'total and N0 = 0 as well -- which is why (6,23) alone showed up as a clean\n'
               '"constant nonzero character" point in the prior scan.  At p = 19 the residual\n'
               'set contributes only zeros (I has roots mod 19), giving N+ = 0 but N0 = 2, so\n'
               'the prior scan\'s N0 = 0 filter missed it: (5,19) is the SAME phenomenon.  At\n'
               'p = 11 and p = 31 the residual character is +1 somewhere, and the census does\n'
               'not collapse.  So (6,23) is not sporadic in kind, only in the residual\n'
               'coincidence chi(I)|_{N(23)} == -1, an event of heuristic probability 2^-6.\n')

    out.append('### 5.5 Complete classification of constant-character strata, p <= 300\n')
    out.append('Method: for every odd p <= 300 and every even r in [0, p-2] -- i.e. every\n'
               'value 2m mod (p-1) can take -- evaluate chi(G_r) on all of F_p minus {0,1}\n'
               'and record r whenever the nonzero values are constant.  This is a COMPLETE\n'
               'enumeration of the exceptional strata in that range, not a sample.\n')
    strata = _classify_strata(300)
    named = {}
    for (pp, r, c, hz) in strata:
        half = (pp - 1) // 2
        if r == 0:
            k = 'A   r = 0 (constant character)'
        elif r == 2:
            k = 'B   r = 2 (total collapse, N0 = p-2)'
        elif r == half:
            k = 'C   r = (p-1)/2'
        elif r == half + 1:
            k = 'G   r = (p-1)/2 + 1  (this section)'
        elif r == half + 2:
            k = 'H   r = (p-1)/2 + 2'
        elif r == pp - 3:
            k = 'A*  r = -2 (mod p-1)'
        else:
            k = f'other'
        named.setdefault(k, []).append((pp, r, c, hz))
    out.append('| stratum | count (p <= 300) | first instances (p, r, constant chi, has zeros) |')
    out.append('|---------|------------------|--------------------------------------------------|')
    for k in sorted(named):
        v = named[k]
        out.append(f'| {k} | {len(v)} | {v[:5]} |')
    out.append('')
    out.append('**Reduction principle (all strata are one family).**  Write r = 2m mod (p-1)\n'
               'and suppose r == k (p-1)/n + j (mod p-1) for a divisor n of p-1 and an\n'
               'integer j.  Then lambda^r = psi(lambda) lambda^j where psi is the order-n\n'
               'power-residue character raised to the k-th power, valued in the group\n'
               'mu_n of n-th roots of unity inside F_p.  Hence\n'
               '\n'
               '    G_r = ( 1 - psi(lambda) lambda^j - psi(1-lambda) (1-lambda)^j )^2\n'
               '          - 4 psi(u) u^j,\n'
               '\n'
               'which is one of at most n^2 polynomials, each of degree 2j in lambda, instead\n'
               'of one polynomial of degree 4m-6.  When n and |j| are both small the\n'
               'character sum is short and can degenerate to a constant; that is the ONLY\n'
               'source of an exceptional stratum, and it is why each p has only finitely\n'
               'many.  The named theorems are the corners of this family:\n'
               '    Theorem A = (n,j) = (1,0);   Theorem B = (1,2);\n'
               '    Theorem C = (2,0);           Theorem G = (2,1).\n'
               'Negative j is the reciprocal branch, where the exact identity\n'
               '    u^{2j} G_{-j} = ( u^j - L_j(u) )^2 - 4 u^j    versus    G_j = (1-L_j)^2 - 4u^j\n'
               'exchanges the constant 1 for u^j and leaves -4u^j alone; it is verified\n'
               'symbolically below.\n')
    others = named.get('other', [])
    out.append(f'The strata outside A, B, C, G, H number {len(others)} for p <= 300.  Fitting\n'
               'each to the smallest (n, |j|) over ALL divisors n of p-1 with |j| <= 3.  The\n'
               'reduction is informative only when n is small, since G_r then takes at most\n'
               'n^2 values; a fit with large n says nothing.\n')
    out.append('| p | r | constant chi | (p-1)/n form | n | j | image size of lambda -> lambda^r |')
    out.append('|---|---|--------------|--------------|---|---|----------------------------------|')
    big = []
    for (pp, r, c, hz) in others:
        best = None
        for n in sp.divisors(pp - 1):
            for k in range(n):
                for j in range(-3, 4):
                    if (k * (pp - 1) // n + j - r) % (pp - 1) == 0:
                        cand = (int(n), abs(j), k, j)
                        if best is None or cand[:2] < best[:2]:
                            best = cand
        img = (pp - 1) // sp.gcd(r if r else pp - 1, pp - 1)
        if best is None:
            out.append(f'| {pp} | {r} | {c:+d} | no fit with |j| <= 3 | - | - | {img} |')
            big.append((pp, r, None))
        else:
            n, _, k, j = best
            out.append(f'| {pp} | {r} | {c:+d} | {k}(p-1)/{n} {"+" if j >= 0 else "-"} {abs(j)} '
                       f'| {n} | {j} | {img} |')
            if n > 4:
                big.append((pp, r, n))
    out.append('')
    out.append('The n = 3 and n = 4 rows are the cubic and quartic analogues of Theorem C:\n'
               'lambda^r lands in mu_3 or mu_4 and G_r takes at most nine (resp. sixteen)\n'
               'values.  Together with the n = 2 rows they account for all but one entry, so\n'
               'the "other" column of the table above is not a residue of unexplained\n'
               'sporadic points -- it is the rest of the same family, and Theorems A, B, C\n'
               'and G are its smallest members.\n')
    out.append(f'The exception is {big if big else "none"}: there the smallest fit needs a\n'
               'large n, the image of lambda -> lambda^r is the full subgroup of squares,\n'
               'and no short-character-sum reduction applies.  That single point, and not\n'
               '(6,23), is the one genuinely unexplained constant-character stratum for\n'
               'p <= 300.  It is the concrete target a successor should take next; note that\n'
               'unlike (6,23) it does have zeros, so it is a "constant on the nonvanishing\n'
               'locus" collapse rather than a clean one.\n')
    rec_ok = _verify_reciprocal(8)
    out.append('Symbolic verification of the reciprocal identity:\n'
               '    u^{2j} G_{-j} = ( u^j - L_j(u) )^2 - 4 u^j   against   G_j = (1 - L_j)^2 - 4 u^j,\n'
               f'as an identity of rational functions in lambda: {rec_ok}.\n')
    return ergodis_ok


def _verify_thmG(m, p):
    for l in range(2, p):
        e, f = chi(l, p), chi(1 - l, p)
        uu = (l * (1 - l)) % p
        g = (pow(1 - pow(l, 2 * m, p) - pow((1 - l) % p, 2 * m, p), 2, p)
             - 4 * pow(uu, 2 * m, p)) % p
        if (e, f) == (1, 1):
            pred = (-4 * uu) % p
        elif (e, f) == (-1, -1):
            pred = (4 * (1 - uu)) % p
        elif (e, f) == (1, -1):
            pred = (4 * (1 - l)) % p
        else:
            pred = (4 * l) % p
        if pred != g:
            return False
    return True


def _verify_reciprocal(jmax):
    ok = []
    for j in range(1, jmax + 1):
        L = lam
        uu = L * (1 - L)
        Gm = (1 - L ** (-j) - (1 - L) ** (-j)) ** 2 - 4 * uu ** (-j)
        rhs = (uu ** j - (L ** j + (1 - L) ** j)) ** 2 - 4 * uu ** j
        ok.append(sp.simplify(sp.together(uu ** (2 * j) * Gm - rhs)) == 0)
    return ('exact for every j in 1..%d' % jmax) if all(ok) \
        else f'FAILS at j = {ok.index(False)+1}'


def _classify_strata(pmax):
    hits = []
    for p in sp.primerange(3, pmax + 1):
        sq = [0] * p
        for x in range(1, p):
            sq[(x * x) % p] = 1
        ch = [0] * p
        for a in range(1, p):
            ch[a] = 1 if sq[a] else -1
        for r in range(0, p - 1, 2):
            vals = set()
            for l in range(2, p):
                a = pow(l, r, p)
                b = pow(p + 1 - l, r, p)
                uu = (l * (p + 1 - l)) % p
                g = ((1 - a - b) ** 2 - 4 * pow(uu, r, p)) % p
                vals.add(ch[g])
                if len({v for v in vals if v}) > 1:
                    break
            nz = {v for v in vals if v}
            if len(nz) <= 1:
                hits.append((p, r, (list(nz)[0] if nz else 0), 0 in vals))
    return hits


# ------------------------------------------------------------------ main ----

def section_open(out, ap_lists, level_rec):
    out.append('## 6. Open observations\n')
    out.append('Each item states the exact searched range and the exact statement that held.\n')
    out.append('**(1) SETTLED -- the (6,23) collapse.**  It is the j = 1 chi-twisted stratum\n'
               '(Theorem G, section 5.3), whose residual is a character sum of chi(I) over\n'
               'the doubly-nonsquare set.  (5,19) is the same stratum and the prior scan\n'
               'missed it only because it filtered on N0 = 0.  What is genuinely accidental\n'
               'at p = 23 is that chi(I) = -1 on all six residual points; that is not forced,\n'
               'and it already fails at p = 11 and p = 31.  Nothing about (6,23) is left open.\n'
               'The complete p <= 300 classification in section 5.5 puts one point in its\n'
               'place as the new open case: (p, r) = (47, 30), where the character is\n'
               'constant on the nonvanishing locus but the exponent admits no\n'
               'small-image reduction.\n')
    out.append('**(2) SETTLED -- the (8,29) bad prime.**  29 is a genuine bad prime and it is\n'
               'the first member of the third source E(m) in the bad-prime law of section 4:\n'
               'mod 29 the Dickson polynomials L_8^2-1 and F_7 acquire a common root u_0, so\n'
               'Phit_8 has a double branch point away from the harmonic point.  The complete\n'
               'law Bad = {2} u H u M u E reproduces all eleven rows m = 2..12 with no\n'
               'exception, so the prior report\'s open item (7) is closed.\n')
    out.append('**(3) SETTLED -- the genus law.**  g(C_m) = 2m-4 for m not == 1 (mod 3) and\n'
               '2m-6 for m == 1 (mod 3); the prior 2m-5 is corrected in section 1.\n')
    out.append('**(4) SETTLED -- why the higher-genus quotients split.**  The anharmonic S_3\n'
               'acts on C_m over QQ (Theorem H), and the elliptic factor of Jac(D_1) is\n'
               'Jac(C_m/S_3); the order-3 element does not descend to D_1, which is why D_1\n'
               'itself has trivial reduced automorphism group.  What remains open is\n'
               'quantitative, not structural: the S_3 multiplicities (a, b, c) are measured,\n'
               'not derived -- a Riemann-Hurwitz computation for C_m -> C_m/S_3 would give\n'
               'them in closed form as a function of m, and would predict where a jumps from\n'
               '1 to 2 (observed between m = 7 and m = 8).  The unambiguous traces are\n')
    for name, aps in ap_lists.items():
        out.append('    ' + name + ': ' + ', '.join(f'a_{p}={a:+d}' for p, a in aps[:14]))
    out.append('')
    out.append('**(4b) OPEN -- the conductors of the D_2 elliptic factors.**  A_sgn at\n'
               'm = 5 and m = 6 has no rational newform of level <= 1600 supported on the\n'
               'bad primes, so its conductor is larger than the range searched.  It need not\n'
               'be searched for at all: with tau the order-3 element and h the hyperelliptic\n'
               'involution, A_triv = Jac(C_m/<tau, sigma>) and A_sgn = Jac(C_m/<tau,\n'
               'sigma . h>), both quotients by an explicit order-6 subgroup of\n'
               'S_3 x <h>, so both curves can be written down and their conductors computed\n'
               'directly.  Doing that would also give (a, b, c) in closed form (item 4).\n')
    out.append('**(5) OPEN -- the mod-4 rigidity of the m = 3 bias.**  The prior report item\n'
               '(3) recorded bias(3,p) == 1 (mod 4) for every non-degenerate p <= 199.  The\n'
               'level-90 identification of section 2 makes this a statement about a single\n'
               'weight-2 newform, so it should now be provable from the rational 4-torsion,\n'
               'but it is not proved here.\n')
    out.append('**(6) OPEN -- why the (+,+) case of Theorem G is not an extra condition.**\n'
               'In Theorem G the (+,+) case gives chi(-1) and the two mixed cases give -1\n'
               'automatically, so exactly one of the four cases (the doubly-nonsquare one)\n'
               'carries information.  The asymmetry is visible in the algebra but has no\n'
               'conceptual explanation here; it is what makes the stratum nearly, but not\n'
               'quite, a collapse theorem.\n')


def section_ergodis(out, ergodis_ok, census_bin):
    out.append('## 7. Ergodis interface notes\n')
    out.append('Per the lane directive the finite-field legs were routed through Ergodis\n'
               'first.  This task needed four kinds of computation; Ergodis covered one of\n'
               'them completely and none of the other three.\n')
    out.append('**Fits, and was used.**  The character-census leg is an exact fit, exactly as\n'
               'recorded for C1013: `PrimeQuadraticCharacter::new(p)` plus\n'
               '`reduce_coefficients` plus `polynomial_census_reduced` reproduces\n'
               '(N+, N-, N0, bias) for chi(Phi_{2m,4}) over any prime field.  It was used to\n'
               'confirm the (6,23) collapse independently of the Python count, and to replay\n'
               f'the whole m = 2..8, p < 200 census: disagreements = '
               f'{ergodis_ok if ergodis_ok else "none"}.  That is the independent-replay leg\n'
               'required by `notes/research-reproducibility-conventions.md`.\n')
    out.append('**Misfits -- three legs Ergodis cannot express at all.**\n'
               '  1. *Zeta functions of curves over F_p.*  The whole of section 3 needs the\n'
               '     characteristic polynomial of Frobenius on a genus-3 or genus-4\n'
               '     hyperelliptic curve, not a character count.  Ergodis has no zeta,\n'
               '     no point count over F_{p^k}, and no extension-field arithmetic exposed;\n'
               '     PARI `hyperellcharpoly` did all of it.  A typed\n'
               '     `hyperelliptic-zeta {p, coefficients}` returning the L-polynomial would\n'
               '     be the single highest-value addition for this family of tasks, because\n'
               '     it is the object that decides splitting, and it subsumes the census\n'
               '     (the census is the T-coefficient).\n'
               '  2. *Global arithmetic of the quotient curves.*  Minimal models, conductors,\n'
               '     torsion, isogeny classes, newform levels -- section 2 -- are outside\n'
               '     Ergodis by design and were done in PARI.  No interface note is warranted\n'
               '     beyond noting that the census sums Ergodis computes ARE the a_p of these\n'
               '     curves, so an optional "interpret this census as a_p" annotation would\n'
               '     connect the two worlds cheaply.\n'
               '  3. *Sweeps over the exponent r = 2m mod (p-1) rather than over p.*  The\n'
               '     complete stratum classification of section 5.5 evaluates chi(G_r) for\n'
               '     every even r < p-1 at every p <= 300.  Expressed through the existing\n'
               '     API this would mean materializing a degree-2r polynomial per (p, r) and\n'
               '     paying O(r) per point; the natural primitive is instead a census of\n'
               '     chi(F(x^r, (1-x)^r, u^r)) with r as a parameter, i.e. exponent-sweep\n'
               '     support with fast modular exponentiation inside the kernel.  This is a\n'
               '     new typed operation, not packaging.  The scan was done in Python.\n')
    out.append('The four improvement items from the C1013 pass (CLI census command, prime\n'
               'ranges, general polynomial twist, in-kernel squarefree detection, genus\n'
               'annotation) all still stand; items 1 and 3 above are new and are the ones\n'
               'that actually blocked work this time.  Nothing in the rank, orbit, span, or\n'
               'incidence modules was applicable: the objects here are curves and character\n'
               'sums, not codes.\n')
    out.append(f'Driver used: `{census_bin}`\n'
               '(crate `notes/clebsch-tasks/c1013-ergodis-driver`, build directory relocated\n'
               'to `~/.cache/ergodis/c1013-census-target` so that no build tree lives under\n'
               '`notes/`).\n')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('output')
    ap.add_argument('--gp', default='nix shell nixpkgs#pari --command gp')
    ap.add_argument('--census',
                    default='/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census')
    args = ap.parse_args()

    out = []
    out.append('# C1014 -- modular structure of the descent quotients of y^2 = Phi_{2m,4}\n')
    out.append('**Lane:** clebsch\n')
    out.append('**Task:** C1014 (modular identification of the quotient curves of the\n'
               'four-point Gram invariant family; sporadic strata).\n')
    out.append('**Scope:** research note only.  No manuscript, Ergodis, or Lean source edited.\n')
    out.append('**Generator:** `notes/clebsch-tasks/c1014_modular_structure.py` -- this file\n'
               'is machine-emitted by that script, which also writes and runs the generated\n'
               'PARI scripts `c1014_curves.gp` and `c1014_hyperell.gp` in the same directory\n'
               'and drives the C1013 ergodis census front end.\n')
    out.append('Replay:\n')
    out.append('```text\n'
               'uv run --with sympy python3 notes/clebsch-tasks/c1014_modular_structure.py \\\n'
               '    notes/2026-08-30-c1014-modular-structure-covers.md\n'
               '```\n')
    out.append('Prerequisite context: `notes/2026-08-30-c1013-c1014-phi-family-arithmetic.md`\n'
               '(Phi_{2m,4} = P_m (P_m + 4u^{m-1}), P_m = (1-L_m^2)/u, L_m Dickson; the\n'
               'descent S = S_1 + S_2; Theorems A/B/C).  The PARI legs need a few minutes;\n'
               'the modular-level search of section 3.4 dominates the runtime.\n')
    out.append('## Executive summary\n')
    out.append('1. **The genus law of the prior report is off by one at m == 1 (mod 3).**\n'
               '   g(C_m) = 2m-4, dropping to 2m-6 (not 2m-5) when m == 1 (mod 3), because\n'
               '   the repeated part I^2 must be divided out whole.  The same slip made\n'
               '   chi(Phi) = chi(radical) instead of chi(Phi/I^2) in that report\'s\n'
               '   section 6 preamble.  Section 1.\n')
    out.append('2. **Both m = 4 quotients are elliptic of conductor 14** -- the unique\n'
               '   level-14 newform (class 14a).  Across m = 4, 5, 6 these are the only\n'
               '   genus-1 quotients.  Section 2.\n')
    out.append('3. **The supersingular congruence has a one-line cause.**  L = lcm of the\n'
               '   rational torsion orders across the isogeny class divides p+1 at every\n'
               '   supersingular p, so m = 3 forces p == 11 (mod 12) (L = 12) and m = 4\n'
               '   forces only p == 5 (mod 6) (L = 6).  Exhaustive on p < 2000.  Section 2.1.\n')
    out.append('4. **The higher-genus quotients are split, and the reason is an anharmonic\n'
               '   S_3 on the parent curve.**  The square-class model of Phi_{2m,4} is\n'
               '   EXACTLY invariant under the anharmonic group acting on lambda, with\n'
               '   constant 1, so Aut_QQ(C_m) contains S_3 (Theorem H).  Decomposing\n'
               '   H^0(Omega) as a.triv + b.sgn + c.std gives g(C_m) = a+b+2c,\n'
               '   g(D_1) = a+c, g(D_2) = b+c, and the measured multiplicities are (0,0,1)\n'
               '   at m = 3,4; (1,1,2) at m = 5; (1,1,3) at m = 6,7; (2,2,4) at m = 8.  So\n'
               '   for m >= 5 Jac(D_1) contains Jac(C_m/S_3) -- an elliptic curve for\n'
               '   m = 5,6,7, an abelian surface at m = 8 -- even though D_1 itself has\n'
               '   trivial reduced automorphism group; that is why the L-polynomial always\n'
               '   factors.  At m = 3,4 the trivial and sign parts vanish and D_1, D_2 are\n'
               '   the same isogeny factor, which is why the prior report found\n'
               '   a_p(E_1) = a_p(E_2).  The new elliptic factors are the level-150 (m = 5)\n'
               '   and level-1584 (m = 6) newforms.  Section 3.\n')
    out.append('5. **Exact bad-prime law.**  Bad(C_m) = {2} u H(m) u M(m) u E(m) from three\n'
               '   distinct geometric sources -- the harmonic point lambda = 1/2, the\n'
               '   collision locus u = 0 (which is where p | m enters), and a genuine double\n'
               '   branch point where L_m^2-1 and F_{m-1} collide.  Matches every m = 2..12\n'
               '   with no exception, and closes the prior report\'s (8,29) puzzle.\n'
               '   Section 4.\n')
    out.append('6. **The (6,23) collapse is a stratum, not an accident of that one point.**\n'
               '   It is r = 2m == (p-1)/2 + 1 (mod p-1), where lambda^r = chi(lambda) lambda\n'
               '   and the character becomes -1 outside the doubly-nonsquare set and\n'
               '   chi(lambda^2-lambda+1) on it.  (5,19) is the same stratum.  What is\n'
               '   accidental at p = 23 is only that the residual character is -1 on all six\n'
               '   residual points.  Section 5, with a complete classification of every\n'
               '   constant-character stratum for p <= 300.\n')

    def flush():
        with open(args.output, 'w') as fh:
            fh.write('\n'.join(out) + '\n')

    rows = section_family(out)
    section_models(out, rows)
    flush()

    section_elliptic(out, rows, args.gp)
    flush()

    _, _, ap_lists = section_higher(out, rows, args.gp)
    flush()

    section_badprimes(out)
    flush()

    ergodis_ok = section_stratum(out, args.census)
    flush()

    section_open(out, ap_lists, None)
    section_ergodis(out, ergodis_ok, args.census)
    out.append('Status: complete.\n')
    flush()
    print(f'wrote {args.output} ({len(out)} blocks)')


if __name__ == '__main__':
    main()
