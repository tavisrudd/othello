#[repr(transparent)]
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub(crate) struct MatrixId(pub(crate) u32);

const _: () = assert!(std::mem::size_of::<MatrixId>() == 4);
const _: () = assert!(std::mem::align_of::<MatrixId>() == 4);

#[repr(C)]
#[derive(Clone, Copy, Debug)]
struct MatrixRecord {
    offset: u32,
    len: u32,
    rows: u16,
    cols: u16,
    _reserved: u32,
}

const _: () = assert!(std::mem::size_of::<MatrixRecord>() == 16);
const _: () = assert!(std::mem::align_of::<MatrixRecord>() == 4);

#[derive(Clone, Copy, Debug)]
pub(crate) struct MatrixView<'a> {
    pub(crate) rows: usize,
    pub(crate) cols: usize,
    pub(crate) data: &'a [u8],
}

#[derive(Clone, Debug, Default)]
pub(crate) struct FlatMatrixArena {
    records: Vec<MatrixRecord>,
    bytes: Vec<u8>,
}

impl FlatMatrixArena {
    pub(crate) fn push(&mut self, rows: usize, cols: usize, data: &[u8]) -> MatrixId {
        assert_eq!(data.len(), rows * cols);
        let offset = u32::try_from(self.bytes.len()).expect("matrix byte arena exceeds u32");
        let len = u32::try_from(data.len()).expect("one arena matrix exceeds u32 bytes");
        let id = MatrixId(u32::try_from(self.records.len()).expect("matrix arena exceeds u32"));
        self.bytes.extend_from_slice(data);
        self.records.push(MatrixRecord {
            offset,
            len,
            rows: u16::try_from(rows).expect("arena matrix row count exceeds u16"),
            cols: u16::try_from(cols).expect("arena matrix column count exceeds u16"),
            _reserved: 0,
        });
        id
    }

    #[inline]
    pub(crate) fn get(&self, id: MatrixId) -> MatrixView<'_> {
        let record = self.records[id.0 as usize];
        let start = record.offset as usize;
        let end = start + record.len as usize;
        MatrixView {
            rows: record.rows as usize,
            cols: record.cols as usize,
            data: &self.bytes[start..end],
        }
    }
}
