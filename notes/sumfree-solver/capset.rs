// Standalone solver for the impartial CAP-SET game on F_3^d (Game 2).
//
//   Position = cap C subset F_3^d (no 3 distinct a,b,c with a+b+c=0).
//   Move     = add a point keeping it a cap.  Normal play.
//   G(d)     = Grundy value of the EMPTY cap.
//
// Symmetry: the affine group AGL(d,3) = translations + GL(d,3) preserves caps,
// so it is Grundy-preserving.  We memoize on the AGL-canonical form.
//
// Canonicalization (the tractable part).  The lex-min image of C under AGL is
//   min over o in C of  GL-min-image(C - o).
// and the GL-min-image of a vector set V (containing 0) is achieved by mapping
// an ORDERED INDEPENDENT TUPLE of V's own vectors to the standard basis
// e_0,e_1,...  (proof: index 3^j is the smallest new index introducible at
// depth j, hit by sending a fresh independent source vector there; smaller
// indices are forced combinations of already-placed basis vectors).  So the
// search ranges over C's <=|C| points, not the ~2e9 group elements.  A
// prefix-pruned backtracking finds the lex-min image fast.
//
// Build: rustc -O opt-level=3 -C target-cpu=native -C link-arg=-fuse-ld=mold capset.rs -o capset
// Run:   ./capset <d>   (d<=4; the cap bitset is 3^d bits, must be <=128)

use std::env;
use std::time::Instant;

const DMAX: usize = 5;

// -------------------- memo: u128 -> u8 --------------------
const EMPTY: u8 = 0xFF;
struct Table {
    keys: Vec<u128>,
    vals: Vec<u8>,
    mask: usize,
    len: usize,
    start: Instant,
    next_report: usize,
}
impl Table {
    fn new(cap_pow2: u32) -> Self {
        let cap = 1usize << cap_pow2;
        Table {
            keys: vec![0u128; cap],
            vals: vec![EMPTY; cap],
            mask: cap - 1,
            len: 0,
            start: Instant::now(),
            next_report: 1 << 19,
        }
    }
    #[inline(always)]
    fn hash(k: u128) -> u64 {
        let lo = k as u64;
        let hi = (k >> 64) as u64;
        let mut h = lo.wrapping_mul(0x9E37_79B9_7F4A_7C15);
        h ^= hi.wrapping_mul(0xC2B2_AE3D_27D4_EB4F);
        h ^= h >> 29;
        h = h.wrapping_mul(0xBF58_476D_1CE4_E5B9);
        h ^= h >> 32;
        h
    }
    #[inline(always)]
    fn get(&self, k: u128) -> Option<u8> {
        let mut i = (Self::hash(k) as usize) & self.mask;
        loop {
            let v = unsafe { *self.vals.get_unchecked(i) };
            if v == EMPTY {
                return None;
            }
            if unsafe { *self.keys.get_unchecked(i) } == k {
                return Some(v);
            }
            i = (i + 1) & self.mask;
        }
    }
    fn insert(&mut self, k: u128, val: u8) {
        if (self.len + 1) * 10 >= (self.mask + 1) * 7 {
            self.grow();
        }
        let mut i = (Self::hash(k) as usize) & self.mask;
        loop {
            if self.vals[i] == EMPTY {
                self.keys[i] = k;
                self.vals[i] = val;
                self.len += 1;
                if self.len >= self.next_report {
                    eprintln!(
                        "  [progress] memo={} ({:.1}s)",
                        self.len,
                        self.start.elapsed().as_secs_f64()
                    );
                    self.next_report += 1 << 19;
                }
                return;
            }
            if self.keys[i] == k {
                self.vals[i] = val;
                return;
            }
            i = (i + 1) & self.mask;
        }
    }
    fn grow(&mut self) {
        let newcap = (self.mask + 1) * 2;
        let mut nk = vec![0u128; newcap];
        let mut nv = vec![EMPTY; newcap];
        let nmask = newcap - 1;
        for idx in 0..=self.mask {
            if self.vals[idx] != EMPTY {
                let k = self.keys[idx];
                let mut i = (Self::hash(k) as usize) & nmask;
                while nv[i] != EMPTY {
                    i = (i + 1) & nmask;
                }
                nk[i] = k;
                nv[i] = self.vals[idx];
            }
        }
        self.keys = nk;
        self.vals = nv;
        self.mask = nmask;
    }
}

// -------------------- F_3 geometry --------------------
#[inline(always)]
fn inv3(a: i8) -> i8 {
    // inverse mod 3: inv(1)=1, inv(2)=2
    a
}

struct Geo {
    d: usize,
    n: usize,
    pow3: [usize; DMAX + 1],
    coords: Vec<[i8; DMAX]>, // coords[i] = digit vector of point i
    third: Vec<u8>,          // third[a*n+b] = point c with a+b+c=0
}

impl Geo {
    fn new(d: usize) -> Self {
        let mut pow3 = [0usize; DMAX + 1];
        pow3[0] = 1;
        for i in 1..=DMAX {
            pow3[i] = pow3[i - 1] * 3;
        }
        let n = pow3[d];
        let mut coords = vec![[0i8; DMAX]; n];
        for i in 0..n {
            let mut x = i;
            for j in 0..d {
                coords[i][j] = (x % 3) as i8;
                x /= 3;
            }
        }
        let idx = |c: &[i8; DMAX]| -> usize {
            let mut s = 0usize;
            for j in 0..d {
                s += (c[j] as usize) * pow3[j];
            }
            s
        };
        let mut third = vec![0u8; n * n];
        for a in 0..n {
            for b in 0..n {
                let mut c = [0i8; DMAX];
                for j in 0..d {
                    c[j] = ((3 - ((coords[a][j] + coords[b][j]) % 3)) % 3) as i8;
                }
                third[a * n + b] = idx(&c) as u8;
            }
        }
        Geo { d, n, pow3, coords, third }
    }

    #[inline(always)]
    fn idx(&self, c: &[i8; DMAX]) -> usize {
        let mut s = 0usize;
        for j in 0..self.d {
            s += (c[j] as usize) * self.pow3[j];
        }
        s
    }
}

// invert a d x d matrix over F_3 given as columns; returns Some(inverse-as-rows-applied)
// We store M with M[r][c]; solve for inverse. Returns None if singular.
fn invert(m: &[[i8; DMAX]; DMAX], d: usize) -> Option<[[i8; DMAX]; DMAX]> {
    // augmented [m | I], row-reduce
    let mut a = [[0i8; DMAX]; DMAX];
    let mut inv = [[0i8; DMAX]; DMAX];
    for r in 0..d {
        for c in 0..d {
            a[r][c] = m[r][c];
        }
        inv[r][r] = 1;
    }
    for col in 0..d {
        // find pivot row
        let mut piv = None;
        for r in col..d {
            if a[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        let piv = piv?;
        if piv != col {
            a.swap(piv, col);
            inv.swap(piv, col);
        }
        // normalize pivot row so a[col][col]=1
        let f = inv3(a[col][col]);
        for c in 0..d {
            a[col][c] = (a[col][c] * f) % 3;
            inv[col][c] = (inv[col][c] * f) % 3;
        }
        // eliminate other rows
        for r in 0..d {
            if r != col && a[r][col] != 0 {
                let g = a[r][col];
                for c in 0..d {
                    a[r][c] = ((a[r][c] - g * a[col][c]) % 3 + 3) % 3;
                    inv[r][c] = ((inv[r][c] - g * inv[col][c]) % 3 + 3) % 3;
                }
            }
        }
    }
    Some(inv)
}

#[inline(always)]
fn matvec(m: &[[i8; DMAX]; DMAX], v: &[i8; DMAX], d: usize) -> [i8; DMAX] {
    let mut out = [0i8; DMAX];
    for r in 0..d {
        let mut s = 0i32;
        for c in 0..d {
            s += (m[r][c] as i32) * (v[c] as i32);
        }
        out[r] = (((s % 3) + 3) % 3) as i8;
    }
    out
}

// GL-min-image of a vector set V (as coord arrays, including the zero vector).
// Returns the lex-min sorted vector of image indices. Uses prefix-pruned DFS,
// where the ordered independent basis is drawn from V's own vectors.
struct GlCtx<'a> {
    geo: &'a Geo,
    v: Vec<[i8; DMAX]>, // the vector set (includes zero)
}

impl<'a> GlCtx<'a> {
    // inverse of B = [chosen | unit fillers on non-pivot rows]  (single pass).
    fn complete_inverse(&self, chosen: &[[i8; DMAX]]) -> [[i8; DMAX]; DMAX] {
        let d = self.geo.d;
        let m = chosen.len();
        // find the pivot rows of the chosen columns
        let mut w = [[0i8; DMAX]; DMAX];
        for (ci, cc) in chosen.iter().enumerate() {
            for r in 0..d {
                w[r][ci] = cc[r];
            }
        }
        let mut usedrow = [false; DMAX];
        let mut pivrow = [false; DMAX];
        for col in 0..m {
            let mut pr = 0usize;
            for r in 0..d {
                if !usedrow[r] && w[r][col] != 0 {
                    pr = r;
                    break;
                }
            }
            usedrow[pr] = true;
            pivrow[pr] = true;
            let f = inv3(w[pr][col]);
            for c in 0..m {
                w[pr][c] = (w[pr][c] * f) % 3;
            }
            for r in 0..d {
                if r != pr && w[r][col] != 0 {
                    let g = w[r][col];
                    for c in 0..m {
                        w[r][c] = ((w[r][c] - g * w[pr][c]) % 3 + 3) % 3;
                    }
                }
            }
        }
        // B: columns 0..m = chosen, then unit e_r for each non-pivot row r
        let mut b = [[0i8; DMAX]; DMAX];
        for (ci, cc) in chosen.iter().enumerate() {
            for r in 0..d {
                b[r][ci] = cc[r];
            }
        }
        let mut ci = m;
        for r in 0..d {
            if !pivrow[r] {
                b[r][ci] = 1;
                ci += 1;
            }
        }
        invert(&b, d).expect("completed basis must be invertible")
    }

    #[inline(always)]
    fn index_of(&self, c: &[i8; DMAX]) -> u16 {
        let mut s = 0u16;
        for j in 0..self.geo.d {
            s += (c[j] as u16) * (self.geo.pow3[j] as u16);
        }
        s
    }

    fn dfs(&self, chosen: &mut Vec<[i8; DMAX]>, best: &mut Option<Vec<u16>>, nodes: &mut u64) {
        *nodes += 1;
        let d = self.geo.d;
        let m = chosen.len();
        let minv = self.complete_inverse(chosen);
        let mut determined: Vec<u16> = Vec::with_capacity(self.v.len());
        let mut pending: Vec<(u16, [i8; DMAX])> = Vec::new();
        for v in &self.v {
            let c = matvec(&minv, v, d);
            let mut in_span = true;
            for k in m..d {
                if c[k] != 0 {
                    in_span = false;
                    break;
                }
            }
            if in_span {
                determined.push(self.index_of(&c));
            } else {
                pending.push((self.index_of(&c), *v));
            }
        }
        determined.sort_unstable();
        // prune: `determined` = exactly the final image's elements < 3^m (pending
        // all map to indices >= 3^m). So it is a strict prefix of any completion.
        if let Some(b) = best.as_ref() {
            let l = determined.len(); // < b.len() unless pending empty
            let three_m: u16 = 3u16.pow(m as u32);
            let mut prune = false;
            let mut better = false;
            for i in 0..l {
                if determined[i] < b[i] {
                    better = true; // guaranteed to beat best -> continue
                    break;
                } else if determined[i] > b[i] {
                    prune = true;
                    break;
                }
            }
            if !better && !prune && l < b.len() && b[l] < three_m {
                // tied prefix, but best has another element < 3^m that we cannot
                // match (our next element is a pending vector, index >= 3^m)
                prune = true;
            }
            if prune {
                return;
            }
        }
        if pending.is_empty() {
            match best.as_ref() {
                None => *best = Some(determined),
                Some(b) => {
                    if determined < *b {
                        *best = Some(determined);
                    }
                }
            }
            return;
        }
        // best-first: try the pending vector with the smallest current full
        // index first, so `best` tightens early and pruning bites.
        pending.sort_unstable_by_key(|&(idx, _)| idx);
        for (_, p) in pending {
            chosen.push(p);
            self.dfs(chosen, best, nodes);
            chosen.pop();
        }
    }
}

// check first `cur` columns of mat (d rows) are linearly independent over F_3
fn independent(mat: &[[i8; DMAX]; DMAX], d: usize, cur: usize) -> bool {
    // gaussian elimination on the cur columns
    let mut a = [[0i8; DMAX]; DMAX]; // rows d, cols cur
    for r in 0..d {
        for c in 0..cur {
            a[r][c] = mat[r][c];
        }
    }
    let mut rank = 0usize;
    let mut row = 0usize;
    for col in 0..cur {
        // find pivot at or below `row`
        let mut piv = None;
        for r in row..d {
            if a[r][col] != 0 {
                piv = Some(r);
                break;
            }
        }
        if let Some(pr) = piv {
            a.swap(pr, row);
            let f = inv3(a[row][col]);
            for c in 0..cur {
                a[row][c] = (a[row][c] * f) % 3;
            }
            for r in 0..d {
                if r != row && a[r][col] != 0 {
                    let g = a[r][col];
                    for c in 0..cur {
                        a[r][c] = ((a[r][c] - g * a[row][c]) % 3 + 3) % 3;
                    }
                }
            }
            row += 1;
            rank += 1;
        }
    }
    rank == cur
}

// AGL-canonical form of cap C (bitset) -> bitset of the lex-min image.
fn canon_nodes(geo: &Geo, c: u128) -> (u128, u64) {
    // collect points of C
    let mut pts: Vec<usize> = Vec::new();
    let mut x = c;
    while x != 0 {
        let p = x.trailing_zeros() as usize;
        x &= x - 1;
        pts.push(p);
    }
    if pts.is_empty() {
        return (0, 0);
    }
    let mut best: Option<Vec<u16>> = None;
    let mut nodes: u64 = 0;
    // min over origin o in C
    for &o in &pts {
        // V = C - o (coord subtraction), includes zero
        let mut v: Vec<[i8; DMAX]> = Vec::with_capacity(pts.len());
        for &p in &pts {
            let mut cc = [0i8; DMAX];
            for j in 0..geo.d {
                cc[j] = ((geo.coords[p][j] - geo.coords[o][j] + 3) % 3) as i8;
            }
            v.push(cc);
        }
        let ctx = GlCtx { geo, v };
        // reuse `best` across origins for extra pruning
        let mut chosen: Vec<[i8; DMAX]> = Vec::new();
        ctx.dfs(&mut chosen, &mut best, &mut nodes);
    }
    // convert best image (sorted indices) to bitset
    let img = best.unwrap();
    let mut key: u128 = 0;
    for &i in &img {
        key |= 1u128 << (i as usize);
    }
    (key, nodes)
}

#[inline(always)]
fn canon(geo: &Geo, c: u128) -> u128 {
    canon_nodes(geo, c).0
}

// -------------------- game --------------------
fn addable_mask(geo: &Geo, c: u128, full: u128) -> u128 {
    // forbidden = { third(a,b) : a,b in C, a != b }
    let mut forb: u128 = 0;
    let mut pts: [usize; 40] = [0; 40];
    let mut np = 0usize;
    let mut x = c;
    while x != 0 {
        let p = x.trailing_zeros() as usize;
        x &= x - 1;
        pts[np] = p;
        np += 1;
    }
    for i in 0..np {
        for j in (i + 1)..np {
            let t = geo.third[pts[i] * geo.n + pts[j]] as usize;
            forb |= 1u128 << t;
        }
    }
    full & !c & !forb
}

// outcome-only: returns true if C is a P-position (mover loses).
// P  <=>  Grundy == 0, so is_P(empty) decides the "always P (G=0)" conjecture.
// N-positions short-circuit on the first P-child -> far fewer states than full mex.
fn is_p(geo: &Geo, c: u128, full: u128, table: &mut Table) -> bool {
    if let Some(v) = table.get(c) {
        return v == 1;
    }
    let add = addable_mask(geo, c, full);
    let mut res = true; // P unless a move reaches a P-child
    let mut y = add;
    while y != 0 {
        let p = y.trailing_zeros() as usize;
        y &= y - 1;
        let child = c | (1u128 << p);
        let cc = canon(geo, child);
        if is_p(geo, cc, full, table) {
            res = false; // found a P child -> current is N
            break;
        }
    }
    table.insert(c, if res { 1 } else { 0 });
    res
}

fn grundy(geo: &Geo, c: u128, full: u128, table: &mut Table) -> u8 {
    if let Some(v) = table.get(c) {
        return v;
    }
    let add = addable_mask(geo, c, full);
    let mut seen: u64 = 0;
    let mut y = add;
    while y != 0 {
        let p = y.trailing_zeros() as usize;
        y &= y - 1;
        let child = c | (1u128 << p);
        let cc = canon(geo, child);
        let gv = grundy(geo, cc, full, table);
        if gv < 64 {
            seen |= 1u64 << gv;
        }
    }
    let mex = (!seen).trailing_zeros() as u8;
    table.insert(c, mex);
    mex
}

// -------------------- brute AGL canon (validation, small d) --------------------
fn brute_perms(geo: &Geo) -> Vec<Vec<u8>> {
    // enumerate GL(d,3) x translations as point permutations. Only for small d.
    let d = geo.d;
    let n = geo.n;
    let total_mats = 3usize.pow((d * d) as u32);
    let mut perms: Vec<Vec<u8>> = Vec::new();
    for mcode in 0..total_mats {
        // build matrix from base-3 digits
        let mut m = [[0i8; DMAX]; DMAX];
        let mut x = mcode;
        for r in 0..d {
            for c in 0..d {
                m[r][c] = (x % 3) as i8;
                x /= 3;
            }
        }
        if invert(&m, d).is_none() {
            continue;
        }
        // for each translation t
        for tcode in 0..n {
            let tc = &geo.coords[tcode];
            let mut perm = vec![0u8; n];
            for p in 0..n {
                let mv = matvec(&m, &geo.coords[p], d);
                let mut cc = [0i8; DMAX];
                for j in 0..d {
                    cc[j] = (mv[j] + tc[j]) % 3;
                }
                perm[p] = geo.idx(&cc) as u8;
            }
            perms.push(perm);
        }
    }
    perms
}

// sorted-list-lex order for EQUAL-SIZE sets: a < b iff the smallest element
// where they differ belongs to a.
#[inline(always)]
fn sorted_lex_less(a: u128, b: u128) -> bool {
    let diff = a ^ b;
    if diff == 0 {
        return false;
    }
    let m = diff & diff.wrapping_neg();
    (a & m) != 0
}

fn canon_brute(_geo: &Geo, c: u128, perms: &[Vec<u8>]) -> u128 {
    let mut best: Option<u128> = None;
    for perm in perms {
        let mut b: u128 = 0;
        let mut x = c;
        while x != 0 {
            let p = x.trailing_zeros() as usize;
            x &= x - 1;
            b |= 1u128 << (perm[p] as usize);
        }
        match best {
            None => best = Some(b),
            Some(cur) => {
                if sorted_lex_less(b, cur) {
                    best = Some(b);
                }
            }
        }
    }
    best.unwrap()
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let d: usize = args.get(1).and_then(|s| s.parse().ok()).unwrap_or(4);
    let mode = args.get(2).map(|s| s.as_str()).unwrap_or("solve");

    let geo = Geo::new(d);
    if geo.n > 128 {
        eprintln!("d={} needs {} bits > 128; unsupported by this u128 bitset.", d, geo.n);
        return;
    }
    let full: u128 = if geo.n == 128 { u128::MAX } else { (1u128 << geo.n) - 1 };

    if mode == "bench" {
        // measure canon speed and dfs-node counts over random caps by size band
        let mut rng: u64 = 0xdead_beef_cafe_1234;
        let mut rnd = move || {
            rng ^= rng << 13;
            rng ^= rng >> 7;
            rng ^= rng << 17;
            rng
        };
        // build a big pool of random caps
        let mut pools: Vec<Vec<u128>> = vec![Vec::new(); 25]; // by popcount
        for _ in 0..20000 {
            let mut c: u128 = 0;
            loop {
                let add = addable_mask(&geo, c, full);
                if add == 0 {
                    break;
                }
                if (rnd() & 7) == 0 {
                    break;
                }
                let cnt = add.count_ones();
                let mut k = (rnd() % cnt as u64) as u32;
                let mut y = add;
                let mut chosen = usize::MAX;
                loop {
                    let p = y.trailing_zeros() as usize;
                    y &= y - 1;
                    if k == 0 {
                        chosen = p;
                        break;
                    }
                    k -= 1;
                }
                c |= 1u128 << chosen;
                let pc = c.count_ones() as usize;
                if pc < pools.len() {
                    pools[pc].push(c);
                }
            }
        }
        println!("canon bench d={}: (size: samples avg_nodes avg_us)", d);
        for pc in 1..pools.len() {
            let pool = &pools[pc];
            if pool.is_empty() {
                continue;
            }
            let take = pool.len().min(3000);
            let start = Instant::now();
            let mut totn: u64 = 0;
            for &c in pool.iter().take(take) {
                let (_, n) = canon_nodes(&geo, c);
                totn += n;
            }
            let us = start.elapsed().as_secs_f64() * 1e6 / take as f64;
            println!(
                "  size {:>2}: {:>6} samples  {:>8.1} nodes  {:>8.2} us",
                pc,
                take,
                totn as f64 / take as f64,
                us
            );
        }
        return;
    }

    if mode == "validate" {
        // compare min-image canon vs brute full-group canon on random caps
        if d > 3 {
            eprintln!("brute validation only for d<=3");
            return;
        }
        let perms = brute_perms(&geo);
        eprintln!("d={}: |AGL| = {} perms", d, perms.len());
        // random caps: build by adding random addable points
        let mut rng: u64 = 0x1234_5678_9abc_def0;
        let mut rnd = || {
            rng ^= rng << 13;
            rng ^= rng >> 7;
            rng ^= rng << 17;
            rng
        };
        let mut mism = 0;
        let iters = if d == 3 { 30000 } else { 200000 };
        for _ in 0..iters {
            // random cap
            let mut c: u128 = 0;
            loop {
                let add = addable_mask(&geo, c, full);
                if add == 0 {
                    break;
                }
                // 50% stop early
                if (rnd() & 3) == 0 {
                    break;
                }
                // pick a random addable bit
                let cnt = add.count_ones();
                let mut k = (rnd() % cnt as u64) as u32;
                let mut y = add;
                let mut chosen = 0usize;
                loop {
                    let p = y.trailing_zeros() as usize;
                    y &= y - 1;
                    if k == 0 {
                        chosen = p;
                        break;
                    }
                    k -= 1;
                }
                c |= 1u128 << chosen;
            }
            let a = canon(&geo, c);
            let b = canon_brute(&geo, c, &perms);
            if a != b {
                mism += 1;
                if mism <= 5 {
                    eprintln!("MISMATCH c={:b}\n  min-image={:b}\n  brute    ={:b}", c, a, b);
                }
            }
        }
        eprintln!("validate d={}: mismatches={} / 200000", d, mism);
        return;
    }

    if mode == "outcome" {
        // outcome-only (P/N). P <=> Grundy 0, so this decides the conjecture.
        println!("Cap-set game on F_3^{}: |space|={} points  [outcome-only]", d, geo.n);
        let start = Instant::now();
        let mut table = Table::new(16);
        let p = is_p(&geo, 0u128, full, &mut table);
        let secs = start.elapsed().as_secs_f64();
        println!(
            "d={}: empty is {} => G({})=={}  (memo={}, {:.3}s)   conjecture 'always P (G=0)': {}",
            d,
            if p { "P" } else { "N" },
            d,
            if p { "0" } else { ">0" },
            table.len,
            secs,
            if p { "HOLDS" } else { "*** VIOLATED ***" }
        );
        return;
    }

    // solve: compute G(d)
    println!("Cap-set game on F_3^{}: |space|={} points", d, geo.n);
    let start = Instant::now();
    let mut table = Table::new(16);
    let g = grundy(&geo, 0u128, full, &mut table);
    let secs = start.elapsed().as_secs_f64();
    println!(
        "G({}) = {}   (memo={}, {:.3}s)   conjecture 'always P (G=0)': {}",
        d,
        g,
        table.len,
        secs,
        if g == 0 { "HOLDS" } else { "*** VIOLATED ***" }
    );
}
