// C294 B3: cross-class-seeking live selector for the exact two-port quotient.
//
// The checked predecessor selects the smallest eligible separator side.  This
// bounded variant scans sides in the same validated envelope and selects a
// side when its transition class matches a previously selected, different
// exact piece class.  Its fallback is the complementary largest-side order.
#define C294_TWO_PORT_LIVE_SEEK_CROSS_CLASS
#define C294_TWO_PORT_LIVE_NO_MAIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "2026-07-17-c294-b3-two-port-live.cpp"
#pragma GCC diagnostic pop
#undef C294_TWO_PORT_LIVE_NO_MAIN
#undef C294_TWO_PORT_LIVE_SEEK_CROSS_CLASS

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-two-port-largest-live GAME_STATE_LIMIT "
                     "INTERFACE_STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t game_limit = std::strtoull(argv[1], nullptr, 10);
    size_t interface_limit = std::strtoull(argv[2], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    TwoPortLiveProbe solver(game_limit, interface_limit);
    solver.adjacency.resize(graph_size);
    solver.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    solver.initialize_transition();
    bool game_stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        game_stopped = true;
    }

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 4) {
        output_file.open(argv[3]);
        if (!output_file) return 2;
        output = &output_file;
    }
    const auto emit_occurrence = [&](const TwoPortLiveProbe::SeekerRepresentative &item) {
        *output << "{\"component\": ";
        emit_mask(*output, item.candidate.piece);
        *output << ", \"residual\": ";
        emit_mask(*output, item.residual);
        *output << ", \"separators\": [" << item.candidate.first_port << ", "
                << item.candidate.second_port << "]}";
    };
    *output << "{\n"
            << "  \"connected_states\": " << solver.connected_states << ",\n"
            << "  \"decompositions\": " << solver.decompositions << ",\n"
            << "  \"exact_top_state_hits\": " << solver.exact_top_state_hits << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"first_merger\": {\"current\": ";
    if (solver.has_first_seeker_cross_class()) {
        emit_occurrence(solver.first_seeker_current());
    } else {
        *output << "null";
    }
    *output << ", \"prior\": ";
    if (solver.has_first_seeker_cross_class()) {
        emit_occurrence(solver.first_seeker_prior());
    } else {
        *output << "null";
    }
    *output << "},\n"
            << "  \"follower_nimber\": " << value << ",\n"
            << "  \"game_state_limit\": " << game_limit << ",\n"
            << "  \"game_stopped_at_limit\": "
            << (game_stopped ? "true" : "false") << ",\n"
            << "  \"high_key_requests\": " << solver.high_key_requests << ",\n"
            << "  \"interface_classes\": " << solver.interface_classes() << ",\n"
            << "  \"interface_nodes\": " << solver.interface_nodes() << ",\n"
            << "  \"interface_state_limit\": " << interface_limit << ",\n"
            << "  \"interface_states\": " << solver.interface_states() << ",\n"
            << "  \"interface_stopped_at_limit\": "
            << (solver.interface_stopped() ? "true" : "false") << ",\n"
            << "  \"live_decomposition_requests\": " << solver.live_requests << ",\n"
            << "  \"live_new_absolute_key_hits\": "
            << solver.live_new_absolute_key_hits << ",\n"
            << "  \"low_key_requests\": " << solver.low_key_requests << ",\n"
            << "  \"maximum_requested_core_vertices\": "
            << solver.maximum_requested_core_vertices << ",\n"
            << "  \"maximum_requested_expanded_vertices\": "
            << solver.maximum_requested_expanded_vertices << ",\n"
            << "  \"nonisomorphic_interface_hits\": "
            << solver.nonisomorphic_interface_hits << ",\n"
            << "  \"quotient_cache_hits\": " << solver.quotient_cache_hits << ",\n"
            << "  \"quotient_classes\": " << solver.quotient_classes() << ",\n"
            << "  \"reusable_interface_hits\": "
            << solver.reusable_interface_hits << ",\n"
            << "  \"seeker_candidates\": " << solver.seeker_candidates << ",\n"
            << "  \"seeker_cross_class_selections\": "
            << solver.seeker_cross_class_selections << ",\n"
            << "  \"selector\": \"cross-class-seeker-with-largest-fallback\",\n"
            << "  \"type_index\": " << type_index << "\n"
            << "}\n";
}
