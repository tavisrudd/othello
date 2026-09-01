use serde::Deserialize;
use std::fs::File;
use std::io::{self, BufReader, Read};
use std::path::Path;
use std::time::Instant;

#[derive(Deserialize)]
struct Instance {
    coordinate_count: usize,
    physical_checks: Vec<Vec<usize>>,
    logical_observations: Vec<Vec<usize>>,
}

struct TannerGraph {
    bits: usize,
    checks: usize,
    row_offsets: Vec<usize>,
    edge_bits: Vec<usize>,
    edge_checks: Vec<usize>,
    col_offsets: Vec<usize>,
    col_edges: Vec<usize>,
}

impl TannerGraph {
    fn from_rows(bits: usize, rows: impl Iterator<Item = Vec<usize>>) -> Self {
        let rows: Vec<Vec<usize>> = rows.collect();
        let checks = rows.len();
        let edge_count: usize = rows.iter().map(Vec::len).sum();
        let mut row_offsets = Vec::with_capacity(checks + 1);
        let mut edge_bits = Vec::with_capacity(edge_count);
        let mut edge_checks = Vec::with_capacity(edge_count);
        let mut degrees = vec![0usize; bits];
        row_offsets.push(0);
        for (check, row) in rows.iter().enumerate() {
            for &bit in row {
                assert!(bit < bits, "column index out of range");
                edge_bits.push(bit);
                edge_checks.push(check);
                degrees[bit] += 1;
            }
            row_offsets.push(edge_bits.len());
        }

        let mut col_offsets = Vec::with_capacity(bits + 1);
        col_offsets.push(0);
        for degree in degrees {
            col_offsets.push(col_offsets.last().copied().unwrap() + degree);
        }
        let mut col_edges = vec![0usize; edge_count];
        let mut cursors = col_offsets[..bits].to_vec();
        for (edge, &bit) in edge_bits.iter().enumerate() {
            col_edges[cursors[bit]] = edge;
            cursors[bit] += 1;
        }
        Self {
            bits,
            checks,
            row_offsets,
            edge_bits,
            edge_checks,
            col_offsets,
            col_edges,
        }
    }
}

#[repr(C, align(64))]
struct MinSum {
    v2c: Vec<f64>,
    c2v: Vec<f64>,
    posterior: Vec<f64>,
    hard: Vec<u8>,
    observed: Vec<u8>,
}

#[repr(C, align(64))]
struct Osd0 {
    rows: Vec<u64>,
    template: Vec<u64>,
    order: Vec<usize>,
    pivot_columns: Vec<usize>,
    candidate: Vec<u8>,
    words: usize,
}

impl Osd0 {
    fn new(graph: &TannerGraph) -> Self {
        let words = (graph.bits + 1).div_ceil(64);
        let mut template = vec![0u64; graph.checks * words];
        for edge in 0..graph.edge_bits.len() {
            let check = graph.edge_checks[edge];
            let bit = graph.edge_bits[edge];
            template[check * words + bit / 64] ^= 1u64 << (bit % 64);
        }
        Self {
            rows: template.clone(),
            template,
            order: (0..graph.bits).collect(),
            pivot_columns: vec![0; graph.checks],
            candidate: vec![0; graph.bits],
            words,
        }
    }

    fn solve(&mut self, graph: &TannerGraph, syndrome: &[u8], posterior: &[f64]) -> bool {
        self.rows.copy_from_slice(&self.template);
        self.candidate.fill(0);
        for (check, &value) in syndrome.iter().enumerate() {
            self.rows[check * self.words + graph.bits / 64] |=
                u64::from(value) << (graph.bits % 64);
        }
        self.order.sort_unstable_by(|&left, &right| {
            posterior[left]
                .total_cmp(&posterior[right])
                .then_with(|| left.cmp(&right))
        });

        let mut rank = 0usize;
        for &column in &self.order {
            let word = column / 64;
            let mask = 1u64 << (column % 64);
            let Some(pivot) =
                (rank..graph.checks).find(|&row| self.rows[row * self.words + word] & mask != 0)
            else {
                continue;
            };
            if pivot != rank {
                let (left, right) = self.rows.split_at_mut(pivot * self.words);
                left[rank * self.words..(rank + 1) * self.words]
                    .swap_with_slice(&mut right[..self.words]);
            }
            for row in 0..graph.checks {
                if row == rank || self.rows[row * self.words + word] & mask == 0 {
                    continue;
                }
                for offset in 0..self.words {
                    self.rows[row * self.words + offset] ^= self.rows[rank * self.words + offset];
                }
            }
            self.pivot_columns[rank] = column;
            rank += 1;
            if rank == graph.checks {
                break;
            }
        }

        let rhs_word = graph.bits / 64;
        let rhs_mask = 1u64 << (graph.bits % 64);
        for row in rank..graph.checks {
            if self.rows[row * self.words + rhs_word] & rhs_mask != 0 {
                return false;
            }
        }
        for row in 0..rank {
            self.candidate[self.pivot_columns[row]] =
                u8::from(self.rows[row * self.words + rhs_word] & rhs_mask != 0);
        }
        true
    }
}

impl MinSum {
    fn new(graph: &TannerGraph) -> Self {
        let edges = graph.edge_bits.len();
        Self {
            v2c: vec![0.0; edges],
            c2v: vec![0.0; edges],
            posterior: vec![0.0; graph.bits],
            hard: vec![0; graph.bits],
            observed: vec![0; graph.checks],
        }
    }

    fn decode(
        &mut self,
        graph: &TannerGraph,
        syndrome: &[u8],
        channel_llr: f64,
        scale: f64,
        max_iterations: usize,
    ) -> usize {
        self.v2c.fill(channel_llr);
        self.c2v.fill(0.0);
        self.hard.fill(0);

        for iteration in 1..=max_iterations {
            for (check, window) in graph.row_offsets.windows(2).enumerate() {
                let start = window[0];
                let end = window[1];
                let mut sign = syndrome[check] != 0;
                let mut minimum = f64::INFINITY;
                let mut second = f64::INFINITY;
                let mut minimum_edge = usize::MAX;
                for edge in start..end {
                    let message = self.v2c[edge];
                    sign ^= message <= 0.0;
                    let magnitude = message.abs();
                    if magnitude < minimum {
                        second = minimum;
                        minimum = magnitude;
                        minimum_edge = edge;
                    } else if magnitude < second {
                        second = magnitude;
                    }
                }
                for edge in start..end {
                    let magnitude = if edge == minimum_edge {
                        second
                    } else {
                        minimum
                    } * scale;
                    let negative = sign ^ (self.v2c[edge] <= 0.0);
                    self.c2v[edge] = if negative { -magnitude } else { magnitude };
                }
            }

            self.observed.fill(0);
            for bit in 0..graph.bits {
                let mut llr = channel_llr;
                let start = graph.col_offsets[bit];
                let end = graph.col_offsets[bit + 1];
                for slot in start..end {
                    llr += self.c2v[graph.col_edges[slot]];
                }
                self.posterior[bit] = llr;
                self.hard[bit] = u8::from(llr <= 0.0);
                if llr <= 0.0 {
                    for slot in start..end {
                        let edge = graph.col_edges[slot];
                        self.observed[graph.edge_checks[edge]] ^= 1;
                    }
                }
                for slot in start..end {
                    let edge = graph.col_edges[slot];
                    self.v2c[edge] = llr - self.c2v[edge];
                }
            }

            if self.observed == syndrome {
                return iteration;
            }
        }
        0
    }

    fn satisfies(&mut self, graph: &TannerGraph, syndrome: &[u8]) -> bool {
        self.observed.fill(0);
        for bit in 0..graph.bits {
            if self.hard[bit] == 0 {
                continue;
            }
            for slot in graph.col_offsets[bit]..graph.col_offsets[bit + 1] {
                let edge = graph.col_edges[slot];
                self.observed[graph.edge_checks[edge]] ^= 1;
            }
        }
        self.observed == syndrome
    }
}

fn read_targets(path: &Path, limit: usize) -> io::Result<Vec<u64>> {
    let mut reader = BufReader::new(File::open(path)?);
    let mut header = [0u8; 16];
    reader.read_exact(&mut header)?;
    assert_eq!(&header[..8], b"EGBPORD1");
    let bits = usize::from(u16::from_le_bytes([header[8], header[9]]));
    let encoded = usize::try_from(u32::from_le_bytes(header[12..16].try_into().unwrap())).unwrap();
    let count = encoded.min(limit);
    let mut targets = Vec::with_capacity(count);
    let mut target = [0u8; 8];
    let mut skipped_order = vec![0u8; bits * 2];
    for _ in 0..count {
        reader.read_exact(&mut target)?;
        targets.push(u64::from_le_bytes(target));
        reader.read_exact(&mut skipped_order)?;
    }
    Ok(targets)
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args = std::env::args_os().skip(1);
    let input = args
        .next()
        .expect("usage: c985-native-bp INPUT TARGETS [TRIALS] [ITERATIONS]");
    let targets_path = args.next().expect("missing targets file");
    let trials = args
        .next()
        .map(|v| v.to_string_lossy().parse())
        .transpose()?
        .unwrap_or(2048);
    let iterations = args
        .next()
        .map(|v| v.to_string_lossy().parse())
        .transpose()?
        .unwrap_or(300);
    let run_osd0 = args.next().is_some_and(|value| value == "osd0");
    let instance: Instance = serde_json::from_reader(BufReader::new(File::open(input)?))?;
    assert!(instance.logical_observations.len() <= 64);
    let physical_count = instance.physical_checks.len();
    let logical_count = instance.logical_observations.len();
    let graph = TannerGraph::from_rows(
        instance.coordinate_count,
        instance
            .physical_checks
            .into_iter()
            .chain(instance.logical_observations),
    );
    let targets = read_targets(Path::new(&targets_path), trials)?;
    let mut syndrome = vec![0u8; graph.checks];
    let mut decoder = MinSum::new(&graph);
    let mut osd0 = Osd0::new(&graph);
    let channel_llr = ((1.0f64 - 0.002) / 0.002).ln();
    let start = Instant::now();
    let mut converged = 0usize;
    let mut iterations_total = 0usize;
    let mut best_weight = graph.bits + 1;
    let mut osd0_solved = 0usize;
    let mut osd0_best_weight = graph.bits + 1;
    for target in targets.iter().copied() {
        syndrome.fill(0);
        for bit in 0..logical_count {
            syndrome[physical_count + bit] = ((target >> bit) & 1) as u8;
        }
        let used = decoder.decode(&graph, &syndrome, channel_llr, 0.625, iterations);
        if used != 0 {
            assert!(decoder.satisfies(&graph, &syndrome));
            converged += 1;
            iterations_total += used;
            best_weight = best_weight.min(decoder.hard.iter().map(|&v| usize::from(v)).sum());
        }
        if run_osd0 && osd0.solve(&graph, &syndrome, &decoder.posterior) {
            decoder.hard.copy_from_slice(&osd0.candidate);
            assert!(decoder.satisfies(&graph, &syndrome));
            osd0_solved += 1;
            osd0_best_weight =
                osd0_best_weight.min(osd0.candidate.iter().map(|&value| usize::from(value)).sum());
        }
    }
    let elapsed = start.elapsed();
    decoder.satisfies(&graph, &syndrome);
    let residual_weight = decoder
        .observed
        .iter()
        .zip(&syndrome)
        .filter(|(left, right)| left != right)
        .count();
    let hard_weight: usize = decoder.hard.iter().map(|&v| usize::from(v)).sum();
    let posterior_min = decoder
        .posterior
        .iter()
        .copied()
        .fold(f64::INFINITY, f64::min);
    let posterior_max = decoder
        .posterior
        .iter()
        .copied()
        .fold(f64::NEG_INFINITY, f64::max);
    let posterior_sum: f64 = decoder.posterior.iter().sum();
    println!(
        "{{\"schema\":\"c985-native-bp-spike-v1\",\"trials\":{},\"converged\":{},\"iterations_total\":{},\"best_weight\":{},\"osd0_solved\":{},\"osd0_best_weight\":{},\"elapsed_ns\":{},\"edges\":{},\"last_hard_weight\":{},\"last_residual_weight\":{},\"last_posterior_min\":{},\"last_posterior_max\":{},\"last_posterior_sum\":{}}}",
        targets.len(),
        converged,
        iterations_total,
        best_weight,
        osd0_solved,
        osd0_best_weight,
        elapsed.as_nanos(),
        graph.edge_bits.len(),
        hard_weight,
        residual_weight,
        posterior_min,
        posterior_max,
        posterior_sum
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn decodes_single_parity_check_without_allocation_after_setup() {
        let graph = TannerGraph::from_rows(3, [vec![0, 1], vec![1, 2]].into_iter());
        let mut decoder = MinSum::new(&graph);
        let used = decoder.decode(&graph, &[1, 0], 2.0, 0.625, 8);
        assert!(used > 0);
        assert!(decoder.satisfies(&graph, &[1, 0]));
        assert_eq!(decoder.hard.iter().copied().sum::<u8>(), 1);
    }
}
