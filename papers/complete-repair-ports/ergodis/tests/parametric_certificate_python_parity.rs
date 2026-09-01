use std::io::{Cursor, Read};

use ergodis::{
    verify_parametric_certificate, ParametricCertificate, ParametricCompositionDag,
    ParametricCompositionNode, ParametricCover, ParametricFamily, ParametricVerificationLimits,
    PayloadDigest, PayloadDigestAlgorithm, PolynomialOp, PolynomialProgram,
};
use num_bigint::BigInt;
use serde::Deserialize;

#[derive(Deserialize)]
struct Fixture {
    schema: String,
    payload_hex: String,
    payload_sha256: String,
    family: FamilyFixture,
    cover: CoverFixture,
    expected: ExpectedFixture,
}

#[derive(Deserialize)]
struct FamilyFixture {
    name: String,
    modulus: u32,
    residue: u32,
    parameter_minimum: u64,
    class_node: u32,
    identity_roots: Vec<u32>,
    positive_roots: Vec<u32>,
    nodes: Vec<NodeFixture>,
}

#[derive(Deserialize)]
#[serde(tag = "op", rename_all = "lowercase")]
enum NodeFixture {
    Literal { coefficients: Vec<String> },
    Add { left: u32, right: u32 },
    Subtract { left: u32, right: u32 },
    Multiply { left: u32, right: u32 },
}

#[derive(Deserialize)]
struct CoverFixture {
    claim_minimum: u64,
    modulus: u32,
    exceptional_residues: Vec<u32>,
}

#[derive(Deserialize)]
struct ExpectedFixture {
    identity_coefficients: Vec<String>,
    family_count: u32,
    payload_count: u32,
    composition_nodes: u32,
}

fn decode_hex(encoded: &str) -> Vec<u8> {
    assert!(encoded.len().is_multiple_of(2));
    encoded
        .as_bytes()
        .chunks_exact(2)
        .map(|pair| {
            let high = (pair[0] as char).to_digit(16).unwrap();
            let low = (pair[1] as char).to_digit(16).unwrap();
            ((high << 4) | low) as u8
        })
        .collect()
}

fn polynomial_node(node: NodeFixture) -> PolynomialOp {
    match node {
        NodeFixture::Literal { coefficients } => PolynomialOp::Literal(
            coefficients
                .into_iter()
                .map(|coefficient| BigInt::parse_bytes(coefficient.as_bytes(), 10).unwrap())
                .collect::<Vec<_>>()
                .into_boxed_slice(),
        ),
        NodeFixture::Add { left, right } => PolynomialOp::Add { left, right },
        NodeFixture::Subtract { left, right } => PolynomialOp::Subtract { left, right },
        NodeFixture::Multiply { left, right } => PolynomialOp::Multiply { left, right },
    }
}

#[test]
fn independently_generated_parametric_fixture_verifies() {
    let fixture: Fixture =
        serde_json::from_str(include_str!("fixtures/parametric_certificate.json")).unwrap();
    assert_eq!(fixture.schema, "ergodis-parametric-certificate-v1");
    assert_eq!(fixture.expected.identity_coefficients, ["0"]);

    let payload = decode_hex(&fixture.payload_hex);
    let digest: [u8; 32] = decode_hex(&fixture.payload_sha256).try_into().unwrap();
    let family = ParametricFamily {
        name: fixture.family.name.into(),
        modulus: fixture.family.modulus,
        residue: fixture.family.residue,
        parameter_minimum: fixture.family.parameter_minimum,
        program: PolynomialProgram {
            nodes: fixture
                .family
                .nodes
                .into_iter()
                .map(polynomial_node)
                .collect::<Vec<_>>()
                .into_boxed_slice(),
            class_node: fixture.family.class_node,
            identity_roots: fixture.family.identity_roots.into_boxed_slice(),
            positive_roots: fixture.family.positive_roots.into_boxed_slice(),
        },
    };
    let certificate = ParametricCertificate {
        cover: ParametricCover {
            claim_minimum: fixture.cover.claim_minimum,
            modulus: fixture.cover.modulus,
            exceptional_residues: fixture.cover.exceptional_residues.into_boxed_slice(),
            families: vec![family].into_boxed_slice(),
        },
        payloads: vec![PayloadDigest {
            name: "independent-fixture".into(),
            algorithm: PayloadDigestAlgorithm::Sha256,
            byte_length: payload.len() as u64,
            digest,
        }]
        .into_boxed_slice(),
        composition: ParametricCompositionDag {
            nodes: vec![
                ParametricCompositionNode::Family { family: 0 },
                ParametricCompositionNode::FiniteCover {
                    premises: vec![0].into_boxed_slice(),
                },
                ParametricCompositionNode::Payload { payload: 0 },
                ParametricCompositionNode::All {
                    premises: vec![1, 2].into_boxed_slice(),
                },
            ]
            .into_boxed_slice(),
            root: 3,
        },
    };
    let mut cursor = Cursor::new(payload);
    let mut readers: [&mut dyn Read; 1] = [&mut cursor];
    let verified = verify_parametric_certificate(
        &certificate,
        ParametricVerificationLimits::default(),
        &mut readers,
    )
    .unwrap();
    assert_eq!(verified.claim_minimum, fixture.cover.claim_minimum);
    assert_eq!(verified.cover_modulus, fixture.cover.modulus);
    assert_eq!(verified.family_count, fixture.expected.family_count);
    assert_eq!(verified.payload_count, fixture.expected.payload_count);
    assert_eq!(
        verified.composition_nodes,
        fixture.expected.composition_nodes
    );
}
