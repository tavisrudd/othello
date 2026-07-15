// C147 --- the octad analogue of the hexad polarity-defect characterization, at q=23.
//
// HEXAD RESULT (q=11, verified): a 6-subset of the 12 conic points of PG(2,11) has
// t(H) = 60 iff it is a hexad of one of the two S(5,6,12) systems on P^1(F_11),
// where t(H) counts concurrent triples among H's chords.
//
// THE TEST HERE: same invariant, next Mathieu design. H ranges over the C(24,8) =
// 735471 8-subsets of the 24 conic points of PG(2,23) = P^1(F_23); the 759 octads of
// S(5,8,24) live on the same point set via the extended binary Golay code (QR(23)
// extended, whose automorphism group contains PSL(2,23) acting naturally on P^1(F_23)).
//
// THE NULL, declared before running: writing m_P for the number of chords of H through
// P, we have t(H) = sum_P C(m_P,3). A chord meets the conic exactly at its two
// endpoints, so m_P = 7 for P in H (contributing 8*C(7,3) = 280) and m_P = 0 for a
// conic point outside H. Hence
//        t(H) = 280 + sum_{P off conic} C(m_P,3)  >= 280,
// with equality iff no point off the conic lies on three chords of H.
//
// PREDICTION (the direct analogue): PSL(2,23) is maximal in M24, so PGL(2,23) is not a
// subgroup of M24 and its outer coset should move the Golay octad set to a second
// system, giving |{t = 280}| = 2 * 759 = 1518. Recorded so the run can refute it.
//
// Build:  rustc -O -o <out> 2026-07-14-c147-octad-q23.rs
use std::collections::HashMap;

const Q: i64 = 23;
const INF: usize = 23; // label for the point at infinity of P^1(F_23)
const NLAB: usize = 24;

fn inv(a: i64) -> i64 {
    let mut r = 1;
    let mut b = a.rem_euclid(Q);
    let mut e = Q - 2;
    while e > 0 {
        if e & 1 == 1 {
            r = r * b % Q;
        }
        b = b * b % Q;
        e >>= 1;
    }
    r
}

fn norm(x: i64, y: i64, z: i64) -> (i64, i64, i64) {
    let (x, y, z) = (x.rem_euclid(Q), y.rem_euclid(Q), z.rem_euclid(Q));
    if x != 0 {
        let iv = inv(x);
        (1, y * iv % Q, z * iv % Q)
    } else if y != 0 {
        let iv = inv(y);
        (0, 1, z * iv % Q)
    } else {
        (0, 0, 1)
    }
}

fn cross(a: (i64, i64, i64), b: (i64, i64, i64)) -> (i64, i64, i64) {
    norm(
        a.1 * b.2 - a.2 * b.1,
        a.2 * b.0 - a.0 * b.2,
        a.0 * b.1 - a.1 * b.0,
    )
}

fn dot(a: (i64, i64, i64), b: (i64, i64, i64)) -> i64 {
    (a.0 * b.0 + a.1 * b.1 + a.2 * b.2).rem_euclid(Q)
}

fn c3(m: u32) -> u64 {
    if m < 3 {
        0
    } else {
        (m as u64) * (m as u64 - 1) * (m as u64 - 2) / 6
    }
}

// ---- the extended binary Golay code, via the cyclic QR(23) code -------------------
// g(x) = x^11 + x^10 + x^6 + x^5 + x^4 + x^2 + 1, a generator of the [23,12,7] Golay
// code. Coordinates 0..22 are Z_23 (cyclic shift = x -> x+1); coordinate 23 = INF
// carries the overall parity, which is the classical labelling on which PSL(2,23) acts.
fn golay_octads() -> Vec<u32> {
    let g: u32 = (1 << 11) | (1 << 10) | (1 << 6) | (1 << 5) | (1 << 4) | (1 << 2) | 1;
    let mut octads = Vec::new();
    for msg in 0u32..4096 {
        // c(x) = m(x) * g(x) over F_2, reduced mod x^23 - 1
        let mut c: u32 = 0;
        for i in 0..12 {
            if msg >> i & 1 == 1 {
                for j in 0..12 {
                    if g >> j & 1 == 1 {
                        c ^= 1 << ((i + j) % 23);
                    }
                }
            }
        }
        let w = c.count_ones();
        // extend with the overall parity bit at INF
        let full = if w % 2 == 1 { c | (1 << INF) } else { c };
        if full.count_ones() == 8 {
            octads.push(full);
        }
    }
    octads
}

fn is_steiner_5_8_24(blocks: &[u32]) -> bool {
    // every 5-subset of the 24 points in exactly one block
    let mut cnt: HashMap<u32, u32> = HashMap::new();
    for &b in blocks {
        let pts: Vec<usize> = (0..NLAB).filter(|&i| b >> i & 1 == 1).collect();
        for a in 0..8 {
            for bb in a + 1..8 {
                for c in bb + 1..8 {
                    for d in c + 1..8 {
                        for e in d + 1..8 {
                            let m = (1u32 << pts[a])
                                | (1 << pts[bb])
                                | (1 << pts[c])
                                | (1 << pts[d])
                                | (1 << pts[e]);
                            *cnt.entry(m).or_insert(0) += 1;
                        }
                    }
                }
            }
        }
    }
    cnt.len() == 42504 && cnt.values().all(|&v| v == 1)
}

// Mobius action on labels of P^1(F_23)
fn mobius(m: (i64, i64, i64, i64), t: usize) -> usize {
    let (a, b, c, d) = m;
    if t == INF {
        return if c.rem_euclid(Q) == 0 {
            INF
        } else {
            (a * inv(c) % Q).rem_euclid(Q) as usize
        };
    }
    let t = t as i64;
    let num = (a * t + b).rem_euclid(Q);
    let den = (c * t + d).rem_euclid(Q);
    if den == 0 {
        INF
    } else {
        (num * inv(den) % Q).rem_euclid(Q) as usize
    }
}

fn apply_to_blocks(m: (i64, i64, i64, i64), blocks: &[u32]) -> Vec<u32> {
    let mut out: Vec<u32> = blocks
        .iter()
        .map(|&b| {
            let mut nb = 0u32;
            for i in 0..NLAB {
                if b >> i & 1 == 1 {
                    nb |= 1 << mobius(m, i);
                }
            }
            nb
        })
        .collect();
    out.sort_unstable();
    out
}

fn main() {
    // ---- conic points and the point index of PG(2,23) ----------------------------
    let cpt: Vec<(i64, i64, i64)> = (0..NLAB)
        .map(|t| {
            if t == INF {
                (1, 0, 0)
            } else {
                norm((t * t) as i64 % Q, t as i64, 1)
            }
        })
        .collect();

    let mut idx: HashMap<(i64, i64, i64), usize> = HashMap::new();
    let mut pts: Vec<(i64, i64, i64)> = Vec::new();
    for x in 0..Q {
        for y in 0..Q {
            for z in 0..Q {
                if x == 0 && y == 0 && z == 0 {
                    continue;
                }
                let p = norm(x, y, z);
                if !idx.contains_key(&p) {
                    idx.insert(p, pts.len());
                    pts.push(p);
                }
            }
        }
    }
    let npts = pts.len();
    assert_eq!(npts, (Q * Q + Q + 1) as usize, "PG(2,23) point count");

    let on_conic: Vec<bool> = {
        let mut v = vec![false; npts];
        for c in &cpt {
            v[idx[c]] = true;
        }
        v
    };
    assert_eq!(on_conic.iter().filter(|&&b| b).count(), NLAB);

    // ---- for each chord (pair of conic labels): the off-conic points on it --------
    let mut chord_pts: Vec<Vec<u16>> = Vec::new();
    let mut pair_id = [[usize::MAX; NLAB]; NLAB];
    for i in 0..NLAB {
        for j in i + 1..NLAB {
            let line = cross(cpt[i], cpt[j]);
            let v: Vec<u16> = (0..npts)
                .filter(|&p| !on_conic[p] && dot(pts[p], line) == 0)
                .map(|p| p as u16)
                .collect();
            assert_eq!(v.len(), (Q - 1) as usize, "a chord carries q-1 off-conic points");
            pair_id[i][j] = chord_pts.len();
            chord_pts.push(v);
        }
    }
    assert_eq!(chord_pts.len(), 276);
    println!("PG(2,23): {} points, conic {} points, {} chords, each with {} off-conic points",
             npts, NLAB, chord_pts.len(), Q - 1);

    // ---- the Golay octads --------------------------------------------------------
    let mut oct = golay_octads();
    oct.sort_unstable();
    assert_eq!(oct.len(), 759, "octad count");
    assert!(is_steiner_5_8_24(&oct), "system 1 is not S(5,8,24)");
    println!("system 1: extended QR(23) Golay -> {} octads, Steiner S(5,8,24) VERIFIED", oct.len());

    // PSL(2,23)-invariance of the labelling (the classical fact, checked not assumed)
    let qrs: Vec<i64> = (1..Q).map(|x| x * x % Q).collect();
    let is_qr = |d: i64| qrs.contains(&d.rem_euclid(Q));
    assert!(is_qr(1));
    // x -> x+1 (det 1) and x -> -1/x (det 1) generate PSL(2,23)
    for m in [(1, 1, 0, 1), (0, -1, 1, 0)] {
        assert_eq!(apply_to_blocks(m, &oct), oct, "octad set not PSL(2,23)-invariant");
    }
    println!("system 1 is PSL(2,23)-invariant (generators x+1, -1/x) -- CHECKED");

    // ---- system 2: image under an outer (non-residue determinant) map -------------
    let n = (2..Q).find(|&d| !is_qr(d)).unwrap();
    assert!(!is_qr(n));
    let g = (1, 0, 0, n); // x -> x/n, det = n, a non-residue
    let oct2 = apply_to_blocks(g, &oct);
    assert_eq!(oct2.len(), 759);
    assert!(is_steiner_5_8_24(&oct2), "system 2 is not S(5,8,24)");
    let same = oct2 == oct;
    println!("system 2: image under x -> x/{} -> 759 octads, Steiner VERIFIED; equals system 1? {}",
             n, same);
    let sys2_set: std::collections::HashSet<u32> = oct2.iter().copied().collect();
    let sys1_set: std::collections::HashSet<u32> = oct.iter().copied().collect();
    let shared = sys1_set.intersection(&sys2_set).count();
    println!("  |sys1 ∩ sys2| = {}, |sys1 ∪ sys2| = {}", shared,
             sys1_set.union(&sys2_set).count());

    // ---- the census over all C(24,8) subsets --------------------------------------
    let mut counts = vec![0u8; npts];
    let mut spectrum: HashMap<u64, u64> = HashMap::new();
    let mut min_stratum: Vec<u32> = Vec::new();
    let mut h = [0usize; 8];
    let mut total = 0u64;

    // iterate 8-subsets of 0..24 in lexicographic order
    for a in 0..NLAB {
        h[0] = a;
        for b in a + 1..NLAB {
            h[1] = b;
            for c in b + 1..NLAB {
                h[2] = c;
                for d in c + 1..NLAB {
                    h[3] = d;
                    for e in d + 1..NLAB {
                        h[4] = e;
                        for f in e + 1..NLAB {
                            h[5] = f;
                            for g2 in f + 1..NLAB {
                                h[6] = g2;
                                for i8_ in g2 + 1..NLAB {
                                    h[7] = i8_;
                                    total += 1;

                                    let mut touched: Vec<u16> = Vec::with_capacity(28 * 22);
                                    for x in 0..8 {
                                        for y in x + 1..8 {
                                            let cid = pair_id[h[x]][h[y]];
                                            for &p in &chord_pts[cid] {
                                                counts[p as usize] += 1;
                                                touched.push(p);
                                            }
                                        }
                                    }
                                    let mut t = 280u64; // the forced part, from P in H
                                    for &p in &touched {
                                        let m = counts[p as usize];
                                        if m > 0 {
                                            t += c3(m as u32);
                                            counts[p as usize] = 0; // consume once
                                        }
                                    }
                                    for &p in &touched {
                                        counts[p as usize] = 0;
                                    }
                                    *spectrum.entry(t).or_insert(0) += 1;
                                    if t == 280 {
                                        let mut mask = 0u32;
                                        for x in 0..8 {
                                            mask |= 1 << h[x];
                                        }
                                        min_stratum.push(mask);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    assert_eq!(total, 735471);

    let mut sk: Vec<_> = spectrum.iter().map(|(&k, &v)| (k, v)).collect();
    sk.sort_unstable();
    let psl = 6072u64;
    println!("\nt-spectrum over all {} 8-subsets ({} distinct values):", total, sk.len());
    for (k, v) in sk.iter() {
        let mult = if v % psl == 0 {
            format!("{} x |PSL(2,23)|", v / psl)
        } else {
            format!("{:.3} x |PSL|", *v as f64 / psl as f64)
        };
        println!("   t = {:5}  ->  {:7} subsets   ({})", k, v, mult);
    }

    let tmin = sk[0].0;
    println!("\nminimum t = {} (null predicted >= 280): {}", tmin,
             if tmin == 280 { "NULL ATTAINED" } else { "NULL NOT ATTAINED" });
    println!("|{{t = 280}}| = {}", min_stratum.len());

    min_stratum.sort_unstable();
    let strat: std::collections::HashSet<u32> = min_stratum.iter().copied().collect();
    let union: std::collections::HashSet<u32> = sys1_set.union(&sys2_set).copied().collect();
    println!("\n{{t = 280}} == system 1 ?                 {}", strat == sys1_set);
    println!("{{t = 280}} == system 1 U system 2 ?      {}", strat == union);
    println!("system 1 subset of {{t = 280}} ?          {}", sys1_set.is_subset(&strat));
    println!("octads in {{t=280}}: {} of 759", sys1_set.intersection(&strat).count());

    // ---- where DO the octads sit? the informative half of the miss ---------------
    let mut recompute = |mask: u32| -> u64 {
        let hh: Vec<usize> = (0..NLAB).filter(|&i| mask >> i & 1 == 1).collect();
        let mut touched: Vec<u16> = Vec::with_capacity(28 * 22);
        for x in 0..8 {
            for y in x + 1..8 {
                for &p in &chord_pts[pair_id[hh[x]][hh[y]]] {
                    counts[p as usize] += 1;
                    touched.push(p);
                }
            }
        }
        let mut t = 280u64;
        for &p in &touched {
            let m = counts[p as usize];
            if m > 0 {
                t += c3(m as u32);
                counts[p as usize] = 0;
            }
        }
        for &p in &touched {
            counts[p as usize] = 0;
        }
        t
    };

    let mut oct_t: HashMap<u64, u64> = HashMap::new();
    for &m in &oct {
        *oct_t.entry(recompute(m)).or_insert(0) += 1;
    }
    let mut ok: Vec<_> = oct_t.iter().map(|(&k, &v)| (k, v)).collect();
    ok.sort_unstable();
    println!("\nt on the 759 octads of system 1: {:?}", ok);

    let mut oct2_t: HashMap<u64, u64> = HashMap::new();
    for &m in &oct2 {
        *oct2_t.entry(recompute(m)).or_insert(0) += 1;
    }
    let mut ok2: Vec<_> = oct2_t.iter().map(|(&k, &v)| (k, v)).collect();
    ok2.sort_unstable();
    println!("t on the 759 octads of system 2: {:?}", ok2);
    println!("(t is PGL-invariant, so these two distributions must agree)");

    // is the octad set distinguished by t at all?
    let oct_vals: std::collections::HashSet<u64> = oct_t.keys().copied().collect();
    let pure: Vec<u64> = oct_vals
        .iter()
        .filter(|v| spectrum[v] == oct_t[v] + oct2_t.get(v).copied().unwrap_or(0))
        .copied()
        .collect();
    println!("\nt-values whose ENTIRE stratum is octads (of the two systems): {:?}", pure);
    println!("=> t {} separate the octads at q=23.",
             if pure.len() == oct_vals.len() && !pure.is_empty() { "DOES" } else { "does NOT" });

    // ---- is the octads' t-constancy a finding, or forced by transitivity? --------
    let rep = oct[0];
    let mut orb: std::collections::HashSet<u32> = std::collections::HashSet::new();
    let mut frontier = vec![rep];
    let gens: [(i64, i64, i64, i64); 2] = [(1, 1, 0, 1), (0, -1, 1, 0)];
    orb.insert(rep);
    while let Some(b) = frontier.pop() {
        for m in gens {
            let mut nb = 0u32;
            for i in 0..NLAB {
                if b >> i & 1 == 1 {
                    nb |= 1 << mobius(m, i);
                }
            }
            if orb.insert(nb) {
                frontier.push(nb);
            }
        }
    }
    println!("\nPSL(2,23)-orbit of one octad has size {} (of 759) -- transitive? {}",
             orb.len(), orb.len() == 759);
    println!("=> t constant on the octads is {} by transitivity, not an independent finding.",
             if orb.len() == 759 { "FORCED" } else { "NOT forced" });

    // ---- the extremes: 759 subsets at max t, 1518 just below. What are they? -----
    for &target in &[sk.last().unwrap().0, sk[sk.len() - 2].0] {
        let mut fam: Vec<u32> = Vec::new();
        for a in 0..NLAB {
            for b in a + 1..NLAB {
                for c in b + 1..NLAB {
                    for d in c + 1..NLAB {
                        for e in d + 1..NLAB {
                            for f in e + 1..NLAB {
                                for g2 in f + 1..NLAB {
                                    for h2 in g2 + 1..NLAB {
                                        let mask = (1u32 << a) | (1 << b) | (1 << c) | (1 << d)
                                            | (1 << e) | (1 << f) | (1 << g2) | (1 << h2);
                                        if recompute(mask) == target {
                                            fam.push(mask);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        let steiner = fam.len() == 759 && is_steiner_5_8_24(&fam);
        println!("\nstratum t = {}: {} subsets; a Steiner S(5,8,24)? {}", target, fam.len(), steiner);
        let famset: std::collections::HashSet<u32> = fam.iter().copied().collect();
        println!("   equals the Golay octads? {};  meets them in {} blocks",
                 famset == sys1_set, famset.intersection(&sys1_set).count());
    }
}
