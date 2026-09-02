use anyhow::Result;
use ergodis_private::q19_marked_polar::compile_q19_marked_polar;

pub fn run() -> Result<()> {
    let census = compile_q19_marked_polar()?;
    println!(
        "projective_members={} split_squarefree_members={} finite_only_members={} common_root_mask={:#x} availability_mask={:#x} marked_classes={}",
        census.projective_members,
        census.split_squarefree_members,
        census.finite_only_members,
        census.common_root_mask,
        census.availability_mask,
        census.marked_classes,
    );
    for roots in &census.split_root_masks {
        println!("split_roots={roots:#07x}");
    }
    Ok(())
}
