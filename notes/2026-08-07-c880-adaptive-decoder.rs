// C880: an adaptive decoder for aligned-design reconstruction.
//
// The manuscript's nonadaptive family costs 3n^2 - 23n + 45 alignment tests.
// This program implements and validates an ADAPTIVE decoder whose cost is
// C(n-1,2) + O(n), i.e. n^2/2 + O(n), against the counting lower bound
// C(n,2) - n = n^2/2 - 3n/2 that binds every decoder, adaptive or not.
//
// Mechanism.  Points are 0..n-1 and 0 is the root; a two-graph is the
// switching class of a graph G on 1..n-1, with tau(0ij) = e_ij and
// tau(ijk) = e_ij + e_ik + e_jk.  Write u_a = e_{va} for a new point v.
// Two shapes of test are used, and each is the conjunction of exactly two
// F_2-affine conditions on the unknown bits:
//
//   root test  {0,v,a,b}   aligned  <=>  u_a = e_ab  and  u_b = e_ab;
//   outer test {v,a,b,c}   aligned  <=>  u_a + u_b = e_ac + e_bc
//                                   and  u_a + u_c = e_ab + e_bc.
//
// ATTACHMENT LEMMA.  Suppose the edges of G inside a set K are known and
// e_vb is known for at least two b in K.  Then for every a in K one test
// determines e_va.  Proof: put beta_b = u_b + e_ab for the known b.  If some
// beta_b = 0 then the root test {0,v,a,b} has its second condition already
// true, so it reads exactly [u_a = e_ab].  Otherwise beta_b = 1 for every
// known b, so any two known b,c have beta_b = beta_c, which is precisely the
// condition that the two conditions of the outer test {v,a,b,c} agree; that
// test then reads exactly [u_a = u_b + e_ac + e_bc].
//
// So attaching a point costs one test per unknown edge, after a bootstrap
// that supplies the first two.  The bootstrap is done on five fixed helper
// points: the tests inside {0,v} u H that contain v determine u on H
// outright, because {0,v} u H has seven points and the paper's own
// faithfulness theorem separates there, while the tests avoiding v are
// already known.  Its cost is a constant, measured exhaustively by the
// `bootstrap` mode over all 2^10 helper graphs and all 2^5 unknown patterns.
//
// Build:  rustc -O -o <scratch>/c880ad 2026-08-07-c880-adaptive-decoder.rs
// Run:    <scratch>/c880ad core      --out <path.json>
//         <scratch>/c880ad bootstrap --out <path.json>
//         <scratch>/c880ad verify --n 7 --out <path.json>
//         <scratch>/c880ad verify --n 8 --out <path.json>
//         <scratch>/c880ad sample --n 12 --count 20000 --seed 1 --out <p.json>
//         <scratch>/c880ad predict --nmax 40 --out <path.json>
//
// Every mode validates the decoder's output against the hidden two-graph, up
// to the global complement, and aborts on any mismatch.

use std::env;
use std::fs;
use std::process;

// ------------------------------------------------------------------ pairs

struct Idx {
    idx: Vec<Vec<usize>>,
    pairs: usize,
}

impl Idx {
    fn new(n: usize) -> Idx {
        let mut idx = vec![vec![usize::MAX; n]; n];
        let mut k = 0;
        for i in 1..n {
            for j in (i + 1)..n {
                idx[i][j] = k;
                idx[j][i] = k;
                k += 1;
            }
        }
        Idx { idx, pairs: k }
    }
    fn at(&self, i: usize, j: usize) -> usize {
        self.idx[i][j]
    }
}

// ------------------------------------------------------------------ graphs

#[derive(Clone)]
struct Graph {
    e: Vec<bool>,
}

impl Graph {
    fn zeros(idx: &Idx) -> Graph {
        Graph { e: vec![false; idx.pairs] }
    }
    fn from_bits(idx: &Idx, bits: u64) -> Graph {
        let mut e = vec![false; idx.pairs];
        for k in 0..idx.pairs {
            e[k] = (bits >> k) & 1 == 1;
        }
        Graph { e }
    }
    fn edge(&self, idx: &Idx, i: usize, j: usize) -> bool {
        self.e[idx.at(i, j)]
    }
    fn set_edge(&mut self, idx: &Idx, i: usize, j: usize, v: bool) {
        self.e[idx.at(i, j)] = v;
    }
    // tau on a triple of distinct points of 0..n-1
    fn tau(&self, idx: &Idx, a: usize, b: usize, c: usize) -> bool {
        let mut t = [a, b, c];
        t.sort_unstable();
        if t[0] == 0 {
            self.edge(idx, t[1], t[2])
        } else {
            self.edge(idx, t[0], t[1]) ^ self.edge(idx, t[0], t[2]) ^ self.edge(idx, t[1], t[2])
        }
    }
    fn aligned(&self, idx: &Idx, q: [usize; 4]) -> bool {
        let mut s = q;
        s.sort_unstable();
        let t0 = self.tau(idx, s[0], s[1], s[2]);
        let t1 = self.tau(idx, s[0], s[1], s[3]);
        let t2 = self.tau(idx, s[0], s[2], s[3]);
        let t3 = self.tau(idx, s[1], s[2], s[3]);
        t0 == t1 && t1 == t2 && t2 == t3
    }
}

// ------------------------------------------------------------------ oracle

struct Oracle<'a> {
    g: &'a Graph,
    idx: &'a Idx,
    count: usize,
}

impl<'a> Oracle<'a> {
    fn ask(&mut self, q: [usize; 4]) -> bool {
        let mut s = q;
        s.sort_unstable();
        assert!(s[0] < s[1] && s[1] < s[2] && s[2] < s[3], "degenerate test");
        self.count += 1;
        self.g.aligned(self.idx, s)
    }
}

// ------------------------------------------------- the seven-point core

// The core is the two-graph on the points 0..6, i.e. a graph on 1..6 with
// fifteen edge bits, determined up to the global complement.  The strategy is
// a greedy adaptive decision tree over the thirty-five tests, built once.

const CORE_N: usize = 7;
const CORE_BITS: u32 = 15;

fn core_tests() -> Vec<[usize; 4]> {
    let mut v = Vec::new();
    for a in 0..CORE_N {
        for b in (a + 1)..CORE_N {
            for c in (b + 1)..CORE_N {
                for d in (c + 1)..CORE_N {
                    v.push([a, b, c, d]);
                }
            }
        }
    }
    v
}

enum CoreNode {
    Leaf(u64),
    Test { test: usize, yes: Box<CoreNode>, no: Box<CoreNode> },
}

struct Core {
    tests: Vec<[usize; 4]>,
    root: CoreNode,
    depth_max: usize,
    depth_sum: usize,
    leaves: usize,
}

fn build_core(idx7: &Idx) -> Core {
    let tests = core_tests();
    let full: u64 = (1u64 << CORE_BITS) - 1;
    // canonical representative of each complement pair
    let mut reps: Vec<u64> = Vec::new();
    for g in 0..(1u64 << CORE_BITS) {
        let c = (!g) & full;
        if g <= c {
            reps.push(g);
        }
    }
    // signature: one bit per test
    let mut sig: Vec<u64> = Vec::with_capacity(reps.len());
    for &r in &reps {
        let gr = Graph::from_bits(idx7, r);
        let mut s = 0u64;
        for (t, q) in tests.iter().enumerate() {
            if gr.aligned(idx7, *q) {
                s |= 1 << t;
            }
        }
        sig.push(s);
    }
    let mut depth_max = 0usize;
    let mut depth_sum = 0usize;
    let mut leaves = 0usize;
    let all: Vec<usize> = (0..reps.len()).collect();
    let root = build_core_node(&all, &sig, tests.len(), &reps, 0, &mut depth_max, &mut depth_sum, &mut leaves);
    Core { tests, root, depth_max, depth_sum, leaves }
}

fn build_core_node(
    cands: &[usize],
    sig: &[u64],
    ntests: usize,
    reps: &[u64],
    depth: usize,
    depth_max: &mut usize,
    depth_sum: &mut usize,
    leaves: &mut usize,
) -> CoreNode {
    if cands.len() == 1 {
        if depth > *depth_max {
            *depth_max = depth;
        }
        *depth_sum += depth;
        *leaves += 1;
        return CoreNode::Leaf(reps[cands[0]]);
    }
    // greedy: the test whose larger side is smallest
    let mut best = usize::MAX;
    let mut best_score = usize::MAX;
    for t in 0..ntests {
        let mut yes = 0usize;
        for &c in cands {
            if (sig[c] >> t) & 1 == 1 {
                yes += 1;
            }
        }
        let no = cands.len() - yes;
        if yes == 0 || no == 0 {
            continue;
        }
        let score = yes.max(no);
        if score < best_score {
            best_score = score;
            best = t;
        }
    }
    assert!(best != usize::MAX, "core: no separating test remains");
    let mut yes_c = Vec::new();
    let mut no_c = Vec::new();
    for &c in cands {
        if (sig[c] >> best) & 1 == 1 {
            yes_c.push(c);
        } else {
            no_c.push(c);
        }
    }
    let y = build_core_node(&yes_c, sig, ntests, reps, depth + 1, depth_max, depth_sum, leaves);
    let n = build_core_node(&no_c, sig, ntests, reps, depth + 1, depth_max, depth_sum, leaves);
    CoreNode::Test { test: best, yes: Box::new(y), no: Box::new(n) }
}

// ------------------------------------------------------------- bootstrap

// The bootstrap works on five helper points, addressed by position 0..4.  All
// of it depends on the hidden two-graph only through the ten known edges among
// the helpers, encoded as HCODE below, and the five unknown edges from the new
// point, encoded as a 5-bit pattern.  That is what makes the exhaustive
// verification in the `bootstrap` mode complete.

const H: usize = 5;
const HPAIRS: usize = 10;

// lexicographic index of the helper pair (p < q)
fn hpair(p: usize, q: usize) -> usize {
    let (a, b) = if p < q { (p, q) } else { (q, p) };
    let mut k = 0;
    for i in 0..H {
        for j in (i + 1)..H {
            if i == a && j == b {
                return k;
            }
            k += 1;
        }
    }
    unreachable!()
}

fn hedge(code: u32, p: usize, q: usize) -> bool {
    (code >> hpair(p, q)) & 1 == 1
}

#[derive(Clone, Copy)]
enum BootQuery {
    Root(usize, usize),          // {0, v, h[p], h[q]}
    Outer(usize, usize, usize),  // {v, h[p], h[q], h[r]}
}

fn boot_queries() -> Vec<BootQuery> {
    let mut q = Vec::new();
    for i in 0..H {
        for j in (i + 1)..H {
            q.push(BootQuery::Root(i, j));
        }
    }
    for i in 0..H {
        for j in (i + 1)..H {
            for k in (j + 1)..H {
                q.push(BootQuery::Outer(i, j, k));
            }
        }
    }
    q
}

// Predicted answer of a bootstrap query, given the helper edge code and a
// candidate assignment u.  Invariant under complementing u and the helper
// edges together, which is why the decoder may work in whichever gauge the
// core fixed.
fn boot_predict(q: BootQuery, u: u32, code: u32) -> bool {
    match q {
        BootQuery::Root(x, z) => {
            let ux = (u >> x) & 1 == 1;
            let uz = (u >> z) & 1 == 1;
            let exz = hedge(code, x, z);
            ux == exz && uz == exz
        }
        BootQuery::Outer(x, z, w) => {
            let ux = (u >> x) & 1 == 1;
            let uz = (u >> z) & 1 == 1;
            let uw = (u >> w) & 1 == 1;
            (ux ^ uz) == (hedge(code, x, w) ^ hedge(code, z, w))
                && (ux ^ uw) == (hedge(code, x, z) ^ hedge(code, z, w))
        }
    }
}

// coordinates on which every surviving candidate agrees
fn resolved_mask(post: &[u32]) -> u32 {
    let mut mask = 0u32;
    for p in 0..H {
        let b = (post[0] >> p) & 1;
        if post.iter().all(|u| (u >> p) & 1 == b) {
            mask |= 1 << p;
        }
    }
    mask
}

// Greedy adaptive bootstrap.  Stops as soon as `want` coordinates are pinned;
// `want = 5` runs it to a single candidate.  Returns that candidate and the
// mask of pinned coordinates.
fn bootstrap<A>(code: u32, ask: &mut A, want: u32) -> (u32, u32)
where
    A: FnMut(BootQuery) -> bool,
{
    let queries = boot_queries();
    let mut post: Vec<u32> = (0..32u32).collect();
    let mut used = vec![false; queries.len()];
    while post.len() > 1 && (resolved_mask(&post).count_ones() as u32) < want {
        let mut best = usize::MAX;
        let mut best_score = usize::MAX;
        for (i, q) in queries.iter().enumerate() {
            if used[i] {
                continue;
            }
            let mut yes = 0usize;
            for &u in &post {
                if boot_predict(*q, u, code) {
                    yes += 1;
                }
            }
            let no = post.len() - yes;
            if yes == 0 || no == 0 {
                continue;
            }
            let score = yes.max(no);
            if score < best_score {
                best_score = score;
                best = i;
            }
        }
        assert!(best != usize::MAX, "bootstrap: no separating query remains");
        used[best] = true;
        let ans = ask(queries[best]);
        post.retain(|&u| boot_predict(queries[best], u, code) == ans);
        assert!(!post.is_empty(), "bootstrap: oracle answer excluded every candidate");
    }
    (post[0], resolved_mask(&post))
}

// ---- exact minimax bootstrap
//
// The bootstrap subproblem is small enough to solve optimally: 32 candidate
// assignments and 20 available tests, with the posterior as the state.  For a
// fixed helper edge code, `opt_depth` is the worst-case number of tests an
// optimal player needs to pin all five coordinates, and `opt_choice` replays
// that optimal play.  The information-theoretic floor is 7, since each test
// answers yes with probability 1/4 and five bits are wanted.

struct BootOpt {
    want: u32,
    memo: std::collections::HashMap<u32, u8>,
    yes: Vec<u32>, // yes-set of each query as a candidate mask
}

// coordinates on which every candidate in a posterior mask agrees
fn pinned_count(post: u32) -> u32 {
    let first = post.trailing_zeros();
    let mut c = 0;
    for p in 0..H {
        let b = (first >> p) & 1;
        let mut agree = true;
        for u in 0..32u32 {
            if (post >> u) & 1 == 1 && (u >> p) & 1 != b {
                agree = false;
                break;
            }
        }
        if agree {
            c += 1;
        }
    }
    c
}

impl BootOpt {
    fn new(code: u32, want: u32) -> BootOpt {
        let queries = boot_queries();
        let mut yes = Vec::with_capacity(queries.len());
        for q in &queries {
            let mut m = 0u32;
            for u in 0..32u32 {
                if boot_predict(*q, u, code) {
                    m |= 1 << u;
                }
            }
            yes.push(m);
        }
        BootOpt { want, memo: std::collections::HashMap::new(), yes }
    }
    fn depth(&mut self, post: u32) -> u8 {
        if post.count_ones() <= 1 || pinned_count(post) >= self.want {
            return 0;
        }
        if let Some(&d) = self.memo.get(&post) {
            return d;
        }
        let mut best = u8::MAX;
        for i in 0..self.yes.len() {
            let y = post & self.yes[i];
            let n = post & !self.yes[i];
            if y == 0 || n == 0 {
                continue;
            }
            let d = 1 + self.depth(y).max(self.depth(n));
            if d < best {
                best = d;
            }
        }
        assert!(best != u8::MAX, "bootstrap: posterior with no separating test");
        self.memo.insert(post, best);
        best
    }
    fn choose(&mut self, post: u32) -> usize {
        let mut best = usize::MAX;
        let mut best_d = u8::MAX;
        for i in 0..self.yes.len() {
            let y = post & self.yes[i];
            let n = post & !self.yes[i];
            if y == 0 || n == 0 {
                continue;
            }
            let d = 1 + self.depth(y).max(self.depth(n));
            if d < best_d {
                best_d = d;
                best = i;
            }
        }
        assert!(best != usize::MAX, "bootstrap: no separating test remains");
        best
    }
}

// The optimal play, compiled once per helper code into a decision tree the
// decoder can walk without re-searching.
enum BNode {
    Leaf { u: u32, mask: u32 },
    Test { q: usize, yes: usize, no: usize },
}

struct BootTree {
    nodes: Vec<BNode>,
    depth: usize,
}

fn build_boot_tree(code: u32, want: u32) -> BootTree {
    let mut opt = BootOpt::new(code, want);
    let depth = opt.depth(u32::MAX) as usize;
    let mut nodes = Vec::new();
    build_boot_node(&mut opt, u32::MAX, &mut nodes);
    BootTree { nodes, depth }
}

fn build_boot_node(opt: &mut BootOpt, post: u32, nodes: &mut Vec<BNode>) -> usize {
    if post.count_ones() <= 1 || pinned_count(post) >= opt.want {
        let first = post.trailing_zeros();
        let mut mask = 0u32;
        for p in 0..H {
            let b = (first >> p) & 1;
            let mut agree = true;
            for u in 0..32u32 {
                if (post >> u) & 1 == 1 && (u >> p) & 1 != b {
                    agree = false;
                    break;
                }
            }
            if agree {
                mask |= 1 << p;
            }
        }
        nodes.push(BNode::Leaf { u: first, mask });
        return nodes.len() - 1;
    }
    let q = opt.choose(post);
    let ymask = opt.yes[q];
    let y = build_boot_node(opt, post & ymask, nodes);
    let n = build_boot_node(opt, post & !ymask, nodes);
    nodes.push(BNode::Test { q, yes: y, no: n });
    nodes.len() - 1
}

fn boot_opt_table(want: u32) -> Vec<usize> {
    (0..(1u32 << HPAIRS))
        .map(|c| BootOpt::new(c, want).depth(u32::MAX) as usize)
        .collect()
}

fn build_boot_trees(want: u32) -> Vec<BootTree> {
    (0..(1u32 << HPAIRS)).map(|c| build_boot_tree(c, want)).collect()
}

// helper edge code of a five-subset of known points, read off a graph
fn code_of(g: &Graph, idx: &Idx, h: &[usize; H]) -> u32 {
    let mut code = 0u32;
    for i in 0..H {
        for j in (i + 1)..H {
            if g.edge(idx, h[i], h[j]) {
                code |= 1 << hpair(i, j);
            }
        }
    }
    code
}

// ------------------------------------------------------------- the decoder

struct DecodeReport {
    queries: usize,
    core_queries: usize,
    boot_queries: usize,
    lemma_queries: usize,
}

fn decode(
    oracle: &mut Oracle,
    n: usize,
    core: &Core,
    idx: &Idx,
    trees: &[BootTree],
) -> (Graph, DecodeReport) {
    assert!(n >= CORE_N);
    let mut g = Graph::zeros(idx);

    // ---- core: the two-graph on 0..6, up to complement
    let mut node = &core.root;
    let start = oracle.count;
    let rep = loop {
        match node {
            CoreNode::Leaf(r) => break *r,
            CoreNode::Test { test, yes, no } => {
                let ans = oracle.ask(core.tests[*test]);
                node = if ans { yes } else { no };
            }
        }
    };
    let core_queries = oracle.count - start;
    // unpack the core representative onto the pairs inside 1..6
    let idx7 = Idx::new(CORE_N);
    for i in 1..CORE_N {
        for j in (i + 1)..CORE_N {
            let bit = (rep >> idx7.at(i, j)) & 1 == 1;
            g.set_edge(idx, i, j, bit);
        }
    }

    let mut boot_queries_total = 0usize;
    let mut lemma_queries_total = 0usize;

    // ---- attach the remaining points one at a time
    for v in CORE_N..n {
        // choose the helper five out of the first six known points: the six
        // five-subsets have different worst-case bootstrap costs, and the
        // decoder knows the induced graph, so it can take the cheapest.
        let pool: Vec<usize> = (1..CORE_N).collect(); // {1,...,6}
        let mut helpers = [0usize; H];
        let mut best_cost = usize::MAX;
        for drop in 0..pool.len() {
            let mut cand = [0usize; H];
            let mut k = 0;
            for (i, &p) in pool.iter().enumerate() {
                if i != drop {
                    cand[k] = p;
                    k += 1;
                }
            }
            let cost = trees[code_of(&g, idx, &cand) as usize].depth;
            if cost < best_cost {
                best_cost = cost;
                helpers = cand;
            }
        }
        let code = code_of(&g, idx, &helpers);

        // bootstrap on those five points, playing the optimal tree
        let before = oracle.count;
        let (u_h, mask) = {
            let tree = &trees[code as usize];
            let queries = boot_queries();
            let mut at = tree.nodes.len() - 1;
            loop {
                match tree.nodes[at] {
                    BNode::Leaf { u, mask } => break (u, mask),
                    BNode::Test { q, yes, no } => {
                        let ans = match queries[q] {
                            BootQuery::Root(x, z) => oracle.ask([0, v, helpers[x], helpers[z]]),
                            BootQuery::Outer(x, z, w) => {
                                oracle.ask([v, helpers[x], helpers[z], helpers[w]])
                            }
                        };
                        at = if ans { yes } else { no };
                    }
                }
            }
        };
        boot_queries_total += oracle.count - before;
        let mut resolved: Vec<usize> = Vec::new();
        let mut pending: Vec<usize> = Vec::new();
        for (p, &h) in helpers.iter().enumerate() {
            if (mask >> p) & 1 == 1 {
                g.set_edge(idx, h, v, (u_h >> p) & 1 == 1);
                resolved.push(h);
            } else {
                pending.push(h);
            }
        }
        assert!(resolved.len() >= 2, "bootstrap pinned fewer than two edges");

        // attachment lemma: one test per remaining edge
        let before = oracle.count;
        let rest: Vec<usize> = pending
            .into_iter()
            .chain(pool.iter().cloned().filter(|p| !helpers.contains(p)))
            .chain(CORE_N..v)
            .collect();
        for a in rest {
            // root test, if some resolved b has u_b = e_ab
            let mut hit: Option<usize> = None;
            for &b in &resolved {
                if g.edge(idx, b, v) == g.edge(idx, a, b) {
                    hit = Some(b);
                    break;
                }
            }
            match hit {
                Some(b) => {
                    let eab = g.edge(idx, a, b);
                    let ans = oracle.ask([0, v, a, b]);
                    g.set_edge(idx, a, v, if ans { eab } else { !eab });
                }
                None => {
                    // every resolved b has beta_b = 1, so any two agree
                    let b = resolved[0];
                    let c = resolved[1];
                    let target = g.edge(idx, b, v) ^ g.edge(idx, a, c) ^ g.edge(idx, b, c);
                    let ans = oracle.ask([v, a, b, c]);
                    g.set_edge(idx, a, v, if ans { target } else { !target });
                }
            }
            resolved.push(a);
        }
        lemma_queries_total += oracle.count - before;
    }

    let report = DecodeReport {
        queries: oracle.count,
        core_queries,
        boot_queries: boot_queries_total,
        lemma_queries: lemma_queries_total,
    };
    (g, report)
}

// ---------------------------------------------------------------- checking

fn same_up_to_complement(a: &Graph, b: &Graph) -> bool {
    let eq = a.e.iter().zip(b.e.iter()).all(|(x, y)| x == y);
    let co = a.e.iter().zip(b.e.iter()).all(|(x, y)| x != y);
    eq || co
}

// ----------------------------------------------------------------- rng

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
}

// ----------------------------------------------------------------- bounds

fn counting_bound(n: usize) -> usize {
    // C(n,2) - n
    n * (n - 1) / 2 - n
}

fn entropy_bound(n: usize) -> f64 {
    let dim = ((n - 1) * (n - 2) / 2) as f64 - 1.0;
    let h = -(0.25f64 * 0.25f64.log2() + 0.75f64 * 0.75f64.log2());
    dim / h
}

fn manuscript_count(n: usize) -> i64 {
    3 * (n as i64) * (n as i64) - 23 * (n as i64) + 45
}

// worst-case bound of the decoder from the two measured constants
fn decoder_bound(n: usize, core_max: usize, boot_max: usize, pinned: usize) -> usize {
    let mut t = core_max;
    for v in CORE_N..n {
        t += boot_max + (v - 1 - pinned);
    }
    t
}

// -------------------------------------------------------------------- main

fn arg(args: &[String], key: &str) -> Option<String> {
    args.iter().position(|a| a == key).and_then(|i| args.get(i + 1).cloned())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: c880ad <core|bootstrap|verify|sample|predict> [options] --out <path>");
        process::exit(2);
    }
    let mode = args[1].clone();
    let out = arg(&args, "--out");
    let idx7 = Idx::new(CORE_N);
    let core = build_core(&idx7);

    let json = match mode.as_str() {
        "core" => {
            format!(
                "{{\n  \"mode\": \"core\",\n  \"points\": {},\n  \"tests\": {},\n  \"complement_pairs\": {},\n  \"leaves\": {},\n  \"depth_max\": {},\n  \"depth_mean\": {:.6}\n}}\n",
                CORE_N,
                core.tests.len(),
                1u64 << (CORE_BITS - 1),
                core.leaves,
                core.depth_max,
                core.depth_sum as f64 / core.leaves as f64
            )
        }
        "bootstrap" => {
            // exhaustive over every helper graph and every unknown pattern
            let hn = H;
            let hpairs = HPAIRS;
            let want: u32 = arg(&args, "--want").unwrap_or_else(|| "5".into()).parse().unwrap();
            let mut worst = 0usize;
            let mut total = 0usize;
            let mut cases = 0usize;
            let mut worst_pinned = 0u32;
            let mut least_pinned = 5u32;
            let mut hist = vec![0usize; 32];
            for gbits in 0..(1u32 << hpairs) {
                for truth in 0..32u32 {
                    let mut used = 0usize;
                    let mut ask = |q: BootQuery| -> bool {
                        used += 1;
                        boot_predict(q, truth, gbits)
                    };
                    let (got, mask) = bootstrap(gbits, &mut ask, want);
                    let pinned = mask.count_ones();
                    assert!(pinned >= want.min(5), "bootstrap pinned too few coordinates");
                    for p in 0..5u32 {
                        if (mask >> p) & 1 == 1 {
                            assert_eq!((got >> p) & 1, (truth >> p) & 1, "bootstrap pinned a wrong bit");
                        }
                    }
                    worst_pinned = worst_pinned.max(pinned);
                    least_pinned = least_pinned.min(pinned);
                    worst = worst.max(used);
                    total += used;
                    cases += 1;
                    hist[used] += 1;
                }
            }
            let mut hist_s = String::new();
            for (k, c) in hist.iter().enumerate() {
                if *c > 0 {
                    if !hist_s.is_empty() {
                        hist_s.push_str(", ");
                    }
                    hist_s.push_str(&format!("\"{}\": {}", k, c));
                }
            }
            format!(
                "{{\n  \"mode\": \"bootstrap\",\n  \"helpers\": {},\n  \"want\": {},\n  \"helper_graphs\": {},\n  \"patterns\": 32,\n  \"cases\": {},\n  \"exhaustive\": true,\n  \"all_pinned_bits_correct\": true,\n  \"pinned_min\": {},\n  \"pinned_max\": {},\n  \"queries_max\": {},\n  \"queries_mean\": {:.6},\n  \"histogram\": {{{}}}\n}}\n",
                hn,
                want,
                1u32 << hpairs,
                cases,
                least_pinned,
                worst_pinned,
                worst,
                total as f64 / cases as f64,
                hist_s
            )
        }
        "helperchoice" => {
            // For every graph on six known points, the decoder picks the
            // five-subset with the cheapest worst-case bootstrap.  This mode
            // reports the largest cost it can be forced to pay, which is the
            // per-attachment constant of the decoder's proved bound.
            let want: u32 = arg(&args, "--want").unwrap_or_else(|| "5".into()).parse().unwrap();
            let table = boot_opt_table(want);
            let six = 6usize;
            let sixpairs = six * (six - 1) / 2; // 15
            let idx6 = Idx::new(7); // pairs on 1..6
            let mut worst_choice = 0usize;
            let mut worst_fixed = 0usize;
            let mut hist = vec![0usize; 32];
            for bits in 0..(1u64 << sixpairs) {
                let g = Graph::from_bits(&idx6, bits);
                let pool: Vec<usize> = (1..7).collect();
                let mut best = usize::MAX;
                for drop in 0..six {
                    let mut cand = [0usize; H];
                    let mut k = 0;
                    for (i, &p) in pool.iter().enumerate() {
                        if i != drop {
                            cand[k] = p;
                            k += 1;
                        }
                    }
                    let c = table[code_of(&g, &idx6, &cand) as usize];
                    best = best.min(c);
                    if drop == 5 {
                        worst_fixed = worst_fixed.max(c); // the fixed choice {1,...,5}
                    }
                }
                worst_choice = worst_choice.max(best);
                hist[best] += 1;
            }
            let mut hist_s = String::new();
            for (k, c) in hist.iter().enumerate() {
                if *c > 0 {
                    if !hist_s.is_empty() {
                        hist_s.push_str(", ");
                    }
                    hist_s.push_str(&format!("\"{}\": {}", k, c));
                }
            }
            format!(
                "{{\n  \"mode\": \"helperchoice\",\n  \"want\": {},\n  \"six_point_graphs\": {},\n  \"exhaustive\": true,\n  \"worst_with_choice\": {},\n  \"worst_fixed_five\": {},\n  \"histogram\": {{{}}}\n}}\n",
                want,
                1u64 << sixpairs,
                worst_choice,
                worst_fixed,
                hist_s
            )
        }
        "bootopt" => {
            let want: u32 = arg(&args, "--want").unwrap_or_else(|| "5".into()).parse().unwrap();
            let table = boot_opt_table(want);
            let mut hist = vec![0usize; 32];
            for &d in &table {
                hist[d] += 1;
            }
            let mut hist_s = String::new();
            for (k, c) in hist.iter().enumerate() {
                if *c > 0 {
                    if !hist_s.is_empty() {
                        hist_s.push_str(", ");
                    }
                    hist_s.push_str(&format!("\"{}\": {}", k, c));
                }
            }
            let mx = *table.iter().max().unwrap();
            let worst_codes: Vec<String> = table
                .iter()
                .enumerate()
                .filter(|(_, &d)| d == mx)
                .map(|(c, _)| format!("{}", c))
                .collect();
            format!(
                "{{\n  \"mode\": \"bootopt\",\n  \"want\": {},\n  \"helper_graphs\": {},\n  \"exhaustive\": true,\n  \"optimal_depth_max\": {},\n  \"optimal_depth_min\": {},\n  \"entropy_floor\": 7,\n  \"worst_codes\": [{}],\n  \"histogram\": {{{}}}\n}}\n",
                want,
                1u32 << HPAIRS,
                table.iter().max().unwrap(),
                table.iter().min().unwrap(),
                worst_codes.join(", "),
                hist_s
            )
        }
        "trivial" => {
            // The one complement class on which the helper five is forced to be
            // monochromatic: the two-graph all of whose triples agree, i.e. the
            // empty and complete graphs.  Its attachments pay the 9-test
            // bootstrap at every stage, so it is the decoder's worst class.
            let nmax: usize = arg(&args, "--nmax").unwrap_or_else(|| "20".into()).parse().unwrap();
            let trees = build_boot_trees(5);
            let mut rows = String::new();
            for n in CORE_N..=nmax {
                let idx = Idx::new(n);
                for (label, fill) in [("empty", false), ("complete", true)] {
                    let g = Graph { e: vec![fill; idx.pairs] };
                    let mut oracle = Oracle { g: &g, idx: &idx, count: 0 };
                    let (out, rep) = decode(&mut oracle, n, &core, &idx, &trees);
                    assert!(same_up_to_complement(&g, &out), "decoder failed on the trivial class");
                    if !rows.is_empty() {
                        rows.push_str(",\n");
                    }
                    rows.push_str(&format!(
                        "    {{\"n\": {}, \"graph\": \"{}\", \"queries\": {}, \"core\": {}, \"bootstrap\": {}, \"lemma\": {}, \"counting\": {}}}",
                        n, label, rep.queries, rep.core_queries, rep.boot_queries, rep.lemma_queries, counting_bound(n)
                    ));
                }
            }
            format!(
                "{{\n  \"mode\": \"trivial\",\n  \"all_recovered\": true,\n  \"rows\": [\n{}\n  ]\n}}\n",
                rows
            )
        }
        "verify" | "sample" => {
            let n: usize = arg(&args, "--n").expect("--n required").parse().unwrap();
            assert!(n >= CORE_N, "n must be at least 7");
            let idx = Idx::new(n);
            let exhaustive = mode == "verify";
            let count: u64 = if exhaustive {
                1u64 << idx.pairs
            } else {
                arg(&args, "--count").expect("--count required").parse().unwrap()
            };
            let seed: u64 = arg(&args, "--seed").unwrap_or_else(|| "1".into()).parse().unwrap();
            let want: u32 = arg(&args, "--want").unwrap_or_else(|| "5".into()).parse().unwrap();
            let trees = build_boot_trees(want);
            if exhaustive {
                assert!(idx.pairs <= 24, "exhaustive mode is limited to n <= 8");
            }
            let mut rng = Rng(seed.wrapping_mul(0x9E3779B97F4A7C15) | 1);
            let mut worst = 0usize;
            let mut total: u64 = 0;
            let mut worst_core = 0usize;
            let mut worst_boot = 0usize;
            let mut worst_lemma = 0usize;
            let mut checked: u64 = 0;
            for i in 0..count {
                let g = if exhaustive {
                    Graph::from_bits(&idx, i)
                } else {
                    let mut e = vec![false; idx.pairs];
                    let mut acc = 0u64;
                    let mut bits = 0;
                    for k in 0..idx.pairs {
                        if bits == 0 {
                            acc = rng.next();
                            bits = 64;
                        }
                        e[k] = acc & 1 == 1;
                        acc >>= 1;
                        bits -= 1;
                    }
                    Graph { e }
                };
                let mut oracle = Oracle { g: &g, idx: &idx, count: 0 };
                let (out_g, rep) = decode(&mut oracle, n, &core, &idx, &trees);
                assert!(same_up_to_complement(&g, &out_g), "decoder failed at instance {}", i);
                worst = worst.max(rep.queries);
                worst_core = worst_core.max(rep.core_queries);
                worst_boot = worst_boot.max(rep.boot_queries);
                worst_lemma = worst_lemma.max(rep.lemma_queries);
                total += rep.queries as u64;
                checked += 1;
            }
            format!(
                "{{\n  \"mode\": \"{}\",\n  \"n\": {},\n  \"instances\": {},\n  \"exhaustive\": {},\n  \"seed\": {},\n  \"want\": {},\n  \"all_recovered\": true,\n  \"queries_max\": {},\n  \"queries_mean\": {:.6},\n  \"core_max\": {},\n  \"bootstrap_max\": {},\n  \"lemma_max\": {},\n  \"dimension\": {},\n  \"counting_bound\": {},\n  \"entropy_bound_nonadaptive\": {:.4},\n  \"manuscript_family\": {}\n}}\n",
                mode,
                n,
                checked,
                exhaustive,
                seed,
                want,
                worst,
                total as f64 / checked as f64,
                worst_core,
                worst_boot,
                worst_lemma,
                (n - 1) * (n - 2) / 2,
                counting_bound(n),
                entropy_bound(n),
                manuscript_count(n)
            )
        }
        "predict" => {
            let nmax: usize = arg(&args, "--nmax").unwrap_or_else(|| "40".into()).parse().unwrap();
            let core_max: usize = arg(&args, "--core-max")
                .unwrap_or_else(|| core.depth_max.to_string())
                .parse()
                .unwrap();
            let boot_max: usize = arg(&args, "--boot-max").expect("--boot-max required").parse().unwrap();
            let pinned: usize = arg(&args, "--pinned").unwrap_or_else(|| "5".into()).parse().unwrap();
            let mut rows = String::new();
            for n in CORE_N..=nmax {
                if !rows.is_empty() {
                    rows.push_str(",\n");
                }
                rows.push_str(&format!(
                    "    {{\"n\": {}, \"decoder_bound\": {}, \"counting\": {}, \"entropy_nonadaptive\": {:.4}, \"manuscript\": {}}}",
                    n,
                    decoder_bound(n, core_max, boot_max, pinned),
                    counting_bound(n),
                    entropy_bound(n),
                    manuscript_count(n)
                ));
            }
            format!(
                "{{\n  \"mode\": \"predict\",\n  \"core_max\": {},\n  \"boot_max\": {},\n  \"pinned\": {},\n  \"rows\": [\n{}\n  ]\n}}\n",
                core_max, boot_max, pinned, rows
            )
        }
        other => {
            eprintln!("unknown mode {}", other);
            process::exit(2);
        }
    };

    match out {
        Some(p) => fs::write(&p, &json).expect("write failed"),
        None => print!("{}", json),
    }
}
