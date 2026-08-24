# CARAT check for the three quotients by primitive sign subtori of the
# type-I1 anticanonical quotient torus. Load RatProbAlgTori.gap first.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;
SetPrintFormattingStatus("*stdout*", false);

quotientGenerators := [
  [
    [[-1,1,0,0],[0,1,0,0],[0,1,-1,0],[0,-2,0,-1]],
    [[0,-1,0,0],[-1,0,0,0],[-1,-1,0,-1],[1,1,-1,0]]
  ],
  [
    [[-1,1,0,0],[0,1,0,0],[1,-1,0,-1],[-1,0,-1,0]],
    [[0,-1,0,0],[-1,0,0,0],[0,0,-1,0],[0,0,0,-1]]
  ],
  [
    [[-1,1,0,0],[0,1,0,0],[1,1,0,-1],[-1,2,-1,0]],
    [[0,-1,0,0],[-1,0,0,0],[-1,-1,0,1],[-1,-1,1,0]]
  ]
];;

maximalHereditaryIds := [
    [4,20,22,1], [4,30,13,1], [4,31,7,1], [4,32,21,1],
    [4,25,9,2], [4,13,6,4], [4,25,7,5], [4,24,3,4]
];;

HereditaryContainers := function(group)
    local hits, id, maximal, class, subgroup;
    hits := [];
    for id in maximalHereditaryIds do
        maximal := MatGroupZClass(id[1], id[2], id[3], id[4]);
        for class in ConjugacyClassesSubgroups(maximal) do
            subgroup := Representative(class);
            if Size(subgroup) = Size(group) and
               RepresentativeAction(GL(4,Integers), group, subgroup) <> fail then
                Add(hits, id);
                break;
            fi;
        od;
    od;
    return hits;
end;;

groups := List(quotientGenerators, generators -> Group(List(
    generators,
    matrix -> TransposedMat(Inverse(matrix))
)));;
caratIds := List(groups, CaratZClass);;
containers := List(groups, HereditaryContainers);;
if caratIds <> [[4,76,4], [4,76,4], [4,78,4]] then
    Error("unexpected quotient character CARAT IDs: ", caratIds);
fi;
if containers <> [
    [[4,31,7,1]], [[4,31,7,1]], [[4,20,22,1], [4,30,13,1]]
] then
    Error("unexpected hereditary containers: ", containers);
fi;

for index in [1..Length(groups)] do
    Print(
        "subtorus_quotient_", index,
        "_character_carat=", caratIds[index],
        " hereditary_container=", containers[index][1],
        "\n"
    );
od;
QUIT;
