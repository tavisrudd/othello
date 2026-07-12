// C83(3): coarsest Grundy-respecting congruence (coarsest bisimulation) of the
// exact residual grid-game DAG, in Rust for q >= 13 where the full DAG exceeds
// Python's memory.
//
// The residual game (PG(2,q) after the opening pair): cells of F_q x F_q, a move
// selects a cell, legal = affine cap + at most one per row + at most one per
// column. Equivalent legality: the infinity point a=(1,0,0) burns the whole
// column of any selected cell, b=(0,1,0) burns the whole row, and each pair of
// selected affine cells burns the ordinary affine line through them.
//
// Pipeline: enumerate all states reachable from the empty position, label each by
// Grundy value (mex over children), then compute the coarsest bisimulation by
// signature refinement (own block + SET of child blocks). Grundy is a
// bisimulation invariant, so the coarsest bisimulation = coarsest
// Grundy-respecting congruence; its class count vs q is the decisive dichotomy.
//
// Memory: a single copy of each mask (Vec<Mask>) plus an open-addressing u32
// index; children are built in a second id-ordered pass as a plain CSR (no
// per-node length array), and masks/index are freed before the bisimulation.
//
// Build:  rustc -O -C target-cpu=native scripts/c83_bisim.rs -o target/c83_bisim
// Run:    target/c83_bisim <q> [--count-only]
//
// Cross-check: q=11 must reproduce states=15697452 edges=85760081 classes=29.

use std::collections::HashMap;
use std::env;

const W: usize = 5; // 5*64 = 320 bits >= 17^2 = 289 (q<=17).
type Mask = [u64; W];
const EMPTY: u32 = u32::MAX;

#[inline]
fn set_bit(m: &mut Mask, i: usize) {
    m[i >> 6] |= 1u64 << (i & 63);
}
#[inline]
fn get_bit(m: &Mask, i: usize) -> bool {
    (m[i >> 6] >> (i & 63)) & 1 == 1
}
#[inline]
fn or_into(a: &mut Mask, b: &Mask) {
    for i in 0..W {
        a[i] |= b[i];
    }
}
#[inline]
fn popcount(m: &Mask) -> u32 {
    m.iter().map(|w| w.count_ones()).sum()
}
#[inline]
fn hash_mask(m: &Mask) -> u64 {
    let mut h: u64 = 0xcbf2_9ce4_8422_2325;
    for &w in m.iter() {
        h = (h ^ w).wrapping_mul(0x0000_0100_0000_01B3);
        h ^= h >> 29;
    }
    h
}

// Open-addressing interner: one stored copy of each mask, u32 ids.
struct Interner {
    masks: Vec<Mask>,
    index: Vec<u32>, // slot -> id, EMPTY sentinel
    mask_lo: usize,  // index.len() - 1 (power-of-two mask)
}

impl Interner {
    fn new(cap_log2: u32) -> Interner {
        let cap = 1usize << cap_log2;
        Interner {
            masks: Vec::new(),
            index: vec![EMPTY; cap],
            mask_lo: cap - 1,
        }
    }
    fn grow(&mut self) {
        let ncap = self.index.len() * 2;
        let mut nindex = vec![EMPTY; ncap];
        let mlo = ncap - 1;
        for (id, m) in self.masks.iter().enumerate() {
            let mut slot = (hash_mask(m) as usize) & mlo;
            while nindex[slot] != EMPTY {
                slot = (slot + 1) & mlo;
            }
            nindex[slot] = id as u32;
        }
        self.index = nindex;
        self.mask_lo = mlo;
    }
    #[inline]
    fn get_or_insert(&mut self, m: &Mask) -> u32 {
        if self.masks.len() * 10 >= self.index.len() * 7 {
            self.grow();
        }
        let mut slot = (hash_mask(m) as usize) & self.mask_lo;
        loop {
            let id = self.index[slot];
            if id == EMPTY {
                let nid = self.masks.len() as u32;
                self.masks.push(*m);
                self.index[slot] = nid;
                return nid;
            }
            if &self.masks[id as usize] == m {
                return id;
            }
            slot = (slot + 1) & self.mask_lo;
        }
    }
    #[inline]
    fn get(&self, m: &Mask) -> u32 {
        let mut slot = (hash_mask(m) as usize) & self.mask_lo;
        loop {
            let id = self.index[slot];
            debug_assert!(id != EMPTY);
            if &self.masks[id as usize] == m {
                return id;
            }
            slot = (slot + 1) & self.mask_lo;
        }
    }
}

struct Board {
    q: usize,
    ncells: usize,
    full: Mask,
    row: Vec<Mask>,
    col: Vec<Mask>,
    line: Vec<Mask>,
    // translation cell-permutations: trans[g*ncells + cell] = image of cell under the
    // g-th translation (e,f). Translations are game automorphisms (they permute rows and
    // columns and preserve affine lines), so canonicalizing a state by the lexicographic
    // min over its q^2 translates preserves the bisimulation class count while cutting the
    // reachable-state count by ~q^2.
    trans: Vec<u32>,
    ntrans: usize,
    canon_on: bool,
}

impl Board {
    fn new(q: usize) -> Board {
        let ncells = q * q;
        assert!(ncells <= W * 64, "q too large for W");
        let mut full = [0u64; W];
        for i in 0..ncells {
            set_bit(&mut full, i);
        }
        let mut row = vec![[0u64; W]; q];
        let mut col = vec![[0u64; W]; q];
        for r in 0..q {
            for c in 0..q {
                let cell = r * q + c;
                set_bit(&mut row[r], cell);
                set_bit(&mut col[c], cell);
            }
        }
        let mut line = vec![[0u64; W]; ncells * ncells];
        for p1 in 0..ncells {
            let (r1, c1) = (p1 / q, p1 % q);
            for p2 in 0..ncells {
                if p1 == p2 {
                    continue;
                }
                let (r2, c2) = (p2 / q, p2 % q);
                let dr = (r2 + q - r1) % q;
                let dc = (c2 + q - c1) % q;
                let m = &mut line[p1 * ncells + p2];
                for x in 0..q {
                    for y in 0..q {
                        let lhs = ((x + q - r1) % q) * dc % q;
                        let rhs = ((y + q - c1) % q) * dr % q;
                        if lhs == rhs {
                            set_bit(m, x * q + y);
                        }
                    }
                }
            }
        }
        // translation permutations (e,f) in F_q x F_q
        let mut trans = vec![0u32; q * q * ncells];
        let mut g = 0usize;
        for e in 0..q {
            for f in 0..q {
                for r in 0..q {
                    for c in 0..q {
                        let src = r * q + c;
                        let dst = ((r + e) % q) * q + ((c + f) % q);
                        trans[g * ncells + src] = dst as u32;
                    }
                }
                g += 1;
            }
        }
        Board {
            q,
            ncells,
            full,
            row,
            col,
            line,
            trans,
            ntrans: q * q,
            canon_on: true,
        }
    }

    // lexicographic-min translate of a mask (canonical form under translation), or the
    // mask itself when canonicalization is disabled.
    #[inline]
    fn canon(&self, m: &Mask) -> Mask {
        if !self.canon_on {
            return *m;
        }
        let mut best: Option<Mask> = None;
        for g in 0..self.ntrans {
            let base = g * self.ncells;
            let mut t = [0u64; W];
            for word in 0..W {
                let mut bits = m[word];
                while bits != 0 {
                    let b = bits.trailing_zeros() as usize;
                    bits &= bits - 1;
                    let dst = self.trans[base + word * 64 + b] as usize;
                    t[dst >> 6] |= 1u64 << (dst & 63);
                }
            }
            match best {
                None => best = Some(t),
                Some(cur) => {
                    if t < cur {
                        best = Some(t);
                    }
                }
            }
        }
        best.unwrap()
    }

    fn legal(&self, occ_mask: &Mask) -> Mask {
        let mut forbidden = *occ_mask;
        let mut occ: Vec<usize> = Vec::new();
        for i in 0..self.ncells {
            if get_bit(occ_mask, i) {
                occ.push(i);
                let (r, c) = (i / self.q, i % self.q);
                or_into(&mut forbidden, &self.row[r]);
                or_into(&mut forbidden, &self.col[c]);
            }
        }
        for a in 0..occ.len() {
            for b in (a + 1)..occ.len() {
                or_into(&mut forbidden, &self.line[occ[a] * self.ncells + occ[b]]);
            }
        }
        let mut legal = [0u64; W];
        for k in 0..W {
            legal[k] = self.full[k] & !forbidden[k];
        }
        legal
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let q: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(11);
    let count_only = args.iter().any(|a| a == "--count-only");
    let no_canon = args.iter().any(|a| a == "--no-canon");
    let mut board = Board::new(q);
    board.canon_on = !no_canon;
    eprintln!("q={} canon={}", q, board.canon_on);

    // ---- Phase 1: enumerate reachable states (masks + index only) ----
    let mut it = Interner::new(20);
    let empty = [0u64; W];
    it.get_or_insert(&empty);
    let mut stack: Vec<u32> = vec![0];
    let mut edges: u64 = 0;
    while let Some(id) = stack.pop() {
        let m = it.masks[id as usize];
        let legal = board.legal(&m);
        for word in 0..W {
            let mut bits = legal[word];
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let mut cm = m;
                set_bit(&mut cm, word * 64 + b);
                let cm = board.canon(&cm);
                let before = it.masks.len();
                let cid = it.get_or_insert(&cm);
                edges += 1;
                if it.masks.len() != before {
                    stack.push(cid);
                }
            }
        }
    }
    let n = it.masks.len();
    eprintln!("phase1 done q={} states={} edges={}", q, n, edges);
    if count_only {
        println!("C83-SIZE q={} states={} edges={}", q, n, edges);
        return;
    }

    // ---- Phase 2: CSR in id order + depth (popcount) ----
    let mut depth: Vec<u8> = vec![0; n];
    let mut child_start: Vec<u32> = vec![0; n + 1];
    let mut child_flat: Vec<u32> = Vec::with_capacity(edges as usize);
    for id in 0..n {
        let m = it.masks[id];
        depth[id] = popcount(&m) as u8;
        child_start[id] = child_flat.len() as u32;
        let legal = board.legal(&m);
        for word in 0..W {
            let mut bits = legal[word];
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                let mut cm = m;
                set_bit(&mut cm, word * 64 + b);
                let cm = board.canon(&cm);
                child_flat.push(it.get(&cm));
            }
        }
    }
    child_start[n] = child_flat.len() as u32;
    assert_eq!(child_flat.len() as u64, edges);
    drop(it); // free masks + index

    // ---- Phase 3: Grundy in reverse-topological (decreasing popcount) order ----
    let mut order: Vec<u32> = (0..n as u32).collect();
    order.sort_unstable_by_key(|&i| std::cmp::Reverse(depth[i as usize]));
    let mut grundy: Vec<u8> = vec![0; n];
    for &i in &order {
        let s = child_start[i as usize] as usize;
        let e = child_start[i as usize + 1] as usize;
        if s == e {
            continue;
        }
        let mut present = [false; 64];
        for k in s..e {
            let cg = grundy[child_flat[k] as usize] as usize;
            present[cg] = true;
        }
        let mut mx = 0u8;
        while present[mx as usize] {
            mx += 1;
        }
        grundy[i as usize] = mx;
    }
    let mut ghist: HashMap<u8, u64> = HashMap::new();
    for &g in &grundy {
        *ghist.entry(g).or_insert(0) += 1;
    }
    let root_grundy = grundy[0];

    // ---- Phase 4: coarsest bisimulation (seed by Grundy; refine by own block +
    // sorted-unique child blocks; hashed signatures) ----
    let mut block: Vec<u32> = vec![0; n];
    {
        let mut remap: HashMap<u8, u32> = HashMap::new();
        for i in 0..n {
            let next = remap.len() as u32;
            block[i] = *remap.entry(grundy[i]).or_insert(next);
        }
    }
    let mut history: Vec<u32> = {
        let mut s = std::collections::HashSet::new();
        for &b in &block {
            s.insert(b);
        }
        vec![s.len() as u32]
    };
    let mut scratch: Vec<u32> = Vec::new();
    loop {
        let mut sig_id: HashMap<u128, u32> = HashMap::new();
        let mut new_block: Vec<u32> = vec![0; n];
        for i in 0..n {
            let s = child_start[i] as usize;
            let e = child_start[i + 1] as usize;
            scratch.clear();
            for k in s..e {
                scratch.push(block[child_flat[k] as usize]);
            }
            scratch.sort_unstable();
            scratch.dedup();
            let mut h: u128 = 0xcbf2_9ce4_8422_2325_cbf2_9ce4_8422_2325;
            h = (h ^ block[i] as u128).wrapping_mul(0x0000_0100_0000_01B3_0000_0100_0000_01B3);
            h = (h ^ 0xFFFF_FFFF).wrapping_mul(0x0000_0100_0000_01B3_0000_0100_0000_01B3);
            for &v in &scratch {
                h = (h ^ v as u128).wrapping_mul(0x0000_0100_0000_01B3_0000_0100_0000_01B3);
            }
            let next = sig_id.len() as u32;
            new_block[i] = *sig_id.entry(h).or_insert(next);
        }
        let count = sig_id.len() as u32;
        history.push(count);
        let stable = count == history[history.len() - 2];
        block = new_block;
        if stable {
            break;
        }
    }
    let n_classes = *history.last().unwrap();

    let mut cpg: HashMap<u8, std::collections::HashSet<u32>> = HashMap::new();
    for i in 0..n {
        cpg.entry(grundy[i]).or_default().insert(block[i]);
    }
    let mut ghist_v: Vec<(u8, u64)> = ghist.into_iter().collect();
    ghist_v.sort();
    let mut cpg_v: Vec<(u8, usize)> = cpg.iter().map(|(g, s)| (*g, s.len())).collect();
    cpg_v.sort();

    println!(
        "C83-BISIM q={} states={} edges={} grundy_values={:?} root_grundy={} bisim_classes={} refine_rounds={:?} classes_per_grundy={:?}",
        q, n, edges, ghist_v, root_grundy, n_classes, history, cpg_v
    );
}
