//! Exhaustive gate for a compact, exact pc==9 outcome oracle.
//!
//! Input is nauty `geng 9` graph6 output: one representative of every unlabelled
//! 9-vertex graph. Every graph is labelled exactly from the production W0..W8
//! tables. We then group values under progressively richer cheap invariants.
//! A signature is usable only when its entire bucket is win-only or loss-only;
//! mixed buckets fall back to the normal solver, so incomplete invariants remain exact.
//!
//! Generate the catalogue and run:
//!   geng -q 9 /tmp/graph9.g6
//!   w9_purity_bench [/tmp/graph9.g6]

use std::collections::HashMap;
use std::fs::File;
use std::hash::Hash;
use std::io::{BufRead, BufReader};
use std::time::Instant;

// dense.rs is #[path]-included here for W8 lookups. Some items (W9_K, w9_masks,
// W9_MASKS, get9) are used by the lib/queens bin but not this bench.
#[allow(dead_code)]
#[path = "../queens/dense.rs"]
mod dense;

const K: usize = 9;
type Adj = [u16; K];

#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct LocalVertex {
    degree: u8,
    triangles: u8,
    neighbour_degrees: [u8; K],
}

type DegreeKey = [u8; K];
type TupleKey = [u16; K];
type HistKey = [u64; K];
type LocalKey = [LocalVertex; K];

#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct PairVertex {
    local: LocalVertex,
    // For every other vertex: adjacency, its degree/triangle count, and the
    // pair's common-neighbour count. Sorted, so labels do not matter.
    pairs: [u16; K],
}

type PairKey = [PairVertex; K];

#[derive(Clone, Copy, Default)]
struct Bucket {
    outcomes: u8,
    graphs: u32,
}

fn parse_graph6(line: &[u8]) -> Adj {
    assert!(!line.is_empty());
    assert_eq!((line[0] - 63) as usize, K, "expected a 9-vertex graph6 row");
    let mut adj = [0u16; K];
    let mut bit = 0usize;
    for j in 1..K {
        for i in 0..j {
            let byte = line[1 + bit / 6] - 63;
            if ((byte >> (5 - bit % 6)) & 1) != 0 {
                adj[i] |= 1 << j;
                adj[j] |= 1 << i;
            }
            bit += 1;
        }
    }
    adj
}

fn project(adj: &Adj, alive: u16) -> (usize, usize) {
    let mut verts = [0usize; K];
    let mut n = 0usize;
    let mut rem = alive;
    while rem != 0 {
        let v = rem.trailing_zeros() as usize;
        rem &= rem - 1;
        verts[n] = v;
        n += 1;
    }
    let mut code = 0usize;
    let mut bit = 0usize;
    for x in 0..n {
        for y in (x + 1)..n {
            code |= (((adj[verts[x]] >> verts[y]) & 1) as usize) << bit;
            bit += 1;
        }
    }
    (n, code)
}

fn wins(adj: &Adj, w8: &dense::DenseW8) -> bool {
    let full = (1u16 << K) - 1;
    for i in 0..K {
        let child = full & !((1 << i) | adj[i]);
        let (n, code) = project(adj, child);
        if !w8.get(n, code) {
            return true;
        }
    }
    false
}

fn local_vertices(adj: &Adj) -> LocalKey {
    let mut degree = [0u8; K];
    let mut triangles = [0u8; K];
    for i in 0..K {
        degree[i] = adj[i].count_ones() as u8;
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            triangles[i] += (adj[i] & adj[j]).count_ones() as u8;
        }
        triangles[i] /= 2;
    }

    let mut out = [LocalVertex {
        degree: 0,
        triangles: 0,
        neighbour_degrees: [0; K],
    }; K];
    for i in 0..K {
        let mut nd = [0u8; K];
        let mut n = 0usize;
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            nd[n] = degree[j];
            n += 1;
        }
        nd.sort_unstable();
        out[i] = LocalVertex {
            degree: degree[i],
            triangles: triangles[i],
            neighbour_degrees: nd,
        };
    }
    out.sort_unstable();
    out
}

fn degree_key(adj: &Adj) -> DegreeKey {
    let mut out = [0u8; K];
    for i in 0..K {
        out[i] = adj[i].count_ones() as u8;
    }
    out.sort_unstable();
    out
}

fn degree_triangle_key(adj: &Adj) -> TupleKey {
    let mut out = [0u16; K];
    for i in 0..K {
        let degree = adj[i].count_ones() as u16;
        let mut twice_triangles = 0u16;
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            twice_triangles += (adj[i] & adj[j]).count_ones() as u16;
        }
        out[i] = (degree << 5) | (twice_triangles / 2);
    }
    out.sort_unstable();
    out
}

fn degree_triangle_sum_key(adj: &Adj) -> TupleKey {
    let mut degree = [0u8; K];
    for i in 0..K {
        degree[i] = adj[i].count_ones() as u8;
    }
    let mut out = [0u16; K];
    for i in 0..K {
        let mut twice_triangles = 0u16;
        let mut neighbour_degree_sum = 0u16;
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            twice_triangles += (adj[i] & adj[j]).count_ones() as u16;
            neighbour_degree_sum += degree[j] as u16;
        }
        out[i] = ((degree[i] as u16) << 11) | ((twice_triangles / 2) << 6) | neighbour_degree_sum;
    }
    out.sort_unstable();
    out
}

fn neighbour_hist_key(adj: &Adj) -> HistKey {
    let mut degree = [0u8; K];
    for i in 0..K {
        degree[i] = adj[i].count_ones() as u8;
    }
    let mut out = [0u64; K];
    for i in 0..K {
        let mut twice_triangles = 0u8;
        let mut hist = [0u8; K];
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            twice_triangles += (adj[i] & adj[j]).count_ones() as u8;
            hist[degree[j] as usize] += 1;
        }
        let mut code = degree[i] as u64 | (((twice_triangles / 2) as u64) << 4);
        for (d, &count) in hist.iter().enumerate() {
            code |= (count as u64) << (9 + 4 * d);
        }
        out[i] = code;
    }
    out.sort_unstable();
    out
}

fn local_key(adj: &Adj) -> LocalKey {
    local_vertices(adj)
}

fn pair_key(adj: &Adj) -> PairKey {
    let mut identity_local = [LocalVertex {
        degree: 0,
        triangles: 0,
        neighbour_degrees: [0; K],
    }; K];
    for i in 0..K {
        let degree = adj[i].count_ones() as u8;
        let mut twice_triangles = 0u8;
        let mut nd = [0u8; K];
        let mut n = 0usize;
        let mut neighbours = adj[i];
        while neighbours != 0 {
            let j = neighbours.trailing_zeros() as usize;
            neighbours &= neighbours - 1;
            twice_triangles += (adj[i] & adj[j]).count_ones() as u8;
            nd[n] = adj[j].count_ones() as u8;
            n += 1;
        }
        nd.sort_unstable();
        identity_local[i] = LocalVertex {
            degree,
            triangles: twice_triangles / 2,
            neighbour_degrees: nd,
        };
    }

    let mut out = [PairVertex {
        local: identity_local[0],
        pairs: [0; K],
    }; K];
    for i in 0..K {
        let mut pairs = [0u16; K];
        for j in 0..K {
            if i == j {
                continue;
            }
            let linked = (adj[i] >> j) & 1;
            let common = (adj[i] & adj[j]).count_ones() as u16;
            pairs[j] = (linked << 13)
                | ((identity_local[j].degree as u16) << 9)
                | ((identity_local[j].triangles as u16) << 4)
                | common;
        }
        pairs.sort_unstable();
        out[i] = PairVertex {
            local: identity_local[i],
            pairs,
        };
    }
    out.sort_unstable();
    out
}

fn aggregate<T: Copy + Eq + Hash>(keys: &[T], values: &[bool]) -> HashMap<T, Bucket> {
    let mut map = HashMap::<T, Bucket>::with_capacity(keys.len());
    for (&key, &value) in keys.iter().zip(values) {
        let bucket = map.entry(key).or_default();
        bucket.outcomes |= 1 << value as u8;
        bucket.graphs += 1;
    }
    map
}

fn report<T: Copy + Eq + Hash>(name: &str, keys: &[T], values: &[bool], build_ns: f64) {
    let map = aggregate(keys, values);
    let mut pure_buckets = 0usize;
    let mut pure_graphs = 0u64;
    let mut mixed_graphs = 0u64;
    for bucket in map.values() {
        if bucket.outcomes.count_ones() == 1 {
            pure_buckets += 1;
            pure_graphs += bucket.graphs as u64;
        } else {
            mixed_graphs += bucket.graphs as u64;
        }
    }
    let t0 = Instant::now();
    let mut sink = 0u64;
    for key in keys {
        sink += map.get(key).unwrap().outcomes as u64;
    }
    std::hint::black_box(sink);
    let lookup_ns = t0.elapsed().as_secs_f64() * 1e9 / keys.len() as f64;
    println!(
        "{name:<12} {:>9} {:>8.3}% {:>8.3}% {:>10.1} {:>10.1}",
        map.len(),
        pure_buckets as f64 * 100.0 / map.len() as f64,
        pure_graphs as f64 * 100.0 / keys.len() as f64,
        build_ns,
        lookup_ns,
    );
    assert_eq!(pure_graphs + mixed_graphs, keys.len() as u64);
}

fn timed_keys<T, F>(graphs: &[Adj], mut f: F) -> (Vec<T>, f64)
where
    F: FnMut(&Adj) -> T,
{
    let t0 = Instant::now();
    let keys: Vec<T> = graphs.iter().map(&mut f).collect();
    let ns = t0.elapsed().as_secs_f64() * 1e9 / graphs.len() as f64;
    (keys, ns)
}

fn main() {
    let path = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "/tmp/graph9.g6".to_owned());
    let file = File::open(&path).unwrap_or_else(|e| panic!("open {path}: {e}"));
    let graphs: Vec<Adj> = BufReader::new(file)
        .lines()
        .map(|line| parse_graph6(line.unwrap().as_bytes()))
        .collect();
    assert_eq!(
        graphs.len(),
        274_668,
        "catalogue must contain every k=9 graph"
    );

    let t0 = Instant::now();
    let w8 = dense::DenseW8::build();
    let w8_secs = t0.elapsed().as_secs_f64();
    let t0 = Instant::now();
    let values: Vec<bool> = graphs.iter().map(|g| wins(g, &w8)).collect();
    let solve_ns = t0.elapsed().as_secs_f64() * 1e9 / graphs.len() as f64;
    let wins = values.iter().filter(|&&v| v).count();

    println!(
        "W9 outcome-pure invariant gate — {} unlabelled graphs",
        graphs.len()
    );
    println!(
        "W8 build {:.3}s ({:.1} MiB); exact labels {:.1} ns/graph; outcomes: {} win / {} loss",
        w8_secs,
        w8.bytes() as f64 / (1 << 20) as f64,
        solve_ns,
        wins,
        graphs.len() - wins
    );
    println!();
    println!(
        "{:<12} {:>9} {:>9} {:>9} {:>10} {:>10}",
        "signature", "buckets", "pure/bkt", "coverage", "sig ns", "hash ns"
    );

    let (degree, degree_ns) = timed_keys(&graphs, degree_key);
    report("degree", &degree, &values, degree_ns);
    let (deg_tri, deg_tri_ns) = timed_keys(&graphs, degree_triangle_key);
    report("deg+tri", &deg_tri, &values, deg_tri_ns);
    let (deg_tri_sum, deg_tri_sum_ns) = timed_keys(&graphs, degree_triangle_sum_key);
    report("deg+tri+sum", &deg_tri_sum, &values, deg_tri_sum_ns);
    let (hist, hist_ns) = timed_keys(&graphs, neighbour_hist_key);
    report("nbr-hist", &hist, &values, hist_ns);
    let (local, local_ns) = timed_keys(&graphs, local_key);
    report("local", &local, &values, local_ns);
    let (pair, pair_ns) = timed_keys(&graphs, pair_key);
    report("pair", &pair, &values, pair_ns);
}
