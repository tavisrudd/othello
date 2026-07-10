// C58: exact cap-game solver on an arbitrary projective plane given as pure
// incidence data (point/line lists).  Independent of the coordinatized grid
// solver -- consumes the .inc files emitted by c58_order9_planes.py, so it works
// on the non-Desarguesian order-9 planes (Hall / dual Hall / Hughes) too.
//
// Game (same semantics as the reference grid solver's `g`):
//   position = a cap (arc): a set of points with no 3 collinear.
//   a move adds a point p keeping the set a cap: p is legal iff p is not already
//     chosen and p lies on NO secant of the current cap (a line through 2 chosen
//     points).  normal play: the player who cannot move loses.
//   value: N (next player to move wins) iff some child is P; P iff all children N
//     or no move exists (terminal => P, mover loses).
//   PG(2,q) = P  <=>  the empty position solves to P (first-player loss).
//
// Memoized negamax with short-circuit (stop a node at the first P child).  The
// memo is a raw (un-canonicalized) open-addressing table keyed by the 128-bit
// cap bitmask; it captures transpositions (same set via different move orders).
//
// Build:  rustc -O -C target-cpu=native scripts/c58_cap_solve.rs -o target/c58cap
// Run:    target/c58cap <plane.inc> [--tt-bits <b>] [--order low|deg]

use std::time::Instant;

const NONE: i32 = -1;

struct Plane {
    n: usize,              // number of points
    all_mask: u128,        // bitmask of all points
    line_masks: Vec<u128>, // per line: bitmask of its points
    // pair_line[a*n + b] = bitmask of the unique line through points a,b (a!=b)
    pair_line: Vec<u128>,
}

fn parse_plane(path: &str) -> Plane {
    let text = std::fs::read_to_string(path).expect("read inc file");
    let mut it = text.split_whitespace();
    let npoints: usize = it.next().unwrap().parse().unwrap();
    let nlines: usize = it.next().unwrap().parse().unwrap();
    assert!(npoints <= 128, "only <=128 points supported (u128 bitset)");
    let mut line_masks = Vec::with_capacity(nlines);
    let mut pair_line = vec![0u128; npoints * npoints];
    let mut lt = vec![NONE; npoints * npoints]; // line index through a,b
    for li in 0..nlines {
        let k: usize = it.next().unwrap().parse().unwrap();
        let mut pts = Vec::with_capacity(k);
        for _ in 0..k {
            let p: usize = it.next().unwrap().parse().unwrap();
            pts.push(p);
        }
        let mut mask = 0u128;
        for &p in &pts {
            mask |= 1u128 << p;
        }
        line_masks.push(mask);
        for i in 0..pts.len() {
            for j in (i + 1)..pts.len() {
                let (a, b) = (pts[i], pts[j]);
                // every point-pair lies on exactly one line -> no overwrite
                debug_assert!(lt[a * npoints + b] == NONE);
                lt[a * npoints + b] = li as i32;
                lt[b * npoints + a] = li as i32;
                pair_line[a * npoints + b] = mask;
                pair_line[b * npoints + a] = mask;
            }
        }
    }
    // every off-diagonal pair must be covered (projective plane axiom)
    for a in 0..npoints {
        for b in 0..npoints {
            if a != b {
                assert!(lt[a * npoints + b] != NONE, "pair on no line");
            }
        }
    }
    let all_mask = if npoints == 128 {
        u128::MAX
    } else {
        (1u128 << npoints) - 1
    };
    Plane {
        n: npoints,
        all_mask,
        line_masks,
        pair_line,
    }
}

// ---- open-addressing memo: slot = 0 empty; else key|occupied(1<<127)|val(1<<126)
// key uses bits 0..=90 (<=91 points), so bits 126/127 are free. ----
struct Memo {
    slots: Vec<u128>,
    mask: usize,
    len: usize,
    cap_entries: usize, // grow trigger (load factor)
    max_entries: usize, // hard cap -> abort
}

const OCC: u128 = 1u128 << 127;
const VAL: u128 = 1u128 << 126;

impl Memo {
    fn new(bits: u32, max_entries: usize) -> Memo {
        let size = 1usize << bits;
        Memo {
            slots: vec![0u128; size],
            mask: size - 1,
            len: 0,
            cap_entries: size * 3 / 4,
            max_entries,
        }
    }
    #[inline]
    fn hash(key: u128) -> u64 {
        // splitmix-ish mix of the two halves
        let mut h = (key as u64) ^ ((key >> 64) as u64).wrapping_mul(0x9E3779B97F4A7C15);
        h ^= h >> 30;
        h = h.wrapping_mul(0xBF58476D1CE4E5B9);
        h ^= h >> 27;
        h
    }
    #[inline]
    fn get(&self, key: u128) -> Option<bool> {
        let mut i = (Self::hash(key) as usize) & self.mask;
        loop {
            let s = self.slots[i];
            if s == 0 {
                return None;
            }
            if (s & !(OCC | VAL)) == key {
                return Some(s & VAL != 0);
            }
            i = (i + 1) & self.mask;
        }
    }
    #[inline]
    fn insert(&mut self, key: u128, val: bool) {
        if self.len >= self.cap_entries {
            self.grow();
        }
        let payload = key | OCC | if val { VAL } else { 0 };
        let mut i = (Self::hash(key) as usize) & self.mask;
        loop {
            let s = self.slots[i];
            if s == 0 {
                self.slots[i] = payload;
                self.len += 1;
                return;
            }
            if (s & !(OCC | VAL)) == key {
                self.slots[i] = payload;
                return;
            }
            i = (i + 1) & self.mask;
        }
    }
    fn grow(&mut self) {
        let newsize = self.slots.len() * 2;
        eprintln!(
            "  [memo grow -> {} slots ({:.1} GB), {} entries]",
            newsize,
            (newsize * 16) as f64 / 1e9,
            self.len
        );
        let old = std::mem::replace(&mut self.slots, vec![0u128; newsize]);
        self.mask = newsize - 1;
        self.cap_entries = newsize * 3 / 4;
        self.len = 0;
        for s in old {
            if s != 0 {
                let key = s & !(OCC | VAL);
                let val = s & VAL != 0;
                let payload = key | OCC | if val { VAL } else { 0 };
                let mut i = (Self::hash(key) as usize) & self.mask;
                loop {
                    if self.slots[i] == 0 {
                        self.slots[i] = payload;
                        self.len += 1;
                        break;
                    }
                    i = (i + 1) & self.mask;
                }
            }
        }
    }
}

struct Solver<'a> {
    p: &'a Plane,
    memo: Memo,
    nodes: u64,
    max_size: usize,
    aborted: bool,
}

impl<'a> Solver<'a> {
    // returns is_n: true = position where the player to move WINS (N)
    // chosen: bitmask of the cap; occ: list of chosen points; forbidden: secant
    // cover (points illegal because on a secant of `chosen`).
    fn g(&mut self, occ: &mut Vec<u32>, chosen: u128, forbidden: u128) -> bool {
        if let Some(v) = self.memo.get(chosen) {
            return v;
        }
        if self.memo.len >= self.memo.max_entries {
            self.aborted = true;
            return false;
        }
        self.nodes += 1;
        let size = occ.len();
        if size > self.max_size {
            self.max_size = size;
        }
        let avail = self.p.all_mask & !chosen & !forbidden;
        let mut is_n = false;
        let mut bits = avail;
        while bits != 0 {
            let z = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let mut nforb = forbidden;
            for &x in occ.iter() {
                nforb |= self.p.pair_line[x as usize * self.p.n + z];
            }
            let nchosen = chosen | (1u128 << z);
            occ.push(z as u32);
            let child = self.g(occ, nchosen, nforb);
            occ.pop();
            if self.aborted {
                return false;
            }
            if !child {
                is_n = true;
                break; // short-circuit: found a P child => this node is N
            }
        }
        self.memo.insert(chosen, is_n);
        is_n
    }
}

// Complete-arc spectrum: an isomorphism-invariant of the plane.  DFS over arcs
// in index-increasing order (each arc visited once); tally all arcs by size and
// maximal (complete) arcs by size.  The complete-arc spectrum is the classical
// distinguisher of the four order-9 planes.
struct Census<'a> {
    p: &'a Plane,
    all_by_size: Vec<u64>,
    complete_by_size: Vec<u64>,
}
impl<'a> Census<'a> {
    fn dfs(&mut self, occ: &mut Vec<u32>, chosen: u128, forbidden: u128) {
        let size = occ.len();
        if size >= self.all_by_size.len() {
            self.all_by_size.resize(size + 1, 0);
            self.complete_by_size.resize(size + 1, 0);
        }
        self.all_by_size[size] += 1;
        let avail = self.p.all_mask & !chosen & !forbidden;
        if avail == 0 {
            self.complete_by_size[size] += 1;
            return;
        }
        let last = *occ.last().unwrap_or(&0);
        // children: only points with index > last (dedup permutations)
        let hi_mask = if size == 0 {
            avail
        } else {
            avail & !((1u128 << (last + 1)) - 1)
        };
        let mut bits = hi_mask;
        while bits != 0 {
            let z = bits.trailing_zeros() as usize;
            bits &= bits - 1;
            let mut nforb = forbidden;
            for &x in occ.iter() {
                nforb |= self.p.pair_line[x as usize * self.p.n + z];
            }
            occ.push(z as u32);
            self.dfs(occ, chosen | (1u128 << z), nforb);
            occ.pop();
        }
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: c58cap <plane.inc> [--tt-bits <b>] [--max-gb <g>] [--census]");
        std::process::exit(1);
    }
    let path = &args[1];
    let mut tt_bits: u32 = 20;
    let mut max_gb: f64 = 7.0;
    let mut census = false;
    let mut i = 2;
    while i < args.len() {
        match args[i].as_str() {
            "--tt-bits" => {
                tt_bits = args[i + 1].parse().unwrap();
                i += 2;
            }
            "--max-gb" => {
                max_gb = args[i + 1].parse().unwrap();
                i += 2;
            }
            "--census" => {
                census = true;
                i += 1;
            }
            other => {
                eprintln!("unknown arg {other}");
                std::process::exit(1);
            }
        }
    }
    let plane = parse_plane(path);
    if census {
        let t0 = Instant::now();
        let mut c = Census {
            p: &plane,
            all_by_size: vec![0; 12],
            complete_by_size: vec![0; 12],
        };
        let mut occ: Vec<u32> = Vec::new();
        c.dfs(&mut occ, 0u128, 0u128);
        let dt = t0.elapsed().as_secs_f64();
        let tot: u64 = c.all_by_size.iter().sum();
        println!(
            "CENSUS {} ({:.1}s, {} total arcs incl. empty)",
            path, dt, tot
        );
        println!("  size : all_arcs : complete_arcs");
        for s in 0..c.all_by_size.len() {
            if c.all_by_size[s] > 0 {
                println!(
                    "  {:>4} : {:>12} : {:>10}",
                    s, c.all_by_size[s], c.complete_by_size[s]
                );
            }
        }
        let cspec: Vec<(usize, u64)> = (0..c.complete_by_size.len())
            .filter(|&s| c.complete_by_size[s] > 0)
            .map(|s| (s, c.complete_by_size[s]))
            .collect();
        println!("  complete-arc spectrum: {:?}", cspec);
        return;
    }
    let max_entries = ((max_gb * 1e9) / 16.0) as usize;
    eprintln!(
        "plane {}: {} points, {} lines; memo start 2^{} slots, max {} entries ({:.1} GB)",
        path,
        plane.n,
        plane.line_masks.len(),
        tt_bits,
        max_entries,
        max_gb
    );
    let mut solver = Solver {
        p: &plane,
        memo: Memo::new(tt_bits, max_entries),
        nodes: 0,
        max_size: 0,
        aborted: false,
    };
    let t0 = Instant::now();
    let mut occ: Vec<u32> = Vec::new();
    let is_n = solver.g(&mut occ, 0u128, 0u128);
    let dt = t0.elapsed().as_secs_f64();
    if solver.aborted {
        println!(
            "ABORTED (memo hit {} entries) after {} nodes, max arc {}, {:.1}s",
            solver.memo.len, solver.nodes, solver.max_size, dt
        );
        std::process::exit(2);
    }
    let verdict = if is_n {
        "N (first-player WIN)"
    } else {
        "P (first-player LOSS)"
    };
    println!(
        "RESULT {} : {}  | nodes {} | memo {} | max arc {} | {:.2}s",
        path, verdict, solver.nodes, solver.memo.len, solver.max_size, dt
    );
}
