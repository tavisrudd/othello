# Exact CARAT convention check for the C925 type-I1 rank-five torus.
# Load RatProbAlgTori.gap before reading this file.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;

rootGeneratorOne := [
    [-1, 0, 0, -1, -1],
    [1, 1, 1, 0, 2],
    [0, 0, -1, -1, -1],
    [0, 0, 0, 0, 1],
    [0, 0, 0, 1, 0]
];;
rootGeneratorTwo := [
    [0, -1, -1, 0, -1],
    [-1, 0, -1, 0, -1],
    [0, 0, 0, 0, 1],
    [0, 0, -1, -1, -1],
    [0, 0, 1, 0, 0]
];;

rootGroup := Group([rootGeneratorOne, rootGeneratorTwo]);;
characterGroup := Group(List(
    [rootGeneratorOne, rootGeneratorTwo],
    matrix -> TransposedMat(Inverse(matrix))
));;

rootId := CaratZClass(rootGroup);;
characterId := CaratZClass(characterGroup);;
if rootId <> [5, 232, 14] then
    Error("unexpected root-lattice CARAT ID: ", rootId);
fi;
if characterId <> [5, 232, 15] then
    Error("unexpected character-lattice CARAT ID: ", characterId);
fi;

Print("root_lattice_carat_id=", rootId, "\n");
Print("character_lattice_carat_id=", characterId, "\n");
QUIT;
