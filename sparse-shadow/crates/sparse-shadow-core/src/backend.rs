use std::collections::BTreeSet;

use serde::{Deserialize, Serialize};

use crate::{CanonicalArtifact, InputArtifact, ProfileInput, ShadowError, validate};

pub const BACKEND_GRAPH_SCHEMA_VERSION: &str = "sparse-shadow-colored-incidence/v1";
pub const BACKEND_COMPARISON_SCHEMA_VERSION: &str = "sparse-shadow-backend-comparison/v1";

#[derive(Clone, Copy, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum ExternalBackendKind {
    Nauty,
    Bliss,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendDescriptor {
    pub kind: ExternalBackendKind,
    pub engine_version: String,
    pub configuration: String,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ColoredIncidenceGraph {
    pub schema: String,
    pub colors: Vec<u32>,
    pub edges: Vec<[u32; 2]>,
    pub original_vertex_nodes: Vec<u32>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendObservation {
    pub canonical_graph_blake3: String,
    pub automorphism_order: u64,
    pub search_nodes: Option<u64>,
}

#[derive(Clone, Debug, Eq, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BackendComparison {
    pub schema: String,
    pub encoding_schema: String,
    pub authoritative_backend: String,
    pub native_canonical_id: String,
    pub external_backend: BackendDescriptor,
    pub raw_input: BackendObservation,
    pub native_canonical_input: BackendObservation,
    pub canonical_graph_agrees: bool,
    pub automorphism_order_agrees: bool,
}

impl BackendComparison {
    #[must_use]
    pub const fn verified(&self) -> bool {
        self.canonical_graph_agrees && self.automorphism_order_agrees
    }
}

/// Encode an enabled paper shadow as a colored incidence graph.
///
/// Original vertices retain their typed data as color classes. Every relation
/// or weighted-pair edge becomes a vertex in a relation-specific color class
/// joined to its two endpoints. Consequently,
/// color-preserving graph automorphisms restrict exactly to automorphisms of
/// the relational shadow.
///
/// # Errors
///
/// Returns an error for invalid, gated, or directed inputs. Directed relation
/// gadgets are reserved for a later encoding schema.
pub fn encode_colored_incidence(
    input: &InputArtifact,
) -> Result<ColoredIncidenceGraph, ShadowError> {
    validate(input)?;
    if let ProfileInput::PaperIiTrade(value) = &input.profile {
        return encode_paper_ii(value);
    }
    if let ProfileInput::PaperIiiFourShadow(value) = &input.profile {
        return encode_paper_iii(value);
    }
    if let ProfileInput::PaperVChordalConference(value) = &input.profile {
        return encode_paper_v(value);
    }
    if let ProfileInput::PaperIvMinimumWords(value) = &input.profile {
        return encode_paper_iv(value);
    }
    let ProfileInput::PaperIOrientation(paper) = &input.profile else {
        return Err(ShadowError::Invalid(
            "colored-incidence v1 supports only the enabled Paper-I profile".into(),
        ));
    };
    if paper
        .shadow
        .relations
        .iter()
        .any(|relation| relation.directed)
    {
        return Err(ShadowError::Invalid(
            "colored-incidence v1 does not encode directed relations".into(),
        ));
    }

    let calibrated: BTreeSet<u32> = paper.calibrated_triangle.into_iter().flatten().collect();
    let mut vertex_keys = Vec::with_capacity(paper.shadow.vertices.len());
    for (index, vertex) in paper.shadow.vertices.iter().enumerate() {
        let index = u32::try_from(index)
            .map_err(|_| ShadowError::Invalid("Paper-I vertex count exceeds u32".into()))?;
        vertex_keys.push((
            vertex.color,
            vertex.weight,
            vertex.sign,
            calibrated.contains(&index),
        ));
    }
    let mut color_classes = vertex_keys.clone();
    color_classes.sort_unstable();
    color_classes.dedup();
    let mut colors = Vec::with_capacity(
        paper.shadow.vertices.len()
            + paper
                .shadow
                .relations
                .iter()
                .map(|relation| relation.edges.len())
                .sum::<usize>(),
    );
    for key in vertex_keys {
        let color = color_classes.binary_search(&key).map_err(|_| {
            ShadowError::Invalid("Paper-I vertex color class was not collected".into())
        })?;
        colors.push(
            u32::try_from(color)
                .map_err(|_| ShadowError::Invalid("Paper-I color count exceeds u32".into()))?,
        );
    }

    let original_vertex_nodes = (0..paper.shadow.vertices.len())
        .map(u32::try_from)
        .collect::<Result<Vec<_>, _>>()
        .map_err(|_| ShadowError::Invalid("Paper-I vertex count exceeds u32".into()))?;
    let relation_color_base = u32::try_from(color_classes.len())
        .map_err(|_| ShadowError::Invalid("Paper-I color count exceeds u32".into()))?;
    let mut edges = Vec::new();
    for (relation_index, relation) in paper.shadow.relations.iter().enumerate() {
        let relation_color = relation_color_base
            + u32::try_from(relation_index)
                .map_err(|_| ShadowError::Invalid("Paper-I relation count exceeds u32".into()))?;
        for &[left, right] in &relation.edges {
            let edge_node = u32::try_from(colors.len()).map_err(|_| {
                ShadowError::Invalid("Paper-I incidence encoding exceeds u32".into())
            })?;
            colors.push(relation_color);
            edges.push([left.min(edge_node), left.max(edge_node)]);
            edges.push([right.min(edge_node), right.max(edge_node)]);
        }
    }
    edges.sort_unstable();

    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

fn encode_paper_iii(value: &crate::GatedPaperIii) -> Result<ColoredIncidenceGraph, ShadowError> {
    let original_vertex_nodes = (0_u32..6).collect::<Vec<_>>();
    let mut colors = vec![0_u32; 6];
    let mut edges = Vec::with_capacity(4 * value.aligned_four_sets.len());
    for four_set in &value.aligned_four_sets {
        let four_set_node = u32::try_from(colors.len())
            .map_err(|_| ShadowError::Invalid("Paper-III encoding exceeds u32".into()))?;
        colors.push(1);
        for &vertex in four_set {
            edges.push([vertex.min(four_set_node), vertex.max(four_set_node)]);
        }
    }
    edges.sort_unstable();
    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

fn encode_paper_ii(value: &crate::GatedPaperIi) -> Result<ColoredIncidenceGraph, ShadowError> {
    let degree = 12_u32;
    let original_vertex_nodes = (0..degree).collect::<Vec<_>>();
    let mut colors = vec![0_u32; degree as usize];
    let mut edges = Vec::with_capacity(22 * 6 * 3);
    for (sheet, half) in value.trade_halves.iter().enumerate() {
        for block in half {
            let matching_node = u32::try_from(colors.len())
                .map_err(|_| ShadowError::Invalid("Paper-II encoding exceeds u32".into()))?;
            colors.push(1 + u32::try_from(sheet).expect("two Paper-II sheets fit u32"));
            for &encoded in &block.support {
                let edge_node = u32::try_from(colors.len())
                    .map_err(|_| ShadowError::Invalid("Paper-II encoding exceeds u32".into()))?;
                colors.push(3);
                let left = encoded / degree;
                let right = encoded % degree;
                edges.push([left.min(edge_node), left.max(edge_node)]);
                edges.push([right.min(edge_node), right.max(edge_node)]);
                edges.push([matching_node.min(edge_node), matching_node.max(edge_node)]);
            }
        }
    }
    edges.sort_unstable();
    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

fn encode_paper_v(value: &crate::GatedPaperV) -> Result<ColoredIncidenceGraph, ShadowError> {
    let original_vertex_nodes = (0_u32..6).collect::<Vec<_>>();
    let mut colors = vec![0_u32; 6];
    let mut edges = Vec::with_capacity(54);
    for (relation_index, relation) in value.retained_residue.relations.iter().enumerate() {
        for &[left, right] in &relation.edges {
            let edge_node = u32::try_from(colors.len())
                .map_err(|_| ShadowError::Invalid("Paper-V encoding exceeds u32".into()))?;
            colors.push(1 + u32::try_from(relation_index).expect("two relation colors fit u32"));
            edges.push([left.min(edge_node), left.max(edge_node)]);
            edges.push([right.min(edge_node), right.max(edge_node)]);
        }
    }
    for source in 0_u32..6 {
        let map_node = u32::try_from(colors.len())
            .map_err(|_| ShadowError::Invalid("Paper-V encoding exceeds u32".into()))?;
        colors.push(3);
        let source_port = u32::try_from(colors.len())
            .map_err(|_| ShadowError::Invalid("Paper-V encoding exceeds u32".into()))?;
        colors.push(4);
        let target_port = u32::try_from(colors.len())
            .map_err(|_| ShadowError::Invalid("Paper-V encoding exceeds u32".into()))?;
        colors.push(5);
        let target = value.outer_involution[source as usize];
        edges.extend([
            [source.min(source_port), source.max(source_port)],
            [source_port.min(map_node), source_port.max(map_node)],
            [map_node.min(target_port), map_node.max(target_port)],
            [target.min(target_port), target.max(target_port)],
        ]);
    }
    edges.sort_unstable();
    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

fn encode_paper_iv(value: &crate::GatedPaperIv) -> Result<ColoredIncidenceGraph, ShadowError> {
    let degree = value.coordinate_count as usize;
    let original_vertex_nodes = (0..value.coordinate_count).collect::<Vec<_>>();
    let mut colors = vec![0_u32; degree];
    let mut edges = Vec::with_capacity(2 * value.weighted_pair_section.len());
    for pair in &value.weighted_pair_section {
        let relation_color = match pair.multiplicity {
            6 => 1,
            7 => 2,
            8 => 3,
            9 => 4,
            12 => 5,
            _ => {
                return Err(ShadowError::Invalid(
                    "Paper-IV incidence encoding found an unknown weight".into(),
                ));
            }
        };
        let edge_node = u32::try_from(colors.len())
            .map_err(|_| ShadowError::Invalid("Paper-IV encoding exceeds u32".into()))?;
        colors.push(relation_color);
        edges.push([pair.left.min(edge_node), pair.left.max(edge_node)]);
        edges.push([pair.right.min(edge_node), pair.right.max(edge_node)]);
    }
    edges.sort_unstable();
    Ok(ColoredIncidenceGraph {
        schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        colors,
        edges,
        original_vertex_nodes,
    })
}

/// Bind two observations from one external engine to the authoritative native
/// canonical artifact.
///
/// # Errors
///
/// Returns an error unless the external engine assigns the raw input and the
/// native canonical payload the same canonical graph and the same group order
/// as the native certificate.
pub fn compare_external_backend(
    native: &CanonicalArtifact,
    external_backend: BackendDescriptor,
    raw_input: BackendObservation,
    native_canonical_input: BackendObservation,
) -> Result<BackendComparison, ShadowError> {
    let canonical_graph_agrees =
        raw_input.canonical_graph_blake3 == native_canonical_input.canonical_graph_blake3;
    let automorphism_order_agrees = raw_input.automorphism_order == native.automorphism_order
        && native_canonical_input.automorphism_order == native.automorphism_order;
    let comparison = BackendComparison {
        schema: BACKEND_COMPARISON_SCHEMA_VERSION.into(),
        encoding_schema: BACKEND_GRAPH_SCHEMA_VERSION.into(),
        authoritative_backend: authoritative_backend(native)?.into(),
        native_canonical_id: native.canonical_id.clone(),
        external_backend,
        raw_input,
        native_canonical_input,
        canonical_graph_agrees,
        automorphism_order_agrees,
    };
    verify_backend_comparison(native, &comparison)?;
    Ok(comparison)
}

/// Check the self-consistency of a serialized external-backend comparison.
/// Engine observations remain independently reproducible only by rerunning the
/// named backend; this verifier binds their recorded agreement to the native
/// artifact and rejects corrupted wrapper fields.
///
/// # Errors
///
/// Returns an error for unsupported metadata, malformed observations, stale
/// native identity, or disagreement with the native automorphism order.
pub fn verify_backend_comparison(
    native: &CanonicalArtifact,
    comparison: &BackendComparison,
) -> Result<(), ShadowError> {
    let digest_valid =
        |digest: &str| digest.len() == 64 && digest.bytes().all(|byte| byte.is_ascii_hexdigit());
    if comparison.schema != BACKEND_COMPARISON_SCHEMA_VERSION
        || comparison.encoding_schema != BACKEND_GRAPH_SCHEMA_VERSION
        || comparison.authoritative_backend != authoritative_backend(native)?
        || comparison.native_canonical_id != native.canonical_id
        || comparison.external_backend.engine_version.is_empty()
        || comparison.external_backend.configuration.is_empty()
        || !digest_valid(&comparison.raw_input.canonical_graph_blake3)
        || !digest_valid(&comparison.native_canonical_input.canonical_graph_blake3)
    {
        return Err(ShadowError::Certificate(
            "external backend comparison metadata is inconsistent".into(),
        ));
    }
    let canonical_graph_agrees = comparison.raw_input.canonical_graph_blake3
        == comparison.native_canonical_input.canonical_graph_blake3;
    let automorphism_order_agrees = comparison.raw_input.automorphism_order
        == native.automorphism_order
        && comparison.native_canonical_input.automorphism_order == native.automorphism_order;
    if comparison.canonical_graph_agrees != canonical_graph_agrees
        || comparison.automorphism_order_agrees != automorphism_order_agrees
        || !canonical_graph_agrees
        || !automorphism_order_agrees
    {
        return Err(ShadowError::Certificate(
            "external backend disagrees with the native canonical artifact".into(),
        ));
    }
    Ok(())
}

fn authoritative_backend(native: &CanonicalArtifact) -> Result<&'static str, ShadowError> {
    match native.certificate.proof_system.as_str() {
        "paper-i-ir-exhaustion/v1" => Ok("native-paper-i-ir/v1"),
        "paper-ii-declared-action-exhaustion/v1" => Ok("native-paper-ii-declared-action/v1"),
        "paper-iii-four-shadow-action-exhaustion/v1" => {
            Ok("native-paper-iii-four-shadow-action/v1")
        }
        "paper-iv-weighted-scheme-ir-exhaustion/v1" => Ok("native-paper-iv-weighted-scheme-ir/v1"),
        "paper-v-marked-conference-action-exhaustion/v1" => {
            Ok("native-paper-v-marked-conference-action/v1")
        }
        _ => Err(ShadowError::Certificate(
            "external comparison names an unsupported native proof system".into(),
        )),
    }
}
