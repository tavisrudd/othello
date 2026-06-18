use rayon::prelude::*;
use std::env;
use std::time::Instant;

const MAX_K: usize = 8;

fn edge_count(k: usize) -> usize {
    k * (k - 1) / 2
}

fn slots(k: usize) -> usize {
    1usize << edge_count(k)
}

fn words(k: usize) -> usize {
    slots(k).div_ceil(64)
}

fn bit_get(bits: &[u64], idx: usize) -> bool {
    (bits[idx >> 6] & (1u64 << (idx & 63))) != 0
}

fn adj_from_code(k: usize, code: usize) -> [u16; MAX_K] {
    let mut adj = [0u16; MAX_K];
    let mut bit = 0usize;
    for i in 0..k {
        for j in (i + 1)..k {
            if (code >> bit) & 1 != 0 {
                adj[i] |= 1u16 << j;
                adj[j] |= 1u16 << i;
            }
            bit += 1;
        }
    }
    adj
}

fn projected_code(adj: &[u16; MAX_K], alive: u16) -> (usize, usize) {
    let k = alive.count_ones() as usize;
    let mut verts = [0usize; MAX_K];
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
    for x in 0..k {
        let vx = verts[x];
        for &vy in verts.iter().take(k).skip(x + 1) {
            code |= (((adj[vx] >> vy) & 1) as usize) << bit;
            bit += 1;
        }
    }
    (k, code)
}

fn graph_wins(k: usize, code: usize, tables: &[Vec<u64>]) -> bool {
    let adj = adj_from_code(k, code);
    let full = (1u16 << k) - 1;
    for i in 0..k {
        let child = full & !((1u16 << i) | adj[i]);
        let (ck, ccode) = projected_code(&adj, child);
        if !bit_get(&tables[ck], ccode) {
            return true;
        }
    }
    false
}

fn build_table(k: usize, tables: &[Vec<u64>]) -> Vec<u64> {
    let nwords = words(k);
    (0..nwords)
        .into_par_iter()
        .map(|word| {
            let mut out = 0u64;
            let base = word << 6;
            let limit = slots(k).saturating_sub(base).min(64);
            for b in 0..limit {
                if graph_wins(k, base + b, tables) {
                    out |= 1u64 << b;
                }
            }
            out
        })
        .collect()
}

fn main() {
    let max_k = env::args()
        .nth(1)
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(MAX_K)
        .min(MAX_K);

    let mut tables = Vec::with_capacity(max_k + 1);
    tables.push(vec![0u64]); // empty graph is a loss for the player to move.

    for k in 1..=max_k {
        let t = Instant::now();
        let table = build_table(k, &tables);
        let wins: u64 = table.iter().map(|w| w.count_ones() as u64).sum();
        let total = slots(k) as u64;
        eprintln!(
            "k={k}: {total} labelled graphs, {} MiB bitset, {wins} wins ({:.2}%) in {:.3}s",
            table.len() * 8 / (1 << 20),
            100.0 * wins as f64 / total as f64,
            t.elapsed().as_secs_f64()
        );
        tables.push(table);
    }
}
