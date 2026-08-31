//! C1020 — reconstruction of Brouwer's exceptional complete-exterior-set census.
//!
//! Blokhuis--Seress--Wilbrink, *Characterization of complete exterior sets of
//! conics*, Combinatorica 12 (2) (1992) 143--147, section 3, reports a complete
//! classification up to isomorphism, credited to Andries Brouwer, of the
//! complete exterior sets of a conic in `PG(2,q)` that are not the exterior
//! points of a single passant line, for `q = 7, 11, 19, 23, 27, 31`, with none
//! for `q = 43, ..., 131`.
//!
//! This driver reconstructs that census independently and runs the gem-mining
//! lane's own invariants over every member.
//!
//! Definitions used, all standard and all checked in code rather than assumed:
//!
//! * `C` is the conic `x0 x2 = x1^2` in `PG(2,q)`, `q` odd.
//! * A line is a *secant*, *tangent* or *passant* as it meets `C` in 2, 1 or 0
//!   points. A point off `C` is *external* if it lies on 2 tangents and
//!   *internal* if it lies on none.
//! * An *exterior set* is a set of external points whose pairwise joins are all
//!   passants. It is *complete* when it is maximal under inclusion.
//!
//! The search runs on the graph `G` whose vertices are the `q(q+1)/2` external
//! points and whose edges are the pairs whose join is a passant; complete
//! exterior sets are exactly the maximal cliques of `G`. `PGL(2,q)`, the
//! stabiliser of `C` in `PGL(3,q)`, is transitive on external points, so every
//! isomorphism class has a representative containing a fixed external point and
//! the enumeration is exhaustive over maximal cliques of the neighbourhood of
//! that point.
//!
//! Ergodis core is read-only here: this binary is additive under `src/bin`
//! autodiscovery and edits no manifest.

use std::collections::{BTreeMap, BTreeSet, HashMap, HashSet};
use std::fmt::Write as _;
use std::fs;
use std::path::PathBuf;

use anyhow::{bail, Context, Result};
use clap::Parser;
use ergodis::field::SmallField;
use ergodis::projective::ProjectiveIndex;
use serde::Serialize;
use sha2::{Digest, Sha256};

#[derive(Parser, Debug)]
#[command(
    name = "c1020-exterior-sets",
    about = "Exhaustive complete-exterior-set census of a conic in PG(2,q)"
)]
struct Args {
    /// Odd prime power orders to census.
    #[arg(long, value_delimiter = ',', num_args = 1..)]
    q: Vec<u16>,
    /// Include field automorphisms (full P\Gamma L(2,q)) when q is not prime.
    #[arg(long, default_value_t = true)]
    gamma: bool,
    /// Abort a cell if it produces more maximal cliques than this.
    #[arg(long, default_value_t = 4_000_000)]
    max_cliques: usize,
    /// Write the machine-readable certificate here.
    #[arg(long)]
    json_out: Option<PathBuf>,
    /// Analyse one explicit point set (indices in the canonical PG(2,q) ranking)
    /// instead of running the census. Requires exactly one `--q`.
    #[arg(long, value_delimiter = ',', num_args = 1..)]
    points: Vec<usize>,
}

// ---------------------------------------------------------------------------
// plane
// ---------------------------------------------------------------------------

const ON_CONIC: u8 = 0;
const EXTERNAL: u8 = 1;
const INTERNAL: u8 = 2;

struct Plane {
    field: SmallField,
    q: u16,
    p: u8,
    h: u8,
    n: usize,
    coords: Vec<[u8; 3]>,
    ptype: Vec<u8>,
    conic_points: Vec<u32>,
    line_conic: Vec<u8>,
    externals: Vec<u32>,
    external_slot: Vec<i32>,
}

fn factor_prime_power(q: u16) -> Result<(u8, u8)> {
    if q < 2 {
        bail!("q = {q} is not a prime power");
    }
    for p in 2u16..=q {
        if q % p != 0 {
            continue;
        }
        let mut rest = q;
        let mut h = 0u8;
        while rest % p == 0 {
            rest /= p;
            h += 1;
        }
        if rest != 1 {
            bail!("q = {q} is not a prime power");
        }
        return Ok((u8::try_from(p).context("characteristic exceeds u8")?, h));
    }
    bail!("q = {q} is not a prime power")
}

impl Plane {
    fn new(q: u16) -> Result<Self> {
        let (p, h) = factor_prime_power(q)?;
        if p == 2 {
            bail!("q = {q} is even; the internal/external dichotomy is undefined in characteristic two");
        }
        let field = SmallField::new(p, h).map_err(|e| anyhow::anyhow!("field GF({q}): {e}"))?;
        let index = ProjectiveIndex::new(&field, 2)
            .map_err(|e| anyhow::anyhow!("projective index PG(2,{q}): {e}"))?;
        let n = usize::try_from(index.point_count()).context("point count overflow")?;
        let mut coords = Vec::with_capacity(n);
        for i in 0..n as u64 {
            let point = index
                .point_owned(i)
                .map_err(|e| anyhow::anyhow!("unrank {i}: {e}"))?;
            coords.push([point[0], point[1], point[2]]);
        }

        // Q(x) = x0 x2 - x1^2 ; B(x,y) = x0 y2 - 2 x1 y1 + x2 y0 = 2 * (polarised Q).
        let quad = |c: &[u8; 3]| -> u8 {
            let prod = field.mul(c[0], c[2]);
            let square = field.mul(c[1], c[1]);
            field.sub(prod, square)
        };
        let bilinear = |a: &[u8; 3], b: &[u8; 3]| -> u8 {
            let t0 = field.mul(a[0], b[2]);
            let t2 = field.mul(a[2], b[0]);
            let mid = field.mul(a[1], b[1]);
            let twice = field.add(mid, mid);
            field.sub(field.add(t0, t2), twice)
        };

        let mut conic_points = Vec::new();
        for (i, c) in coords.iter().enumerate() {
            if quad(c) == 0 {
                conic_points.push(i as u32);
            }
        }
        if conic_points.len() != usize::from(q) + 1 {
            bail!(
                "conic has {} points, expected {}",
                conic_points.len(),
                q + 1
            );
        }

        // point types via tangent count; tangent at conic point c is the polar of c.
        let mut ptype = vec![ON_CONIC; n];
        for (i, c) in coords.iter().enumerate() {
            if quad(c) == 0 {
                continue;
            }
            let mut tangents = 0u32;
            for &cp in &conic_points {
                if bilinear(c, &coords[cp as usize]) == 0 {
                    tangents += 1;
                }
            }
            ptype[i] = match tangents {
                2 => EXTERNAL,
                0 => INTERNAL,
                other => bail!("point {i} lies on {other} tangents"),
            };
        }

        // line index space is the same ranking applied to coefficient triples.
        let mut line_conic = vec![0u8; n];
        for (l, lc) in coords.iter().enumerate() {
            let mut hits = 0u8;
            for &cp in &conic_points {
                let c = &coords[cp as usize];
                let dot = field.add(
                    field.add(field.mul(lc[0], c[0]), field.mul(lc[1], c[1])),
                    field.mul(lc[2], c[2]),
                );
                if dot == 0 {
                    hits += 1;
                }
            }
            line_conic[l] = hits;
        }

        let mut externals = Vec::new();
        let mut external_slot = vec![-1i32; n];
        for (i, &t) in ptype.iter().enumerate() {
            if t == EXTERNAL {
                external_slot[i] = externals.len() as i32;
                externals.push(i as u32);
            }
        }
        let expected_ext = usize::from(q) * (usize::from(q) + 1) / 2;
        if externals.len() != expected_ext {
            bail!(
                "found {} external points, expected {expected_ext}",
                externals.len()
            );
        }

        Ok(Self {
            field,
            q,
            p,
            h,
            n,
            coords,
            ptype,
            conic_points,
            line_conic,
            externals,
            external_slot,
        })
    }

    fn cross(&self, a: &[u8; 3], b: &[u8; 3]) -> [u8; 3] {
        let f = &self.field;
        [
            f.sub(f.mul(a[1], b[2]), f.mul(a[2], b[1])),
            f.sub(f.mul(a[2], b[0]), f.mul(a[0], b[2])),
            f.sub(f.mul(a[0], b[1]), f.mul(a[1], b[0])),
        ]
    }

    fn rank(&self, index: &ProjectiveIndex<'_>, v: &[u8; 3]) -> Result<usize> {
        let r = index
            .index(v)
            .map_err(|e| anyhow::anyhow!("rank {v:?}: {e}"))?;
        Ok(usize::try_from(r).context("rank overflow")?)
    }

    /// Line joining two distinct points, as a line index.
    fn join(&self, index: &ProjectiveIndex<'_>, a: usize, b: usize) -> Result<usize> {
        let v = self.cross(&self.coords[a], &self.coords[b]);
        self.rank(index, &v)
    }

    fn on_line(&self, line: usize, point: usize) -> bool {
        let f = &self.field;
        let l = &self.coords[line];
        let c = &self.coords[point];
        f.add(
            f.add(f.mul(l[0], c[0]), f.mul(l[1], c[1])),
            f.mul(l[2], c[2]),
        ) == 0
    }
}

// ---------------------------------------------------------------------------
// group: PGL(2,q) via the symmetric square, optionally extended by Frobenius
// ---------------------------------------------------------------------------

fn build_group(
    plane: &Plane,
    index: &ProjectiveIndex<'_>,
    gamma: bool,
) -> Result<(Vec<Vec<u16>>, usize, usize)> {
    let f = &plane.field;
    let q = usize::from(plane.q);
    let order = u8::try_from(plane.q).unwrap_or(0);
    let _ = order;
    let mut mats = Vec::new();
    // normalized 2x2 invertible matrices over F_q, one per PGL class
    for a in 0..q as u8 {
        for b in 0..q as u8 {
            for c in 0..q as u8 {
                for d in 0..q as u8 {
                    if f.sub(f.mul(a, d), f.mul(b, c)) == 0 {
                        continue;
                    }
                    let lead = [a, b, c, d].into_iter().find(|&x| x != 0).unwrap();
                    if lead != 1 {
                        continue;
                    }
                    mats.push([a, b, c, d]);
                }
            }
        }
    }
    let expected = q * q * q - q;
    if mats.len() != expected {
        bail!("|PGL(2,{})| = {} but enumerated {}", plane.q, expected, mats.len());
    }

    let frobenius_steps = if gamma && plane.h > 1 {
        usize::from(plane.h)
    } else {
        1
    };

    let mut perms: Vec<Vec<u16>> = Vec::with_capacity(mats.len() * frobenius_steps);
    // Frobenius on point indices, applied j times.
    let mut frob = vec![0u16; plane.n];
    for i in 0..plane.n {
        let c = plane.coords[i];
        let image = [
            f.pow(c[0], u16::from(plane.p)),
            f.pow(c[1], u16::from(plane.p)),
            f.pow(c[2], u16::from(plane.p)),
        ];
        frob[i] = u16::try_from(plane.rank(index, &image)?).context("index overflow")?;
    }

    for m in &mats {
        let [a, b, c, d] = *m;
        let s = [
            [f.mul(a, a), f.add(f.mul(a, b), f.mul(a, b)), f.mul(b, b)],
            [
                f.mul(a, c),
                f.add(f.mul(a, d), f.mul(b, c)),
                f.mul(b, d),
            ],
            [f.mul(c, c), f.add(f.mul(c, d), f.mul(c, d)), f.mul(d, d)],
        ];
        let mut base = vec![0u16; plane.n];
        for i in 0..plane.n {
            let x = plane.coords[i];
            let mut image = [0u8; 3];
            for (r, row) in s.iter().enumerate() {
                let mut acc = 0u8;
                for k in 0..3 {
                    acc = f.add(acc, f.mul(row[k], x[k]));
                }
                image[r] = acc;
            }
            base[i] = u16::try_from(plane.rank(index, &image)?).context("index overflow")?;
        }
        // conic must be preserved
        for &cp in &plane.conic_points {
            if plane.ptype[usize::from(base[cp as usize])] != ON_CONIC {
                bail!("symmetric-square lift does not preserve the conic");
            }
        }
        perms.push(base.clone());
        let mut current = base;
        for _ in 1..frobenius_steps {
            let next: Vec<u16> = (0..plane.n)
                .map(|i| current[usize::from(frob[i])])
                .collect();
            perms.push(next.clone());
            current = next;
        }
    }
    Ok((perms, mats.len(), frobenius_steps))
}

// ---------------------------------------------------------------------------
// Bron-Kerbosch with pivoting over a bitset graph
// ---------------------------------------------------------------------------

struct BitGraph {
    m: usize,
    words: usize,
    adj: Vec<u64>,
}

impl BitGraph {
    fn new(m: usize) -> Self {
        let words = m.div_ceil(64);
        Self {
            m,
            words,
            adj: vec![0u64; m * words],
        }
    }
    fn set(&mut self, i: usize, j: usize) {
        self.adj[i * self.words + j / 64] |= 1u64 << (j % 64);
        self.adj[j * self.words + i / 64] |= 1u64 << (i % 64);
    }
    fn row(&self, i: usize) -> &[u64] {
        &self.adj[i * self.words..(i + 1) * self.words]
    }
}

fn popcount(v: &[u64]) -> u32 {
    v.iter().map(|w| w.count_ones()).sum()
}

fn iter_bits(v: &[u64], mut f: impl FnMut(usize)) {
    for (wi, &w) in v.iter().enumerate() {
        let mut w = w;
        while w != 0 {
            let b = w.trailing_zeros() as usize;
            f(wi * 64 + b);
            w &= w - 1;
        }
    }
}

fn bron_kerbosch(
    g: &BitGraph,
    r: &mut Vec<usize>,
    p: Vec<u64>,
    x: Vec<u64>,
    out: &mut Vec<Vec<usize>>,
    cap: usize,
) -> Result<()> {
    if out.len() > cap {
        bail!("maximal-clique cap exceeded");
    }
    if popcount(&p) == 0 && popcount(&x) == 0 {
        out.push(r.clone());
        return Ok(());
    }
    // pivot: maximize |P ∩ N(u)| over u in P ∪ X
    let mut best = usize::MAX;
    let mut best_count = -1i64;
    let mut consider = |u: usize| {
        let row = g.row(u);
        let mut c = 0u32;
        for w in 0..g.words {
            c += (p[w] & row[w]).count_ones();
        }
        if i64::from(c) > best_count {
            best_count = i64::from(c);
            best = u;
        }
    };
    iter_bits(&p, &mut consider);
    iter_bits(&x, &mut consider);

    let mut candidates = p.clone();
    if best != usize::MAX {
        let row = g.row(best);
        for w in 0..g.words {
            candidates[w] &= !row[w];
        }
    }

    let mut order = Vec::new();
    iter_bits(&candidates, |v| order.push(v));

    let mut p = p;
    let mut x = x;
    for v in order {
        let row = g.row(v);
        let np: Vec<u64> = (0..g.words).map(|w| p[w] & row[w]).collect();
        let nx: Vec<u64> = (0..g.words).map(|w| x[w] & row[w]).collect();
        r.push(v);
        bron_kerbosch(g, r, np, nx, out, cap)?;
        r.pop();
        p[v / 64] &= !(1u64 << (v % 64));
        x[v / 64] |= 1u64 << (v % 64);
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// combinatorics of a six-arc
// ---------------------------------------------------------------------------

fn perfect_matchings_of_six() -> Vec<[(usize, usize); 3]> {
    let mut out = Vec::new();
    let rest = [1usize, 2, 3, 4, 5];
    for i in 0..5 {
        let a = rest[i];
        let others: Vec<usize> = rest.iter().copied().filter(|&x| x != a).collect();
        // pair 0 with a, then match the remaining four in three ways
        for (j, k) in [(0usize, 1usize), (0, 2), (0, 3)] {
            let b = others[j];
            let c = others[k];
            let last: Vec<usize> = others
                .iter()
                .copied()
                .filter(|&x| x != b && x != c)
                .collect();
            out.push([(0, a), (b, c), (last[0], last[1])]);
        }
    }
    out
}

#[derive(Serialize, Clone, Debug)]
struct BrianchonReport {
    arc_points: Vec<usize>,
    concurrent_matchings: usize,
    brianchon_points: Vec<usize>,
    brianchon_types: BTreeMap<String, usize>,
    chords_with_two_brianchon_points: usize,
    chord_graph_degrees: Vec<usize>,
    chord_graph_is_petersen: bool,
    matching_disjointness_graph_is_petersen: bool,
}

fn petersen_test(adj: &[Vec<bool>]) -> bool {
    let n = adj.len();
    if n != 10 {
        return false;
    }
    for i in 0..n {
        if adj[i].iter().filter(|&&b| b).count() != 3 {
            return false;
        }
    }
    for i in 0..n {
        for j in (i + 1)..n {
            let common = (0..n).filter(|&k| adj[i][k] && adj[j][k]).count();
            let want = if adj[i][j] { 0 } else { 1 };
            if common != want {
                return false;
            }
        }
    }
    true
}

fn analyse_six_arc(
    plane: &Plane,
    index: &ProjectiveIndex<'_>,
    arc: &[usize],
) -> Result<Option<BrianchonReport>> {
    if arc.len() != 6 {
        return Ok(None);
    }
    // arc test: no three collinear
    for i in 0..6 {
        for j in (i + 1)..6 {
            let line = plane.join(index, arc[i], arc[j])?;
            for k in (j + 1)..6 {
                if plane.on_line(line, arc[k]) {
                    return Ok(None);
                }
            }
        }
    }
    let mut chord = [[0usize; 6]; 6];
    for i in 0..6 {
        for j in 0..6 {
            if i != j {
                chord[i][j] = plane.join(index, arc[i], arc[j])?;
            }
        }
    }
    let matchings = perfect_matchings_of_six();
    let mut concurrent: Vec<(usize, usize)> = Vec::new(); // (matching id, point)
    for (mid, m) in matchings.iter().enumerate() {
        let l0 = chord[m[0].0][m[0].1];
        let l1 = chord[m[1].0][m[1].1];
        let l2 = chord[m[2].0][m[2].1];
        let v = plane.cross(&plane.coords[l0], &plane.coords[l1]);
        if v == [0, 0, 0] {
            continue;
        }
        let pt = plane.rank(index, &v)?;
        if !plane.on_line(l2, pt) {
            continue;
        }
        if arc.contains(&pt) {
            continue;
        }
        concurrent.push((mid, pt));
    }
    let points: Vec<usize> = concurrent.iter().map(|&(_, p)| p).collect();
    let distinct: BTreeSet<usize> = points.iter().copied().collect();
    let mut types: BTreeMap<String, usize> = BTreeMap::new();
    for &p in &distinct {
        let key = match plane.ptype[p] {
            ON_CONIC => "on_conic",
            EXTERNAL => "external",
            _ => "internal",
        };
        *types.entry(key.to_string()).or_insert(0) += 1;
    }

    let verts: Vec<usize> = distinct.iter().copied().collect();
    let vpos: HashMap<usize, usize> = verts.iter().enumerate().map(|(i, &p)| (p, i)).collect();
    let mut adj = vec![vec![false; verts.len()]; verts.len()];
    let mut chords_with_two = 0usize;
    let mut all_chords: BTreeSet<usize> = BTreeSet::new();
    for i in 0..6 {
        for j in (i + 1)..6 {
            all_chords.insert(chord[i][j]);
        }
    }
    for &l in &all_chords {
        let on: Vec<usize> = verts
            .iter()
            .copied()
            .filter(|&p| plane.on_line(l, p))
            .collect();
        if on.len() == 2 {
            chords_with_two += 1;
            let a = vpos[&on[0]];
            let b = vpos[&on[1]];
            adj[a][b] = true;
            adj[b][a] = true;
        }
    }
    let degrees: Vec<usize> = adj
        .iter()
        .map(|row| row.iter().filter(|&&b| b).count())
        .collect();

    // matching-disjointness graph on the concurrent matchings
    let mut madj = vec![vec![false; concurrent.len()]; concurrent.len()];
    for a in 0..concurrent.len() {
        for b in (a + 1)..concurrent.len() {
            let ma = &matchings[concurrent[a].0];
            let mb = &matchings[concurrent[b].0];
            let shares = ma.iter().any(|&(x, y)| {
                mb.iter()
                    .any(|&(u, v)| (x, y) == (u, v) || (x, y) == (v, u))
            });
            if !shares {
                madj[a][b] = true;
                madj[b][a] = true;
            }
        }
    }

    Ok(Some(BrianchonReport {
        arc_points: arc.to_vec(),
        concurrent_matchings: concurrent.len(),
        brianchon_points: verts.clone(),
        brianchon_types: types,
        chords_with_two_brianchon_points: chords_with_two,
        chord_graph_degrees: degrees,
        chord_graph_is_petersen: petersen_test(&adj),
        matching_disjointness_graph_is_petersen: petersen_test(&madj),
    }))
}

// ---------------------------------------------------------------------------
// per-configuration invariants
// ---------------------------------------------------------------------------

#[derive(Serialize, Clone, Debug)]
struct ConfigReport {
    size: usize,
    linear: bool,
    is_arc: bool,
    orbit_size: usize,
    stabiliser_order_pgl: usize,
    stabiliser_order_full: usize,
    line_profile: BTreeMap<String, usize>,
    canonical_points: Vec<usize>,
    canonical_coordinates: Vec<[u8; 3]>,
    six_arc_split: Option<BrianchonReport>,
    six_arc_split_is_exactly_complement: bool,
}

#[derive(Serialize, Clone, Debug)]
struct CellReport {
    q: u16,
    characteristic: u8,
    degree: u8,
    plane_points: usize,
    conic_points: usize,
    external_points: usize,
    internal_points: usize,
    passant_lines: usize,
    group_order_pgl: usize,
    group_order_full: usize,
    neighbourhood_size: usize,
    maximal_cliques_through_base_point: usize,
    size_histogram: BTreeMap<usize, usize>,
    classes: Vec<ConfigReport>,
    exceptional_classes: usize,
    linear_classes: usize,
}



fn run_cell(args: &Args, q: u16) -> Result<CellReport> {
    let plane = Plane::new(q)?;
    let index = ProjectiveIndex::new(&plane.field, 2)
        .map_err(|e| anyhow::anyhow!("projective index: {e}"))?;
    let (perms, pgl_order, frob_steps) = build_group(&plane, &index, args.gamma)?;

    let internal_count = plane.ptype.iter().filter(|&&t| t == INTERNAL).count();
    let passants = plane.line_conic.iter().filter(|&&c| c == 0).count();

    // graph on external points
    let m_ext = plane.externals.len();
    let mut full = BitGraph::new(m_ext);
    for (li, &lc) in plane.line_conic.iter().enumerate() {
        if lc != 0 {
            continue;
        }
        let on: Vec<usize> = plane
            .externals
            .iter()
            .enumerate()
            .filter(|(_, &p)| plane.on_line(li, p as usize))
            .map(|(slot, _)| slot)
            .collect();
        for a in 0..on.len() {
            for b in (a + 1)..on.len() {
                full.set(on[a], on[b]);
            }
        }
    }

    // base point: the first external point
    let base_slot = 0usize;
    let base_point = plane.externals[base_slot] as usize;
    let nbrs: Vec<usize> = {
        let mut v = Vec::new();
        iter_bits(full.row(base_slot), |j| v.push(j));
        v
    };
    let local: HashMap<usize, usize> = nbrs.iter().enumerate().map(|(i, &s)| (s, i)).collect();
    let mut sub = BitGraph::new(nbrs.len());
    for (i, &a) in nbrs.iter().enumerate() {
        let row = full.row(a);
        iter_bits(row, |b| {
            if let Some(&j) = local.get(&b) {
                if j > i {
                    sub.set(i, j);
                }
            }
        });
    }

    let mut cliques: Vec<Vec<usize>> = Vec::new();
    {
        let mut p = vec![u64::MAX; sub.words];
        let excess = sub.words * 64 - sub.m;
        if excess > 0 {
            let last = sub.words - 1;
            p[last] = u64::MAX >> excess;
        }
        let x = vec![0u64; sub.words];
        let mut r = Vec::new();
        bron_kerbosch(&sub, &mut r, p, x, &mut cliques, args.max_cliques)?;
    }

    let mut size_hist: BTreeMap<usize, usize> = BTreeMap::new();
    let mut sets: Vec<Vec<usize>> = Vec::with_capacity(cliques.len());
    for clique in &cliques {
        let mut set: Vec<usize> = clique
            .iter()
            .map(|&i| plane.externals[nbrs[i]] as usize)
            .collect();
        set.push(base_point);
        set.sort_unstable();
        *size_hist.entry(set.len()).or_insert(0) += 1;
        sets.push(set);
    }
    let max_size = size_hist.keys().copied().max().unwrap_or(0);

    // One orbit computation per class, not per clique: mark every orbit member
    // that passes through the base point, so each class is visited once.
    let mut seen: HashSet<Vec<usize>> = HashSet::new();
    let mut reps: Vec<(Vec<usize>, Vec<usize>, usize, usize, usize)> = Vec::new();
    for set in &sets {
        if seen.contains(set) {
            continue;
        }
        let mut images: HashSet<Vec<usize>> = HashSet::new();
        let mut stab_full = 0usize;
        let mut stab_pgl = 0usize;
        let mut canon: Option<Vec<usize>> = None;
        let mut buf = vec![0usize; set.len()];
        for (k, perm) in perms.iter().enumerate() {
            for (i, &p) in set.iter().enumerate() {
                buf[i] = usize::from(perm[p]);
            }
            buf.sort_unstable();
            if buf == *set {
                stab_full += 1;
                if k % frob_steps == 0 {
                    stab_pgl += 1;
                }
            }
            if canon.as_ref().map(|c| buf < *c).unwrap_or(true) {
                canon = Some(buf.clone());
            }
            images.insert(buf.clone());
        }
        let orbit = images.len();
        for img in images {
            if img.binary_search(&base_point).is_ok() {
                seen.insert(img);
            }
        }
        reps.push((set.clone(), canon.unwrap(), orbit, stab_full, stab_pgl));
    }

    let mut classes = Vec::new();
    for (set, canon, orbit, stab_full, stab_pgl) in reps {
        // line profile
        let mut profile: BTreeMap<String, usize> = BTreeMap::new();
        let mut max_on_line = 0usize;
        for l in 0..plane.n {
            let cnt = set.iter().filter(|&&p| plane.on_line(l, p)).count();
            if cnt >= 2 {
                *profile.entry(format!("{cnt}-point lines")).or_insert(0) += 1;
                max_on_line = max_on_line.max(cnt);
            }
        }
        let linear = max_on_line == set.len();
        let is_arc = max_on_line <= 2;

        // six-arc / Brianchon split, only for the exceptional sizes worth it
        let mut split = None;
        let mut split_exact = false;
        if !linear && set.len() >= 6 && set.len() == max_size {
            let idxs: Vec<usize> = (0..set.len()).collect();
            'outer: for combo in combinations(&idxs, 6) {
                let arc: Vec<usize> = combo.iter().map(|&i| set[i]).collect();
                if let Some(report) = analyse_six_arc(&plane, &index, &arc)? {
                    let complement: BTreeSet<usize> = set
                        .iter()
                        .copied()
                        .filter(|p| !arc.contains(p))
                        .collect();
                    let bs: BTreeSet<usize> = report.brianchon_points.iter().copied().collect();
                    if !bs.is_empty() && bs == complement {
                        split_exact = true;
                        split = Some(report);
                        break 'outer;
                    }
                    if split.is_none() && report.concurrent_matchings > 0 {
                        split = Some(report);
                    }
                }
            }
        }

        let coordinates = canon.iter().map(|&p| plane.coords[p]).collect();
        classes.push(ConfigReport {
            size: set.len(),
            linear,
            is_arc,
            orbit_size: orbit,
            stabiliser_order_pgl: stab_pgl,
            stabiliser_order_full: stab_full,
            line_profile: profile,
            canonical_points: canon,
            canonical_coordinates: coordinates,
            six_arc_split: split,
            six_arc_split_is_exactly_complement: split_exact,
        });
    }
    classes.sort_by_key(|c| (c.linear, std::cmp::Reverse(c.size), c.canonical_points.clone()));
    let exceptional = classes.iter().filter(|c| !c.linear).count();
    let linear_classes = classes.iter().filter(|c| c.linear).count();

    Ok(CellReport {
        q,
        characteristic: plane.p,
        degree: plane.h,
        plane_points: plane.n,
        conic_points: plane.conic_points.len(),
        external_points: plane.externals.len(),
        internal_points: internal_count,
        passant_lines: passants,
        group_order_pgl: pgl_order,
        group_order_full: perms.len(),
        neighbourhood_size: nbrs.len(),
        maximal_cliques_through_base_point: cliques.len(),
        size_histogram: size_hist,
        classes,
        exceptional_classes: exceptional,
        linear_classes,
    })
}

fn combinations(items: &[usize], k: usize) -> Vec<Vec<usize>> {
    let mut out = Vec::new();
    let n = items.len();
    if k > n {
        return out;
    }
    let mut idx: Vec<usize> = (0..k).collect();
    loop {
        out.push(idx.iter().map(|&i| items[i]).collect());
        let mut i = k;
        loop {
            if i == 0 {
                return out;
            }
            i -= 1;
            if idx[i] != i + n - k {
                break;
            }
            if i == 0 {
                return out;
            }
        }
        idx[i] += 1;
        for j in (i + 1)..k {
            idx[j] = idx[j - 1] + 1;
        }
    }
}

/// Deep analysis of one explicit exterior set: tangent-freeness of `C ∪ S`, and
/// the full six-arc / Brianchon spectrum over every six-subset of `S`.
fn analyse_set(q: u16, set: &[usize]) -> Result<()> {
    let plane = Plane::new(q)?;
    let index = ProjectiveIndex::new(&plane.field, 2)
        .map_err(|e| anyhow::anyhow!("projective index: {e}"))?;
    let f = &plane.field;

    println!("q={q} set_size={}", set.len());
    for &p in set {
        let t = match plane.ptype[p] {
            ON_CONIC => "on_conic",
            EXTERNAL => "external",
            _ => "internal",
        };
        if t != "external" {
            bail!("point {p} is {t}, not external");
        }
    }
    println!("all_points_external=true");

    // pairwise joins must be passants
    let mut bad = 0usize;
    for i in 0..set.len() {
        for j in (i + 1)..set.len() {
            let l = plane.join(&index, set[i], set[j])?;
            if plane.line_conic[l] != 0 {
                bad += 1;
            }
        }
    }
    println!("non_passant_joins={bad}");

    // tangent pairs: the two conic points c with B(p,c) = 0
    let bilinear = |a: &[u8; 3], b: &[u8; 3]| -> u8 {
        let t0 = f.mul(a[0], b[2]);
        let t2 = f.mul(a[2], b[0]);
        let mid = f.mul(a[1], b[1]);
        let twice = f.add(mid, mid);
        f.sub(f.add(t0, t2), twice)
    };
    let mut covered: BTreeMap<u32, usize> = BTreeMap::new();
    for &p in set {
        for &c in &plane.conic_points {
            if bilinear(&plane.coords[p], &plane.coords[c as usize]) == 0 {
                *covered.entry(c).or_insert(0) += 1;
            }
        }
    }
    let all_once = covered.len() == plane.conic_points.len()
        && covered.values().all(|&v| v == 1);
    println!(
        "tangent_points_covered={} of {} each_exactly_once={}",
        covered.len(),
        plane.conic_points.len(),
        all_once
    );

    // C ∪ S has no tangent line: every line meets it in 0 or >= 2 points
    let mut union: BTreeSet<usize> = set.iter().copied().collect();
    for &c in &plane.conic_points {
        union.insert(c as usize);
    }
    let mut singleton_lines = 0usize;
    for l in 0..plane.n {
        let cnt = union.iter().filter(|&&p| plane.on_line(l, p)).count();
        if cnt == 1 {
            singleton_lines += 1;
        }
    }
    println!("union_size={} lines_meeting_union_once={singleton_lines}", union.len());

    // setwise stabiliser in the full conic stabiliser, with its element-order
    // spectrum so the group can be named rather than guessed from its order.
    let (perms, pgl_order, frob_steps) = build_group(&plane, &index, true)?;
    let target: BTreeSet<usize> = set.iter().copied().collect();
    let mut orders: BTreeMap<usize, usize> = BTreeMap::new();
    let mut stab_full = 0usize;
    let mut stab_pgl = 0usize;
    let mut buf = vec![0usize; set.len()];
    for (k, perm) in perms.iter().enumerate() {
        for (i, &p) in set.iter().enumerate() {
            buf[i] = usize::from(perm[p]);
        }
        if buf.iter().copied().collect::<BTreeSet<usize>>() != target {
            continue;
        }
        stab_full += 1;
        if k % frob_steps == 0 {
            stab_pgl += 1;
        }
        // order of the permutation on the whole plane
        let mut order = 1usize;
        let mut current: Vec<u16> = perm.clone();
        while (0..plane.n).any(|i| usize::from(current[i]) != i) {
            for i in 0..plane.n {
                current[i] = perm[usize::from(current[i])];
            }
            order += 1;
            if order > 4096 {
                bail!("permutation order exceeded 4096");
            }
        }
        *orders.entry(order).or_insert(0) += 1;
    }
    println!(
        "group_order_pgl={pgl_order} group_order_full={} stabiliser_pgl={stab_pgl} stabiliser_full={stab_full} element_order_spectrum={orders:?}",
        perms.len()
    );

    // full six-arc spectrum
    let idxs: Vec<usize> = (0..set.len()).collect();
    let mut spectrum: BTreeMap<usize, usize> = BTreeMap::new();
    let mut arcs = 0usize;
    let mut best: Option<(usize, Vec<usize>, BrianchonReport)> = None;
    let mut bsw_shape = 0usize;
    for combo in combinations(&idxs, 6) {
        let arc: Vec<usize> = combo.iter().map(|&i| set[i]).collect();
        let Some(report) = analyse_six_arc(&plane, &index, &arc)? else {
            continue;
        };
        arcs += 1;
        let k = report.brianchon_points.len();
        *spectrum.entry(k).or_insert(0) += 1;
        let complement: BTreeSet<usize> =
            set.iter().copied().filter(|p| !arc.contains(p)).collect();
        let bs: BTreeSet<usize> = report.brianchon_points.iter().copied().collect();
        let is_shape = k == 10 && bs == complement && report.chord_graph_is_petersen;
        if is_shape {
            bsw_shape += 1;
        }
        let score = if is_shape { 1000 + k } else { k };
        if best.as_ref().map(|(s, _, _)| score > *s).unwrap_or(true) {
            best = Some((score, arc.clone(), report));
        }
    }
    println!("six_subsets_that_are_arcs={arcs} brianchon_count_spectrum={spectrum:?}");
    println!("six_subsets_with_bsw_petersen_shape={bsw_shape}");
    if let Some((_, arc, r)) = best {
        println!(
            "best_arc={arc:?} brianchon={} types={:?} chords_with_two_brianchon={} chord_graph_degrees={:?} chord_graph_is_petersen={} matching_disjointness_is_petersen={}",
            r.brianchon_points.len(),
            r.brianchon_types,
            r.chords_with_two_brianchon_points,
            r.chord_graph_degrees,
            r.chord_graph_is_petersen,
            r.matching_disjointness_graph_is_petersen
        );
        println!("best_arc_brianchon_points={:?}", r.brianchon_points);
        let complement: BTreeSet<usize> =
            set.iter().copied().filter(|p| !arc.contains(p)).collect();
        let bs: BTreeSet<usize> = r.brianchon_points.iter().copied().collect();
        println!("brianchon_equals_complement={}", bs == complement);
    }
    Ok(())
}

fn main() -> Result<()> {
    let args = Args::parse();
    if !args.points.is_empty() {
        if args.q.len() != 1 {
            bail!("--points requires exactly one --q");
        }
        return analyse_set(args.q[0], &args.points);
    }
    let mut cells = Vec::new();
    let mut text = String::new();
    for &q in &args.q {
        let started = std::time::Instant::now();
        let cell = run_cell(&args, q)?;
        writeln!(
            text,
            "q={} points={} conic={} external={} internal={} passants={} |PGL(2,q)|={} |group|={} nbhd={} maximal_cliques={} classes={} exceptional={} linear={} elapsed_s={:.2}",
            cell.q,
            cell.plane_points,
            cell.conic_points,
            cell.external_points,
            cell.internal_points,
            cell.passant_lines,
            cell.group_order_pgl,
            cell.group_order_full,
            cell.neighbourhood_size,
            cell.maximal_cliques_through_base_point,
            cell.classes.len(),
            cell.exceptional_classes,
            cell.linear_classes,
            started.elapsed().as_secs_f64()
        )?;
        for c in &cell.classes {
            writeln!(
                text,
                "  size={} linear={} arc={} orbit={} stab_pgl={} stab_full={} profile={:?} split_exact={}",
                c.size,
                c.linear,
                c.is_arc,
                c.orbit_size,
                c.stabiliser_order_pgl,
                c.stabiliser_order_full,
                c.line_profile,
                c.six_arc_split_is_exactly_complement
            )?;
            if let Some(s) = &c.six_arc_split {
                writeln!(
                    text,
                    "    six_arc={:?} concurrent_matchings={} brianchon={} types={:?} chords_with_two={} chord_petersen={} matching_petersen={}",
                    s.arc_points,
                    s.concurrent_matchings,
                    s.brianchon_points.len(),
                    s.brianchon_types,
                    s.chords_with_two_brianchon_points,
                    s.chord_graph_is_petersen,
                    s.matching_disjointness_graph_is_petersen
                )?;
            }
        }
        cells.push(cell);
    }
    print!("{text}");
    if let Some(path) = &args.json_out {
        let payload = serde_json::to_string_pretty(&cells)?;
        fs::write(path, payload.as_bytes())?;
        let digest = Sha256::digest(payload.as_bytes());
        println!("json_out={} sha256={:x}", path.display(), digest);
    }
    Ok(())
}
