use ergodis_private::q29_inventory_scope::{census_q29_inventory_scopes, Q29InventoryWorkspace};

fn main() {
    let mut workspace = Q29InventoryWorkspace::new();
    let census = census_q29_inventory_scopes(&mut workspace).expect("bounded census");
    println!(
        "sum_zero_magnitude_inventories={}",
        census.sum_zero_magnitude_inventories
    );
    println!(
        "sum_one_magnitude_inventories={}",
        census.sum_one_magnitude_inventories
    );
    println!(
        "sum_zero_energy_support_scopes={}",
        census.sum_zero_energy_support_scopes
    );
    println!(
        "sum_one_energy_support_scopes={}",
        census.sum_one_energy_support_scopes
    );
    println!(
        "feasible_ordered_odd_support_scopes={}",
        census.feasible_ordered_odd_support_scopes
    );
    println!(
        "all_energy_505_magnitude_quartets={}",
        census.all_energy_505_magnitude_quartets
    );
    println!(
        "support_3_4_4_2_magnitude_quartets={}",
        census.support_3_4_4_2_magnitude_quartets
    );
    println!(
        "seed_energy_support_scope_magnitude_quartets={}",
        census.seed_energy_support_scope_magnitude_quartets
    );
    println!(
        "exact_seed_inventory_quartets={}",
        census.exact_seed_inventory_quartets
    );
    println!("workspace_bytes={}", census.workspace_bytes);
    println!("provenance={}", census.provenance);
}
