"""Materialize the human citation dispositions; no inference of reading from cache.

Replay after editing the explicit decisions below, not as an automatic novelty test.
The frozen graph acquisitions remain authoritative for membership and abstracts.
"""
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CACHE = Path('/tmp/persistent/tavis/lit-search')

# These abstracts were individually read in the adjudication pass. All remaining
# metadata dispositions use titles only, except records with a primary comparison.
ABSTRACT_READ = {
    2, 6, 9, 10, 13, 14, 15, 16, 17, 18, 24, 29, 30, 33, 35, 36, 37,
    39, 44, 58, 63, 64, 66, 68, 77, 79, 80, 81, 83, 84, 85, 86, 92,
    96, 98, 129, 131, 137, 140, 150, 153, 157, 167, 172, 199, 203,
    223, 260, 261, 264, 268, 272, 298, 306, 316, 321, 326, 331,
}

PRIMARY = {
    5: 'arXiv:2408.10140',
    13: 'arXiv:2601.21514',
    19: 'arXiv:1606.01904',
    39: 'arXiv:2603.04548',
    65: 'arXiv:2403.06228',
    83: 'arXiv:2512.21874',
    85: 'arXiv:2510.10852',
    92: 'arXiv:2408.07764',
    101: 'arXiv:2501.10163',
    112: 'arXiv:1606.01904',
    121: 'arXiv:1811.08461',
    123: 'arXiv:1503.08800',
    142: 'arXiv:1709.08658',
    153: 'arXiv:2012.00490',
    172: 'arXiv:2312.14399',
    173: 'arXiv:2603.04548',
    241: 'arXiv:2308.01886',
    242: '10.1007/s11128-023-04186-9',
    300: 'arXiv:2608.28563',
    306: 'arXiv:2603.15550',
    316: 'arXiv:2506.11725',
    321: 'arXiv:2306.09292',
}

REASONS = {
    2: 'Abstract: permutation-invariant multiqubit spin codes; different construction domain.',
    10: 'Abstract: discrete-angle refinement and homological obstructions; background to an already-known mechanism, not a claimed new obstruction here.',
    14: 'Abstract explicitly specifies binary nested codes and divisible weights.',
    15: 'Dissertation abstract: binary QFD/transversal T and Clifford synthesis; background.',
    16: 'Abstract: generalized triorthogonal T/controlled-S/Toffoli protocols; retire broad coupled-resource mechanism novelty.',
    24: 'Survey abstract; not used as a substitute for primary technical comparisons.',
    29: 'Abstract explicitly specifies Boolean hypercube and single-qubit rotations.',
    35: 'Abstract explicitly specifies binary CSS cosets; coset constancy is prior framework.',
    36: 'Abstract: graphical characterization of transversal third-level diagonal gates; no novelty claimed for such characterization.',
    44: 'Abstract explicitly studies four-qubit permutations and semi-Clifford gates.',
    58: 'Abstract: GKP-to-discrete single-site gate construction; not the finite signed trade source.',
    63: 'Abstract: AG codes and multiplication-friendly alphabet reduction, including fixed alphabets; no asymptotic-code novelty claimed.',
    64: 'Abstract: products of algebraic chain complexes and transversal controlled-Z gates; no LDPC/asymptotic novelty claimed.',
    66: 'Abstract explicitly classifies one-qubit or one-qudit hierarchy gates.',
    68: 'Abstract: Boolean LUT synthesis and phase-depth; no compilation-framework novelty claimed.',
    77: 'Abstract: finite tricycle LDPC factories; outside the explicitly fixed p=7 comparison menu.',
    79: 'Abstract: group/AG lifting, decoding and addressability; no claim of first group-based quantum code.',
    80: 'Abstract: refined puncturing and sublinear Z checks, fixed-prime alphabet reduction; not an unrestricted benchmark comparator.',
    81: 'Abstract allows non-Clifford processing in its distillation protocol; different resource accounting.',
    84: 'Abstract: addressable parallel controlled-Z on good qudit codes; prior distance-side framework.',
    86: 'Abstract: asymptotic subsystem product codes with sublinear checks; background only.',
    96: 'Abstract: quadratic-residue T/Strange-state distillation; no claim of first finite-geometric magic-state construction.',
    98: 'Abstract: single-qudit universality by local dimension; distinct from construction/census questions.',
    129: 'Abstract: single-qudit magic/MUB uncertainty and bipartite CHSH states; prior extremality background.',
    131: 'Abstract: qubit/qutrit single-site diagonal L1 optimality. Not used to infer a multiqudit Hessian theorem.',
    137: 'Abstract: SU(d) irreducible-representation codes with one logical qudit; no general invariant-code novelty claimed.',
    140: 'Abstract: Alltop/Zauner symmetries and three Clifford orbits; already-known symmetry-defined resources.',
    150: 'Abstract: qutrit phase gadgets and controlled gates; compilation background, not a new mechanism here.',
    157: 'Abstract: MUS/SIC/Alltop single-system comparisons; broad extremality claim is withheld.',
    167: 'Abstract: discrete Wigner stationary phase and quadratic Gauss sums; supports treating the method as established.',
    195: 'Title-only graph metadata; diagonal-hierarchy classification is background, not evidence excluding overlap in unread text.',
    199: 'Abstract: all third-level gates on up to two prime qudits are semi-Clifford; different classification domain.',
    203: 'Abstract warns of SE monotonicity failures; companion uses pure-state Clifford invariance/additivity only.',
    223: 'Abstract: small-code distillation survey/search; no claim of first small-code factory.',
    260: 'Abstract: random CZ/CCZ ensemble entanglement, not a specific signed-trade spectrum.',
    261: 'Abstract explicitly includes exact logical error rates for qudit channels via enumerators; no first qudit-enumerator claim.',
    264: 'Abstract: shadow estimation and Clifford measurement ensembles; MUB background.',
    268: 'Abstract explicitly about two qubits and a qubit conjecture; not an arbitrary odd-prime theorem.',
    272: 'Relevant single-prime L1 optimality; publisher PDF was HTML. ACCESS GAP, no source-wide negative.',
    298: 'Review abstract, not substituted for primary rank/state-construction sources.',
    326: 'Abstract: qubit topological triple-intersection invariant induces logical phase; distinguishes binary-form invariants, not first invariant-defined gate.',
    330: 'Title-only graph screen: stabilizer representation, not a novelty-bearing use of that paper. No text-level exclusion.',
    331: 'Abstract explicitly concerns pure-qubit Fisher information in labelled Pauli data; distinct from Hessian census.',
}


def main():
    promoted = json.loads((ROOT / 'promoted.json').read_text())
    source_records = json.loads((ROOT / 'adjudication-sources.json').read_text())
    source_index = {x['key']: x for x in source_records}
    rows = []
    for i, original in enumerate(promoted):
        row = dict(index=i, title=original['title'], id=original['id'],
                   doi=original.get('doi'), externalIds=original.get('externalIds'),
                   read_depth='abstract/metadata only',
                   fields_read=['title', 'abstract'] if i in ABSTRACT_READ else ['title'],
                   disposition='METADATA_BACKGROUND' if i in ABSTRACT_READ else 'TITLE_SCREEN_NOT_PROMOTED_FURTHER',
                   reason=REASONS.get(i, 'Title/available abstract does not identify one of the six target contributions; background or different physical/algorithmic problem. This is a screening decision, not a full-text non-overlap verdict.'))
        if i in PRIMARY:
            s = source_index[PRIMARY[i]]
            row.update(disposition='PRIMARY_COMPARISON', source_key=s['key'],
                       read_depth=s['read_depth'], fields_read=['primary sections'],
                       reason=s['comparison'], sections_read=s['sections_read'])
        if i == 19:
            row.update(read_depth='secondary only',
                       sections_read='Companion PRA arXiv:1606.01904, II.C; PRL full text not read',
                       reason='The related PRA primary reading supplies the synthillation comparison; this is not a primary reading of the PRL companion.')
        if i == 272:
            row['disposition'] = 'ACCESS_GAP'
        rows.append(row)
    payload = dict(
        promoted_sha256=hashlib.sha256((ROOT / 'promoted.json').read_bytes()).hexdigest(),
        count=len(rows), index_convention='zero-based index in frozen promoted.json',
        discriminator='Inspect all 336 titles; inspect abstracts for potentially relevant mechanisms, phase-state constructions, entropy/product bounds, geometry/invariants, or synthesis. Compare closest sources at named primary sections. Do not interpret a metadata dismissal as absence in unread full text.',
        warning='Completed dispositions do not imply 336 technical/full-text readings or a passed Gate 1.',
        records=rows,
    )
    (ROOT / 'adjudication.json').write_text(json.dumps(payload, indent=2) + '\n')
    counts = {k: sum(x['disposition'] == k for x in rows) for k in sorted({x['disposition'] for x in rows})}
    print(json.dumps(counts))


if __name__ == '__main__':
    main()
