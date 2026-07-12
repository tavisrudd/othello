//! C78: bounded exact `PGL(5,5)` orbit-growth probe for caps in `PG(4,5)`.
//!
//! This is deliberately a sizing tool, not the cap-game solver.  It uses a
//! 13-word mask for the 781 projective points and exhaustive frame/torus
//! canonicalization, so equal keys are equivalent exactly when the caps are
//! projectively equivalent.  A wall check runs between parents and children.

use std::collections::HashMap;
use std::env;
use std::time::Instant;

const Q: u8 = 5;
const DIM: usize = 5;
const N: usize = 781;
const WORDS: usize = 13;
type V = [u8; DIM];
type Mask = [u64; WORDS];

#[inline]
fn add(a: u8, b: u8) -> u8 {
    (a + b) % Q
}

#[inline]
fn sub(a: u8, b: u8) -> u8 {
    (a + Q - b) % Q
}

#[inline]
fn mul(a: u8, b: u8) -> u8 {
    (a * b) % Q
}

#[inline]
fn inv(a: u8) -> u8 {
    const INV: [u8; 5] = [0, 1, 3, 2, 4];
    INV[a as usize]
}

fn vcanon(mut v: V, dim: usize) -> Option<V> {
    let a = v[..dim].iter().copied().find(|&x| x != 0)?;
    let ia = inv(a);
    for x in &mut v[..dim] {
        *x = mul(ia, *x);
    }
    Some(v)
}

fn encode(v: &V, dim: usize) -> usize {
    v[..dim]
        .iter()
        .fold((0usize, 1usize), |(s, p), &x| {
            (s + x as usize * p, p * Q as usize)
        })
        .0
}

#[inline]
fn set(mask: &mut Mask, i: usize) {
    mask[i >> 6] |= 1u64 << (i & 63);
}

#[inline]
fn has(mask: &Mask, i: usize) -> bool {
    mask[i >> 6] & (1u64 << (i & 63)) != 0
}

fn or_assign(a: &mut Mask, b: &Mask) {
    for i in 0..WORDS {
        a[i] |= b[i];
    }
}

fn mat_inv(a: &[[u8; DIM]; DIM], n: usize) -> Option<[[u8; DIM]; DIM]> {
    let mut m = [[0u8; 2 * DIM]; DIM];
    for i in 0..n {
        m[i][..n].copy_from_slice(&a[i][..n]);
        m[i][n + i] = 1;
    }
    for col in 0..n {
        let piv = (col..n).find(|&r| m[r][col] != 0)?;
        m.swap(col, piv);
        let z = inv(m[col][col]);
        for x in &mut m[col][..2 * n] {
            *x = mul(z, *x);
        }
        for r in 0..n {
            if r == col || m[r][col] == 0 {
                continue;
            }
            let z = m[r][col];
            let pivot = m[col];
            for (j, x) in m[r][..2 * n].iter_mut().enumerate() {
                *x = sub(*x, mul(z, pivot[j]));
            }
        }
    }
    let mut out = [[0u8; DIM]; DIM];
    for i in 0..n {
        out[i][..n].copy_from_slice(&m[i][n..2 * n]);
    }
    Some(out)
}

fn mv(m: &[[u8; DIM]; DIM], v: &V, n: usize) -> V {
    let mut out = [0u8; DIM];
    for i in 0..n {
        for (j, &vj) in v[..n].iter().enumerate() {
            out[i] = add(out[i], mul(m[i][j], vj));
        }
    }
    out
}

fn rank(rows: &[V], n: usize) -> usize {
    let mut m = rows.to_vec();
    let mut r = 0;
    let mut col = 0;
    while r < m.len() && col < n {
        let Some(piv) = (r..m.len()).find(|&i| m[i][col] != 0) else {
            col += 1;
            continue;
        };
        m.swap(r, piv);
        let z = inv(m[r][col]);
        for x in &mut m[r][..n] {
            *x = mul(z, *x);
        }
        for i in 0..m.len() {
            if i == r || m[i][col] == 0 {
                continue;
            }
            let z = m[i][col];
            let pivot = m[r];
            for (j, x) in m[i][..n].iter_mut().enumerate() {
                *x = sub(*x, mul(z, pivot[j]));
            }
        }
        r += 1;
        col += 1;
    }
    r
}

struct Board {
    pts: Vec<V>,
    vidx: Vec<i16>,
    lines: Vec<Mask>,
    hyperplanes: Vec<Mask>,
}

impl Board {
    fn build() -> Self {
        let total = (Q as usize).pow(DIM as u32);
        let mut pts = Vec::with_capacity(N);
        let mut seen = vec![false; total];
        for code in 1..total {
            let mut c = code;
            let mut v = [0u8; DIM];
            for x in &mut v {
                *x = (c % Q as usize) as u8;
                c /= Q as usize;
            }
            let cv = vcanon(v, DIM).unwrap();
            let e = encode(&cv, DIM);
            if !seen[e] {
                seen[e] = true;
                pts.push(cv);
            }
        }
        pts.sort_by_key(|v| encode(v, DIM));
        assert_eq!(pts.len(), N);
        let mut vidx = vec![-1i16; total];
        for (i, p) in pts.iter().enumerate() {
            vidx[encode(p, DIM)] = i as i16;
        }

        let mut lines = vec![[0u64; WORDS]; N * N];
        for i in 0..N {
            for j in i + 1..N {
                let mut line = [0u64; WORDS];
                for a in 0..Q {
                    for b in 0..Q {
                        if a == 0 && b == 0 {
                            continue;
                        }
                        let mut v = [0u8; DIM];
                        for (k, x) in v.iter_mut().enumerate() {
                            *x = add(mul(a, pts[i][k]), mul(b, pts[j][k]));
                        }
                        if let Some(cv) = vcanon(v, DIM) {
                            set(&mut line, vidx[encode(&cv, DIM)] as usize);
                        }
                    }
                }
                lines[i * N + j] = line;
                lines[j * N + i] = line;
            }
        }

        let mut hyperplanes = vec![[0u64; WORDS]; N];
        for (h, f) in pts.iter().enumerate() {
            for (i, p) in pts.iter().enumerate() {
                let dot = (0..DIM).fold(0, |s, k| add(s, mul(f[k], p[k])));
                if dot == 0 {
                    set(&mut hyperplanes[h], i);
                }
            }
        }
        Self {
            pts,
            vidx,
            lines,
            hyperplanes,
        }
    }

    fn spectrum(&self, cap: &[u16]) -> Vec<u16> {
        let mut hist = vec![0u16; cap.len() + 1];
        for h in &self.hyperplanes {
            let n = cap.iter().filter(|&&x| has(h, x as usize)).count();
            hist[n] += 1;
        }
        while hist.last() == Some(&0) {
            hist.pop();
        }
        hist
    }
}

#[derive(Clone, Debug, Eq, Hash, PartialEq, Ord, PartialOrd)]
struct Key {
    rank: u8,
    method: u8,
    image: Vec<u16>,
}

type OrbitEntry = (Option<Key>, Vec<u16>);
type OrbitBuckets = HashMap<Vec<u16>, Vec<OrbitEntry>>;

struct Canon<'a> {
    b: &'a Board,
}

impl Canon<'_> {
    fn project(&self, cap: &[u16]) -> (usize, Vec<V>) {
        let mut basis = Vec::new();
        for &i in cap {
            let mut trial = basis.clone();
            trial.push(self.b.pts[i as usize]);
            if rank(&trial, DIM) > basis.len() {
                basis.push(self.b.pts[i as usize]);
            }
        }
        let r = basis.len();
        let mut full = basis;
        for i in 0..DIM {
            if full.len() == DIM {
                break;
            }
            let mut e = [0u8; DIM];
            e[i] = 1;
            let mut trial = full.clone();
            trial.push(e);
            if rank(&trial, DIM) > full.len() {
                full.push(e);
            }
        }
        let mut a = [[0u8; DIM]; DIM];
        for c in 0..DIM {
            for row in 0..DIM {
                a[row][c] = full[c][row];
            }
        }
        let ai = mat_inv(&a, DIM).unwrap();
        let coords = cap
            .iter()
            .map(|&i| {
                let mut v = mv(&ai, &self.b.pts[i as usize], DIM);
                v[r..].fill(0);
                v
            })
            .collect();
        (r, coords)
    }

    fn image(&self, m: &[[u8; DIM]; DIM], coords: &[V], r: usize) -> Vec<u16> {
        let mut out = Vec::with_capacity(coords.len());
        for v in coords {
            let cv = vcanon(mv(m, v, r), r).unwrap();
            out.push(self.b.vidx[encode(&cv, DIM)] as u16);
        }
        out.sort_unstable();
        out
    }

    fn key(&self, cap: &[u16]) -> Key {
        let (r, coords) = self.project(cap);
        if cap.len() == r {
            return Key {
                rank: r as u8,
                method: b'I',
                image: Vec::new(),
            };
        }
        let mut best = None;
        let mut order = vec![0usize; r];
        self.frames(&coords, r, 0, &mut order, &mut best);
        if let Some(image) = best {
            return Key {
                rank: r as u8,
                method: b'F',
                image,
            };
        }
        Key {
            rank: r as u8,
            method: b'T',
            image: self.torus(&coords, r),
        }
    }

    fn frames(
        &self,
        coords: &[V],
        r: usize,
        depth: usize,
        order: &mut [usize],
        best: &mut Option<Vec<u16>>,
    ) {
        if depth < r {
            for i in 0..coords.len() {
                if order[..depth].contains(&i) {
                    continue;
                }
                let mut rows: Vec<V> = order[..depth].iter().map(|&j| coords[j]).collect();
                rows.push(coords[i]);
                if rank(&rows, r) == depth + 1 {
                    order[depth] = i;
                    self.frames(coords, r, depth + 1, order, best);
                }
            }
            return;
        }
        let mut a = [[0u8; DIM]; DIM];
        for c in 0..r {
            for row in 0..r {
                a[row][c] = coords[order[c]][row];
            }
        }
        let ai = mat_inv(&a, r).unwrap();
        for u in 0..coords.len() {
            if order.contains(&u) {
                continue;
            }
            let c = mv(&ai, &coords[u], r);
            if c[..r].contains(&0) {
                continue;
            }
            let mut m = [[0u8; DIM]; DIM];
            for i in 0..r {
                for j in 0..r {
                    m[i][j] = mul(inv(c[i]), ai[i][j]);
                }
            }
            let image = self.image(&m, coords, r);
            if best.as_ref().is_none_or(|b| image < *b) {
                *best = Some(image);
            }
        }
    }

    fn torus(&self, coords: &[V], r: usize) -> Vec<u16> {
        let mut best = None;
        let mut order = vec![0usize; r];
        self.torus_bases(coords, r, 0, &mut order, &mut best);
        best.unwrap()
    }

    fn torus_bases(
        &self,
        coords: &[V],
        r: usize,
        depth: usize,
        order: &mut [usize],
        best: &mut Option<Vec<u16>>,
    ) {
        if depth < r {
            for i in 0..coords.len() {
                if order[..depth].contains(&i) {
                    continue;
                }
                let mut rows: Vec<V> = order[..depth].iter().map(|&j| coords[j]).collect();
                rows.push(coords[i]);
                if rank(&rows, r) == depth + 1 {
                    order[depth] = i;
                    self.torus_bases(coords, r, depth + 1, order, best);
                }
            }
            return;
        }
        let mut a = [[0u8; DIM]; DIM];
        for c in 0..r {
            for row in 0..r {
                a[row][c] = coords[order[c]][row];
            }
        }
        let ai = mat_inv(&a, r).unwrap();
        let mut diag = [1u8; DIM];
        self.tori(coords, r, &ai, 1, &mut diag, best);
    }

    fn tori(
        &self,
        coords: &[V],
        r: usize,
        ai: &[[u8; DIM]; DIM],
        i: usize,
        diag: &mut V,
        best: &mut Option<Vec<u16>>,
    ) {
        if i < r {
            for x in 1..Q {
                diag[i] = x;
                self.tori(coords, r, ai, i + 1, diag, best);
            }
            return;
        }
        let mut m = [[0u8; DIM]; DIM];
        for i in 0..r {
            for j in 0..r {
                m[i][j] = mul(diag[i], ai[i][j]);
            }
        }
        let image = self.image(&m, coords, r);
        if best.as_ref().is_none_or(|b| image < *b) {
            *best = Some(image);
        }
    }
}

fn orbit_probe(max_k: usize, wall: f64) {
    let build_start = Instant::now();
    let b = Board::build();
    println!(
        "board=PG(4,5) points={} words={} build_s={:.3}",
        N,
        WORDS,
        build_start.elapsed().as_secs_f64()
    );
    let canon = Canon { b: &b };
    let start = Instant::now();
    let mut cur = vec![vec![0u16]];
    let mut counts = vec![1usize, 1];
    let mut timed_out = false;
    for k in 1..max_k {
        let mut buckets = OrbitBuckets::new();
        let mut terminals = 0usize;
        'parents: for cap in &cur {
            if start.elapsed().as_secs_f64() >= wall {
                timed_out = true;
                break;
            }
            let mut chosen = [0u64; WORDS];
            for &x in cap {
                set(&mut chosen, x as usize);
            }
            let mut forbidden = [0u64; WORDS];
            for i in 0..cap.len() {
                for j in i + 1..cap.len() {
                    or_assign(
                        &mut forbidden,
                        &b.lines[cap[i] as usize * N + cap[j] as usize],
                    );
                }
            }
            let mut any = false;
            for y in 0..N {
                if has(&chosen, y) || has(&forbidden, y) {
                    continue;
                }
                any = true;
                let mut child = cap.clone();
                child.push(y as u16);
                child.sort_unstable();
                let sp = b.spectrum(&child);
                let entries = buckets.entry(sp).or_default();
                if entries.is_empty() {
                    entries.push((None, child));
                } else {
                    let ck = canon.key(&child);
                    let mut hit = false;
                    for entry in entries.iter_mut() {
                        let ek = entry.0.get_or_insert_with(|| canon.key(&entry.1));
                        if *ek == ck {
                            hit = true;
                            break;
                        }
                    }
                    if !hit {
                        entries.push((Some(ck), child));
                    }
                }
                if start.elapsed().as_secs_f64() >= wall {
                    timed_out = true;
                    break 'parents;
                }
            }
            if !any {
                terminals += 1;
            }
        }
        if timed_out {
            println!(
                "cutoff_during_size={} elapsed_s={:.3}",
                k + 1,
                start.elapsed().as_secs_f64()
            );
            break;
        }
        cur = buckets
            .into_values()
            .flat_map(|v| v.into_iter().map(|(_, cap)| cap))
            .collect();
        counts.push(cur.len());
        println!(
            "orbits_{}={} parent_terminal_orbits={} elapsed_s={:.3}",
            k + 1,
            cur.len(),
            terminals,
            start.elapsed().as_secs_f64()
        );
    }
    println!(
        "PG45_ORBIT_RESULT counts={counts:?} timed_out={timed_out} elapsed_s={:.3}",
        start.elapsed().as_secs_f64()
    );
}

fn main() {
    let max_k = env::args().nth(1).map_or(6, |s| s.parse().unwrap());
    let wall = env::args().nth(2).map_or(120.0, |s| s.parse().unwrap());
    orbit_probe(max_k, wall);
}
