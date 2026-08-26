/// Compact predecessor ID. `u32::MAX` denotes the root.
#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct WitnessId(pub u32);

const _: () = assert!(std::mem::size_of::<WitnessId>() == 4);
const _: () = assert!(std::mem::align_of::<WitnessId>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct WitnessNode {
    pub parent: WitnessId,
    pub coordinate: u32,
    pub inverse_scale: u8,
    pub _pad: [u8; 3],
    pub depth: u32,
}

const _: () = assert!(std::mem::size_of::<WitnessNode>() == 16);
const _: () = assert!(std::mem::align_of::<WitnessNode>() == 4);

#[derive(Debug, Default)]
pub struct WitnessArena {
    nodes: Vec<WitnessNode>,
}

impl WitnessArena {
    pub const ROOT: WitnessId = WitnessId(u32::MAX);

    pub fn push(&mut self, parent: WitnessId, coordinate: u32, inverse_scale: u8) -> WitnessId {
        let depth = if parent == Self::ROOT {
            1
        } else {
            self.nodes[parent.0 as usize].depth + 1
        };
        let id = WitnessId(u32::try_from(self.nodes.len()).expect("witness arena exceeds u32"));
        self.nodes.push(WitnessNode {
            parent,
            coordinate,
            inverse_scale,
            _pad: [0; 3],
            depth,
        });
        id
    }

    pub fn support(&self, mut id: WitnessId) -> Box<[u32]> {
        if id == Self::ROOT {
            return Box::new([]);
        }
        let depth = self.nodes[id.0 as usize].depth as usize;
        let mut result = Vec::with_capacity(depth);
        while id != Self::ROOT {
            let node = self.nodes[id.0 as usize];
            result.push(node.coordinate);
            id = node.parent;
        }
        result.reverse();
        result.into_boxed_slice()
    }
}
