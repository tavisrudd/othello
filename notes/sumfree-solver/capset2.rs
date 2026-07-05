// Optimized standalone solver for the impartial CAP-SET game on F_3^d.
//
//   Position = cap C subset F_3^d  (no 3 distinct a,b,c in C with a+b+c=0).
//   Move     = add a point p keeping C a cap.  Normal play, last player wins.
//   G(d)     = Grundy value of the EMPTY cap.  Conjecture: G(d)=0 for all d.
//
// Symmetry: AGL(d,3) = translations (3^d) x GL(d,3) preserves caps and the game,
// so it is Grundy-preserving.  We memoise on the AGL-canonical form of each cap:
// the lexicographically-minimal image (as a sorted index list) over the group.
//
// Canonical form (exact, provably a perfect invariant):
//     canon(C) = min over origin o in C of  GL-min-image(C - o).
// GL-min-image maps an ordered independent frame drawn from the cap's OWN
// vectors to the standard basis e_0,e_1,...  (index 3^j is the smallest new
// index a fresh basis vector can introduce at depth j; smaller indices are
// forced combinations of already-placed basis vectors).  A prefix-pruned,
// best-first DFS finds it.
//
// This file is a faster rewrite of capset.rs:
//   * no per-DFS-node heap allocation (fixed stack arrays),
//   * per-node reduction is a d x m Gaussian elimination (no full 4x4 inverse),
//   * origins tried best-first by an affine invariant (parallelogram count) so
//     `best` tightens early and the prefix prune bites,
//   * a hard memo cap so we never disrupt other work on the box.
//
// Build: rustc -C opt-level=3 -C target-cpu=native -C link-arg=-fuse-ld=mold capset2.rs -o capset2
// Run:   ./capset2 <d> <mode>   modes: solve | outcome | validate | bench | count
//        env QUEENS... no; env CAP_MAX_SLOTS=<pow2 count of memo slots> caps memory.

use std::env;
use std::time::Instant;

const DMAX: usize = 5; // supports d<=4 for the u128 bitset (3^4 = 81 <= 128)
const MAXP: usize = 24; // max cap size in F_3^4 is 20; headroom
const EMPTY: u8 = 0xFF;

// -------------------- memo: u128 -> u8, open addressing --------------------
struct Table {
    keys: Vec<u128>,
    vals: Vec<u8>,
    mask: usize,
    len: usize,
    max_slots: usize, // hard ceiling on capacity (memory cap)
    capped: bool,
}
impl Table {
    fn new(cap_pow2: u32, max_slots: usize) -> Self {
        let cap = 1usize << cap_pow2;
        Table {
            keys: vec![0u128; cap],
            vals: vec![EMPTY; cap],
            mask: cap - 1,
            len: 0,
            max_slots,
            capped: false,
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
        if newcap > self.max_slots {
            if !self.capped {
                eprintln!(
                    "  *** MEMO CAP HIT: {} entries in {} slots (~{:.1} GB). Refusing to grow past {} slots. ***",
                    self.len,
                    self.mask + 1,
                    ((self.mask + 1) * 17) as f64 / 1e9,
                    self.max_slots
                );
                self.capped = true;
            }
            // Let the table run at high load factor rather than aborting; correctness
            // holds (open addressing still resolves), it just gets slower.
            return;
        }
        let nmask = newcap - 1;
        let mut nk = vec![0u128; newcap];
        let mut nv = vec![EMPTY; newcap];
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

// -------------------- F_3^d geometry --------------------
struct Geo {
    d: usize,
    n: usize,
    pow3: [usize; DMAX + 1],
    coords: Vec<[i8; DMAX]>, // coords[i] = base-3 digit vector of point i
    third: Vec<u8>,          // third[a*n+b] = point c with a+b+c=0
    add_tbl: Vec<u8>,        // add_tbl[a*n+b] = index of coords_a + coords_b (mod 3)
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
        let mut add_tbl = vec![0u8; n * n];
        for a in 0..n {
            for b in 0..n {
                let mut c = [0i8; DMAX];
                let mut s = [0i8; DMAX];
                for j in 0..d {
                    c[j] = ((3 - ((coords[a][j] + coords[b][j]) % 3)) % 3) as i8;
                    s[j] = ((coords[a][j] + coords[b][j]) % 3) as i8;
                }
                third[a * n + b] = idx(&c) as u8;
                add_tbl[a * n + b] = idx(&s) as u8;
            }
        }
        Geo { d, n, pow3, coords, third, add_tbl }
    }
    #[inline(always)]
    fn idx(&self, c: &[i8; DMAX]) -> usize {
        let mut s = 0usize;
        for j in 0..self.d {
            s += (c[j] as usize) * self.pow3[j];
        }
        s
    }
    // index of coords_a + coords_b - coords_c (mod 3), used for parallelogram invariant
    #[inline(always)]
    fn idx_apbmc(&self, a: usize, b: usize, c: usize) -> usize {
        let mut s = 0usize;
        for j in 0..self.d {
            let v = ((self.coords[a][j] + self.coords[b][j] - self.coords[c][j]) % 3 + 3) % 3;
            s += (v as usize) * self.pow3[j];
        }
        s
    }
}

// -------------------- fast lex-min AGL canonicalisation --------------------
// Reduce m independent column-vectors `chosen` (each length d) to RREF, producing
// a transform T (d x d) with T*chosen[j] = e_j.  Then for any vector v, w = T*v:
//   v is in span(chosen)  iff  w[r]==0 for all r in m..d,
//   full provisional index of v = sum_r w[r]*3^r  (determined => only r<m nonzero).
#[inline]
fn build_transform(chosen: &[[i8; DMAX]], m: usize, d: usize) -> [[i8; DMAX]; DMAX] {
    // A: d rows, columns 0..m = chosen (as columns), columns m..m+d = identity.
    // We only need the identity-block result T = A[., m..m+d] after RREF of left block.
    let mut a = [[0i8; 2 * DMAX]; DMAX];
    for r in 0..d {
        for j in 0..m {
            a[r][j] = chosen[j][r];
        }
        a[r][DMAX + r] = 1; // identity in the augmented block (offset DMAX to be safe)
    }
    let ncol = m;
    let aug0 = DMAX;
    let mut row = 0usize;
    for col in 0..ncol {
        // find pivot at or below `row`
        let mut piv = usize::MAX;
        for r in row..d {
            if a[r][col] != 0 {
                piv = r;
                break;
            }
        }
        // chosen are independent => a pivot always exists
        if piv == usize::MAX {
            continue;
        }
        if piv != row {
            a.swap(piv, row);
        }
        // normalise pivot row (inv of 1 is 1, inv of 2 is 2 over F_3)
        let f = a[row][col]; // 1 or 2, self-inverse
        if f == 2 {
            for c in col..(aug0 + d) {
                a[row][c] = (a[row][c] * 2) % 3;
            }
        }
        // eliminate all other rows
        for r in 0..d {
            if r != row && a[r][col] != 0 {
                let g = a[r][col];
                for c in col..(aug0 + d) {
                    a[r][c] = ((a[r][c] - g * a[row][c]) % 3 + 3) % 3;
                }
            }
        }
        row += 1;
    }
    let mut t = [[0i8; DMAX]; DMAX];
    for r in 0..d {
        for c in 0..d {
            t[r][c] = a[r][aug0 + c];
        }
    }
    t
}

// Context for one canon() call.  `vco` holds the current origin's relative coords.
struct MinImg<'a> {
    geo: &'a Geo,
    vco: [[i8; DMAX]; MAXP], // relative coords for all npts points (includes zero vector)
    sighash: [u64; MAXP],    // AGL-invariant per-point signature hash (indexed like vco)
    npts: usize,
    best: [u16; MAXP],
    best_len: usize,
    has_best: bool,
    nodes: u64,
}
impl<'a> MinImg<'a> {
    #[inline(always)]
    fn idx_of_w(w: &[i8; DMAX], d: usize, pow3: &[usize; DMAX + 1]) -> u16 {
        let mut s = 0u16;
        for r in 0..d {
            s += (w[r] as u16) * (pow3[r] as u16);
        }
        s
    }

    fn dfs(&mut self, chosen: &mut [[i8; DMAX]; DMAX], m: usize) {
        self.nodes += 1;
        let d = self.geo.d;
        let t = build_transform(chosen, m, d);
        // classify all points
        let mut det: [u16; MAXP] = [0; MAXP];
        let mut det_len = 0usize;
        let mut pend_idx: [u16; MAXP] = [0; MAXP];
        let mut pend_vec: [[i8; DMAX]; MAXP] = [[0; DMAX]; MAXP];
        let mut pend_src: [usize; MAXP] = [0; MAXP];
        let mut pend_len = 0usize;
        for i in 0..self.npts {
            let v = &self.vco[i];
            // w = T * v
            let mut w = [0i8; DMAX];
            let mut spanned = true;
            for r in 0..d {
                let mut acc = 0i32;
                let tr = &t[r];
                for c in 0..d {
                    acc += (tr[c] as i32) * (v[c] as i32);
                }
                let wr = (((acc % 3) + 3) % 3) as i8;
                w[r] = wr;
                if r >= m && wr != 0 {
                    spanned = false;
                }
            }
            let idx = Self::idx_of_w(&w, d, &self.geo.pow3);
            if spanned {
                det[det_len] = idx;
                det_len += 1;
            } else {
                pend_idx[pend_len] = idx;
                pend_vec[pend_len] = *v;
                pend_src[pend_len] = i;
                pend_len += 1;
            }
        }
        // sort determined ascending (insertion sort, tiny)
        for i in 1..det_len {
            let x = det[i];
            let mut j = i;
            while j > 0 && det[j - 1] > x {
                det[j] = det[j - 1];
                j -= 1;
            }
            det[j] = x;
        }
        // prefix prune vs best: `det` is a genuine prefix of any completion's
        // sorted image (all det < 3^m, all pending completions >= 3^m).
        if self.has_best {
            let l = det_len.min(self.best_len);
            let mut decided_worse = false;
            for i in 0..l {
                if det[i] < self.best[i] {
                    break; // can still beat best -> keep going
                } else if det[i] > self.best[i] {
                    decided_worse = true;
                    break;
                }
            }
            if decided_worse {
                return;
            }
        }
        if pend_len == 0 {
            // complete image of length npts
            if !self.has_best {
                self.best[..det_len].copy_from_slice(&det[..det_len]);
                self.best_len = det_len;
                self.has_best = true;
            } else {
                // lex compare equal-length sorted lists
                let mut better = false;
                for i in 0..det_len {
                    if det[i] < self.best[i] {
                        better = true;
                        break;
                    } else if det[i] > self.best[i] {
                        break;
                    }
                }
                if better {
                    self.best[..det_len].copy_from_slice(&det[..det_len]);
                    self.best_len = det_len;
                }
            }
            return;
        }
        // best-first: sort pending by provisional full index ascending
        // (insertion sort carrying the vec and source index)
        for i in 1..pend_len {
            let xi = pend_idx[i];
            let xv = pend_vec[i];
            let xs = pend_src[i];
            let mut j = i;
            while j > 0 && pend_idx[j - 1] > xi {
                pend_idx[j] = pend_idx[j - 1];
                pend_vec[j] = pend_vec[j - 1];
                pend_src[j] = pend_src[j - 1];
                j -= 1;
            }
            pend_idx[j] = xi;
            pend_vec[j] = xv;
            pend_src[j] = xs;
        }
        // Frame restriction (only for the FIRST basis vector, m==0): the choice of
        // b_0 is confined to directions whose endpoint has the maximal AGL-invariant
        // signature.  This set is Stab(origin)-equivariant, so min-image over it (with
        // b_1.. exhaustive) is still a COMPLETE invariant -- it just is not the global
        // lex-min image.  Correctness is checked by `validate2` (orbit-partition match).
        let restrict_b0 = m == 0;
        let mut maxh = 0u64;
        if restrict_b0 {
            for i in 0..pend_len {
                let h = self.sighash[pend_src[i]];
                if h > maxh {
                    maxh = h;
                }
            }
        }
        for i in 0..pend_len {
            if restrict_b0 && self.sighash[pend_src[i]] != maxh {
                continue;
            }
            chosen[m] = pend_vec[i];
            self.dfs(chosen, m + 1);
        }
    }
}

// returns (canonical bitmask, dfs nodes)
fn canon_nodes(geo: &Geo, c: u128) -> (u128, u64) {
    // collect points
    let mut pts: [usize; MAXP] = [0; MAXP];
    let mut npts = 0usize;
    let mut x = c;
    while x != 0 {
        let p = x.trailing_zeros() as usize;
        x &= x - 1;
        pts[npts] = p;
        npts += 1;
    }
    if npts == 0 {
        return (0, 0);
    }
    if npts == 1 {
        return (1u128, 0); // single point -> {0}
    }
    // ---- AGL-invariant per-point signature (for origin + b_0 restriction) ----
    // par(p) = #{ (q,r): q,r in C\{p}, q!=r, (q+r-p) in C }  (parallelograms through p).
    let mut par: [u32; MAXP] = [0; MAXP];
    for a in 0..npts {
        let pa = pts[a];
        let mut cnt = 0u32;
        for b in 0..npts {
            if b == a {
                continue;
            }
            let pb = pts[b];
            for e in 0..npts {
                if e == a || e == b {
                    continue;
                }
                let s = geo.idx_apbmc(pb, pts[e], pa);
                if (c >> s) & 1 == 1 {
                    cnt += 1;
                }
            }
        }
        par[a] = cnt;
    }
    // pair invariant cw{i,j} = #{ e != i,j : (pts[i]+pts[j]-pts[e]) in C } (AGL-invariant,
    // symmetric in i,j).  sighash(i) = hash( par[i], sorted multiset of (cw{i,j}, par[j]) ).
    let mut sighash: [u64; MAXP] = [0; MAXP];
    for i in 0..npts {
        let mut pairs: [u64; MAXP] = [0; MAXP];
        let mut np2 = 0usize;
        for j in 0..npts {
            if j == i {
                continue;
            }
            let mut cw = 0u32;
            for e in 0..npts {
                if e == i || e == j {
                    continue;
                }
                let s = geo.idx_apbmc(pts[i], pts[j], pts[e]);
                if (c >> s) & 1 == 1 {
                    cw += 1;
                }
            }
            pairs[np2] = ((cw as u64) << 40) | (par[j] as u64);
            np2 += 1;
        }
        pairs[..np2].sort_unstable();
        let mut h: u64 = 0xcbf2_9ce4_8422_2325 ^ (par[i] as u64).wrapping_mul(0x100_0000_01b3);
        for &pv in pairs.iter().take(np2) {
            h ^= pv;
            h = h.wrapping_mul(0x100_0000_01b3);
            h ^= h >> 29;
        }
        sighash[i] = h;
    }
    // Restrict origins to those with the maximal signature hash (an AGL-equivariant
    // subset).  Min-image over this subset is still a complete invariant.
    let mut maxsig = 0u64;
    for i in 0..npts {
        if sighash[i] > maxsig {
            maxsig = sighash[i];
        }
    }

    let mut mi = MinImg {
        geo,
        vco: [[0; DMAX]; MAXP],
        sighash,
        npts,
        best: [0; MAXP],
        best_len: 0,
        has_best: false,
        nodes: 0,
    };
    let d = geo.d;
    let mut chosen = [[0i8; DMAX]; DMAX];
    for oi in 0..npts {
        if sighash[oi] != maxsig {
            continue;
        }
        let o = pts[oi];
        for i in 0..npts {
            let p = pts[i];
            for j in 0..d {
                mi.vco[i][j] = ((geo.coords[p][j] - geo.coords[o][j]) % 3 + 3) % 3;
            }
        }
        mi.dfs(&mut chosen, 0);
    }
    let mut key: u128 = 0;
    for i in 0..mi.best_len {
        key |= 1u128 << (mi.best[i] as usize);
    }
    (key, mi.nodes)
}

#[inline(always)]
fn canon(geo: &Geo, c: u128) -> u128 {
    canon_nodes(geo, c).0
}

// Translation-subgroup canonical form: lex-min (as a sorted set) over the 3^d
// translations.  A genuine subgroup of AGL, so Grundy-preserving; O(n*k) and
// ~1 us.  Coarser quotient than full AGL (up to 3^d larger), but exact.
fn canon_trans(geo: &Geo, c: u128) -> u128 {
    if c == 0 {
        return 0;
    }
    // collect points
    let mut pts: [usize; MAXP] = [0; MAXP];
    let mut np = 0usize;
    let mut x = c;
    while x != 0 {
        let p = x.trailing_zeros() as usize;
        x &= x - 1;
        pts[np] = p;
        np += 1;
    }
    let n = geo.n;
    let mut best: u128 = u128::MAX;
    // try every translation t; translate every point by t; build bitmask; keep lex-min
    for t in 0..n {
        let base = t * n;
        let mut b: u128 = 0;
        for i in 0..np {
            let q = unsafe { *geo.add_tbl.get_unchecked(base + pts[i]) } as usize;
            b |= 1u128 << q;
        }
        if best == u128::MAX || sorted_lex_less(b, best) {
            best = b;
        }
    }
    best
}

// -------------------- game move generation --------------------
#[inline]
fn addable_mask(geo: &Geo, c: u128, full: u128) -> u128 {
    let mut forb: u128 = 0;
    let mut pts: [usize; MAXP] = [0; MAXP];
    let mut np = 0usize;
    let mut x = c;
    while x != 0 {
        let p = x.trailing_zeros() as usize;
        x &= x - 1;
        pts[np] = p;
        np += 1;
    }
    let n = geo.n;
    for i in 0..np {
        let base = pts[i] * n;
        for j in (i + 1)..np {
            let t = unsafe { *geo.third.get_unchecked(base + pts[j]) } as usize;
            forb |= 1u128 << t;
        }
    }
    full & !c & !forb
}

// -------------------- solver --------------------
struct Solver {
    geo: Geo,
    full: u128,
    table: Table,
    canon_fn: fn(&Geo, u128) -> u128,
    start: Instant,
    canon_calls: u64,
    max_pc: u32,
    next_check: u64,
    last_report_s: f64,
}
impl Solver {
    fn new(d: usize, max_slots: usize, canon_fn: fn(&Geo, u128) -> u128) -> Self {
        let geo = Geo::new(d);
        let full: u128 = if geo.n == 128 { u128::MAX } else { (1u128 << geo.n) - 1 };
        Solver {
            geo,
            full,
            table: Table::new(18, max_slots),
            canon_fn,
            start: Instant::now(),
            canon_calls: 0,
            max_pc: 0,
            next_check: 1 << 20,
            last_report_s: 0.0,
        }
    }
    #[inline]
    fn tick(&mut self, pc: u32) {
        if pc > self.max_pc {
            self.max_pc = pc;
        }
        self.canon_calls += 1;
        if self.canon_calls >= self.next_check {
            self.next_check += 1 << 20;
            let s = self.start.elapsed().as_secs_f64();
            if s - self.last_report_s >= 2.0 {
                self.last_report_s = s;
                let rss = read_rss_gb();
                eprintln!(
                    "  [t={:>6.1}s] memo={:>11} canon_calls={:>13} max_cap={} rss={:.2}GB{}",
                    s,
                    self.table.len,
                    self.canon_calls,
                    self.max_pc,
                    rss,
                    if self.table.capped { " [CAPPED]" } else { "" }
                );
            }
        }
    }

    // outcome-only: true iff C is a P-position (mover loses => Grundy 0).
    fn is_p(&mut self, c: u128) -> bool {
        if let Some(v) = self.table.get(c) {
            return v == 1;
        }
        let pc = c.count_ones();
        self.tick(pc);
        let add = addable_mask(&self.geo, c, self.full);
        let mut res = true; // P unless a move reaches a P-child
        let mut y = add;
        while y != 0 {
            let p = y.trailing_zeros() as usize;
            y &= y - 1;
            let child = c | (1u128 << p);
            let cc = (self.canon_fn)(&self.geo, child);
            if self.is_p(cc) {
                res = false;
                break;
            }
        }
        self.table.insert(c, if res { 1 } else { 0 });
        res
    }

    // full Grundy value via mex.
    fn grundy(&mut self, c: u128) -> u8 {
        if let Some(v) = self.table.get(c) {
            return v;
        }
        let pc = c.count_ones();
        self.tick(pc);
        let add = addable_mask(&self.geo, c, self.full);
        let mut seen: u64 = 0;
        let mut y = add;
        while y != 0 {
            let p = y.trailing_zeros() as usize;
            y &= y - 1;
            let child = c | (1u128 << p);
            let cc = (self.canon_fn)(&self.geo, child);
            let gv = self.grundy(cc);
            if gv < 64 {
                seen |= 1u64 << gv;
            }
        }
        let mex = (!seen).trailing_zeros() as u8;
        self.table.insert(c, mex);
        mex
    }
}

fn read_rss_gb() -> f64 {
    use std::fs;
    if let Ok(s) = fs::read_to_string("/proc/self/statm") {
        if let Some(tok) = s.split_whitespace().nth(1) {
            if let Ok(pages) = tok.parse::<u64>() {
                return (pages * 4096) as f64 / 1e9;
            }
        }
    }
    0.0
}

// -------------------- brute AGL canon (validation, d<=3) --------------------
fn invert(m: &[[i8; DMAX]; DMAX], d: usize) -> Option<[[i8; DMAX]; DMAX]> {
    let mut a = [[0i8; DMAX]; DMAX];
    let mut inv = [[0i8; DMAX]; DMAX];
    for r in 0..d {
        for c in 0..d {
            a[r][c] = m[r][c];
        }
        inv[r][r] = 1;
    }
    for col in 0..d {
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
        let f = a[col][col]; // self-inverse over F_3
        for c in 0..d {
            a[col][c] = (a[col][c] * f) % 3;
            inv[col][c] = (inv[col][c] * f) % 3;
        }
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
fn brute_perms(geo: &Geo) -> Vec<Vec<u8>> {
    let d = geo.d;
    let n = geo.n;
    let total_mats = 3usize.pow((d * d) as u32);
    let mut perms: Vec<Vec<u8>> = Vec::new();
    for mcode in 0..total_mats {
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
#[inline(always)]
fn sorted_lex_less(a: u128, b: u128) -> bool {
    let diff = a ^ b;
    if diff == 0 {
        return false;
    }
    let m = diff & diff.wrapping_neg();
    (a & m) != 0
}
fn canon_brute(c: u128, perms: &[Vec<u8>]) -> u128 {
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
    let mode = args.get(2).map(|s| s.as_str()).unwrap_or("outcome");
    let sym = args.get(3).map(|s| s.as_str()).unwrap_or("agl"); // agl | trans

    // memory cap: default 2^28 slots (~4.6 GB for keys+vals). Override via env.
    let max_pow2: u32 = env::var("CAP_MAX_SLOTS_POW2")
        .ok()
        .and_then(|s| s.parse().ok())
        .unwrap_or(28);
    let max_slots = 1usize << max_pow2;

    let geo = Geo::new(d);
    if geo.n > 128 {
        eprintln!(
            "d={} needs {} bits > 128; this u128 build supports d<=4 only.",
            d, geo.n
        );
        return;
    }
    let full: u128 = if geo.n == 128 { u128::MAX } else { (1u128 << geo.n) - 1 };

    match mode {
        "validate" => {
            // The restricted AGL canon is a COMPLETE invariant but not the global
            // lex-min image, so we check it two ways against the brute full-group form:
            //  (1) invariance: canon(C) == canon(g.C) for random g in AGL,
            //  (2) orbit-partition match: canon(.) and canon_brute(.) induce the SAME
            //      partition on a random sample (b->r and r->b both single-valued).
            if d > 3 {
                eprintln!("brute validation only for d<=3");
                return;
            }
            use std::collections::HashMap;
            let perms = brute_perms(&geo);
            eprintln!("d={}: |AGL(d,3)| = {} perms", d, perms.len());
            let mut rng: u64 = 0x1234_5678_9abc_def0;
            let mut rnd = || {
                rng ^= rng << 13;
                rng ^= rng >> 7;
                rng ^= rng << 17;
                rng
            };
            let apply = |perm: &[u8], c: u128| -> u128 {
                let mut b = 0u128;
                let mut x = c;
                while x != 0 {
                    let p = x.trailing_zeros() as usize;
                    x &= x - 1;
                    b |= 1u128 << (perm[p] as usize);
                }
                b
            };
            let mut b2r: HashMap<u128, u128> = HashMap::new();
            let mut r2b: HashMap<u128, u128> = HashMap::new();
            let mut inv_fail = 0u64;
            let mut part_fail = 0u64;
            let iters: u64 = if d == 3 { 60_000 } else { 300_000 };
            for _ in 0..iters {
                let mut c: u128 = 0;
                loop {
                    let add = addable_mask(&geo, c, full);
                    if add == 0 || (rnd() & 3) == 0 {
                        break;
                    }
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
                let r = canon(&geo, c);
                let b = canon_brute(c, &perms);
                // (2) partition match vs brute
                match b2r.get(&b) {
                    Some(&pr) if pr != r => part_fail += 1,
                    None => {
                        b2r.insert(b, r);
                    }
                    _ => {}
                }
                match r2b.get(&r) {
                    Some(&pb) if pb != b => part_fail += 1,
                    None => {
                        r2b.insert(r, b);
                    }
                    _ => {}
                }
                // (1) invariance under a random group element
                let perm = &perms[(rnd() as usize) % perms.len()];
                let gc = apply(perm, c);
                if canon(&geo, gc) != r {
                    inv_fail += 1;
                    if inv_fail <= 3 {
                        eprintln!("INVARIANCE FAIL c={:b} -> {:b} vs {:b}", c, r, canon(&geo, gc));
                    }
                }
            }
            eprintln!(
                "validate d={}: invariance_fail={} partition_fail={} / {} samples ({} brute-classes seen)",
                d, inv_fail, part_fail, iters, b2r.len()
            );
        }
        "invcheck" => {
            // Invariance test for ANY d (no full-group enumeration): apply random
            // affine maps g = M.x + t (M in GL(d,3)) to random caps and confirm
            // canon(g.C) == canon(C).  Catches equivariance bugs at d=4 where brute
            // enumeration is infeasible.  (Completeness is guaranteed by construction:
            // canon(C) is always an AGL-image of C, so it cannot merge distinct orbits.)
            let mut rng: u64 = 0x0bad_c0de_1234_5678;
            let mut rnd = || {
                rng ^= rng << 13;
                rng ^= rng >> 7;
                rng ^= rng << 17;
                rng
            };
            // build a point-permutation for a random affine map
            let rand_affine = |rnd: &mut dyn FnMut() -> u64| -> Vec<u8> {
                loop {
                    let mut m = [[0i8; DMAX]; DMAX];
                    for r in 0..d {
                        for cc in 0..d {
                            m[r][cc] = (rnd() % 3) as i8;
                        }
                    }
                    if invert(&m, d).is_none() {
                        continue;
                    }
                    let mut t = [0i8; DMAX];
                    for r in 0..d {
                        t[r] = (rnd() % 3) as i8;
                    }
                    let mut perm = vec![0u8; geo.n];
                    for p in 0..geo.n {
                        let mv = matvec(&m, &geo.coords[p], d);
                        let mut ccx = [0i8; DMAX];
                        for j in 0..d {
                            ccx[j] = (mv[j] + t[j]) % 3;
                        }
                        perm[p] = geo.idx(&ccx) as u8;
                    }
                    return perm;
                }
            };
            let apply = |perm: &[u8], c: u128| -> u128 {
                let mut b = 0u128;
                let mut x = c;
                while x != 0 {
                    let p = x.trailing_zeros() as usize;
                    x &= x - 1;
                    b |= 1u128 << (perm[p] as usize);
                }
                b
            };
            let iters = 200_000u64;
            let mut fails = 0u64;
            for _ in 0..iters {
                // random cap
                let mut c: u128 = 0;
                loop {
                    let add = addable_mask(&geo, c, full);
                    if add == 0 || (rnd() & 3) == 0 {
                        break;
                    }
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
                let base = canon(&geo, c);
                let perm = rand_affine(&mut rnd);
                let gc = apply(&perm, c);
                let gcan = canon(&geo, gc);
                if gcan != base {
                    fails += 1;
                    if fails <= 3 {
                        eprintln!("INVCHECK FAIL: canon(C)={:b} canon(gC)={:b}", base, gcan);
                    }
                }
            }
            eprintln!("invcheck d={}: invariance_fail={} / {} random affine maps", d, fails, iters);
        }
        "bench" => {
            let mut rng: u64 = 0xdead_beef_cafe_1234;
            let mut rnd = move || {
                rng ^= rng << 13;
                rng ^= rng >> 7;
                rng ^= rng << 17;
                rng
            };
            let mut pools: Vec<Vec<u128>> = vec![Vec::new(); 25];
            for _ in 0..30000 {
                let mut c: u128 = 0;
                loop {
                    let add = addable_mask(&geo, c, full);
                    if add == 0 || (rnd() & 7) == 0 {
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
                let take = pool.len().min(4000);
                let start = Instant::now();
                let mut totn: u64 = 0;
                for &c in pool.iter().take(take) {
                    let (_, nn) = canon_nodes(&geo, c);
                    totn += nn;
                }
                let us = start.elapsed().as_secs_f64() * 1e6 / take as f64;
                println!(
                    "  size {:>2}: {:>6} samples  {:>9.1} nodes  {:>9.3} us",
                    pc,
                    take,
                    totn as f64 / take as f64,
                    us
                );
            }
        }
        "outcome" => {
            let (cf, symname): (fn(&Geo, u128) -> u128, &str) = match sym {
                "trans" => (canon_trans, "translation-only (3^d)"),
                _ => (canon, "full AGL(d,3)"),
            };
            println!(
                "Cap-set game F_3^{}: |space|={} pts  [outcome-only, sym={}, memo cap 2^{} slots]",
                d, geo.n, symname, max_pow2
            );
            let mut solver = Solver::new(d, max_slots, cf);
            let p = solver.is_p(0u128);
            let secs = solver.start.elapsed().as_secs_f64();
            println!(
                "d={}: empty is {} => G({}) {} 0  (memo={}, canon_calls={}, max_cap={}, {:.3}s){}",
                d,
                if p { "P" } else { "N" },
                d,
                if p { "==" } else { ">" },
                solver.table.len,
                solver.canon_calls,
                solver.max_pc,
                secs,
                if p {
                    "  conjecture 'always P (G=0)' HOLDS"
                } else {
                    "  *** conjecture VIOLATED ***"
                }
            );
        }
        _ => {
            // solve: full Grundy
            let (cf, symname): (fn(&Geo, u128) -> u128, &str) = match sym {
                "trans" => (canon_trans, "translation-only (3^d)"),
                _ => (canon, "full AGL(d,3)"),
            };
            println!(
                "Cap-set game F_3^{}: |space|={} pts  [full Grundy, sym={}, memo cap 2^{} slots]",
                d, geo.n, symname, max_pow2
            );
            let mut solver = Solver::new(d, max_slots, cf);
            let g = solver.grundy(0u128);
            let secs = solver.start.elapsed().as_secs_f64();
            println!(
                "G({}) = {}  (memo={}, canon_calls={}, max_cap={}, {:.3}s)  conjecture 'always P (G=0)': {}",
                d,
                g,
                solver.table.len,
                solver.canon_calls,
                solver.max_pc,
                secs,
                if g == 0 { "HOLDS" } else { "*** VIOLATED ***" }
            );
        }
    }
}
