# CARAT and hereditary-rationality check for the three level-four quotients.
# Load RatProbAlgTori.gap before reading this file.

if not IsBound(CaratZClass) then
    Error("load RatProbAlgTori.gap before this checker");
fi;

quotientGroups := [
    Group([
        [[1,0,0,0],[1,-1,0,0],[-1,0,-1,0],[-3,0,0,-1]],
        [[1,1,1,1],[0,1,2,0],[0,0,-1,0],[0,-2,-2,-1]]
    ]),
    Group([
        [[1,0,0,0],[-1,-1,0,0],[1,2,1,0],[-3,-2,-2,-1]],
        [[1,1,1,1],[0,-1,0,0],[0,0,-1,0],[0,0,0,-1]]
    ]),
    Group([
        [[1,0,0,0],[1,-1,0,0],[1,2,3,2],[-3,-2,-4,-3]],
        [[1,3,3,3],[0,3,2,2],[0,0,-1,0],[0,-4,-2,-3]]
    ])
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

caratIds := List(quotientGroups, CaratZClass);;
containers := List(quotientGroups, HereditaryContainers);;
if caratIds <> [[4,76,3], [4,76,3], [4,78,3]] then
    Error("unexpected CARAT IDs: ", caratIds);
fi;
if containers <> [
    [[4,32,21,1]], [[4,32,21,1]], [[4,20,22,1]]
] then
    Error("unexpected hereditary containers: ", containers);
fi;

for index in [1..3] do
    Print(
        "quotient_", index,
        "_carat=", caratIds[index],
        " container=", containers[index][1],
        "\n"
    );
od;
QUIT;
