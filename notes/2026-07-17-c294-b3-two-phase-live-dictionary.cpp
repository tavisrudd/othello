// C294 B3: compile the fixed recursive-separator partition into a live dictionary.
//
// Phase one reproduces the fixed-prefix congruence closure.  Its completed
// absolute keys are compiled to dense class IDs and one checked nimber per
// class.  Phase two restarts the exact recursion and consults that immutable
// dictionary before evaluating a connected state.  An exact (uncompressed)
// dictionary replay is run beside the compressed replay as a traversal-level
// cross-check.
#define C294_RECURSIVE_SEPARATOR_NORMAL_FORM_NO_MAIN
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "2026-07-17-c294-b3-recursive-separator-normal-form.cpp"
#pragma GCC diagnostic pop
#undef C294_RECURSIVE_SEPARATOR_NORMAL_FORM_NO_MAIN

struct LiveDictionary {
    std::unordered_map<std::vector<int>, size_t, VectorHash> class_by_absolute;
    std::vector<uint8_t> class_value;
};

class DictionaryCompiler : public RecursiveSeparatorProbe {
  public:
    using RecursiveSeparatorProbe::RecursiveSeparatorProbe;

    LiveDictionary compile(bool compress) {
        LiveDictionary result;
        std::unordered_map<size_t, size_t> dense_by_root;
        for (const auto &[absolute_key, entry] : quotient_cache_) {
            size_t dense;
            auto known = class_by_absolute_.find(absolute_key);
            if (known == class_by_absolute_.end()) {
                throw std::runtime_error("quotient key has no recorded class ID");
            }
            if (compress) {
                size_t closure_root = root(known->second);
                auto [where, inserted] = dense_by_root.emplace(
                    closure_root, result.class_value.size()
                );
                dense = where->second;
                if (inserted) result.class_value.push_back(entry.value);
            } else {
                dense = result.class_value.size();
                result.class_value.push_back(entry.value);
            }
            auto [where, inserted] = result.class_by_absolute.emplace(absolute_key, dense);
            if (!inserted) throw std::runtime_error("duplicate absolute dictionary key");
            (void)where;
            if (result.class_value[dense] != entry.value) {
                throw std::runtime_error("dictionary class contains unequal nimbers");
            }
        }
        if (compress && result.class_value.size() != normal_form_classes()) {
            throw std::runtime_error(
                "compiled dictionary class count mismatch: " +
                std::to_string(result.class_value.size()) + " != " +
                std::to_string(normal_form_classes())
            );
        }
        if (!compress && result.class_value.size() != quotient_classes()) {
            throw std::runtime_error("exact dictionary class count mismatch");
        }
        return result;
    }
};

class DictionaryReplayProbe : public SeparatorCensusProbe {
  public:
    DictionaryReplayProbe(size_t game_limit, const LiveDictionary &dictionary)
        : SeparatorCensusProbe(game_limit), dictionary_(dictionary),
          used_classes_(dictionary.class_value.size(), false) {}

    uint8_t nimber(Mask mask) {
        if (empty(mask)) return 0;
        std::vector<Mask> parts = components(mask);
        if (parts.size() != 1) {
            ++decompositions;
            uint8_t value = 0;
            for (Mask part : parts) value ^= nimber(part);
            return value;
        }

        int vertices = size(mask);
        int twice_edges = 0;
        int maximum_degree = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            int degree = size(adjacency[vertex] & mask);
            twice_edges += degree;
            maximum_degree = std::max(maximum_degree, degree);
        }
        int edges = twice_edges / 2;
        if (maximum_degree <= 2) {
            ++path_cycle_hits;
            if (edges == vertices - 1) return path_nimber_[vertices];
            if (edges == vertices && vertices >= 3) return cycle_nimber_[vertices];
            throw std::runtime_error("unexpected connected maximum-degree-two graph");
        }
        if (edges == vertices - 1) {
            std::string key = tree_key(mask);
            auto found = tree_cache_.find(key);
            if (found != tree_cache_.end()) {
                ++tree_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected(mask);
            tree_cache_.emplace(std::move(key), value);
            ++tree_shapes;
            return value;
        }
        if (edges == vertices) {
            std::string key = unicyclic_key(mask);
            auto found = unicyclic_cache_.find(key);
            if (found != unicyclic_cache_.end()) {
                ++unicyclic_cache_hits;
                return found->second;
            }
            uint8_t value = evaluate_connected(mask);
            unicyclic_cache_.emplace(std::move(key), value);
            ++unicyclic_shapes;
            return value;
        }

        int cyclomatic = edges - vertices + 1;
        std::vector<int> absolute_key;
        if (cyclomatic >= 2 && cyclomatic <= 4) {
            absolute_key = low_cyclomatic_keys(mask, cyclomatic).candidate;
            ++low_key_requests;
        } else {
            absolute_key = sparse_absolute_core_key(mask, cyclomatic);
            ++high_key_requests;
        }

        auto learned = dictionary_.class_by_absolute.find(absolute_key);
        if (learned != dictionary_.class_by_absolute.end()) {
            ++dictionary_hits;
            if (!used_classes_[learned->second]) {
                used_classes_[learned->second] = true;
                ++dictionary_classes_used;
            }
            return dictionary_.class_value[learned->second];
        }
        ++dictionary_misses;

        auto found = new_cache_.find(absolute_key);
        if (found != new_cache_.end()) {
            ++new_cache_hits;
            return found->second;
        }
        uint8_t value = evaluate_connected(mask);
        new_cache_.emplace(std::move(absolute_key), value);
        if (cyclomatic >= 2 && cyclomatic <= 4) ++low_cyclomatic_shapes;
        return value;
    }

    uint64_t dictionary_hits = 0;
    uint64_t dictionary_misses = 0;
    uint64_t dictionary_classes_used = 0;
    uint64_t new_cache_hits = 0;
    uint64_t low_key_requests = 0;
    uint64_t high_key_requests = 0;

  private:
    uint8_t evaluate_connected(Mask mask) {
        if (connected_states >= limit_) {
            limit_vertices = size(mask);
            throw LimitReached();
        }
        int twice_edges = 0;
        Mask scan = mask;
        while (!empty(scan)) {
            int vertex = pop_first(scan);
            twice_edges += size(adjacency[vertex] & mask);
        }
        int cyclomatic = twice_edges / 2 - size(mask) + 1;
        ++cyclomatic_states[std::min(cyclomatic, 16)];
        ++connected_states;
        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = nimber(and_not(mask, closed[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        if (~seen[0]) return static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        return static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
    }

    const LiveDictionary &dictionary_;
    std::vector<bool> used_classes_;
    std::unordered_map<std::vector<int>, uint8_t, VectorHash> new_cache_;
};

struct ReplayResult {
    int value = -1;
    bool stopped = false;
    DictionaryReplayProbe *solver = nullptr;
};

static ReplayResult run_replay(size_t game_limit,
                               const LiveDictionary &dictionary,
                               const std::vector<Mask> &adjacency,
                               const std::vector<Mask> &closed,
                               Mask root) {
    auto *solver = new DictionaryReplayProbe(game_limit, dictionary);
    solver->adjacency = adjacency;
    solver->closed = closed;
    ReplayResult result;
    result.solver = solver;
    try {
        result.value = solver->nimber(root);
    } catch (const LimitReached &) {
        result.stopped = true;
    }
    return result;
}

static void emit_replay(std::ostream &output, const ReplayResult &result) {
    const DictionaryReplayProbe &solver = *result.solver;
    output << "{\"connected_states\": " << solver.connected_states
           << ", \"decompositions\": " << solver.decompositions
           << ", \"dictionary_classes_used\": " << solver.dictionary_classes_used
           << ", \"dictionary_hits\": " << solver.dictionary_hits
           << ", \"dictionary_misses\": " << solver.dictionary_misses
           << ", \"follower_nimber\": " << result.value
           << ", \"high_key_requests\": " << solver.high_key_requests
           << ", \"limit_vertices\": " << solver.limit_vertices
           << ", \"low_key_requests\": " << solver.low_key_requests
           << ", \"new_cache_hits\": " << solver.new_cache_hits
           << ", \"stopped_at_limit\": " << (result.stopped ? "true" : "false")
           << "}";
}

static void require_same_traversal(const ReplayResult &exact,
                                   const ReplayResult &compressed) {
    const DictionaryReplayProbe &a = *exact.solver;
    const DictionaryReplayProbe &b = *compressed.solver;
    if (exact.value != compressed.value || exact.stopped != compressed.stopped ||
        a.connected_states != b.connected_states ||
        a.decompositions != b.decompositions ||
        a.dictionary_hits != b.dictionary_hits ||
        a.dictionary_misses != b.dictionary_misses ||
        a.new_cache_hits != b.new_cache_hits ||
        a.low_key_requests != b.low_key_requests ||
        a.high_key_requests != b.high_key_requests ||
        a.limit_vertices != b.limit_vertices) {
        throw std::runtime_error(
            "compressed and exact dictionaries produce different traversals"
        );
    }
}

int main(int argc, char **argv) {
    if (argc < 3 || argc > 4) {
        std::cerr << "usage: c294-b3-two-phase-live-dictionary "
                     "TRAIN_STATE_LIMIT REPLAY_STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t train_limit = std::strtoull(argv[1], nullptr, 10);
    size_t replay_limit = std::strtoull(argv[2], nullptr, 10);
    int field_order;
    int type_index;
    int graph_size;
    if (!(std::cin >> field_order >> type_index >> graph_size) ||
        graph_size < 0 || graph_size > 128) return 2;
    DictionaryCompiler trainer(train_limit, 1000000);
    trainer.adjacency.resize(graph_size);
    trainer.closed.resize(graph_size);
    for (int vertex = 0; vertex < graph_size; ++vertex) {
        std::cin >> trainer.adjacency[vertex].lo >> trainer.adjacency[vertex].hi;
        trainer.closed[vertex] = trainer.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    trainer.initialize_transition();
    bool train_stopped = false;
    int train_value = -1;
    try {
        train_value = trainer.nimber(root);
    } catch (const LimitReached &) {
        train_stopped = true;
    }

    LiveDictionary exact = trainer.compile(false);
    LiveDictionary compressed = trainer.compile(true);
    ReplayResult exact_replay = run_replay(
        replay_limit, exact, trainer.adjacency, trainer.closed, root
    );
    ReplayResult compressed_replay = run_replay(
        replay_limit, compressed, trainer.adjacency, trainer.closed, root
    );
    require_same_traversal(exact_replay, compressed_replay);

    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 4) {
        output_file.open(argv[3]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
            << "  \"compressed_dictionary_classes\": "
            << compressed.class_value.size() << ",\n"
            << "  \"dictionary_absolute_keys\": "
            << compressed.class_by_absolute.size() << ",\n"
            << "  \"exact_dictionary_classes\": " << exact.class_value.size() << ",\n"
            << "  \"exact_replay\": ";
    emit_replay(*output, exact_replay);
    *output << ",\n"
            << "  \"field_order\": " << field_order << ",\n"
            << "  \"normal_replay\": ";
    emit_replay(*output, compressed_replay);
    *output << ",\n"
            << "  \"replay_state_limit\": " << replay_limit << ",\n"
            << "  \"selector\": \"two-phase-fixed-prefix-live-dictionary\",\n"
            << "  \"train_connected_states\": " << trainer.connected_states << ",\n"
            << "  \"train_decompositions\": " << trainer.decompositions << ",\n"
            << "  \"train_follower_nimber\": " << train_value << ",\n"
            << "  \"train_high_key_requests\": " << trainer.high_key_requests << ",\n"
            << "  \"train_limit_vertices\": " << trainer.limit_vertices << ",\n"
            << "  \"train_low_key_requests\": " << trainer.low_key_requests << ",\n"
            << "  \"train_normal_form_classes\": "
            << trainer.normal_form_classes() << ",\n"
            << "  \"train_quotient_classes\": " << trainer.quotient_classes() << ",\n"
            << "  \"train_state_limit\": " << train_limit << ",\n"
            << "  \"train_stopped_at_limit\": "
            << (train_stopped ? "true" : "false") << ",\n"
            << "  \"train_value_conflicts\": " << trainer.value_conflicts << ",\n"
            << "  \"type_index\": " << type_index << "\n"
            << "}\n";
    delete exact_replay.solver;
    delete compressed_replay.solver;
}
