//! C1028 — chain-ring instrument test for the Ergodis core.
//!
//! Points Ergodis at arcs and linear codes over the two finite chain rings of
//! order four: the integers modulo four (`Z4`) and the truncated polynomial
//! ring `S2 = F2[u]/(u^2)`. Both have residue field `F2`, so both coordinatize
//! a projective Hjelmslev plane `PHG(2,R)` with 28 points and 28 lines of six
//! points each, and the two planes differ in exactly one published arc-table
//! entry (`m_2 = 7` for `Z4`, `6` for `S2`).
//!
//! Two deliverables, both emitted as JSON:
//!
//! 1. A gap specification. Each `probe_*` function calls an Ergodis core
//!    kernel as it stands on ring input and records the failure mode
//!    (rejected input, silently wrong answer, or clean pass).
//! 2. A real ring-side computation. The plane is built from local chain-ring
//!    arithmetic, the whole order-four arc column `m_n(R)`, `n = 0..=6`, is
//!    determined exhaustively for both rings, the maximum arcs are classified
//!    up to the ring-linear group `GL(3,R)` using the core's own orbit
//!    compiler, and the Gray images of the associated codes are checked
//!    against the published `(14, 2^6, 6)` and octacode / Nordstrom-Robinson
//!    landmarks.
//!
//! The Ergodis core is read-only. All ring arithmetic below is local to this
//! driver, which is the expected outcome, not a workaround: the record of what
//! had to be reimplemented *is* the gap specification.

use std::collections::BTreeMap;
use std::fmt::Write as _;
use std::fs;
use std::path::PathBuf;
use std::time::Instant;

use ergodis::field::{FieldElement, Gf4, Prime, SmallField};
use ergodis::group_action::{
    compile_permutation_orbits, verify_permutation_orbits, ExplicitPermutationAction,
};
use ergodis::linear_code::CompiledBinaryLinearCode;
use ergodis::matrix::Matrix;
use ergodis::projective::ProjectiveIndex;

// ---------------------------------------------------------------------------
// Chain-ring arithmetic (local; the core has no ring layer)
// ---------------------------------------------------------------------------

/// The two finite chain rings of order four, with residue field `F2`.
///
/// Encoding is `a + 2b` in both cases: for `Z4` that is the residue itself,
/// for `S2` it is the pair of coefficients of `a + b*u`.
#[derive(Clone, Copy, PartialEq, Eq, Debug)]
enum Ring4 {
    Z4,
    S2,
}

impl Ring4 {
    const ALL: [Ring4; 2] = [Ring4::Z4, Ring4::S2];

    fn name(self) -> &'static str {
        match self {
            Ring4::Z4 => "Z4",
            Ring4::S2 => "S2",
        }
    }

    #[inline]
    fn add(self, x: u8, y: u8) -> u8 {
        match self {
            Ring4::Z4 => (x + y) & 3,
            Ring4::S2 => x ^ y,
        }
    }

    #[inline]
    fn neg(self, x: u8) -> u8 {
        match self {
            Ring4::Z4 => (4 - x) & 3,
            Ring4::S2 => x,
        }
    }

    #[inline]
    fn mul(self, x: u8, y: u8) -> u8 {
        match self {
            Ring4::Z4 => (x * y) & 3,
            Ring4::S2 => {
                let (a0, a1) = (x & 1, x >> 1);
                let (b0, b1) = (y & 1, y >> 1);
                (a0 & b0) | ((((a0 & b1) ^ (a1 & b0)) & 1) << 1)
            }
        }
    }

    /// A ring element is a unit exactly when its residue is nonzero.
    #[inline]
    fn is_unit(x: u8) -> bool {
        x & 1 == 1
    }

    /// Both units of both rings square to one, so a unit is its own inverse.
    #[inline]
    fn unit_inverse(x: u8) -> u8 {
        x
    }
}

/// Homogeneous weight on a chain ring of length two with residue field `F2`;
/// for `Z4` this coincides with the Lee weight.
const HOM_WEIGHT: [u32; 4] = [0, 1, 2, 1];

/// Gray map into two binary coordinates, packed low bit first.
/// `0 -> 00`, `1 -> 01`, `2 -> 11`, `3 -> 10`; weight-preserving for
/// [`HOM_WEIGHT`] in both rings.
const GRAY: [u8; 4] = [0b00, 0b01, 0b11, 0b10];

// ---------------------------------------------------------------------------
// The projective Hjelmslev plane PHG(2,R)
// ---------------------------------------------------------------------------

const POINTS: usize = 28;

struct Phg2 {
    ring: Ring4,
    points: Vec<[u8; 3]>,
    lines: Vec<[u8; 3]>,
    index_of: [i16; 64],
    line_points: Vec<u32>,
    point_lines: Vec<u32>,
}

fn encode(v: [u8; 3]) -> usize {
    v[0] as usize + 4 * v[1] as usize + 16 * v[2] as usize
}

/// Canonical representative of the free rank-one submodule `vR`: scale so the
/// first unit coordinate is one. Returns `None` for non-unimodular vectors,
/// which are not points of the Hjelmslev plane.
fn canonical(ring: Ring4, v: [u8; 3]) -> Option<[u8; 3]> {
    let pivot = (0..3).find(|&i| Ring4::is_unit(v[i]))?;
    let scale = Ring4::unit_inverse(v[pivot]);
    Some([
        ring.mul(v[0], scale),
        ring.mul(v[1], scale),
        ring.mul(v[2], scale),
    ])
}

fn dot(ring: Ring4, a: [u8; 3], b: [u8; 3]) -> u8 {
    let mut sum = 0u8;
    for i in 0..3 {
        sum = ring.add(sum, ring.mul(a[i], b[i]));
    }
    sum
}

impl Phg2 {
    fn new(ring: Ring4) -> Self {
        let mut points = Vec::new();
        let mut index_of = [-1i16; 64];
        for code in 0..64usize {
            let v = [
                (code & 3) as u8,
                ((code >> 2) & 3) as u8,
                ((code >> 4) & 3) as u8,
            ];
            let Some(rep) = canonical(ring, v) else {
                continue;
            };
            let rep_code = encode(rep);
            if index_of[rep_code] < 0 {
                index_of[rep_code] = points.len() as i16;
                points.push(rep);
            }
            index_of[code] = index_of[rep_code];
        }
        // Lines are the free rank-two submodules, indexed by unimodular linear
        // forms modulo units, i.e. by the same canonical class set.
        let lines = points.clone();
        let mut line_points = vec![0u32; lines.len()];
        let mut point_lines = vec![0u32; points.len()];
        for (li, &l) in lines.iter().enumerate() {
            for (pi, &p) in points.iter().enumerate() {
                if dot(ring, l, p) == 0 {
                    line_points[li] |= 1 << pi;
                    point_lines[pi] |= 1 << li;
                }
            }
        }
        Self {
            ring,
            points,
            lines,
            index_of,
            line_points,
            point_lines,
        }
    }

    fn point_index(&self, v: [u8; 3]) -> Option<usize> {
        let i = self.index_of[encode(v)];
        if i < 0 {
            None
        } else {
            Some(i as usize)
        }
    }

    /// Structural invariants of the plane, as measured rather than assumed.
    fn structure(&self) -> BTreeMap<String, serde_json::Value> {
        let mut out = BTreeMap::new();
        out.insert("points".into(), self.points.len().into());
        out.insert("lines".into(), self.lines.len().into());
        let line_sizes: Vec<u32> = self.line_points.iter().map(|m| m.count_ones()).collect();
        let point_degrees: Vec<u32> = self.point_lines.iter().map(|m| m.count_ones()).collect();
        out.insert(
            "line_sizes_distinct".into(),
            distinct_sorted(&line_sizes).into(),
        );
        out.insert(
            "point_degrees_distinct".into(),
            distinct_sorted(&point_degrees).into(),
        );
        // Neighbour relation: two distinct points are neighbours exactly when
        // more than one line joins them. In a projective plane this never
        // happens; it is the defining Hjelmslev degeneracy.
        let mut joins: BTreeMap<u32, u32> = BTreeMap::new();
        for a in 0..self.points.len() {
            for b in (a + 1)..self.points.len() {
                let common = (self.point_lines[a] & self.point_lines[b]).count_ones();
                *joins.entry(common).or_insert(0) += 1;
            }
        }
        out.insert(
            "point_pair_join_multiplicities".into(),
            serde_json::to_value(&joins).unwrap(),
        );
        // Neighbour classes are the fibres of reduction modulo the radical.
        let mut classes: BTreeMap<usize, Vec<usize>> = BTreeMap::new();
        for (pi, p) in self.points.iter().enumerate() {
            let residue = (p[0] & 1) as usize + 2 * (p[1] & 1) as usize + 4 * (p[2] & 1) as usize;
            classes.entry(residue).or_default().push(pi);
        }
        let mut sizes: Vec<u32> = classes.values().map(|v| v.len() as u32).collect();
        sizes.sort_unstable();
        out.insert("neighbour_class_count".into(), classes.len().into());
        out.insert(
            "neighbour_class_sizes_distinct".into(),
            distinct_sorted(&sizes).into(),
        );
        // Cross-check: the "more than one join" relation equals the residue
        // fibre relation.
        let mut agree = true;
        for a in 0..self.points.len() {
            for b in 0..self.points.len() {
                if a == b {
                    continue;
                }
                let multi = (self.point_lines[a] & self.point_lines[b]).count_ones() > 1;
                let same_class = self
                    .points
                    .iter()
                    .nth(a)
                    .zip(self.points.iter().nth(b))
                    .map(|(x, y)| (0..3).all(|i| x[i] & 1 == y[i] & 1))
                    .unwrap();
                if multi != same_class {
                    agree = false;
                }
            }
        }
        out.insert("neighbour_relation_cross_check".into(), agree.into());
        out
    }
}

fn distinct_sorted(values: &[u32]) -> Vec<u32> {
    let mut v: Vec<u32> = values.to_vec();
    v.sort_unstable();
    v.dedup();
    v
}

// ---------------------------------------------------------------------------
// Exhaustive arc census
// ---------------------------------------------------------------------------

struct ArcSearch<'a> {
    plane: &'a Phg2,
    bound: u32,
    counts: [u32; POINTS],
    best: usize,
    collect: bool,
    found: Vec<u32>,
    nodes: u64,
}

impl<'a> ArcSearch<'a> {
    fn dfs(&mut self, next: usize, chosen: u32, size: usize) {
        self.nodes += 1;
        if self.collect {
            if size == self.best {
                self.found.push(chosen);
                return;
            }
            if size + (POINTS - next) < self.best {
                return;
            }
        } else {
            if size > self.best {
                self.best = size;
            }
            if size + (POINTS - next) <= self.best {
                return;
            }
        }
        for p in next..POINTS {
            if self.collect && size + (POINTS - p) < self.best {
                return;
            }
            if !self.collect && size + (POINTS - p) <= self.best {
                return;
            }
            let lines = self.plane.point_lines[p];
            let mut ok = true;
            let mut mask = lines;
            while mask != 0 {
                let l = mask.trailing_zeros() as usize;
                mask &= mask - 1;
                if self.counts[l] + 1 > self.bound {
                    ok = false;
                    break;
                }
            }
            if !ok {
                continue;
            }
            let mut mask = lines;
            while mask != 0 {
                let l = mask.trailing_zeros() as usize;
                mask &= mask - 1;
                self.counts[l] += 1;
            }
            self.dfs(p + 1, chosen | (1 << p), size + 1);
            let mut mask = lines;
            while mask != 0 {
                let l = mask.trailing_zeros() as usize;
                mask &= mask - 1;
                self.counts[l] -= 1;
            }
        }
    }
}

/// Exhaustively determine `m_n(R)` and, in a second pass, every maximum arc.
fn arc_census(plane: &Phg2, bound: u32) -> (usize, Vec<u32>, u64) {
    let mut search = ArcSearch {
        plane,
        bound,
        counts: [0; POINTS],
        best: 0,
        collect: false,
        found: Vec::new(),
        nodes: 0,
    };
    search.dfs(0, 0, 0);
    let best = search.best;
    let nodes_phase1 = search.nodes;
    let mut collect = ArcSearch {
        plane,
        bound,
        counts: [0; POINTS],
        best,
        collect: true,
        found: Vec::new(),
        nodes: 0,
    };
    collect.dfs(0, 0, 0);
    let nodes = nodes_phase1 + collect.nodes;
    let mut found = collect.found;
    found.sort_unstable();
    (best, found, nodes)
}

// ---------------------------------------------------------------------------
// The ring-linear group GL(3,R) and its action on the plane
// ---------------------------------------------------------------------------

type Mat3 = [u8; 9];

fn mat_mul(ring: Ring4, a: &Mat3, b: &Mat3) -> Mat3 {
    let mut out = [0u8; 9];
    for i in 0..3 {
        for j in 0..3 {
            let mut sum = 0u8;
            for k in 0..3 {
                sum = ring.add(sum, ring.mul(a[3 * i + k], b[3 * k + j]));
            }
            out[3 * i + j] = sum;
        }
    }
    out
}

fn det3(ring: Ring4, m: &Mat3) -> u8 {
    let term = |i: usize, j: usize, k: usize| ring.mul(ring.mul(m[i], m[3 + j]), m[6 + k]);
    let positive = ring.add(ring.add(term(0, 1, 2), term(1, 2, 0)), term(2, 0, 1));
    let negative = ring.add(ring.add(term(0, 2, 1), term(1, 0, 2)), term(2, 1, 0));
    ring.add(positive, ring.neg(negative))
}

fn mat_encode(m: &Mat3) -> u32 {
    m.iter()
        .enumerate()
        .map(|(i, &e)| (e as u32) << (2 * i))
        .sum()
}

fn mat_decode(code: u32) -> Mat3 {
    let mut m = [0u8; 9];
    for (i, e) in m.iter_mut().enumerate() {
        *e = ((code >> (2 * i)) & 3) as u8;
    }
    m
}

/// Brute-force order of `GL(3,R)`: invertible exactly when the determinant is
/// a unit, since `R` is commutative local.
fn gl3_order(ring: Ring4) -> u64 {
    (0..(1u32 << 18))
        .filter(|&code| Ring4::is_unit(det3(ring, &mat_decode(code))))
        .count() as u64
}

/// Elementary transvections plus one unit dilation.
fn gl3_generators() -> Vec<Mat3> {
    let identity: Mat3 = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    let mut gens = Vec::new();
    for i in 0..3 {
        for j in 0..3 {
            if i == j {
                continue;
            }
            let mut g = identity;
            g[3 * i + j] = 1;
            gens.push(g);
        }
    }
    let mut dilation = identity;
    dilation[0] = 3;
    gens.push(dilation);
    gens
}

fn generated_order(ring: Ring4, gens: &[Mat3]) -> u64 {
    let identity: Mat3 = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    let mut seen = vec![false; 1usize << 18];
    let mut queue = vec![mat_encode(&identity)];
    seen[mat_encode(&identity) as usize] = true;
    let mut count = 0u64;
    while let Some(code) = queue.pop() {
        count += 1;
        let m = mat_decode(code);
        for g in gens {
            let p = mat_mul(ring, g, &m);
            let pc = mat_encode(&p);
            if !seen[pc as usize] {
                seen[pc as usize] = true;
                queue.push(pc);
            }
        }
    }
    count
}

fn point_permutation(plane: &Phg2, m: &Mat3) -> Vec<u32> {
    (0..plane.points.len())
        .map(|p| {
            let v = plane.points[p];
            let mut image = [0u8; 3];
            for (i, slot) in image.iter_mut().enumerate() {
                let mut sum = 0u8;
                for k in 0..3 {
                    sum = plane.ring.add(sum, plane.ring.mul(m[3 * i + k], v[k]));
                }
                *slot = sum;
            }
            plane
                .point_index(canonical(plane.ring, image).expect("units are preserved"))
                .expect("canonical class is indexed") as u32
        })
        .collect()
}

fn permute_mask(mask: u32, perm: &[u32]) -> u32 {
    let mut out = 0u32;
    let mut rest = mask;
    while rest != 0 {
        let p = rest.trailing_zeros() as usize;
        rest &= rest - 1;
        out |= 1 << perm[p];
    }
    out
}

/// Classify a set of arcs up to `GL(3,R)` **using the core's orbit compiler**,
/// which is the one kernel expected to survive contact with ring data.
fn classify_arcs(
    plane: &Phg2,
    arcs: &[u32],
    generators: &[Mat3],
) -> anyhow::Result<(usize, Vec<u32>, Vec<Vec<u32>>, bool)> {
    let perms: Vec<Vec<u32>> = generators
        .iter()
        .map(|g| point_permutation(plane, g))
        .collect();
    let mut images = Vec::with_capacity(perms.len() * arcs.len());
    for perm in &perms {
        for &arc in arcs {
            let moved = permute_mask(arc, perm);
            let target = arcs
                .binary_search(&moved)
                .map_err(|_| anyhow::anyhow!("arc set is not closed under the group"))?;
            images.push(target as u32);
        }
    }
    let action = ExplicitPermutationAction::new(arcs.len(), images)?;
    let partition = compile_permutation_orbits(&action).map_err(|e| anyhow::anyhow!("{e}"))?;
    let verified = verify_permutation_orbits(&action, &partition).is_ok();
    let representatives: Vec<u32> = partition.representatives().to_vec();
    let mut sizes = vec![0u32; representatives.len()];
    for &orbit in partition.point_orbits() {
        sizes[orbit as usize] += 1;
    }
    // Line-intersection spectrum of each orbit representative: an invariant of
    // the orbit, so orbits of the two rings can be compared as labelled
    // objects rather than only by size.
    let spectra: Vec<Vec<u32>> = representatives
        .iter()
        .map(|&rep| {
            let mask = arcs[rep as usize];
            let mut spectrum = vec![0u32; 8];
            for &line in &plane.line_points {
                spectrum[(line & mask).count_ones() as usize] += 1;
            }
            spectrum
        })
        .collect();
    // Sort orbits canonically by (spectrum, size) so the two rings' lists are
    // directly comparable.
    let mut order: Vec<usize> = (0..representatives.len()).collect();
    order.sort_by(|&a, &b| spectra[a].cmp(&spectra[b]).then(sizes[a].cmp(&sizes[b])));
    let sizes = order.iter().map(|&i| sizes[i]).collect();
    let spectra = order.iter().map(|&i| spectra[i].clone()).collect();
    Ok((representatives.len(), sizes, spectra, verified))
}

// ---------------------------------------------------------------------------
// Codes over the chain ring, and their Gray images
// ---------------------------------------------------------------------------

struct CodeReport {
    length: usize,
    words: usize,
    min_hamming_ring: u32,
    min_homogeneous: u32,
    gray_length: usize,
    gray_words: usize,
    gray_min_distance: u32,
    gray_is_linear: bool,
}

/// Enumerate `{ a G : a in R^3 }` for a `3 x k` generator matrix and report the
/// ring-side weights and the Gray image.
fn code_from_generator(ring: Ring4, generator: &[[u8; 3]]) -> CodeReport {
    let k = generator.len();
    let mut words: Vec<Vec<u8>> = Vec::with_capacity(64);
    for code in 0..64usize {
        let a = [
            (code & 3) as u8,
            ((code >> 2) & 3) as u8,
            ((code >> 4) & 3) as u8,
        ];
        let word: Vec<u8> = (0..k)
            .map(|i| {
                let mut sum = 0u8;
                for j in 0..3 {
                    sum = ring.add(sum, ring.mul(a[j], generator[i][j]));
                }
                sum
            })
            .collect();
        words.push(word);
    }
    let mut distinct = words.clone();
    distinct.sort();
    distinct.dedup();
    let min_hamming_ring = words
        .iter()
        .filter(|w| w.iter().any(|&e| e != 0))
        .map(|w| w.iter().filter(|&&e| e != 0).count() as u32)
        .min()
        .unwrap_or(0);
    let min_homogeneous = words
        .iter()
        .filter(|w| w.iter().any(|&e| e != 0))
        .map(|w| w.iter().map(|&e| HOM_WEIGHT[e as usize]).sum::<u32>())
        .min()
        .unwrap_or(0);
    let gray: Vec<u64> = words
        .iter()
        .map(|w| {
            let mut bits = 0u64;
            for (i, &e) in w.iter().enumerate() {
                bits |= (GRAY[e as usize] as u64) << (2 * i);
            }
            bits
        })
        .collect();
    let mut gray_distinct = gray.clone();
    gray_distinct.sort_unstable();
    gray_distinct.dedup();
    let mut gray_min = u32::MAX;
    for i in 0..gray_distinct.len() {
        for j in (i + 1)..gray_distinct.len() {
            gray_min = gray_min.min((gray_distinct[i] ^ gray_distinct[j]).count_ones());
        }
    }
    let gray_is_linear = gray_distinct.iter().all(|&x| {
        gray_distinct
            .iter()
            .all(|&y| gray_distinct.binary_search(&(x ^ y)).is_ok())
    });
    CodeReport {
        length: k,
        words: distinct.len(),
        min_hamming_ring,
        min_homogeneous,
        gray_length: 2 * k,
        gray_words: gray_distinct.len(),
        gray_min_distance: if gray_min == u32::MAX { 0 } else { gray_min },
        gray_is_linear,
    }
}

fn code_report_json(report: &CodeReport) -> serde_json::Value {
    serde_json::json!({
        "ring_length": report.length,
        "ring_words": report.words,
        "min_hamming_over_ring": report.min_hamming_ring,
        "min_homogeneous_weight": report.min_homogeneous,
        "gray_length": report.gray_length,
        "gray_words": report.gray_words,
        "gray_min_distance": report.gray_min_distance,
        "gray_is_f2_linear": report.gray_is_linear,
    })
}

// ---------------------------------------------------------------------------
// The octacode: an independent Z4 calibration landmark
// ---------------------------------------------------------------------------

/// Polynomial remainder of `x^7 - 1` by a monic cubic over the ring.
fn divides_x7_minus_1(ring: Ring4, g: &[u8; 4]) -> bool {
    // x^7 - 1 as coefficients, low degree first.
    let mut rem = [0u8; 8];
    rem[0] = ring.neg(1);
    rem[7] = 1;
    for power in (3..8).rev() {
        let lead = rem[power];
        if lead == 0 {
            continue;
        }
        let shift = power - 3;
        for i in 0..4 {
            let product = ring.mul(lead, g[i]);
            rem[shift + i] = ring.add(rem[shift + i], ring.neg(product));
        }
    }
    rem[..3].iter().all(|&c| c == 0)
}

/// Build the extended cyclic code of length eight generated by `g`, whose
/// coordinates sum to zero; the octacode is the instance with minimum
/// homogeneous weight six.
fn octacode_candidate(ring: Ring4, g: &[u8; 4]) -> (usize, u32, u32, bool) {
    let mut words: Vec<Vec<u8>> = Vec::with_capacity(256);
    for code in 0..256usize {
        // message a0 + a1 x + a2 x^2 + a3 x^3 over R, times g, modulo nothing:
        // degree at most 6, so the product already lies in the cyclic code.
        let a = [
            (code & 3) as u8,
            ((code >> 2) & 3) as u8,
            ((code >> 4) & 3) as u8,
            ((code >> 6) & 3) as u8,
        ];
        let mut c = [0u8; 8];
        for (i, &ai) in a.iter().enumerate() {
            for (j, &gj) in g.iter().enumerate() {
                c[i + j] = ring.add(c[i + j], ring.mul(ai, gj));
            }
        }
        let mut sum = 0u8;
        for &e in c[..7].iter() {
            sum = ring.add(sum, e);
        }
        c[7] = ring.neg(sum);
        words.push(c.to_vec());
    }
    let mut distinct = words.clone();
    distinct.sort();
    distinct.dedup();
    let min_hom = words
        .iter()
        .filter(|w| w.iter().any(|&e| e != 0))
        .map(|w| w.iter().map(|&e| HOM_WEIGHT[e as usize]).sum::<u32>())
        .min()
        .unwrap_or(0);
    let gray: Vec<u32> = words
        .iter()
        .map(|w| {
            let mut bits = 0u32;
            for (i, &e) in w.iter().enumerate() {
                bits |= (GRAY[e as usize] as u32) << (2 * i);
            }
            bits
        })
        .collect();
    let mut gd = gray.clone();
    gd.sort_unstable();
    gd.dedup();
    let mut min_d = u32::MAX;
    for i in 0..gd.len() {
        for j in (i + 1)..gd.len() {
            min_d = min_d.min((gd[i] ^ gd[j]).count_ones());
        }
    }
    let linear = gd
        .iter()
        .all(|&x| gd.iter().all(|&y| gd.binary_search(&(x ^ y)).is_ok()));
    (
        distinct.len(),
        min_hom,
        if min_d == u32::MAX { 0 } else { min_d },
        linear,
    )
}

// ---------------------------------------------------------------------------
// Reference Howell form (what a ring-capable matrix layer must produce)
// ---------------------------------------------------------------------------

/// Enumerate the row module of a matrix over the chain ring.
fn row_module(ring: Ring4, rows: &[Vec<u8>], cols: usize) -> Vec<Vec<u8>> {
    let mut module: Vec<Vec<u8>> = vec![vec![0u8; cols]];
    for row in rows {
        let mut next = Vec::new();
        for base in &module {
            for scalar in 0..4u8 {
                let combined: Vec<u8> = (0..cols)
                    .map(|c| ring.add(base[c], ring.mul(scalar, row[c])))
                    .collect();
                next.push(combined);
            }
        }
        next.sort();
        next.dedup();
        module = next;
    }
    module
}

/// Reference Howell basis, derived from the enumerated module. Canonical by
/// construction: process columns left to right, prefer a unit pivot, fall back
/// to a radical pivot, and take the lexicographically least witness.
fn howell_basis(ring: Ring4, rows: &[Vec<u8>], cols: usize) -> Vec<Vec<u8>> {
    let module = row_module(ring, rows, cols);
    let mut basis: Vec<Vec<u8>> = Vec::new();
    let mut leading = 0usize;
    for col in 0..cols {
        let candidates: Vec<&Vec<u8>> = module
            .iter()
            .filter(|w| w[..col].iter().all(|&e| e == 0) && w[col] != 0)
            .collect();
        if candidates.is_empty() {
            continue;
        }
        let unit = candidates.iter().find(|w| Ring4::is_unit(w[col]));
        let pick = match unit {
            Some(w) => {
                let scale = Ring4::unit_inverse(w[col]);
                (0..cols)
                    .map(|c| ring.mul(w[c], scale))
                    .collect::<Vec<u8>>()
            }
            None => candidates
                .iter()
                .min_by(|a, b| a.cmp(b))
                .map(|w| (*w).clone())
                .unwrap(),
        };
        basis.push(pick);
        leading += 1;
        let _ = leading;
    }
    basis
}

// ---------------------------------------------------------------------------
// Core probes: where Ergodis breaks on chain-ring input
// ---------------------------------------------------------------------------

fn probe_no_entry_point() -> serde_json::Value {
    let prime4 = Prime::<4>::validate().err().map(|e| e.to_string());
    // `Matrix::new::<4>` no longer compiles: since core commit 67d79e05b the
    // `Prime<P>` arithmetic asserts primality at codegen, so a composite
    // modulus is a type-level error rather than a runtime `FieldError`.  The
    // runtime `validate` path above remains the only way to observe it.
    let matrix4 = Some(String::from(
        "rejected at compile time: Prime::<4> fails the VALID_MODULUS assertion",
    ));
    let unreduced_binary = Matrix::new::<2>(1, 2, vec![2u8, 3u8])
        .err()
        .map(|e| e.to_string());
    serde_json::json!({
        "kernel": "field::Prime / matrix::Matrix",
        "failure_mode": "no applicable entry point",
        "Prime_4_validate": prime4,
        "Matrix_new_4": matrix4,
        "Matrix_new_2_on_ring_entries": unreduced_binary,
    })
}

fn probe_order_four_arithmetic() -> serde_json::Value {
    let gf4 = SmallField::new(2, 2).expect("GF(4) is constructible");
    let mut rows = Vec::new();
    for ring in Ring4::ALL {
        let mut add_diff = 0;
        let mut mul_diff = 0;
        let mut add_cells = Vec::new();
        let mut mul_cells = Vec::new();
        for x in 0..4u8 {
            for y in 0..4u8 {
                if gf4.add(x, y) != ring.add(x, y) {
                    add_diff += 1;
                    add_cells.push(format!(
                        "{x}+{y}: GF4={} {}={}",
                        gf4.add(x, y),
                        ring.name(),
                        ring.add(x, y)
                    ));
                }
                if gf4.mul(x, y) != ring.mul(x, y) {
                    mul_diff += 1;
                    mul_cells.push(format!(
                        "{x}*{y}: GF4={} {}={}",
                        gf4.mul(x, y),
                        ring.name(),
                        ring.mul(x, y)
                    ));
                }
            }
        }
        // The static Gf4 must agree with the runtime SmallField(2,2).
        let static_matches = (0..4u8).all(|x| {
            let x = FieldElement::<Gf4>::new(x).expect("canonical GF(4) element");
            (0..4u8).all(|y| {
                let y = FieldElement::<Gf4>::new(y).expect("canonical GF(4) element");
                (x + y).value() == gf4.add(x.value(), y.value())
                    && (x * y).value() == gf4.mul(x.value(), y.value())
            })
        });
        rows.push(serde_json::json!({
            "ring": ring.name(),
            "addition_cells_differing_from_GF4": add_diff,
            "multiplication_cells_differing_from_GF4": mul_diff,
            "addition_witnesses": add_cells,
            "multiplication_witnesses": mul_cells,
            "static_Gf4_matches_runtime_SmallField": static_matches,
        }));
    }
    serde_json::json!({
        "kernel": "field::SmallField / field::Gf4",
        "failure_mode": "silent semantic substitution",
        "note": "SmallField::new(2,2) is GF(4); it is the only order-four arithmetic the core offers.",
        "rings": rows,
    })
}

fn probe_rank_oracle() -> serde_json::Value {
    let gf4 = SmallField::new(2, 2).expect("GF(4) is constructible");
    let mut rows = Vec::new();
    for ring in Ring4::ALL {
        let mut module_size_mismatch = 0u32;
        let mut membership_disagreements = 0u32;
        let mut membership_tests = 0u32;
        let mut howell_mismatch = 0u32;
        let mut first_witness: Option<String> = None;
        for code in 0..256usize {
            let entries: Vec<u8> = (0..4).map(|i| ((code >> (2 * i)) & 3) as u8).collect();
            let rows_ring = vec![entries[0..2].to_vec(), entries[2..4].to_vec()];
            let module = row_module(ring, &rows_ring, 2);
            let true_size = module.len();
            let matrix = Matrix::new_with_field(&gf4, 2, 2, entries.clone())
                .expect("entries are reduced modulo four");
            let basis = matrix
                .canonical_row_basis_with(&gf4)
                .expect("GF(4) elimination always succeeds");
            let field_size = 4usize.pow(basis.rows() as u32);
            if field_size != true_size {
                module_size_mismatch += 1;
                if first_witness.is_none() {
                    let mut w = String::new();
                    let _ =
                        write!(
                        w,
                        "[[{},{}],[{},{}]]: {} row module has {} elements, GF(4) rank {} claims {}",
                        entries[0], entries[1], entries[2], entries[3],
                        ring.name(), true_size, basis.rows(), field_size
                    );
                    first_witness = Some(w);
                }
            }
            // Membership oracle, vector by vector.
            for vcode in 0..16usize {
                let v = vec![(vcode & 3) as u8, ((vcode >> 2) & 3) as u8];
                let truth = module.contains(&v);
                let candidate = Matrix::new_with_field(&gf4, 1, 2, v.clone()).unwrap();
                let claim = basis
                    .row_space_contains_field::<Gf4>(&candidate)
                    .unwrap_or(false);
                membership_tests += 1;
                if truth != claim {
                    membership_disagreements += 1;
                }
            }
            // Reference Howell form must reproduce the module exactly.
            let howell = howell_basis(ring, &rows_ring, 2);
            if row_module(ring, &howell, 2).len() != true_size {
                howell_mismatch += 1;
            }
        }
        rows.push(serde_json::json!({
            "ring": ring.name(),
            "matrices_tested": 256,
            "row_module_size_mismatches": module_size_mismatch,
            "membership_tests": membership_tests,
            "membership_disagreements": membership_disagreements,
            "reference_howell_module_mismatches": howell_mismatch,
            "first_witness": first_witness,
        }));
    }
    serde_json::json!({
        "kernel": "matrix::canonical_row_basis / row_space_contains",
        "failure_mode": "silently wrong answer",
        "rings": rows,
    })
}

fn probe_projective_index(plane: &Phg2) -> serde_json::Value {
    let gf4 = SmallField::new(2, 2).expect("GF(4) is constructible");
    let indexer = ProjectiveIndex::new(&gf4, 2).expect("PG(2,4) indexer");
    let ring = plane.ring;
    let mut classes: BTreeMap<u64, Vec<usize>> = BTreeMap::new();
    let mut phantom = 0u32;
    let mut rejected = 0u32;
    for code in 0..64usize {
        let v = [
            (code & 3) as u8,
            ((code >> 2) & 3) as u8,
            ((code >> 4) & 3) as u8,
        ];
        let unimodular = v.iter().any(|&e| Ring4::is_unit(e));
        match indexer.index(&v) {
            Ok(i) => {
                if unimodular {
                    classes.entry(i).or_default().push(code);
                } else {
                    // A nonzero vector with all coordinates in the radical is
                    // not a point of PHG(2,R), but PG(2,4) accepts it.
                    phantom += 1;
                }
            }
            Err(_) => {
                if unimodular {
                    rejected += 1;
                }
            }
        }
    }
    // How badly does the field indexer partition the ring points?
    let mut split = 0u32;
    let mut merged = 0u32;
    for members in classes.values() {
        let ring_points: Vec<usize> = members
            .iter()
            .map(|&code| {
                let v = [
                    (code & 3) as u8,
                    ((code >> 2) & 3) as u8,
                    ((code >> 4) & 3) as u8,
                ];
                plane
                    .point_index(canonical(ring, v).expect("unimodular"))
                    .expect("indexed")
            })
            .collect();
        let mut distinct = ring_points.clone();
        distinct.sort_unstable();
        distinct.dedup();
        if distinct.len() > 1 {
            merged += 1;
        }
    }
    // Count Hjelmslev points whose two representatives land on different
    // field-side indices.
    for p in 0..plane.points.len() {
        let rep = plane.points[p];
        let other = [
            ring.mul(rep[0], 3),
            ring.mul(rep[1], 3),
            ring.mul(rep[2], 3),
        ];
        let a = indexer.index(&rep).ok();
        let b = indexer.index(&other).ok();
        if a != b {
            split += 1;
        }
    }
    serde_json::json!({
        "kernel": "projective::ProjectiveIndex",
        "failure_mode": "wrong object, silently",
        "ring": ring.name(),
        "field_point_count_PG_2_4": indexer.point_count(),
        "true_point_count_PHG_2_R": plane.points.len(),
        "phantom_points_accepted": phantom,
        "unimodular_vectors_rejected": rejected,
        "field_classes_merging_distinct_ring_points": merged,
        "ring_points_split_across_field_classes": split,
    })
}

fn probe_distance_kernel(
    gray_words: &[u64],
    gray_length: usize,
    true_distance: u32,
) -> serde_json::Value {
    // The nearest available core path: take the F2-span of the Gray image and
    // ask the binary linear-code kernel for its minimum weight.
    let mut basis: Vec<u64> = Vec::new();
    for &w in gray_words {
        let mut x = w;
        for &b in &basis {
            x = x.min(x ^ b);
        }
        if x != 0 {
            basis.push(x);
            basis.sort_unstable_by(|a, b| b.cmp(a));
        }
    }
    let dim = basis.len();
    let data: Vec<u8> = basis
        .iter()
        .flat_map(|&w| (0..gray_length).map(move |i| ((w >> i) & 1) as u8))
        .collect();
    let generator = Matrix::new::<2>(dim, gray_length, data).expect("binary generator");
    let compiled = CompiledBinaryLinearCode::compile(&generator).expect("compiles");
    let result = compiled.minimum_nonzero_weight();
    serde_json::json!({
        "kernel": "linear_code::CompiledBinaryLinearCode",
        "failure_mode": "silently wrong answer via the nearest available path",
        "gray_image_words": gray_words.len(),
        "gray_image_true_min_distance": true_distance,
        "f2_span_dimension": dim,
        "f2_span_words": 1u64 << dim,
        "core_reported_min_weight": result.weight,
        "note": "the Gray image is not F2-linear, so the only distance kernel in the core has no correct input for it",
    })
}

// ---------------------------------------------------------------------------
// Driver
// ---------------------------------------------------------------------------

/// Flag names and defaults reproduce the hand-rolled `std::env::args` parser the
/// standalone binary used, so committed replay commands are unchanged.
#[derive(clap::Args)]
pub struct ChainRingArgs {
    /// Report output directory. Defaults to `$HOME/.cache/ergodis/c1028`.
    #[arg(long)]
    out: Option<PathBuf>,
    /// Also write the compact certificate here.
    #[arg(long)]
    cert: Option<PathBuf>,
}

pub fn run(cli: ChainRingArgs) -> anyhow::Result<()> {
    let out_dir = cli.out.unwrap_or_else(|| {
        PathBuf::from(std::env::var("HOME").unwrap_or_else(|_| ".".into()))
            .join(".cache/ergodis/c1028")
    });
    let cert_path: Option<PathBuf> = cli.cert;
    fs::create_dir_all(&out_dir)?;
    let started = Instant::now();

    let generators = gl3_generators();
    let mut rings_json = Vec::new();
    let mut gap_json = vec![
        probe_no_entry_point(),
        probe_order_four_arithmetic(),
        probe_rank_oracle(),
    ];
    let mut distance_probe = serde_json::Value::Null;

    for ring in Ring4::ALL {
        let plane = Phg2::new(ring);
        let structure = plane.structure();
        let group_order = gl3_order(ring);
        let generated = generated_order(ring, &generators);

        let mut arcs_json = Vec::new();
        let mut hyperoval_code: Option<CodeReport> = None;
        let mut hyperoval_gray: Vec<u64> = Vec::new();
        for bound in 0..=6u32 {
            let t0 = Instant::now();
            let (best, maxima, nodes) = arc_census(&plane, bound);
            let (orbits, orbit_sizes, orbit_spectra, verified) = if maxima.len() <= 4_000_000 {
                classify_arcs(&plane, &maxima, &generators)?
            } else {
                (0, Vec::new(), Vec::new(), false)
            };
            arcs_json.push(serde_json::json!({
                "n": bound,
                "m_n": best,
                "maximum_arcs": maxima.len(),
                "orbits_under_GL3": orbits,
                "orbit_sizes": orbit_sizes,
                "orbit_line_spectra": orbit_spectra,
                "core_orbit_certificate_verified": verified,
                "search_nodes": nodes,
                "seconds": t0.elapsed().as_secs_f64(),
                "first_maximum_arc_points": maxima
                    .first()
                    .map(|&m| (0..POINTS).filter(|i| m >> i & 1 == 1).collect::<Vec<_>>()),
            }));
            if bound == 2 {
                let mask = *maxima.first().expect("a maximum 2-arc exists");
                let columns: Vec<[u8; 3]> = (0..POINTS)
                    .filter(|i| mask >> i & 1 == 1)
                    .map(|i| plane.points[i])
                    .collect();
                let report = code_from_generator(ring, &columns);
                // Recompute the Gray image words for the distance probe.
                let mut words = Vec::new();
                for code in 0..64usize {
                    let a = [
                        (code & 3) as u8,
                        ((code >> 2) & 3) as u8,
                        ((code >> 4) & 3) as u8,
                    ];
                    let mut bits = 0u64;
                    for (i, col) in columns.iter().enumerate() {
                        let mut sum = 0u8;
                        for j in 0..3 {
                            sum = ring.add(sum, ring.mul(a[j], col[j]));
                        }
                        bits |= (GRAY[sum as usize] as u64) << (2 * i);
                    }
                    words.push(bits);
                }
                words.sort_unstable();
                words.dedup();
                if ring == Ring4::Z4 {
                    hyperoval_gray = words.clone();
                }
                hyperoval_code = Some(report);
            }
        }

        // Octacode search: every monic cubic dividing x^7 - 1, extended.
        let mut octacode = Vec::new();
        for code in 0..64usize {
            let g = [
                (code & 3) as u8,
                ((code >> 2) & 3) as u8,
                ((code >> 4) & 3) as u8,
                1u8,
            ];
            if !divides_x7_minus_1(ring, &g) {
                continue;
            }
            let (words, min_hom, gray_d, linear) = octacode_candidate(ring, &g);
            octacode.push(serde_json::json!({
                "generator_poly_low_to_high": g,
                "words": words,
                "min_homogeneous_weight": min_hom,
                "gray_length": 16,
                "gray_min_distance": gray_d,
                "gray_is_f2_linear": linear,
            }));
        }

        if ring == Ring4::Z4 {
            let true_d = hyperoval_code
                .as_ref()
                .map(|r| r.gray_min_distance)
                .unwrap_or(0);
            distance_probe = probe_distance_kernel(&hyperoval_gray, 14, true_d);
            gap_json.push(probe_projective_index(&plane));
        }

        rings_json.push(serde_json::json!({
            "ring": ring.name(),
            "plane_structure": structure,
            "GL3_order_bruteforce": group_order,
            "GL3_order_from_generators": generated,
            "generators_generate_full_group": group_order == generated,
            "arc_census": arcs_json,
            "hyperoval_code": hyperoval_code.as_ref().map(code_report_json),
            "extended_cyclic_length_8_codes": octacode,
        }));
    }
    gap_json.push(distance_probe);

    let document = serde_json::json!({
        "task": "C1028",
        "lane": "gem-mining",
        "title": "Chain-ring instrument test: Ergodis against PHG(2,R) and R-linear codes, |R| = 4",
        "published_ground_truth": {
            "source": "Honold, Kiermaier, Landjev, arXiv:2409.02099v1, Table 3",
            "sha256": "e000b315c711d754a7940f090ceab9e48d03e3457f172388450dda182ff6cdbd",
            "m_n_Z4": [0, 1, 7, 10, 16, 22, 28],
            "m_n_S2": [0, 1, 6, 10, 16, 22, 28],
            "hyperoval_gray_image": "(14, 2^6, 6) optimal nonlinear binary code",
            "octacode_gray_image": "(16, 256, 6) Nordstrom-Robinson code"
        },
        "rings": rings_json,
        "core_gap_specification": gap_json,
        "elapsed_seconds": started.elapsed().as_secs_f64(),
    });

    let full = out_dir.join("c1028-chain-ring-report.json");
    fs::write(&full, serde_json::to_string_pretty(&document)? + "\n")?;
    println!("full report: {}", full.display());

    if let Some(path) = cert_path {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }
        let certificate = compact_certificate(&document);
        fs::write(&path, serde_json::to_string_pretty(&certificate)? + "\n")?;
        println!("certificate: {}", path.display());
    }
    println!("{}", summary(&document));
    Ok(())
}

fn compact_certificate(document: &serde_json::Value) -> serde_json::Value {
    let rings = document["rings"].as_array().cloned().unwrap_or_default();
    let arcs: Vec<serde_json::Value> = rings
        .iter()
        .map(|r| {
            serde_json::json!({
                "ring": r["ring"],
                "points": r["plane_structure"]["points"],
                "lines": r["plane_structure"]["lines"],
                "line_sizes": r["plane_structure"]["line_sizes_distinct"],
                "neighbour_classes": r["plane_structure"]["neighbour_class_count"],
                "GL3_order": r["GL3_order_bruteforce"],
                "m_n": r["arc_census"].as_array().map(|a| {
                    a.iter().map(|e| e["m_n"].clone()).collect::<Vec<_>>()
                }),
                "maximum_arc_counts": r["arc_census"].as_array().map(|a| {
                    a.iter().map(|e| e["maximum_arcs"].clone()).collect::<Vec<_>>()
                }),
                "orbits_under_GL3": r["arc_census"].as_array().map(|a| {
                    a.iter().map(|e| e["orbits_under_GL3"].clone()).collect::<Vec<_>>()
                }),
                "orbit_line_spectra": r["arc_census"].as_array().map(|a| {
                    a.iter().map(|e| e["orbit_line_spectra"].clone()).collect::<Vec<_>>()
                }),
                "orbit_certificates_verified": r["arc_census"].as_array().map(|a| {
                    a.iter().map(|e| e["core_orbit_certificate_verified"].clone()).collect::<Vec<_>>()
                }),
                "hyperoval_code": r["hyperoval_code"],
            })
        })
        .collect();
    serde_json::json!({
        "task": document["task"],
        "title": document["title"],
        "published_ground_truth": document["published_ground_truth"],
        "computed": arcs,
        "core_gap_specification": document["core_gap_specification"],
    })
}

fn summary(document: &serde_json::Value) -> String {
    let mut out = String::new();
    for ring in document["rings"].as_array().unwrap_or(&Vec::new()) {
        let name = ring["ring"].as_str().unwrap_or("?");
        let values: Vec<String> = ring["arc_census"]
            .as_array()
            .unwrap_or(&Vec::new())
            .iter()
            .map(|e| e["m_n"].to_string())
            .collect();
        let _ = writeln!(out, "m_n({name}) = [{}]", values.join(", "));
    }
    out
}
