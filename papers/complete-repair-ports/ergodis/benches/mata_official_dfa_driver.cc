// Official-corpus comparison driver for VeriFIT/MATA revision
// e8c9310e389b1e62ece7080956550f70ceeed777. This file is not part of the
// Cargo build; scripts/mata-official-ab.sh compiles it against that revision.
#include <mata/nfa/algorithms.hh>
#include <mata/nfa/builder.hh>
#include <mata/nfa/nfa.hh>
#include <mata/parser/inter-aut.hh>
#include <mata/parser/mintermization.hh>

#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <vector>

using mata::nfa::Nfa;

struct LoadedAutomaton {
    std::unique_ptr<mata::OnTheFlyAlphabet> alphabet;
    Nfa automaton;
};

static LoadedAutomaton load_automaton(const std::string& filename) {
    std::ifstream input{filename};
    if (!input) {
        throw std::runtime_error("cannot open input");
    }
    const mata::parser::Parsed parsed = mata::parser::parse_mf(input, true);
    if (parsed.size() != 1 || !parsed[0].type.starts_with("NFA")) {
        throw std::runtime_error("expected one NFA section");
    }
    std::vector<mata::IntermediateAut> intermediates = mata::IntermediateAut::parse_from_mf(parsed);
    auto alphabet = std::make_unique<mata::OnTheFlyAlphabet>();
    if (intermediates[0].alphabet_type == mata::IntermediateAut::AlphabetType::Bitvector) {
        mata::Mintermization mintermization;
        intermediates[0] = mintermization.mintermize(intermediates[0]);
    }
    Nfa automaton = mata::nfa::builder::construct(intermediates[0], alphabet.get());
    return LoadedAutomaton{std::move(alphabet), std::move(automaton)};
}

int main(int argc, char** argv) {
    if (argc < 2) {
        return 2;
    }
    const std::string mode{argv[1]};
    if (mode == "prepare") {
        if (argc != 4) {
            return 2;
        }
        LoadedAutomaton loaded = load_automaton(argv[2]);
        Nfa dfa = mata::nfa::determinize(loaded.automaton);
        dfa.trim();
        if (!dfa.is_deterministic() || dfa.initial.size() != 1
            || dfa.get_useful_states().count() != dfa.num_of_states()) {
            throw std::runtime_error("prepared automaton is not a trimmed DFA");
        }
        dfa.print_to_mata(argv[3], loaded.alphabet.get());
        std::cout << "prepared\t" << loaded.automaton.num_of_states() << '\t'
                  << loaded.automaton.delta.num_of_transitions()
                  << '\t' << dfa.num_of_states() << '\t' << dfa.delta.num_of_transitions() << '\n';
        return 0;
    }
    if (mode == "bench") {
        if (argc != 4) {
            return 2;
        }
        LoadedAutomaton loaded = load_automaton(argv[2]);
        Nfa& dfa = loaded.automaton;
        if (!dfa.is_deterministic() || dfa.initial.size() != 1
            || dfa.get_useful_states().count() != dfa.num_of_states()) {
            throw std::runtime_error("benchmark input is not a trimmed DFA");
        }
        const auto repetitions = std::stoull(argv[3]);
        std::size_t classes = 0;
        const auto start = std::chrono::steady_clock::now();
        for (std::uint64_t repetition = 0; repetition < repetitions; ++repetition) {
            auto output = mata::nfa::algorithms::minimize_hopcroft(dfa);
            classes = output.num_of_states();
            asm volatile("" : "+r"(classes) : : "memory");
        }
        const auto elapsed = std::chrono::steady_clock::now() - start;
        const auto nanoseconds =
            std::chrono::duration_cast<std::chrono::nanoseconds>(elapsed).count();
        std::cout << "mata\t" << dfa.num_of_states() << '\t' << dfa.delta.num_of_transitions()
                  << '\t' << repetitions << '\t' << nanoseconds / repetitions << '\t' << classes
                  << '\n';
        return 0;
    }
    return 2;
}
