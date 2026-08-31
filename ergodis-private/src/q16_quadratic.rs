//! Private `PG(2,16)` quadratic-avoidance replay adapter.

use std::io::Read;

use anyhow::{ensure, Context, Result};
use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use ergodis::theorem_search::{
    evolve_implications, CandidateTrial, EvolutionConfig, EvolutionResult,
};

const Q: usize = 16;
const POINT_COUNT: usize = 273;
const WORDS: usize = 5;

type Point = [u8; 3];

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct ExceptionalLeaf {
    pub ordinal: u32,
    pub rank: u8,
    pub kernel: [u8; 6],
    pub selected_zeros: u8,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct QuadraticCensus {
    pub leaves: u32,
    pub structural: u32,
    pub full_rank_fallback: u32,
    pub forced_hit: u32,
    pub exceptions: [ExceptionalLeaf; 3],
    pub exception_count: u8,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct LineOffCandidate {
    pub collinear_points: u8,
    pub off_line_rank: u8,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct QuadraticTheoremDiscovery {
    pub examples: u32,
    pub full_rank_examples: u32,
    pub trials: Box<[CandidateTrial<LineOffCandidate>]>,
    pub best_sound: CandidateTrial<LineOffCandidate>,
}

#[derive(Clone, Copy)]
struct QuadraticExample {
    uncovered: [u64; WORDS],
    full_rank: bool,
}

pub fn read_level8(mut input: impl Read) -> Result<Vec<[u16; 8]>> {
    let mut text = String::new();
    input.read_to_string(&mut text)?;
    let marker = text
        .find("def level8")
        .context("missing level8 definition")?;
    let list = text[marker..]
        .find(":= [")
        .map(|offset| marker + offset + 4)
        .context("missing level8 list")?;
    let bytes = text.as_bytes();
    let mut arcs = Vec::with_capacity(2_633);
    let mut cursor = list;
    while cursor < bytes.len() {
        if bytes[cursor] == b']' {
            break;
        }
        if bytes[cursor] != b'{' {
            cursor += 1;
            continue;
        }
        cursor += 1;
        let mut arc = [0_u16; 8];
        for (index, value) in arc.iter_mut().enumerate() {
            let start = cursor;
            while cursor < bytes.len() && bytes[cursor].is_ascii_digit() {
                cursor += 1;
            }
            ensure!(start != cursor, "missing point index in level8 row");
            *value = text[start..cursor].parse()?;
            let delimiter = if index == 7 { b'}' } else { b',' };
            ensure!(
                bytes.get(cursor) == Some(&delimiter),
                "bad level8 row delimiter"
            );
            cursor += 1;
        }
        arcs.push(arc);
    }
    ensure!(arcs.len() == 2_633, "expected 2633 level8 leaves");
    Ok(arcs)
}

pub fn analyze_quadratic_obstructions(
    arcs: &[[u16; 8]],
    threads: usize,
) -> Result<QuadraticCensus> {
    ensure!(
        (1..=12).contains(&threads),
        "thread count must be in 1..=12"
    );
    let geometry = Geometry::build();
    let census = reduce_roots(
        &QuadraticKernel {
            geometry: &geometry,
        },
        arcs,
        threads,
        QuadraticCensus::default,
        merge_census,
    )?;
    ensure!(census.leaves as usize == arcs.len(), "leaf count changed");
    Ok(census)
}

pub fn synthesize_quadratic_theorem(arcs: &[[u16; 8]]) -> Result<QuadraticTheoremDiscovery> {
    let geometry = Geometry::build();
    let examples = arcs
        .iter()
        .map(|arc| {
            let uncovered = geometry.uncovered(arc);
            let (rank, _) = quadratic_rank_kernel(&geometry.monomials, uncovered);
            QuadraticExample {
                uncovered,
                full_rank: rank == 6,
            }
        })
        .collect::<Vec<_>>();
    let EvolutionResult { trials, best_sound } = evolve_implications(
        [LineOffCandidate {
            collinear_points: 1,
            off_line_rank: 1,
        }],
        &examples,
        EvolutionConfig {
            generations: 8,
            beam_width: 8,
            max_candidates: 64,
        },
        |candidate, output| {
            if candidate.collinear_points < 5 {
                output.push(LineOffCandidate {
                    collinear_points: candidate.collinear_points + 1,
                    ..*candidate
                });
            }
            if candidate.off_line_rank < 3 {
                output.push(LineOffCandidate {
                    off_line_rank: candidate.off_line_rank + 1,
                    ..*candidate
                });
            }
        },
        |candidate, example| geometry.matches_line_off(example.uncovered, *candidate),
        |example| example.full_rank,
        |candidate| u32::from(candidate.collinear_points + candidate.off_line_rank),
    )?;
    let best_sound = best_sound.context("theorem evolution found no sound candidate")?;
    Ok(QuadraticTheoremDiscovery {
        examples: examples.len() as u32,
        full_rank_examples: examples.iter().filter(|example| example.full_rank).count() as u32,
        trials,
        best_sound,
    })
}

fn merge_census(mut left: QuadraticCensus, right: QuadraticCensus) -> QuadraticCensus {
    left.leaves += right.leaves;
    left.structural += right.structural;
    left.full_rank_fallback += right.full_rank_fallback;
    left.forced_hit += right.forced_hit;
    for index in 0..right.exception_count as usize {
        left.exceptions[left.exception_count as usize] = right.exceptions[index];
        left.exception_count += 1;
    }
    left
}

struct Geometry {
    points: Box<[Point]>,
    line_masks: Box<[[u64; WORDS]]>,
    line_by_key: Box<[u16]>,
    monomials: Box<[[u8; 6]]>,
}

impl Geometry {
    fn build() -> Self {
        let mut points = Vec::with_capacity(POINT_COUNT);
        points.push([0, 0, 1]);
        for z in 0..Q as u8 {
            points.push([0, 1, z]);
        }
        for y in 0..Q as u8 {
            for z in 0..Q as u8 {
                points.push([1, y, z]);
            }
        }
        let mut line_by_key = vec![u16::MAX; Q * Q * Q];
        for (index, &point) in points.iter().enumerate() {
            line_by_key[point_key(point)] = index as u16;
        }
        let mut line_masks = Vec::with_capacity(POINT_COUNT);
        for &line in &points {
            let mut mask = [0_u64; WORDS];
            for (index, &point) in points.iter().enumerate() {
                if dot(line, point) == 0 {
                    mask[index / 64] |= 1_u64 << (index % 64);
                }
            }
            line_masks.push(mask);
        }
        let monomials = points.iter().copied().map(monomial).collect::<Vec<_>>();
        Self {
            points: points.into_boxed_slice(),
            line_masks: line_masks.into_boxed_slice(),
            line_by_key: line_by_key.into_boxed_slice(),
            monomials: monomials.into_boxed_slice(),
        }
    }

    #[inline]
    fn join(&self, left: u16, right: u16) -> usize {
        self.line_by_key[point_key(normalize(cross(
            self.points[left as usize],
            self.points[right as usize],
        )))] as usize
    }

    fn uncovered(&self, arc: &[u16; 8]) -> [u64; WORDS] {
        let mut covered = [0_u64; WORDS];
        for left in 0..arc.len() {
            for right in left + 1..arc.len() {
                let line = self.join(arc[left], arc[right]);
                for (covered_word, line_word) in covered.iter_mut().zip(&self.line_masks[line]) {
                    *covered_word |= line_word;
                }
            }
        }
        let mut uncovered = covered.map(|word| !word);
        uncovered[WORDS - 1] &= (1_u64 << (POINT_COUNT - 64 * (WORDS - 1))) - 1;
        uncovered
    }

    fn has_six_point_obstruction(&self, uncovered: [u64; WORDS]) -> bool {
        for line in 0..POINT_COUNT {
            if intersection_count(uncovered, self.line_masks[line]) < 3 {
                continue;
            }
            let off_line = and_not(uncovered, self.line_masks[line]);
            let Some(first) = first_set(off_line) else {
                continue;
            };
            let mut remaining = off_line;
            remaining[first as usize / 64] &= !(1_u64 << (first as usize % 64));
            let Some(second) = first_set(remaining) else {
                continue;
            };
            let joining_line = self.join(first, second);
            if any(and_not(remaining, self.line_masks[joining_line])) {
                return true;
            }
        }
        false
    }

    fn matches_line_off(&self, uncovered: [u64; WORDS], candidate: LineOffCandidate) -> bool {
        for line in 0..POINT_COUNT {
            if intersection_count(uncovered, self.line_masks[line])
                < u32::from(candidate.collinear_points)
            {
                continue;
            }
            if self.off_line_rank(and_not(uncovered, self.line_masks[line]))
                >= candidate.off_line_rank
            {
                return true;
            }
        }
        false
    }

    fn off_line_rank(&self, points: [u64; WORDS]) -> u8 {
        let Some(first) = first_set(points) else {
            return 0;
        };
        let mut remaining = points;
        remaining[first as usize / 64] &= !(1_u64 << (first as usize % 64));
        let Some(second) = first_set(remaining) else {
            return 1;
        };
        let joining_line = self.join(first, second);
        if any(and_not(remaining, self.line_masks[joining_line])) {
            3
        } else {
            2
        }
    }
}

struct QuadraticKernel<'a> {
    geometry: &'a Geometry,
}

impl RootKernel for QuadraticKernel<'_> {
    type Root = [u16; 8];
    type Worker = ();
    type Output = QuadraticCensus;

    fn create_worker(&self) -> Self::Worker {}

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        ordinal: RootOrdinal,
        arc: &Self::Root,
    ) -> Self::Output {
        let uncovered = self.geometry.uncovered(arc);
        if self.geometry.has_six_point_obstruction(uncovered) {
            return QuadraticCensus {
                leaves: 1,
                structural: 1,
                ..QuadraticCensus::default()
            };
        }

        let (rank, kernel) = quadratic_rank_kernel(&self.geometry.monomials, uncovered);
        if rank == 6 {
            return QuadraticCensus {
                leaves: 1,
                full_rank_fallback: 1,
                ..QuadraticCensus::default()
            };
        }
        let selected_zeros = arc
            .iter()
            .filter(|&&point| dot6(self.geometry.monomials[point as usize], kernel) == 0)
            .count() as u8;
        QuadraticCensus {
            leaves: 1,
            forced_hit: u32::from(selected_zeros != 0),
            exceptions: [
                ExceptionalLeaf {
                    ordinal: ordinal.0,
                    rank,
                    kernel,
                    selected_zeros,
                },
                ExceptionalLeaf::default(),
                ExceptionalLeaf::default(),
            ],
            exception_count: 1,
            ..QuadraticCensus::default()
        }
    }
}

fn quadratic_rank_kernel(monomials: &[[u8; 6]], points: [u64; WORDS]) -> (u8, [u8; 6]) {
    let mut basis = [[0_u8; 6]; 6];
    let mut rank = 0_u8;
    for point in SetBits::new(points) {
        let mut row = monomials[point as usize];
        for pivot in 0..6 {
            if row[pivot] == 0 {
                continue;
            }
            if basis[pivot][pivot] != 0 {
                let factor = row[pivot];
                add_scaled(&mut row, basis[pivot], factor);
                continue;
            }
            let inverse = inv16(row[pivot]);
            for value in &mut row {
                *value = mul16(*value, inverse);
            }
            for old in &mut basis {
                if old[pivot] != 0 {
                    let factor = old[pivot];
                    add_scaled(old, row, factor);
                }
            }
            basis[pivot] = row;
            rank += 1;
            break;
        }
    }
    let mut kernel = [0_u8; 6];
    if rank == 5 {
        let free = (0..6).find(|&column| basis[column][column] == 0).unwrap();
        kernel[free] = 1;
        for pivot in 0..6 {
            if basis[pivot][pivot] != 0 {
                kernel[pivot] = basis[pivot][free];
            }
        }
    }
    (rank, kernel)
}

#[inline]
fn add_scaled(row: &mut [u8; 6], source: [u8; 6], factor: u8) {
    for column in 0..6 {
        row[column] ^= mul16(source[column], factor);
    }
}

#[inline]
fn mul16(mut left: u8, mut right: u8) -> u8 {
    let mut product = 0_u8;
    while right != 0 {
        product ^= left & (0_u8.wrapping_sub(right & 1));
        right >>= 1;
        left <<= 1;
        if left & 16 != 0 {
            left ^= 0x13;
        }
    }
    product
}

#[inline]
fn inv16(value: u8) -> u8 {
    let mut power = value;
    let mut inverse = 1_u8;
    let mut exponent = 14_u8;
    while exponent != 0 {
        if exponent & 1 != 0 {
            inverse = mul16(inverse, power);
        }
        power = mul16(power, power);
        exponent >>= 1;
    }
    inverse
}

#[inline]
fn normalize(mut point: Point) -> Point {
    let pivot = point.iter().position(|&value| value != 0).unwrap();
    let inverse = inv16(point[pivot]);
    for value in &mut point {
        *value = mul16(*value, inverse);
    }
    point
}

#[inline]
fn point_key(point: Point) -> usize {
    point[0] as usize * Q * Q + point[1] as usize * Q + point[2] as usize
}

#[inline]
fn cross(left: Point, right: Point) -> Point {
    [
        mul16(left[1], right[2]) ^ mul16(left[2], right[1]),
        mul16(left[2], right[0]) ^ mul16(left[0], right[2]),
        mul16(left[0], right[1]) ^ mul16(left[1], right[0]),
    ]
}

#[inline]
fn dot(left: Point, right: Point) -> u8 {
    mul16(left[0], right[0]) ^ mul16(left[1], right[1]) ^ mul16(left[2], right[2])
}

#[inline]
fn monomial(point: Point) -> [u8; 6] {
    [
        mul16(point[0], point[0]),
        mul16(point[1], point[1]),
        mul16(point[2], point[2]),
        mul16(point[0], point[1]),
        mul16(point[0], point[2]),
        mul16(point[1], point[2]),
    ]
}

#[inline]
fn dot6(left: [u8; 6], right: [u8; 6]) -> u8 {
    let mut result = 0_u8;
    for index in 0..6 {
        result ^= mul16(left[index], right[index]);
    }
    result
}

#[inline]
fn intersection_count(left: [u64; WORDS], right: [u64; WORDS]) -> u32 {
    (0..WORDS)
        .map(|word| (left[word] & right[word]).count_ones())
        .sum()
}

#[inline]
fn and_not(left: [u64; WORDS], right: [u64; WORDS]) -> [u64; WORDS] {
    std::array::from_fn(|word| left[word] & !right[word])
}

#[inline]
fn any(words: [u64; WORDS]) -> bool {
    words.iter().any(|&word| word != 0)
}

#[inline]
fn first_set(words: [u64; WORDS]) -> Option<u16> {
    words
        .iter()
        .position(|&word| word != 0)
        .map(|index| (64 * index + words[index].trailing_zeros() as usize) as u16)
}

struct SetBits {
    words: [u64; WORDS],
    word: usize,
}

impl SetBits {
    fn new(words: [u64; WORDS]) -> Self {
        Self { words, word: 0 }
    }
}

impl Iterator for SetBits {
    type Item = u16;

    fn next(&mut self) -> Option<Self::Item> {
        while self.word < WORDS {
            if self.words[self.word] != 0 {
                let bit = self.words[self.word].trailing_zeros() as usize;
                self.words[self.word] &= self.words[self.word] - 1;
                return Some((64 * self.word + bit) as u16);
            }
            self.word += 1;
        }
        None
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn field_and_theorem_paths_match_known_leaves() {
        for value in 1..16 {
            assert_eq!(mul16(value, inv16(value)), 1);
        }
        let geometry = Geometry::build();
        assert!(geometry
            .has_six_point_obstruction(geometry.uncovered(&[0, 1, 17, 34, 52, 67, 89, 106])));

        let kernel = QuadraticKernel {
            geometry: &geometry,
        };
        for (ordinal, arc, expected_kernel, expected_zeros) in [
            (89, [0, 1, 17, 34, 52, 67, 159, 205], [1, 1, 1, 1, 1, 0], 2),
            (90, [0, 1, 17, 34, 52, 69, 86, 99], [0, 0, 0, 5, 4, 1], 7),
            (
                2631,
                [0, 1, 17, 34, 54, 99, 125, 200],
                [2, 1, 1, 5, 5, 1],
                2,
            ),
        ] {
            let result = kernel.evaluate(&mut (), RootOrdinal(ordinal), &arc);
            assert_eq!(result.forced_hit, 1);
            assert_eq!(result.exception_count, 1);
            assert_eq!(result.exceptions[0].kernel, expected_kernel);
            assert_eq!(result.exceptions[0].selected_zeros, expected_zeros);
        }
    }
}
