use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{
    BinaryRelation, DeclaredAction, GatedPaperIi, GatedPaperIv, GatedPaperV, InputArtifact,
    PaperIOrientation, ProfileInput, RelationalShadow, ShadowError, VerificationReport,
    WeightedPair, validate, verify_certificate,
};

pub const CANONICAL_SCHEMA_VERSION: &str = "sparse-shadow-canonical/v2";

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SearchStats {
    pub search_nodes: u64,
    pub canonical_leaves: u64,
    pub refinement_rounds: u64,
    pub max_depth: u32,
    pub arena_grows: u64,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BranchDecision {
    pub depth: u32,
    pub cell: Vec<u32>,
    pub chosen_vertex: u32,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CanonicalCertificate {
    pub certificate_schema: String,
    pub proof_system: String,
    pub input_to_canonical: Vec<u32>,
    pub canonical_json: String,
    pub canonical_id: String,
    pub winning_trace: Vec<BranchDecision>,
    pub automorphisms: Vec<Vec<u32>>,
    pub search_stats: SearchStats,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PointStabilizer {
    pub fixed_vertex: u32,
    pub automorphism_generators: Vec<Vec<u32>>,
    pub automorphism_order: u64,
    pub vertex_orbits: Vec<Vec<u32>>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CanonicalArtifact {
    pub schema: String,
    pub canonical_id: String,
    pub canonical: InputArtifact,
    pub input_to_canonical: Vec<u32>,
    pub automorphism_generators: Vec<Vec<u32>>,
    pub automorphism_order: u64,
    pub vertex_orbits: Vec<Vec<u32>>,
    pub point_stabilizers: Vec<PointStabilizer>,
    pub stats: SearchStats,
    pub certificate: CanonicalCertificate,
}

/// Compute the deterministic canonical form and replay certificate.
///
/// # Errors
///
/// Returns an error when the schema or profile is invalid or gated, or when a
/// canonical artifact cannot be represented by schema v1.
pub fn canonicalize(input: &InputArtifact) -> Result<CanonicalArtifact, ShadowError> {
    validate(input)?;
    let paper = match &input.profile {
        ProfileInput::PaperIOrientation(paper) => paper,
        ProfileInput::PaperIiTrade(value) => return canonicalize_paper_ii(input, value),
        ProfileInput::PaperIvMinimumWords(value) => return canonicalize_paper_iv(input, value),
        ProfileInput::PaperVChordalConference(value) => return canonicalize_paper_v(input, value),
        ProfileInput::PaperIiiFourShadow(_) => return Err(gated_error(&input.profile)),
    };

    let search = crate::hot::search(paper);
    let canonical = relabel(paper, &search.best_permutation);
    let canonical_json = serde_json::to_string(&canonical)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = automorphisms(&search.best_permutation, &search.equal_permutations)?;
    let automorphism_generators = generating_set(&automorphisms);
    let vertex_orbits = permutation_orbits(paper.shadow.vertices.len(), &automorphisms)?;
    let point_stabilizers = point_stabilizers(&vertex_orbits, &automorphisms)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_order = u64::try_from(automorphisms.len())
        .map_err(|_| ShadowError::Invalid("automorphism count exceeds u64".into()))?;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        proof_system: "paper-i-ir-exhaustion/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: search.winning_trace,
        automorphisms: automorphisms.clone(),
        search_stats: search.stats.clone(),
    };

    Ok(CanonicalArtifact {
        schema: CANONICAL_SCHEMA_VERSION.into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators,
        automorphism_order,
        vertex_orbits,
        point_stabilizers,
        stats: search.stats,
        certificate,
    })
}

fn canonicalize_paper_v(
    input: &InputArtifact,
    value: &GatedPaperV,
) -> Result<CanonicalArtifact, ShadowError> {
    let search = crate::paper_v::search(value)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = automorphisms(&search.best_permutation, &search.equal_permutations)?;
    let canonical = relabel_paper_v(input, value, &input_to_canonical)?;
    let canonical_json = serde_json::to_string(&canonical)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_generators = generating_set(&automorphisms);
    let vertex_orbits = permutation_orbits(6, &automorphisms)?;
    let point_stabilizers = point_stabilizers(&vertex_orbits, &automorphisms)?;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        proof_system: "paper-v-marked-conference-action-exhaustion/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: Vec::new(),
        automorphisms: automorphisms.clone(),
        search_stats: search.stats.clone(),
    };
    Ok(CanonicalArtifact {
        schema: CANONICAL_SCHEMA_VERSION.into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators,
        automorphism_order: automorphisms.len() as u64,
        vertex_orbits,
        point_stabilizers,
        stats: search.stats,
        certificate,
    })
}

pub(crate) fn relabel_paper_v(
    input: &InputArtifact,
    value: &GatedPaperV,
    input_to_canonical: &[u32],
) -> Result<InputArtifact, ShadowError> {
    let permutation = input_to_canonical
        .iter()
        .map(|&image| image as usize)
        .collect::<Vec<_>>();
    let mut canonical = value.clone();
    let mut vertices = value.retained_residue.vertices.clone();
    for (old, &new) in permutation.iter().enumerate() {
        vertices[new] = value.retained_residue.vertices[old].clone();
    }
    canonical.retained_residue.vertices = vertices;
    canonical.retained_residue.relations = value
        .retained_residue
        .relations
        .iter()
        .map(|relation| relabel_relation(relation, &permutation))
        .collect();
    let mut outer = vec![0; 6];
    for old in 0..6 {
        outer[permutation[old]] = input_to_canonical[value.outer_involution[old] as usize];
    }
    canonical.outer_involution = outer;
    let mut delta = value.delta_matrix.clone();
    for row in 0..6 {
        for column in 0..6 {
            delta[permutation[row]][permutation[column]] = value.delta_matrix[row][column].clone();
        }
    }
    canonical.delta_matrix = delta;
    let declared_group = crate::paper_v::declared_group(value)?;
    let mut conjugated = declared_group
        .iter()
        .map(|element| {
            let mut result = vec![0; 6];
            for old in 0..6 {
                result[permutation[old]] = input_to_canonical[element[old]];
            }
            result
        })
        .collect::<Vec<_>>();
    conjugated.sort_unstable();
    canonical.action = DeclaredAction::VertexPermutations {
        degree: 6,
        generators: generating_set(&conjugated),
    };
    let mut artifact = input.clone();
    artifact.profile = ProfileInput::PaperVChordalConference(Box::new(canonical));
    Ok(artifact)
}

fn canonicalize_paper_ii(
    input: &InputArtifact,
    value: &GatedPaperIi,
) -> Result<CanonicalArtifact, ShadowError> {
    let search = crate::paper_ii::search(value)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = automorphisms(&search.best_permutation, &search.equal_permutations)?;
    let canonical = relabel_paper_ii(input, value, &input_to_canonical, &automorphisms)?;
    let canonical_json = serde_json::to_string(&canonical)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_generators = generating_set(&automorphisms);
    let vertex_orbits = permutation_orbits(input_to_canonical.len(), &automorphisms)?;
    let point_stabilizers = point_stabilizers(&vertex_orbits, &automorphisms)?;
    let automorphism_order = automorphisms.len() as u64;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        proof_system: "paper-ii-declared-action-exhaustion/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: Vec::new(),
        automorphisms: automorphisms.clone(),
        search_stats: search.stats.clone(),
    };
    Ok(CanonicalArtifact {
        schema: CANONICAL_SCHEMA_VERSION.into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators,
        automorphism_order,
        vertex_orbits,
        point_stabilizers,
        stats: search.stats,
        certificate,
    })
}

pub(crate) fn relabel_paper_ii(
    input: &InputArtifact,
    value: &GatedPaperIi,
    input_to_canonical: &[u32],
    _automorphisms: &[Vec<u32>],
) -> Result<InputArtifact, ShadowError> {
    let permutation = input_to_canonical
        .iter()
        .map(|&image| image as usize)
        .collect::<Vec<_>>();
    let mut canonical = value.clone();
    canonical.trade_halves = [
        crate::paper_ii::relabel_blocks(&value.trade_halves[0], &permutation)?,
        crate::paper_ii::relabel_blocks(&value.trade_halves[1], &permutation)?,
    ];
    let declared_group = crate::paper_ii::declared_group(value)?;
    let mut canonical_group = declared_group
        .iter()
        .map(|automorphism| {
            let mut conjugate = vec![0; input_to_canonical.len()];
            for old in 0..input_to_canonical.len() {
                conjugate[input_to_canonical[old] as usize] = input_to_canonical[automorphism[old]];
            }
            conjugate
        })
        .collect::<Vec<_>>();
    canonical_group.sort_unstable();
    canonical_group.dedup();
    canonical.action = DeclaredAction::VertexPermutations {
        degree: u32::try_from(input_to_canonical.len()).expect("Paper-II degree fits u32"),
        generators: generating_set(&canonical_group),
    };
    let mut artifact = input.clone();
    artifact.profile = ProfileInput::PaperIiTrade(Box::new(canonical));
    Ok(artifact)
}

fn canonicalize_paper_iv(
    input: &InputArtifact,
    value: &GatedPaperIv,
) -> Result<CanonicalArtifact, ShadowError> {
    let search = crate::paper_iv::search(value)?;
    let input_to_canonical = to_u32_permutation(&search.best_permutation)?;
    let automorphisms = search
        .equal_permutations
        .iter()
        .map(|permutation| to_u32_permutation(permutation))
        .collect::<Result<Vec<_>, _>>()?;
    let canonical = relabel_paper_iv(input, value, &input_to_canonical, &automorphisms);
    let canonical_json = serde_json::to_string(&canonical)?;
    let canonical_id = blake3::hash(canonical_json.as_bytes()).to_hex().to_string();
    let automorphism_generators = generating_set(&automorphisms);
    let vertex_orbits = permutation_orbits(value.coordinate_count as usize, &automorphisms)?;
    let point_stabilizers = point_stabilizers(&vertex_orbits, &automorphisms)?;
    let automorphism_order = u64::try_from(automorphisms.len())
        .map_err(|_| ShadowError::Invalid("automorphism count exceeds u64".into()))?;
    let certificate = CanonicalCertificate {
        certificate_schema: "sparse-shadow-certificate/v1".into(),
        proof_system: "paper-iv-weighted-scheme-ir-exhaustion/v1".into(),
        input_to_canonical: input_to_canonical.clone(),
        canonical_json,
        canonical_id: canonical_id.clone(),
        winning_trace: search.winning_trace,
        automorphisms: automorphisms.clone(),
        search_stats: search.stats.clone(),
    };
    Ok(CanonicalArtifact {
        schema: CANONICAL_SCHEMA_VERSION.into(),
        canonical_id,
        canonical,
        input_to_canonical,
        automorphism_generators,
        automorphism_order,
        vertex_orbits,
        point_stabilizers,
        stats: search.stats,
        certificate,
    })
}

pub(crate) fn relabel_paper_iv(
    input: &InputArtifact,
    value: &GatedPaperIv,
    input_to_canonical: &[u32],
    automorphisms: &[Vec<u32>],
) -> InputArtifact {
    let mut canonical = value.clone();
    canonical.weighted_pair_section = value
        .weighted_pair_section
        .iter()
        .map(|pair| {
            let mut endpoints = [
                input_to_canonical[pair.left as usize],
                input_to_canonical[pair.right as usize],
            ];
            endpoints.sort_unstable();
            WeightedPair {
                left: endpoints[0],
                right: endpoints[1],
                multiplicity: pair.multiplicity,
            }
        })
        .collect();
    canonical
        .weighted_pair_section
        .sort_unstable_by_key(|pair| (pair.left, pair.right, pair.multiplicity));

    let mut canonical_group = automorphisms
        .iter()
        .map(|automorphism| {
            let mut conjugate = vec![0; input_to_canonical.len()];
            for old in 0..input_to_canonical.len() {
                conjugate[input_to_canonical[old] as usize] =
                    input_to_canonical[automorphism[old] as usize];
            }
            conjugate
        })
        .collect::<Vec<_>>();
    canonical_group.sort_unstable();
    canonical_group.dedup();
    canonical.action = DeclaredAction::VertexPermutations {
        degree: value.coordinate_count,
        generators: generating_set(&canonical_group),
    };
    let mut artifact = input.clone();
    artifact.profile = ProfileInput::PaperIvMinimumWords(Box::new(canonical));
    artifact
}

/// Replay a full canonical artifact and bind every public wrapper field to its
/// independently checked certificate.
///
/// # Errors
///
/// Returns an error when the inner proof fails or any wrapper field is
/// inconsistent with it.
pub fn verify_canonical_artifact(
    input: &InputArtifact,
    artifact: &CanonicalArtifact,
) -> Result<VerificationReport, ShadowError> {
    let report = verify_certificate(input, &artifact.certificate)?;
    verify_canonical_artifact_fields(artifact)?;
    Ok(report)
}

fn verify_canonical_artifact_fields(artifact: &CanonicalArtifact) -> Result<(), ShadowError> {
    let certificate = &artifact.certificate;
    if artifact.schema != CANONICAL_SCHEMA_VERSION
        || artifact.canonical_id != certificate.canonical_id
        || artifact.input_to_canonical != certificate.input_to_canonical
        || artifact.stats != certificate.search_stats
    {
        return Err(ShadowError::Certificate(
            "canonical artifact wrapper differs from its certificate".into(),
        ));
    }
    if serde_json::to_string(&artifact.canonical)? != certificate.canonical_json {
        return Err(ShadowError::Certificate(
            "canonical artifact payload differs from its certificate".into(),
        ));
    }
    let expected_order = u64::try_from(certificate.automorphisms.len())
        .map_err(|_| ShadowError::Certificate("automorphism count exceeds u64".into()))?;
    if artifact.automorphism_order != expected_order {
        return Err(ShadowError::Certificate(
            "canonical artifact automorphism order differs from its certificate".into(),
        ));
    }

    let degree = artifact.input_to_canonical.len();
    for generator in &artifact.automorphism_generators {
        validate_permutation(generator, degree)?;
    }
    let expected: BTreeSet<_> = certificate.automorphisms.iter().cloned().collect();
    let generated = generated_closure_within(degree, &artifact.automorphism_generators, &expected)?;
    if generated != expected {
        return Err(ShadowError::Certificate(
            "canonical artifact generators do not close to the certified automorphism group".into(),
        ));
    }
    if artifact.vertex_orbits != permutation_orbits(degree, &certificate.automorphisms)? {
        return Err(ShadowError::Certificate(
            "canonical artifact vertex orbits differ from its certificate".into(),
        ));
    }
    let expected_stabilizers =
        point_stabilizers(&artifact.vertex_orbits, &certificate.automorphisms)
            .map_err(|error| ShadowError::Certificate(error.to_string()))?;
    if artifact.point_stabilizers != expected_stabilizers {
        return Err(ShadowError::Certificate(
            "canonical artifact point stabilizers differ from its certificate".into(),
        ));
    }
    Ok(())
}

fn generated_closure_within(
    degree: usize,
    generators: &[Vec<u32>],
    expected: &BTreeSet<Vec<u32>>,
) -> Result<BTreeSet<Vec<u32>>, ShadowError> {
    let identity: Vec<u32> = (0..degree)
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    if !expected.contains(&identity)
        || generators
            .iter()
            .any(|generator| !expected.contains(generator))
    {
        return Err(ShadowError::Certificate(
            "canonical artifact generator is outside the certified automorphism group".into(),
        ));
    }
    let mut closure = BTreeSet::from([identity.clone()]);
    let mut frontier = vec![identity];
    while let Some(element) = frontier.pop() {
        for generator in generators {
            let product: Vec<u32> = element
                .iter()
                .map(|&image| generator[image as usize])
                .collect();
            if !expected.contains(&product) {
                return Err(ShadowError::Certificate(
                    "canonical artifact generators leave the certified automorphism group".into(),
                ));
            }
            if closure.insert(product.clone()) {
                frontier.push(product);
            }
        }
    }
    Ok(closure)
}

fn validate_permutation(permutation: &[u32], degree: usize) -> Result<(), ShadowError> {
    let image: BTreeSet<_> = permutation.iter().copied().collect();
    if permutation.len() != degree
        || image.len() != degree
        || image.iter().any(|&vertex| vertex as usize >= degree)
    {
        return Err(ShadowError::Certificate(
            "canonical artifact generator is not a permutation".into(),
        ));
    }
    Ok(())
}

fn gated_error(profile: &ProfileInput) -> ShadowError {
    let (name, gate) = match profile {
        ProfileInput::PaperIiTrade(value) => ("paper_ii_trade", &value.gate),
        ProfileInput::PaperIiiFourShadow(value) => ("paper_iii_four_shadow", &value.gate),
        ProfileInput::PaperIvMinimumWords(value) => ("paper_iv_minimum_words", &value.gate),
        ProfileInput::PaperVChordalConference(value) => ("paper_v_chordal_conference", &value.gate),
        ProfileInput::PaperIOrientation(_) => unreachable!(),
    };
    ShadowError::ProfileGated {
        profile: name,
        reason: format!("{}; required export: {}", gate.reason, gate.required_export),
    }
}

fn relabel(paper: &PaperIOrientation, permutation: &[usize]) -> InputArtifact {
    let n = paper.shadow.vertices.len();
    let mut vertices = vec![paper.shadow.vertices[0].clone(); n];
    for (old, &new) in permutation.iter().enumerate() {
        vertices[new] = paper.shadow.vertices[old].clone();
    }
    let relations = paper
        .shadow
        .relations
        .iter()
        .map(|relation| relabel_relation(relation, permutation))
        .collect();
    let calibrated_triangle = paper.calibrated_triangle.map(|triangle| {
        let mut mapped = triangle.map(|vertex| index_u32(permutation[vertex as usize]));
        mapped.sort_unstable();
        mapped
    });
    InputArtifact {
        schema: crate::SCHEMA_VERSION.into(),
        profile: ProfileInput::PaperIOrientation(PaperIOrientation {
            theorem_locator: "clebsch-paper-i-orientation/v1".into(),
            shadow: RelationalShadow {
                action: paper.shadow.action,
                vertices,
                relations,
            },
            calibrated_triangle,
        }),
    }
}

fn relabel_relation(relation: &BinaryRelation, permutation: &[usize]) -> BinaryRelation {
    let mut edges: Vec<[u32; 2]> = relation
        .edges
        .iter()
        .map(|&[left, right]| {
            let mut mapped = [
                index_u32(permutation[left as usize]),
                index_u32(permutation[right as usize]),
            ];
            if !relation.directed && mapped[0] > mapped[1] {
                mapped.swap(0, 1);
            }
            mapped
        })
        .collect();
    edges.sort_unstable();
    BinaryRelation {
        name: relation.name.clone(),
        directed: relation.directed,
        edges,
    }
}

fn automorphisms(best: &[usize], equal: &[Vec<usize>]) -> Result<Vec<Vec<u32>>, ShadowError> {
    let mut result = BTreeSet::new();
    for leaf in equal {
        let mut inverse = vec![0; leaf.len()];
        for (old, &canonical) in leaf.iter().enumerate() {
            inverse[canonical] = old;
        }
        let automorphism: Vec<u32> = best
            .iter()
            .map(|&canonical| u32::try_from(inverse[canonical]))
            .collect::<Result<_, _>>()
            .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))?;
        result.insert(automorphism);
    }
    Ok(result.into_iter().collect())
}

fn generating_set(group: &[Vec<u32>]) -> Vec<Vec<u32>> {
    let Some(first) = group.first() else {
        return Vec::new();
    };
    let identity: Vec<u32> = (0..first.len())
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    let mut generators = Vec::new();
    let mut generated = BTreeSet::from([identity]);
    for candidate in group {
        if !generated.contains(candidate) {
            generators.push(candidate.clone());
            generated = generated_closure(first.len(), &generators);
            if generated.len() == group.len() {
                break;
            }
        }
    }
    generators
}

fn generated_closure(degree: usize, generators: &[Vec<u32>]) -> BTreeSet<Vec<u32>> {
    let identity: Vec<u32> = (0..degree)
        .map(|value| u32::try_from(value).expect("validated degree fits u32"))
        .collect();
    let mut closure = BTreeSet::from([identity.clone()]);
    let mut frontier = vec![identity];
    while let Some(element) = frontier.pop() {
        for generator in generators {
            let product: Vec<u32> = element
                .iter()
                .map(|&image| generator[image as usize])
                .collect();
            if closure.insert(product.clone()) {
                frontier.push(product);
            }
        }
    }
    closure
}

fn permutation_orbits(n: usize, automorphisms: &[Vec<u32>]) -> Result<Vec<Vec<u32>>, ShadowError> {
    let mut parent: Vec<usize> = (0..n).collect();
    for permutation in automorphisms {
        for (left, &right) in permutation.iter().enumerate() {
            union(&mut parent, left, right as usize);
        }
    }
    let mut roots = std::collections::BTreeMap::<usize, Vec<u32>>::new();
    for vertex in 0..n {
        let root = find(&mut parent, vertex);
        roots.entry(root).or_default().push(
            u32::try_from(vertex)
                .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))?,
        );
    }
    Ok(roots.into_values().collect())
}

fn point_stabilizers(
    vertex_orbits: &[Vec<u32>],
    automorphisms: &[Vec<u32>],
) -> Result<Vec<PointStabilizer>, ShadowError> {
    let degree = automorphisms.first().map_or(0, Vec::len);
    vertex_orbits
        .iter()
        .map(|orbit| {
            let &fixed_vertex = orbit
                .first()
                .ok_or_else(|| ShadowError::Invalid("vertex orbit is empty".into()))?;
            let subgroup: Vec<Vec<u32>> = automorphisms
                .iter()
                .filter(|permutation| permutation[fixed_vertex as usize] == fixed_vertex)
                .cloned()
                .collect();
            let automorphism_order = u64::try_from(subgroup.len())
                .map_err(|_| ShadowError::Invalid("stabilizer order exceeds u64".into()))?;
            Ok(PointStabilizer {
                fixed_vertex,
                automorphism_generators: generating_set(&subgroup),
                automorphism_order,
                vertex_orbits: permutation_orbits(degree, &subgroup)?,
            })
        })
        .collect()
}

fn find(parent: &mut [usize], vertex: usize) -> usize {
    if parent[vertex] != vertex {
        parent[vertex] = find(parent, parent[vertex]);
    }
    parent[vertex]
}

fn union(parent: &mut [usize], left: usize, right: usize) {
    let left_root = find(parent, left);
    let right_root = find(parent, right);
    if left_root != right_root {
        parent[right_root] = left_root;
    }
}

fn to_u32_permutation(permutation: &[usize]) -> Result<Vec<u32>, ShadowError> {
    permutation
        .iter()
        .map(|&value| {
            u32::try_from(value)
                .map_err(|_| ShadowError::Invalid("vertex index exceeds u32".into()))
        })
        .collect()
}

fn index_u32(value: usize) -> u32 {
    u32::try_from(value).expect("validated vertex count fits u32")
}
