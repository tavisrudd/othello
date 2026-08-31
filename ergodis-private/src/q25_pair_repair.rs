//! Private `PG(2,25)` Frobenius-pair repair adapter.
//!
//! Domain geometry stays private.  The response quotient is compiled by the
//! public Ergodis observational engine.

use std::io::{Read, Write};

use anyhow::{ensure, Context, Result};
use ergodis::observational::{
    compile_observational_with_policy, verify_compilation, CertificatePolicy, CompiledObservation,
    FinitePresentation, GeneratorSpec,
};
use ergodis::root_execution::{reduce_roots, RootKernel, RootOrdinal};
use ergodis::theorem_search::{
    evolve_implications, CandidateTrial, EvolutionConfig, EvolutionResult,
};

const FIELD_ORDER: usize = 25;
const POINT_COUNT: usize = 651;
const ORBIT_COUNT: usize = 310;
const NO_POINT: u16 = u16::MAX;
const CERTIFICATE_MAGIC: [u8; 8] = *b"ERGQ2501";
const MINIMUM_CERTIFICATE_MAGIC: [u8; 8] = *b"ERGQ25M1";

type Point = [u8; 3];

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum RowOutcome {
    Obstruction([u8; 3]),
    Legal {
        first_witness: u16,
        second_witness: u16,
    },
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct RowRecord {
    pub second_orbit: u16,
    pub third_orbit: u16,
    pub outcome: RowOutcome,
}

#[derive(Debug)]
pub struct Q25Census {
    pub records: Box<[RowRecord]>,
    legal_masks: Box<[[u64; 5]]>,
    record_to_legal: Box<[u32]>,
    pub response_classes: u32,
    presentation: FinitePresentation,
    compilation: CompiledObservation,
}

#[derive(Clone, Copy, Debug)]
struct RootRange {
    start: u16,
    end: u16,
}

#[derive(Clone, Debug)]
struct GeneratedRow {
    record: RowRecord,
    legal_mask: Option<[u64; 5]>,
}

#[derive(Clone, Copy, Debug)]
enum MinimumEvidenceRow {
    Obstruction([u8; 3]),
    LegalMask([u64; 5]),
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub struct MinimumCertificateSummary {
    pub rows: u32,
    pub legal_rows: u32,
    pub minimum_legal_count: u32,
    pub maximum_legal_count: u32,
    pub minimum_rows: u32,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord)]
pub struct ResidualOrbitClass {
    pub representative: [u16; 3],
    pub orbit_size: u16,
    pub stabilizer_order: u16,
    pub slice_rows: u16,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct StabilizerPatternDiscovery {
    pub matrices: u32,
    pub members: u32,
    pub universal_literals: u32,
    pub trials: Box<[CandidateTrial<u32>]>,
    pub best_sound: CandidateTrial<u32>,
}

#[derive(Clone, Copy)]
struct MatrixExample {
    literals: u32,
    member: bool,
}

impl Q25Census {
    pub fn obstruction_count(&self) -> usize {
        self.records
            .iter()
            .filter(|record| matches!(record.outcome, RowOutcome::Obstruction(_)))
            .count()
    }

    pub fn legal_count(&self) -> usize {
        self.legal_masks.len()
    }

    pub fn certificate_bytes(&self) -> usize {
        self.compilation.storage().certificate_bytes
    }

    pub fn quotient_bytes(&self) -> usize {
        self.compilation.storage().quotient_bytes
    }

    pub fn verify_compilation(&self) -> Result<()> {
        verify_compilation(&self.presentation, &self.compilation)?;
        Ok(())
    }
}

pub fn classify_minimum_residual_orbits(census: &Q25Census) -> Vec<ResidualOrbitClass> {
    let geometry = Geometry::build();
    let action = geometry.residual_action();
    let first = geometry.orbit_by_number[5];
    let mut representatives = Vec::with_capacity(5);

    for (index, record) in census.records.iter().enumerate() {
        let legal = census.record_to_legal[index];
        if legal == u32::MAX
            || census.legal_masks[legal as usize]
                .iter()
                .map(|word| word.count_ones())
                .sum::<u32>()
                != 32
        {
            continue;
        }
        let triple = [
            first,
            geometry.orbit_by_number[record.second_orbit as usize],
            geometry.orbit_by_number[record.third_orbit as usize],
        ];
        let representative = canonical_triple(triple, &action);
        if let Some(class) = representatives
            .iter_mut()
            .find(|class: &&mut ResidualOrbitClass| class.representative == representative)
        {
            class.slice_rows += 1;
        } else {
            let orbit_size = triple_orbit_size(representative, &action);
            representatives.push(ResidualOrbitClass {
                representative,
                orbit_size,
                stabilizer_order: 400 / orbit_size,
                slice_rows: 1,
            });
        }
    }
    representatives.sort_unstable();
    representatives
}

pub fn synthesize_residual_stabilizer_pattern() -> Result<StabilizerPatternDiscovery> {
    let mut examples = Vec::with_capacity(5_usize.pow(9));
    let mut universal_literals = (1_u32 << 27) - 1;
    let mut members = 0_u32;
    for code in 0..5_usize.pow(9) {
        let matrix = decode_matrix(code);
        let literals = matrix_literal_mask(matrix);
        let member = semantic_residual_member(matrix);
        if member {
            universal_literals &= literals;
            members += 1;
        }
        examples.push(MatrixExample { literals, member });
    }
    let EvolutionResult { trials, best_sound } = evolve_implications(
        [0_u32],
        &examples,
        EvolutionConfig {
            generations: 10,
            beam_width: 32,
            max_candidates: 256,
        },
        |candidate, output| {
            let mut available = universal_literals & !candidate;
            while available != 0 {
                let bit = available.trailing_zeros();
                output.push(*candidate | (1_u32 << bit));
                available &= available - 1;
            }
        },
        |candidate, example| example.literals & candidate == *candidate,
        |example| example.member,
        |candidate| candidate.count_ones(),
    )?;
    let best_sound = best_sound.context("matrix evolution found no exact stabilizer rule")?;
    Ok(StabilizerPatternDiscovery {
        matrices: examples.len() as u32,
        members,
        universal_literals,
        trials,
        best_sound,
    })
}

pub fn format_matrix_pattern(pattern: u32) -> String {
    let mut parts = Vec::new();
    for entry in 0..9 {
        for test in 0..3 {
            let literal = 1_u32 << (3 * entry + test);
            if pattern & literal == 0 {
                continue;
            }
            let relation = match test {
                0 => "=0",
                1 => "!=0",
                _ => "=1",
            };
            parts.push(format!("m{entry}{relation}"));
        }
    }
    parts.join(" & ")
}

fn decode_matrix(mut code: usize) -> [u8; 9] {
    let mut matrix = [0_u8; 9];
    for entry in &mut matrix {
        *entry = (code % 5) as u8;
        code /= 5;
    }
    matrix
}

fn matrix_literal_mask(matrix: [u8; 9]) -> u32 {
    let mut mask = 0_u32;
    for (entry, value) in matrix.into_iter().enumerate() {
        if value == 0 {
            mask |= 1_u32 << (3 * entry);
        } else {
            mask |= 1_u32 << (3 * entry + 1);
        }
        if value == 1 {
            mask |= 1_u32 << (3 * entry + 2);
        }
    }
    mask
}

fn semantic_residual_member(matrix: [u8; 9]) -> bool {
    if matrix.iter().find(|&&entry| entry != 0) != Some(&1) || det5(matrix) == 0 {
        return false;
    }
    [([0, 0, 1], [0, 0, 1]), ([0, 1, 0], [0, 1, 0])]
        .into_iter()
        .all(|(point, expected)| normalize(apply_matrix_raw(matrix, point)) == expected)
}

fn canonical_triple(triple: [u16; 3], action: &[[u16; ORBIT_COUNT]]) -> [u16; 3] {
    let mut best = [u16::MAX; 3];
    for permutation in action {
        let mut image = [
            permutation[triple[0] as usize],
            permutation[triple[1] as usize],
            permutation[triple[2] as usize],
        ];
        image.sort_unstable();
        best = best.min(image);
    }
    best
}

fn triple_orbit_size(triple: [u16; 3], action: &[[u16; ORBIT_COUNT]]) -> u16 {
    let mut images = [[0_u16; 3]; 400];
    for (image, permutation) in images.iter_mut().zip(action) {
        *image = [
            permutation[triple[0] as usize],
            permutation[triple[1] as usize],
            permutation[triple[2] as usize],
        ];
        image.sort_unstable();
    }
    images.sort_unstable();
    let mut distinct = 1_u16;
    for index in 1..images.len() {
        distinct += u16::from(images[index] != images[index - 1]);
    }
    distinct
}

pub fn write_certificate(census: &Q25Census, output: &mut impl Write) -> Result<u64> {
    output.write_all(&CERTIFICATE_MAGIC)?;
    output.write_all(&(census.records.len() as u32).to_le_bytes())?;
    let mut bytes = 12_u64;
    for record in &census.records {
        match record.outcome {
            RowOutcome::Obstruction(indices) => {
                output.write_all(&[triple_rank(indices)])?;
                bytes += 1;
            }
            RowOutcome::Legal {
                first_witness,
                second_witness,
            } => {
                output.write_all(&[u8::MAX])?;
                output.write_all(&first_witness.to_le_bytes())?;
                output.write_all(&second_witness.to_le_bytes())?;
                bytes += 5;
            }
        }
    }
    Ok(bytes)
}

pub fn verify_certificate(input: &mut impl Read) -> Result<u64> {
    let mut magic = [0_u8; 8];
    input.read_exact(&mut magic)?;
    ensure!(magic == CERTIFICATE_MAGIC, "Q25 certificate magic mismatch");
    let mut count_bytes = [0_u8; 4];
    input.read_exact(&mut count_bytes)?;
    ensure!(u32::from_le_bytes(count_bytes) == 46_056);
    let geometry = Geometry::build();
    let mut bytes = 12_u64;
    for second in 6..309_u16 {
        for third in second + 1..310_u16 {
            let points = geometry.row_points(second, third);
            let mut tag = [0_u8; 1];
            input.read_exact(&mut tag)?;
            bytes += 1;
            if tag[0] != u8::MAX {
                let indices = triple_from_rank(tag[0])?;
                ensure!(
                    determinant(
                        geometry.points[points[indices[0] as usize] as usize],
                        geometry.points[points[indices[1] as usize] as usize],
                        geometry.points[points[indices[2] as usize] as usize],
                    ) == 0,
                    "Q25 obstruction does not replay"
                );
                continue;
            }
            let first = read_u16(input)?;
            let second = read_u16(input)?;
            bytes += 4;
            ensure!(first < ORBIT_COUNT as u16 && second < ORBIT_COUNT as u16);
            ensure!(first != second, "Q25 repair witnesses are not distinct");
            ensure!(direct_arc(&geometry, &points, first));
            ensure!(direct_arc(&geometry, &points, second));
        }
    }
    let mut trailing = [0_u8; 1];
    ensure!(
        input.read(&mut trailing)? == 0,
        "trailing Q25 certificate data"
    );
    Ok(bytes)
}

pub fn write_minimum_certificate(census: &Q25Census, output: &mut impl Write) -> Result<u64> {
    output.write_all(&MINIMUM_CERTIFICATE_MAGIC)?;
    output.write_all(&(census.records.len() as u32).to_le_bytes())?;
    let mut bytes = 12_u64;
    for (index, record) in census.records.iter().enumerate() {
        match record.outcome {
            RowOutcome::Obstruction(indices) => {
                output.write_all(&[triple_rank(indices)])?;
                bytes += 1;
            }
            RowOutcome::Legal { .. } => {
                output.write_all(&[u8::MAX])?;
                let legal = census.record_to_legal[index];
                ensure!(legal != u32::MAX);
                for word in census.legal_masks[legal as usize] {
                    output.write_all(&word.to_le_bytes())?;
                }
                bytes += 41;
            }
        }
    }
    Ok(bytes)
}

#[derive(Clone, Copy)]
struct MinimumVerifyResult {
    valid: bool,
    summary: MinimumCertificateSummary,
}

struct MinimumVerifyKernel<'a> {
    geometry: &'a Geometry,
    evidence: &'a [MinimumEvidenceRow],
}

impl RootKernel for MinimumVerifyKernel<'_> {
    type Root = RootRange;
    type Worker = ();
    type Output = MinimumVerifyResult;

    fn create_worker(&self) -> Self::Worker {}

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        _ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        let mut output = MinimumVerifyResult {
            valid: true,
            summary: MinimumCertificateSummary {
                minimum_legal_count: u32::MAX,
                ..MinimumCertificateSummary::default()
            },
        };
        for second in root.start..root.end {
            for third in second + 1..310_u16 {
                output.summary.rows += 1;
                let points = self.geometry.row_points(second, third);
                match self.evidence[row_index(second, third)] {
                    MinimumEvidenceRow::Obstruction(indices) => {
                        if determinant(
                            self.geometry.points[points[indices[0] as usize] as usize],
                            self.geometry.points[points[indices[1] as usize] as usize],
                            self.geometry.points[points[indices[2] as usize] as usize],
                        ) != 0
                        {
                            output.valid = false;
                            return output;
                        }
                    }
                    MinimumEvidenceRow::LegalMask(mask) => {
                        let count = mask.iter().map(|word| word.count_ones()).sum::<u32>();
                        if count < 32 {
                            output.valid = false;
                            return output;
                        }
                        for orbit in 0..ORBIT_COUNT as u16 {
                            let recorded =
                                mask[orbit as usize / 64] & (1_u64 << (orbit as usize % 64)) != 0;
                            if recorded != direct_arc(self.geometry, &points, orbit) {
                                output.valid = false;
                                return output;
                            }
                        }
                        output.summary.legal_rows += 1;
                        output.summary.minimum_legal_count =
                            output.summary.minimum_legal_count.min(count);
                        output.summary.maximum_legal_count =
                            output.summary.maximum_legal_count.max(count);
                        output.summary.minimum_rows += u32::from(count == 32);
                    }
                }
            }
        }
        output
    }
}

pub fn verify_minimum_certificate(
    input: &mut impl Read,
    threads: usize,
) -> Result<MinimumCertificateSummary> {
    ensure!(
        (1..=12).contains(&threads),
        "thread count must be in 1..=12"
    );
    let mut magic = [0_u8; 8];
    input.read_exact(&mut magic)?;
    ensure!(
        magic == MINIMUM_CERTIFICATE_MAGIC,
        "Q25 minimum certificate magic mismatch"
    );
    let mut count_bytes = [0_u8; 4];
    input.read_exact(&mut count_bytes)?;
    ensure!(u32::from_le_bytes(count_bytes) == 46_056);
    let mut evidence = Vec::with_capacity(46_056);
    for _ in 0..46_056 {
        let mut tag = [0_u8; 1];
        input.read_exact(&mut tag)?;
        if tag[0] == u8::MAX {
            let mut mask = [0_u64; 5];
            for word in &mut mask {
                *word = read_u64(input)?;
            }
            evidence.push(MinimumEvidenceRow::LegalMask(mask));
        } else {
            evidence.push(MinimumEvidenceRow::Obstruction(triple_from_rank(tag[0])?));
        }
    }
    let mut trailing = [0_u8; 1];
    ensure!(
        input.read(&mut trailing)? == 0,
        "trailing Q25 minimum certificate data"
    );
    let geometry = Geometry::build();
    let roots = root_ranges(threads);
    let result = reduce_roots(
        &MinimumVerifyKernel {
            geometry: &geometry,
            evidence: &evidence,
        },
        &roots,
        threads,
        || MinimumVerifyResult {
            valid: true,
            summary: MinimumCertificateSummary {
                minimum_legal_count: u32::MAX,
                ..MinimumCertificateSummary::default()
            },
        },
        |left, right| MinimumVerifyResult {
            valid: left.valid && right.valid,
            summary: MinimumCertificateSummary {
                rows: left.summary.rows + right.summary.rows,
                legal_rows: left.summary.legal_rows + right.summary.legal_rows,
                minimum_legal_count: left
                    .summary
                    .minimum_legal_count
                    .min(right.summary.minimum_legal_count),
                maximum_legal_count: left
                    .summary
                    .maximum_legal_count
                    .max(right.summary.maximum_legal_count),
                minimum_rows: left.summary.minimum_rows + right.summary.minimum_rows,
            },
        },
    )?;
    ensure!(
        result.valid,
        "Q25 minimum certificate failed semantic replay"
    );
    ensure!(result.summary.rows == 46_056);
    ensure!(result.summary.legal_rows == 7_044);
    Ok(result.summary)
}

fn triple_rank(indices: [u8; 3]) -> u8 {
    let mut rank = 0_u8;
    for left in 0..8_u8 {
        for middle in left + 1..8_u8 {
            for right in middle + 1..8_u8 {
                if indices == [left, middle, right] {
                    return rank;
                }
                rank += 1;
            }
        }
    }
    panic!("invalid obstruction triple")
}

fn triple_from_rank(target: u8) -> Result<[u8; 3]> {
    let mut rank = 0_u8;
    for left in 0..8_u8 {
        for middle in left + 1..8_u8 {
            for right in middle + 1..8_u8 {
                if rank == target {
                    return Ok([left, middle, right]);
                }
                rank += 1;
            }
        }
    }
    anyhow::bail!("invalid obstruction-triple rank {target}")
}

fn read_u16(input: &mut impl Read) -> Result<u16> {
    let mut bytes = [0_u8; 2];
    input.read_exact(&mut bytes)?;
    Ok(u16::from_le_bytes(bytes))
}

fn read_u64(input: &mut impl Read) -> Result<u64> {
    let mut bytes = [0_u8; 8];
    input.read_exact(&mut bytes)?;
    Ok(u64::from_le_bytes(bytes))
}

#[derive(Debug)]
struct Geometry {
    points: Box<[Point]>,
    fixed: Box<[u16]>,
    orbits: Box<[[u16; 2]]>,
    orbit_by_number: Box<[u16]>,
    joins: Box<[u16]>,
}

impl Geometry {
    fn build() -> Self {
        let mut points = Vec::with_capacity(POINT_COUNT);
        let mut id_by_key = vec![NO_POINT; FIELD_ORDER.pow(3)];
        for a in 0..FIELD_ORDER as u8 {
            for b in 0..FIELD_ORDER as u8 {
                for c in 0..FIELD_ORDER as u8 {
                    if a == 0 && b == 0 && c == 0 {
                        continue;
                    }
                    let point = normalize([a, b, c]);
                    let key = point_key(point);
                    if id_by_key[key] == NO_POINT {
                        id_by_key[key] = points.len() as u16;
                        points.push(point);
                    }
                }
            }
        }
        assert_eq!(points.len(), POINT_COUNT);

        let mut sigma = vec![0_u16; POINT_COUNT];
        let mut fixed = Vec::with_capacity(31);
        for (index, &point) in points.iter().enumerate() {
            let image = id_by_key[point_key(frobenius(point))];
            sigma[index] = image;
            if image as usize == index {
                fixed.push(index as u16);
            }
        }
        assert_eq!(fixed.len(), 31);
        let mut orbits = Vec::with_capacity(ORBIT_COUNT);
        for (index, &image) in sigma.iter().enumerate() {
            if index < image as usize {
                orbits.push([index as u16, image]);
            }
        }
        assert_eq!(orbits.len(), ORBIT_COUNT);

        let mut orbit_by_number = vec![NO_POINT; ORBIT_COUNT];
        for (orbit, &[left, right]) in orbits.iter().enumerate() {
            let number = lean_orbit_number(points[left as usize], points[right as usize]);
            assert_eq!(orbit_by_number[number], NO_POINT);
            orbit_by_number[number] = orbit as u16;
        }

        let mut joins = vec![NO_POINT; POINT_COUNT * POINT_COUNT];
        for left in 0..POINT_COUNT {
            for right in left + 1..POINT_COUNT {
                let line = id_by_key[point_key(cross(points[left], points[right]))];
                joins[left * POINT_COUNT + right] = line;
                joins[right * POINT_COUNT + left] = line;
            }
        }
        Self {
            points: points.into_boxed_slice(),
            fixed: fixed.into_boxed_slice(),
            orbits: orbits.into_boxed_slice(),
            orbit_by_number: orbit_by_number.into_boxed_slice(),
            joins: joins.into_boxed_slice(),
        }
    }

    #[inline]
    fn collinear(&self, left: u16, middle: u16, right: u16) -> bool {
        let line = self.joins[left as usize * POINT_COUNT + middle as usize];
        dot(self.points[right as usize], self.points[line as usize]) == 0
    }

    fn first_obstruction<const N: usize>(&self, points: &[u16; N]) -> Option<[u8; 3]> {
        for left in 0..N {
            for middle in left + 1..N {
                for right in middle + 1..N {
                    if self.collinear(points[left], points[middle], points[right]) {
                        return Some([left as u8, middle as u8, right as u8]);
                    }
                }
            }
        }
        None
    }

    fn row_points(&self, second: u16, third: u16) -> [u16; 8] {
        let first = self.orbits[self.orbit_by_number[5] as usize];
        let second = self.orbits[self.orbit_by_number[second as usize] as usize];
        let third = self.orbits[self.orbit_by_number[third as usize] as usize];
        [
            self.fixed[0],
            self.fixed[1],
            first[0],
            first[1],
            second[0],
            second[1],
            third[0],
            third[1],
        ]
    }

    #[inline]
    fn extends(&self, base: &[u16; 8], orbit_number: u16) -> bool {
        let pair = self.orbits[self.orbit_by_number[orbit_number as usize] as usize];
        if base.contains(&pair[0]) || base.contains(&pair[1]) {
            return false;
        }
        for left in 0..8 {
            if self.collinear(pair[0], pair[1], base[left]) {
                return false;
            }
            for right in left + 1..8 {
                if self.collinear(base[left], base[right], pair[0])
                    || self.collinear(base[left], base[right], pair[1])
                {
                    return false;
                }
            }
        }
        true
    }

    fn residual_action(&self) -> Box<[[u16; ORBIT_COUNT]]> {
        let mut id_by_key = vec![NO_POINT; FIELD_ORDER.pow(3)];
        for (index, &point) in self.points.iter().enumerate() {
            id_by_key[point_key(point)] = index as u16;
        }
        let mut orbit_of_point = vec![NO_POINT; POINT_COUNT];
        for (orbit, pair) in self.orbits.iter().enumerate() {
            orbit_of_point[pair[0] as usize] = orbit as u16;
            orbit_of_point[pair[1] as usize] = orbit as u16;
        }

        assert_eq!(self.points[self.fixed[0] as usize], [0, 0, 1]);
        assert_eq!(self.points[self.fixed[1] as usize], [0, 1, 0]);
        let mut matrices = Vec::with_capacity(400);
        for middle_scale in 1..5 {
            for final_scale in 1..5 {
                for lower_left in 0..5 {
                    for bottom_left in 0..5 {
                        matrices.push([
                            1,
                            0,
                            0,
                            lower_left,
                            middle_scale,
                            0,
                            bottom_left,
                            0,
                            final_scale,
                        ]);
                    }
                }
            }
        }
        assert_eq!(matrices.len(), 400);

        let mut action = Vec::with_capacity(400);
        for matrix in matrices {
            let mut permutation = [NO_POINT; ORBIT_COUNT];
            for (orbit, pair) in self.orbits.iter().enumerate() {
                let image = apply_matrix(matrix, self.points[pair[0] as usize]);
                let image_point = id_by_key[point_key(image)];
                permutation[orbit] = orbit_of_point[image_point as usize];
            }
            debug_assert!(!permutation.contains(&NO_POINT));
            action.push(permutation);
        }
        action.into_boxed_slice()
    }
}

#[inline]
fn det5(matrix: [u8; 9]) -> u8 {
    let positive = matrix[0] as i16 * matrix[4] as i16 * matrix[8] as i16
        + matrix[1] as i16 * matrix[5] as i16 * matrix[6] as i16
        + matrix[2] as i16 * matrix[3] as i16 * matrix[7] as i16;
    let negative = matrix[2] as i16 * matrix[4] as i16 * matrix[6] as i16
        + matrix[1] as i16 * matrix[3] as i16 * matrix[8] as i16
        + matrix[0] as i16 * matrix[5] as i16 * matrix[7] as i16;
    (positive - negative).rem_euclid(5) as u8
}

#[inline]
fn apply_matrix(matrix: [u8; 9], point: Point) -> Point {
    normalize(apply_matrix_raw(matrix, point))
}

#[inline]
fn apply_matrix_raw(matrix: [u8; 9], point: Point) -> Point {
    let mut image = [0_u8; 3];
    for row in 0..3 {
        let mut coordinate = 0_u8;
        for column in 0..3 {
            coordinate = add25(coordinate, mul25(matrix[3 * row + column], point[column]));
        }
        image[row] = coordinate;
    }
    image
}

struct GenerateKernel<'a> {
    geometry: &'a Geometry,
}

impl RootKernel for GenerateKernel<'_> {
    type Root = RootRange;
    type Worker = ();
    type Output = Vec<GeneratedRow>;

    fn create_worker(&self) -> Self::Worker {}

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        _ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        let capacity = (root.start..root.end)
            .map(|second| usize::from(309 - second))
            .sum();
        let mut rows = Vec::with_capacity(capacity);
        for second in root.start..root.end {
            for third in second + 1..310_u16 {
                let points = self.geometry.row_points(second, third);
                if let Some(obstruction) = self.geometry.first_obstruction(&points) {
                    rows.push(GeneratedRow {
                        record: RowRecord {
                            second_orbit: second,
                            third_orbit: third,
                            outcome: RowOutcome::Obstruction(obstruction),
                        },
                        legal_mask: None,
                    });
                    continue;
                }
                let mut mask = [0_u64; 5];
                let mut witnesses = [NO_POINT; 2];
                let mut witness_count = 0_usize;
                for orbit in 0..ORBIT_COUNT as u16 {
                    if self.geometry.extends(&points, orbit) {
                        mask[orbit as usize / 64] |= 1_u64 << (orbit as usize % 64);
                        if witness_count < witnesses.len() {
                            witnesses[witness_count] = orbit;
                        }
                        witness_count += 1;
                    }
                }
                assert!(witness_count >= 2);
                rows.push(GeneratedRow {
                    record: RowRecord {
                        second_orbit: second,
                        third_orbit: third,
                        outcome: RowOutcome::Legal {
                            first_witness: witnesses[0],
                            second_witness: witnesses[1],
                        },
                    },
                    legal_mask: Some(mask),
                });
            }
        }
        assert_eq!(rows.len(), capacity);
        rows
    }
}

fn root_ranges(threads: usize) -> Vec<RootRange> {
    let task_count = (threads * 4).clamp(1, 303);
    (0..task_count)
        .filter_map(|task| {
            let start = 6 + (303 * task / task_count) as u16;
            let end = 6 + (303 * (task + 1) / task_count) as u16;
            (start != end).then_some(RootRange { start, end })
        })
        .collect()
}

pub fn compile_q25_pair_repair(threads: usize) -> Result<Q25Census> {
    ensure!(
        (1..=12).contains(&threads),
        "thread count must be in 1..=12"
    );
    let geometry = Geometry::build();
    let roots = root_ranges(threads);
    let mut generated = reduce_roots(
        &GenerateKernel {
            geometry: &geometry,
        },
        &roots,
        threads,
        Vec::new,
        |mut left, mut right| {
            left.append(&mut right);
            left
        },
    )?;
    generated.sort_unstable_by_key(|row| (row.record.second_orbit, row.record.third_orbit));
    let mut records = Vec::with_capacity(46_056);
    let mut legal_masks = Vec::with_capacity(7_044);
    let mut record_to_legal = Vec::with_capacity(46_056);
    for row in generated {
        records.push(row.record);
        if let Some(mask) = row.legal_mask {
            record_to_legal.push(legal_masks.len() as u32);
            legal_masks.push(mask);
        } else {
            record_to_legal.push(u32::MAX);
        }
    }
    ensure!(records.len() == 46_056, "normalized row count changed");
    ensure!(legal_masks.len() == 7_044, "legal row count changed");

    let legal_count = legal_masks.len() as u32;
    let target_start = legal_count;
    let mut observations = vec![0_u32; legal_masks.len()];
    observations.extend([0, 1]);
    let mut generators = Vec::with_capacity(ORBIT_COUNT);
    for orbit in 0..ORBIT_COUNT {
        let transitions = legal_masks
            .iter()
            .map(|mask| target_start + u32::from(mask[orbit / 64] & (1_u64 << (orbit % 64)) != 0))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        generators.push(GeneratorSpec {
            source_sort: 0,
            target_sort: 1,
            transitions,
        });
    }
    let presentation = FinitePresentation::new([legal_count, 2], observations, generators)?;
    let compilation =
        compile_observational_with_policy(&presentation, CertificatePolicy::AdaptiveTranscript)?;
    let response_classes = compilation.class_ranges()[0].len;
    Ok(Q25Census {
        records: records.into_boxed_slice(),
        legal_masks: legal_masks.into_boxed_slice(),
        record_to_legal: record_to_legal.into_boxed_slice(),
        response_classes,
        presentation,
        compilation,
    })
}

struct VerifyKernel<'a> {
    geometry: &'a Geometry,
    census: &'a Q25Census,
}

impl RootKernel for VerifyKernel<'_> {
    type Root = RootRange;
    type Worker = ();
    type Output = bool;

    fn create_worker(&self) -> Self::Worker {}

    fn evaluate(
        &self,
        _worker: &mut Self::Worker,
        _ordinal: RootOrdinal,
        root: &Self::Root,
    ) -> Self::Output {
        for second in root.start..root.end {
            for third in second + 1..310_u16 {
                let index = row_index(second, third);
                let record = &self.census.records[index];
                let points = self.geometry.row_points(second, third);
                match record.outcome {
                    RowOutcome::Obstruction(indices) => {
                        if determinant(
                            self.geometry.points[points[indices[0] as usize] as usize],
                            self.geometry.points[points[indices[1] as usize] as usize],
                            self.geometry.points[points[indices[2] as usize] as usize],
                        ) != 0
                        {
                            return false;
                        }
                    }
                    RowOutcome::Legal {
                        first_witness,
                        second_witness,
                    } => {
                        if first_witness == second_witness
                            || !direct_arc(self.geometry, &points, first_witness)
                            || !direct_arc(self.geometry, &points, second_witness)
                        {
                            return false;
                        }
                        let legal = self.census.record_to_legal[index];
                        if legal == u32::MAX {
                            return false;
                        }
                        let mask = self.census.legal_masks[legal as usize];
                        for orbit in 0..ORBIT_COUNT as u16 {
                            let recorded =
                                mask[orbit as usize / 64] & (1_u64 << (orbit as usize % 64)) != 0;
                            if recorded != direct_arc(self.geometry, &points, orbit) {
                                return false;
                            }
                        }
                    }
                }
            }
        }
        true
    }
}

fn row_index(second: u16, third: u16) -> usize {
    let preceding = usize::from(second - 6);
    preceding * 303 - preceding * preceding.saturating_sub(1) / 2 + usize::from(third - second - 1)
}

pub fn independently_verify(census: &Q25Census, threads: usize) -> Result<()> {
    ensure!(
        (1..=12).contains(&threads),
        "thread count must be in 1..=12"
    );
    let geometry = Geometry::build();
    let roots = root_ranges(threads);
    ensure!(reduce_roots(
        &VerifyKernel {
            geometry: &geometry,
            census,
        },
        &roots,
        threads,
        || true,
        |left, right| left && right,
    )?);
    census.verify_compilation()
}

fn direct_arc(geometry: &Geometry, base: &[u16; 8], orbit_number: u16) -> bool {
    let pair = geometry.orbits[geometry.orbit_by_number[orbit_number as usize] as usize];
    let points = [
        base[0], base[1], base[2], base[3], base[4], base[5], base[6], base[7], pair[0], pair[1],
    ];
    for left in 0..10 {
        for middle in left + 1..10 {
            for right in middle + 1..10 {
                if determinant(
                    geometry.points[points[left] as usize],
                    geometry.points[points[middle] as usize],
                    geometry.points[points[right] as usize],
                ) == 0
                {
                    return false;
                }
            }
        }
    }
    true
}

fn determinant(a: Point, b: Point, c: Point) -> u8 {
    add25(
        add25(
            mul25(a[0], sub25(mul25(b[1], c[2]), mul25(b[2], c[1]))),
            mul25(a[1], sub25(mul25(b[2], c[0]), mul25(b[0], c[2]))),
        ),
        mul25(a[2], sub25(mul25(b[0], c[1]), mul25(b[1], c[0]))),
    )
}

#[inline]
fn add25(left: u8, right: u8) -> u8 {
    ((left % 5 + right % 5) % 5) + 5 * ((left / 5 + right / 5) % 5)
}

#[inline]
fn neg25(value: u8) -> u8 {
    ((5 - value % 5) % 5) + 5 * ((5 - value / 5) % 5)
}

#[inline]
fn sub25(left: u8, right: u8) -> u8 {
    add25(left, neg25(right))
}

#[inline]
fn mul25(left: u8, right: u8) -> u8 {
    let (a, b) = (left % 5, left / 5);
    let (c, d) = (right % 5, right / 5);
    ((a * c + 2 * b * d) % 5) + 5 * ((a * d + b * c) % 5)
}

fn pow25(mut value: u8, mut power: u8) -> u8 {
    let mut result = 1;
    while power != 0 {
        if power & 1 != 0 {
            result = mul25(result, value);
        }
        value = mul25(value, value);
        power >>= 1;
    }
    result
}

fn normalize(mut point: Point) -> Point {
    let pivot = point.iter().position(|&value| value != 0).unwrap();
    let inverse = pow25(point[pivot], 23);
    for value in &mut point {
        *value = mul25(*value, inverse);
    }
    point
}

fn point_key(point: Point) -> usize {
    point[0] as usize + 25 * point[1] as usize + 625 * point[2] as usize
}

fn projective_rank(point: Point) -> usize {
    if point[0] == 1 {
        point[1] as usize * 25 + point[2] as usize
    } else if point[1] == 1 {
        625 + point[2] as usize
    } else {
        650
    }
}

fn lean_orbit_number(left: Point, right: Point) -> usize {
    let point = if projective_rank(left) < projective_rank(right) {
        left
    } else {
        right
    };
    if point[0] == 1 {
        let (y_real, y_imag) = (point[1] % 5, point[1] / 5);
        if y_imag != 0 {
            assert!(y_imag == 1 || y_imag == 2);
            return (y_real as usize * 2 + y_imag as usize - 1) * 25 + point[2] as usize;
        }
        let (z_real, z_imag) = (point[2] % 5, point[2] / 5);
        assert!(z_imag == 1 || z_imag == 2);
        250 + (y_real as usize * 5 + z_real as usize) * 2 + z_imag as usize - 1
    } else {
        let (z_real, z_imag) = (point[2] % 5, point[2] / 5);
        assert_eq!(point[1], 1);
        assert!(z_imag == 1 || z_imag == 2);
        300 + z_real as usize * 2 + z_imag as usize - 1
    }
}

fn cross(left: Point, right: Point) -> Point {
    normalize([
        sub25(mul25(left[1], right[2]), mul25(left[2], right[1])),
        sub25(mul25(left[2], right[0]), mul25(left[0], right[2])),
        sub25(mul25(left[0], right[1]), mul25(left[1], right[0])),
    ])
}

fn dot(left: Point, right: Point) -> u8 {
    add25(
        add25(mul25(left[0], right[0]), mul25(left[1], right[1])),
        mul25(left[2], right[2]),
    )
}

fn frobenius(mut point: Point) -> Point {
    for value in &mut point {
        *value = pow25(*value, 5);
    }
    normalize(point)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn q25_census_matches_the_authoritative_counts_and_replays() {
        let census = compile_q25_pair_repair(4).unwrap();
        assert_eq!(census.records.len(), 46_056);
        assert_eq!(census.obstruction_count(), 39_012);
        assert_eq!(census.legal_count(), 7_044);
        independently_verify(&census, 4).unwrap();
        let mut certificate = Vec::new();
        assert_eq!(
            write_certificate(&census, &mut certificate).unwrap(),
            74_244
        );
        assert_eq!(
            verify_certificate(&mut certificate.as_slice()).unwrap(),
            74_244
        );
        certificate[0] ^= 1;
        assert!(verify_certificate(&mut certificate.as_slice()).is_err());

        let mut minimum_certificate = Vec::new();
        assert_eq!(
            write_minimum_certificate(&census, &mut minimum_certificate).unwrap(),
            327_828
        );
        assert_eq!(
            verify_minimum_certificate(&mut minimum_certificate.as_slice(), 4).unwrap(),
            MinimumCertificateSummary {
                rows: 46_056,
                legal_rows: 7_044,
                minimum_legal_count: 32,
                maximum_legal_count: 47,
                minimum_rows: 24,
            }
        );
        minimum_certificate[0] ^= 1;
        assert!(verify_minimum_certificate(&mut minimum_certificate.as_slice(), 4).is_err());

        assert_eq!(
            classify_minimum_residual_orbits(&census),
            vec![
                ResidualOrbitClass {
                    representative: [65, 93, 154],
                    orbit_size: 200,
                    stabilizer_order: 2,
                    slice_rows: 3,
                },
                ResidualOrbitClass {
                    representative: [65, 96, 216],
                    orbit_size: 400,
                    stabilizer_order: 1,
                    slice_rows: 6,
                },
                ResidualOrbitClass {
                    representative: [65, 98, 251],
                    orbit_size: 400,
                    stabilizer_order: 1,
                    slice_rows: 6,
                },
                ResidualOrbitClass {
                    representative: [65, 119, 232],
                    orbit_size: 200,
                    stabilizer_order: 2,
                    slice_rows: 3,
                },
                ResidualOrbitClass {
                    representative: [65, 123, 279],
                    orbit_size: 400,
                    stabilizer_order: 1,
                    slice_rows: 6,
                },
            ]
        );
    }
}
