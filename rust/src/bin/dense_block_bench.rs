//! Pre-check #2 for dense-blocks (Idea B, simd-dense-dataflow proposal): is a per-boundary
//! *reachable-only* win/loss DP cheap enough (per reachable-state, L1) to beat the ~100 ns DRAM
//! probe it would replace in the deep pc≤12 region? No solver change, gate-free — a standalone
//! timing of the Idea B kernel (a u16-widened `solve_local`) over connected K=9..12 graphs.
//!
//! Make-or-break framing (from this session's measurement #0): the deep node is ~35 % backend-
//! by-memory (~1.9 DRAM fills/node). Dense-blocks wins iff it visits ≈ the same reachable node
//! count as the DFS-with-TT subtree but each node is an L1 mask-op, not a probe. So the number
//! that matters is **ns per reachable-state** (must be ≪ ~100 ns). Reachable-set *size* is
//! graph-dependent, but ns/reachable-state is the kernel's intrinsic, density-robust cost.

use std::time::Instant;

/// Idea B kernel: reachable-only win/loss DP for a single K-vertex graph, keyed by the `alive`
/// bitmask. `closed[i] = (1<<i) | adj[i]` (vertex i + its neighbours), so playing i leaves
/// `alive & !closed[i]`. Memoised over a 2^K `i8` array (−1 unknown). This is `solve_local`
/// widened from u8 to u16. Returns won[full].
fn solve_block(closed: &[u16], alive: u16, memo: &mut [i8]) -> bool {
    let m = memo[alive as usize];
    if m >= 0 {
        return m != 0;
    }
    let mut result = false;
    let mut rem = alive;
    while rem != 0 {
        let i = rem.trailing_zeros() as usize;
        rem &= rem - 1;
        let child = alive & !closed[i];
        if child == 0 || !solve_block(closed, child, memo) {
            result = true;
            break;
        }
    }
    memo[alive as usize] = result as i8;
    result
}

/// Count reachable states (memo cells filled) for one solve — the dense DP's true node count,
/// the quantity that must compare against the DFS-with-TT subtree it replaces.
fn count_reachable(memo: &[i8]) -> usize {
    memo.iter().filter(|&&x| x >= 0).count()
}

// Deterministic xorshift (Date/rand-free; reproducible).
struct Rng(u64);
impl Rng {
    fn next(&mut self) -> u64 {
        let mut x = self.0;
        x ^= x << 13;
        x ^= x >> 7;
        x ^= x << 17;
        self.0 = x;
        x
    }
    fn frac(&mut self) -> f64 {
        (self.next() >> 11) as f64 / (1u64 << 53) as f64
    }
}

/// Random connected K-graph at edge density p, as `closed[i] = (1<<i) | adj[i]`.
fn gen_connected(k: usize, p: f64, rng: &mut Rng) -> Vec<u16> {
    loop {
        let mut adj = vec![0u16; k];
        for i in 0..k {
            for j in (i + 1)..k {
                if rng.frac() < p {
                    adj[i] |= 1 << j;
                    adj[j] |= 1 << i;
                }
            }
        }
        // connectivity via BFS from 0
        let mut seen = 1u16;
        let mut frontier = 1u16;
        while frontier != 0 {
            let mut next = 0u16;
            let mut rem = frontier;
            while rem != 0 {
                let v = rem.trailing_zeros() as usize;
                rem &= rem - 1;
                next |= adj[v] & !seen;
            }
            seen |= next;
            frontier = next;
        }
        if seen == (1u16 << k) - 1 {
            return (0..k).map(|i| (1u16 << i) | adj[i]).collect();
        }
    }
}

fn main() {
    let samples = 400usize;
    println!(
        "dense-block pre-check #2 — reachable-only win/loss DP, ns per block & per reachable-state"
    );
    println!("(must beat the ~100 ns DRAM probe the DFS-with-TT subtree pays *per node*)\n");
    println!(
        "{:>2}  {:>5}  {:>9}  {:>9}  {:>10}  {:>12}",
        "K", "dens", "reach/2^K", "ns/block", "ns/reach", "probe-equiv"
    );
    let mut rng = Rng(0x9E3779B97F4A7C15);
    for k in 9..=12usize {
        let size = 1usize << k;
        for &p in &[0.20f64, 0.35, 0.50] {
            // build the sample set first (graph gen excluded from the timed region)
            let graphs: Vec<Vec<u16>> = (0..samples)
                .map(|_| gen_connected(k, p, &mut rng))
                .collect();
            let mut memo = vec![-1i8; size];
            let mut reach_total = 0usize;
            // warm + correctness sink
            let mut sink = 0u64;
            let t = Instant::now();
            for g in &graphs {
                memo.iter_mut().for_each(|x| *x = -1);
                let full = (1u16 << k) - 1;
                let w = solve_block(g, full, &mut memo);
                sink += w as u64;
                reach_total += count_reachable(&memo);
            }
            let elapsed = t.elapsed().as_secs_f64();
            let per_block_ns = elapsed / samples as f64 * 1e9;
            let reach_avg = reach_total as f64 / samples as f64;
            let per_reach_ns = elapsed / reach_total as f64 * 1e9;
            // probe-equiv = ns/block ÷ 100 ns: how many DRAM probes one block costs.
            let probe_equiv = per_block_ns / 100.0;
            println!(
                "{:>2}  {:>5.2}  {:>9.3}  {:>9.0}  {:>10.2}  {:>12.1}   (sink={})",
                k,
                p,
                reach_avg / size as f64,
                per_block_ns,
                per_reach_ns,
                probe_equiv,
                sink & 1
            );
        }
    }
    println!(
        "\nRead: ns/reach is the kernel's intrinsic per-node cost (L1). If ns/reach ≪ 100, a dense\n\
         block beats the DFS-with-TT subtree *per node* (same node count, no probe). probe-equiv =\n\
         how many DRAM probes one whole block costs — compare to the DFS subtree's distinct-node count."
    );
}
