// C880: query complexity of aligned-design reconstruction.
//
// Two questions, one program:
//   (1) `threshold` — on n points, does the full family of alignment tests
//       determine the two-graph up to the global complement bit?  A collision
//       at n = 6 makes the manuscript's hypothesis |V| >= 7 sharp.
//   (2) `minimize`  — the exact minimum number of alignment tests that
//       determines a two-graph on n points up to complement (nonadaptive
//       query complexity), compared with the exhibited 3n^2 - 23n + 45.
//
// Build:  rustc -O -o <scratch>/c880 2026-08-07-c880-alignment-separation.rs
// Run:    <scratch>/c880 threshold --nmax 7 --out <path.json>
//         <scratch>/c880 minimize --n 7 --out <path.json>
//
// Conventions
//   Points are 0..n-1.  A two-graph is a map tau from 3-subsets to F_2 with
//   even sum on every 4-subset; equivalently the switching class of a graph,
//   tau(abc) = (number of edges of G inside {a,b,c}) mod 2.
//   Every switching class has exactly one representative graph in which the
//   point 0 is isolated, so switching classes on n points are indexed by the
//   2^C(n-1,2) graphs on the points 1..n-1; the bit for the pair (i,j) with
//   1 <= i < j <= n-1 is edge_index[i][j], assigned in lexicographic order.
//   The complementary two-graph tau + 1 is the complement graph on 1..n-1,
//   i.e. the bitwise complement of the index inside its C(n-1,2) bits.
//
//   A 4-subset is ALIGNED when its four triples carry equal tau values.  This
//   is the alignment test: one bit per 4-subset, invariant under the global
//   complement.  4-subsets are indexed in lexicographic order.
//
//   The alignment vector of a two-graph is the C(n,4)-bit word of those tests.
//   `threshold` asks whether distinct complement pairs have distinct vectors;
//   `minimize` asks for the smallest set of coordinates on which they stay
//   distinct.
//
// The minimization is exact: a lazy-constraint (row generation) loop over a
// minimal-hitting-set enumerator, seeded with every pair-difference mask of
// small weight.  A candidate is accepted only after a direct check that its
// coordinates separate all complement pairs, and a size is rejected only after
// the enumerator exhausts every minimal hitting set of that size for a family
// of constraints each of which is a genuine pair difference.

use std::collections::HashSet;
use std::env;
use std::fs;
use std::process;

// ---------------------------------------------------------------- structure

struct Model {
    n: usize,
    edge_bits: usize,       // C(n-1, 2)
    class_count: usize,     // 2^edge_bits switching classes
    foursets: Vec<[usize; 4]>,
    // for each 4-subset, the four edge masks of its triples
    triple_masks: Vec<[u32; 4]>,
}

fn build_model(n: usize) -> Model {
    assert!((4..=9).contains(&n), "n out of supported range");
    let mut edge_index = vec![vec![usize::MAX; n]; n];
    let mut edge_bits = 0usize;
    for i in 1..n {
        for j in (i + 1)..n {
            edge_index[i][j] = edge_bits;
            edge_bits += 1;
        }
    }
    let triple_mask = |t: [usize; 3]| -> u32 {
        let mut m = 0u32;
        for a in 0..3 {
            for b in (a + 1)..3 {
                let (i, j) = (t[a], t[b]);
                if i >= 1 {
                    m |= 1u32 << edge_index[i][j];
                }
            }
        }
        m
    };
    let mut foursets = Vec::new();
    let mut triple_masks = Vec::new();
    for a in 0..n {
        for b in (a + 1)..n {
            for c in (b + 1)..n {
                for d in (c + 1)..n {
                    foursets.push([a, b, c, d]);
                    triple_masks.push([
                        triple_mask([a, b, c]),
                        triple_mask([a, b, d]),
                        triple_mask([a, c, d]),
                        triple_mask([b, c, d]),
                    ]);
                }
            }
        }
    }
    Model {
        n,
        edge_bits,
        class_count: 1usize << edge_bits,
        foursets,
        triple_masks,
    }
}

impl Model {
    fn tests(&self) -> usize {
        self.foursets.len()
    }

    /// Alignment vector of the switching class indexed by `g`.
    fn alignment(&self, g: u32) -> u128 {
        let mut v = 0u128;
        for (k, tm) in self.triple_masks.iter().enumerate() {
            let p0 = ((tm[0] & g).count_ones() & 1) as u8;
            let p1 = ((tm[1] & g).count_ones() & 1) as u8;
            let p2 = ((tm[2] & g).count_ones() & 1) as u8;
            let p3 = ((tm[3] & g).count_ones() & 1) as u8;
            if p0 == p1 && p1 == p2 && p2 == p3 {
                v |= 1u128 << k;
            }
        }
        v
    }

    fn complement(&self, g: u32) -> u32 {
        g ^ ((1u32 << self.edge_bits) - 1)
    }

    /// Edge list of the representative graph (point 0 isolated).
    fn edges(&self, g: u32) -> Vec<[usize; 2]> {
        let mut out = Vec::new();
        let mut bit = 0usize;
        for i in 1..self.n {
            for j in (i + 1)..self.n {
                if g >> bit & 1 == 1 {
                    out.push([i, j]);
                }
                bit += 1;
            }
        }
        out
    }

    /// Representatives of the complement pairs: g < complement(g).
    fn pair_reps(&self) -> Vec<u32> {
        (0..self.class_count as u32)
            .filter(|&g| g < self.complement(g))
            .collect()
    }
}

// ---------------------------------------------------------------- json bits

fn json_fourset(f: &[usize; 4]) -> String {
    format!("[{},{},{},{}]", f[0], f[1], f[2], f[3])
}

fn json_edges(e: &[[usize; 2]]) -> String {
    let inner: Vec<String> = e.iter().map(|p| format!("[{},{}]", p[0], p[1])).collect();
    format!("[{}]", inner.join(","))
}

fn json_bits(v: u128, width: usize) -> String {
    let idx: Vec<String> = (0..width)
        .filter(|k| v >> k & 1 == 1)
        .map(|k| k.to_string())
        .collect();
    format!("[{}]", idx.join(","))
}

// ---------------------------------------------------------------- threshold

fn mode_threshold(nmax: usize, out: &str) {
    let mut blocks = Vec::new();
    for n in 4..=nmax {
        let m = build_model(n);
        let reps = m.pair_reps();
        // group complement pairs by alignment vector
        let mut keyed: Vec<(u128, u32)> = reps.iter().map(|&g| (m.alignment(g), g)).collect();
        keyed.sort();
        let mut groups: Vec<Vec<u32>> = Vec::new();
        let mut i = 0usize;
        while i < keyed.len() {
            let mut j = i + 1;
            while j < keyed.len() && keyed[j].0 == keyed[i].0 {
                j += 1;
            }
            if j - i > 1 {
                groups.push(keyed[i..j].iter().map(|p| p.1).collect());
            }
            i = j;
        }
        let colliding_pairs: usize = groups.iter().map(|g| g.len()).sum();
        let largest = groups.iter().map(|g| g.len()).max().unwrap_or(0);
        let describe = |g: &Vec<u32>| -> String {
            let v = m.alignment(g[0]);
            let members: Vec<String> = g
                .iter()
                .map(|&x| {
                    format!(
                        "{{\"index\":{},\"edges\":{},\"complement_index\":{}}}",
                        x,
                        json_edges(&m.edges(x)),
                        m.complement(x)
                    )
                })
                .collect();
            format!(
                "{{\"alignment_bits\":{},\"aligned_foursets\":[{}],\"members\":[{}]}}",
                json_bits(v, m.tests()),
                (0..m.tests())
                    .filter(|k| v >> k & 1 == 1)
                    .map(|k| json_fourset(&m.foursets[k]))
                    .collect::<Vec<_>>()
                    .join(","),
                members.join(",")
            )
        };
        // Two witnesses are worth separating: the degenerate collision among
        // two-graphs with no aligned four-set at all, where every test answers
        // "no", and the smallest collision whose members do have aligned
        // four-sets, which is the one that shows the failure at n = 6 is not
        // merely the empty-family artifact.
        let witness = groups.first().map(&describe);
        let empty_family_pairs = keyed.iter().filter(|(v, _)| *v == 0).count();
        let witness_nonempty = groups
            .iter()
            .find(|g| m.alignment(g[0]) != 0)
            .map(|g| describe(g));
        // how many distinct alignment vectors occur at all
        let mut seen: HashSet<u128> = HashSet::new();
        for &(v, _) in keyed.iter() {
            seen.insert(v);
        }
        blocks.push(format!(
            "{{\"n\":{},\"switching_classes\":{},\"complement_pairs\":{},\
             \"tests\":{},\"distinct_alignment_vectors\":{},\
             \"colliding_groups\":{},\"pairs_in_collisions\":{},\"largest_group\":{},\
             \"empty_family_pairs\":{},\
             \"faithful_up_to_complement\":{},\"witness\":{},\"witness_nonempty\":{}}}",
            n,
            m.class_count,
            reps.len(),
            m.tests(),
            seen.len(),
            groups.len(),
            colliding_pairs,
            largest,
            empty_family_pairs,
            if groups.is_empty() { "true" } else { "false" },
            witness.unwrap_or_else(|| "null".to_string()),
            witness_nonempty.unwrap_or_else(|| "null".to_string())
        ));
        eprintln!(
            "n={} classes={} pairs={} tests={} distinct={} colliding_groups={} largest={}",
            n,
            m.class_count,
            reps.len(),
            m.tests(),
            seen.len(),
            groups.len(),
            largest
        );
    }
    let doc = format!(
        "{{\"artifact\":\"c880-alignment-threshold\",\"schema\":1,\
         \"question\":\"does the full alignment-test family determine a two-graph up to complement\",\
         \"results\":[{}]}}\n",
        blocks.join(",")
    );
    fs::write(out, doc).expect("write output");
}

// ---------------------------------------------------------------- minimize

/// All minimal hitting sets of `cons` of size <= k, reported through `emit`.
/// `emit` returns true to stop the enumeration early.
fn enumerate_hitting_sets(
    cons: &[u128],
    chosen: u128,
    forbidden: u128,
    depth: usize,
    k: usize,
    emit: &mut dyn FnMut(u128) -> bool,
) -> bool {
    let mut unhit: Option<u128> = None;
    for &c in cons {
        if c & chosen == 0 {
            unhit = Some(c);
            break;
        }
    }
    let c = match unhit {
        None => return emit(chosen),
        Some(c) => c,
    };
    if depth == k {
        return false;
    }
    let mut avail = c & !forbidden;
    let mut forb = forbidden;
    while avail != 0 {
        let b = avail & avail.wrapping_neg();
        avail ^= b;
        if enumerate_hitting_sets(cons, chosen | b, forb, depth + 1, k, emit) {
            return true;
        }
        forb |= b;
    }
    false
}

/// If `sel` fails to separate, return the smallest-weight difference mask of a
/// colliding pair; otherwise None.
fn violated_mask(vectors: &[u128], sel: u128) -> Option<u128> {
    let mut proj: Vec<(u128, u32)> = vectors
        .iter()
        .enumerate()
        .map(|(i, &v)| (v & sel, i as u32))
        .collect();
    proj.sort_unstable();
    let mut best: Option<u128> = None;
    let mut i = 0usize;
    while i + 1 < proj.len() {
        if proj[i].0 == proj[i + 1].0 {
            let mut j = i + 1;
            while j < proj.len() && proj[j].0 == proj[i].0 {
                let d = vectors[proj[i].1 as usize] ^ vectors[proj[j].1 as usize];
                best = Some(match best {
                    None => d,
                    Some(b) if d.count_ones() < b.count_ones() => d,
                    Some(b) => b,
                });
                j += 1;
            }
            i = j;
        } else {
            i += 1;
        }
    }
    best
}

fn minimalize(mut cons: Vec<u128>) -> Vec<u128> {
    cons.sort_unstable_by_key(|c| (c.count_ones(), *c));
    cons.dedup();
    let mut out: Vec<u128> = Vec::new();
    for c in cons {
        if !out.iter().any(|&o| o & c == o) {
            out.push(c);
        }
    }
    out
}

fn mode_minimize(n: usize, seed_weight: u32, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();

    // faithfulness of the full family
    let mut sorted = vectors.clone();
    sorted.sort_unstable();
    let dup = sorted.windows(2).any(|w| w[0] == w[1]);
    eprintln!(
        "n={} pairs={} tests={} full_family_faithful={}",
        n,
        vectors.len(),
        tests,
        !dup
    );
    if dup {
        eprintln!("full family is not faithful; minimization is vacuous");
        process::exit(2);
    }

    // seed constraints: every pair-difference mask of weight <= seed_weight
    let mut seeds: HashSet<u128> = HashSet::new();
    for i in 0..vectors.len() {
        let vi = vectors[i];
        for j in (i + 1)..vectors.len() {
            let d = vi ^ vectors[j];
            if d.count_ones() <= seed_weight {
                seeds.insert(d);
            }
        }
    }
    let mut cons = minimalize(seeds.into_iter().collect());
    eprintln!(
        "seed constraints (weight <= {}): {} minimal",
        seed_weight,
        cons.len()
    );
    let min_weight = cons.iter().map(|c| c.count_ones()).min().unwrap_or(0);

    // counting lower bound: k bits must index all complement pairs
    let mut k = 1usize;
    while (1usize << k) < vectors.len() {
        k += 1;
    }
    let counting_bound = k;

    let mut solution: Option<u128> = None;
    let mut rounds = 0usize;
    let mut candidates_tested = 0usize;
    'outer: while k <= tests {
        loop {
            rounds += 1;
            let mut new_cons: Vec<u128> = Vec::new();
            let mut found: Option<u128> = None;
            let mut n_cand = 0usize;
            {
                let vectors = &vectors;
                let mut emit = |sel: u128| -> bool {
                    n_cand += 1;
                    match violated_mask(vectors, sel) {
                        None => {
                            found = Some(sel);
                            true
                        }
                        Some(d) => {
                            new_cons.push(d);
                            false
                        }
                    }
                };
                enumerate_hitting_sets(&cons, 0, 0, 0, k, &mut emit);
            }
            candidates_tested += n_cand;
            if let Some(sel) = found {
                solution = Some(sel);
                break 'outer;
            }
            if n_cand == 0 {
                eprintln!("k={}: no hitting set of this size exists", k);
                break;
            }
            let before = cons.len();
            cons.extend(new_cons);
            cons = minimalize(cons);
            eprintln!(
                "k={} round={} candidates={} constraints {} -> {}",
                k,
                rounds,
                n_cand,
                before,
                cons.len()
            );
            if cons.len() == before {
                eprintln!("no new constraints although every candidate failed; aborting");
                process::exit(3);
            }
        }
        k += 1;
    }

    let sel = solution.expect("a separating family exists");
    let nn = n as i64;
    let exhibited = 3 * nn * nn - 23 * nn + 45;
    let sel_list: Vec<String> = (0..tests)
        .filter(|t| sel >> t & 1 == 1)
        .map(|t| json_fourset(&m.foursets[t]))
        .collect();
    let doc = format!(
        "{{\"artifact\":\"c880-alignment-minimum\",\"schema\":1,\"n\":{},\
         \"switching_classes\":{},\"complement_pairs\":{},\"tests_available\":{},\
         \"full_family_faithful\":true,\"counting_lower_bound\":{},\
         \"min_pair_difference_weight\":{},\"exhibited_family_size\":{},\
         \"minimum_tests\":{},\"optimal_family\":[{}],\"optimal_family_indices\":{},\
         \"search\":{{\"seed_weight\":{},\"final_constraints\":{},\"rounds\":{},\
         \"candidates_tested\":{}}}}}\n",
        n,
        m.class_count,
        vectors.len(),
        tests,
        counting_bound,
        min_weight,
        exhibited,
        sel.count_ones(),
        sel_list.join(","),
        json_bits(sel, tests),
        seed_weight,
        cons.len(),
        rounds,
        candidates_tested
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} minimum separating alignment tests = {} (counting bound {}, exhibited {})",
        n,
        sel.count_ones(),
        counting_bound,
        exhibited
    );
}

// ---------------------------------------------------------------- census

/// Open-addressed distinctness check: do the projections of `vectors` onto the
/// coordinate set `sel` stay pairwise distinct?
struct Distinct {
    keys: Vec<u128>,
    stamps: Vec<u32>,
    shift: u32,
    gen: u32,
}

impl Distinct {
    fn new(capacity: usize) -> Distinct {
        let mut bits = 1u32;
        while (1usize << bits) < capacity * 4 {
            bits += 1;
        }
        Distinct {
            keys: vec![0u128; 1usize << bits],
            stamps: vec![0u32; 1usize << bits],
            shift: 64 - bits,
            gen: 0,
        }
    }
    fn separates(&mut self, vectors: &[u128], sel: u128) -> bool {
        self.gen += 1;
        let mask = self.keys.len() - 1;
        for &v in vectors {
            let p = v & sel;
            let folded = (p as u64) ^ ((p >> 64) as u64);
            let mut h =
                (folded.wrapping_mul(0x9E37_79B9_7F4A_7C15) >> self.shift) as usize & mask;
            loop {
                if self.stamps[h] != self.gen {
                    self.stamps[h] = self.gen;
                    self.keys[h] = p;
                    break;
                }
                if self.keys[h] == p {
                    return false;
                }
                h = (h + 1) & mask;
            }
        }
        true
    }
}

fn permutations(n: usize) -> Vec<Vec<usize>> {
    let mut out = Vec::new();
    let mut cur: Vec<usize> = (0..n).collect();
    fn rec(k: usize, cur: &mut Vec<usize>, out: &mut Vec<Vec<usize>>) {
        if k == cur.len() {
            out.push(cur.clone());
            return;
        }
        for i in k..cur.len() {
            cur.swap(k, i);
            rec(k + 1, cur, out);
            cur.swap(k, i);
        }
    }
    rec(0, &mut cur, &mut out);
    out
}

/// Exhaustive, method-independent replay of the minimum: removability of a set
/// of tests is downward closed, so every removable set of size r+1 is a
/// removable set of size r extended by one larger-indexed test.  Level-wise
/// enumeration therefore visits every removable set without any hitting-set
/// machinery.
fn mode_census(n: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();
    let full: u128 = if tests == 128 {
        u128::MAX
    } else {
        (1u128 << tests) - 1
    };
    let mut d = Distinct::new(vectors.len());
    if !d.separates(&vectors, full) {
        eprintln!("full family is not faithful; census is vacuous");
        process::exit(2);
    }

    // level-wise enumeration of removable test sets
    let mut level: Vec<u128> = vec![0u128];
    let mut levels: Vec<(usize, usize)> = vec![(0, 1)];
    let mut r = 0usize;
    let mut last_nonempty: Vec<u128> = level.clone();
    loop {
        let mut next: Vec<u128> = Vec::new();
        for &s in level.iter() {
            let start = if s == 0 {
                0
            } else {
                (127 - s.leading_zeros()) as usize + 1
            };
            for t in start..tests {
                let cand = s | (1u128 << t);
                if d.separates(&vectors, full & !cand) {
                    next.push(cand);
                }
            }
        }
        r += 1;
        levels.push((r, next.len()));
        eprintln!("removable sets of size {}: {}", r, next.len());
        if next.is_empty() {
            break;
        }
        last_nonempty = next.clone();
        level = next;
    }
    let max_removable = r - 1;
    let minimum = tests - max_removable;

    // orbit classification of the maximal removable sets under S_n
    let perms = permutations(n);
    let mut test_index = std::collections::HashMap::new();
    for (k, f) in m.foursets.iter().enumerate() {
        test_index.insert(*f, k);
    }
    let mut orbit_maps: Vec<Vec<usize>> = Vec::new();
    for p in perms.iter() {
        let mut map = vec![0usize; tests];
        for (k, f) in m.foursets.iter().enumerate() {
            let mut img = [p[f[0]], p[f[1]], p[f[2]], p[f[3]]];
            img.sort_unstable();
            map[k] = test_index[&img];
        }
        orbit_maps.push(map);
    }
    let mut canon: HashSet<u128> = HashSet::new();
    let mut orbit_sizes: std::collections::HashMap<u128, usize> = std::collections::HashMap::new();
    for &s in last_nonempty.iter() {
        let mut best = u128::MAX;
        for map in orbit_maps.iter() {
            let mut img = 0u128;
            let mut bits = s;
            while bits != 0 {
                let b = bits.trailing_zeros() as usize;
                bits &= bits - 1;
                img |= 1u128 << map[b];
            }
            if img < best {
                best = img;
            }
        }
        canon.insert(best);
        *orbit_sizes.entry(best).or_insert(0) += 1;
    }
    let mut orbits: Vec<(u128, usize)> = orbit_sizes.into_iter().collect();
    orbits.sort_unstable();
    let orbit_json: Vec<String> = orbits
        .iter()
        .map(|(rep, size)| {
            let sets: Vec<String> = (0..tests)
                .filter(|t| rep >> t & 1 == 1)
                .map(|t| json_fourset(&m.foursets[t]))
                .collect();
            format!(
                "{{\"size\":{},\"representative\":[{}]}}",
                size,
                sets.join(",")
            )
        })
        .collect();

    let example = last_nonempty[0];
    let example_list: Vec<String> = (0..tests)
        .filter(|t| example >> t & 1 == 1)
        .map(|t| json_fourset(&m.foursets[t]))
        .collect();
    let level_json: Vec<String> = levels
        .iter()
        .map(|(r, c)| format!("{{\"removed\":{},\"families\":{}}}", r, c))
        .collect();
    let nn = n as i64;
    let exhibited = 3 * nn * nn - 23 * nn + 45;
    let doc = format!(
        "{{\"artifact\":\"c880-alignment-census\",\"schema\":1,\"n\":{},\
         \"complement_pairs\":{},\"tests_available\":{},\"exhibited_family_size\":{},\
         \"max_removable\":{},\"minimum_tests\":{},\
         \"minimum_families\":{},\"minimum_families_up_to_symmetry\":{},\
         \"levels\":[{}],\"example_removed_set\":[{}],\"orbits\":[{}]}}\n",
        n,
        vectors.len(),
        tests,
        exhibited,
        max_removable,
        minimum,
        last_nonempty.len(),
        canon.len(),
        level_json.join(","),
        example_list.join(","),
        orbit_json.join(",")
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} minimum={} (max removable {}), {} optimal families in {} orbits",
        n,
        minimum,
        max_removable,
        last_nonempty.len(),
        canon.len()
    );
}

// ---------------------------------------------------------------- paper

/// The manuscript's selected query family for the anchor {0,1,2,3}: every
/// 4-subset meeting the anchor in at least two points.  Asks how much of it is
/// redundant when nothing is promised about the anchor.
fn mode_paper(n: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();
    let anchor = [0usize, 1, 2, 3];
    let anchor_test = m
        .foursets
        .iter()
        .position(|f| *f == anchor)
        .expect("anchor is a 4-subset");
    let mut family = 0u128;
    for (k, f) in m.foursets.iter().enumerate() {
        let meet = f.iter().filter(|x| anchor.contains(x)).count();
        if meet >= 2 {
            family |= 1u128 << k;
        }
    }
    let nn = n as i64;
    let exhibited = 3 * nn * nn - 23 * nn + 45;
    assert_eq!(family.count_ones() as i64, exhibited);

    let mut d = Distinct::new(vectors.len());
    let separates_full = d.separates(&vectors, family);
    let without_anchor = family & !(1u128 << anchor_test);
    let separates_without_anchor = d.separates(&vectors, without_anchor);

    // greedily strip redundant members, forwards and backwards
    let mut best_removed = 0u128;
    for reverse in [false, true] {
        let mut keep = family;
        let mut removed = 0u128;
        let order: Vec<usize> = if reverse {
            (0..tests).rev().collect()
        } else {
            (0..tests).collect()
        };
        for t in order {
            if keep >> t & 1 == 0 {
                continue;
            }
            let trial = keep & !(1u128 << t);
            if d.separates(&vectors, trial) {
                keep = trial;
                removed |= 1u128 << t;
            }
        }
        if removed.count_ones() > best_removed.count_ones() {
            best_removed = removed;
        }
    }
    let removed_list: Vec<String> = (0..tests)
        .filter(|t| best_removed >> t & 1 == 1)
        .map(|t| json_fourset(&m.foursets[t]))
        .collect();
    let doc = format!(
        "{{\"artifact\":\"c880-paper-family\",\"schema\":1,\"n\":{},\
         \"complement_pairs\":{},\"anchor\":[0,1,2,3],\"family_size\":{},\
         \"separates_unconditionally\":{},\"separates_without_anchor_test\":{},\
         \"greedy_redundant\":{},\"greedy_reduced_size\":{},\"greedy_removed\":[{}]}}\n",
        n,
        vectors.len(),
        family.count_ones(),
        separates_full,
        separates_without_anchor,
        best_removed.count_ones(),
        family.count_ones() - best_removed.count_ones(),
        removed_list.join(",")
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} paper family {} separates={} without anchor test={} greedy reduces to {}",
        n,
        family.count_ones(),
        separates_full,
        separates_without_anchor,
        family.count_ones() - best_removed.count_ones()
    );
}

// ---------------------------------------------------------------- bounds

/// Read-only open-addressed membership table for alignment vectors.
struct Table {
    keys: Vec<u128>,
    used: Vec<bool>,
    shift: u32,
}

impl Table {
    fn build(vectors: &[u128]) -> Table {
        let mut bits = 1u32;
        while (1usize << bits) < vectors.len() * 4 {
            bits += 1;
        }
        let mut t = Table {
            keys: vec![0u128; 1usize << bits],
            used: vec![false; 1usize << bits],
            shift: 64 - bits,
        };
        for &v in vectors {
            let mut h = t.slot(v);
            let mask = t.keys.len() - 1;
            loop {
                if !t.used[h] {
                    t.used[h] = true;
                    t.keys[h] = v;
                    break;
                }
                if t.keys[h] == v {
                    break;
                }
                h = (h + 1) & mask;
            }
        }
        t
    }
    #[inline]
    fn slot(&self, v: u128) -> usize {
        let folded = (v as u64) ^ ((v >> 64) as u64);
        ((folded.wrapping_mul(0x9E37_79B9_7F4A_7C15) >> self.shift) as usize) & (self.keys.len() - 1)
    }
    #[inline]
    fn contains(&self, v: u128) -> bool {
        let mask = self.keys.len() - 1;
        let mut h = self.slot(v);
        loop {
            if !self.used[h] {
                return false;
            }
            if self.keys[h] == v {
                return true;
            }
            h = (h + 1) & mask;
        }
    }
}

/// Greedy colouring bound and Tomita-style maximum clique on <= 128 vertices.
fn max_clique(adj: &[u128], nv: usize) -> (usize, u128) {
    let mut best: (usize, u128) = (0, 0);
    let all: u128 = if nv == 128 {
        u128::MAX
    } else {
        (1u128 << nv) - 1
    };
    fn expand(adj: &[u128], r: u128, p: u128, best: &mut (usize, u128)) {
        if p == 0 {
            if (r.count_ones() as usize) > best.0 {
                *best = (r.count_ones() as usize, r);
            }
            return;
        }
        // greedy colouring of p
        let mut order: Vec<usize> = Vec::new();
        let mut colors: Vec<usize> = Vec::new();
        let mut uncolored = p;
        let mut color = 0usize;
        while uncolored != 0 {
            color += 1;
            let mut avail = uncolored;
            while avail != 0 {
                let v = avail.trailing_zeros() as usize;
                let b = 1u128 << v;
                avail &= !b;
                uncolored &= !b;
                order.push(v);
                colors.push(color);
                avail &= !adj[v];
            }
        }
        let mut p = p;
        for i in (0..order.len()).rev() {
            if r.count_ones() as usize + colors[i] <= best.0 {
                return;
            }
            let v = order[i];
            let b = 1u128 << v;
            expand(adj, r | b, p & adj[v], best);
            p &= !b;
        }
    }
    expand(adj, 0, all, &mut best);
    best
}


/// All pairwise alignment-vector differences of weight at most `w`, found by
/// the pigeonhole split: two vectors at distance at most `w` agree exactly on
/// one of `w + 1` disjoint blocks of coordinates, so bucketing by each block in
/// turn sees every such pair.
fn low_weight_masks(vectors: &[u128], tests: usize, w: usize) -> (HashSet<u128>, usize, u64) {
    let blocks = w + 1;
    let mut out: HashSet<u128> = HashSet::new();
    let mut largest_bucket = 0usize;
    let mut compares: u64 = 0;
    for b in 0..blocks {
        let lo = tests * b / blocks;
        let hi = tests * (b + 1) / blocks;
        let bm: u128 = ((1u128 << (hi - lo)) - 1) << lo;
        let mut keyed: Vec<(u128, u32)> = vectors
            .iter()
            .enumerate()
            .map(|(i, &v)| (v & bm, i as u32))
            .collect();
        keyed.sort_unstable();
        let mut i = 0usize;
        while i < keyed.len() {
            let mut j = i + 1;
            while j < keyed.len() && keyed[j].0 == keyed[i].0 {
                j += 1;
            }
            largest_bucket = largest_bucket.max(j - i);
            for a in i..j {
                for c in (a + 1)..j {
                    compares += 1;
                    let d = vectors[keyed[a].1 as usize] ^ vectors[keyed[c].1 as usize];
                    if d != 0 && (d.count_ones() as usize) <= w {
                        out.insert(d);
                    }
                }
            }
            i = j;
        }
    }
    (out, largest_bucket, compares)
}

/// Largest set of tests containing no constraint mask; its complement is the
/// smallest hitting set, hence a lower bound on the minimum separating family.
/// A mask's residual shrinks only when one of its own tests is chosen, so
/// rescanning the masks through the newly chosen test keeps the forbidden set
/// exact at any mask weight.
fn max_mask_free(masks: &[u128], tests: usize, node_cap: u64) -> (usize, u128, bool) {
    let mut banned = 0u128;
    for &m in masks {
        if m.count_ones() == 1 {
            banned |= m;
        }
    }
    let mut by_vertex: Vec<Vec<u128>> = vec![Vec::new(); tests];
    for &m in masks {
        if m.count_ones() < 2 {
            continue;
        }
        let mut b = m;
        while b != 0 {
            let t = b.trailing_zeros() as usize;
            b &= b - 1;
            by_vertex[t].push(m);
        }
    }
    struct Ctx<'a> {
        tests: usize,
        by_vertex: &'a [Vec<u128>],
        best: (usize, u128),
        nodes: u64,
        cap: u64,
    }
    fn rec(ctx: &mut Ctx, chosen: u128, size: usize, forbidden: u128, next: usize) {
        ctx.nodes += 1;
        if ctx.nodes > ctx.cap {
            return;
        }
        let remaining = (next..ctx.tests).filter(|t| forbidden >> t & 1 == 0).count();
        if size + remaining <= ctx.best.0 {
            return;
        }
        if size > ctx.best.0 {
            ctx.best = (size, chosen);
        }
        for v in next..ctx.tests {
            if forbidden >> v & 1 == 1 {
                continue;
            }
            let nchosen = chosen | (1u128 << v);
            let mut nf = forbidden | (1u128 << v);
            let mut dead = false;
            for &m in ctx.by_vertex[v].iter() {
                let r = m & !nchosen;
                if r == 0 {
                    dead = true;
                    break;
                }
                if r.count_ones() == 1 {
                    nf |= r;
                }
            }
            if dead {
                continue;
            }
            rec(ctx, nchosen, size + 1, nf, v + 1);
        }
    }
    let mut ctx = Ctx {
        tests,
        by_vertex: &by_vertex,
        best: (0, 0),
        nodes: 0,
        cap: node_cap,
    };
    rec(&mut ctx, 0, 0, banned, 0);
    (ctx.best.0, ctx.best.1, ctx.nodes <= node_cap)
}

/// Lower and upper bounds on the minimum at n points.
///
/// Lower bound: a pair of two-graphs whose alignment vectors differ in exactly
/// one or two coordinates forces those coordinates to be kept, so the minimum
/// is at least the minimum hitting set of the weight-one and weight-two
/// difference masks; on the tests that the weight-one masks do not already
/// force, that is a minimum vertex cover, computed exactly.
/// Upper bound: strip the manuscript's family greedily, and separately test the
/// complement of a maximum independent set of the weight-two graph.
fn mode_bounds(n: usize, weight: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();
    eprintln!("n={} pairs={} tests={}", n, vectors.len(), tests);

    let (masks, largest_bucket, compares) = low_weight_masks(&vectors, tests, weight);
    let mut by_weight = vec![0usize; weight + 1];
    for &mk in masks.iter() {
        by_weight[mk.count_ones() as usize] += 1;
    }
    eprintln!(
        "masks of weight <= {}: {} (per weight {:?}), largest bucket {}, comparisons {}",
        weight,
        masks.len(),
        by_weight,
        largest_bucket,
        compares
    );
    let mask_vec: Vec<u128> = {
        let mut v: Vec<u128> = masks.into_iter().collect();
        v.sort_unstable();
        v
    };
    let (alpha, free_set, complete) = max_mask_free(&mask_vec, tests, 200_000_000);
    let mut counting = 1usize;
    while (1usize << counting) < vectors.len() {
        counting += 1;
    }
    // an incomplete search only underestimates the mask-free set, which would
    // overstate the bound, so it is not used
    let mask_lower = if complete { tests - alpha } else { 0 };
    let lower = mask_lower.max(counting);
    eprintln!(
        "largest mask-free set {} (search complete: {}), mask bound {}, counting bound {}, lower bound {}",
        alpha, complete, mask_lower, counting, lower
    );

    let full: u128 = if tests == 128 {
        u128::MAX
    } else {
        (1u128 << tests) - 1
    };
    let mut d = Distinct::new(vectors.len());
    let candidate = full & !free_set;
    let candidate_separates = d.separates(&vectors, candidate);

    // greedy strip of the full family under three orders
    let mut degree = vec![0u32; tests];
    for &mk in mask_vec.iter() {
        let mut b = mk;
        while b != 0 {
            let t = b.trailing_zeros() as usize;
            b &= b - 1;
            degree[t] += 1;
        }
    }
    let mut best_keep = full;
    let mut rng: u64 = 0x243F_6A88_85A3_08D3; // fixed seed keeps the search deterministic
    for pass in 0..23 {
        let mut keep = full;
        let order: Vec<usize> = match pass {
            0 => (0..tests).collect(),
            1 => (0..tests).rev().collect(),
            2 => {
                let mut o: Vec<usize> = (0..tests).collect();
                o.sort_by_key(|t| (degree[*t], *t));
                o
            }
            _ => {
                let mut o: Vec<usize> = (0..tests).collect();
                for i in (1..o.len()).rev() {
                    rng ^= rng << 13;
                    rng ^= rng >> 7;
                    rng ^= rng << 17;
                    let j = (rng % (i as u64 + 1)) as usize;
                    o.swap(i, j);
                }
                o
            }
        };
        for t in order {
            let trial = keep & !(1u128 << t);
            if d.separates(&vectors, trial) {
                keep = trial;
            }
        }
        if keep.count_ones() < best_keep.count_ones() {
            best_keep = keep;
        }
    }
    let upper = if candidate_separates {
        candidate.count_ones().min(best_keep.count_ones())
    } else {
        best_keep.count_ones()
    };
    let best_family = if candidate_separates && candidate.count_ones() <= best_keep.count_ones() {
        candidate
    } else {
        best_keep
    };
    let nn = n as i64;
    let exhibited = 3 * nn * nn - 23 * nn + 45;
    let doc = format!(
        "{{\"artifact\":\"c880-alignment-bounds\",\"schema\":1,\"n\":{},\
         \"complement_pairs\":{},\"tests_available\":{},\"exhibited_family_size\":{},\
         \"counting_lower_bound\":{},\"difference_weight_scanned\":{},\
         \"masks_by_weight\":{:?},\"largest_mask_free_set\":{},\
         \"mask_free_search_complete\":{},\"mask_lower_bound\":{},\
         \"lower_bound\":{},\"mask_free_complement_separates\":{},\
         \"greedy_upper_bound\":{},\"upper_bound\":{},\"exact\":{},\
         \"upper_bound_family\":{}}}\n",
        n,
        vectors.len(),
        tests,
        exhibited,
        counting,
        weight,
        by_weight,
        alpha,
        complete,
        mask_lower,
        lower,
        candidate_separates,
        best_keep.count_ones(),
        upper,
        lower as u32 == upper,
        json_bits(best_family, tests)
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} bounds: {} <= minimum <= {} (exhibited {})",
        n, lower, upper, exhibited
    );
}

// ---------------------------------------------------------------- family

/// A test on {p,q,x,y} is sensitive to the elementary flip of the pair {x,y}
/// exactly when tau(pxy) = tau(qxy), so the tests of a separating family that
/// contain a given pair must, on the link graph of that pair, leave no proper
/// two-colouring: the link must be non-bipartite.  This checks that necessary
/// condition, and measures anchor families of any anchor size against it.
fn bipartite(adj: &[u128], verts: &[usize]) -> bool {
    let mut color = std::collections::HashMap::new();
    for &s in verts {
        if color.contains_key(&s) {
            continue;
        }
        color.insert(s, 0u8);
        let mut stack = vec![s];
        while let Some(v) = stack.pop() {
            let cv = color[&v];
            let mut b = adj[v];
            while b != 0 {
                let w = b.trailing_zeros() as usize;
                b &= b - 1;
                match color.get(&w) {
                    None => {
                        color.insert(w, 1 - cv);
                        stack.push(w);
                    }
                    Some(&cw) => {
                        if cw == cv {
                            return false;
                        }
                    }
                }
            }
        }
    }
    true
}

fn mode_family(n: usize, anchor_size: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();

    // marginal of a single alignment test over all two-graphs
    let yes: u64 = vectors.iter().map(|v| v.count_ones() as u64).sum();
    let marginal = yes as f64 / (vectors.len() as f64 * tests as f64);
    let h = |p: f64| -p * p.log2() - (1.0 - p) * (1.0 - p).log2();
    let entropy_bound = (((m.edge_bits - 1) as f64) / h(marginal)).ceil() as usize;

    let anchor: Vec<usize> = (0..anchor_size).collect();
    let mut family = 0u128;
    for (k, f) in m.foursets.iter().enumerate() {
        if f.iter().filter(|x| anchor.contains(x)).count() >= 2 {
            family |= 1u128 << k;
        }
    }

    // links of the family: for each pair, the graph of the other two points
    let mut links_nonbipartite = true;
    let mut bipartite_pairs: Vec<String> = Vec::new();
    for x in 0..n {
        for y in (x + 1)..n {
            let others: Vec<usize> = (0..n).filter(|v| *v != x && *v != y).collect();
            let mut adj = vec![0u128; n];
            for (k, f) in m.foursets.iter().enumerate() {
                if family >> k & 1 == 0 {
                    continue;
                }
                if !f.contains(&x) || !f.contains(&y) {
                    continue;
                }
                let pq: Vec<usize> = f.iter().filter(|v| **v != x && **v != y).cloned().collect();
                adj[pq[0]] |= 1u128 << pq[1];
                adj[pq[1]] |= 1u128 << pq[0];
            }
            if bipartite(&adj, &others) {
                links_nonbipartite = false;
                bipartite_pairs.push(format!("[{},{}]", x, y));
            }
        }
    }

    let mut d = Distinct::new(vectors.len());
    let separates = d.separates(&vectors, family);
    let mut keep = family;
    for t in 0..tests {
        if keep >> t & 1 == 0 {
            continue;
        }
        let trial = keep & !(1u128 << t);
        if d.separates(&vectors, trial) {
            keep = trial;
        }
    }
    let doc = format!(
        "{{\"artifact\":\"c880-anchor-family\",\"schema\":1,\"n\":{},\"anchor_size\":{},\
         \"complement_pairs\":{},\"tests_available\":{},\"family_size\":{},\
         \"alignment_marginal\":{:.6},\"entropy_lower_bound\":{},\
         \"all_links_nonbipartite\":{},\"bipartite_link_pairs\":[{}],\
         \"separates\":{},\"greedy_reduced_size\":{}}}\n",
        n,
        anchor_size,
        vectors.len(),
        tests,
        family.count_ones(),
        marginal,
        entropy_bound,
        links_nonbipartite,
        bipartite_pairs.join(","),
        separates,
        if separates { keep.count_ones() } else { 0 }
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} anchor={} family={} links_nonbipartite={} separates={} greedy={} (marginal {:.6}, entropy bound {})",
        n,
        anchor_size,
        family.count_ones(),
        links_nonbipartite,
        separates,
        if separates { keep.count_ones() } else { 0 },
        marginal,
        entropy_bound
    );
}

// ---------------------------------------------------------------- links

/// How much of the anchor's link is really needed?  The manuscript's family
/// gives every outside pair the complete graph on the four anchor points as its
/// link.  This sweeps every subgraph R of that link: the family keeps the tests
/// meeting the anchor in three or four points, plus the tests whose anchor pair
/// lies in R, and reports which R still separate.
fn mode_links(n: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();
    let anchor = [0usize, 1, 2, 3];
    let anchor_pairs: Vec<[usize; 2]> = vec![[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]];
    let mut base = 0u128;
    let mut pair_tests = vec![0u128; 6];
    for (k, f) in m.foursets.iter().enumerate() {
        let meet: Vec<usize> = f.iter().filter(|x| anchor.contains(x)).cloned().collect();
        if meet.len() >= 3 {
            base |= 1u128 << k;
        } else if meet.len() == 2 {
            let idx = anchor_pairs
                .iter()
                .position(|p| p[0] == meet[0] && p[1] == meet[1])
                .unwrap();
            pair_tests[idx] |= 1u128 << k;
        }
    }
    let mut d = Distinct::new(vectors.len());
    let mut rows: Vec<String> = Vec::new();
    let mut best: Option<(u32, usize)> = None;
    for r in 0u32..64 {
        let mut fam = base;
        for i in 0..6 {
            if r >> i & 1 == 1 {
                fam |= pair_tests[i];
            }
        }
        // is the retained anchor link non-bipartite?
        let mut adj = vec![0u128; 4];
        for i in 0..6 {
            if r >> i & 1 == 1 {
                let p = anchor_pairs[i];
                adj[p[0]] |= 1u128 << p[1];
                adj[p[1]] |= 1u128 << p[0];
            }
        }
        let nonbip = !bipartite(&adj, &[0, 1, 2, 3]);
        let sep = d.separates(&vectors, fam);
        if sep {
            let sz = fam.count_ones();
            if best.map(|b| sz < b.0).unwrap_or(true) {
                best = Some((sz, r.count_ones() as usize));
            }
        }
        rows.push(format!(
            "{{\"link_edges\":{},\"link_nonbipartite\":{},\"family_size\":{},\"separates\":{}}}",
            r.count_ones(),
            nonbip,
            fam.count_ones(),
            sep
        ));
    }
    let doc = format!(
        "{{\"artifact\":\"c880-anchor-links\",\"schema\":1,\"n\":{},\"complement_pairs\":{},\
         \"tests_available\":{},\"anchor\":[0,1,2,3],\
         \"smallest_separating_family\":{},\"link_edges_used\":{},\"subgraphs\":[{}]}}\n",
        n,
        vectors.len(),
        tests,
        best.map(|b| b.0 as i64).unwrap_or(-1),
        best.map(|b| b.1 as i64).unwrap_or(-1),
        rows.join(",")
    );
    fs::write(out, doc).expect("write output");
    eprintln!(
        "n={} smallest separating anchor-link family: {:?}",
        n, best
    );
}

// ---------------------------------------------------------------- search

/// Iterated local search for a small separating family: greedily strip in a
/// random order, then repeatedly put a few tests back and strip again.
fn mode_search(n: usize, iters: usize, kick: usize, out: &str) {
    let m = build_model(n);
    let reps = m.pair_reps();
    let vectors: Vec<u128> = reps.iter().map(|&g| m.alignment(g)).collect();
    let tests = m.tests();
    let full: u128 = if tests == 128 {
        u128::MAX
    } else {
        (1u128 << tests) - 1
    };
    let mut d = Distinct::new(vectors.len());
    let mut rng: u64 = 0x9E37_79B9_7F4A_7C15; // fixed seed
    let mut next = move || {
        rng ^= rng << 13;
        rng ^= rng >> 7;
        rng ^= rng << 17;
        rng
    };
    let mut strip = |d: &mut Distinct, start: u128, order: &[usize]| -> u128 {
        let mut keep = start;
        for &t in order {
            if keep >> t & 1 == 0 {
                continue;
            }
            let trial = keep & !(1u128 << t);
            if d.separates(&vectors, trial) {
                keep = trial;
            }
        }
        keep
    };
    let mut order: Vec<usize> = (0..tests).collect();
    let mut best = strip(&mut d, full, &order);
    eprintln!("initial {}", best.count_ones());
    for it in 0..iters {
        for i in (1..order.len()).rev() {
            let j = (next() % (i as u64 + 1)) as usize;
            order.swap(i, j);
        }
        let mut start = best;
        for _ in 0..kick {
            let t = (next() % tests as u64) as usize;
            start |= 1u128 << t;
        }
        let cand = strip(&mut d, start, &order);
        if cand.count_ones() < best.count_ones() {
            best = cand;
            eprintln!("iteration {}: {}", it, best.count_ones());
        }
    }
    let list: Vec<String> = (0..tests)
        .filter(|t| best >> t & 1 == 1)
        .map(|t| json_fourset(&m.foursets[t]))
        .collect();
    let nn = n as i64;
    let doc = format!(
        "{{\"artifact\":\"c880-alignment-search\",\"schema\":1,\"n\":{},\"complement_pairs\":{},\
         \"tests_available\":{},\"exhibited_family_size\":{},\"iterations\":{},\"kick\":{},\
         \"best_separating_size\":{},\"best_family\":[{}]}}\n",
        n,
        vectors.len(),
        tests,
        3 * nn * nn - 23 * nn + 45,
        iters,
        kick,
        best.count_ones(),
        list.join(",")
    );
    fs::write(out, doc).expect("write output");
    eprintln!("n={} best separating family found: {}", n, best.count_ones());
}

// ---------------------------------------------------------------- driver

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("usage: c880 threshold --nmax N --out PATH");
        eprintln!("       c880 minimize --n N [--seed-weight W] --out PATH");
        process::exit(1);
    }
    let getval = |flag: &str| -> Option<String> {
        args.iter()
            .position(|a| a == flag)
            .and_then(|i| args.get(i + 1))
            .cloned()
    };
    match args[1].as_str() {
        "threshold" => {
            let nmax: usize = getval("--nmax").map(|s| s.parse().unwrap()).unwrap_or(6);
            let out = getval("--out").expect("--out");
            mode_threshold(nmax, &out);
        }
        "minimize" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(7);
            let w: u32 = getval("--seed-weight")
                .map(|s| s.parse().unwrap())
                .unwrap_or(3);
            let out = getval("--out").expect("--out");
            mode_minimize(n, w, &out);
        }
        "paper" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(7);
            let out = getval("--out").expect("--out");
            mode_paper(n, &out);
        }
        "bounds" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(8);
            let weight: usize = getval("--weight").map(|s| s.parse().unwrap()).unwrap_or(3);
            let out = getval("--out").expect("--out");
            mode_bounds(n, weight, &out);
        }
        "family" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(8);
            let a: usize = getval("--anchor").map(|s| s.parse().unwrap()).unwrap_or(3);
            let out = getval("--out").expect("--out");
            mode_family(n, a, &out);
        }
        "links" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(8);
            let out = getval("--out").expect("--out");
            mode_links(n, &out);
        }
        "search" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(8);
            let iters: usize = getval("--iters").map(|s| s.parse().unwrap()).unwrap_or(200);
            let kick: usize = getval("--kick").map(|s| s.parse().unwrap()).unwrap_or(6);
            let out = getval("--out").expect("--out");
            mode_search(n, iters, kick, &out);
        }
        "census" => {
            let n: usize = getval("--n").map(|s| s.parse().unwrap()).unwrap_or(7);
            let out = getval("--out").expect("--out");
            mode_census(n, &out);
        }
        other => {
            eprintln!("unknown mode {}", other);
            process::exit(1);
        }
    }
}
