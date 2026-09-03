//! A small typed grammar of lossless encoders, with allocation-free decode and
//! random-access probe paths over caller-owned presized buffers.
//!
//! The grammar exists so a bounded evolution engine can search representations
//! the way it searches predicates: a candidate is a typed pipeline, its score is
//! an exact byte count plus the measured compute every operation the
//! representation implies, and it is admitted only on round-trip identity plus
//! exact probe agreement against the reference observation.
//!
//! Layout and allocation rules follow the core performance contract. Every
//! record crossing into a probe or decode loop is `#[repr(C)]` with asserted
//! size and alignment and no owned dynamic container; the pipeline description
//! itself is cold configuration and is never read inside a probe. Encode,
//! decode, probe, and every precondition table are built into a caller-owned
//! [`ReprWorkspace`], so the measured paths allocate nothing.

use std::cmp::Ordering;

use serde::Serialize;

/// Maximum number of grammar nodes in one pipeline (transforms plus serializer).
pub const MAX_PIPELINE_DEPTH: usize = 3;

/// Maximum transforms, i.e. [`MAX_PIPELINE_DEPTH`] minus the serializer.
pub const MAX_TRANSFORMS: usize = MAX_PIPELINE_DEPTH - 1;

/// Block length, in elements, of the hash-consing dictionary serializer.
pub const DICTIONARY_BLOCK: usize = 4;

/// The typed observation families the grammar accepts.
#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ObservationKind {
    /// A strictly increasing list of ids drawn from a large universe.
    SortedIds,
    /// A membership set over a contiguous index range, dense in the middle.
    DenseBitmap,
    /// An order-bearing vector of small nonnegative integers.
    SmallIntVector,
}

impl ObservationKind {
    /// True when the observation is a set, so element order carries no
    /// information and a canonical permutation is lossless.
    pub fn order_free(self) -> bool {
        matches!(self, Self::SortedIds | Self::DenseBitmap)
    }

    /// The probe this family is actually asked in the core.
    pub fn membership_probe(self) -> bool {
        self.order_free()
    }
}

/// One typed observation. Membership families store their members strictly
/// increasing; the vector family stores its values in order.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct Observation {
    kind: ObservationKind,
    universe: u64,
    values: Box<[i64]>,
}

/// Reasons an observation is not well formed for its declared family.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ObservationError {
    /// A membership family received a nonincreasing or repeated member.
    NotStrictlyIncreasing,
    /// A value lies outside the declared universe.
    OutOfUniverse,
    /// The observation exceeds the workspace element cap.
    TooLarge,
}

impl Observation {
    /// Validate and take ownership of one observation.
    pub fn new(
        kind: ObservationKind,
        universe: u64,
        values: Vec<i64>,
    ) -> Result<Self, ObservationError> {
        if values.len() > u32::MAX as usize || universe > u32::MAX as u64 {
            return Err(ObservationError::TooLarge);
        }
        for &value in &values {
            if value < 0 || value as u64 >= universe.max(1) {
                return Err(ObservationError::OutOfUniverse);
            }
        }
        if kind.order_free() && values.windows(2).any(|pair| pair[0] >= pair[1]) {
            return Err(ObservationError::NotStrictlyIncreasing);
        }
        Ok(Self {
            kind,
            universe,
            values: values.into_boxed_slice(),
        })
    }

    pub fn kind(&self) -> ObservationKind {
        self.kind
    }

    pub fn universe(&self) -> u64 {
        self.universe
    }

    pub fn values(&self) -> &[i64] {
        &self.values
    }

    pub fn len(&self) -> usize {
        self.values.len()
    }

    pub fn is_empty(&self) -> bool {
        self.values.is_empty()
    }

    /// Exact bytes of the uncompressed reference form: one `u64` per element.
    pub fn reference_bytes(&self) -> u64 {
        8 * self.values.len() as u64
    }

    /// `log2` of the number of distinct observations with these shape
    /// parameters, in bytes: the combinatorial entropy bound for the family.
    ///
    /// Membership families are subsets of the universe of the observed size;
    /// the vector family is a word over its value alphabet.
    pub fn entropy_bound_bytes(&self) -> f64 {
        let n = self.values.len() as f64;
        let u = self.universe.max(1) as f64;
        let bits = if self.kind.order_free() {
            log2_binomial(u, n)
        } else {
            n * u.log2()
        };
        bits / 8.0
    }
}

fn log2_binomial(u: f64, n: f64) -> f64 {
    if n <= 0.0 || n >= u {
        return 0.0;
    }
    (ln_gamma(u + 1.0) - ln_gamma(n + 1.0) - ln_gamma(u - n + 1.0)) / std::f64::consts::LN_2
}

/// Lanczos approximation, sufficient for a reported information bound.
fn ln_gamma(x: f64) -> f64 {
    const COEFFICIENTS: [f64; 6] = [
        76.180_091_729_471_46,
        -86.505_320_329_416_77,
        24.014_098_240_830_91,
        -1.231_739_572_450_155,
        0.001_208_650_973_866_179,
        -0.000_005_395_239_384_953,
    ];
    let mut y = x;
    let temporary = x + 5.5;
    let temporary = temporary - (x + 0.5) * temporary.ln();
    let mut series = 1.000_000_000_190_015_f64;
    for coefficient in COEFFICIENTS {
        y += 1.0;
        series += coefficient / y;
    }
    -temporary + (2.506_628_274_631_000_5 * series / x).ln()
}

/// Value-to-value grammar nodes. Every transform is exactly invertible given
/// the header it writes.
#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum Transform {
    /// Subtract the elementwise minimum, recording it as the header base. On a
    /// membership row this clips the empty prefix; the serializer's own extent
    /// clips the empty suffix.
    WindowClip,
    /// Replace each element by its difference from the previous one.
    Delta,
    /// Fold signed values onto the nonnegative integers.
    Zigzag,
    /// Sort ascending. Lossless only for an order-free family.
    CanonicalPermutation,
}

/// Value-sequence-to-bytes grammar nodes.
#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum Serializer {
    /// Identity: eight fixed bytes per element.
    Fixed64,
    /// Bit-width narrowing: `ceil(log2(max + 1))` bits per element.
    Narrow,
    /// LEB128 over nonnegative values.
    Varint,
    /// Elias-Fano over a nondecreasing nonnegative sequence, with a rank
    /// directory over the high bitvector.
    EliasFano,
    /// Run-length pairs of value and repeat count.
    RunLength,
    /// A window-relative dense bitmap over the value extent.
    BitPack,
    /// Hash-consing of fixed-length blocks into a dictionary plus index stream.
    Dictionary,
}

impl Serializer {
    /// True when an element or member can be reached without decoding the
    /// prefix, given a pointwise-only inverse chain.
    pub fn random_access(self) -> bool {
        matches!(
            self,
            Self::Fixed64 | Self::Narrow | Self::BitPack | Self::EliasFano
        )
    }

    /// True when this serializer builds a precondition table in the workspace.
    pub fn builds_directory(self) -> bool {
        matches!(self, Self::EliasFano | Self::Dictionary)
    }
}

/// Where the shape information of an encoded structure lives.
///
/// This is a first-class grammar axis, not a presentation detail: moving a
/// field out of the per-structure record and into the type removes both its
/// bytes and the runtime check that reads it. The public core already does this
/// for finite fields (`ergodis::field::Prime<P>`, dispatched statically through
/// the `FiniteField` trait) and for its `#[repr(C)]` hot records; the axis here
/// asks whether the same move pays for an encoded representation.
#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum Descriptor {
    /// The full 64-byte [`EncodedHeader`] record, one per structure.
    Runtime,
    /// One 8-byte machine word with typed bit-field accessors
    /// ([`type_level::PackedDescriptor`]).
    Packed,
    /// Zero bytes: the width, base, and element count are const-generic
    /// parameters of the compiled consumer, so nothing is stored per structure
    /// and the mask, shift, and extent bound are compile-time constants.
    TypeCarried,
}

impl Descriptor {
    /// Bytes this descriptor costs per encoded structure.
    pub fn bytes(self) -> u64 {
        match self {
            Self::Runtime => std::mem::size_of::<EncodedHeader>() as u64,
            Self::Packed => std::mem::size_of::<type_level::PackedDescriptor>() as u64,
            Self::TypeCarried => 0,
        }
    }

    pub fn name(self) -> &'static str {
        match self {
            Self::Runtime => "runtime-header",
            Self::Packed => "packed-word",
            Self::TypeCarried => "type-carried",
        }
    }
}

/// A typed pipeline: an ordered transform chain and one serializer.
///
/// This is cold configuration. It is read once when the encoder is compiled and
/// never inside a probe; the probe reads only [`EncodedHeader`] and the payload.
#[derive(Clone, Debug, Eq, Hash, Ord, PartialEq, PartialOrd, Serialize)]
pub struct Pipeline {
    transforms: Vec<Transform>,
    serializer: Serializer,
    descriptor: Descriptor,
}

impl Pipeline {
    /// A pipeline carrying the full runtime header.
    pub fn new(transforms: Vec<Transform>, serializer: Serializer) -> Option<Self> {
        Self::with_descriptor(transforms, serializer, Descriptor::Runtime)
    }

    pub fn with_descriptor(
        transforms: Vec<Transform>,
        serializer: Serializer,
        descriptor: Descriptor,
    ) -> Option<Self> {
        // Only a serializer with a fixed, plan-known width or extent can move
        // its shape into the type: a varint, run-length, or dictionary stream
        // has a data-dependent layout that no const generic can carry.
        if descriptor == Descriptor::TypeCarried
            && !matches!(serializer, Serializer::Narrow | Serializer::BitPack)
        {
            return None;
        }
        if transforms.len() > MAX_TRANSFORMS {
            return None;
        }
        // One header base slot, so at most one window clip.
        if transforms
            .iter()
            .filter(|&&step| step == Transform::WindowClip)
            .count()
            > 1
        {
            return None;
        }
        // A repeated pointwise transform is either a no-op or ill typed.
        if transforms.len() == 2 && transforms[0] == transforms[1] {
            return None;
        }
        // A canonical permutation is a normalization of the input, so it is
        // lossless only in first position: applied to a delta or zigzag stream
        // it discards the ordering the inverse chain needs.
        if transforms
            .iter()
            .skip(1)
            .any(|&step| step == Transform::CanonicalPermutation)
        {
            return None;
        }
        Some(Self {
            transforms,
            serializer,
            descriptor,
        })
    }

    pub fn transforms(&self) -> &[Transform] {
        &self.transforms
    }

    pub fn serializer(&self) -> Serializer {
        self.serializer
    }

    pub fn descriptor(&self) -> Descriptor {
        self.descriptor
    }

    /// Declared syntax cost: one unit per grammar node, the descriptor
    /// included.
    pub fn syntax_cost(&self) -> u32 {
        self.transforms.len() as u32 + 2
    }

    /// True when the inverse chain is pointwise, so a random-access serializer
    /// yields a random-access probe.
    pub fn pointwise_inverse(&self) -> bool {
        !self.transforms.contains(&Transform::Delta)
    }

    /// The probe class this pipeline compiles to.
    pub fn probe_class(&self) -> ProbeClass {
        if self.serializer.random_access() && self.pointwise_inverse() {
            ProbeClass::RandomAccess
        } else {
            ProbeClass::Streaming
        }
    }

    /// A stable, human-readable name, serializer last.
    pub fn name(&self) -> String {
        let mut parts = self
            .transforms
            .iter()
            .map(|step| transform_name(*step))
            .collect::<Vec<_>>();
        parts.push(serializer_name(self.serializer));
        parts.push(self.descriptor.name());
        parts.join(" . ")
    }
}

pub fn transform_name(step: Transform) -> &'static str {
    match step {
        Transform::WindowClip => "window-clip",
        Transform::Delta => "delta",
        Transform::Zigzag => "zigzag",
        Transform::CanonicalPermutation => "canonical-permutation",
    }
}

pub fn serializer_name(serializer: Serializer) -> &'static str {
    match serializer {
        Serializer::Fixed64 => "identity",
        Serializer::Narrow => "narrow",
        Serializer::Varint => "varint",
        Serializer::EliasFano => "elias-fano",
        Serializer::RunLength => "run-length",
        Serializer::BitPack => "bitpack",
        Serializer::Dictionary => "dictionary",
    }
}

/// How a probe reaches its answer.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum ProbeClass {
    /// Constant or logarithmic: no prefix decode.
    RandomAccess,
    /// Sequential decode of the prefix, with early exit where the family allows.
    Streaming,
}

/// Fixed-layout header of one encoded image.
///
/// Tiger-style hot record: plain data only, explicit `#[repr(C, align(64))]`,
/// fields ordered from largest alignment to smallest with the probe-hot fields
/// (`base`, `element_count`, `universe`, `bit_width`) first, explicit trailing
/// padding, and asserted size and alignment. It owns no payload; payload and
/// directory live in the caller's workspace and are addressed by length, not by
/// pointer.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct EncodedHeader {
    /// Window-clip base, zero when the pipeline has no clip.
    pub base: i64,
    /// Elements in the original observation.
    pub element_count: u32,
    /// Declared universe of the original observation.
    pub universe: u32,
    /// Payload bytes actually written.
    pub payload_bytes: u32,
    /// `u32` entries of the precondition table actually written.
    pub directory_entries: u32,
    /// Elias-Fano low-bit width, or the narrowing width, in bits.
    pub bit_width: u8,
    /// Encoded [`ObservationKind`].
    pub kind: u8,
    /// Encoded [`Serializer`].
    pub serializer: u8,
    /// Number of transforms in the pipeline.
    pub transform_count: u8,
    /// Bit 0: pointwise inverse chain. Bit 1: directory present.
    pub flags: u8,
    _padding: [u8; 35],
}

const _: () = assert!(std::mem::size_of::<EncodedHeader>() == 64);
const _: () = assert!(std::mem::align_of::<EncodedHeader>() == 64);

impl EncodedHeader {
    /// Total declared space: the descriptor, the payload, and every
    /// precondition table the representation requires.
    pub fn declared_bytes(&self, descriptor: Descriptor) -> u64 {
        descriptor.bytes() + u64::from(self.payload_bytes) + 4 * u64::from(self.directory_entries)
    }
}

/// The exact cost vector of one candidate on one instance.
///
/// Every field is measured or exactly counted; nothing here is an estimate.
/// The weighted objective is computed from this vector by [`UsageWeights`], and
/// the raw vector is reported so a different weighting can be applied later.
#[repr(C, align(64))]
#[derive(Clone, Copy, Debug, Default, PartialEq, Serialize)]
pub struct CostVector {
    /// Header plus payload plus precondition tables.
    pub encoded_bytes: u64,
    /// Reference cycles for one full encode, excluding preconditions.
    pub encode_cycles: u64,
    /// Reference cycles for one full decode into a presized buffer.
    pub decode_cycles: u64,
    /// Reference cycles per random-access probe, in 16.16 fixed point.
    pub probe_cycles_q16: u64,
    /// Reference cycles to build every precondition the encoder requires.
    pub precondition_cycles: u64,
    /// Peak caller-owned working bytes touched during encode and decode,
    /// excluding the encoded image itself.
    pub peak_working_bytes: u64,
    /// One unit per grammar node.
    pub syntax_cost: u32,
    _padding0: u32,
    _padding1: [u8; 8],
}

const _: () = assert!(std::mem::size_of::<CostVector>() == 64);
const _: () = assert!(std::mem::align_of::<CostVector>() == 64);

impl CostVector {
    pub fn new(
        encoded_bytes: u64,
        encode_cycles: u64,
        decode_cycles: u64,
        probe_cycles_q16: u64,
        precondition_cycles: u64,
        peak_working_bytes: u64,
        syntax_cost: u32,
    ) -> Self {
        Self {
            encoded_bytes,
            encode_cycles,
            decode_cycles,
            probe_cycles_q16,
            precondition_cycles,
            peak_working_bytes,
            syntax_cost,
            _padding0: 0,
            _padding1: [0; 8],
        }
    }

    pub fn probe_cycles(&self) -> f64 {
        self.probe_cycles_q16 as f64 / 65_536.0
    }
}

/// How often each operation runs in the real usage of one observation family.
///
/// These are declared usage frequencies, not tuning knobs: they say how many
/// times per materialized structure each operation actually executes in the
/// core, and they are stated per observation type in the task report.
#[derive(Clone, Copy, Debug, PartialEq, Serialize)]
pub struct UsageWeights {
    /// Cost, in weighted units, charged per byte of declared space.
    pub bytes: f64,
    /// Encodes per materialization.
    pub encodes: f64,
    /// Full decodes per materialization.
    pub decodes: f64,
    /// Random-access probes per materialization.
    pub probes: f64,
    /// Precondition builds per materialization.
    pub preconditions: f64,
    /// Cost charged per byte of peak working memory.
    pub working_bytes: f64,
    /// Cost charged per grammar node, breaking ties toward simpler pipelines.
    pub syntax: f64,
}

impl UsageWeights {
    /// The declared usage profile of one observation family.
    pub fn for_kind(kind: ObservationKind, elements: usize) -> Self {
        let n = elements.max(1) as f64;
        match kind {
            // A reachability row is written once per item and then probed
            // once per surviving state during the backward witness replay,
            // which walks the row once per element. It is never fully decoded.
            ObservationKind::DenseBitmap => Self {
                bytes: 1.0,
                encodes: 1.0,
                decodes: 0.0,
                probes: n,
                preconditions: 1.0,
                working_bytes: 1.0,
                syntax: 8.0,
            },
            // A certificate id array is encoded once when the evidence file is
            // written and decoded once at replay. It is not probed.
            ObservationKind::SortedIds => Self {
                bytes: 1.0,
                encodes: 1.0,
                decodes: 1.0,
                probes: 0.0,
                preconditions: 1.0,
                working_bytes: 1.0,
                syntax: 8.0,
            },
            // A witness vector is built once and then read by index many times
            // during span replay.
            ObservationKind::SmallIntVector => Self {
                bytes: 1.0,
                encodes: 1.0,
                decodes: 0.0,
                probes: n,
                preconditions: 1.0,
                working_bytes: 1.0,
                syntax: 8.0,
            },
        }
    }

    /// The declared scalar objective. Lower is better.
    ///
    /// Space and compute are combined in one currency by charging one weighted
    /// unit per byte and one weighted unit per reference cycle; the weights
    /// above convert per-operation cost into cost per materialized structure.
    pub fn objective(&self, cost: &CostVector) -> f64 {
        self.bytes * cost.encoded_bytes as f64
            + self.working_bytes * cost.peak_working_bytes as f64
            + self.encodes * cost.encode_cycles as f64
            + self.decodes * cost.decode_cycles as f64
            + self.probes * cost.probe_cycles()
            + self.preconditions * cost.precondition_cycles as f64
            + self.syntax * f64::from(cost.syntax_cost)
    }
}

/// Caller-owned presized storage for every encode, decode, probe, and
/// precondition path. Nothing in those paths allocates.
#[derive(Clone, Debug)]
pub struct ReprWorkspace {
    stage: Box<[i64]>,
    decoded: Box<[i64]>,
    payload: Box<[u8]>,
    directory: Box<[u32]>,
    max_elements: usize,
}

impl ReprWorkspace {
    /// Presize for the largest observation and the largest payload the grammar
    /// can produce for it.
    pub fn new(max_elements: usize, max_universe: usize) -> Self {
        // The loosest serializer is `Fixed64` at eight bytes per element; the
        // loosest membership serializer is `BitPack` over the whole universe.
        let payload = (16 * max_elements + max_universe / 8 + 4096).max(4096);
        let directory = (2 * max_elements + max_universe / 64 + 1024).max(1024);
        Self {
            stage: vec![0; max_elements + 1].into_boxed_slice(),
            decoded: vec![0; max_elements + 1].into_boxed_slice(),
            payload: vec![0; payload].into_boxed_slice(),
            directory: vec![0; directory].into_boxed_slice(),
            max_elements,
        }
    }

    pub fn max_elements(&self) -> usize {
        self.max_elements
    }

    /// Peak caller-owned working bytes, excluding the encoded image.
    pub fn working_bytes(&self, elements: usize) -> u64 {
        8 * (elements as u64 + 1) * 2
    }

    pub fn decoded(&self) -> &[i64] {
        &self.decoded
    }

    pub fn payload(&self) -> &[u8] {
        &self.payload
    }

    pub fn directory(&self) -> &[u32] {
        &self.directory
    }
}

/// Why a pipeline does not apply to an observation.
#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize)]
#[serde(rename_all = "kebab-case")]
pub enum EncodeError {
    /// The observation exceeds the workspace element cap.
    Capacity,
    /// The serializer requires nonnegative values and saw a negative one.
    NegativeValue,
    /// Elias-Fano or bitpack requires a nondecreasing sequence.
    NotMonotone,
    /// Bitpack requires a strictly increasing membership sequence.
    NotASet,
    /// The encoded image would exceed the presized payload or directory.
    PayloadOverflow,
    /// The sequence is empty and the serializer has no empty form.
    Empty,
    /// A canonical permutation was applied to an order-bearing family.
    OrderNotFree,
}

/// A compiled encoder image: the header plus the lengths of the caller-owned
/// payload and directory it wrote.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct EncodedImage {
    pub header: EncodedHeader,
    pub precondition_cycles: u64,
}

/// One probe request.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ProbeQuery {
    /// Membership families.
    Contains(i64),
    /// The vector family.
    Get(u32),
}

/// One probe answer, compared exactly against the reference observation.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub enum ProbeAnswer {
    Present(bool),
    Value(Option<i64>),
}

// ---------------------------------------------------------------------------
// Encoding
// ---------------------------------------------------------------------------

/// Apply the pipeline to `observation`, writing the payload and any
/// precondition table into `workspace`.
///
/// Allocation-free: the staging vector, payload, and directory are all
/// caller-owned presized buffers.
pub fn encode(
    pipeline: &Pipeline,
    observation: &Observation,
    workspace: &mut ReprWorkspace,
) -> Result<EncodedImage, EncodeError> {
    let count = observation.len();
    if count > workspace.max_elements {
        return Err(EncodeError::Capacity);
    }
    if count == 0 {
        return Err(EncodeError::Empty);
    }
    workspace.stage[..count].copy_from_slice(observation.values());

    let mut base = 0_i64;
    for &step in pipeline.transforms() {
        match step {
            Transform::WindowClip => {
                let minimum = workspace.stage[..count].iter().copied().min().unwrap_or(0);
                base = minimum;
                for value in &mut workspace.stage[..count] {
                    *value -= minimum;
                }
            }
            Transform::Delta => {
                for index in (1..count).rev() {
                    workspace.stage[index] -= workspace.stage[index - 1];
                }
            }
            Transform::Zigzag => {
                for value in &mut workspace.stage[..count] {
                    *value = zigzag(*value);
                }
            }
            Transform::CanonicalPermutation => {
                if !observation.kind().order_free() {
                    return Err(EncodeError::OrderNotFree);
                }
                workspace.stage[..count].sort_unstable();
            }
        }
    }

    let (payload_bytes, directory_entries, bit_width, precondition_cycles) =
        serialize(pipeline.serializer(), count, workspace)?;

    let mut flags = 0_u8;
    if pipeline.pointwise_inverse() {
        flags |= 1;
    }
    if directory_entries > 0 {
        flags |= 2;
    }
    let header = EncodedHeader {
        base,
        element_count: count as u32,
        universe: observation.universe() as u32,
        payload_bytes: payload_bytes as u32,
        directory_entries: directory_entries as u32,
        bit_width,
        kind: observation.kind() as u8,
        serializer: pipeline.serializer() as u8,
        transform_count: pipeline.transforms().len() as u8,
        flags,
        _padding: [0; 35],
    };
    Ok(EncodedImage {
        header,
        precondition_cycles,
    })
}

fn serialize(
    serializer: Serializer,
    count: usize,
    workspace: &mut ReprWorkspace,
) -> Result<(usize, usize, u8, u64), EncodeError> {
    let stage = &workspace.stage[..count];
    if stage.iter().any(|&value| value < 0)
        && !matches!(serializer, Serializer::Fixed64 | Serializer::Dictionary)
    {
        return Err(EncodeError::NegativeValue);
    }
    match serializer {
        Serializer::Fixed64 => {
            let bytes = 8 * count;
            if bytes > workspace.payload.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            for (index, &value) in stage.iter().enumerate() {
                workspace.payload[8 * index..8 * index + 8].copy_from_slice(&value.to_le_bytes());
            }
            Ok((bytes, 0, 64, 0))
        }
        Serializer::Narrow => {
            let maximum = stage.iter().copied().max().unwrap_or(0);
            let width = bit_width_for(maximum as u64);
            let bytes = (count * usize::from(width)).div_ceil(8);
            if bytes > workspace.payload.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            workspace.payload[..bytes].fill(0);
            for (index, &value) in stage.iter().enumerate() {
                write_bits(
                    &mut workspace.payload,
                    index * usize::from(width),
                    width,
                    value as u64,
                );
            }
            Ok((bytes, 0, width, 0))
        }
        Serializer::Varint => {
            let mut offset = 0_usize;
            for &value in stage {
                let mut remaining = value as u64;
                loop {
                    if offset == workspace.payload.len() {
                        return Err(EncodeError::PayloadOverflow);
                    }
                    let byte = (remaining & 0x7f) as u8;
                    remaining >>= 7;
                    workspace.payload[offset] = if remaining == 0 { byte } else { byte | 0x80 };
                    offset += 1;
                    if remaining == 0 {
                        break;
                    }
                }
            }
            Ok((offset, 0, 8, 0))
        }
        Serializer::EliasFano => {
            if stage.windows(2).any(|pair| pair[0] > pair[1]) {
                return Err(EncodeError::NotMonotone);
            }
            let upper = stage.last().copied().unwrap_or(0) as u64 + 1;
            let low_width = elias_fano_low_width(upper, count);
            let low_bits = count * usize::from(low_width);
            let high_bits = count + (upper >> low_width) as usize + 1;
            let bytes = low_bits.div_ceil(8) + high_bits.div_ceil(8);
            if bytes > workspace.payload.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            workspace.payload[..bytes].fill(0);
            let high_offset = low_bits.div_ceil(8);
            for (index, &value) in stage.iter().enumerate() {
                let value = value as u64;
                if low_width > 0 {
                    write_bits(
                        &mut workspace.payload,
                        index * usize::from(low_width),
                        low_width,
                        value & ((1 << low_width) - 1),
                    );
                }
                let bucket = (value >> low_width) as usize;
                let bit = bucket + index;
                workspace.payload[high_offset + bit / 8] |= 1 << (bit % 8);
            }
            // Precondition table: a rank directory over the high bitvector, one
            // prefix popcount per byte. Built once, outside every probe.
            let started = reference_cycles();
            let high_bytes = high_bits.div_ceil(8);
            let entries = high_bytes + 1;
            if entries > workspace.directory.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            let mut running = 0_u32;
            for byte in 0..high_bytes {
                workspace.directory[byte] = running;
                running += workspace.payload[high_offset + byte].count_ones();
            }
            workspace.directory[high_bytes] = running;
            let precondition_cycles = reference_cycles().saturating_sub(started);
            Ok((bytes, entries, low_width, precondition_cycles))
        }
        Serializer::RunLength => {
            let mut offset = 0_usize;
            let mut index = 0_usize;
            while index < count {
                let value = stage[index];
                let mut run = 1_usize;
                while index + run < count && stage[index + run] == value {
                    run += 1;
                }
                if offset + 12 > workspace.payload.len() {
                    return Err(EncodeError::PayloadOverflow);
                }
                workspace.payload[offset..offset + 8].copy_from_slice(&value.to_le_bytes());
                workspace.payload[offset + 8..offset + 12]
                    .copy_from_slice(&(run as u32).to_le_bytes());
                offset += 12;
                index += run;
            }
            Ok((offset, 0, 64, 0))
        }
        Serializer::BitPack => {
            if stage.windows(2).any(|pair| pair[0] >= pair[1]) {
                return Err(EncodeError::NotASet);
            }
            let extent = stage.last().copied().unwrap_or(0) as usize + 1;
            let bytes = extent.div_ceil(8);
            if bytes > workspace.payload.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            workspace.payload[..bytes].fill(0);
            for &value in stage {
                let value = value as usize;
                workspace.payload[value / 8] |= 1 << (value % 8);
            }
            Ok((bytes, 0, 1, 0))
        }
        Serializer::Dictionary => {
            let blocks = count.div_ceil(DICTIONARY_BLOCK);
            let table_slots = (2 * blocks).next_power_of_two();
            if table_slots > workspace.directory.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            // Precondition: open-addressing hash-consing of distinct blocks,
            // built once into the caller-owned directory buffer.
            let started = reference_cycles();
            workspace.directory[..table_slots].fill(u32::MAX);
            let mut distinct = 0_usize;
            let index_offset = 32 * blocks;
            if index_offset + 4 * blocks > workspace.payload.len() {
                return Err(EncodeError::PayloadOverflow);
            }
            for block in 0..blocks {
                let mut key = [0_i64; DICTIONARY_BLOCK];
                for (slot, entry) in key.iter_mut().enumerate() {
                    let position = block * DICTIONARY_BLOCK + slot;
                    *entry = if position < count { stage[position] } else { 0 };
                }
                let mut probe = (block_hash(&key) as usize) & (table_slots - 1);
                let assigned = loop {
                    let candidate = workspace.directory[probe];
                    if candidate == u32::MAX {
                        workspace.directory[probe] = distinct as u32;
                        for (slot, &entry) in key.iter().enumerate() {
                            let at = 32 * distinct + 8 * slot;
                            workspace.payload[at..at + 8].copy_from_slice(&entry.to_le_bytes());
                        }
                        distinct += 1;
                        break distinct as u32 - 1;
                    }
                    let at = 32 * candidate as usize;
                    let stored = read_block(&workspace.payload[at..at + 32]);
                    if stored == key {
                        break candidate;
                    }
                    probe = (probe + 1) & (table_slots - 1);
                };
                let at = index_offset + 4 * block;
                workspace.payload[at..at + 4].copy_from_slice(&assigned.to_le_bytes());
            }
            let precondition_cycles = reference_cycles().saturating_sub(started);
            // Compact: the index stream moves down behind the realized table.
            let table_bytes = 32 * distinct;
            workspace
                .payload
                .copy_within(index_offset..index_offset + 4 * blocks, table_bytes);
            Ok((
                table_bytes + 4 * blocks,
                table_slots,
                64,
                precondition_cycles,
            ))
        }
    }
}

// ---------------------------------------------------------------------------
// Decoding
// ---------------------------------------------------------------------------

/// Fully materialize the encoded image back into `workspace.decoded`.
///
/// Allocation-free over caller-owned presized buffers.
pub fn decode(
    pipeline: &Pipeline,
    image: &EncodedImage,
    workspace: &mut ReprWorkspace,
) -> Result<usize, EncodeError> {
    let header = image.header;
    let count = header.element_count as usize;
    if count > workspace.decoded.len() {
        return Err(EncodeError::Capacity);
    }
    deserialize(pipeline.serializer(), &header, workspace)?;
    // Inverse transforms in reverse order.
    for &step in pipeline.transforms().iter().rev() {
        match step {
            Transform::WindowClip => {
                for value in &mut workspace.decoded[..count] {
                    *value += header.base;
                }
            }
            Transform::Delta => {
                for index in 1..count {
                    workspace.decoded[index] += workspace.decoded[index - 1];
                }
            }
            Transform::Zigzag => {
                for value in &mut workspace.decoded[..count] {
                    *value = unzigzag(*value);
                }
            }
            Transform::CanonicalPermutation => {}
        }
    }
    Ok(count)
}

fn deserialize(
    serializer: Serializer,
    header: &EncodedHeader,
    workspace: &mut ReprWorkspace,
) -> Result<(), EncodeError> {
    let count = header.element_count as usize;
    match serializer {
        Serializer::Fixed64 => {
            for index in 0..count {
                let at = 8 * index;
                workspace.decoded[index] =
                    i64::from_le_bytes(workspace.payload[at..at + 8].try_into().unwrap());
            }
        }
        Serializer::Narrow => {
            let width = header.bit_width;
            for index in 0..count {
                workspace.decoded[index] =
                    read_bits(&workspace.payload, index * usize::from(width), width) as i64;
            }
        }
        Serializer::Varint => {
            let mut offset = 0_usize;
            for index in 0..count {
                let mut value = 0_u64;
                let mut shift = 0_u32;
                loop {
                    let byte = workspace.payload[offset];
                    offset += 1;
                    value |= u64::from(byte & 0x7f) << shift;
                    shift += 7;
                    if byte & 0x80 == 0 {
                        break;
                    }
                }
                workspace.decoded[index] = value as i64;
            }
        }
        Serializer::EliasFano => {
            let low_width = header.bit_width;
            let low_bits = count * usize::from(low_width);
            let high_offset = low_bits.div_ceil(8);
            let high_bytes = header.payload_bytes as usize - high_offset;
            let mut index = 0_usize;
            let mut ones = 0_usize;
            for byte in 0..high_bytes {
                let mut word = workspace.payload[high_offset + byte];
                while word != 0 {
                    let bit = word.trailing_zeros() as usize;
                    word &= word - 1;
                    let bucket = (byte * 8 + bit) - ones;
                    let low = if low_width > 0 {
                        read_bits(
                            &workspace.payload,
                            index * usize::from(low_width),
                            low_width,
                        )
                    } else {
                        0
                    };
                    workspace.decoded[index] = (((bucket as u64) << low_width) | low) as i64;
                    ones += 1;
                    index += 1;
                    if index == count {
                        break;
                    }
                }
                if index == count {
                    break;
                }
            }
        }
        Serializer::RunLength => {
            let mut offset = 0_usize;
            let mut index = 0_usize;
            while index < count {
                let value =
                    i64::from_le_bytes(workspace.payload[offset..offset + 8].try_into().unwrap());
                let run = u32::from_le_bytes(
                    workspace.payload[offset + 8..offset + 12]
                        .try_into()
                        .unwrap(),
                ) as usize;
                for slot in 0..run {
                    workspace.decoded[index + slot] = value;
                }
                index += run;
                offset += 12;
            }
        }
        Serializer::BitPack => {
            let bytes = header.payload_bytes as usize;
            let mut index = 0_usize;
            for byte in 0..bytes {
                let mut word = workspace.payload[byte];
                while word != 0 {
                    let bit = word.trailing_zeros() as usize;
                    word &= word - 1;
                    workspace.decoded[index] = (byte * 8 + bit) as i64;
                    index += 1;
                }
            }
        }
        Serializer::Dictionary => {
            let blocks = count.div_ceil(DICTIONARY_BLOCK);
            let table_bytes = header.payload_bytes as usize - 4 * blocks;
            for block in 0..blocks {
                let at = table_bytes + 4 * block;
                let entry =
                    u32::from_le_bytes(workspace.payload[at..at + 4].try_into().unwrap()) as usize;
                for slot in 0..DICTIONARY_BLOCK {
                    let position = block * DICTIONARY_BLOCK + slot;
                    if position >= count {
                        break;
                    }
                    let from = 32 * entry + 8 * slot;
                    workspace.decoded[position] =
                        i64::from_le_bytes(workspace.payload[from..from + 8].try_into().unwrap());
                }
            }
        }
    }
    Ok(())
}

// ---------------------------------------------------------------------------
// Probing
// ---------------------------------------------------------------------------

/// Answer one probe against the encoded image, without decoding the whole
/// structure when the pipeline compiles to a random-access probe.
///
/// Reads only the fixed [`EncodedHeader`] record and the caller-owned payload
/// and directory slices. Allocation-free; no owned container is constructed.
pub fn probe(
    pipeline: &Pipeline,
    image: &EncodedImage,
    workspace: &ReprWorkspace,
    query: ProbeQuery,
) -> ProbeAnswer {
    let header = image.header;
    let count = header.element_count as usize;
    match (pipeline.probe_class(), query) {
        (ProbeClass::RandomAccess, ProbeQuery::Contains(target)) => {
            // Transform the query forward into the stored domain rather than
            // inverting every stored element. Valid because every pointwise
            // transform in the grammar is monotone on the encoded range.
            let shifted = apply_pointwise_forward(pipeline, &header, target);
            match pipeline.serializer() {
                Serializer::BitPack => {
                    if shifted < 0 {
                        return ProbeAnswer::Present(false);
                    }
                    let index = shifted as usize;
                    let byte = index / 8;
                    if byte >= header.payload_bytes as usize {
                        return ProbeAnswer::Present(false);
                    }
                    ProbeAnswer::Present(workspace.payload[byte] & (1 << (index % 8)) != 0)
                }
                Serializer::Fixed64 => {
                    ProbeAnswer::Present(binary_search_fixed(workspace, count, shifted))
                }
                Serializer::Narrow => ProbeAnswer::Present(binary_search_narrow(
                    workspace,
                    count,
                    header.bit_width,
                    shifted,
                )),
                Serializer::EliasFano => {
                    ProbeAnswer::Present(elias_fano_contains(workspace, &header, shifted))
                }
                _ => ProbeAnswer::Present(false),
            }
        }
        (ProbeClass::RandomAccess, ProbeQuery::Get(index)) => {
            let index = index as usize;
            if index >= count {
                return ProbeAnswer::Value(None);
            }
            let raw = match pipeline.serializer() {
                Serializer::Fixed64 => i64::from_le_bytes(
                    workspace.payload[8 * index..8 * index + 8]
                        .try_into()
                        .unwrap(),
                ),
                Serializer::Narrow => read_bits(
                    &workspace.payload,
                    index * usize::from(header.bit_width),
                    header.bit_width,
                ) as i64,
                _ => return ProbeAnswer::Value(None),
            };
            ProbeAnswer::Value(Some(apply_pointwise_inverse(pipeline, &header, raw)))
        }
        (ProbeClass::Streaming, query) => streaming_probe(pipeline, &header, workspace, query),
    }
}

/// Map a membership query into the stored domain by replaying the pipeline's
/// pointwise transforms forward.
fn apply_pointwise_forward(pipeline: &Pipeline, header: &EncodedHeader, mut value: i64) -> i64 {
    for &step in pipeline.transforms() {
        match step {
            Transform::WindowClip => value -= header.base,
            Transform::Zigzag => value = zigzag(value),
            Transform::Delta | Transform::CanonicalPermutation => {}
        }
    }
    value
}

fn apply_pointwise_inverse(pipeline: &Pipeline, header: &EncodedHeader, mut value: i64) -> i64 {
    for &step in pipeline.transforms().iter().rev() {
        match step {
            Transform::WindowClip => value += header.base,
            Transform::Zigzag => value = unzigzag(value),
            Transform::Delta | Transform::CanonicalPermutation => {}
        }
    }
    value
}

/// Sequential decode with early exit. Uses no scratch beyond three registers,
/// so it neither allocates nor writes the caller's decode buffer.
fn streaming_probe(
    pipeline: &Pipeline,
    header: &EncodedHeader,
    workspace: &ReprWorkspace,
    query: ProbeQuery,
) -> ProbeAnswer {
    let count = header.element_count as usize;
    let has_delta = pipeline.transforms().contains(&Transform::Delta);
    let mut cursor = SerialCursor::new(pipeline.serializer(), header);
    let mut running = 0_i64;
    for index in 0..count {
        let raw = cursor.next(workspace, header);
        // Inverse chain, streamed in reverse order of application.
        let mut value = raw;
        for &step in pipeline.transforms().iter().rev() {
            match step {
                Transform::WindowClip => value += header.base,
                Transform::Zigzag => value = unzigzag(value),
                Transform::Delta => {
                    running += value;
                    value = running;
                }
                Transform::CanonicalPermutation => {}
            }
        }
        if !has_delta {
            running = value;
        }
        match query {
            ProbeQuery::Contains(target) => {
                if value == target {
                    return ProbeAnswer::Present(true);
                }
                // Membership sequences are increasing after the inverse chain.
                if value > target {
                    return ProbeAnswer::Present(false);
                }
            }
            ProbeQuery::Get(wanted) => {
                if index == wanted as usize {
                    return ProbeAnswer::Value(Some(value));
                }
            }
        }
    }
    match query {
        ProbeQuery::Contains(_) => ProbeAnswer::Present(false),
        ProbeQuery::Get(_) => ProbeAnswer::Value(None),
    }
}

/// A sequential reader over one serializer's payload. Plain data, no owned
/// container, no pointer chasing: it holds byte offsets into the caller's
/// payload slice.
#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct SerialCursor {
    byte_offset: u32,
    bit_offset: u32,
    run_value: i64,
    run_left: u32,
    ones: u32,
    index: u32,
    serializer: u8,
    _padding: [u8; 7],
}

const _: () = assert!(std::mem::size_of::<SerialCursor>() == 40);

impl SerialCursor {
    fn new(serializer: Serializer, header: &EncodedHeader) -> Self {
        let bit_offset = match serializer {
            Serializer::EliasFano => {
                8 * (header.element_count as usize * usize::from(header.bit_width)).div_ceil(8)
                    as u32
            }
            _ => 0,
        };
        Self {
            byte_offset: 0,
            bit_offset,
            run_value: 0,
            run_left: 0,
            ones: 0,
            index: 0,
            serializer: serializer as u8,
            _padding: [0; 7],
        }
    }

    fn next(&mut self, workspace: &ReprWorkspace, header: &EncodedHeader) -> i64 {
        let payload = &workspace.payload;
        let value = match self.serializer {
            x if x == Serializer::Fixed64 as u8 => {
                let at = self.byte_offset as usize;
                self.byte_offset += 8;
                i64::from_le_bytes(payload[at..at + 8].try_into().unwrap())
            }
            x if x == Serializer::Narrow as u8 => {
                let at = self.bit_offset as usize;
                self.bit_offset += u32::from(header.bit_width);
                read_bits(payload, at, header.bit_width) as i64
            }
            x if x == Serializer::Varint as u8 => {
                let mut value = 0_u64;
                let mut shift = 0_u32;
                loop {
                    let byte = payload[self.byte_offset as usize];
                    self.byte_offset += 1;
                    value |= u64::from(byte & 0x7f) << shift;
                    shift += 7;
                    if byte & 0x80 == 0 {
                        break;
                    }
                }
                value as i64
            }
            x if x == Serializer::RunLength as u8 => {
                if self.run_left == 0 {
                    let at = self.byte_offset as usize;
                    self.run_value = i64::from_le_bytes(payload[at..at + 8].try_into().unwrap());
                    self.run_left =
                        u32::from_le_bytes(payload[at + 8..at + 12].try_into().unwrap());
                    self.byte_offset += 12;
                }
                self.run_left -= 1;
                self.run_value
            }
            x if x == Serializer::BitPack as u8 => {
                let mut bit = self.bit_offset as usize;
                let bytes = header.payload_bytes as usize;
                loop {
                    if bit / 8 >= bytes {
                        break;
                    }
                    if payload[bit / 8] & (1 << (bit % 8)) != 0 {
                        break;
                    }
                    bit += 1;
                }
                self.bit_offset = bit as u32 + 1;
                bit as i64
            }
            x if x == Serializer::EliasFano as u8 => {
                let low_width = header.bit_width;
                let high_offset =
                    (header.element_count as usize * usize::from(low_width)).div_ceil(8);
                let mut bit = self.bit_offset as usize - 8 * high_offset;
                loop {
                    if payload[high_offset + bit / 8] & (1 << (bit % 8)) != 0 {
                        break;
                    }
                    bit += 1;
                }
                let bucket = bit - self.ones as usize;
                self.ones += 1;
                self.bit_offset = (8 * high_offset + bit + 1) as u32;
                let low = if low_width > 0 {
                    read_bits(
                        payload,
                        self.index as usize * usize::from(low_width),
                        low_width,
                    )
                } else {
                    0
                };
                (((bucket as u64) << low_width) | low) as i64
            }
            _ => {
                // Dictionary: an indexed block read, sequentially walked.
                let blocks = (header.element_count as usize).div_ceil(DICTIONARY_BLOCK);
                let table_bytes = header.payload_bytes as usize - 4 * blocks;
                let position = self.index as usize;
                let at = table_bytes + 4 * (position / DICTIONARY_BLOCK);
                let entry = u32::from_le_bytes(payload[at..at + 4].try_into().unwrap()) as usize;
                let from = 32 * entry + 8 * (position % DICTIONARY_BLOCK);
                i64::from_le_bytes(payload[from..from + 8].try_into().unwrap())
            }
        };
        self.index += 1;
        value
    }
}

fn binary_search_fixed(workspace: &ReprWorkspace, count: usize, target: i64) -> bool {
    let mut low = 0_usize;
    let mut high = count;
    while low < high {
        let middle = (low + high) / 2;
        let at = 8 * middle;
        let value = i64::from_le_bytes(workspace.payload[at..at + 8].try_into().unwrap());
        match value.cmp(&target) {
            Ordering::Equal => return true,
            Ordering::Less => low = middle + 1,
            Ordering::Greater => high = middle,
        }
    }
    false
}

fn binary_search_narrow(workspace: &ReprWorkspace, count: usize, width: u8, target: i64) -> bool {
    if target < 0 {
        return false;
    }
    let mut low = 0_usize;
    let mut high = count;
    while low < high {
        let middle = (low + high) / 2;
        let value = read_bits(&workspace.payload, middle * usize::from(width), width) as i64;
        match value.cmp(&target) {
            Ordering::Equal => return true,
            Ordering::Less => low = middle + 1,
            Ordering::Greater => high = middle,
        }
    }
    false
}

fn elias_fano_contains(workspace: &ReprWorkspace, header: &EncodedHeader, target: i64) -> bool {
    if target < 0 {
        return false;
    }
    let count = header.element_count as usize;
    let low_width = header.bit_width;
    let high_offset = (count * usize::from(low_width)).div_ceil(8);
    let high_bytes = header.payload_bytes as usize - high_offset;
    let bucket = (target as u64 >> low_width) as usize;
    let low = target as u64 & ((1_u64 << low_width) - 1);
    // The rank directory turns "find the bucket" into a byte-level binary
    // search plus one in-byte scan, instead of a linear walk of the unary
    // high bitvector.
    let mut low_byte = 0_usize;
    let mut high_byte = high_bytes;
    while low_byte < high_byte {
        let middle = (low_byte + high_byte) / 2;
        // Zeros before this byte boundary give the bucket index reached.
        let zeros = middle * 8 - workspace.directory[middle] as usize;
        if zeros <= bucket {
            low_byte = middle + 1;
        } else {
            high_byte = middle;
        }
    }
    let start_byte = low_byte.saturating_sub(1);
    let mut zeros = start_byte * 8 - workspace.directory[start_byte] as usize;
    let mut index = workspace.directory[start_byte] as usize;
    let mut bit = start_byte * 8;
    while bit < high_bytes * 8 && index < count {
        if workspace.payload[high_offset + bit / 8] & (1 << (bit % 8)) != 0 {
            if zeros == bucket {
                let stored = if low_width > 0 {
                    read_bits(
                        &workspace.payload,
                        index * usize::from(low_width),
                        low_width,
                    )
                } else {
                    0
                };
                if stored == low {
                    return true;
                }
                if stored > low {
                    return false;
                }
            } else if zeros > bucket {
                return false;
            }
            index += 1;
        } else {
            zeros += 1;
            if zeros > bucket {
                return false;
            }
        }
        bit += 1;
    }
    false
}

/// Answer a whole probe schedule with the representation dispatched once,
/// outside the loop, as the core performance contract requires.
///
/// This is the path the scorer measures. For a type-carried candidate the
/// dispatch selects a monomorphization in which the field width is a compile-
/// time constant, so the shift, the mask, and the element stride are folded and
/// no descriptor is loaded at all.
pub fn probe_batch(
    pipeline: &Pipeline,
    image: &EncodedImage,
    workspace: &ReprWorkspace,
    queries: &[ProbeQuery],
    answers: &mut [ProbeAnswer],
) {
    let header = image.header;
    let count = header.element_count as usize;
    if pipeline.descriptor() == Descriptor::TypeCarried
        && pipeline.serializer() == Serializer::Narrow
        && pipeline.probe_class() == ProbeClass::RandomAccess
    {
        let width = header.bit_width;
        for (query, answer) in queries.iter().zip(answers.iter_mut()) {
            *answer = match *query {
                ProbeQuery::Contains(target) => {
                    let shifted = apply_pointwise_forward(pipeline, &header, target);
                    ProbeAnswer::Present(type_level::narrow_contains_dispatch(
                        &workspace.payload,
                        count,
                        width,
                        shifted,
                    ))
                }
                ProbeQuery::Get(index) => {
                    if index as usize >= count {
                        ProbeAnswer::Value(None)
                    } else {
                        let raw = type_level::narrow_get_dispatch(
                            &workspace.payload,
                            index as usize,
                            width,
                        ) as i64;
                        ProbeAnswer::Value(Some(apply_pointwise_inverse(pipeline, &header, raw)))
                    }
                }
            };
        }
        return;
    }
    for (query, answer) in queries.iter().zip(answers.iter_mut()) {
        *answer = probe(pipeline, image, workspace, *query);
    }
}

// ---------------------------------------------------------------------------
// Type-level representations
// ---------------------------------------------------------------------------

/// Representations whose information lives in the type rather than in a stored
/// field, and the runtime work each one removes.
///
/// The precedent in the public core is `ergodis::field::Prime<P>`: the modulus
/// is a const-generic parameter of the `FiniteField` implementation, so every
/// arithmetic call is statically dispatched and no modulus is loaded or
/// branched on inside a kernel. The items here apply the same move to encoder
/// shape data, and each states exactly which field or check it removes.
pub mod type_level {
    use std::marker::PhantomData;
    use std::num::NonZeroU32;

    /// The whole descriptor of an encoded structure packed into one machine
    /// word with typed accessors.
    ///
    /// Replaces the 64-byte [`super::EncodedHeader`] on the probe path.
    /// Removes: a cache line of per-structure metadata and four separate field
    /// loads, at the price of one shift and mask per accessor.
    ///
    /// Layout: `base` in bits 0-23, `element_count` in bits 24-45,
    /// `payload_bytes` in bits 46-63 is not representable, so the packing
    /// carries `base`, `element_count`, and `bit_width` only; the payload
    /// length is a property of the slice the consumer already holds.
    #[repr(transparent)]
    #[derive(Clone, Copy, Debug, Eq, PartialEq)]
    pub struct PackedDescriptor(u64);

    const _: () = assert!(std::mem::size_of::<PackedDescriptor>() == 8);
    const _: () = assert!(std::mem::align_of::<PackedDescriptor>() == 8);

    impl PackedDescriptor {
        const BASE_BITS: u32 = 32;
        const COUNT_BITS: u32 = 25;

        pub fn new(base: u32, element_count: u32, bit_width: u8) -> Option<Self> {
            if element_count >= 1 << Self::COUNT_BITS || u32::from(bit_width) > 64 {
                return None;
            }
            Some(Self(
                u64::from(base)
                    | (u64::from(element_count) << Self::BASE_BITS)
                    | (u64::from(bit_width) << (Self::BASE_BITS + Self::COUNT_BITS)),
            ))
        }

        #[inline]
        pub fn base(self) -> u32 {
            self.0 as u32
        }

        #[inline]
        pub fn element_count(self) -> u32 {
            ((self.0 >> Self::BASE_BITS) & ((1 << Self::COUNT_BITS) - 1)) as u32
        }

        #[inline]
        pub fn bit_width(self) -> u8 {
            (self.0 >> (Self::BASE_BITS + Self::COUNT_BITS)) as u8
        }
    }

    /// A niche-optimized element index.
    ///
    /// Removes: the separate presence byte or sentinel comparison that an
    /// `Option<u32>` slot would need. The public core stores absent indices as
    /// explicit sentinels and has no `NonZero` type anywhere, so `Option<Slot>`
    /// is an unexploited free byte-for-byte win wherever an optional index is
    /// stored in a hot record.
    #[repr(transparent)]
    #[derive(Clone, Copy, Debug, Eq, PartialEq)]
    pub struct Slot(NonZeroU32);

    const _: () = assert!(std::mem::size_of::<Option<Slot>>() == 4);
    const _: () = assert!(std::mem::size_of::<Option<u32>>() == 8);

    impl Slot {
        pub fn new(index: u32) -> Option<Self> {
            NonZeroU32::new(index.wrapping_add(1)).map(Self)
        }

        pub fn index(self) -> u32 {
            self.0.get() - 1
        }
    }

    /// A residue whose modulus lives in the type, in the style of the core's
    /// `Prime<P>`.
    ///
    /// Removes: the stored modulus field and the runtime bound check on it. The
    /// reduction is a compile-time constant, so `add` compiles to an add, a
    /// compare against a literal, and a conditional subtract.
    #[repr(transparent)]
    #[derive(Clone, Copy, Debug, Eq, PartialEq)]
    pub struct Residue<const Q: u8>(u8);

    const _: () = assert!(std::mem::size_of::<Residue<7>>() == 1);

    impl<const Q: u8> Residue<Q> {
        pub fn new(value: u8) -> Option<Self> {
            (value < Q).then_some(Self(value))
        }

        #[inline]
        pub fn add_residue(self, other: Self) -> Self {
            let sum = self.0 + other.0;
            Self(if sum >= Q { sum - Q } else { sum })
        }

        pub fn get(self) -> u8 {
            self.0
        }
    }

    /// A fixed-arity slot set whose length lives in the type.
    ///
    /// Removes: the length field and every bounds check on a constant index.
    /// `PhantomData<Order>` carries the proof that the slots are in canonical
    /// order, so the consumer needs no runtime sortedness check.
    #[repr(C)]
    #[derive(Clone, Copy, Debug, Eq, PartialEq)]
    pub struct FixedSlots<T, Order, const N: usize> {
        pub slots: [T; N],
        _order: PhantomData<Order>,
    }

    /// Witness type for "the slots are in canonical ascending order".
    #[derive(Clone, Copy, Debug, Eq, PartialEq)]
    pub struct CanonicalOrder;

    const _: () = assert!(std::mem::size_of::<FixedSlots<u32, CanonicalOrder, 8>>() == 32);

    impl<T, Order, const N: usize> FixedSlots<T, Order, N> {
        pub fn new(slots: [T; N]) -> Self {
            Self {
                slots,
                _order: PhantomData,
            }
        }

        pub const fn len(&self) -> usize {
            N
        }

        pub const fn is_empty(&self) -> bool {
            N == 0
        }
    }

    /// Read one `WIDTH`-bit field with the width, mask, and stride folded at
    /// compile time.
    #[inline]
    fn read_field<const WIDTH: u32>(payload: &[u8], index: usize) -> u64 {
        let bit_offset = index * WIDTH as usize;
        let byte = bit_offset / 8;
        let shift = bit_offset % 8;
        let span = ((shift + WIDTH as usize).div_ceil(8)).min(payload.len() - byte);
        let mut buffer = [0_u8; 16];
        buffer[..span].copy_from_slice(&payload[byte..byte + span]);
        let word = u128::from_le_bytes(buffer) >> shift;
        if WIDTH >= 64 {
            word as u64
        } else {
            (word & ((1_u128 << WIDTH) - 1)) as u64
        }
    }

    fn contains_const<const WIDTH: u32>(payload: &[u8], count: usize, target: i64) -> bool {
        if target < 0 {
            return false;
        }
        let target = target as u64;
        let mut low = 0_usize;
        let mut high = count;
        while low < high {
            let middle = (low + high) / 2;
            let value = read_field::<WIDTH>(payload, middle);
            match value.cmp(&target) {
                std::cmp::Ordering::Equal => return true,
                std::cmp::Ordering::Less => low = middle + 1,
                std::cmp::Ordering::Greater => high = middle,
            }
        }
        false
    }

    macro_rules! width_call {
        ($body:ident, $literal:literal, ($($argument:expr),*)) => {
            $body::<$literal>($($argument),*)
        };
    }

    macro_rules! width_dispatch {
        ($width:expr, $body:ident, $arguments:tt, $($literal:literal),+ $(,)?) => {
            match $width {
                $($literal => width_call!($body, $literal, $arguments),)+
                _ => width_call!($body, 64, $arguments),
            }
        };
    }

    /// Dispatch once to the monomorphization for this width. The caller hoists
    /// this out of its probe loop.
    pub fn narrow_contains_dispatch(payload: &[u8], count: usize, width: u8, target: i64) -> bool {
        width_dispatch!(
            u32::from(width),
            contains_const,
            (payload, count, target),
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            39,
            40,
            41,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            61,
            62,
            63,
        )
    }

    /// Indexed read with the width folded at compile time.
    pub fn narrow_get_dispatch(payload: &[u8], index: usize, width: u8) -> u64 {
        width_dispatch!(
            u32::from(width),
            read_field,
            (payload, index),
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            39,
            40,
            41,
            42,
            43,
            44,
            45,
            46,
            47,
            48,
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            58,
            59,
            60,
            61,
            62,
            63,
        )
    }
}

// ---------------------------------------------------------------------------
// Bit and numeric helpers
// ---------------------------------------------------------------------------

fn zigzag(value: i64) -> i64 {
    (value << 1) ^ (value >> 63)
}

fn unzigzag(value: i64) -> i64 {
    let value = value as u64;
    ((value >> 1) as i64) ^ -((value & 1) as i64)
}

fn bit_width_for(maximum: u64) -> u8 {
    if maximum == 0 {
        1
    } else {
        (64 - maximum.leading_zeros()) as u8
    }
}

fn elias_fano_low_width(upper: u64, count: usize) -> u8 {
    let ratio = upper / count.max(1) as u64;
    if ratio < 2 {
        0
    } else {
        (63 - ratio.leading_zeros()) as u8
    }
}

/// Insert `width` bits at a bit offset with one unaligned 16-byte
/// read-modify-write, not a per-bit loop: a packed field must cost a shift and
/// a mask, or the scorer measures the harness instead of the representation.
fn write_bits(payload: &mut [u8], bit_offset: usize, width: u8, value: u64) {
    if width == 0 {
        return;
    }
    let byte = bit_offset / 8;
    let shift = bit_offset % 8;
    let span = (shift + usize::from(width))
        .div_ceil(8)
        .min(payload.len() - byte);
    let mut buffer = [0_u8; 16];
    buffer[..span].copy_from_slice(&payload[byte..byte + span]);
    let mask = if width >= 64 {
        u128::from(u64::MAX)
    } else {
        (1_u128 << width) - 1
    };
    let word =
        (u128::from_le_bytes(buffer) & !(mask << shift)) | (u128::from(value) & mask) << shift;
    let bytes = word.to_le_bytes();
    payload[byte..byte + span].copy_from_slice(&bytes[..span]);
}

/// Extract `width` bits from a bit offset with one unaligned 16-byte read.
fn read_bits(payload: &[u8], bit_offset: usize, width: u8) -> u64 {
    if width == 0 {
        return 0;
    }
    let byte = bit_offset / 8;
    let shift = bit_offset % 8;
    let span = (shift + usize::from(width))
        .div_ceil(8)
        .min(payload.len() - byte);
    let mut buffer = [0_u8; 16];
    buffer[..span].copy_from_slice(&payload[byte..byte + span]);
    let word = u128::from_le_bytes(buffer) >> shift;
    if width >= 64 {
        word as u64
    } else {
        (word & ((1_u128 << width) - 1)) as u64
    }
}

fn read_block(bytes: &[u8]) -> [i64; DICTIONARY_BLOCK] {
    let mut block = [0_i64; DICTIONARY_BLOCK];
    for (slot, entry) in block.iter_mut().enumerate() {
        *entry = i64::from_le_bytes(bytes[8 * slot..8 * slot + 8].try_into().unwrap());
    }
    block
}

fn block_hash(block: &[i64; DICTIONARY_BLOCK]) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for &entry in block {
        hash ^= entry as u64;
        hash = hash.wrapping_mul(0x0000_0100_0000_01b3);
    }
    hash ^ (hash >> 31)
}

/// A monotone reference-cycle counter.
///
/// The workspace has no reusable performance-counter harness, so this reads the
/// invariant time-stamp counter where it exists and falls back to a monotone
/// nanosecond clock elsewhere. It is a reference clock, not a retired-core-cycle
/// count; every number derived from it is labelled as reference cycles.
#[inline]
pub fn reference_cycles() -> u64 {
    #[cfg(target_arch = "x86_64")]
    {
        // SAFETY: `_rdtsc` reads the time-stamp counter and has no memory or
        // register side effects beyond its return value. It is unconditionally
        // available on x86_64.
        unsafe { core::arch::x86_64::_rdtsc() }
    }
    #[cfg(not(target_arch = "x86_64"))]
    {
        use std::time::{SystemTime, UNIX_EPOCH};
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .map(|elapsed| elapsed.as_nanos() as u64)
            .unwrap_or(0)
    }
}

/// Enumerate every structurally valid pipeline up to [`MAX_PIPELINE_DEPTH`].
///
/// Cold: used to seed the evolution engine and to produce the exhaustive
/// control ranking the search is compared against.
pub fn enumerate_pipelines() -> Vec<Pipeline> {
    const TRANSFORMS: [Transform; 4] = [
        Transform::WindowClip,
        Transform::Delta,
        Transform::Zigzag,
        Transform::CanonicalPermutation,
    ];
    const SERIALIZERS: [Serializer; 7] = [
        Serializer::Fixed64,
        Serializer::Narrow,
        Serializer::Varint,
        Serializer::EliasFano,
        Serializer::RunLength,
        Serializer::BitPack,
        Serializer::Dictionary,
    ];
    const DESCRIPTORS: [Descriptor; 3] = [
        Descriptor::Runtime,
        Descriptor::Packed,
        Descriptor::TypeCarried,
    ];
    let mut pipelines = Vec::new();
    for serializer in SERIALIZERS {
        for descriptor in DESCRIPTORS {
            if let Some(pipeline) = Pipeline::with_descriptor(Vec::new(), serializer, descriptor) {
                pipelines.push(pipeline);
            }
            for first in TRANSFORMS {
                if let Some(pipeline) =
                    Pipeline::with_descriptor(vec![first], serializer, descriptor)
                {
                    pipelines.push(pipeline);
                }
                for second in TRANSFORMS {
                    if let Some(pipeline) =
                        Pipeline::with_descriptor(vec![first, second], serializer, descriptor)
                    {
                        pipelines.push(pipeline);
                    }
                }
            }
        }
    }
    pipelines.sort();
    pipelines.dedup();
    pipelines
}

#[cfg(test)]
mod tests {
    use super::*;

    fn membership(values: Vec<i64>, universe: u64) -> Observation {
        Observation::new(ObservationKind::DenseBitmap, universe, values).unwrap()
    }

    #[test]
    fn every_applicable_pipeline_round_trips() {
        let cases = [
            membership((300..420).collect(), 1_024),
            membership(vec![3, 9, 17, 400, 999], 1_024),
            Observation::new(
                ObservationKind::SmallIntVector,
                64,
                vec![1, 1, 1, 5, 5, 9, 9, 9, 9, 2],
            )
            .unwrap(),
        ];
        let mut workspace = ReprWorkspace::new(4_096, 4_096);
        let mut applicable = 0_usize;
        for observation in &cases {
            for pipeline in enumerate_pipelines() {
                let Ok(image) = encode(&pipeline, observation, &mut workspace) else {
                    continue;
                };
                let count = decode(&pipeline, &image, &mut workspace).unwrap();
                assert_eq!(count, observation.len(), "{}", pipeline.name());
                assert_eq!(
                    &workspace.decoded()[..count],
                    observation.values(),
                    "round trip failed for {}",
                    pipeline.name()
                );
                applicable += 1;
            }
        }
        assert!(
            applicable > 60,
            "too few applicable pipelines: {applicable}"
        );
    }

    #[test]
    fn probes_agree_with_the_reference_observation() {
        let observation = membership(vec![5, 6, 7, 40, 41, 900], 1_024);
        let mut workspace = ReprWorkspace::new(1_024, 1_024);
        for pipeline in enumerate_pipelines() {
            let Ok(image) = encode(&pipeline, &observation, &mut workspace) else {
                continue;
            };
            for target in 0..1_024_i64 {
                let expected = observation.values().binary_search(&target).is_ok();
                assert_eq!(
                    probe(&pipeline, &image, &workspace, ProbeQuery::Contains(target)),
                    ProbeAnswer::Present(expected),
                    "{} disagreed at {target}",
                    pipeline.name()
                );
            }
        }
    }

    #[test]
    fn vector_get_agrees_with_the_reference_observation() {
        let observation = Observation::new(
            ObservationKind::SmallIntVector,
            32,
            vec![7, 7, 3, 0, 31, 5, 5, 5, 1],
        )
        .unwrap();
        let mut workspace = ReprWorkspace::new(64, 64);
        for pipeline in enumerate_pipelines() {
            let Ok(image) = encode(&pipeline, &observation, &mut workspace) else {
                continue;
            };
            for index in 0..observation.len() as u32 {
                assert_eq!(
                    probe(&pipeline, &image, &workspace, ProbeQuery::Get(index)),
                    ProbeAnswer::Value(Some(observation.values()[index as usize])),
                    "{} disagreed at index {index}",
                    pipeline.name()
                );
            }
        }
    }

    #[test]
    fn window_clipped_bitpack_beats_bare_bitpack_on_a_clipped_row() {
        let observation = membership((900..1_000).collect(), 4_096);
        let mut workspace = ReprWorkspace::new(4_096, 4_096);
        let clipped = Pipeline::new(vec![Transform::WindowClip], Serializer::BitPack).unwrap();
        let bare = Pipeline::new(Vec::new(), Serializer::BitPack).unwrap();
        let clipped_bytes = encode(&clipped, &observation, &mut workspace)
            .unwrap()
            .header
            .declared_bytes(clipped.descriptor());
        let bare_bytes = encode(&bare, &observation, &mut workspace)
            .unwrap()
            .header
            .declared_bytes(bare.descriptor());
        assert!(clipped_bytes < bare_bytes, "{clipped_bytes} {bare_bytes}");
    }

    #[test]
    fn type_carried_descriptors_cost_nothing_and_probe_identically() {
        let observation = membership(vec![5, 6, 7, 40, 41, 900], 1_024);
        let mut workspace = ReprWorkspace::new(1_024, 1_024);
        let mut runtime_answers = vec![ProbeAnswer::Present(false); 1_024];
        let mut typed_answers = vec![ProbeAnswer::Present(false); 1_024];
        let queries = (0..1_024_i64).map(ProbeQuery::Contains).collect::<Vec<_>>();
        for serializer in [Serializer::Narrow, Serializer::BitPack] {
            let runtime = Pipeline::with_descriptor(
                vec![Transform::WindowClip],
                serializer,
                Descriptor::Runtime,
            )
            .unwrap();
            let typed = Pipeline::with_descriptor(
                vec![Transform::WindowClip],
                serializer,
                Descriptor::TypeCarried,
            )
            .unwrap();
            let image = encode(&runtime, &observation, &mut workspace).unwrap();
            probe_batch(&runtime, &image, &workspace, &queries, &mut runtime_answers);
            let image = encode(&typed, &observation, &mut workspace).unwrap();
            probe_batch(&typed, &image, &workspace, &queries, &mut typed_answers);
            assert_eq!(runtime_answers, typed_answers, "{}", typed.name());
            assert_eq!(typed.descriptor().bytes(), 0);
            assert_eq!(runtime.descriptor().bytes(), 64);
        }
    }

    #[test]
    fn packed_descriptor_round_trips_its_fields() {
        let packed = type_level::PackedDescriptor::new(1_234_567, 9_001, 17).unwrap();
        assert_eq!(packed.base(), 1_234_567);
        assert_eq!(packed.element_count(), 9_001);
        assert_eq!(packed.bit_width(), 17);
        assert_eq!(type_level::Slot::new(0).unwrap().index(), 0);
        assert_eq!(
            type_level::Residue::<7>::new(5)
                .unwrap()
                .add_residue(type_level::Residue::<7>::new(4).unwrap())
                .get(),
            2
        );
    }

    #[test]
    fn canonical_permutation_is_rejected_on_an_order_bearing_family() {
        let observation =
            Observation::new(ObservationKind::SmallIntVector, 16, vec![5, 1, 9]).unwrap();
        let mut workspace = ReprWorkspace::new(16, 16);
        let pipeline =
            Pipeline::new(vec![Transform::CanonicalPermutation], Serializer::Fixed64).unwrap();
        assert_eq!(
            encode(&pipeline, &observation, &mut workspace),
            Err(EncodeError::OrderNotFree)
        );
    }
}
