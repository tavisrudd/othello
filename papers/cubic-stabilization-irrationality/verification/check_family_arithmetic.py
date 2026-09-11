from __future__ import annotations

import argparse
import itertools
import json
import sys
from fractions import Fraction
from itertools import combinations_with_replacement
from math import gcd, isqrt, prod
from pathlib import Path

import sympy as sp


def check(condition: bool, message: str) -> None:
    if not condition:
        raise ArithmeticError(message)

def coefficient_vector(poly: sp.Expr, variables: tuple, monomials: list) -> sp.Matrix:
    polynomial = sp.Poly(poly, *variables)
    return sp.Matrix([polynomial.coeff_monomial(m) for m in monomials])

def signed_permutation_group(generators: tuple[tuple[int, ...], ...]) -> set:
    identity = tuple(range(1, len(generators[0]) + 1))
    group, pending = {identity}, [identity]
    while pending:
        element = pending.pop()
        for generator in generators:
            product = tuple(
                (1 if i > 0 else -1) * generator[abs(i) - 1] for i in element
            )
            if product not in group:
                group.add(product)
                pending.append(product)
    return group

def family_checks() -> dict:
    u, v, x, z, y = sp.symbols("u v x z y")
    variables = (u, v, x, z, y)
    cubic_monomials = [
        sp.prod(variables[i] for i in indices)
        for indices in combinations_with_replacement(range(5), 3)
    ]
    seed = (
        (z - x) * u**2 + 6*y*u*v + 3*(z + x)*v**2 - z**3
        + sp.Rational(3, 4)*(x**2 + 3*y**2)*z + y**3
    )
    derivatives = [sp.diff(seed, variable) for variable in variables]
    jacobian_basis = sp.groebner(derivatives, *variables)
    pure_power_remainders = [jacobian_basis.reduce(variable**6)[1] for variable in variables]
    check(all(remainder == 0 for remainder in pure_power_remainders), "Seed smoothness check failed")
    deformations = (x**3, x**2*y, y**3)
    orbit = sp.Matrix.hstack(*(
        coefficient_vector(variable*derivative, variables, cubic_monomials)
        for variable in variables for derivative in derivatives
    ))
    family_directions = sp.Matrix.hstack(*(
        coefficient_vector(monomial, variables, cubic_monomials)
        for monomial in deformations
    ))
    cubic_ranks = (orbit.rank(), orbit.row_join(family_directions).rank())
    check(cubic_ranks == (25, 28), "Cubic moduli rank check failed")

    a, t, s, beta, w, h = sp.symbols("a t s beta w h")
    A = a**2 + 3
    c = t**3 - sp.Rational(3, 4)*A*t - beta
    discriminant = sp.factor(sp.discriminant(c, t))
    expected_discriminant = sp.Rational(27, 16)*A**3 - 27*beta**2
    check(sp.expand(discriminant - expected_discriminant) == 0, "Cubic discriminant failed")
    e_plus_sq = (s-a)*c.subs(t, s)
    e_minus_sq = (-s-a)*c.subs(t, -s)
    norm_remainder = sp.rem(sp.expand(e_plus_sq*e_minus_sq-discriminant/9), s**2-A, s)
    check(norm_remainder == 0, "Component splitting norm identity failed")

    Q1 = -a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2 - z*h
    Q2 = u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2 - z**2 + w*h
    pencil_matrix = sp.hessian(Q1+t*Q2, (u, v, w, z, h))/2
    pencil_determinant = sp.factor(pencil_matrix.det())
    check(sp.expand(pencil_determinant-sp.Rational(3, 4)*(t**2-A)*c) == 0,
          "Quadrics pencil determinant failed")
    generic_cubic = (
        w*(-a*u**2 + 6*u*v + 3*a*v**2 + beta*w**2)
        + z*(u**2 + 3*v**2 + sp.Rational(3, 4)*A*w**2-z**2)
    )
    check(sp.expand(w*Q1+z*Q2-generic_cubic) == 0, "Birational projection identity failed")
    point = {u: 0, v: 0, w: 0, z: 0, h: 1}
    check(Q1.subs(point) == 0 and Q2.subs(point) == 0, "Rational point failed")

    r1, r2 = sp.symbols("r1 r2")
    r3 = -r1-r2
    root_A = sp.Rational(4, 3)*(r1**2+r1*r2+r2**2)
    check(sp.expand((r2-r3)**2-3*(root_A-r1**2)) == 0, "Root-difference identity failed")
    generators = (
        (1, 2, 3, 5, 4),
        (1, 2, 3, -4, -5),
        (2, 3, 1, 4, 5),
        (-1, -3, -2, 4, -5),
    )
    group = signed_permutation_group(generators)
    check(len(group) == 24, "Signed permutation group order failed")
    check(all(sum(i < 0 for i in g) % 2 == 0 for g in group), "Group not in W(D5)")

    sextic = 16*y**6-(x**2+3*y**2)**3
    sextic_monomials = [x**i*y**(6-i) for i in range(7)]
    binary_variables = (x, y)
    sextic_orbit = sp.Matrix.hstack(*(
        coefficient_vector(q*sp.diff(sextic, r), binary_variables, sextic_monomials)
        for q in binary_variables for r in binary_variables
    ))
    sextic_directions = sp.Matrix.hstack(*(
        coefficient_vector(32*y**3*m, binary_variables, sextic_monomials)
        for m in deformations
    ))
    genus_two_ranks = (sextic_orbit.rank(), sextic_orbit.row_join(sextic_directions).rank())
    check(genus_two_ranks == (4, 7), "Genus-two moduli rank failed")
    affine_sextic = sextic.subs({x: a, y: 1})
    sextic_gcd = sp.gcd(affine_sextic, sp.diff(affine_sextic, a))
    check(sextic_gcd == 1, "Seed genus-two curve is not smooth")

    return {
        "sympy_version": sp.__version__,
        "all_checks_passed": True,
        "scope": "Finite algebraic checks only; the geometric argument and its dependencies are stated in the proof packet, Part V.",
        "seed_cubic": str(seed),
        "seed_smoothness": {
            "sixth_power_remainders": dict(zip(map(str, variables), map(str, pure_power_remainders))),
            "jacobian_groebner_basis": [str(p.as_expr()) for p in jacobian_basis.polys],
        },
        "cubic_moduli": {
            "orbit_rank": cubic_ranks[0],
            "augmented_rank": cubic_ranks[1],
            "independent_directions": list(map(str, deformations)),
            "direction_remainders": [str(jacobian_basis.reduce(m)[1]) for m in deformations],
        },
        "quartic_del_pezzo": {
            "quadrics": [str(Q1), str(Q2)],
            "pencil_determinant": str(pencil_determinant),
            "cubic_discriminant": str(discriminant),
            "component_norm_identity_remainder": str(norm_remainder),
        },
        "type_I3": {"generators": generators, "group_order": len(group)},
        "genus_two": {
            "seed_sextic": str(sp.expand(sextic)),
            "squarefree_gcd": str(sextic_gcd),
            "orbit_rank": genus_two_ranks[0],
            "augmented_rank": genus_two_ranks[1],
        },
    }

def lattice_checks():
    A = sp.Matrix([[-1,0,0,-1,-1],[1,1,1,0,2],[0,0,-1,-1,-1],[0,0,0,0,1],[0,0,0,1,0]])
    B = sp.Matrix([[0,1,1,1,2],[-1,-1,0,0,-1],[0,0,1,0,0],[0,0,0,1,0],[0,0,-1,-1,-1]])
    ranks = [sp.Matrix.vstack(A-e*sp.eye(5), B-f*sp.eye(5)).rank() for e,f in itertools.product((-1,1), repeat=2)]
    m = sp.Matrix([-1,-1,-3,-3,3])
    assert A*m == -m and B*m == m
    weights = {f'E{i+1}': tuple(int(j == i) for j in range(4))+(0,) for i in range(5)}
    for i,j in itertools.combinations(range(5),2):
        weights[f'L{i+1}{j+1}'] = tuple(-int(k in (i,j)) for k in range(4))+(1,)
    weights['Q'] = (-1,-1,-1,-1,2)
    restriction = lambda w: (w[1]-w[0],w[2]-3*w[0],w[3]-3*w[0],w[4]+3*w[0])
    reduced = {name: restriction(w) for name,w in weights.items()}
    assert len(set(reduced.values())) == 16
    unimodular = sum(abs(int(sp.Matrix.hstack(*(sp.Matrix(reduced[n])-sp.Matrix(reduced[sub[0]]) for n in sub[1:])).det())) == 1 for sub in itertools.combinations(reduced,5))
    affine_actions = []
    weight_to_name = {w:name for name,w in weights.items()}
    for g in (A,B):
        candidates=[]
        for shift in weights.values():
            images={name: tuple(g*sp.Matrix(w)+sp.Matrix(shift)) for name,w in weights.items()}
            if set(images.values()) == set(weight_to_name):
                candidates.append({name:weight_to_name[w] for name,w in images.items()})
        assert len(candidates)==1
        affine_actions.append(candidates[0])
    unseen=set(weights)
    orbits=[]
    while unseen:
        orbit={min(unseen)}
        while True:
            new=orbit | {g[name] for g in affine_actions for name in orbit}
            if new==orbit:
                break
            orbit=new
        unseen-=orbit
        orbits.append(sorted(orbit))
    N3=sp.eye(5)[:,2:]
    cocharacter_actions=[g.inv().T[2:,2:] for g in (A,B)]
    for g,h in zip((A,B),cocharacter_actions):
        assert g.inv().T*N3==N3*h
    expected=(sp.Matrix([[-1,0,0],[-1,0,1],[-1,1,0]]),sp.Matrix([[1,0,-1],[0,1,-1],[0,0,-1]]))
    assert tuple(cocharacter_actions)==expected
    residual_vectors={(0,1),(1,-1),(-1,0)}
    for g in (A,B):
        assert {tuple(g[:2,:2]*sp.Matrix(v)) for v in residual_vectors}==residual_vectors
    assert ranks==[5,4,5,5] and unimodular==1992
    assert sorted(map(len,orbits))==[4,12]
    return {'stacked_ranks':ranks,'primitive_character':list(m),'five_subsets':4368,'unimodular_subsets':unimodular,'orbits':orbits,'rank_three_cocharacter_actions_verified':True,'residual_norm_one_lattice_verified':True}

def certificate_polynomials():
    a,b,h=sp.symbols('a b h')
    D=[
      (8*a-27)**2*(3968*a-1349*b-2619),
      568453977*a**3-373279764*a*a*b-1658788404*a*a+59068867*a*b*b+976763788*a*b+925668016*a-128537024*b*b-359163728*b-10185728,
      1643918400*a**3-1105797420*a*a*b-7261914240*a*a+154718524*a*b*b+3804690316*a*b+9944961600*a-282623593*b*b-3443769343*b-3454184244,
      35068545*a**3+2864538*a*a*b-236376549*a*a-5350827*a*b*b+24417420*a*b+469658574*a+14536855*b*b-90750394*b-214068162,
    ]
    M=[
      -4*(a-1)*(b-7)*(3*a-b-2)*(2*a*b+7*a-9*b),
      -9*(a-1)*(2*b-11)*(3*a-b-2)*(4*a*b+11*a-15*b),
      -25*(a-1)*(3*b-13)*(2*a-b-1)*(3*a*b+13*a-16*b),
      -(a-1)*(4*b-17)*(13*a-5*b-8)*(32*a*b+85*a-117*b),
    ]
    delta=a*b*(a-1)*(b-1)*(a-b)
    q0=31223016*b*b-435944529*b+1306078948
    q4=83246*b*b-872181*b+2185995
    bezout=(2265746679974131615-377042650728395274*b)*q0+(141417109727495582904*b-1342668830289072756147)*q4
    assert sp.expand(bezout)==24176690547344887359179755
    evaluations=[q0.subs(b,sp.Rational(17,4)),q0.subs(b,sp.Rational(85,16)),q4.subs(b,sp.Rational(26,3)),q4.subs(b,sp.Rational(13,3))]
    assert evaluations==[sp.Rational(69121705,4),sp.Rational(-4117757269,32),sp.Rational(7918133,9),sp.Rational(-272530,9)]
    line_factor=-(b-1)**4*(4*b-17)*(16*b-85)*q4
    ratio=sp.factor((D[3]*M[3]).subs(a,(b+2)/3)/line_factor)
    assert ratio.is_Rational and ratio != 0
    result={}
    for choices in itertools.product((0,1),repeat=3):
        equations=[(D,M)[choice][i] for i,choice in enumerate(choices)]
        gb=sp.groebner(equations+[h*delta-1],h,a,b,domain=sp.QQ)
        name=''.join(('D','M')[choice]+str(i+1) for i,choice in enumerate(choices))
        expected_empty=choices not in ((1,1,0),(1,1,1))
        assert (list(gb)==[1])==expected_empty
        if not expected_empty:
            assert gb.reduce(3*a-b-2)[1]==0
            residual=q0 if choices==(1,1,0) else (3*b-26)*(3*b-13)
            assert gb.reduce(residual)[1]==0
            target=sp.groebner([3*a-b-2,residual,h*delta-1],h,a,b,domain=sp.QQ)
            assert all(target.reduce(p.as_expr())[1]==0 for p in gb.polys)
        result[name]='empty' if expected_empty else str(sp.factor(residual))
    return {'localized_cases':result,'bezout_constant':str(sp.expand(bezout)),'line_restriction_factor':str(ratio),'linear_root_exclusion_values':list(map(str,evaluations)),'scope':'Checks printed polynomial cover; does not reconstruct tangent determinants from Cox quadrics.'}

def tangent_checks() -> dict:
    a,b=sp.symbols('a b')
    names='E1 E2 E3 E4 E5 L12 L13 L14 L15 L23 L24 L25 L34 L35 L45 Q'.split()
    symbols=sp.symbols(' '.join(names))
    coords=dict(zip(names,symbols))
    E1,E2,E3,E4,E5,L12,L13,L14,L15,L23,L24,L25,L34,L35,L45,Q=symbols
    equations=[E2*L12-E3*L13+E4*L14,
        a*E2*L12-b*E3*L13+E5*L15,
        E1*L12-E3*L23+E4*L24,
        E1*L12-b*E3*L23+E5*L25,
        E1*L13-E2*L23+E4*L34,
        E1*L13-a*E2*L23+E5*L35,
        (b-1)*E1*L14+(a-b)*E2*L24+E5*L45,
        a*L23*L45+(a-b)*L24*L35-E1*Q]
    def point(z,e):
        z1,z2,z3=z
        lines=[z3,z2,z2-z3,b*z2-a*z3,z1,z1-z3,b*z1-z3,z1-z2,a*z1-z2,(b-a)*z1+(1-b)*z2+(a-1)*z3]
        indices=[(0,1),(0,2),(0,3),(0,4),(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)]
        conic=b*(1-a)*z1*z2+a*(b-1)*z1*z3+(a-b)*z2*z3
        values=list(map(sp.Integer,e))+[sp.sympify(line)/(e[i]*e[j]) for line,(i,j) in zip(lines,indices)]+[conic/sp.prod(e)]
        return dict(zip(symbols,values))
    witnesses=[((1,3,7),(2,3,5,7,11),(2,4,9)),((2,5,11),(3,4,7,13,17),(1,6,10)),((3,8,13),(5,7,11,17,19),(2,9,15)),((4,9,17),(2,5,11,19,23),(3,10,18))]
    D=[(8*a-27)**2*(3968*a-1349*b-2619),568453977*a**3-373279764*a*a*b-1658788404*a*a+59068867*a*b*b+976763788*a*b+925668016*a-128537024*b*b-359163728*b-10185728,1643918400*a**3-1105797420*a*a*b-7261914240*a*a+154718524*a*b*b+3804690316*a*b+9944961600*a-282623593*b*b-3443769343*b-3454184244,35068545*a**3+2864538*a*a*b-236376549*a*a-5350827*a*b*b+24417420*a*b+469658574*a+14536855*b*b-90750394*b-214068162]
    M=[-4*(a-1)*(b-7)*(3*a-b-2)*(2*a*b+7*a-9*b),-9*(a-1)*(2*b-11)*(3*a-b-2)*(4*a*b+11*a-15*b),-25*(a-1)*(3*b-13)*(2*a-b-1)*(3*a*b+13*a-16*b),-(a-1)*(4*b-17)*(13*a-5*b-8)*(32*a*b+85*a-117*b)]
    groups=['L13 L23 L35','L14 L24 L45','E1 E2 E5','L12 L15 L25']
    group_indices=[[names.index(n) for n in group.split()] for group in groups]
    minor_indices=[names.index(n) for n in 'E1 E2 E5 L12 L13 L14 L15 L23'.split()]
    boundary_indices=[names.index(n) for n in 'E3 E4 L34 Q'.split()]
    jac=sp.Matrix(equations).jacobian(symbols)
    out=[]
    for i,(z,e,zp) in enumerate(witnesses):
        p=point(z,(1,1,1,1,1)); x=point(zp,e)
        assert all(sp.expand(f.subs(p))==0 and sp.expand(f.subs(x))==0 for f in equations)
        J=jac.subs(p)
        minor=sp.factor(J[:,minor_indices].det(method='domain-ge'))
        assert sp.expand(minor-M[i])==0
        kernel=J[:,boundary_indices].T.nullspace()
        assert len(kernel)==4
        H=sp.Matrix.vstack(*(v.T*J for v in kernel)).applyfunc(sp.cancel)
        assert H[:,boundary_indices]==sp.zeros(4)
        ev=sp.Matrix(4,4,lambda r,c:sum(H[r,j]*x[symbols[j]] for j in group_indices[c]))
        determinant=sp.factor(ev.det(method='domain-ge'))
        ratio=sp.factor(determinant/D[i])
        assert ratio.is_Rational and ratio!=0, (i,ratio)
        out.append({'witness':i+1,'jacobian_minor_matches':True,'evaluation_determinant_ratio':str(ratio),'eight_quadrics_vanish_at_both_points':True})
    result={'revision':'f46624d','checks':out,'scope':'Independent reconstruction from the eight printed Cox quadrics. This does not replay the separate all-twenty-quadrics certificate.'}
    return result

def require(condition: bool, message: str) -> None:
    if not condition:
        raise ArithmeticError(message)

def elliptic_and_smoothness_checks() -> dict:
    t, x, y, z, u, v, r, X, Y, Z = sp.symbols('t x y z u v r X Y Z')
    q = x*x + 3*y*y
    g = -z**3 + sp.Rational(3, 4)*q*z + t*y**3
    cubic = (z-x)*u*u + 6*y*u*v + 3*(z+x)*v*v + g
    weierstrass = Y*Y*Z - X**3 + 27*X*X*Z - 1728*t*t*Z**3
    transformed = weierstrass.subs({X: -12*t*y, Y: 36*t*x, Z: z}, simultaneous=True)
    require(sp.expand(transformed - 1728*t*t*g) == 0, 'Elliptic coordinate change failed')
    a, b = -243, 1728*t*t-1458
    short_model = Y*Y*Z - X**3 - a*X*Z*Z - b*Z**3
    short_transform = short_model.subs({X: -12*t*y-9*z, Y: 36*t*x, Z: z}, simultaneous=True)
    require(sp.expand(short_transform - 1728*t*t*g) == 0, 'Short Weierstrass coordinate change failed')
    discriminant = sp.factor(-16*(4*a**3+27*b*b))
    c4 = -48*a
    j = sp.factor(c4**3 / discriminant)
    require(discriminant == -2**12*3**9*t*t*(16*t*t-27), 'Elliptic discriminant failed')
    require(j == -sp.Rational(19683)/(t*t*(16*t*t-27)), 'j-invariant failed')
    sextic_C = 16*t*t-(r*r+3)**3
    sextic_H = 32*t*r**3-(r*r+3)**3
    disc_C = sp.factor(sp.discriminant(sextic_C, r))
    disc_H = sp.factor(sp.discriminant(sextic_H, r))
    require(sp.factor(disc_C/(t**8*(16*t*t-27))).is_Integer, 'Unexpected C branch factors')
    require(sp.factor(disc_H/(t**4*(16*t*t-27))).is_Integer, 'Unexpected H branch factors')
    require(sp.factor(disc_C/(t**8*(16*t*t-27))) != 0, 'C discriminant identically zero')
    require(sp.factor(disc_H/(t**4*(16*t*t-27))) != 0, 'H discriminant identically zero')
    variables = (u, v, x, y, z)
    smooth_samples = []
    for value, prime in [(1, 5), (1, 7), (5, 7), (7, 13)]:
        F = sp.expand(4*cubic.subs(t, value))
        basis = sp.groebner([sp.diff(F, w) for w in variables], *variables, modulus=prime)
        remainders = [basis.reduce(w**6)[1] for w in variables]
        require(all(a == 0 for a in remainders), 'Sample cubic geometric smoothness check failed')
        smooth_samples.append({'parameter': value, 'prime': prime, 'sixth_powers_in_jacobian_ideal': True})
    return {
        'cubic': str(cubic), 'elliptic_plane_cubic': str(g),
        'weierstrass_equation': 'Y^2 Z = X^3 - 27 X^2 Z + 1728 t^2 Z^3',
        'coordinate_change': {'X': '-12*t*y', 'Y': '36*t*x', 'Z': 'z'},
        'short_weierstrass_a': a, 'short_weierstrass_b': str(b),
        'short_coordinate_change': {'X': '-12*t*y-9*z', 'Y': '36*t*x', 'Z': 'z'},
        'c4': c4, 'discriminant': str(discriminant), 'j': str(j),
        'C_discriminant': str(disc_C), 'H_discriminant': str(disc_H),
        'smoothness_samples': smooth_samples,
        'scope': 'Uniform smoothness and the geometric elliptic factor are proved in the note.'
    }

def prime_sequence(length: int) -> list[int]:
    if length < 1:
        raise ValueError('Sequence length must be positive')
    values = [1]
    while len(values) < length:
        candidate = 5
        while any(a*(16*a*a-27) % candidate == 0 for a in values):
            candidate = int(sp.nextprime(candidate))
        values.append(candidate)
    return values

def prime_certificates(length: int) -> dict:
    values = prime_sequence(length)
    certificates = []
    for index, prime in enumerate(values[1:], start=1):
        require(sp.isprime(prime) and prime >= 5, 'New parameter not a permitted prime')
        old_residues = [int(a*(16*a*a-27) % prime) for a in values[:index]]
        require(all(old_residues), 'A predecessor has a bad reduction factor at the new prime')
        require((16*prime*prime-27) % prime != 0, 'Unexpected extra j-denominator valuation')
        require(19683 % prime != 0, 'Numerator changes the j-valuation')
        certificates.append({
            'parameter': prime, 'separating_prime': prime,
            'predecessor_good_reduction_residues': old_residues,
            'new_elliptic_j_valuation': -2
        })
    return {'parameters': values, 'certificates': certificates,
            'scope': 'Certifies the elementary local conditions; invokes written reduction and Hodge arguments for nonbirationality.'}

def quartic_j(f: sp.Expr, x: sp.Symbol) -> sp.Expr:
    a, b, c, d, e = sp.Poly(f, x).all_coeffs()
    i = 12*a*e - 3*b*d + c*c
    j = 72*a*c*e + 9*b*c*d - 27*a*d*d - 27*b*b*e - 2*c**3
    return sp.factor(6912*i**3 / (4*i**3-j*j))

def elliptic_quotients() -> dict:
    x, t, k, z, v, s = sp.symbols('x t k z v s')
    c = 16*t*t - (x*x+3)**3
    c_plus = 16*t*t-(z+3)**3
    c_minus = z*(16*t*t-(z+3)**3)
    assert sp.expand(c_plus.subs(z, x*x)-c) == 0
    assert sp.expand(c_minus.subs(z, x*x)-x*x*c) == 0
    c_j = quartic_j(c_minus, z)
    assert sp.factor(c_j + 2**12*3**6*t*t/(16*t*t-27)**2) == 0

    h = (x*x+1)**3-k*x**3
    for sign in (1, -1):
        target = (z+2*sign)*(z**3-k)
        lhs = h*(x+sign)**2/x**4
        assert sp.factor(lhs-target.subs(z, x+1/x)) == 0
        expected = sign*55296*k/(k+sign*8)**2
        assert sp.factor(quartic_j(target, z)-expected) == 0

    js = [sp.Integer(0), 432/(s*s*(1-s*s)),
          -6912*s*s/(s*s-1)**2,
          6912*s/(s+1)**2, -6912*s/(s-1)**2]
    degree = lambda f: max(sp.degree(q, s) for q in sp.fraction(sp.cancel(f)))
    assert [degree(j) for j in js[1:]] == [4, 4, 2, 2]
    assert sp.factor(js[2].subs(s, 1/s)-js[2]) == 0
    for j in js[3:]:
        assert sp.factor(j.subs(s, 1/s)-j) == 0
    assert sp.factor(js[3].subs(s, -s)-js[4]) == 0
    assert sp.factor(js[3]+js[4]-4*js[2]) == 0
    assert sp.factor(js[3]*js[4]-6912*js[2]) == 0
    r = sp.symbols('r')
    c_r = -6912*r/(r-1)**2
    assert sp.factor(c_r*(c_r-1728)-3456**2*r*(r+1)**2/(r-1)**4) == 0
    return {
        'C_second_quotient_j': str(c_j),
        'normalized_five_j_invariants': [str(sp.factor(j)) for j in js],
        'nonconstant_j_map_degrees': [4, 4, 2, 2],
        'quotient_map_identities': True,
        'H_j_pair_equation': 'Z^2 - 4*c*Z + 6912*c = 0',
        'factor_splitting_field': 'C(r)(sqrt(r)), r=16*t^2/27',
        'pole_supports': [[], ['0', '-1', '1'], ['-1', '1'], ['-1'], ['1']],
    }

def point_count(coefficients: list[int], p: int, degree: int) -> int:
    def chi(a: int) -> int:
        a %= p
        return 0 if a == 0 else (1 if pow(a, (p-1)//2, p) == 1 else -1)

    if degree == 1:
        result = p
        for x in range(p):
            value = 0
            for c in coefficients:
                value = (value*x+c) % p
            result += chi(value)
        return result + (1 if len(coefficients) % 2 == 0 else 1+chi(coefficients[0]))

    if degree != 2:
        raise ValueError('Only F_p and F_(p^2) are implemented.')
    n = next(i for i in range(2, p) if chi(i) == -1)
    result = p*p
    for x, y in itertools.product(range(p), repeat=2):
        a, b = 0, 0
        for c in coefficients:
            a, b = (a*x+n*b*y+c) % p, (a*y+b*x) % p
        result += chi(a*a-n*b*b)
    return result + (1 if len(coefficients) % 2 == 0 else 2)

def frobenius(f: sp.Expr, x: sp.Symbol, p: int) -> sp.Expr:
    f = sp.Poly(f, x)
    coeff = [int(c) % p for c in f.all_coeffs()]
    assert coeff[0] != 0
    assert sp.Poly(f, modulus=p).gcd(sp.Poly(sp.diff(f.as_expr(), x), x, modulus=p)).degree() == 0
    n1 = point_count(coeff, p, 1)
    a1 = p+1-n1
    T = sp.Symbol('T')
    if f.degree() in (3, 4):
        return T*T-a1*T+p
    n2 = point_count(coeff, p, 2)
    numerator = n2-p*p-1+a1*a1
    assert numerator % 2 == 0
    return T**4-a1*T**3+(numerator//2)*T*T-p*a1*T+p*p

def cubic_points(t: int, p: int) -> int:
    count = 0
    for first in range(5):
        for tail in itertools.product(range(p), repeat=4-first):
            u, v, x, y, z = (0,)*first+(1,)+tail
            f = 4*(z-x)*u*u+24*y*u*v+12*(z+x)*v*v-4*z**3+3*(x*x+3*y*y)*z+4*t*y**3
            count += f % p == 0
    return count

def finite_field_checks() -> list[dict]:
    p = 13
    sqrt3 = next(x for x in range(p) if x*x % p == 3)
    assert any(x*x % p == (-27) % p for x in range(p))
    x, T = sp.symbols('x T')
    rows = []
    for t in (1, 2, 4, 5):
        assert t*(16*t*t-27) % p
        c = 16*t*t-(x*x+3)**3
        c1 = 16*t*t-(x+3)**3
        c2 = x*(16*t*t-(x+3)**3)
        cpol = frobenius(c, x, p)
        c1pol, c2pol = frobenius(c1, x, p), frobenius(c2, x, p)
        assert sp.expand(cpol-c1pol*c2pol) == 0
        k = 32*sqrt3*pow(9, -1, p)*t % p
        h = 2*((x*x+1)**3-k*x**3)
        h1, h2 = 2*(x+2)*(x**3-k), 2*(x-2)*(x**3-k)
        hpol = frobenius(h, x, p)
        h1pol, h2pol = frobenius(h1, x, p), frobenius(h2, x, p)
        assert sp.expand(hpol-h1pol*h2pol) == 0
        e = x**3-243*x+1728*t*t-1458
        epol = frobenius(e, x, p)
        trace = -sum(int(sp.Poly(q, T).coeff_monomial(T)) for q in [epol,c1pol,c2pol,h1pol,h2pol])
        n = cubic_points(t, p)
        assert n == 1+p+p*p+p**3-p*trace
        rows.append({'p':p, 't':t, 'five_elliptic_factors':[str(q) for q in [epol,c1pol,c2pol,h1pol,h2pol]],
                     'C_factorization':True, 'H_factorization':True, 'cubic_point_count':n,
                     'five_factor_trace_matches_cubic':True, 'normalized_H_quadratic_twist':2})
    for p in (5,7,11,13):
        for t in (1,2,4):
            if t*(16*t*t-27) % p == 0:
                continue
            e=x**3-243*x+1728*t*t-1458
            c=-3*(16*t*t-(x*x+3)**3)
            h=-6*(32*t*x**3-(x*x+3)**3)
            pol=[frobenius(f,x,p) for f in (e,c,h)]
            trace=-sum(int(sp.Poly(f,T).coeff_monomial(T**(sp.degree(f,T)-1))) for f in pol)
            n=cubic_points(t,p)
            assert n==1+p+p*p+p**3-p*trace
            rows.append({'p':p,'t':t,'Q_defined_factors':[str(f) for f in pol],
                         'twists':{'C':-3,'H':-6},'cubic_point_count':n,
                         'Q_defined_trace_matches_cubic':True})
    return rows

def toric_rank(t: Fraction, p: int) -> int:
    if p < 5 or not sp.isprime(p):
        raise ValueError('The certificate requires a prime p >= 5.')
    a, b = t.numerator, t.denominator
    if a == 0:
        raise ValueError('The parameter must be nonzero.')
    if a % p == 0:
        return 1
    if b % p != 0 and (16*a*a-27*b*b) % p == 0:
        return 3
    return 0

def squarefree(n: int) -> bool:
    return n != 0 and all(e == 1 for e in sp.factorint(abs(n)).values())

def certificate(t: Fraction) -> dict:
    a, b = t.numerator, t.denominator
    if a <= 0 or b % 2 == 0 or gcd(a, 6) != 1:
        raise ValueError('The reconstruction chart requires a > 0 coprime to 6 and b positive odd.')
    d = 16*a*a-27*b*b
    if d <= 0 or not squarefree(a*d):
        raise ValueError('The reconstruction chart requires a*(16a^2-27b^2) positive and squarefree.')
    s1 = sorted(int(p) for p in sp.factorint(a))
    s3 = sorted(int(p) for p in sp.factorint(d))
    assert all(p >= 5 for p in s1+s3)
    assert set(s1).isdisjoint(s3)
    assert all(toric_rank(t,p) == 1 for p in s1)
    assert all(toric_rank(t,p) == 3 for p in s3)
    aa, dd = prod(s1), prod(s3)
    b2 = (16*aa*aa-dd)//27
    bb = isqrt(b2)
    assert 27*b2 == 16*aa*aa-dd and bb*bb == b2
    assert Fraction(aa,bb) == t
    return {'parameter':str(t), 'a':a, 'b':b, 'D':d, 'rank_1_primes':s1, 'rank_3_primes':s3,
            'reconstructed_parameter':str(Fraction(aa,bb))}

def arithmetic_checks(bound: int) -> dict:
    integers = [n for n in range(1,bound+1) if gcd(n,6)==1 and squarefree(n)]
    for i,a in enumerate(integers):
        for b in integers[:i]:
            pa, pb = set(sp.factorint(a)), set(sp.factorint(b))
            p = int(min(pa ^ pb))
            assert toric_rank(Fraction(a),p) != toric_rank(Fraction(b),p)
    rational_rows = []
    for a in range(1,bound+1,6):
        for b in range(1,(a-1)//2+1,2):
            if 4*b <= a or gcd(a,b)!=1:
                continue
            d=16*a*a-27*b*b
            if squarefree(a*d):
                rational_rows.append(certificate(Fraction(a,b)))
    assert len({(tuple(r['rank_1_primes']),tuple(r['rank_3_primes'])) for r in rational_rows}) == len(rational_rows)
    return {'bound':bound, 'squarefree_integer_count':len(integers), 'first_integer_parameters':integers[:35],
            'all_integer_pairs_locally_separated':True,
            'rational_reconstruction_count_in_wedge':len(rational_rows),
            'sample_rational_certificates':rational_rows[:20]}

def s_unit_identities() -> dict:
    t = sp.symbols('t', nonzero=True)
    root = sp.sqrt(3)
    w = 3*root/(4*t)
    x, y = (1+w)/2, (1-w)/2
    assert sp.simplify(x+y-1) == 0
    assert sp.simplify(3*root/(4*(x-y))-t) == 0
    assert sp.factor(x*y-(16*t*t-27)/(64*t*t)) == 0
    assert sp.simplify(x.xreplace({root:-root})-y) == 0
    return {'x':str(x), 'y':str(y), 'sum':1,
            'norm_x':'(16*t^2 - 27)/(64*t^2)',
            'recovery':'t = 3*sqrt(3)/(4*(x-y))',
            'conjugation_identity':True,
            'unit_equation_solver_implemented':False,
            'rank_bound':'2^(8*(number_of_finite_places_above_S + 2))'}

def simplex_checks() -> dict:
    weights = [sp.Matrix(w) for w in ((0,1,1),(1,0,1),(1,1,0),(1,1,1))]
    differences = sp.Matrix.hstack(*(w-weights[0] for w in weights[1:]))
    visible = sp.Matrix.hstack(*(sp.Matrix(w) for w in ((0,1,1),(1,0,1),(1,1,0))))
    require(abs(differences.det()) == 1, 'Selected simplex is not unimodular')
    require(abs(visible.det()) == 2, 'Unsaturated parametrization has unexpected index')
    k0,k1,k2,k3 = sp.symbols('k0 k1 k2 k3', nonzero=True)
    t1,t2,t3 = k3/k0,k3/k1,k3/k2
    require(sp.cancel(t1/t2-k1/k0) == 0, 'First correction ratio failed')
    require(sp.cancel(t1/t3-k2/k0) == 0, 'Second correction ratio failed')
    require(sp.cancel(t1-k3/k0) == 0, 'Third correction ratio failed')
    return {'difference_determinant':int(differences.det()),
            'unsaturated_index':abs(int(visible.det())),
            'orbit_correction_verified':True}


def local_density_checks() -> list[dict]:
    rows=[]
    for p in (5,7,11,13,17,19):
        modulus=p*p
        actual=sum(a*(16*a*a-27*b*b)%modulus == 0
                   for a in range(modulus) for b in range(modulus))
        lines=3 if sp.legendre_symbol(3,p)==1 else 1
        expected=p*p+lines*p*(p-1)
        require(actual==expected, f'Local density failed at {p}')
        rows.append({'p':p,'zero_count_mod_p_squared':actual,'lines':lines})
    return rows


def main() -> None:
    parser=argparse.ArgumentParser()
    parser.add_argument('--output',type=Path,default=Path('sharpness_upgrade_checks.json'))
    parser.add_argument('--check-output',type=Path,help='Compare with a certificate without writing; ignore only Python version metadata')
    parser.add_argument('--bound',type=int,default=240)
    parser.add_argument('--length',type=int,default=20)
    parser.add_argument('--skip-tangent',action='store_true')
    args=parser.parse_args()
    if not __debug__:
        parser.error('Run without -O; assertions are part of the verification.')
    if args.bound < 20 or args.length < 1:
        parser.error('--bound must be at least 20 and --length must be positive.')
    jobs=[('family',family_checks),('simplex',simplex_checks),
          ('lattices',lattice_checks),('uniform_cover',certificate_polynomials)]
    if not args.skip_tangent:
        jobs.append(('tangent_reconstruction',tangent_checks))
    jobs += [('smooth_pencil',elliptic_and_smoothness_checks),
             ('elliptic_quotients',elliptic_quotients),('finite_field_twists',finite_field_checks),
             ('local_certificates',lambda:arithmetic_checks(args.bound)),
             ('recursive_sequence',lambda:prime_certificates(args.length)),
             ('local_densities',local_density_checks),('s_unit_identities',s_unit_identities)]
    result={'sympy_version':sp.__version__,'python_version':sys.version.split()[0],
            'input_version':'sharpness proof packet, 9 September 2026','tangent_reconstruction_skipped':args.skip_tangent}
    for name,job in jobs:
        result[name]=job()
        print(f'Passed: {name}',flush=True)
    result['all_requested_checks_passed']=True
    result['scope']=(
        'Exact finite algebra only. The Cox check reconstructs eight tangent rows, '
        'not the complete twenty-quadric ideal or the repository verification target. '
        'The surface geometry, Galois identification, descent, Hodge conservation, '
        'Prym comparison, reduction theory and squarefree/S-unit theorems are separate '
        'written arguments or imported results. No expanded rationalization or full '
        'S-unit solver is produced.')
    if args.check_output:
        expected=json.loads(args.check_output.read_text())
        actual=json.loads(json.dumps(result,default=str))
        expected.pop('python_version',None)
        actual.pop('python_version',None)
        require(actual == expected, 'Family/arithmetic certificate mismatch')
        print('Family/arithmetic certificate: ok')
        return
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2,default=str)+'\n',encoding='utf-8')
    print(f'All requested checks passed. Output: {args.output}',flush=True)


if __name__=='__main__':
    main()
